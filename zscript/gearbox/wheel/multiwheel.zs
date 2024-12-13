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

struct gb_MultiWheelModel
{
  Array<bool> isWeapon;
  Array<int>  data; // slot or weapon index
}

class gb_MultiWheel
{

  static
  void fill(gb_ViewModel viewModel, out gb_MultiWheelModel model)
  {
    uint nWeapons = viewModel.tags.size();
    int  lastSlot = -1;

    for (uint i = 0; i < nWeapons; ++i)
    {
      int  slot     = viewModel.slots[i];
      bool isSingle = isSingleWeaponInSlot(viewModel, nWeapons, slot);
      if (isSingle)
      {
        model.isWeapon.push(true);
        model.data.push(i);
      }
      else
      {
        if (slot != lastSlot)
        {
          lastSlot = slot;
          model.isWeapon.push(false);
          model.data.push(slot);
        }
      }
    }
  }

  static
  bool isSingleWeaponInSlot(gb_ViewModel viewModel, uint nWeapons, int slot)
  {
    int nWeaponsInSlot = 0;
    for (uint i = 0; i < nWeapons; ++i)
    {
      nWeaponsInSlot += (viewModel.slots[i] == slot);
      if (nWeaponsInSlot > 1) return false;
    }
    return true;
  }

} // class gb_MultiWheel
