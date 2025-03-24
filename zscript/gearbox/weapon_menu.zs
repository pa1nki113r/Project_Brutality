/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2020-2021
 * Carrascado 2022
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

class gb_WeaponMenu
{

  static
  gb_WeaponMenu from(gb_WeaponData weaponData, gb_Options options)
  {
    let result = new("gb_WeaponMenu");

    result.mWeapons.move(weaponData.weapons);
    result.mSlots.move(weaponData.slots);
    result.mSelectedIndex = 0;
    result.mCacheTime     = 0;
    result.mOptions       = options;

    loadIconServices(result.mIconServices);
    loadHideServices(result.mHideServices);

    return result;
  }

  int getSelectedIndex() const
  {
    return mSelectedIndex;
  }

  bool setSelectedIndexFromView(gb_ViewModel viewModel, int index)
  {
    if (index == -1 || mSelectedIndex == viewModel.indices[index]) return false;

    mSelectedIndex = viewModel.indices[index];
    return true;
  }

  void setSelectedWeapon(class<Weapon> aClass)
  {
    if (aClass == NULL) return;

    uint index = getIndexOf(aClass);
    if (index != mWeapons.size()) mSelectedIndex = index;
  }

  ui
  bool selectNextWeapon()
  {
    mSelectedIndex = findNextWeapon();
    return mSelectedIndex != mWeapons.size();
  }

  ui
  bool selectPrevWeapon()
  {
    mSelectedIndex = findPrevWeapon();
    return mSelectedIndex != mWeapons.size();
  }

  bool selectSlot(int slot, bool selectFirstWeapon = false)
  {
    uint nWeapons = mWeapons.size();
    int direction = mOptions.isSlotCycleOrderReversed() ? -1 : 1;
    int startOffset = selectFirstWeapon ? 0 : (mSelectedIndex + direction);

    for (uint i = 0; i < nWeapons; ++i)
    {
      uint index = (startOffset + nWeapons + direction * i) % nWeapons;
      if (mSlots[index] == slot && isInInventory(index) && !isHidden(mWeapons[index].getClassName()))
      {
        mSelectedIndex = index;
        return true;
      }
    }

    return false;
  }

  bool isOneWeaponInSlot(int slot) const
  {
    uint nWeapons = mWeapons.size();
    int  nWeaponsInSlot = 0;
    for (uint i = 1; i < nWeapons; ++i)
    {
      uint index = (mSelectedIndex + nWeapons - i) % nWeapons;
      nWeaponsInSlot += (mSlots[index] == slot && isInInventory(index));
      if (nWeaponsInSlot > 1) return false;
    }
    if (nWeaponsInSlot == 0) return false;
    return true;
  }

  bool isInInventory(int index) const
  {
    return NULL != players[consolePlayer].mo.findInventory(mWeapons[index]);
  }

  string confirmSelection() const
  {
    if (mSelectedIndex >= uint(mWeapons.size())) return "";

    return getDefaultByType(mWeapons[mSelectedIndex]).getClassName();
  }

  ui
  void fill(out gb_ViewModel viewModel)
  {
    // every other tic.
    bool isCacheValid = (level.time <= mCacheTime + 1);
    if (!isCacheValid)
    {
      mCacheTime = level.time;
      mCachedViewModel.tags        .clear();
      mCachedViewModel.slots       .clear();
      mCachedViewModel.indices     .clear();
      mCachedViewModel.icons       .clear();
      mCachedViewModel.iconScaleXs .clear();
      mCachedViewModel.iconScaleYs .clear();
      mCachedViewModel.quantity1   .clear();
      mCachedViewModel.maxQuantity1.clear();
      mCachedViewModel.quantity2   .clear();
      mCachedViewModel.maxQuantity2.clear();

      fillDirect(mCachedViewModel);
    }

    copy(mCachedViewModel, viewModel);
  }

  void rotatePriority()
  {
    mSelectedIndex = rotatePriorityForIndex(mSelectedIndex);
  }

  uint rotatePriorityForIndex(int index)
  {
    bool isIndexFound;
    uint targetIndex;
    [isIndexFound, targetIndex] = findIndexOfNextWeaponWithSlot(index, mSlots[index]);

    if (!isIndexFound) return mSelectedIndex;

    rotate(index, targetIndex);
    return targetIndex;
  }

