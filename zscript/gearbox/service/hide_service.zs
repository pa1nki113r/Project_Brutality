/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
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

class gb_HideService : gb_Service
{

  override
  string get(string className)
  {
    switch (Name(className))
    {
    // SWWM GZ: https://forum.zdoom.org/viewtopic.php?f=43&t=67687
    case 'DualExplodiumGun':
    {
      string explodiumGunClass = "ExplodiumGun";
      return (players[consolePlayer].mo.countInv(explodiumGunClass) > 1) ? SHOW : HIDE;
    }

    default: return IGNORE;
    }
  }

  const HIDE = "1";
  const SHOW = "0";
  const IGNORE = "";

} // class gb_HideService
