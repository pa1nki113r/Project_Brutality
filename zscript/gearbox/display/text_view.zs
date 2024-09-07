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

class gb_TextView
{

  static
  gb_TextView from(gb_Options options, gb_FontSelector fontSelector)
  {
    let result = new("gb_TextView");

    result.setAlpha(1.0);
    result.setScale(1);
    result.mOptions      = options;
    result.mFontSelector = fontSelector;

    return result;
  }

  void setAlpha(double alpha)
  {
    mAlpha = alpha;
  }

  void setScale(int scale)
  {
    if (scale < 1) scale = 1;

    double scaleFactor = getScaleFactor();

    mScreenWidth  = int(Screen.getWidth()  / scale / scaleFactor);
    mScreenHeight = int(Screen.getHeight() / scale / scaleFactor);
  }

  void display(gb_ViewModel viewModel) const
  {
    uint nWeapons = viewModel.tags.size();
    if (nWeapons == 0) return;

    vector2 start = mOptions.getTextPosition();
    start.x *= mScreenWidth;
    start.y *= mScreenHeight;
    double x = start.x;
    double y = start.y;
    Font   aFont = mFontSelector.getFont();
    double lineHeight    = aFont.getHeight();
    int    usualColor    = mOptions.getTextUsualColor();
    int    selectedColor = mOptions.getTextSelectedColor();

    double maxX = 0;
    double maxY = 0;

    // dry run
    int maxSlotWidth = 0;
    for (uint i = 0; i < nWeapons; ++i)
    {
      string slotString = string.format("%d. ", viewModel.slots[i]);
      maxSlotWidth = max(maxSlotWidth, aFont.stringWidth(slotString));
    }
    for (uint i = 0; i < nWeapons; ++i)
    {
      string itemString = makeItemString(viewModel, i);
      maxX = max(maxX, maxSlotWidth + x + aFont.stringWidth(itemString));
      y += lineHeight;
      if (i + 1 < nWeapons && viewModel.slots[i] != viewModel.slots[i + 1]) y += lineHeight / 3;
    }
    maxY = y;

    if (maxX > mScreenWidth) x = max(0, mScreenWidth - (maxX - x));

    double yBoundary = mScreenHeight * mOptions.getTextPositionYMax();
    if (maxY > yBoundary && (maxY - lineHeight != start.y))
    {
      lineHeight *= (yBoundary - lineHeight - start.y) / (maxY - lineHeight - start.y);
    }

    y = start.y;

    // real run
    double selectedY = 0;
    for (uint i = 0; i < nWeapons; ++i)
    {
      if (i == viewModel.selectedIndex)
      {
        selectedY = y;
      }
      else
      {
        string slotString = string.format("%d. ", viewModel.slots[i]);
        drawText(aFont, usualColor, x, y, slotString, mAlpha);
      }
      y += lineHeight;
      if (i + 1 < nWeapons && viewModel.slots[i] != viewModel.slots[i + 1]) y += lineHeight / 3;
    }
    {
      string slotString = string.format("%d. ", viewModel.slots[viewModel.selectedIndex]);
      drawText(aFont, selectedColor, x, selectedY, slotString, mAlpha);
    }

    y = start.y;

    for (uint i = 0; i < nWeapons; ++i)
    {
      if (i != viewModel.selectedIndex)
      {
        string itemText  = makeItemString(viewModel, i);
        drawText(aFont, usualColor, x + maxSlotWidth, y, itemText, mAlpha);
      }
      y += lineHeight;
      if (i + 1 < nWeapons && viewModel.slots[i] != viewModel.slots[i + 1]) y += lineHeight / 3;
    }
    {
      string itemText  = makeItemString(viewModel, viewModel.selectedIndex);
      drawText(aFont, selectedColor, x + maxSlotWidth, selectedY, itemText, mAlpha);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  string makeItemString(gb_ViewModel viewModel, int i)
  {
      string result = viewModel.tags[i];

      bool isQuantity1Valid = gb_Ammo.isValid(viewModel.quantity1[i], viewModel.maxQuantity1[i]);
      bool isQuantity2Valid = gb_Ammo.isValid(viewModel.quantity2[i], viewModel.maxQuantity2[i]);

      if (isQuantity1Valid && isQuantity2Valid)
      {
        result.appendFormat(" (%d/%d, %d/%d)"
                           , viewModel.quantity1[i]
                           , viewModel.maxQuantity1[i]
                           , viewModel.quantity2[i]
                           , viewModel.maxQuantity2[i]
                           );
      }
      else if (isQuantity1Valid)
      {
        result.appendFormat(" (%d/%d)", viewModel.quantity1[i], viewModel.maxQuantity1[i]);
      }
      else if (isQuantity2Valid)
      {
        result.appendFormat(" (%d/%d)", viewModel.quantity2[i], viewModel.maxQuantity2[i]);
      }

      return result;
  }

  private
  void drawText(Font aFont, int color, double x, double y, string text, double alpha = 1.0) const
  {
    Screen.drawText( aFont
                   , color
                   , x
                   , y
                   , text
                   , DTA_Alpha         , mAlpha * alpha
                   , DTA_VirtualWidth  , mScreenWidth
                   , DTA_VirtualHeight , mScreenHeight
                   , DTA_KeepRatio     , true
                   );
  }

  private static
  double getScaleFactor()
  {
    return Screen.getHeight() / 1080.0;
  }

  private double mAlpha;
  private int    mScreenWidth;
  private int    mScreenHeight;

  private gb_Options      mOptions;
  private gb_FontSelector mFontSelector;

} // class gb_TextView