  void rotateSlot()
  {
    mSelectedIndex = rotateSlotForIndex(mSelectedIndex);
  }

  int rotateSlotForIndex(uint oldIndex)
  {
    uint nWeapons = mWeapons.size();
    if (nWeapons < 2) return oldIndex;

    int oldSlot = mSlots[oldIndex];
    int newSlot = getNextSlot(oldSlot);

    uint i = 0;
    for (int slot = 1;;)
    {
      while (i < nWeapons && mSlots[i] == slot) ++i;

      if (slot == newSlot)
      {
        mSlots[oldIndex] = newSlot;
        move(oldIndex, i);
        return (oldIndex < i) ? i - 1 : i;
      }

      slot = getNextSlot(slot);
      if (slot == 1) break;
    }

    return oldIndex;
  }

  bool isThereNoWeapons() const
  {
    bool isNothingFound = true;
    uint nWeapons = mWeapons.size();
    for (uint i = 0; i < nWeapons; ++i)
    {
      if (isInInventory(i) && !isHidden(mWeapons[i].getClassName())) return false;
    }
    return isNothingFound;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void rotate(uint oldIndex, uint newIndex)
  {
    if (oldIndex > newIndex) move(oldIndex, newIndex);
    else                     move(oldIndex, newIndex + 1);
  }

  private
  void move(uint oldIndex, uint newIndex)
  {
    if (oldIndex == newIndex) return;

    mWeapons.insert(newIndex, mWeapons[oldIndex]);
    mSlots  .insert(newIndex, mSlots  [oldIndex]);

    if (newIndex < oldIndex) ++oldIndex;

    mWeapons.delete(oldIndex);
    mSlots  .delete(oldIndex);
  }

  private
  bool, uint findIndexOfNextWeaponWithSlot(uint weaponIndex, int slot)
  {
    uint nWeapons = mWeapons.size();
    for (uint i = 1; i < nWeapons; ++i)
    {
      uint targetCandidateIndex = (weaponIndex + i) % nWeapons;
      if (mSlots[targetCandidateIndex] == slot)
      {
        return true, targetCandidateIndex;
      }
    }

    return false, 0;
  }

  private static
  int getNextSlot(int slot)
  {
    if (1 <= slot && slot <= 8) return slot + 1;

    switch (slot)
    {
    case 9:  return  0;
    case 0:  return 10;
    case 10: return 11;
    case 11: return  1;
    }

    Console.printf("Unexpected slot: %d.", slot);
    return 1;
  }

  private static ui
  void copy(gb_ViewModel source, out gb_ViewModel destination)
  {
    destination.selectedIndex = source.selectedIndex;

    destination.tags        .copy(source.tags);
    destination.slots       .copy(source.slots);
    destination.indices     .copy(source.indices);
    destination.icons       .copy(source.icons);
    destination.iconScaleXs .copy(source.iconScaleXs);
    destination.iconScaleYs .copy(source.iconScaleYs);
    destination.quantity1   .copy(source.quantity1);
    destination.maxQuantity1.copy(source.maxQuantity1);
    destination.quantity2   .copy(source.quantity2);
    destination.maxQuantity2.copy(source.maxQuantity2);
  }

  private ui
  void fillDirect(out gb_ViewModel viewModel)
  {
    uint nWeapons = mWeapons.size();
    for (uint i = 0; i < nWeapons; ++i)
    {
      let aWeapon = Weapon(players[consolePlayer].mo.findInventory(mWeapons[i]));

      if (aWeapon == NULL)
      {
        if (mOptions.isPositionLocked())
        {
          viewModel.tags        .push("");
          viewModel.slots       .push(mSlots[i]);
          viewModel.indices     .push(i);
          viewModel.icons       .push(texman.checkfortexture("TNT1A0"));//-1); 
          viewModel.iconScaleXs .push(-1);
          viewModel.iconScaleYs .push(-1);
          viewModel.quantity1   .push(-1);
          viewModel.maxQuantity1.push(-1);
          viewModel.quantity2   .push(-1);
          viewModel.maxQuantity2.push(-1);
        }
        continue;
      }

      if (isHidden(aWeapon.getClassName())) continue;

      if (mSelectedIndex == i) viewModel.selectedIndex = viewModel.tags.size();

      viewModel.tags.push(aWeapon.getTag());
      viewModel.slots.push(mSlots[i]);
      viewModel.indices.push(i);

      TextureID icon = getIconFor(aWeapon);

      // Workaround, casting TextureID to int may be unreliable.
      viewModel.icons.push(icon);//(int(icon));
      viewModel.iconScaleXs.push(aWeapon.scale.x);
      viewModel.iconScaleYs.push(aWeapon.scale.y);

      bool hasAmmo1 = aWeapon.ammo1;
      bool hasAmmo2 = aWeapon.ammo2 && aWeapon.ammo2 != aWeapon.ammo1;

      viewModel.   quantity1.push(hasAmmo1 ? aWeapon.ammo1.   amount : -1);
      viewModel.maxQuantity1.push(hasAmmo1 ? aWeapon.ammo1.maxAmount : -1);
      viewModel.   quantity2.push(hasAmmo2 ? aWeapon.ammo2.   amount : -1);
      viewModel.maxQuantity2.push(hasAmmo2 ? aWeapon.ammo2.maxAmount : -1);
    }
  }

  private play
  bool isHidden(string className) const
  {
    bool result = false;

    uint nServices = mHideServices.size();
    for (uint i = 0; i < nServices; ++i)
    {
      let service = mHideServices[i];
      string hideResponse = service.get(className);
      if (hideResponse.length() != 0)
      {
        bool isHidden = hideResponse.byteAt(0) - 48; // convert to bool from "0" or "1".
        result = isHidden;
      }
    }

    return result;
  }

  private ui
  TextureID getIconFor(Weapon aWeapon) const
  {
    TextureID icon = BaseStatusBar.getInventoryIcon(aWeapon, BaseStatusBar.DI_AltIconFirst);

    {
      uint nServices = mIconServices.size();
      string className = aWeapon.getClassName();
      for (uint i = 0; i < nServices; ++i)
      {
        let service = mIconServices[i];
        string iconResponse = service.uiGet(className);
        if (iconResponse.length() != 0)
        {
          TextureID iconFromService = TexMan.checkForTexture(iconResponse, TexMan.Type_Any);
          if (iconFromService.isValid()) icon = iconFromService;
        }
      }
    }

    return icon;
  }

  private play State getReadyState(Weapon w) const { return w.getReadyState(); }

  private ui uint findNextWeapon() const { return findWeapon( 1); }
  private ui uint findPrevWeapon() const { return findWeapon(-1); }

  /**
   * @param direction search direction from the selected weapon: 1 or -1.
   *
   * @returns a weapon in the direction. If there is only one weapon, return
   * it. If there are no weapons, return weapons number.
   */
  private ui
  uint findWeapon(int direction) const
  {
    uint nWeapons = mWeapons.size();
    // Note range: [1; nWeapons + 1) instead of [0; nWeapons).
    // This is because I want the current weapon to be found last.
    for (uint i = 1; i < nWeapons + 1; ++i)
    {
      uint index = (mSelectedIndex + i * direction + nWeapons) % nWeapons;
      if (isHidden(mWeapons[index].getClassName())) continue;
      if (isInInventory(index)) return index;
    }

    return nWeapons;
  }

  private
  uint getIndexOf(class<Weapon> aClass) const
  {
    uint nWeapons = mWeapons.size();
    for (uint i = 0; i < nWeapons; ++i)
    {
      if (mWeapons[i] == aClass) return i;
    }
    return nWeapons;
  }

  private static
  void loadIconServices(out Array<gb_Service> services)
  {
    loadServices("gb_IconService", services);
  }

  private static
  void loadHideServices(out Array<gb_Service> services)
  {
    loadServices("gb_HideService", services);
  }

  private static
  void loadServices(string serviceName, out Array<gb_Service> services)
  {
    let iterator = gb_ServiceIterator.find(serviceName);
    gb_Service aService;
    while (aService = iterator.next())
    {
      services.push(aService);
    }
  }

  private Array< class<Weapon> > mWeapons;
  private Array< int >           mSlots;
  private uint mSelectedIndex;

  private Array<gb_Service> mIconServices;
  private Array<gb_Service> mHideServices;

  private gb_ViewModel mCachedViewModel;
  private int          mCacheTime;

  private gb_Options mOptions;

} // class gb_WeaponMenu
