// Minimal stubs so PB2022 PDA compiles without full achievement / XP / glory-kill systems.

class VUAS_AchievementData
{
	String achievementID;
	String title;
	String description;
	String category;
	int achievementType;
	int targetCount;
	int currentCount;
	bool isUnlocked;
	bool isHidden;
	int unlockTime;
	String unlockMap;
	Name targetClass;
	int trackingType;
	bool isCumulative;
	int minSkillLevel;
	int maxSkillLevel;
	String icon;
	bool cheatProtected;
	bool invalidated;
}

class VUAS_RenderSettings ui
{
	ui static String GetColorCode(int colorIndex)
	{
		return "";
	}
}

class VUAS_AchievementHandler : StaticEventHandler
{
	Array<VUAS_AchievementData> achievements;

	ui static VUAS_AchievementHandler GetHandler()
	{
		return VUAS_AchievementHandler(StaticEventHandler.Find("VUAS_AchievementHandler"));
	}

	ui static bool GetCVarBool(Name cvarName, PlayerInfo p, bool defaultValue)
	{
		if (!p)
			return defaultValue;
		let cv = CVar.GetCVar(cvarName, p);
		return cv ? cv.GetBool() : defaultValue;
	}

	ui static int GetCVarInt(Name cvarName, PlayerInfo p, int defaultValue)
	{
		if (!p)
			return defaultValue;
		let cv = CVar.GetCVar(cvarName, p);
		return cv ? cv.GetInt() : defaultValue;
	}
}

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

class PB_XPBank : Inventory {}
class PB_XPRank : Inventory {}
class PB_RewardSpin : Inventory {}
class PB_KatanaChoicePickSith : Inventory {}
class PB_KatanaChoicePickJedi : Inventory {}
class Melee_Attacks : Inventory {}
