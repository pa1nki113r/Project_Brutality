//Project Brutality FULLSCREEN HUD
//Converted from SBARINFO to ZScript by generic name guy

/*
Credits:

generic name guy
-Code

A_D_M_E_R_A_L
-Slanted Bars
-Mugshot code

Iamcarrotmaster
-Graphics

JMartinez2098
-Fixes

BlueShadow
-Bases for powerup timers and keycards

James Paddock
-Mementwo font

Severin Meyer
-Oxanium font

Lewisk3
-Messages base
*/

class PB_Hud_ZS : BaseStatusBar
{	
	//Oxanium by Severin Meyer
	//https://fonts.google.com/specimen/Oxanium
	HUDFont mDefaultFont;
	HUDFont mBoldFont;
	
	//Mementwo from JimmyFonts
	//https://forum.zdoom.org/viewtopic.php?t=33409
	HUDFont mLowResFont;

	DynamicValueInterpolator mHealthInterpolator;
	DynamicValueInterpolator mArmorInterpolator;
	DynamicValueInterpolator mAmmo1Interpolator;
	DynamicValueInterpolator mAmmo2Interpolator;
	DynamicValueInterpolator mAmmoLeftInterpolator;
	PB_DynamicDoubleInterpolator mSwayInterpolator;
	PB_DynamicDoubleInterpolator mPitchInterpolator;
	PB_DynamicDoubleInterpolator mFOffsetInterpolator;

	InventoryBarState invBar;

	//Sway and intro
	double mSway, mPitch, mOldZVel, mForwardOffset;
	double mOldAngles;
	double mOldPitch;
	double mFallOfs;

	int m32to0, m64to0;
	double m0to1Float;
	bool hasPutOnHelmet, hasCompletedHelmetSequence;
	bool deathFadeDone, playerWasDead;
	
	vector2 poll1, poll2, resultSway;

	//Hud variables
	string leftAmmoAmount, oldLeftAmmoAmount;
	bool hudDynamics, inPain;
	double dashIndAlpha, flashlightBatteryAlpha;
	int healthFontCol, keyamount, hudState, oldDashCharge, weaponBarAccent;
	double dashScale1, dashScale2;
	DEDashJump Dasher;
	
	Weapon oldWeapon;

	//CVars
	int16 hudXMargin, hudYMargin, playerMsgPrint;
	bool hudDynamicsCvar, showVisor, showVisorGlass, showLevelStats, lowresfont, curmaxammolist, hideunusedtypes, showList, customPBMugshot, showBloodDrops, showGlassCracks;
	float playerAlpha, playerBoxAlpha, messageSize, bloodDropsAlpha, glassCracksAlpha;

