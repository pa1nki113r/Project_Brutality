//===========================================================================
//
// Adapted from Nash's Tilt++ Menu cause making menus is a pain
// and I'll take whatever shortcut I can find to alleviate it
//
//===========================================================================

class OptionMenuItemZMoveOption : OptionMenuItemOption
{
	String mTooltip;

	OptionMenuItemZMoveOption Init(String label, String tooltip, Name command, Name values, CVar graycheck = null, int center = 0)
	{
		mTooltip = tooltip;
		Super.Init(label, command, values, graycheck, center);
		return self;
	}
}

class OptionMenuItemZMoveSlider : OptionMenuItemSlider
{
	String mTooltip;

	OptionMenuItemZMoveSlider Init(String label, String tooltip, Name command, double min, double max, double step, int showval = 1)
	{
		mTooltip = tooltip;
		Super.Init(label, command, min, max, step, showval);
		return self;
	}
}

//===========================================================================
//
//  Movement Menu
//
//===========================================================================

class ZMoveMenu : OptionMenu
{
	override void Drawer ()
	{
		Super.Drawer();

		String tt;

		if (mDesc.mSelectedItem > 0)
		{
			if (mDesc.mItems[mDesc.mSelectedItem] is "OptionMenuItemZMoveOption")
			{
				tt = StringTable.Localize(OptionMenuItemZMoveOption(mDesc.mItems[mDesc.mSelectedItem]).mTooltip);
			}

			if (mDesc.mItems[mDesc.mSelectedItem] is "OptionMenuItemZMoveSlider")
			{
				tt = StringTable.Localize(OptionMenuItemZMoveSlider(mDesc.mItems[mDesc.mSelectedItem]).mTooltip);
			}
		}

		if (tt.Length() > 0)
		{
			Screen.DrawText (SmallFont, OptionMenuSettings.mFontColorValue,
				(Screen.GetWidth() - SmallFont.StringWidth (tt) * CleanXfac_1) / 2,
				BigFont.GetHeight() * CleanYfac_1 * 2.5,
				tt,
				DTA_CleanNoMove_1, true);
		}
	}
}