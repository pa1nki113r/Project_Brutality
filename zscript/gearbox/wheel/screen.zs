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
 * This class provides helper functions for screen position and sizes.
 */
class gb_Screen
{

  static
  gb_Screen from(gb_Options options)
  {
    let result = new("gb_Screen");
    result.mOptions = options;
    return result;
  }

  vector2 getWheelCenter() const
  {
    int screenWidth      = Screen.getWidth();
    int halfScreenHeight = Screen.getHeight() / 2;
    int centerPosition   = int((screenWidth / 2 - halfScreenHeight) * mOptions.getWheelPosition());
    return (screenWidth / 2 + centerPosition, halfScreenHeight);
  }

  int getWheelRadius() const
  {
    return getScaledScreenHeight() / 4;
  }

  int getWheelDeadRadius() const
  {
    return getScaledScreenHeight() / 16;
  }

  double getScaleFactor() const
  {
    return getScaledScreenHeight() / 1080.0;
  }

  int getScaledScreenHeight() const
  {
    return int(Screen.getHeight() * mOptions.getWheelScale());
  }

  int getScaledScreenWidth() const
  {
    return int(Screen.getWidth() * mOptions.getWheelScale());
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private gb_Options mOptions;

} // class gb_Screen