	bool centerNotify;
  
	
	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 540);
		
		mDefaultFont = HUDFont.Create("PBFONT");
		mBoldFont = HUDFont.Create("PBBOLD");
		mLowResFont = HUDFont.Create("LOWQFONT");

		//invbar = InventoryBarState.CreateNoBox(mBoldFont);
		
		mHealthInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		mArmorInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		
		mAmmo1Interpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		mAmmo2Interpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		mAmmoLeftInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		
		mSwayInterpolator = PB_DynamicDoubleInterpolator.Create(0, 0.30, 0, 32);
		mPitchInterpolator = PB_DynamicDoubleInterpolator.Create(0, 0.30, 0, 32);
		mFOffsetInterpolator = PB_DynamicDoubleInterpolator.Create(0, 0.5, 0, 64);

		InvBar = InventoryBarState.Create();
	}
	
	void GatherCvars()
	{
		hudDynamicsCvar = CVar.GetCvar("PB_HudDynamics", CPlayer).GetBool();

		hudDynamics = automapactive ? false : hudDynamicsCvar;

		hudXMargin = max(Cvar.GetCvar("pb_hudxmargin", CPlayer).GetInt(), -9);
		hudYMargin = max(CVar.GetCvar("pb_hudymargin", CPlayer).GetInt(), -9);
			
		showVisor = CVar.GetCvar("pb_showhudvisor", CPlayer).GetBool();
		showVisorGlass = CVar.GetCvar("pb_showhudvisorglass", CPlayer).GetBool();
	
		showLevelStats = CVar.GetCvar("pb_showlevelstats", CPlayer).GetBool();

		lowresfont = CVar.GetCvar("pb_uselowreshudfont", CPlayer).GetBool();
		
		showList = CVar.GetCvar("pb_showammolist", CPlayer).GetBool();
		curmaxammolist = CVar.GetCvar("pb_curmaxammolist", CPlayer).GetBool();
		hideunusedtypes = CVar.GetCvar("pb_hideunusedtypes", CPlayer).GetBool();

		playerAlpha = CVar.GetCvar("pb_hudalpha", CPlayer).GetFloat();

		playerBoxAlpha = CVar.GetCvar("pb_hudboxalpha", CPlayer).GetFloat();

		customPBMugshot = CVar.GetCvar("pb_newmugshot", CPlayer).GetBool();

		centerNotify = CVar.GetCVar("con_centernotify", CPlayer).GetBool();
		playerMsgPrint = CVar.GetCVar("msg").GetInt();
		messageSize = CVar.GetCVar("pb_messagesize", CPlayer).GetFloat();

		showBloodDrops = CVar.GetCVar("pb_showblooddrops", CPlayer).GetBool();
		showGlassCracks = CVar.GetCVar("pb_showglasscracks", CPlayer).GetBool();

		bloodDropsAlpha = CVar.GetCVar("pb_blooddropsalpha", CPlayer).GetFloat();
		glassCracksAlpha = CVar.GetCVar("pb_glasscracksalpha", CPlayer).GetFloat();
	}

	override void Draw(int state, double TicFrac)
	{
		Super.Draw(state, TicFrac);

		if(menuactive || consolestate == c_up) 
			GatherCvars();
		
		hudState = state;
		
		fractic = TicFrac;
		
		if(HudDynamics)
		{
			IntMSway = mSwayInterpolator.GetValue();
			IntMPitch = mPitchInterpolator.GetValue();
			IntMOfs = mFOffsetInterpolator.GetValue();
		}

		DrawBloodDrops();
		DrawGlassCracks();
		
		if(hudState != HUD_None)
		{
			BeginHUD();
			DrawFullScreenStuff();
		}
	}

	override void NewGame()
	{
		Super.NewGame();

		m32to0 = 64;
		m64to0 = 64;
		m0to1Float = 0;
		dashIndAlpha = 0;
		flashlightBatteryAlpha = 0;
		dashScale1 = 0;
		dashScale2 = 0;
		
		GatherCvars();
		
		mHealthInterpolator.Reset(0);
		mArmorInterpolator.Reset(0);
		mAmmo1Interpolator.Reset(0);
		mAmmo2Interpolator.Reset(0);
		mAmmoLeftInterpolator.Reset(0);
		mSwayInterpolator.Reset(0);
		mPitchInterpolator.Reset(0);
		mFOffsetInterpolator.Reset(0);
	}

	override void Tick()
	{
		Super.Tick();
		
		PBHUD_TickMessages();
		TickBloodDrops();
		TickGlassCracks();
		
		if(!CheckInventory("sae_extcam") && !HasCompletedHelmetSequence)
		{
			From32to0Slow();	
		}
		
		Dasher = DEDashJump(CPlayer.mo.FindInventory("DEDashJump"));
		if(Dasher)
		{
			//console.printf("%i %i", oldDashCharge, Dasher.DashCharge);
			if(oldDashCharge == 16 && Dasher.DashCharge == 17)
				dashScale1 = 0.2;
			if(oldDashCharge == 34 && Dasher.DashCharge == 35)
				dashScale2 = 0.2;
			
			if(dashScale1 > 0.0)
				dashScale1 -= 0.02;
	
			if(dashScale2 > 0.0)
				dashScale2 -= 0.02;
			oldDashCharge = Dasher.DashCharge;
		}

		if(CPlayer.Health <= 25)
		{
			inPain = true;
			healthFontCol = Font.CR_RED;
		}
		else
		{
			inPain = false;
			healthFontCol = Font.FindFontColor("HUDBLUEBAR");
		}

		dashIndAlpha -= 0.2;
		flashlightBatteryAlpha -= 0.2;

		if(hudDynamics && !automapactive)
			CalculateSway();
		
		Ammo Primary, Secondary;
		[Primary, Secondary] = GetCurrentAmmo();
	
		//console.printf("%s", CPlayer.ReadyWeapon.GetClassName());
		
		if(oldweapon && (oldWeapon != CPlayer.ReadyWeapon))
		{
			if(Primary)
				mAmmo1Interpolator.Reset(Primary.Amount); 
			
			if(Secondary) 
				mAmmo2Interpolator.Reset(Secondary.Amount);
				
			mAmmoLeftInterpolator.Reset(0);
		}

		if(m0to1Float > 0.99) {
			mHealthInterpolator.Update(CPlayer.Health);
			mArmorInterpolator.Update(GetAmount("BasicArmor"));
			mSwayInterpolator.Update(mSway);
			mPitchInterpolator.Update(mPitch);
			mFOffsetInterpolator.Update(mForwardOffset);
			
			if(Primary)
				mAmmo1Interpolator.Update(Primary.Amount); 
			
			if(Secondary)
				mAmmo2Interpolator.Update(Secondary.Amount); 
			
			if(leftAmmoAmount)
			{
				if(leftAmmoAmount != oldLeftAmmoAmount) 
					mAmmoLeftInterpolator.Reset(GetAmount(leftAmmoAmount));
			
				mAmmoLeftInterpolator.Update(GetAmount(leftAmmoAmount));
				
				oldLeftAmmoAmount = leftAmmoAmount;
			}
		}
		
		oldWeapon = CPlayer.ReadyWeapon;
	}

	void From32to0Slow() {
		if(m0to1Float < 1.00 && HasPutOnHelmet) {
			m0to1Float += 0.1;
		}
		if(m32to0 > 0) {
			m32to0 -= 4;
		}
		if(m64to0 > 0) {
			m64to0 -= 1;
		}
		if(m32to0 == 0) {
			HasPutOnHelmet = true;
		}
		if(m64to0 == 0) {
			HasCompletedHelmetSequence = true;
		}
	}
	
	void DeathSequence(bool Death) {
		if(death) {
			if(HasPutOnHelmet && m0to1Float > 0.0 && !DeathFadeDone)
			{
				m0to1Float *= (randompick(50, 100, 150) * 0.01);
				
				if(m0to1Float <= 0.0) 
				{
					DeathFadeDone = True;
				}
			}
		}
	  
		if(!death) {
			m0to1Float = 1.0;
			DeathFadeDone = False;
		}
	}
	
	void CalculateSway() {
		//Limit so it only counts when the player strafes.
		vector3 strafedir = (cos(CPlayer.mo.angle + 90), sin(CPlayer.mo.angle + 90), 0);
		double strafeSpeed = CPlayer.mo.vel dot strafedir;
		
		//Calculate offsets.
		double intSway = CPlayer.mo.angle - mOldAngles + Actor.Normalize180((strafeSpeed * 0.35));
		double intPitch = CPlayer.mo.pitch - mOldPitch - (CPlayer.mo.vel.z * 0.35);
		
		//The same concept as the comment above, but forwards.
		vector3 forwarddir = (cos(CPlayer.mo.angle + 180), sin(CPlayer.mo.angle + 180), 0);
		double forwardOffset = CPlayer.mo.vel dot forwarddir;

		//Detect if the player is on the ground and the old Z velocity is 8, if true, play the fall animation.
		bool onGround = CPlayer.mo.pos.Z <= CPlayer.mo.floorz;
		if(mOldZVel < -8 && onGround)
		{
			mFallOfs = clamp((mOldZVel * 0.50), 0, -9);
		}
		
		//Pointer to the PB player class.
		let PB_Player = PlayerPawnBase(CPlayer.mo);

		//Limit and add variables.
		if(PB_Player)
		{
			mSway = clamp(intSway + (PB_Player.XBob * 0.5) - CPlayer.mo.Roll, -8, 8);
			mPitch = clamp(intPitch + mFallOfs - (PB_Player.YBob * 0.5) + CPlayer.mo.Roll, -8, 8);
		}

		//Collect old information.
		mOldAngles = CPlayer.mo.angle;
		mOldPitch = CPlayer.mo.pitch;
		mOldZVel = CPlayer.mo.vel.z;

		//Calculate forward velocity.
		mForwardOffset = clamp((Actor.Normalize180(forwardOffset) * 0.35), -8, 8);
		mForwardOffset += (CPlayer.mo.player.fov - CPlayer.mo.player.DesiredFov) * 0.25;
		
		//Return the falling animation slowly.
		if(mFallOfs < 0.0) {
			mFallOfs += 0.5;
		}
	}

	double IntMSway;
	double IntMPitch;
	double IntMOfs;

	// [gng] pass the x and y parts of the vector to this function individually
	// you can't use the out keyword with vectors, so i had to improvise
	void SetSway(out double posX, out double posY, int flags, double parallax, double parallax2, bool applyDeadZone = true, bool applySpeedShift = true)
	{
		if(applyDeadZone) {
			switch(flags & DI_SCREEN_HMASK) {
				case DI_SCREEN_LEFT:
					posX += HUDXMargin; break;
				case DI_SCREEN_RIGHT:
					posX -= HUDXMargin; break;
				default: break;
			}
			switch(flags & DI_SCREEN_VMASK) {
				case DI_SCREEN_TOP:
					posY += HUDYMargin; break;
				case DI_SCREEN_BOTTOM:
					posY -= HUDYMargin; break;
				default: break;
			}
		}
		
		if(HudDynamics) {
			posX += IntMSway * Parallax;
			posY -= IntMPitch * Parallax;

			if(!applySpeedShift)
				return;

			switch(flags & DI_SCREEN_HMASK) {
				case DI_SCREEN_LEFT:
					posX += (IntMOfs * Parallax2); break;
				case DI_SCREEN_RIGHT:
					posX -= (IntMOfs * Parallax2); break;
				default: break;
			}

			switch(flags & DI_SCREEN_VMASK) {
				case DI_SCREEN_TOP:
					posY += (IntMOfs * Parallax2); break;
				case DI_SCREEN_BOTTOM:
					posY -= (IntMOfs * Parallax2); break;
				default: break;
			}
		}
	}

	void PBHud_DrawImage(String texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25, ERenderStyle style = STYLE_Translucent, Color col = 0xffffffff)
	{
		SetSway(pos.x, pos.y, flags, parallax, parallax2);

		DrawImage(texture, pos, flags, clamp(m0to1Float * Alpha, 0.0, Alpha), box, scale, style, col);
	}
	
	void PBHud_DrawImageManualAlpha(String texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25, ERenderStyle style = STYLE_Translucent, Color col = 0xffffffff)
	{
		SetSway(pos.x, pos.y, flags, parallax, parallax2, false);

		DrawImage(texture, pos, flags, Alpha, box, scale, style, col);
	}
	
	bool PBHud_FlagCheck(int flags, int flag)
	{
		return ( flags & flag ) == flag;
	}
	
	void PBHud_DrawString(HUDFont font, String string, Vector2 pos, int flags = 0, int translation = Font.CR_UNTRANSLATED, double Alpha = 1., int wrapwidth = -1, int linespacing = 4, Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
	{	   
		int fakeflags; //because my dumb ass didn't add screen alignment flags when i made this
		
		if ( !PBHud_FlagCheck(flags, DI_SCREEN_MANUAL_ALIGN) ) // don't need to do this if there are already alignment flags
		{
			if (pos.x < 0) 
				fakeflags |= DI_SCREEN_RIGHT;
			else 
				fakeflags |= DI_SCREEN_LEFT;

			if (pos.y < 0) 
				fakeflags |= DI_SCREEN_BOTTOM;
			else 
				fakeflags |= DI_SCREEN_TOP;
		}
		else
			fakeflags = flags;

		if(lowresfont && (font != mLowResFont)) {
			font = mLowResFont;
			scale *= 1.8;
			pos += (0, 2);
		}

		SetSway(pos.x, pos.y, fakeflags, parallax, parallax2);

		DrawString(font, string, pos, flags, translation, (m0to1Float * Alpha), wrapwidth, linespacing, scale);
	}

	void PBHUD_DrawSlantedBar(String ongfx, String offgfx, double curval, double maxval, vector2 position, int border, int vertical, int flags = 0, double alpha = 1.0)
	{
		for(int i=7;i>0;i--)
		{
			if(position.x < 0)
			{
				DrawBar(ongfx..i, offgfx, curval, maxval, position + (-6, 1), border, vertical, flags, alpha);
				position.x+=1;
			}
			else
			{
				DrawBar(ongfx..i, offgfx, curval, maxval, position + (6, 1), border, vertical, flags, alpha);
				position.x -= 1;
			}
			position.y-=2;
		}
	}
	
	void PBHud_DrawBar(String ongfx, String offgfx, double curval, double maxval, Vector2 pos, int border, int vertical, int flags = 0, double alpha = 1.0, double Parallax = 0.75, double Parallax2 = 0.25, bool slanted = true) 
	{
		SetSway(pos.x, pos.y, flags, parallax, parallax2);
		
		if(slanted)
			PBHUD_DrawSlantedBar(ongfx, offgfx, curval, maxval, pos, border, vertical, flags, (m0to1Float * Alpha));
		else
			DrawBar(ongfx, offgfx, curval, maxval, pos, border, vertical, flags, (m0to1Float * Alpha));
	}

	void PBHud_DrawTexture(TextureID texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
	{
		SetSway(pos.x, pos.y, flags, parallax, parallax2);

		DrawTexture(texture, pos, flags, (m0to1Float * Alpha), box, scale);
	}
	
	void PBHud_DrawSpecialMugshot()
	{
		int mugflags; 
		string mug;

		if(customPBMugshot)
		{
			mugflags = MugShot.ANIMATEDGODMODE | MugShot.XDEATHFACE | MugShot.CUSTOM;
				
			if(cplayer.mo.FindInventory("PowerInvisibility",true) || cplayer.mo.bSHADOW)
				mug = isInvulnerable() ? "SGI" : "SCI";
			else 
				mug = isInvulnerable() ? "SGD" : "SFC";
		}
		else 
		{ 
			mugflags = MugShot.STANDARD; 
			mug = "STF"; 
		}
			
		PBHud_DrawTexture(GetMugShot(5, mugflags, mug), (25, -65), DI_ITEM_OFFSETS | DI_SCREEN_LEFT_BOTTOM, scale: (1.25, 1.25));
	}
	
	////////////////////////////////////
	//	   RESERVE AMMO HUD		 //
	////////////////////////////////////
	
	static const String PB_AmmoTypes[] =
	{
		"AMMOIC2, PB_LowCalMag, Tan, Ammo",
		"AMMOIC3, PB_Shell, Orange, Ammo",
		"AMMOIC1, PB_HighCalMag, Yellow, Ammo",
		"AMMOIC4, PB_RocketAmmo, Red, Ammo",
		"AMMOIC5, PB_Cell, Purple, Ammo",
		"AMMOIC6, PB_Fuel, Orange, Ammo",
		"AMMOIC7, PB_DTech, DarkRed, Ammo",
		"ALISTGRN, PB_GrenadeAmmo, Green, Equipment",
		"ALISTSTN, PB_StunGrenadeAmmo, Cyan, Equipment",
		"ALISTREV, PB_QuickLauncherAmmo, LightBlue, Equipment",
		"ALISTMIN, PB_ProxMineAmmo, Purple, Equipment"
	};
	
	void PB_AmmoListDrawer(vector2 initialpos, int step = 12) 
	{		
		for (int i = 0; i < PB_AmmoTypes.Size(); i++)
		{
			Array<String> ammoTypeArray;
			PB_AmmoTypes[i].Split(ammoTypeArray, ", ");
			bool showthisone;
			
			if(hideunusedtypes)
			{
				for(let i = CPlayer.mo.inv; i != null; i = i.inv)
				{
					if(ammoTypeArray[3] == "Ammo")
					{
						let weap = weapon(i);
						if(weap && (ammoTypeArray[1] == weap.ammotype1 || ammoTypeArray[1] == weap.ammotype2))
							showthisone = true;
					}
					else if(ammoTypeArray[3] == "Equipment")
					{
						if(i.GetClassName() == ammoTypeArray[1])
							showthisone = true;
					}
				}
			}
			else
			{
				showthisone = true;
			}
			
			if(!showthisone)
				continue; 
			
			//console.printf("%s %s %s", ammoTypeArray[0], ammoTypeArray[1], ammoTypeArray[2]);
			PBHud_DrawImage(ammoTypeArray[0], initialpos + (-12, -20), DI_SCREEN_RIGHT_BOTTOM, 1, (14, 12));
			PBHud_DrawString(mBoldFont, curmaxammolist ? FormatNumber(GetAmount(ammoTypeArray[1])).."/"..FormatNumber(GetMaxAmount(ammoTypeArray[1])) : FormatNumber(GetAmount(ammoTypeArray[1])), initialpos + (-25, -33), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT, Font.FindFontColor(ammoTypeArray[2]), scale: (0.8, 0.8));
			initialpos.y -= step;
		}
	}

	////////////////////////////////////
	//		   AMMO HUD			 //
	////////////////////////////////////
	
	void DrawAmmoBar(string lowerBG, string upperBG, string barBorder, string currentBar, string reserveBar, string ammoIcon, int fontTranslation = 0)
	{
		if(CPlayer.ReadyWeapon)
		{
			int IntAmmo1 = mAmmo1Interpolator.GetValue();
			int IntAmmo2 = mAmmo2Interpolator.GetValue();
			
			Ammo Primary, Secondary;
			[Primary, Secondary] = GetCurrentAmmo();

			//Backgrounds
			PBHud_DrawImage(lowerBG, (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
			if(Secondary) { PBHud_DrawImage(upperBG, (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha); }
			//Bars
			if(Secondary) { PBHud_DrawBar(currentBar, "BGBARL", IntAmmo2, Secondary.MaxAmount, (-112, -51), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM); }
			PBHud_DrawBar(reserveBar, "BGBARL", IntAmmo1, Primary.MaxAmount, (-112, -30), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
			//Numbers
			if(Secondary) { PBHud_DrawString(mDefaultFont, Formatnumber(Secondary.Amount), (-207, -69), DI_TEXT_ALIGN_RIGHT, fontTranslation); }
			PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, fontTranslation);
			//Icon
			PBHud_DrawImage(ammoIcon, (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
		}
	}

	////////////////////////////////////
	//			KEY HUD			 //
	////////////////////////////////////
	
	static const String KeyExceptions[] =
	{
		"BlueCard",
		"RedCard",
		"YellowCard",
		"BlueSkull",
		"RedSkull",
		"YellowSkull"
	};
	
	virtual void DrawKeys(vector2 pos, int keycount = 10, int space = 21)
	{
		//From NC HUD
		textureid icon, iconskull, iconcard;
		vector2 size;
		bool scaleup;
		keyamount = 0;
		string keyactorname;

		for(let i = CPlayer.mo.inv; i != null; i = i.inv)
		{
			if(i is "Key")
			{
				//Draw up to defined keycount.
				if(keyamount == keycount)
				{
					break;
				}

				icon = i.AltHUDIcon;
				keyactorname = i.GetClassName();

				if(!icon.isValid())
				{
					if(i.SpawnState && i.SpawnState.sprite != 0)
					{
						icon = i.SpawnState.GetSpriteTexture(0);
					}
					else
					{
						icon = i.icon;
					}

					if(!icon.isValid())
					{
						continue;
					}
				}
				
			  	for (int i = 0; i < KeyExceptions.Size(); i++)
				{
					if(keyactorname == KeyExceptions[i])
					{
						icon = texman.checkfortexture("TNT1A0");
					}
				}
		  
				//Exclude keys which use TNT1 A 0 as their icon
				if(TexMan.GetName(icon) == "TNT1A0")
				{
					continue;
				}
				
				//Scale the icon up if needed
				size = TexMan.GetScaledSize(icon);
				scaleup = (size.x <= 11 && size.y <= 11);
				PBHud_DrawTexture(icon, pos, DI_SCREEN_RIGHT_TOP | DI_ITEM_CENTER, box: (20, 20), scaleup? (2, 2) : (1, 1));
				pos.x -= space;
				keyamount++;
			}
		}
	}
	
	override void DrawPowerups() {} //blank this out so it doesn't cause issues
	
	string FormatPowerupTime(Powerup item)
	{
		int sec = 1 + Thinker.Tics2Seconds(item.EffectTics);
		return String.Format("%02d:%02d", (sec % 3600) / 60, sec % 60);
	}
	
	void PB_DrawPowerups(vector2 initialpos, int step = 22) 
	{
		string image;
		string powerTime;
		name powerName;
		bool invalidPower;
		int fontCol;
		
		for(let i = CPlayer.mo.inv; i != null; i = i.inv)
		{
			let power = Powerup(i);
			
			if(power)
			{
				powername = i.GetClassName();
				powertime = FormatPowerupTime(power);
				
				switch(powername)
				{
					case 'PB_PowerInvul':
						image = "PWRINVUL";
						break;
					case 'PB_PowerIronFeet':
						image = "PWRRADSU";
						break;
					case 'PB_PowerInvis':
						image = "PWRINVIS";
						break;
					case 'PB_PowerLightAmp':
						image = "PWRINFRA";
						break;
					case 'PB_PowerDoomDamage':
						image = "PWRQUADD";
						break;
					case 'PB_PowerSpeed':
						image = "PWRHASTE";
						break;
					Default:
						image = "TNT1A0";
						break;
				}
				
				if(TexMan.GetName(Texman.CheckForTexture(image)) == "TNT1A0")
				{
					continue;
				}
				
				fontCol = Font.FindFontColor(powername);
				PBHud_DrawImage(image, initialpos, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
				PBHud_DrawString(mBoldFont, powertime, (initialpos.x + 28, initialpos.y - 20), DI_SCREEN_LEFT_BOTTOM | DI_TEXT_ALIGN_LEFT, fontcol);
				initialpos.y -= step;
			}
		}
	}
	
	////////////////////////////////////
	//		   HUD LOGIC			//
	////////////////////////////////////
	
	void DrawFullScreenStuff()
	{
		let plr = PlayerPawn(CPlayer.mo);
		
		if(plr) {
			////////////////////////////////////
			//		  HEALTH HUD			//
			////////////////////////////////////
			
			//Get player stats (health, armor)
			int Health = CPlayer.Health;
			double IntMSway = mSwayInterpolator.GetValue();
			double IntMPitch = mPitchInterpolator.GetValue();
			double IntMOfs = mFOffsetInterpolator.GetValue();
			int IntHealth = mHealthInterpolator.GetValue();
			int MaxHealth = CPlayer.mo.GetMaxHealth();

			int Armor = GetAmount("BasicArmor");
			int IntArmor = mArmorInterpolator.GetValue();
			int MaxArmor = GetMaxAmount("BasicArmor");

			//WARNING: vile
			if(!CheckInventory("sae_extcam") && !automapactive) {
				if(showVisorGlass) {
					if(m0to1Float < 1.0) {
						PBHud_DrawImageManualAlpha("HUDTPOF2", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15);  
						PBHud_DrawImageManualAlpha("HUDBTOF2", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15);   
						PBHud_DrawImageManualAlpha("HUDTP2O2", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15); 
						PBHud_DrawImageManualAlpha("HUDBTO22", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15); 
					}
				
					PBHud_DrawImageManualAlpha("HUDTOP2", (-35 - m32to0, -9 - m32to0), DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15);
					PBHud_DrawImageManualAlpha("HUDBOTO2", (-35 - m32to0, 9 + m32to0), DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15);   
					PBHud_DrawImageManualAlpha("HUDT2P2", (35 + m32to0, -9 - m32to0), DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15); 
					PBHud_DrawImageManualAlpha("HUDBOT22", (35 + m32to0, 9 + m32to0), DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (0.7, 0.7), 0.6, 0.15);
				}
			   
				if(showVisor) {
					double sectorlightlevel = cplayer.mo.cursector.lightlevel / 255.0;
					
					color slcol = cplayer.mo.cursector.colormap.lightcolor;
					
					// [gng] i have heard that the color function is expensive, so i avoid running it if there's no need to.
					color flsectorlightcolor;
					if(slcol != 16777215)
						flsectorlightcolor = Color(255, slcol.r, slcol.g, slcol.b);
					else
						flsectorlightcolor = 0xffffffff;
						
					// darkness underlays
				  	PBHud_DrawImageManualAlpha("HUDTDARK", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, 1, scale: (0.7, 0.7), col: flsectorlightcolor);  
					PBHud_DrawImageManualAlpha("HUDBDARK", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, 1, scale: (0.7, 0.7), col: flsectorlightcolor);   
					PBHud_DrawImageManualAlpha("HUDTDAR2", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, 1, scale: (0.7, 0.7), col: flsectorlightcolor);  
				   	PBHud_DrawImageManualAlpha("HUDBDAR2", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, 1, scale: (0.7, 0.7), col: flsectorlightcolor);
				  		
				  	// visor corners
				  	PBHud_DrawImageManualAlpha("HUDTOPOF", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, sectorlightlevel, scale: (0.7, 0.7), col: flsectorlightcolor);  
					PBHud_DrawImageManualAlpha("HUDBOTOF", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, sectorlightlevel, scale: (0.7, 0.7), col: flsectorlightcolor);   
					PBHud_DrawImageManualAlpha("HUDT2POF", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, sectorlightlevel, scale: (0.7, 0.7), col: flsectorlightcolor);  
				   	PBHud_DrawImageManualAlpha("HUDBOT2F", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, sectorlightlevel, scale: (0.7, 0.7), col: flsectorlightcolor);
					
					// lens flares
					PBHud_DrawImageManualAlpha("HUDTFLAR", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, m0to1float * ( 1.0 - (sectorlightlevel)), scale: (0.7, 0.7), style: STYLE_Add);  
					PBHud_DrawImageManualAlpha("HUDBFLAR", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, m0to1float * ( 1.0 - (sectorlightlevel)), scale: (0.7, 0.7), style: STYLE_Add);
					PBHud_DrawImageManualAlpha("HUDTFLA2", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, m0to1float * ( 1.0 - (sectorlightlevel)), scale: (0.7, 0.7), style: STYLE_Add);  
				   	PBHud_DrawImageManualAlpha("HUDBFLA2", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, m0to1float * ( 1.0 - (sectorlightlevel)), scale: (0.7, 0.7), style: STYLE_Add);
					
					// hologram beam
					PBHud_DrawImageManualAlpha("HUDTOP", (-35, -9) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, m0to1Float, scale: (0.7, 0.7), style: STYLE_Add);  
					PBHud_DrawImageManualAlpha("HUDBOTOM", (-35, 9) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, m0to1Float, scale: (0.7, 0.7), style: STYLE_Add);   
					PBHud_DrawImageManualAlpha("HUDT2P", (35, -9), DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, m0to1Float, scale: (0.7, 0.7), style: STYLE_Add);  
					PBHud_DrawImageManualAlpha("HUDBOT2M", (35, 9) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, m0to1Float, scale: (0.7, 0.7), style: STYLE_Add);
				}
			}

			PBHUD_DrawMessages();

			//Healthbar
			if(GetAirTime() < 700)
				PBHud_DrawString(mBoldFont, "O²: "..(Formatnumber(((GetAirTime() / 7.0) * 100.0) / 100.0)).."%", (190, -90), DI_TEXT_ALIGN_LEFT, Font.FindFontColor('HUDBLUEBAR'));

			PBHud_DrawImage(inPain ? "BARBCK1L" : "BARBACK1", (73, -50), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
			
			if(dasher) {
				/*PBHud_DrawBar("DASHHUD2", "DASHHUD1", Dasher.DashCharge, 17.5, (252, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, clamp(dashIndAlpha, 0.0, 1.0), slanted: false);
				PBHud_DrawBar("DASHHUD2", "DASHHUD1", Dasher.DashCharge - 17.5, 17.5, (261, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, clamp(dashIndAlpha, 0.0, 1.0), slanted: false);*/
			   
				PBHud_DrawImage(Dasher.DashCharge >= 17.5 ? "DASHHUD2" : "DASHHUD1", (251 - 9 * dashScale2, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_VCENTER | DI_ITEM_LEFT, clamp(dashIndAlpha, 0.0, 1.0), scale: (1 + dashScale1, 1 + dashScale1));
				PBHud_DrawImage(Dasher.DashCharge >= 35 ? "DASHHUD2" : "DASHHUD1", (275 + 9 * dashScale1, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_VCENTER | DI_ITEM_RIGHT, clamp(dashIndAlpha, 0.0, 1.0), scale: (1 + dashScale2, 1 + dashScale2));
				
				if(Dasher.DashCharge != 35 && dashIndAlpha < 1)
					dashIndAlpha = 5.0;
			}
			
			PBHud_DrawBar(inPain ? "HOBAR" : "HPBAR", "BGBARL", IntHealth, min(MaxHealth, 100), (112, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			if(Health > 100)
				PBHud_DrawBar("HLBAR", "BGBARL", IntHealth - 100, min(MaxHealth, 200), (112, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			PBHud_DrawString(mDefaultFont, Formatnumber(Health), (205, -69), DI_TEXT_ALIGN_LEFT, healthFontCol);
				
			//Armorbar
			PBHud_DrawImage("BARBACK2", (72, -17), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
			
			// health indicator is here because sometimes it overlaps the armor bar
			if(CheckInventory("PB_PowerStrength"))
			{
				// the stupid fucking berserk indicator that i spent too much time on
				double gameTicRadians = gameTic * 11.4592;
				double berserkBeat = 0.1 * ((((sin(gameTicRadians) ** 13) * sin((gameTicRadians) + 85.944)) / 0.2096) + (sin(gameTicRadians - 286.48) ** 16) * 0.2);
				
				PBHud_DrawImage("BZRKHUD",  (92, -62), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, scale: (0.6 + berserkBeat, 0.6 + berserkBeat));
			}

			if(Health > 100)
				PBHud_DrawImage("OVERHUD", (92, -62), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, scale: (0.5, 0.5));
			else
				PBHud_DrawImage(inPain ? "LHLTHHUD" : "HLTHHUD", (92, -62), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, scale: (0.5, 0.5));
			
			PBHud_DrawBar("APBAR", "BGBARL", IntArmor, min(MaxArmor, 100), (112, -30), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			if(Armor > 100)
				PBHud_DrawBar("AOBAR", "BGBARL", IntArmor - 100, min(MaxArmor, 100), (112, -30), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			PBHud_DrawString(mDefaultFont, FormatNumber(Armor), (205, -48), DI_TEXT_ALIGN_LEFT, Font.FindFontColor('HUDGREENBAR2') );
			
			int svpr = GetArmorSavePercent();

			if(svpr >= 0 && svpr < 32)
				PBHud_DrawImage("ARMRHUD1", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
			else if(svpr >= 32 && svpr < 39)
				PBHud_DrawImage("ARMRHUD2", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
			else if(svpr >= 39 && svpr < 70)
				PBHud_DrawImage("ARMRHUD3", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
			else if(svpr >= 70)
				PBHud_DrawImage("ARMRHUD4", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
			
			PBHud_DrawString(mBoldFont, Formatnumber(svpr), (89.8, -41), DI_TEXT_ALIGN_CENTER, Font.CR_WHITE, scale: (0.8, 0.8));
			
			PB_FPP_Holder flPointer = PB_FPP_Holder(CPlayer.mo.FindInventory("PB_FPP_Holder"));
			
			if(flPointer)
			{
				PBHud_DrawImage(flPointer.flOutOfBatteryPenalty ? "FLSHBATL" : "FLSHBATT", (103, -12), DI_ITEM_LEFT_BOTTOM | DI_SCREEN_LEFT_BOTTOM, playerBoxAlpha * clamp(flashlightBatteryAlpha, 0.0, 1.0));
				PBHud_DrawBar(flPointer.flOutOfBatteryPenalty ? "FLSHBBAL" : "FLSHBBAR", "FLSHBBRG", flPointer.flashlightCharge, flPointer.flashlightChargeMax, (122, -15), 0, 0, DI_ITEM_LEFT_BOTTOM | DI_SCREEN_LEFT_BOTTOM, clamp(flashlightBatteryAlpha, 0.0, 1.0), slanted: false);
				
				if((flPointer.flashlightCharge < flPointer.flashlightChargeMax && flashlightBatteryAlpha < 1) || flPointer.on)
					flashlightBatteryAlpha = 10.0;
			}
			
			//Mugshot
			PBHud_DrawImage("EQUPBO", (16, -17), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
			
			PBHud_DrawSpecialMugshot();
			
			//Powerups
			PB_DrawPowerups((16, -76));
			
			//Keys
			if(keyamount > 0)
				PBHud_DrawImage("KEYCRBOX", (-15, 17), DI_SCREEN_RIGHT_TOP | DI_ITEM_RIGHT_TOP, playerBoxAlpha);
				
			DrawKeys((-36, 38), 12, 15);
			
			if(showLevelStats) 
			{
				//Level Stats
				PBHud_DrawImage("LEVLSTAT", (15, 17), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, playerBoxAlpha, scale: (1.2, 1.0));

				//time
				PBHud_DrawImage("1TIME", (26, 26), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, Level.TimeFormatted(), (35, 25), 0, Font.CR_YELLOW, scale: (0.6, 0.6));
				
				//kills
				PBHud_DrawImage("1KILLS", (26, 36), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, FormatNumber(Level.killed_monsters,0,5).." / "..FormatNumber(Level.total_monsters,0,5), (35, 35), 0, Font.CR_WHITE, scale: (0.6, 0.6));
				
				//items
				PBHud_DrawImage("1ITEMS", (26, 46), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, FormatNumber(Level.found_items,0,5).." / "..FormatNumber(Level.total_items,0,5), (35, 45), 0, Font.CR_GREEN, scale: (0.6, 0.6));
				
				//secrets
				PBHud_DrawImage("1SECRET", (26, 56), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, FormatNumber(Level.found_secrets,0,5).." / "..FormatNumber(Level.total_secrets,0,5), (35, 55), 0, Font.CR_PURPLE, scale: (0.6, 0.6));
			}
			
			//DrawMessagesInArray();
			
			if(CPlayer.Health <= 0) 
			{
			  DeathSequence(true);
			  PlayerWasDead = true;
			}
			
			if(CPlayer.Health >= 1 && PlayerWasDead) 
			{
			  DeathSequence(false);
			  PlayerWasDead = false;
			}

			////////////////////////////////////
			//		 AMMOBAR HUD			//
			////////////////////////////////////
			
			if(CPlayer.ReadyWeapon)
			{   
				//Equipment
				PBHud_DrawImage("EQUPBO", (-15, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
				
				if(CheckInventory("FragGrenadeSelected")) {
					PBHud_DrawImage("HFRAGY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
					PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_GrenadeAmmo")), (-38, -37), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED, scale: (0.8, 0.8));
				}
				else if(CheckInventory("ProximityMineSelected")) {
					PBHud_DrawImage("HMINEY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
					PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_ProxMineAmmo")), (-38, -37), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED, scale: (0.8, 0.8));
				}
				else if(CheckInventory("StunGrenadeSelected")) {
					PBHud_DrawImage("HSTUNY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
					PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_StunGrenadeAmmo")), (-38, -37), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED, scale: (0.8, 0.8));
				}
				else if(CheckInventory("RevGunSelected")) {
					PBHud_DrawImage("HREVCY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
					PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_QuickLauncherAmmo")), (-38, -37), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED, scale: (0.8, 0.8));
				}
				else if(CheckInventory("LeechSelected")) {
					PBHud_DrawImage("HLECHY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
					PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_DTech")), (-38, -37), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED, scale: (0.8, 0.8));
				}
				
				//Ammo bars
				if(showList)
					PB_AmmoListDrawer((-10, -60));

				//Specials and Dual Wields
				int IntAmmoLeft = mAmmoLeftInterpolator.GetValue();
				//console.PrintF("%i %s", IntAmmoLeft, leftAmmoAmount);
				
				let PB_Weap = PB_WeaponBase(CPlayer.ReadyWeapon);

				if(PB_Weap && PB_Weap.GunBraced == true)
					PBHud_DrawImage("BRACICON", (-82, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
				
				//handles dual wielding ammo
				if(PB_Weap && PB_Weap.DualWieldToken && CheckInventory(PB_Weap.DualWieldToken) && PB_Weap.AmmoTypeLeft){
					leftAmmoAmount = PB_Weap.AmmoTypeLeft.GetClassName();
					if(WeaponUsesAmmoType("PB_HighCalMag")){
						PBHud_DrawImage("BARBACY3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR1", "BGBARL", IntAmmoLeft, GetMaxAmount(PB_Weap.AmmoTypeLeft), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount(PB_Weap.AmmoTypeLeft)), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
					}
					else if(WeaponUsesAmmoType("PB_LowCalMag")){
						PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR2", "BGBARL", IntAmmoLeft, GetMaxAmount(PB_Weap.AmmoTypeLeft), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount(PB_Weap.AmmoTypeLeft)), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
					}
					else if(WeaponUsesAmmoType("PB_Shell")){
						PBHud_DrawImage("BARBACO3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR3", "BGBARL", IntAmmoLeft, GetMaxAmount(PB_Weap.AmmoTypeLeft), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount(PB_Weap.AmmoTypeLeft)), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
					}
					else if(WeaponUsesAmmoType("PB_RocketAmmo")){
						PBHud_DrawImage("BARBACR3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR4", "BGBARL", IntAmmoLeft, GetMaxAmount(PB_Weap.AmmoTypeLeft), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount(PB_Weap.AmmoTypeLeft)), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
					}
					else if(WeaponUsesAmmoType("PB_Cell")){
						PBHud_DrawImage("BARBACP3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR5", "BGBARL", IntAmmoLeft, GetMaxAmount(PB_Weap.AmmoTypeLeft), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount(PB_Weap.AmmoTypeLeft)), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
					}
					else if(WeaponUsesAmmoType("PB_DTech")){
						PBHud_DrawImage("BARBACZ3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR7", "BGBARL", IntAmmoLeft, GetMaxAmount(PB_Weap.AmmoTypeLeft), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount(PB_Weap.AmmoTypeLeft)), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKRED);
					}
					else{
						PBHud_DrawImage("BARBACC3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR8", "BGBARL", IntAmmoLeft, GetMaxAmount(PB_Weap.AmmoTypeLeft), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount(PB_Weap.AmmoTypeLeft)), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);
					}
				}
				//handles other exceptions
				switch(CPlayer.ReadyWeapon.GetClassName())
				{
					case 'PB_DMR':
						if(CheckInventory("HDMRGrenadeMode") && !CheckInventory("DualWieldingDMRs"))
						{
							leftAmmoAmount = "PB_RocketAmmo";

							//Underbarrel Grenade Ammo
							PBHud_DrawImage("BARBACR3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR4", "BGBARL", IntAmmoLeft, GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
						}
						break;
					default:
						break;
				}
						/*
						if(CheckInventory("DualWieldingDMRs"))
						{
							leftAmmoAmount = "LeftDMRAmmo";
							
							//Left Rifle Ammo
							PBHud_DrawImage("BARBACY3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR1", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftDMRAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftDMRAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
						}
						*/
						/*
					case 'PB_Carbine':
						if(CheckInventory("DualWieldingCarbines"))
						{
							leftAmmoAmount = "LeftXRifleAmmo";
							
							PBHud_DrawImage("BARBACY3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR1", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftXRifleAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftXRifleAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
						}
						break;
					case 'PB_Pistol':
						if(CheckInventory("DualWieldingPistols"))
						{
							leftAmmoAmount = "SecondaryPistolAmmo";

							PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR2", "BGBARL", IntAmmoLeft, GetMaxAmount("SecondaryPistolAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("SecondaryPistolAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
						}
						break;
					case 'PB_Revolver':
						if(CheckInventory("DualWieldingRevolver"))
						{
							leftAmmoAmount = "LeftRevolverAmmo";
							
							PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR2", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftRevolverAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftRevolverAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
						}
						break;
					case 'PB_SMG':
						if(CheckInventory("DualWieldingSMGs"))
						{
							leftAmmoAmount = "LeftSMGAmmo";
							
							PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR2", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftSMGAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftSMGAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
						}
						break;
					case 'PB_Deagle':
						if(CheckInventory("DualWieldingDeagles"))
						{
							leftAmmoAmount = "LeftDeagleAmmo";
							
							PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR2", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftDeagleAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftDeagleAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
						}
						break;
					case 'PB_MP40':
						if(CheckInventory("DualWieldingMP40"))
						{
							leftAmmoAmount = "LeftMP40Ammo";
							
							PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR2", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftMP40Ammo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftMP40Ammo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
						}
						break;
					case 'PB_SSG':
						if(CheckInventory("DualWieldingSSG"))
						{
							leftAmmoAmount = "LeftSSGAmmo";
							
							PBHud_DrawImage("BARBACO3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR3", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftSSGAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftSSGAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
						}
						break;
					case 'PB_AutoShotgun':
						if(CheckInventory("DualWieldingAutoshotguns"))
						{
							leftAmmoAmount = "LeftASGAmmo";
							
							PBHud_DrawImage("BARBACO3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR3", "BGBARL", GetAmount("LeftASGAmmo"), GetMaxAmount("LeftASGAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftASGAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
						}
						break;
					case 'PB_QuadSG':
						if(CheckInventory("QuadAkimboMode"))
						{
							leftAmmoAmount = "LeftQSSGAmmoCounter";
							
							PBHud_DrawImage("BARBACO3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR3", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftQSSGAmmoCounter"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftQSSGAmmoCounter")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
						}
						break;
					case 'PB_M1Plasma':
						if(CheckInventory("DualWieldingPlasma"))
						{
							leftAmmoAmount = "LeftPlasmaAmmo";
							
							PBHud_DrawImage("BARBACP3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR5", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftPlasmaAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftPlasmaAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
						}
						break;
					case 'PB_M2Plasma':
						if(CheckInventory("DualWieldingM2Plasma"))
						{
							leftAmmoAmount = "LeftM2PlasmaAmmo";

							PBHud_DrawImage("BARBACP3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
							PBHud_DrawBar("ABAR5", "BGBARL", IntAmmoLeft, GetMaxAmount("LeftM2PlasmaAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
							PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftM2PlasmaAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
						}
						break;
					*/
					
					
//					 case 'PB_CryoRifle':
//						 if(CheckInventory("CryoRiflePistolToken"))
//						 {
//							 leftAmmoAmount = "PrimaryPistolAmmo";
							
//							 PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
							
//							 PBHud_DrawBar("ABAR2", "BGBARL", IntAmmoLeft, GetMaxAmount("PrimaryPistolAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
//							 PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PrimaryPistolAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
//						 }
//						 break;
				
				if(WeaponUsesAmmoType("PB_LowCalMag"))
				{
					weaponBarAccent = Font.CR_TAN;
					DrawAmmoBar("BARBACT1", "BARBACT2", "BAMBAR2", "ABAR2", "ABAR2", "AMMOIC2", Font.CR_TAN);
				}
				else if(WeaponUsesAmmoType("PB_HighCalMag") && !(CheckWeaponSelected("PB_MG42")))
				{
					weaponBarAccent = Font.CR_YELLOW;
					DrawAmmoBar("BARBACY1", "BARBACY2", "BAMBAR1", "ABAR1", "ABAR1", "AMMOIC1", Font.CR_YELLOW);
				}
				else if(WeaponUsesAmmoType("PB_Shell"))
				{
					weaponBarAccent = Font.CR_ORANGE;
					DrawAmmoBar("BARBACO1", "BARBACO2", "BAMBAR3", "ABAR3", "ABAR3", "AMMOIC3", Font.CR_ORANGE);
				}
				else if(WeaponUsesAmmoType("PB_RocketAmmo"))
				{
					weaponBarAccent = Font.CR_RED;
					DrawAmmoBar("BARBACR1", "BARBACR2", "BAMBAR4", "ABAR4", "ABAR4", "AMMOIC4", Font.CR_RED);
				}
				else if(WeaponUsesAmmoType("PB_Cell"))
				{
					weaponBarAccent = Font.CR_PURPLE;
					DrawAmmoBar("BARBACP1", "BARBACP2", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE);
				}
				else if(WeaponUsesAmmoType("PB_Fuel") && !(CheckWeaponSelected("PB_Chainsaw") || CheckWeaponSelected("PB_Flamethrower")))
				{
					weaponBarAccent = Font.CR_ORANGE;
					DrawAmmoBar("BARBACD1", "BARBACD2", "BAMBAR6", "ABAR6", "ABAR6", "AMMOIC6", Font.CR_ORANGE);
				}
				else if(WeaponUsesAmmoType("PB_DTech") && !(CheckWeaponSelected("PB_Unmaker")))
				{
					weaponBarAccent = Font.CR_DARKRED;
					DrawAmmoBar("BARBACZ1", "BARBACZ2", "BAMBAR7", "ABAR7", "ABAR7", "AMMOIC7", Font.CR_DARKRED);
				}
				else if(WeaponUsesPBAmmoType1() && !CheckWeaponSelected("PB_Unmaker") && !CheckWeaponSelected("PB_Chainsaw") && !CheckWeaponSelected("PB_Flamethrower") && !CheckWeaponSelected("PB_MG42") && !CheckWeaponSelected("PB_TauntWeapon") ){
					weaponBarAccent = Font.CR_CYAN;
					DrawAmmoBar("BARBACC1", "BARBACC2", "BAMBAR8", "ABAR8", "ABAR8", "AMMOIC8", Font.CR_CYAN);
				}
					//PB_Ammo
					//DrawAmmoBar(string lowerBG, string upperBG, string barBorder, string currentBar, string reserveBar, string ammoIcon, int fontTranslation = 0)
				
				//Special weapons
				
				Ammo Primary, Secondary;
				[Primary, Secondary] = GetCurrentAmmo();
				
				
				if((Primary || Secondary) && CPlayer.ReadyWeapon)
				{
					PBHud_DrawString(mDefaultFont, CPlayer.ReadyWeapon.GetTag(), (-110, -22), DI_ITEM_RIGHT_BOTTOM | DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT, weaponBarAccent, scale: (0.5, 0.5));
				}
				
				switch(CPlayer.ReadyWeapon.GetClassName())
				{
					case 'PB_Unmaker':
						PBHud_DrawImage("BARBACZ1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawImage("BARBACZ2", (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						//Bars
						PBHud_DrawBar("ABAR7", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-112, -51), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawBar("ABAR7", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						//Numbers
						PBHud_DrawString(mDefaultFont, "SOULS", (-207, -69), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKRED);
						PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKRED);
						//Icon
						PBHud_DrawImage("AMMOIC7", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
						weaponBarAccent = Font.CR_DARKRED;
						break;
					case 'PB_Chainsaw':
						PBHud_DrawImage("BARBACD1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawBar("ABAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						//Numbers
						PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
						//Icon
						PBHud_DrawImage("AMMOIC6", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));

						if(CheckInventory("ChainsawResourceGather"))
						{
							PBHud_DrawImage("CHAINHL", (-90, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (32, 32));
						}
						weaponBarAccent = Font.CR_ORANGE;
						break;
					case 'PB_MG42':
						PBHud_DrawImage("BARBACY1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						PBHud_DrawImage("BARBACR2", (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						//Bars
						PBHud_DrawBar("ABAR4", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-112, -51), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						PBHud_DrawBar("ABAR1", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						//Numbers
						PBHud_DrawString(mDefaultFont, "HEAT", (-207, -69), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
						PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
						//Icon
						PBHud_DrawImage("AMMOIC1", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
						weaponBarAccent = Font.CR_YELLOW;
						break;
					case 'PB_Flamethrower':
						PBHud_DrawImage("BARBACD1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
						if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawImage("BARBACD2", (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha); }
						//Bars
						if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawBar("ABAR6", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-112, -51), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM); }
						PBHud_DrawBar("ABAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
						//Numbers
						if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawString(mDefaultFont, FormatNumber(Secondary.Amount), (-207, -69), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE); }
						PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
						//Icon
						PBHud_DrawImage("AMMOIC6", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
						weaponBarAccent = Font.CR_ORANGE;
						break;
					case 'PB_Axe':
						int AxeCount = CPlayer.mo.CountInv("PB_Axe");
						
						for (AxeCount > 0; AxeCount--;)
						{
							PBHud_DrawImage("AXECOUNT", (-80 + (-8* AxeCount), -28), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM | DI_MIRROR, scale: (0.5, 0.5));
						}
						break;
				}
			}
		}
	}
	bool WeaponUsesPBAmmoType(){return WeaponUsesPBAmmoType1() || WeaponUsesPBAmmoType2();}
	bool WeaponUsesPBAmmoType1(){
		if (CPlayer == null) return false;
		let w = CPlayer.ReadyWeapon;
		if (w == NULL || w.AmmoType1 == NULL) return false;
		return (w.AmmoType1 is "PB_Ammo");
	}
	bool WeaponUsesPBAmmoType2(){
		if (CPlayer == null) return false;
		let w = CPlayer.ReadyWeapon;
		if (w == NULL || w.AmmoType2 == NULL) return false;
		return (w.AmmoType2 is "PB_Ammo");
	}
}

class PB_DynamicDoubleInterpolator : Object
{
	double mCurrentValue;
	double mMinChange;
	double mMaxChange;
	double mChangeFactor;

	static PB_DynamicDoubleInterpolator Create(int startval, double changefactor, double minchange, double maxchange)
	{
		let v = new("PB_DynamicDoubleInterpolator");
		v.mCurrentValue = startval;
		v.mMinChange = minchange;
		v.mMaxChange = maxchange;
		v.mChangeFactor = changefactor;
		return v;
	}

	void Reset(double value)
	{
		mCurrentValue = value;
	}

	// This must be called periodically in the status bar's Tick function.
	// Do not call this in the Draw function because that may skip some frames!
	void Update(double destvalue)
	{
		double diff = clamp(abs(destvalue - mCurrentValue) * mChangeFactor, mMinChange, mMaxChange);
		if (mCurrentValue > destvalue)
		{
			mCurrentValue = max(destvalue, mCurrentValue - diff);
		}
		else
		{
			mCurrentValue = min(destvalue, mCurrentValue + diff);
		}
	}

	// This must be called in the draw function to retrieve the value for output.
	double GetValue()
	{
		return mCurrentValue;
	}
}