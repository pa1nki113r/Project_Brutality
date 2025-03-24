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

class gb_InputProcessor
{

  static
  gb_Inputs process(InputEvent event)
  {
    if (event.type != InputEvent.Type_KeyDown) return InputNothing;

    int key = event.keyScan;
    if (isKeyForCommand(key, "weapNext"  )) return InputSelectNextWeapon;
    if (isKeyForCommand(key, "weapPrev"  )) return InputSelectPrevWeapon;
    if (isKeyForCommand(key, "+attack"   )) return InputConfirmSelection;
    if (isKeyForCommand(key, "+altAttack")) return InputClose;

    for (int i = 0; i <= 11; ++i)
    {
      if (isKeyForCommand(key, string.format("slot %d", i))) return i + InputSelectSlotBegin;
    }

    return InputNothing;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  bool isKeyForCommand(int key, string command)
  {
    Array<int> keys;
    bindings.getAllKeysForCommand(keys, command);
    uint nKeys = keys.size();
    for (uint i = 0; i < nKeys; ++i)
    {
      if (keys[i] == key) return true;
    }
    return false;
  }

} // class gb_InputProcessor
