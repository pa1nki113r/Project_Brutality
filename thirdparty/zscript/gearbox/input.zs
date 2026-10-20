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

enum gb_Inputs
{

  InputNothing,

  InputSelectNextWeapon,
  InputSelectPrevWeapon,
  InputConfirmSelection,
  InputToggleWeaponMenu,

  InputSelectSlotBegin,
  InputSelectSlotEnd = InputSelectSlotBegin + 11,
  InputClose,

  InputToggleInventoryMenu,
  InputConfirmInventorySelection,

  InputRotateWeaponPriority,
  InputRotateWeaponSlot,
  InputResetCustomOrder,
  
  InputToggleSpecialMenu,
  InputToggleEquipMenu,
} // enum gb_Inputs

class gb_Input
{

  static
  bool isSlot(gb_Inputs input)
  {
    return (InputSelectSlotBegin <= input && input <= InputSelectSlotEnd);
  }

  static
  int getSlot(gb_Inputs input)
  {
    return input - InputSelectSlotBegin;
  }

} // class gb_Input
