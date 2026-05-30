class PB_PDAUiBackdrop ui
{
	ui static void DrawFullScreen(double alpha)
	{
		if (alpha <= 0)
			return;
		int sw = Screen.GetWidth();
		int sh = Screen.GetHeight();
		Screen.Dim("Black", 0.50 * alpha, 0, 0, sw, sh);
		for (int ii = 0; ii < sh; ii += sh / 20)
			Screen.DrawLine(0, ii, sw, ii, "Cyan", int(255 * 0.5 * alpha));
		for (int iii = 0; iii < sw; iii += sw / 20)
			Screen.DrawLine(iii, 0, iii, sh, "Cyan", int(255 * 0.5 * alpha));
		for (int inc = 0; inc < sh; inc += 1)
			Screen.DrawLine(0, inc, sw, inc, "Cyan", int(255 * alpha * inc / sh));
		TextureID logo = TexMan.CheckForTexture("PDAUACICO", TexMan.Type_Any);
		if (logo.IsValid())
			Screen.DrawTexture(logo, true, 0, 0, DTA_Clean, true, DTA_Alpha, alpha);
	}
}
