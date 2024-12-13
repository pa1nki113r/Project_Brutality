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

class gb_BlockyView
{

  static
  gb_BlockyView from(gb_TextureCache textureCache, gb_Options options, gb_FontSelector fontSelector)
  {
    let result = new("gb_BlockyView");

    result.setAlpha(1.0);
    result.setScale(1);
    result.setBaseColor(0x2222CC);
    result.mTextureCache = textureCache;
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

  void setBaseColor(int color)
  {
    mBaseColor     = color;
    mSlotColor     = addColor(mBaseColor, -0x22);
    mSelectedColor = addColor(mBaseColor,  0x44);
    mAmmoBackColor = addColor(mBaseColor,  0x66);
  }

  void display(gb_ViewModel viewModel) const
  {
    int selectedIndex = viewModel.selectedIndex;
    if (selectedIndex >= viewModel.slots.size() || selectedIndex == -1) return;

    vector2 position = mOptions.getBlocksPosition();
    int maxWidth = getMaxWidth(getSlotsNumber(viewModel));
    int maxHeight = getMaxHeight(viewModel);
    int startX = int(min(BORDER + (mScreenWidth  - BORDER) * position.x, mScreenWidth - maxWidth));
    int startY = int(min(BORDER + (mScreenHeight - BORDER) * position.y, mScreenHeight - maxHeight));

    int lastDrawnSlot = 0;
    int slotX = startX;
    int inSlotIndex = 0;

    int selectedSlot = viewModel.slots[selectedIndex];

    Font aFont      = mFontSelector.getFont();
    int  fontHeight = aFont.getHeight();
    int  textY      = startY + SLOT_SIZE / 2 - fontHeight / 2;

    uint nWeapons = viewModel.tags.size();
    for (uint i = 0; i < nWeapons; ++i)
    {
      int slot = viewModel.slots[i];

      // slot number box
      if (slot != lastDrawnSlot)
      {
        drawAlphaTexture(mTextureCache.blockBox, slotX, startY, mSlotColor,mOptions.isColoredEnabled());

        string slotText = string.format("%d", slot);
        int    textX    = slotX + SLOT_SIZE / 2 - aFont.stringWidth(slotText) / 2;
		
		int col = (slot == selectedSlot) ? Font.CR_YELLOW : Font.CR_WHITE;
        drawText(aFont, col, textX, textY, slotText);

        lastDrawnSlot = slot;
      }

      if (slot == selectedSlot) // selected slot (big boxes)
      {
        bool isSelectedWeapon = (i == selectedIndex);
        int  weaponColor      = isSelectedWeapon ? mSelectedColor : mBaseColor;
        int  weaponY = startY + SLOT_SIZE + (SELECTED_WEAPON_HEIGHT + MARGIN) * inSlotIndex;

        // big box blockBigSel
        drawAlphaTexture(isSelectedWeapon ? mTextureCache.blockBigSel : mTextureCache.blockBig, 
		slotX, weaponY, weaponColor,mOptions.isColoredEnabled());

        // weapon
        {
          // code is adapted from GZDoom AltHud.DrawImageToBox.
          TextureID weaponTexture = viewModel.icons[i];
          let weaponSize = TexMan.getScaledSize(weaponTexture);
          weaponSize.x *= viewModel.iconScaleXs[i];
          weaponSize.y *= viewModel.iconScaleYs[i];
          if (mOptions.isPreservingAspectRatio()) weaponSize.y *= 1.2;

          int allowedWidth  = SELECTED_SLOT_WIDTH    - MARGIN * 2;
          int allowedHeight = SELECTED_WEAPON_HEIGHT - MARGIN * 2;

          double scaleHor = (allowedWidth  < weaponSize.x) ? allowedWidth  / weaponSize.x : 1.0;
          double scaleVer = (allowedHeight < weaponSize.y) ? allowedHeight / weaponSize.y : 1.0;
          double scale    = min(scaleHor, scaleVer);

          int weaponWidth  = int(round(weaponSize.x * scale));
          int weaponHeight = int(round(weaponSize.y * scale));

          drawWeapon( weaponTexture
                    , slotX + SELECTED_SLOT_WIDTH / 2
                    , weaponY + SELECTED_WEAPON_HEIGHT / 2
                    , weaponWidth
                    , weaponHeight
                    );
        }

        // corners
        if (isSelectedWeapon)
        {
          int lineEndX = slotX   + SELECTED_SLOT_WIDTH    - CORNER_SIZE;
          int lineEndY = weaponY + SELECTED_WEAPON_HEIGHT - CORNER_SIZE;
          TextureID cornerTexture = mTextureCache.corner;
          // top left, top right, bottom left, bottom right
		  if(mOptions.isColoredEnabled())	//the box is green already if not colored
		  {
			  drawFlippedTexture(cornerTexture, slotX,    weaponY,  NoHorizontalFlip, NoVerticalFlip);
			  drawFlippedTexture(cornerTexture, lineEndX, weaponY,    HorizontalFlip, NoVerticalFlip);
			  drawFlippedTexture(cornerTexture, slotX,    lineEndY, NoHorizontalFlip,   VerticalFlip);
			  drawFlippedTexture(cornerTexture, lineEndX, lineEndY,   HorizontalFlip,   VerticalFlip);
		  }
		}

        // quantity indicators
        TextureID ammoTexture = mTextureCache.ammoLine;
        int ammoY = weaponY;
        if (gb_Ammo.isValid(viewModel.quantity1[i], viewModel.maxQuantity1[i]))
        {
          drawAlphaTexture( ammoTexture
                          , slotX + MARGIN * 2
                          , ammoY
                          , EMPTY_AMMO_COLOR//mAmmoBackColor
                          );
          int ammoRatioWidth = ammoRatioWidthFor(viewModel.quantity1[i], viewModel.maxQuantity1[i]);
          drawAlphaWidthTexture( ammoTexture
                               , slotX + MARGIN * 2
                               , ammoY
                               , FILLED_AMMO_COLOR
                               , ammoRatioWidth
                               );
          ammoY += MARGIN + AMMO_HEIGHT;
        }
        if (gb_Ammo.isValid(viewModel.quantity2[i], viewModel.maxQuantity2[i]))
        {
          drawAlphaTexture( ammoTexture
                          , slotX + MARGIN * 2
                          , ammoY
                          , EMPTY_AMMO_COLOR//mAmmoBackColor
                          );
          int ammoRatioWidth = ammoRatioWidthFor(viewModel.quantity2[i], viewModel.maxQuantity2[i]);
          drawAlphaWidthTexture( ammoTexture
                               , slotX + MARGIN * 2
                               , ammoY
                               , FILLED_AMMO_COLOR
                               , ammoRatioWidth
                               );
        }

        if (mOptions.isShowingTags()) drawTag(viewModel.tags[i], aFont, slotX, weaponY);
      }
      else // not selected slot (small boxes)
      {
        int boxY = startY - MARGIN + (SLOT_SIZE + MARGIN) * (inSlotIndex + 1);
        drawAlphaTexture(mTextureCache.blockBox, slotX, boxY, mBaseColor,mOptions.isColoredEnabled());
      }

      if (i + 1 < nWeapons && viewModel.slots[i + 1] != slot)
      {
        slotX += ((slot == selectedSlot) ? SELECTED_SLOT_WIDTH : SLOT_SIZE) + MARGIN;
        inSlotIndex = 0;
      }
      else
      {
        ++inSlotIndex;
      }
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  int getSlotsNumber(gb_ViewModel viewModel)
  {
    uint nEntries = viewModel.slots.size();
    int nSlots = 0;
    int lastSlot = -1;
    for (uint i = 0; i < nEntries; ++i)
    {
      if (viewModel.slots[i] != lastSlot)
      {
        ++nSlots;
        lastSlot = viewModel.slots[i];
      }
    }
    return nSlots;
  }

  private static
  int getMaxWidth(int nSlots)
  {
    return (nSlots - 1) * (SLOT_SIZE + MARGIN) + SELECTED_SLOT_WIDTH + BORDER;
  }

  private static
  int getMaxHeight(gb_ViewModel viewModel)
  {
    uint nEntries = viewModel.slots.size();
    int lastSlot = -1;
    int itemsInSlot = 1;
    int maxItemsInSlot = -1;
    for (uint i = 0; i < nEntries; ++i)
    {
      if (viewModel.slots[i] == lastSlot)
      {
        ++itemsInSlot;
      }
      else
      {
        lastSlot = viewModel.slots[i];
        if (itemsInSlot > maxItemsInSlot) maxItemsInSlot = itemsInSlot;
        itemsInSlot = 1;
      }
    }
    if (itemsInSlot > maxItemsInSlot) maxItemsInSlot = itemsInSlot;

    return maxItemsInSlot * (SELECTED_WEAPON_HEIGHT + MARGIN) - MARGIN + BORDER + SLOT_SIZE;
  }

  private
  void drawTag(string tag, Font aFont, double startX, double startY)
  {
    // >_<
    //
    // Trying to put as much text into the the box as possible, while gracefully
    // (hopefully) handling when the whole tag cannot fit in the box.
    //
    // This code doesn't take the icon and quantity bars into account. Just print
    // semi-transparent text over them.

    if (tag.length() == 0) return;

    Array<string> words;
    tag.split(words, " ", Tok_SkipEmpty);

    // Start filling lines with words from bottom to top. If the word doesn't
    // fit into the line, it is pushed into the new top line.
    Array<string> lines;
    int nWords = words.size();
    lines.push(words[nWords - 1]);
    int spaceWidth = aFont.stringWidth(" ");
    int allowedStringWidth = SELECTED_SLOT_WIDTH - 2;
    for (int i = nWords - 2; i >= 0; --i)
    {
      uint newWidth = (aFont.stringWidth(lines[0]) + spaceWidth + aFont.stringWidth(words[i]));
      if (newWidth < allowedStringWidth)
      {
        lines[0] = words[i] .. " " .. lines[0];
      }
      else
      {
        lines.insert(0, words[i]);
      }
    }

    // If there are too many lines, put them on the third line and mark the it
    // with ellipsis.
    string ellipsis = aFont.getGlyphHeight(ELLIPSIS_CODE) ? "…" : "...";
    uint nLines = lines.size();
    if (nLines > 3)
    {
      for (uint i = 3; i < nLines; ++i)
      {
        lines[2].appendFormat(" %s", lines[i]);
      }
      lines[2] = lines[2] .. ellipsis;
    }

    // If a line is too long to fit in the box, replace the part that doesn't
    // fit with ellipsis.
    uint linesEnd = min(nLines, 3);
    int ellipsisWidth = aFont.stringWidth(ellipsis);
    for (uint i = 0; i < linesEnd; ++i)
    {
      if (aFont.stringWidth(lines[i]) <= allowedStringWidth) continue;

      while (aFont.stringWidth(lines[i]) + ellipsisWidth > allowedStringWidth)
      {
        lines[i].deleteLastCharacter();
      }
      lines[i] = lines[i] .. ellipsis;
    }

    // Finally, print lines.
    int lineHeight = aFont.getHeight();
    for (uint i = 0; i < linesEnd; ++i)
    {
      double y = startY + SELECTED_WEAPON_HEIGHT + (i - linesEnd) * lineHeight;
      drawText(aFont, Font.CR_WHITE, startX + 1, y, lines[i], 0.3);
    }
  }

  private static
  int ammoRatioWidthFor(int ammoCount, int ammoMax)
  {
    return int(round(float(ammoCount) / ammoMax * AMMO_WIDTH));
  }

  private
  void drawAlphaTexture(TextureID texture, int x, int y, int color, bool docolor = true) const
  {
	if(docolor)
	{
		Screen.drawTexture( texture
						  , NO_ANIMATION
						  , x
						  , y
						  , DTA_FillColor     , color
						  , DTA_AlphaChannel  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_VirtualWidth  , mScreenWidth
						  , DTA_VirtualHeight , mScreenHeight
						  , DTA_KeepRatio     , true
						  );
	}
	else
	{
		Screen.drawTexture( texture
						  , NO_ANIMATION
						  , x
						  , y
						  , DTA_AlphaChannel  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_VirtualWidth  , mScreenWidth
						  , DTA_VirtualHeight , mScreenHeight
						  , DTA_KeepRatio     , true
						  );

	}
  }

  private
  void drawAlphaWidthTexture(TextureID texture, int x, int y, int color, int width,bool docolor = true) const
  {
    if(docolor)
	{
		Screen.drawTexture( texture
						  , NO_ANIMATION
						  , x
						  , y
						  , DTA_FillColor     , color
						  , DTA_AlphaChannel  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_VirtualWidth  , mScreenWidth
						  , DTA_VirtualHeight , mScreenHeight
						  , DTA_KeepRatio     , true
						  , DTA_DestWidth     , width
						  );
	}
	else
	{
		Screen.drawTexture( texture
						  , NO_ANIMATION
						  , x
						  , y
						  , DTA_AlphaChannel  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_VirtualWidth  , mScreenWidth
						  , DTA_VirtualHeight , mScreenHeight
						  , DTA_KeepRatio     , true
						  , DTA_DestWidth     , width
						  );
	}
  }

  enum HorizontalFlipOptions
  {
    NoHorizontalFlip = 0,
    HorizontalFlip = 1,
  }

  enum VerticalFlipOptions
  {
    NoVerticalFlip = 0,
    VerticalFlip = 1,
  }

  private
  void drawFlippedTexture(TextureID texture, int x, int y, int horFlip, int verFlip) const
  {
		Screen.drawTexture( texture
						  , NO_ANIMATION
						  , x
						  , y
						  , DTA_Alpha         , mAlpha
						  , DTA_VirtualWidth  , mScreenWidth
						  , DTA_VirtualHeight , mScreenHeight
						  , DTA_KeepRatio     , true
						  , DTA_FlipX         , horFlip
						  , DTA_FlipY         , verFlip
						  , DTA_FillColor     , mSelectedColor
						  );
  }

  private
  void drawWeapon(TextureID texture, int x, int y, int w, int h) const
  {
    Screen.drawTexture( texture
                      , NO_ANIMATION
                      , x
                      , y
                      , DTA_CenterOffset  , true
                      , DTA_KeepRatio     , true
                      , DTA_DestWidth     , w
                      , DTA_DestHeight    , h
                      , DTA_Alpha         , mAlpha
                      , DTA_VirtualWidth  , mScreenWidth
                      , DTA_VirtualHeight , mScreenHeight
                      );
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
  color addColor(color base, int add)
  {
    uint newRed   = clamp(base.r + add, 0, 255);
    uint newGreen = clamp(base.g + add, 0, 255);
    uint newBlue  = clamp(base.b + add, 0, 255);

    if (  abs(int(newRed  ) - base.r) < abs(add)
       && abs(int(newGreen) - base.g) < abs(add)
       && abs(int(newBlue ) - base.b) < abs(add)
       )
    {
      return addColor(base, -add);
    }

    uint result   = (newRed << 16) + (newGreen << 8) + newBlue;
    return result;
  }

  private static
  double getScaleFactor()
  {
    return Screen.getHeight() / 1080.0;
  }

  const BORDER = 20;
  const MARGIN = 4;

  const SLOT_SIZE = 25;
  const SELECTED_SLOT_WIDTH = 100;
  const SELECTED_WEAPON_HEIGHT = SLOT_SIZE * 2 + MARGIN;

  const NO_ANIMATION = 0; // == false

  const CORNER_SIZE = 4;

  const AMMO_WIDTH = 40;
  const AMMO_HEIGHT = 6;

  const FILLED_AMMO_COLOR 	= 0x00F200;	//0x22DD22;
  const EMPTY_AMMO_COLOR 	= 0xE6010D;

  const ELLIPSIS_CODE = 8230;

  private double mAlpha;

  private int    mScreenWidth;
  private int    mScreenHeight;

  private color  mBaseColor;
  private color  mSlotColor;
  private color  mSelectedColor;
  private color  mAmmoBackColor;

  private gb_TextureCache mTextureCache;
  private gb_Options      mOptions;
  private gb_FontSelector mFontSelector;

} // class gb_BlockyView
