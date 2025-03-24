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

class gb_WheelView
{

  static
  gb_WheelView from( gb_Options        options
                   , gb_MultiWheelMode multiWheelMode
                   , gb_TextureCache   textureCache
                   , gb_Screen         screen
                   , gb_FontSelector   fontSelector
                   )
  {
    let result = new("gb_WheelView");

    result.setAlpha(1.0);
    result.setBaseColor(0x2222CC);

    result.mScreen         = screen;
    result.mOptions        = options;
    result.mFontSelector   = fontSelector;
    result.mMultiWheelMode = multiWheelMode;
    result.mText           = gb_Text.from(textureCache, screen, fontSelector,options);
    result.mTextureCache   = textureCache;
    result.mIsRotating     = true;

    return result;
  }

  void setAlpha(double alpha)
  {
    mAlpha = alpha;
  }

  void setBaseColor(int color)
  {
    mBaseColor = color;
    mSelectedColor = addColor(mBaseColor,  0x44);
  }

  void setRotating(bool isRotating)
  {
    mIsRotating = isRotating;
  }
  

  void display( gb_ViewModel viewModel
              , gb_WheelControllerModel controllerModel
              , bool showPointer
              , int  innerIndex
              , int  outerIndex
              ) const
  {
    mScaleFactor = mScreen.getScaleFactor();
    mCenter      = mScreen.getWheelCenter();

    drawInnerWheel();

    uint nWeapons = viewModel.tags.size();
    if (nWeapons == 0) return;

    int screenHeight = mScreen.getScaledScreenHeight();
    int radius       = screenHeight * 5 / 32;
    int allowedWidth = int(screenHeight * 3 / 16 - MARGIN * 2 * mScaleFactor);

    uint nPlaces = 0;

    bool isSlotExpanded = false;
    bool isMultiWheelMode = mMultiWheelMode.isEngaged(viewModel);
    if (isMultiWheelMode)
    {
      gb_MultiWheelModel multiWheelModel;
      gb_MultiWheel.fill(viewModel, multiWheelModel);

      nPlaces = multiWheelModel.data.size();
      for (uint i = 0; i < nPlaces; ++i)
      {
        bool isWeapon = multiWheelModel.isWeapon[i];
        int  data     = multiWheelModel.data[i];

        if (isWeapon) displayWeapon(i, data, nPlaces, radius, allowedWidth, viewModel, mCenter);
        else          displaySlot  (i, data, nPlaces, radius);
      }

      drawHands(nPlaces, innerIndex, mCenter, 0);

      isSlotExpanded = (outerIndex != UNDEFINED_INDEX && !multiWheelModel.isWeapon[innerIndex]);
      if (isSlotExpanded)
      {
        int slot = multiWheelModel.data[innerIndex];
        drawOuterWeapons( innerIndex
                        , outerIndex
                        , nPlaces
                        , slot
                        , viewModel
                        , radius
                        , allowedWidth
                        , int(controllerModel.radius)
                        );
      }
    }
    else
    {
      isSlotExpanded = false;
      for (uint i = 0; i < nWeapons; ++i)
      {
        if (i == innerIndex) continue;
        displayWeapon(i, i, nWeapons, radius, allowedWidth, viewModel, mCenter);
      }

      nPlaces = nWeapons;
      if (innerIndex != -1)
      {
        displayWeapon(innerIndex, innerIndex, nPlaces, radius, allowedWidth, viewModel, mCenter);
      }
      drawHands(nPlaces, innerIndex, mCenter, 0);
    }

    if (showPointer)
    {
      drawPointer(controllerModel.angle, controllerModel.radius,isSlotExpanded);
    }

    if (mOptions.isShowingTags())
    {
      drawWeaponDescription(viewModel, innerIndex, nPlaces, isSlotExpanded);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void drawOuterWeapons( int  innerIndex
                       , int  outerIndex
                       , uint nPlaces
                       , int  slot
                       , gb_ViewModel viewModel
                       , int  radius
                       , int  allowedWidth
                       , int  controllerRadius
                       )
  {
    int     wheelRadius      = mScreen.getWheelRadius();
    double  angle            = itemAngle(nPlaces, innerIndex);
    vector2 outerWheelCenter = (sin(angle), -cos(angle)) * wheelRadius + mCenter;
    drawOuterWheel(outerWheelCenter.x, outerWheelCenter.y, -angle);

    uint nWeapons = viewModel.tags.size();

    uint start = 0;
    for (; start < nWeapons && viewModel.slots[start] != slot; ++start);
    uint end = start;
    for (; end < nWeapons && viewModel.slots[end] == slot; ++end);

    uint   nWeaponsInSlot = end - start;
    double startingAngle  = angle - 90 + (180.0 / nWeaponsInSlot / 2);

    uint place = 0;
    uint selectedPlace = 0;
    for (uint i = start; i < end; ++i, ++place)
    {
      if (i == viewModel.selectedIndex)
      {
        selectedPlace = place;
        continue;
      }

      displayWeapon( place
                   , i
                   , nWeaponsInSlot * 2
                   , radius
                   , allowedWidth
                   , viewModel
                   , outerWheelCenter
                   , startingAngle
                   );
    }

    // draw the selected thing last in case of icon overlapping
    displayWeapon( selectedPlace
                 , viewModel.selectedIndex
                 , nWeaponsInSlot * 2
                 , radius
                 , allowedWidth
                 , viewModel
                 , outerWheelCenter
                 , startingAngle
                 );

    int deadRadius = mScreen.getWheelDeadRadius();

    drawHands( nWeaponsInSlot * 2
             , outerIndex
             , outerWheelCenter
             , -startingAngle
             );
  }

  private
  void drawInnerWheel()
  {
    int wheelDiameter = mScreen.getWheelRadius() * 2;
	if(mOptions.isColoredEnabled())
	{
		Screen.drawTexture( mTextureCache.circle
						  , NO_ANIMATION
						  , mCenter.x
						  , mCenter.y
						  , DTA_FillColor    , mBaseColor
						  , DTA_AlphaChannel , true
						  , DTA_Alpha        , mAlpha
						  , DTA_CenterOffset , true
						  , DTA_DestWidth    , wheelDiameter
						  , DTA_DestHeight   , wheelDiameter
						  );
	}
	else
	{
		Screen.drawTexture( mTextureCache.circle
						  , NO_ANIMATION
						  , mCenter.x
						  , mCenter.y
						  , DTA_AlphaChannel , true
						  , DTA_Alpha        , mAlpha
						  , DTA_CenterOffset , true
						  , DTA_DestWidth    , wheelDiameter
						  , DTA_DestHeight   , wheelDiameter
						  );
	}
  }

  private
  void drawOuterWheel(double x, double y, double angle)
  {
    int wheelDiameter = mScreen.getWheelRadius() * 2;
	if(mOptions.isColoredEnabled())
	{
		Screen.drawTexture( mTextureCache.halfCircle
						  , NO_ANIMATION
						  , x
						  , y
						  , DTA_FillColor    , mBaseColor
						  , DTA_AlphaChannel , true
						  , DTA_Alpha        , mAlpha
						  , DTA_CenterOffset , true
						  , DTA_Rotate       , angle
						  , DTA_DestWidth    , wheelDiameter
						  , DTA_DestHeight   , wheelDiameter
						  );
	}
	else
	{
		Screen.drawTexture( mTextureCache.halfCircle
					  , NO_ANIMATION
					  , x
					  , y
					  , DTA_AlphaChannel , true
					  , DTA_Alpha        , mAlpha
					  , DTA_CenterOffset , true
					  , DTA_Rotate       , angle
					  , DTA_DestWidth    , wheelDiameter
					  , DTA_DestHeight   , wheelDiameter
					  );

	}
  }

  private
  void displayWeapon( uint place
                    , uint iconIndex
                    , uint nPlaces
                    , int  radius
                    , int  allowedWidth
                    , gb_ViewModel viewModel
                    , vector2 center
                    , double startingAngle = 0.0
                    ) const
  {
    // Code is adapted from GZDoom AltHud.DrawImageToBox.

    TextureID texture     = viewModel.icons[iconIndex];
    vector2   textureSize = TexMan.getScaledSize(texture) * 2 * mScaleFactor;

    if (texture.isValid())
    {
      textureSize.x *= viewModel.iconScaleXs[iconIndex];
      textureSize.y *= viewModel.iconScaleYs[iconIndex];
    }

    bool      isTall      = (textureSize.y * 1.2 > textureSize.x);

    double scale = isTall
      ? ((allowedWidth < textureSize.y) ? allowedWidth / textureSize.y : 1.0)
      : ((allowedWidth < textureSize.x) ? allowedWidth / textureSize.x : 1.0)
      ;

    double  angle = (startingAngle + itemAngle(nPlaces, place)) % 360;
    vector2 xy    = (sin(angle), -cos(angle)) * radius + center;
    int width  = int(textureSize.x * scale);
    int height = int(textureSize.y * scale);

    drawIcon(texture, xy, width, height, angle, isTall);
    drawAmmo(angle, center, viewModel, iconIndex);
  }

  private
  void drawIcon(TextureID texture, vector2 xy, int w, int h, double angle, bool isTall) const
  {
    bool flipX;
    double scaleY;

    if (mIsRotating)
    {
      flipX = (angle > 180);
      if (flipX) angle -= 180;
      angle = -angle + 90;

      if (isTall) angle += flipX ? 90 : -90;

      scaleY = 1.0;
    }
    else
    {
      flipX  = false;
      angle  = 0;
      scaleY = mOptions.isPreservingAspectRatio() ? 1.2 : 1.0;
    }

    if (!texture.isValid()) texture = mTextureCache.noIcon;

    Screen.drawTexture( texture
                      , NO_ANIMATION
                      , xy.x
                      , xy.y
                      , DTA_CenterOffset , true
                      , DTA_DestWidth    , w
                      , DTA_DestHeight   , h
                      , DTA_ScaleY       , scaleY
                      , DTA_Alpha        , mAlpha
                      , DTA_Rotate       , angle
                      , DTA_FlipX        , flipX
                      , DTA_KeepRatio, false
                      );
	
	return;	//no tint for you
    //if (!mOptions.getWheelTint()) return;

    Screen.drawTexture( texture
                      , NO_ANIMATION
                      , xy.x
                      , xy.y
                      , DTA_CenterOffset , true
                      , DTA_DestWidth    , w
                      , DTA_DestHeight   , h
                      , DTA_ScaleY       , scaleY
                      , DTA_Alpha        , mAlpha * 0.3
                      , DTA_FillColor    , mBaseColor
                      , DTA_Rotate       , angle
                      , DTA_FlipX        , flipX
                      );
					 
  }

  private
  void drawAmmoPip(double angle, double radius, vector2 center, bool colored)
  {
    vector2 xy   = (sin(angle), -cos(angle)) * radius + center;
    vector2 size = mTextureCache.ammoPipSize * mScaleFactor;

    if (colored)
    {
      Screen.drawTexture( mTextureCache.ammoPip
                        , NO_ANIMATION
                        , round(xy.x)
                        , round(xy.y)
                        , DTA_CenterOffset , true
                        , DTA_Alpha        , mAlpha
                        , DTA_DestWidth    , int(size.x)
                        , DTA_DestHeight   , int(size.y)
                        , DTA_FillColor    , FILLED_QUANTITY_COLOR
                        );
    }
    else
    {
      Screen.drawTexture( mTextureCache.ammoPip
                        , NO_ANIMATION
                        , round(xy.x)
                        , round(xy.y)
                        , DTA_CenterOffset , true
                        , DTA_Alpha        , mAlpha
                        , DTA_DestWidth    , int(size.x)
                        , DTA_DestHeight   , int(size.y)
                        );
    }
  }

  private static
  int, int makePipsNumbers(int items, int maxItems)
  {
    if (maxItems <= MAX_N_PIPS) return items, maxItems;

    int nColoredPips = int(ceil(MAX_N_PIPS * double(items) / maxItems));
    return nColoredPips, MAX_N_PIPS;
  }

  private
  void drawAmmo(double weaponAngle, vector2 center, gb_ViewModel viewModel, uint weaponIndex)
  {
    if (gb_Ammo.isValid(viewModel.quantity1[weaponIndex], viewModel.maxQuantity1[weaponIndex]))
    {
      int margin = int(10 * mScaleFactor);
      int radius = mScreen.getScaledScreenHeight() / 4 - margin;
      int nColoredPips, nTotalPips;
      [nColoredPips, nTotalPips] = makePipsNumbers( viewModel.quantity1   [weaponIndex]
                                                  , viewModel.maxQuantity1[weaponIndex]
                                                  );
      drawQuantityPips(radius, weaponAngle, center, nColoredPips, nTotalPips);
    }

    if (gb_Ammo.isValid(viewModel.quantity2[weaponIndex], viewModel.maxQuantity2[weaponIndex]))
    {
      int margin = int(20 * mScaleFactor);
      int radius = mScreen.getScaledScreenHeight() / 4 - margin;
      int nColoredPips, nTotalPips;
      [nColoredPips, nTotalPips] = makePipsNumbers( viewModel.quantity2   [weaponIndex]
                                                  , viewModel.maxQuantity2[weaponIndex]
                                                  );
      drawQuantityPips(radius, weaponAngle, center, nColoredPips, nTotalPips);
    }
  }

  void drawQuantityPips( double  radius
                       , double  centerAngle
                       , vector2 center
                       , int     nColoredPips
                       , int     nTotalPips
                       )
  {
    if (nTotalPips % 2 == 0)
    {
      int nTotalPipsHalved = nTotalPips / 2;

      for (int i = -nTotalPipsHalved + 1; i <= 0; ++i)
      {
        double angle = centerAngle - PIPS_GAP + i * PIPS_STEP;
        drawAmmoPip(angle, radius, center, nColoredPips > 0);
        --nColoredPips;
      }

      for (int i = 0; i < nTotalPipsHalved; ++i)
      {
        double angle = centerAngle + PIPS_GAP + i * PIPS_STEP;
        drawAmmoPip(angle, radius, center, nColoredPips > 0);
        --nColoredPips;
      }
    }
    else
    {
      double angleStart = centerAngle - (nTotalPips - 1) * PIPS_STEP / 2;
      for (int i = 0; i < nTotalPips; ++i)
      {
        double angle = angleStart + i * PIPS_STEP;
        drawAmmoPip(angle, radius, center, nColoredPips > 0);
        --nColoredPips;
      }
    }
  }

  private
  void displaySlot(uint place, int slot, uint nPlaces, int radius)
  {
    double  angle = itemAngle(nPlaces, place);
    vector2 pos   = (sin(angle), -cos(angle)) * radius + mCenter;
    Font    aFont = mFontSelector.getFont();

    gb_Text.draw(string.format("%d", slot), pos, aFont, mAlpha, true,font.CR_SAPPHIRE);
  }

  private static
  double itemAngle(uint nItems, uint index)
  {
    return 360.0 / nItems * index;
  }

  private
  void drawHands(uint nPlaces, uint selectedIndex, vector2 center, double startAngle)
  {
    if (nPlaces < 2) return;

    double  handsAngle           = startAngle - itemAngle(nPlaces, selectedIndex);
    double  sectorAngleHalfWidth = max(6, 360.0 / 2.0 / nPlaces - 2);
    double  scaleFactor          = mScreen.getScaleFactor();
    vector2 size                 = TexMan.getScaledSize(mTextureCache.hand) * scaleFactor;
	
	if(mOptions.isColoredEnabled())
	{
		Screen.drawTexture( mTextureCache.hand
						  , NO_ANIMATION
						  , center.x
						  , center.y
						  , DTA_KeepRatio     , true
						  , DTA_CenterOffset  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_Rotate        , handsAngle - sectorAngleHalfWidth
						  , DTA_FlipX         , true
						  , DTA_DestWidthF    , size.x
						  , DTA_DestHeightF   , size.y
						  , DTA_FillColor    , mSelectedColor//mBaseColor
						  );

		Screen.drawTexture( mTextureCache.hand
						  , NO_ANIMATION
						  , center.x
						  , center.y
						  , DTA_KeepRatio     , true
						  , DTA_CenterOffset  , true
						  , DTA_CenterOffset  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_Rotate        , handsAngle + sectorAngleHalfWidth
						  , DTA_DestWidthF    , size.x
						  , DTA_DestHeightF   , size.y
						  , DTA_FillColor    , mSelectedColor//mBaseColor
						  );
	}
	else
	{
		Screen.drawTexture( mTextureCache.hand
						  , NO_ANIMATION
						  , center.x
						  , center.y
						  , DTA_KeepRatio     , true
						  , DTA_CenterOffset  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_Rotate        , handsAngle - sectorAngleHalfWidth
						  , DTA_FlipX         , true
						  , DTA_DestWidthF    , size.x
						  , DTA_DestHeightF   , size.y
						  );

		Screen.drawTexture( mTextureCache.hand
						  , NO_ANIMATION
						  , center.x
						  , center.y
						  , DTA_KeepRatio     , true
						  , DTA_CenterOffset  , true
						  , DTA_CenterOffset  , true
						  , DTA_Alpha         , mAlpha
						  , DTA_Rotate        , handsAngle + sectorAngleHalfWidth
						  , DTA_DestWidthF    , size.x
						  , DTA_DestHeightF   , size.y
						  );
	}
	
  }

  private
  void drawWeaponDescription( gb_ViewModel viewModel
                            , int  innerIndex
                            , int  nPlaces
                            , bool isSlotExpanded
                            )
  {
    int    index       = viewModel.selectedIndex;
    string description = viewModel.tags[index];
    if (description.length() == 0) return;

    string ammo1 = gb_Ammo.isValid(viewModel.quantity1[index], viewModel.maxQuantity1[index])
      ? string.format("%d/%d", viewModel.quantity1[index], viewModel.maxQuantity1[index])
      : "";
    string ammo2 = gb_Ammo.isValid(viewModel.quantity2[index], viewModel.maxQuantity2[index])
      ? string.format("%d/%d", viewModel.quantity2[index], viewModel.maxQuantity2[index])
      : "";

    double  angle   = itemAngle(nPlaces, innerIndex);
    bool    isOnTop = isSlotExpanded && (90.0 < angle && angle < 270.0);
    vector2 pos     = mCenter;
    pos.y += mScreen.getWheelRadius() * (isOnTop ? -1 : 1);
	
    mText.drawBox(ammo1, description, ammo2, pos, !isOnTop, mBaseColor, mAlpha,font.CR_WHITE,true);
  }

  private
  void drawPointer(double angle, double radius,bool multi = false)
  {
    vector2 size = TexMan.getScaledSize(mTextureCache.pointer);
    size *= mScaleFactor * 2;
	radius = clamp(radius,0,size.y * (multi ? 6 : 4));	// 12:8
	vector2 pos = (sin(angle), -cos(angle)) * radius + mCenter;

    Screen.drawTexture( mTextureCache.pointer
                      , NO_ANIMATION
                      , pos.x
                      , pos.y
                      , DTA_CenterOffset , true
                      , DTA_Alpha        , mAlpha
                      , DTA_DestWidth    , int(size.x)
                      , DTA_DestHeight   , int(size.y)
					  //,DTA_LegacyRenderStyle, STYLE_ADD
					  , DTA_TranslationIndex, Translation.GetID('reddenwep') 
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

  const NO_ANIMATION = 0; // == false

  const MARGIN = 4;

  const UNDEFINED_INDEX = -1;

  const MAX_N_PIPS = 10;

  const PIPS_GAP  = 1.2;
  const PIPS_STEP = 1.5;

  const FILLED_QUANTITY_COLOR = 0x22DD22;

  private double  mAlpha;
  private color   mBaseColor;
  private vector2 mCenter;
  private color  mSelectedColor;

  private gb_Screen         mScreen;
  private gb_Options        mOptions;
  private gb_FontSelector   mFontSelector;
  private gb_MultiWheelMode mMultiWheelMode;

  private gb_Text mText;

  private bool mIsRotating;

// cache ///////////////////////////////////////////////////////////////////////////////////////////

  private gb_TextureCache mTextureCache;
  private double mScaleFactor;

} // class gb_WheelView
