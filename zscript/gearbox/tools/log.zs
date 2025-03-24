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

class gb_Log
{

  static
  void print(string s)
  {
    Console.printf("%s", StringTable.localize(s, false));
  }

  static
  void notice(string s)
  {
    Console.printf("[NOTICE] %s: %s", MOD_NAME, StringTable.localize(s, false));
  }

  static
  void error(string s)
  {
    Console.printf("[ERROR] %s: %s.", MOD_NAME, s);
  }

  static
  void log(string s)
  {
    Console.printf("[LOG] %s: %s.", MOD_NAME, s);
  }

  static
  void debug(string s)
  {
    if (DEBUG_ENABLED)
    {
      Console.printf("[DEBUG] %s: %s.", MOD_NAME, s);
    }
  }

  const DEBUG_ENABLED = 0; // == false

  const MOD_NAME = "Gearbox";

} // class gb_Log
