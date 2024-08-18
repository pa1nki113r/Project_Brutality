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

class gb_Level
{

  enum _ { NotInGame, Loading, JustLoaded, Loaded }

  static
  int getState()
  {
    // In the best case, the world is fully loaded on tick 0, but if player
    // weapons are configured via keyconf, they require a bit of network
    // communication, which finishes at tick 1.
    if (level.mapName ~== "titlemap") return gb_Level.NotInGame;
    if (level.mapTime == 0) return gb_Level.Loading;
    if (level.mapTime == 1) return gb_Level.JustLoaded;
    return gb_Level.Loaded;
  }

} // class gb_Level
