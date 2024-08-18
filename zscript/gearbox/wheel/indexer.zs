/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2020-2021
 *
 * This file is part of Gearbox.
 *
 * Gearbox is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Gearbox is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Gearbox.  If not, see <https://www.gnu.org/licenses/>.
 */

class gb_WheelIndexer
{

  static
  gb_WheelIndexer from(gb_MultiWheelMode multiWheelMode, gb_Screen screen)
  {
    let result = new("gb_WheelIndexer");
    result.mSelectedIndex  = UNDEFINED_INDEX;
    result.mLastSlotIndex  = UNDEFINED_INDEX;
    result.mInnerIndex     = UNDEFINED_INDEX;
    result.mOuterIndex     = UNDEFINED_INDEX;
    result.mMultiWheelMode = multiWheelMode;
    result.mScreen         = screen;
    return result;
  }

  int getSelectedIndex() const { return mSelectedIndex; }

  int getInnerIndex(int externalSelectedIndex, gb_ViewModel viewModel) const
  {
    if (areIndicesDefined()) return mInnerIndex;

    uint nWeapons = viewModel.tags.size();
    uint externalSelectedIndexInModel = UNDEFINED_INDEX;
    for (uint i = 0; i < nWeapons; ++i)
    {
      if (viewModel.indices[i] == externalSelectedIndex)
      {
        externalSelectedIndexInModel = i;
        break;
      }
    }

    if (!mMultiWheelMode.isEngaged(viewModel)) return externalSelectedIndexInModel;

    gb_MultiWheelModel multiWheelModel;
    gb_MultiWheel.fill(viewModel, multiWheelModel);

    uint nPlaces = multiWheelModel.data.size();
    for (uint i = 0; i < nPlaces; ++i)
    {
      if (multiWheelModel.isWeapon[i])
      {
        if (viewModel.indices[multiWheelModel.data[i]] == externalSelectedIndex) return i;
      }
      else
      {
        if (multiWheelModel.data[i] == viewModel.slots[externalSelectedIndexInModel]) return i;
      }
    }

    return UNDEFINED_INDEX;
  }

  int getOuterIndex(int externalSelectedIndex, gb_ViewModel viewModel) const
  {
    if (areIndicesDefined()) return mOuterIndex;

    if (!mMultiWheelMode.isEngaged(viewModel)) return UNDEFINED_INDEX;

    uint nWeapons = viewModel.tags.size();
    uint externalSelectedIndexInModel = UNDEFINED_INDEX;
    for (uint i = 0; i < nWeapons; ++i)
    {
      if (viewModel.indices[i] == externalSelectedIndex)
      {
        externalSelectedIndexInModel = i;
        break;
      }
    }

    int slot = viewModel.slots[externalSelectedIndexInModel];

    uint start = 0;
    for (; start < nWeapons && viewModel.slots[start] != slot; ++start);

    return externalSelectedIndexInModel - start;
  }

  void update(gb_ViewModel viewModel, gb_WheelControllerModel controllerModel)
  {
    if (controllerModel.radius < mScreen.getWheelDeadRadius())
    {
      mSelectedIndex = UNDEFINED_INDEX;
      mLastSlotIndex = UNDEFINED_INDEX;
      mInnerIndex    = UNDEFINED_INDEX;
      mOuterIndex    = UNDEFINED_INDEX;
      return;
    }

    uint nWeapons = viewModel.tags.size();

    if (!mMultiWheelMode.isEngaged(viewModel))
    {
      mSelectedIndex = gb_WheelInnerIndexer.getSelectedIndex(nWeapons, controllerModel, mScreen);
      mLastSlotIndex = UNDEFINED_INDEX;
      mInnerIndex    = mSelectedIndex;
      mOuterIndex    = UNDEFINED_INDEX;
      return;
    }

    gb_MultiWheelModel multiWheelModel;
    gb_MultiWheel.fill(viewModel, multiWheelModel);

    uint nPlaces = multiWheelModel.data.size();
    int wheelRadius = mScreen.getWheelRadius();

    if (controllerModel.radius < wheelRadius)
    {
      reportInnerIndex(nPlaces, controllerModel, multiWheelModel, viewModel);
      return;
    }

    if (mLastSlotIndex == UNDEFINED_INDEX || mLastSlotIndex >= multiWheelModel.data.size())
    {
      mSelectedIndex = UNDEFINED_INDEX;
      mInnerIndex    = UNDEFINED_INDEX;
      mOuterIndex    = UNDEFINED_INDEX;
      return;
    }

    int slot = multiWheelModel.data[mLastSlotIndex];

    uint start = 0;
    for (; start < nWeapons && viewModel.slots[start] != slot; ++start);
    uint end = start;
    for (; end < nWeapons && viewModel.slots[end] == slot; ++end);
    uint nWeaponsInSlot = end - start;

    double slotAngle = itemAngle(nPlaces, mLastSlotIndex);

    double r = controllerModel.radius;
    double w = wheelRadius;
    double forSlotAngle = slotAngle - controllerModel.angle;
    double side  = sqrt(r * r + w * w - 2 * r * w * cos(forSlotAngle));

    if (side < mScreen.getWheelDeadRadius())
    {
      reportInnerIndex(nPlaces, controllerModel, multiWheelModel, viewModel);
      return;
    }

    // due to computation precision, the value of ratio may be slightly out of range [-1, 1].
    double ratio = clamp(r / side * sin(forSlotAngle), -1.0, 1.0);
    double angle = -asin(ratio);

    // Limit angle on the borders of the second wheel:
    double borderRadius = wheelRadius / sin(90 - forSlotAngle);
    if (r < borderRadius)
    {
      angle = (angle > 0) ? 89.9999 : -89.9999;
    }

    angle += 90;
    angle %= 180;

    int indexInSlot = int((angle * nWeaponsInSlot / 180.0) % nWeaponsInSlot);

    mSelectedIndex = start + indexInSlot;
    mInnerIndex    = mLastSlotIndex;
    mOuterIndex    = indexInSlot;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void reportInnerIndex( uint nPlaces
                       , gb_WheelControllerModel controllerModel
                       , gb_MultiWheelModel      multiWheelModel
                       , gb_ViewModel            viewModel
                       )
  {
    int  innerIndex = gb_WheelInnerIndexer.getSelectedIndex(nPlaces, controllerModel, mScreen);
    bool isWeapon   = multiWheelModel.isWeapon[innerIndex];

    mSelectedIndex = isWeapon
      ? multiWheelModel.data[innerIndex]
      : firstInSlot(viewModel, multiWheelModel.data[innerIndex]);

    mLastSlotIndex = isWeapon ? UNDEFINED_INDEX : innerIndex;
    mInnerIndex    = innerIndex;
    mOuterIndex    = 0;
  }

  private static
  int firstInSlot(gb_ViewModel viewModel, int slot)
  {
    int nWeapons = viewModel.tags.size();
    for (int i = 0; i < nWeapons; ++i)
    {
      if (viewModel.slots[i] == slot) return i;
    }

    return UNDEFINED_INDEX;
  }

  private
  bool areIndicesDefined() const
  {
    return (mInnerIndex != UNDEFINED_INDEX);
  }

  private static
  double itemAngle(uint nItems, uint index)
  {
    return 360.0 / nItems * index;
  }

  const UNDEFINED_INDEX = -1;

  private int mSelectedIndex;

  private int mLastSlotIndex;
  private int mInnerIndex;
  private int mOuterIndex;

  private gb_MultiWheelMode mMultiWheelMode;
  private gb_Screen         mScreen;

} // class gb_WheelIndexer
