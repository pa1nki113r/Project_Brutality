//Project Brutality FULLSCREEN HUD
//Converted from SBARINFO to ZScript by generic name guy

class PB_Hud_ZS : BaseStatusBar
{
    int currentTickAmount, rtlAmmoBar;
    
    HUDFont mIndexFont;
    HUDFont mNumFont;
    HUDFont mSmallFont;

	DynamicValueInterpolator mHealthInterpolator;
	DynamicValueInterpolator mArmorInterpolator;
    DynamicValueInterpolator mAmmo1Interpolator;
    DynamicValueInterpolator mAmmo2Interpolator;
    DynamicValueInterpolator mSwayInterpolator;
    DynamicValueInterpolator mPitchInterpolator;
    DynamicValueInterpolator mFOffsetInterpolator;

	InventoryBarState InvBar;

    Double mSway, mPitch, mOldZVel, mForwardOffset;
    Double mOldAngles;
    Double mOldPitch;
    Double mFallOfs;

    Int m32to0, m64to0;
    Double m0to1Float;
    Bool HasPutOnHelmet, HasCompletedHelmetSequence;
    Bool DeathFadeDone, PlayerWasDead;

    bool HudDynamics;
    
	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 240);
		
		mIndexFont = HUDFont.Create("INDEXFONT");
        mNumFont = HUDFont.Create("AANUM3");
        mSmallFont = HUDFont.Create("NEWSMALLFONT");
		
        mHealthInterpolator = DynamicValueInterpolator.Create(0, 0.10, 2, 64);
		mArmorInterpolator = DynamicValueInterpolator.Create(0, 0.10, 2, 64);
        mAmmo1Interpolator = DynamicValueInterpolator.Create(0, 0.10, 2, 64);
        mAmmo2Interpolator = DynamicValueInterpolator.Create(0, 0.10, 2, 64);
        mSwayInterpolator = DynamicValueInterpolator.Create(0, 0.30, 1, 32);
        mPitchInterpolator = DynamicValueInterpolator.Create(0, 0.30, 1, 32);
        mFOffsetInterpolator = DynamicValueInterpolator.Create(0, 0.5, 1, 64);

		InvBar = InventoryBarState.Create();
	}

	override void Draw(int state, double TicFrac)
	{
		Super.Draw(state, TicFrac);
        
        if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullScreenStuff();
		}
	}

    override void NewGame()
	{
		Super.NewGame();

        m32to0 = 32;
        m64to0 = 64;
        m0to1Float = 0;

		if(currentTickAmount % 35 == 0) {
            rtlAmmoBar = Cvar.GetCvar("PB_RTLAmmoBar", CPlayer).GetBool();
        } 
        
        mHealthInterpolator.Reset(0);
		mArmorInterpolator.Reset(0);
        mAmmo1Interpolator.Reset(0);
        mAmmo2Interpolator.Reset(0);
        mSwayInterpolator.Reset(0);
        mPitchInterpolator.Reset(0);
        mFOffsetInterpolator.Reset(0);
	}

	override void Tick()
	{
		Super.Tick();
        
        currentTickAmount++;

        if(!CheckInventory("sae_extcam") && !HasCompletedHelmetSequence)
        {
            From32to0Slow();    
        }

        CalculateSway();
        if(currentTickAmount % 35 == 0) {
            rtlAmmoBar = Cvar.GetCvar("PB_RTLAmmoBar", CPlayer).GetBool();
            HudDynamics = CVar.GetCvar("PB_HudDynamics", CPlayer).GetBool();
        } 
        
        Ammo Primary, Secondary;
        [Primary, Secondary] = GetCurrentAmmo();
        if(m0to1Float > 0.99) {
            mHealthInterpolator.Update(CPlayer.Health);
            mArmorInterpolator.Update(GetAmount("BasicArmor"));
            mSwayInterpolator.Update(mSway);
            mPitchInterpolator.Update(mPitch);
            mFOffsetInterpolator.Update(mForwardOffset);
            if(Primary) { mAmmo1Interpolator.Update(Primary.Amount); }
            if(Secondary) { mAmmo2Interpolator.Update(Secondary.Amount); }
        }
	}

    void From32to0Slow() {
        if(m0to1Float < 1.00 && HasPutOnHelmet) {
            m0to1Float += 0.1;
        }
        if(m32to0 > 0) {
            m32to0 -= 2;
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
    
    void From1to0SlowForced(bool Death) {
      if(death) {
        if(HasPutOnHelmet && m0to1Float > 0.0 && !DeathFadeDone) {
          m0to1Float -= 0.1;
          if(m0to1Float <= 0.0) {
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
        if (mOldZVel < -8 && onGround)
		{
            mFallOfs = clamp((mOldZVel * 0.50), 0, -9);
		}
        
        //Pointer to the PB player class.
        let PB_Player = PlayerPawnBase(CPlayer.mo);

        //Limit and add variables.
        mSway = clamp(intSway + (PB_Player.XBob * 0.5) - CPlayer.mo.Roll, -8, 8);
        mPitch = clamp(intPitch + mFallOfs - (PB_Player.YBob * 0.5) + CPlayer.mo.Roll, -8, 8);

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

    void PBHud_DrawImage(String texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
    {
        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();

        if(HudDynamics) {    
            pos.x += IntMSway * Parallax;
            pos.y -= IntMPitch * Parallax;

            if(flags == DI_SCREEN_LEFT_BOTTOM) {
                pos.x += (IntMOfs * Parallax2);
                pos.y -= (IntMOfs * Parallax2);
            }
            
            if(flags == DI_SCREEN_RIGHT_BOTTOM) {
                pos.x -= (IntMOfs * Parallax2);
                pos.y -= (IntMOfs * Parallax2);
            }
        }

        DrawImage(texture, pos, flags, m0to1Float, box, scale);
    }

    void PBHud_DrawString(HUDFont font, String string, Vector2 pos, int flags = 0, int translation = Font.CR_UNTRANSLATED, double Alpha = 1., int wrapwidth = -1, int linespacing = 4, Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
    {
        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();

        if(HudDynamics) {
            pos.x += IntMSway * Parallax;
            pos.y -= IntMPitch * Parallax;

            if(pos.x > 0) {
                pos.x += (IntMOfs * Parallax2);
                pos.y -= (IntMOfs * Parallax2);
            }
            
            if(pos.x < 0) {
                pos.x -= (IntMOfs * Parallax2);
                pos.y -= (IntMOfs * Parallax2);
            }
        }

        DrawString(font, string, pos, flags, translation, m0to1Float, wrapwidth, linespacing, scale);
    }

    void PBHud_DrawBar(String ongfx, String offgfx, double curval, double maxval, Vector2 position, int border, int vertical, int flags = 0, double Parallax = 0.75, double Parallax2 = 0.25) 
    {
        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();

        if(HudDynamics) {
            position.x += IntMSway * Parallax;
            position.y -= IntMPitch * Parallax;

            if(flags == DI_SCREEN_LEFT_BOTTOM) {
                position.x += (IntMOfs * Parallax2);
                position.y -= (IntMOfs * Parallax2);
            }
            
            if(flags == DI_SCREEN_RIGHT_BOTTOM) {
                position.x -= (IntMOfs * Parallax2);
                position.y -= (IntMOfs * Parallax2);
            }
        }
        
        DrawBar(ongfx, offgfx, curval, maxval, position, border, vertical, flags, m0to1Float);
    }

    void PBHud_DrawTexture(TextureID texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
    {
        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();

        if(HudDynamics) {
            pos.x += IntMSway * Parallax;
            pos.y -= IntMPitch * Parallax;

            if(pos.x > 0) {
                pos.x += (IntMOfs * Parallax2);
                pos.y -= (IntMOfs * Parallax2);
            }
            
            if(pos.x < 0) {
                pos.x -= (IntMOfs * Parallax2);
                pos.y -= (IntMOfs * Parallax2);
            }
        }

        DrawTexture(texture, pos, flags, m0to1Float, box, scale);
    }
    
    ////////////////////////////////////
    //       RESERVE AMMO HUD         //
    ////////////////////////////////////

    void ReserveAmmoNum(string ammoIcon, string ammoType, vector2 ammoIconPos, vector2 ammoNumPos, int fontTranslation)
    {
        PBHud_DrawImage(ammoIcon, ammoIconPos + (-10, 0), DI_SCREEN_RIGHT_BOTTOM, 1, (14, 12));
        PBHud_DrawString(mIndexFont, Formatnumber(GetAmount(ammoType)), ammoNumPos + (-10, 0), DI_TEXT_ALIGN_RIGHT, fontTranslation, scale: (1.2, 1.2));
    }
    
    void DrawReserveAmmoBar()
    {
        //Pistol Ammo
        ReserveAmmoNum("AMMOIC2", "PistolBullets", (-9, -62), (-23, -70), Font.CR_TAN);
        
        //Shotgun Ammo
        ReserveAmmoNum("AMMOIC3", "NewShell", (-9, -74), (-23, -82), Font.CR_ORANGE);
        
        //Heavy Ammo
        ReserveAmmoNum("AMMOIC1", "NewClip", (-9, -86), (-23, -94), Font.CR_YELLOW);
        
        //Rocket Ammo
        ReserveAmmoNum("AMMOIC4", "RocketAmmo", (-9, -98), (-23, -106), Font.CR_RED);
        
        //Plasma Ammo
        ReserveAmmoNum("AMMOIC5", "Cell", (-9, -110), (-23, -118), Font.CR_PURPLE);
        
        //Gas Ammo
        ReserveAmmoNum("AMMOIC6", "Gas", (-9, -123), (-23, -130), Font.CR_ORANGE);
        
        //Soul Ammo
        ReserveAmmoNum("AMMOIC7", "Demonpower", (-9, -135), (-23, -142), Font.CR_DARKRED);
    }

    ////////////////////////////////////
    //           AMMO HUD             //
    ////////////////////////////////////
    
    void DrawAmmoBar(string lowerBG, string upperBG, string barBorder, string currentBar, string reserveBar, string ammoIcon, int fontTranslation = 0)
    {
        if(CPlayer.ReadyWeapon)
		{            
            if(CheckWeaponSelected("PB_Unmaker") || CheckWeaponSelected("PB_Flamethrower"))
                return;

            int IntAmmo1 = mAmmo1Interpolator.GetValue();
            int IntAmmo2 = mAmmo2Interpolator.GetValue();
            
            Ammo Primary, Secondary;
            [Primary, Secondary] = GetCurrentAmmo();

            //Backgrounds
            PBHud_DrawImage(lowerBG, (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
            if(Secondary) { PBHud_DrawImage(upperBG, (-121, -32), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22)); }
            PBHud_DrawImage(barBorder, (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
            if(Secondary) { PBHud_DrawImage(barBorder, (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1); }
            //Bars
            if(Secondary) { PBHud_DrawBar(currentBar, "BGBARL", IntAmmo2, Secondary.MaxAmount, (-113, -39), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM); }
            PBHud_DrawBar(reserveBar, "BGBARL", IntAmmo1, Primary.MaxAmount, (-113, -21), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
            //Numbers
            if(Secondary) { PBHud_DrawString(mNumFont, Formatnumber(Secondary.Amount), (-150, -50), DI_TEXT_ALIGN_RIGHT, fontTranslation); }
            PBHud_DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, fontTranslation);
            //Icon
            PBHud_DrawImage(ammoIcon, (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
        }
    }

    ////////////////////////////////////
    //            KEY HUD             //
    ////////////////////////////////////
    
    virtual void DrawKeys(vector2 pos, int keycount = 10, int space = 23)
    {
        //From NC HUD
        textureid icon, iconskull, iconcard;
        vector2 size;
        bool scaleup;
        int count = 0;

        for(let i = CPlayer.mo.inv; i != null; i = i.inv)
        {
            if(i is "Key")
            {
                //Draw up to defined keycount.
                if(count == keycount)
                {
                    break;
                }

                icon = i.AltHUDIcon;

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

                //Exclude keys which use TNT1 A 0 as their icon
                if(TexMan.GetName(icon) ~== "TNT1A0")
                {
                    continue;
                }

                //Replace doom sprites
                if(TexMan.GetName(icon) == "BKEYA0")
                {
                    icon = texman.checkfortexture("BLKYA0");
                }
                
                if(TexMan.GetName(icon) == "RKEYA0")
                {
                    icon = texman.checkfortexture("REKYB0");
                }
                
                if(TexMan.GetName(icon) == "YKEYA0")
                {
                    icon = texman.checkfortexture("YEKYC0");
                }

                if(TexMan.GetName(icon) == "BSKUA0")
                {
                    icon = texman.checkfortexture("BSKLA0");
                }
                
                if(TexMan.GetName(icon) == "RSKUA0")
                {
                    icon = texman.checkfortexture("RSKLA0");
                }
                
                if(TexMan.GetName(icon) == "YSKUA0")
                {
                    icon = texman.checkfortexture("YSKLA0");
                } 
                
                //Scale the icon up if needed
                size = TexMan.GetScaledSize(icon);
                scaleup = (size.x <= 11 && size.y <= 11);
                PBHud_DrawTexture(icon, pos, DI_ITEM_LEFT_BOTTOM | DI_ITEM_CENTER, box: (22, 22), scaleup? (2, 2) : (1, 1));
                pos.x += space;
                count++;
            }
        }
    }
    
    ////////////////////////////////////
    //           HUD LOGIC            //
    ////////////////////////////////////
    
    void DrawFullScreenStuff()
    {
        let plr = PlayerPawn(CPlayer.mo);
        
        if(plr) {
            ////////////////////////////////////
            //          HEALTH HUD            //
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

            //Healthbar
            PBHud_DrawImage("BARBACK1", (124, -32), DI_SCREEN_LEFT_BOTTOM, 1, (180, 22));
            if(CheckInventory("PowerStrength", 1)) {
                PBHud_DrawImage("bzkhud", (70, -35), DI_SCREEN_LEFT_BOTTOM);
            }
            else 
            {
                PBHud_DrawImage("hlthhud", (70, -35), DI_SCREEN_LEFT_BOTTOM);
            }
            PBHud_DrawImage("HTBAR1", (115, -36), DI_SCREEN_LEFT_BOTTOM, 1);
            PBHud_DrawBar("BLUEBAR", "BGBARL", IntHealth, min(MaxHealth, 100), (115, -39), 0, 0, DI_SCREEN_LEFT_BOTTOM);
            PBHud_DrawString(mNumFont, Formatnumber(Health), (185, -50), DI_TEXT_ALIGN_RIGHT, Font.FindFontColor('HUDBLUEBAR'));
                
            //Armorbar
            PBHud_DrawImage("BARBACK2", (124, -12), DI_SCREEN_LEFT_BOTTOM, 1, (180, 22));
            PBHud_DrawImage("ARBAR1", (115, -18), DI_SCREEN_LEFT_BOTTOM, 1);
            PBHud_DrawBar("GRBAR", "BGBARL", IntArmor, min(MaxArmor, 100), (115, -21), 0, 0, DI_SCREEN_LEFT_BOTTOM);
            PBHud_DrawString(mNumFont, FormatNumber(Armor), (185, -32), DI_TEXT_ALIGN_RIGHT, Font.FindFontColor('HUDGREENBAR2'));
            PBHud_DrawImage("armrhud", (70, -14), DI_SCREEN_LEFT_BOTTOM, 1, (17, 17));
            PBHud_DrawString(mIndexFont, Formatnumber(GetArmorSavePercent()), (69, -26), DI_TEXT_ALIGN_CENTER, Font.FindFontColor('HUDGREENBAR2'));
            
            //mugshot
            PBHud_DrawImage("EQUPCO", (30, -13), DI_SCREEN_LEFT_BOTTOM, 1, (600, 900));
            PBHud_DrawTexture(GetMugShot(5), (13, -50), DI_ITEM_OFFSETS);
            PBHud_DrawImage("EQUPCO", (30, -13), DI_SCREEN_LEFT_BOTTOM, 1, (600, 900));
            DrawKeys((12, -68));
            
            if(CPlayer.Health <= 0) {
              From1to0SlowForced(true);
              PlayerWasDead = true;
            }
            
            if(CPlayer.Health >= 1 && PlayerWasDead) {
              From1to0SlowForced(false);
              PlayerWasDead = false;
            }

            ////////////////////////////////////
            //         AMMOBAR HUD            //
            ////////////////////////////////////
            
            if(CPlayer.ReadyWeapon)
			{

                
                //Equipment
                if(CheckInventory("FragGrenadeSelected")) {
                    PBHud_DrawImage("HFRAGY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("HandGrenadeAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("ProximityMineSelected")) {
                    PBHud_DrawImage("HMINEY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("MineAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("StunGrenadeSelected")) {
                    PBHud_DrawImage("HSTUNY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("StunGrenadeAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("RevGunSelected")) {
                    PBHud_DrawImage("HREVCY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("MiniHellRocketAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }

                PBHud_DrawImage("EQUPBO", (-30, -15), DI_SCREEN_RIGHT_BOTTOM, 1, (600, 900));

                DrawReserveAmmoBar();
                
                //Ammo bars


                //Rifle Modes
                if(CheckWeaponSelected("Rifle")) 
                {
                    if(CheckInventory("DualWieldingDMRs"))
                    {
                        //Left Rifle Ammo
                        PBHud_DrawImage("BARBACY2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR1", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR1", "BGBARL", GetAmount("LeftRifleAmmo"), GetMaxAmount("LeftRifleAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftRifleAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                    }

                    if(CheckInventory("HDMRGrenadeMode"))
                    {
                        //Underbarrel Grenade Ammo
                        PBHud_DrawImage("BARBACR2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR4", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR4", "BGBARL", GetAmount("RocketAmmo"), GetMaxAmount("RocketAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("RocketAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                        PBHud_DrawImage("AMMOIC4", (-66, -55), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                    }
                }

                if(CheckWeaponSelected("PB_Carbine") && !CheckWeaponSelected("PB_LMG"))
                {
                    if(CheckInventory("DualWieldingCarbines"))
                    {
                        PBHud_DrawImage("BARBACY2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR1", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR1", "BGBARL", GetAmount("LeftXRifleAmmo"), GetMaxAmount("LeftXRifleAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftXRifleAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                    }
                }

                if(CheckWeaponSelected("PB_Pistol"))
                {
                    if(CheckInventory("DualWieldingPistols"))
                    {
                        PBHud_DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR2", "BGBARL", GetAmount("SecondaryPistolAmmo"), GetMaxAmount("SecondaryPistolAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("SecondaryPistolAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_Revolver") && !CheckWeaponSelected("PB_Deagle"))
                {
                    if(CheckInventory("DualWieldingRevolver"))
                    {
                        PBHud_DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR2", "BGBARL", GetAmount("LeftRevolverAmmo"), GetMaxAmount("LeftRevolverAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftRevolverAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_SMG"))
                {
                    if(CheckInventory("DualWieldingSMGs"))
                    {
                        PBHud_DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR2", "BGBARL", GetAmount("LeftSMGAmmo"), GetMaxAmount("LeftSMGAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftSMGAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_Deagle"))
                {
                    if(CheckInventory("DualWieldingDeagles"))
                    {
                        PBHud_DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR2", "BGBARL", GetAmount("LeftDeagleAmmo"), GetMaxAmount("LeftDeagleAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftDeagleAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_MP40"))
                {
                    if(CheckInventory("DualWieldingMP40"))
                    {
                        PBHud_DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR2", "BGBARL", GetAmount("LeftMP40Ammo"), GetMaxAmount("LeftMP40Ammo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftMP40Ammo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_SSG") && !CheckWeaponSelected("PB_QuadSG"))
                {
                    if(CheckInventory("DualWieldingSSG"))
                    {
                        PBHud_DrawImage("BARBACO2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR3", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR3", "BGBARL", GetAmount("LeftSSGAmmo"), GetMaxAmount("LeftSSGAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftSSGAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_AUTOSHOTGUN"))
                {
                    if(CheckInventory("DualWieldingAutoshotguns"))
                    {
                        PBHud_DrawImage("BARBACO2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR3", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR3", "BGBARL", GetAmount("LeftASGAmmo"), GetMaxAmount("LeftASGAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftASGAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_QuadSG"))
                {
                    if(CheckInventory("QuadAkimboMode"))
                    {
                        PBHud_DrawImage("BARBACO2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR3", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR3", "BGBARL", GetAmount("LeftQSSGAmmoCounter"), GetMaxAmount("LeftQSSGAmmoCounter"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftQSSGAmmoCounter")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_M1Plasma"))
                {
                    if(CheckInventory("DualWieldingPlasma"))
                    {
                        PBHud_DrawImage("BARBACP2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR5", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR5", "BGBARL", GetAmount("LeftPlasmaAmmo"), GetMaxAmount("LeftPlasmaAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftPlasmaAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
                    }
                }

                if(CheckWeaponSelected("PB_M2Plasma"))
                {
                    if(CheckInventory("DualWieldingM2Plasma"))
                    {
                        PBHud_DrawImage("BARBACP2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR5", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR5", "BGBARL", GetAmount("LeftM2PlasmaAmmo"), GetMaxAmount("LeftM2PlasmaAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("LeftM2PlasmaAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
                    }
                }

                if(CheckWeaponSelected("PB_CryoRifle"))
                {
                    if(CheckInventory("CryoRiflePistolToken"))
                    {
                        PBHud_DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("CURBAR2", "BGBARL", GetAmount("PrimaryPistolAmmo"), GetMaxAmount("PrimaryPistolAmmo"), (-113, -57), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(GetAmount("PrimaryPistolAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }
                
                if(WeaponUsesAmmoType("PistolBullets"))
                {
                    DrawAmmoBar("BARBACT1", "BARBACT3", "BAMBAR2", "CURBAR2", "RESBAR2", "AMMOIC2", Font.CR_TAN);
                }
                if(WeaponUsesAmmoType("NewClip") && !CheckWeaponSelected("PB_MG42"))
                {
                    DrawAmmoBar("BARBACY1", "BARBACY3", "BAMBAR1", "CURBAR1", "RESBAR1", "AMMOIC1", Font.CR_YELLOW);
                }
                if(WeaponUsesAmmoType("NewShell"))
                {
                    DrawAmmoBar("BARBACO1", "BARBACO3", "BAMBAR3", "CURBAR3", "RESBAR3", "AMMOIC3", Font.CR_ORANGE);
                }
                if(WeaponUsesAmmoType("RocketAmmo"))
                {
                    DrawAmmoBar("BARBACR1", "BARBACR2", "BAMBAR4", "CURBAR4", "RESBAR4", "AMMOIC4", Font.CR_RED);
                }
                if(WeaponUsesAmmoType("Cell"))
                {
                    DrawAmmoBar("BARBACP1", "BARBACP3", "BAMBAR5", "CURBAR5", "RESBAR5", "AMMOIC5", Font.CR_PURPLE);
                }
                if(WeaponUsesAmmoType("Gas") && !CheckWeaponSelected("PB_Chainsaw"))
                {
                    DrawAmmoBar("BARBACD1", "BARBACD2", "BAMBAR6", "CURBAR6", "RESBAR6", "AMMOIC6", Font.CR_ORANGE);
                }
                if(WeaponUsesAmmoType("Demonpower") && !CheckWeaponSelected("PB_Unmaker"))
                {
                    DrawAmmoBar("BARBACZ1", "BARBACZ2", "BAMBAR7", "CURBAR7", "RESBAR7", "AMMOIC7", Font.CR_DARKRED);
                }
                
                //Special weapons
                
                Ammo Primary, Secondary;
                [Primary, Secondary] = GetCurrentAmmo();
                
                if(CheckWeaponSelected("PB_Unmaker"))
                {
                    PBHud_DrawImage("BAMBAR7", (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1);
                    PBHud_DrawBar("RESBAR7", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-113, -39), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                    PBHud_DrawString(mSmallFont, "SOULS", (-150, -50), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKRED, linespacing: 8);
                    PBHud_DrawImage("BARBACZ2", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                    PBHud_DrawImage("BAMBAR7", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                    PBHud_DrawBar("RESBAR7", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                    PBHud_DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKRED);
                    PBHud_DrawImage("AMMOIC7", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                }
                
                if(CheckWeaponSelected("PB_Chainsaw"))
                {
                    PBHud_DrawImage("BARBACD1", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                    PBHud_DrawImage("BAMBAR6", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                    PBHud_DrawBar("RESBAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                    PBHud_DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    PBHud_DrawImage("AMMOIC6", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));

                    if(CheckInventory("ChainsawResourceGather"))
                    {
                        PBHud_DrawImage("CHAINHL", (-90, -36), DI_SCREEN_RIGHT_BOTTOM, 1, (32, 32));
                    }
                }
                
                if(CheckWeaponSelected("PB_MG42"))
                {
                        //PBHud_DrawImage("BARBACR2", (-121, -32), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR4", (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("RESBAR4", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-113, -39), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mSmallFont, "HEAT", (-150, -50), DI_TEXT_ALIGN_RIGHT, Font.CR_RED, linespacing: 8);
                        PBHud_DrawImage("BARBACY1", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        PBHud_DrawImage("BAMBAR1", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                        PBHud_DrawBar("RESBAR1", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                        PBHud_DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                        PBHud_DrawImage("AMMOIC1", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                }

                if(CheckWeaponSelected("PB_Flamethrower"))
                {
                    PBHud_DrawImage("BARBACD1", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                    if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawImage("BARBACD2", (-121, -32), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22)); }
                    PBHud_DrawImage("BAMBAR6", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                    if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawImage("BAMBAR6", (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1); }
                    if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawBar("CURBAR6", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-113, -39), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM); }
                    PBHud_DrawBar("RESBAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM);
                    if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawString(mNumFont, Formatnumber(Secondary.Amount), (-150, -50), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE); }
                    PBHud_DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    PBHud_DrawImage("AMMOIC6", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                }
            }
        }
    }
}