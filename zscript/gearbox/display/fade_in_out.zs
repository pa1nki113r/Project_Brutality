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

class gb_FadeInOut
{

  static
  gb_FadeInOut from()
  {
    let result = new("gb_FadeInOut");
    result.mAlpha = 0.0;
    return result;
  }

  void fadeInOut(double step)
  {
    mAlpha = clamp(mAlpha + step, 0.0, 1.0);
  }

  double getAlpha() const
  {
    return mAlpha;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private double mAlpha;

}
