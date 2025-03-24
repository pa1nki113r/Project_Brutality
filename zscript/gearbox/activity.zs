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

/**
 * This class stores top-level Gearbox state. It can be either Weapons,
 * Inventory, or None.
 */
class gb_Activity
{

  static
  gb_Activity from()
  {
    let result = new("gb_Activity");
    result.mActivity = gb_Activity.None;
    return result;
  }

  bool isNone()      const { return mActivity == gb_Activity.None;      }
  bool isWeapons()   const { return mActivity == gb_Activity.Weapons;   }
  bool isInventory() const { return mActivity == gb_Activity.Inventory; }
  bool isSpecials()  const { return mActivity == gb_Activity.Specials;	}
  bool isEquipment() const { return mActivity == gb_Activity.Equipments; }
  
  int getActivity() const { return mActivity; }

  void toggleWeaponMenu()
  {
	switch (mActivity)
	{
		case gb_Activity.Inventory: case gb_Activity.Specials:
		case gb_activity.Equipments:
		case gb_Activity.None:    mActivity = gb_Activity.Weapons; break;
		case gb_Activity.Weapons: mActivity = gb_Activity.None;    break;
    }
  }

  void close()         { mActivity = gb_Activity.None; }
  void openWeapons()   { mActivity = gb_Activity.Weapons; }
  void openInventory() { mActivity = gb_Activity.Inventory; }
  void openSpecials()  { mActivity = gb_Activity.Specials; }
  void openEquipment() { mActivity = gb_Activity.Equipments; }
  
// private: ////////////////////////////////////////////////////////////////////////////////////////

  enum Activity
  {

    None,
    Weapons,
    Inventory,
	Specials,
	Equipments,
  }

  private int mActivity;

} // class gb_Activity
