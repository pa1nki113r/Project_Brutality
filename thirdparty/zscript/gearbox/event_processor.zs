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

class gb_EventProcessor
{

  static
  int process(ConsoleEvent event, bool isSelectOnKeyUp)
  {
    if (event.name == "gb_toggle_weapon_menu") return InputToggleWeaponMenu;
    if (event.name == "gb_toggle_weapon_menu_up" && isSelectOnKeyUp) return InputConfirmSelection;

    if (event.name == "gb_toggle_inventory_menu") return InputToggleInventoryMenu;
    if (event.name == "gb_toggle_inventory_menu_up" && isSelectOnKeyUp) return InputConfirmSelection;
    if (event.name == "gb_rotate_weapon_priority") return InputRotateWeaponPriority;
    if (event.name == "gb_rotate_weapon_slot"    ) return InputRotateWeaponSlot;
	
	if (event.name == "pb_special_wheel")	return InputToggleSpecialMenu;
	if (event.name == "pb_special_wheel_up" && isSelectOnKeyUp) return InputConfirmSelection;
	if (event.name == "pb_equip_wheel") 	return InputToggleEquipMenu;
	if (event.name == "pb_equip_wheel_up" && isSelectOnKeyUp) return InputConfirmSelection;
	
    return InputNothing;
  }

} // class gb_EventProcessor
