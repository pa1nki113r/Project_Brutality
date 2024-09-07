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

class gb_IconService : gb_Service
{

  override
  string uiGet(string className)
  {
    /*if (isSmoothDoom()) switch (Name(className))
    {
    case 'PerkFist'           : return "PUNGB0";
    case 'Z86Chainsaw'        : return "CSAWA0";
    case 'PerkShotgun'        : return "SHOTA0";
    case 'PerkSuperShotgun'   : return "SGN2A0";
    case 'Z86Chaingun'        : return "MGUNA0";
    case 'PerkRocketLauncher' : return "LAUNA0";
    case 'BloxPlasmaRifle'    : return "PLRLA0";
    case 'Z86BFG9000'         : return "BFG9A0";
    }*/

    switch (Name(className))
    {
    case 'Fist'           : return "SMFIST0";
    case 'Chainsaw'       : return "SMCSAW0";
    case 'Pistol'         : return "SMPISG0";
    case 'Shotgun'        : return "SMSHOT0";
    case 'SuperShotgun'   : return "SMSGN20";
    case 'Chaingun'       : return "SMMGUN0";
    case 'RocketLauncher' : return "SMLAUN0";
    case 'PlasmaRifle'    : return "SMPLAS0";
    case 'BFG9000'        : return "SMBFGG0";

    default: return IGNORE;
    }
  }

  const IGNORE = "";

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  bool isSmoothDoom()
  {
    string s1 = "SmoothFloatingSkull";
    class  c1 = s1;
    string s2 = "SmoothDoomImp";
    class  c2 = s2;
    return (c1 && c2);
  }

} // class gb_IconService1
