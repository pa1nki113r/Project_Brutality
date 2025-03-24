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

class gb_Caption
{

  static
  gb_Caption from()
  {
    let result = new("gb_Caption");
    result.mActor = NULL;
    return result;
  }

  void setActor(Actor anActor)
  {
    mActor = anActor;
  }

  ui
  void show()
  {
    if (mActor == NULL) return;

    mActor.displayNameTag();
    mActor = NULL;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private Actor mActor;

} // class gb_Caption
