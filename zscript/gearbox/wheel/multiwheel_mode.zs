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

class gb_MultiWheelMode
{

  static
  gb_MultiWheelMode from(gb_Options options)
  {
    let result = new("gb_MultiWheelMode");
    result.mOptions = options;
    return result;
  }

  bool isEngaged(gb_ViewModel viewModel)
  {
    uint nWeapons = viewModel.tags.size();
    bool result   = (nWeapons > mOptions.getMultiWheelLimit());
    return result;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private gb_Options mOptions;

} // class gb_MultiWheelMode
