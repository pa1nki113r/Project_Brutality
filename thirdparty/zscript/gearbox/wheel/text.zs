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

/**
 * This class helps displaying text on screen.
 */
class gb_Text
{

  static
  gb_Text from(gb_TextureCache textureCache, gb_Screen screen, gb_FontSelector fontSelector, gb_Options options)
  {
    let result = new("gb_Text");
    result.mTextureCache = textureCache;
    result.mScreen       = screen;
    result.mFontSelector = fontSelector;
	result.mOptions		 = options;
    return result;
  }

  static
  void draw(string aString, vector2 pos, Font aFont, double alpha, bool isBig = false, int fontcol = font.CR_WHITE)
  {
    int textScale = isBig ? getBigTextScale() : getTextScale();

    pos.x -= aFont.stringWidth(aString) * textScale / 2;
    pos.y -= aFont.getHeight()          * textScale / 2;

    Screen.drawText( aFont
                   , fontcol //added to change the color for each specific call instead of just generally
                   , pos.x
                   , pos.y
                   , aString
                   , DTA_Alpha  , alpha
                   , DTA_ScaleX , textScale
                   , DTA_ScaleY , textScale
                   );
  }

  void drawBox( string  topText
              , string  middleText
              , string  bottomText
              , vector2 pos
              , bool    isPosTop   			// true: pos is the top of text box, false: bottom.
              , color   baseColor
              , double  alpha,
			  int fontcol = font.CR_WHITE,	//added to change the color for each specific call instead of just generally
              bool novertscale = false		//dont adjust the vertical scale of the box
			  )
  {
    double scaleFactor = mScreen.getScaleFactor();
    Font   aFont       = mFontSelector.getFont();
    int    textScale   = getTextScale();
    int    lineHeight  = aFont.getHeight() * textScale;
    int    margin      = int(10 * scaleFactor);
    int    height      = int((margin * 2 + lineHeight * 3) / scaleFactor);

    if (!isPosTop) pos.y -= height * scaleFactor;

    int topTextWidth    = aFont.stringWidth(topText);
    int middleTextWidth = aFont.stringWidth(middleText);
    int bottomTextWidth = aFont.stringWidth(bottomText);

    int width = max(int( ( max(middleTextWidth, max(topTextWidth, bottomTextWidth)) * textScale
                       + margin * 2
                       ) / scaleFactor
                   ), height * 2);
    vector2 size   = (width, height) * scaleFactor;
    vector2 center = pos + (0, size.y / 2);
	if(mOptions.isColoredEnabled())
	{
		if(novertscale)
		{
			Screen.drawTexture( mTextureCache.textBox
							  , NO_ANIMATION
							  , center.x
							  , center.y
							  , DTA_FillColor    , baseColor
							  , DTA_AlphaChannel , true
							  , DTA_CenterOffset , true
							  , DTA_Alpha        , alpha
							  , DTA_DestWidth    , int(size.x)
							  );
		}
		else
		{
			Screen.drawTexture( mTextureCache.textBox
							  , NO_ANIMATION
							  , center.x
							  , center.y
							  , DTA_FillColor    , baseColor
							  , DTA_AlphaChannel , true
							  , DTA_CenterOffset , true
							  , DTA_Alpha        , alpha
							  , DTA_DestWidth    , int(size.x)
							  , DTA_DestHeight   , int(size.y)	
							  );
		}
	}
	else
	{
		if(novertscale)
		{
			Screen.drawTexture( mTextureCache.textBox
							  , NO_ANIMATION
							  , center.x
							  , center.y
							  , DTA_AlphaChannel , true
							  , DTA_CenterOffset , true
							  , DTA_Alpha        , alpha
							  , DTA_DestWidth    , int(size.x)
							  );
		}
		else
		{
			Screen.drawTexture( mTextureCache.textBox
							  , NO_ANIMATION
							  , center.x
							  , center.y
							  , DTA_AlphaChannel , true
							  , DTA_CenterOffset , true
							  , DTA_Alpha        , alpha
							  , DTA_DestWidth    , int(size.x)
							  , DTA_DestHeight   , int(size.y)	
							  );
		}
	}
	
	
    vector2 line = (0, lineHeight);
    if (topText   .length() > 0) draw(topText   , center - line, aFont, alpha,fontcol:fontcol);
    if (middleText.length() > 0) draw(middleText, center       , aFont, alpha,fontcol:fontcol);
    if (bottomText.length() > 0) draw(bottomText, center + line, aFont, alpha,fontcol:fontcol);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  int getBigTextScale()
  {
    return getTextScale() * 2;
  }

  private static
  int getTextScale()
  {
    return max(Screen.getHeight() / 720, 1);
  }

  const NO_ANIMATION = 0; // == false

  private gb_TextureCache mTextureCache;
  private gb_Screen       mScreen;
  private gb_FontSelector mFontSelector;
  private gb_Options        mOptions;

} // class gb_Text
