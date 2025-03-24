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

class gb_FontSelector
{

  static
  gb_FontSelector from()
  {
    let result = new("gb_FontSelector");
    result.mFontString = gb_Cvar.from("gb_font");
    return result;
  }

  Font getFont()
  {
    Font newFont = Font.getFont(mFontString.getString());

    if (newFont == NULL && mOldFont != NULL)
    {
      Console.printf(StringTable.localize("$GB_BAD_FONT"), mFontString.getString());
    }

    mOldFont = newFont;

    if (newFont == NULL)
    {
      newFont = NewSmallFont;
    }

    return newFont;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////


  private gb_Cvar        mFontString;
  private transient Font mOldFont;
}
