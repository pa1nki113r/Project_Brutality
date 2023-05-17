//Project Brutality FULLSCREEN HUD
//Converted from SBARINFO to ZScript by generic name guy

/*
Credits:

A_D_M_E_R_A_L
-Slanted Bars

Iamcarrotmaster
-Graphics

JMartinez2098
-Fixes
*/

class PB_Hud_ZS : BaseStatusBar
{
    int currentTickAmount;
    
    HUDFont mIndexFont;
    HUDFont mDefaultFont;
    HUDFont mBoldFont;

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

    //CVars
    int HUDXMargin, HUDYMargin, rtlAmmoBar;
    bool HudDynamics, showVisor, showVisorGlass, showLevelStats, forceScale;
    
    
	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 240);
		
		mIndexFont = HUDFont.Create("INDEXFONT");
        mDefaultFont = HUDFont.Create("PBFONT");
        mBoldFont = HUDFont.Create("PBBOLD");
		
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
		
		rtlAmmoBar = Cvar.GetCvar("PB_RTLAmmoBar", CPlayer).GetBool();

    HudDynamics = CVar.GetCvar("PB_HudDynamics", CPlayer).GetBool();

    HUDXMargin = Cvar.GetCvar("pb_hudxmargin", CPlayer).GetInt();
    HUDYMargin = CVar.GetCvar("pb_hudymargin", CPlayer).GetInt();
            
    showVisor = CVar.GetCvar("pb_showhudvisor", CPlayer).GetBool();
    showVisorGlass = CVar.GetCvar("pb_showhudvisorglass", CPlayer).GetBool();
    
    showLevelStats = CVar.GetCvar("pb_showlevelstats", CPlayer).GetBool();
            
    if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullScreenStuff();
		}
        
    if (state == HUD_AltHud)
		{
			BeginHUD();
			DrawFullScreenStuff();
		}
        
    if (state == HUD_StatusBar)
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

        rtlAmmoBar = Cvar.GetCvar("PB_RTLAmmoBar", CPlayer).GetBool();
        HudDynamics = CVar.GetCvar("PB_HudDynamics", CPlayer).GetBool();
        
        HUDXMargin = Cvar.GetCvar("pb_hudxmargin", CPlayer).GetInt();
        HUDYMargin = CVar.GetCvar("pb_hudymargin", CPlayer).GetInt();
        
        showVisor = CVar.GetCvar("pb_showhudvisor", CPlayer).GetBool();
        showVisorGlass = CVar.GetCvar("pb_showhudvisorglass", CPlayer).GetBool();
        
        showLevelStats = CVar.GetCvar("pb_showlevelstats", CPlayer).GetBool();
        forceScale = CVar.GetCvar("hud_aspectscale", CPlayer).GetBool();
        
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
        if(HasPutOnHelmet && m0to1Float > 0.0 && !DeathFadeDone) {
          m0to1Float *= (randompick(50, 100, 150) * 0.01);
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

        if(pos.x > 0) {
            pos.x += HUDXMargin;
        }
            
        if(pos.x < 0) {
            pos.x -= HUDXMargin;
        }
        
        if(pos.y > 0) {
						pos.y += HUDYMargin;
        }
            
        if(pos.y < 0) {
        		pos.y -= HUDYMargin;
        }
        
        if(HudDynamics) {    
            pos.x += IntMSway * Parallax;
            pos.y -= IntMPitch * Parallax;

            if(pos.x > 0) {
                pos.x += (IntMOfs * Parallax2);
            }
            
            if(pos.x < 0) {
                pos.x -= (IntMOfs * Parallax2);
            }
            
            if(pos.y > 0) {
                pos.y += (IntMOfs * Parallax2);
            }
            
            if(pos.y < 0) {
                pos.y -= (IntMOfs * Parallax2);
            }
        }

        DrawImage(texture, pos, flags, (m0to1Float * Alpha), box, scale);
    }
    
    void PBHud_DrawImageManualAlpha(String texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 

    {

        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();
        
        if(HudDynamics) {    
            pos.x += IntMSway * Parallax;
            pos.y -= IntMPitch * Parallax;

            if(pos.x > 0) {
                pos.x -= (IntMOfs * Parallax2);
            }
            
            if(pos.x < 0) {
                pos.x += (IntMOfs * Parallax2);
            }
            
            if(pos.y > 0) {
                pos.y -= (IntMOfs * Parallax2);
            }
            
            if(pos.y < 0) {
                pos.y += (IntMOfs * Parallax2);
            }
        }

        DrawImage(texture, pos, flags, Alpha, box, scale);
    }

    void PBHud_DrawString(HUDFont font, String string, Vector2 pos, int flags = 0, int translation = Font.CR_UNTRANSLATED, double Alpha = 1., int wrapwidth = -1, int linespacing = 4, Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
    {
        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();

        if(pos.x > 0) {
            pos.x += HUDXMargin;
        }
            
        if(pos.x < 0) {
            pos.x -= HUDXMargin;
        }
        
        if(pos.y > 0) {
						pos.y += HUDYMargin;
        }
            
        if(pos.y < 0) {
        		pos.y -= HUDYMargin;
        }

        if(HudDynamics) {
            pos.x += IntMSway * Parallax;
            pos.y -= IntMPitch * Parallax;

            if(pos.x > 0) {
                pos.x += (IntMOfs * Parallax2);
            }
            
            if(pos.x < 0) {
                pos.x -= (IntMOfs * Parallax2);
            }
            
            if(pos.y > 0) {
                pos.y += (IntMOfs * Parallax2);
            }
            
            if(pos.y < 0) {
                pos.y -= (IntMOfs * Parallax2);
            }
        }

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
    
    void PBHud_DrawBar(String ongfx, String offgfx, double curval, double maxval, Vector2 position, int border, int vertical, int flags = 0, double alpha = 1.0, double Parallax = 0.75, double Parallax2 = 0.25) 
    {
        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();

        if(position.x > 0) {
            position.x += HUDXMargin;
        }
            
        if(position.x < 0) {
            position.x -= HUDXMargin;
        }
        
        if(position.y > 0) {
						position.y += HUDYMargin;
        }
            
        if(position.y < 0) {
        		position.y -= HUDYMargin;
        }

        if(HudDynamics) {
            position.x += IntMSway * Parallax;
            position.y -= IntMPitch * Parallax;

            if(position.x > 0) {
                position.x += (IntMOfs * Parallax2);
            }
            
            if(position.x < 0) {
                position.x -= (IntMOfs * Parallax2);
            }
            
            if(position.y > 0) {
                position.y += (IntMOfs * Parallax2);
            }
            
            if(position.y < 0) {
                position.y -= (IntMOfs * Parallax2);
            }
        }
        
        PBHUD_DrawSlantedBar(ongfx, offgfx, curval, maxval, position, border, vertical, flags, (m0to1Float * Alpha));
    }

    void PBHud_DrawTexture(TextureID texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
    {
        double IntMSway = mSwayInterpolator.GetValue();
        double IntMPitch = mPitchInterpolator.GetValue();
        double IntMOfs = mFOffsetInterpolator.GetValue();

        if(pos.x > 0) {
            pos.x += HUDXMargin;
        }
            
        if(pos.x < 0) {
            pos.x -= HUDXMargin;
        }
        
        if(pos.y > 0) {
						pos.y += HUDYMargin;
        }
            
        if(pos.y < 0) {
        		pos.y -= HUDYMargin;
        }

        if(HudDynamics) {
            pos.x += IntMSway * Parallax;
            pos.y -= IntMPitch * Parallax;

            if(pos.x > 0) {
                pos.x += (IntMOfs * Parallax2);
            }
            
            if(pos.x < 0) {
                pos.x -= (IntMOfs * Parallax2);
            }
            
            if(pos.y > 0) {
                pos.y += (IntMOfs * Parallax2);
            }
            
            if(pos.y < 0) {
                pos.y -= (IntMOfs * Parallax2);
            }
        }

        DrawTexture(texture, pos, flags, (m0to1Float * Alpha), box, scale);
    }
    
    ////////////////////////////////////
    //       RESERVE AMMO HUD         //
    ////////////////////////////////////

    void ReserveAmmoNum(string ammoIcon, string ammoType, vector2 ammoIconPos, vector2 ammoNumPos, int fontTranslation)
    {
        PBHud_DrawImage(ammoIcon, ammoIconPos + (-12, -20), DI_SCREEN_RIGHT_BOTTOM, 1, (14, 12));
        PBHud_DrawString(mIndexFont, Formatnumber(GetAmount(ammoType)), ammoNumPos + (-11, -21), DI_TEXT_ALIGN_RIGHT, fontTranslation, scale: (1.2, 1.2));
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
            PBHud_DrawImage(lowerBG, (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
            if(Secondary) { PBHud_DrawImage(upperBG, (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1); }
            //Bars
            if(Secondary) { PBHud_DrawBar(currentBar, "BGBARL", IntAmmo2, Secondary.MaxAmount, (-112, -51), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM); }
            PBHud_DrawBar(reserveBar, "BGBARL", IntAmmo1, Primary.MaxAmount, (-112, -30), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
            //Numbers
            if(Secondary) { PBHud_DrawString(mDefaultFont, Formatnumber(Secondary.Amount), (-207, -69), DI_TEXT_ALIGN_RIGHT, fontTranslation); }
            PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, fontTranslation);
            //Icon
            PBHud_DrawImage(ammoIcon, (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
        }
    }

    ////////////////////////////////////
    //            KEY HUD             //
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
        int count = 0;
        string keyactorname;

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

            if(!CheckInventory("sae_extcam")) {
              if(showVisorGlass) {
                if(m0to1Float < 0.99) {
                        PBHud_DrawImageManualAlpha("HUDTPOF2", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, 1 - m0to1Float, scale: (0.7, 0.7), 0.6, 0.15);  

                        PBHud_DrawImageManualAlpha("HUDBTOF2", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, 1 - m0to1Float, scale: (0.7, 0.7), 0.6, 0.15);   
                        
                        PBHud_DrawImageManualAlpha("HUDTP2O2", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, 1 - m0to1Float, scale: (0.7, 0.7), 0.6, 0.15); 
                        
                        PBHud_DrawImageManualAlpha("HUDBTO22", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, 1 - m0to1Float, scale: (0.7, 0.7), 0.6, 0.15); 
                    }
                
                PBHud_DrawImageManualAlpha("HUDTOP2", (-35 - m32to0, -9 - m32to0), DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, m0to1Float, scale: (0.7, 0.7), 0.6, 0.15);
                PBHud_DrawImageManualAlpha("HUDBOTO2", (-35 - m32to0, 9 + m32to0), DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, m0to1Float, scale: (0.7, 0.7), 0.6, 0.15);   
                PBHud_DrawImageManualAlpha("HUDT2P2", (35 + m32to0, -9 - m32to0), DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, m0to1Float, scale: (0.7, 0.7), 0.6, 0.15); 
                PBHud_DrawImageManualAlpha("HUDBOT22", (35 + m32to0, 9 + m32to0), DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, m0to1Float, scale: (0.7, 0.7), 0.6, 0.15);
              }
               
               if(showVisor) {
                  		PBHud_DrawImageManualAlpha("HUDTDARK", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, 1, scale: (0.7, 0.7));  
                    PBHud_DrawImageManualAlpha("HUDBDARK", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, 1, scale: (0.7, 0.7));   
                    PBHud_DrawImageManualAlpha("HUDTDAR2", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, 1, scale: (0.7, 0.7));  
                   	PBHud_DrawImageManualAlpha("HUDBDAR2", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, 1, scale: (0.7, 0.7));
                  		
                  		PBHud_DrawImageManualAlpha("HUDTOPOF", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, cplayer.mo.cursector.lightlevel / 255.0, scale: (0.7, 0.7));  
                    PBHud_DrawImageManualAlpha("HUDBOTOF", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, cplayer.mo.cursector.lightlevel / 255.0, scale: (0.7, 0.7));   
                    PBHud_DrawImageManualAlpha("HUDT2POF", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, cplayer.mo.cursector.lightlevel / 255.0, scale: (0.7, 0.7));  
                   	PBHud_DrawImageManualAlpha("HUDBOT2F", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, cplayer.mo.cursector.lightlevel / 255.0, scale: (0.7, 0.7));
                    
                    PBHud_DrawImageManualAlpha("HUDTFLAR", (-35 - m32to0, -9 - m32to0) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, m0to1float * ( 1.0 - (cplayer.mo.cursector.lightlevel / 255.0)), scale: (0.7, 0.7));  

                    PBHud_DrawImageManualAlpha("HUDBFLAR", (-35 - m32to0, 9 + m32to0) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, m0to1float * ( 1.0 - (cplayer.mo.cursector.lightlevel / 255.0)), scale: (0.7, 0.7));

                    PBHud_DrawImageManualAlpha("HUDTFLA2", (35 + m32to0, -9 - m32to0) , DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, m0to1float * ( 1.0 - (cplayer.mo.cursector.lightlevel / 255.0)), scale: (0.7, 0.7));  
                   	PBHud_DrawImageManualAlpha("HUDBFLA2", (35 + m32to0, 9 + m32to0) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, m0to1float * ( 1.0 - (cplayer.mo.cursector.lightlevel / 255.0)), scale: (0.7, 0.7));
                    
                    PBHud_DrawImageManualAlpha("HUDTOP", (-35, -9) , DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP, m0to1Float, scale: (0.7, 0.7));  
                    PBHud_DrawImageManualAlpha("HUDBOTOM", (-35, 9) , DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM, m0to1Float, scale: (0.7, 0.7));   
                    PBHud_DrawImageManualAlpha("HUDT2P", (35, -9), DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, m0to1Float, scale: (0.7, 0.7));  
                    PBHud_DrawImageManualAlpha("HUDBOT2M", (35, 9) , DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, m0to1Float, scale: (0.7, 0.7));
               }
            }

            //Healthbar
												if(GetAirTime() < 700)
												{
													PBHud_DrawString(mBoldFont, "O²: "..(Formatnumber(((GetAirTime() / 7.0) * 100.0) / 100.0)).."%", (137, -90), DI_TEXT_ALIGN_LEFT, Font.FindFontColor('HUDBLUEBAR'));
												}
            PBHud_DrawImage("BARBACK1", (73, -50), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1);
            if(CheckInventory("PowerStrength")) {
				PBHud_DrawImage("BZRKHUD", (82, -51), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, box: (19, 19));
            }
            else if(Health > 100) {
				PBHud_DrawImage("OVERHUD", (82, -51), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, box: (19, 19));
            }
            else
			{
				PBHud_DrawImage("HLTHHUD", (82, -51), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, box: (19, 19));
			}
            PBHud_DrawBar("HPBAR", "BGBARL", IntHealth, min(MaxHealth, 100), (112, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
            if(Health <= 25) {
            	PBHud_DrawBar("HOBAR", "BGBARL", IntHealth, min(MaxHealth, 100), (112, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
            }
            if(Health > 100) {
            	PBHud_DrawBar("HLBAR", "BGBARL", IntHealth, min(MaxHealth, 100), (112, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
            }
            
            PBHud_DrawString(mDefaultFont, Formatnumber(Health), (205, -69), DI_TEXT_ALIGN_LEFT, Font.FindFontColor('HUDBLUEBAR'));
                
            //Armorbar
            PBHud_DrawImage("BARBACK2", (72, -17), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1);
            PBHud_DrawBar("APBAR", "BGBARL", IntArmor, min(MaxArmor, 100), (112, -30), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
            PBHud_DrawString(mDefaultFont, FormatNumber(Armor), (205, -48), DI_TEXT_ALIGN_LEFT, Font.FindFontColor('HUDGREENBAR2') );
            PBHud_DrawImage("ARMRHUD1", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
            if(GetArmorSavePercent() >= 32) {
                PBHud_DrawImage("ARMRHUD2", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
            }
            if(GetArmorSavePercent() >= 50) {
                PBHud_DrawImage("ARMRHUD3", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
            }
            if(GetArmorSavePercent() >= 70) {
                PBHud_DrawImage("ARMRHUD4", (81, -24), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, box: (20, 21));
            }
            
            PBHud_DrawString(mIndexFont, Formatnumber(GetArmorSavePercent()), (90, -38), DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
            
            //Mugshot
            PBHud_DrawTexture(GetMugShot(5), (25, -65), DI_ITEM_OFFSETS, scale: (1.25, 1.25));
            PBHud_DrawImage("EQUPBO", (16, -17), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
            
            //Keys
            DrawKeys((-40, 38));
            PBHud_DrawImage("KEYCRBOX", (-15, 17), DI_SCREEN_RIGHT_TOP | DI_ITEM_RIGHT_TOP);
			if(showLevelStats) {
				//Level Stats
				//time
				PBHud_DrawImage("1TIME", (26, 26), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, Level.TimeFormatted(), (35, 25), 0, Font.CR_YELLOW, scale: (0.5, 0.5));
				//kills
				PBHud_DrawImage("1KILLS", (26, 36), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, FormatNumber(Level.killed_monsters,0,5).." / "..FormatNumber(Level.total_monsters,0,5), (35, 35), 0, Font.CR_RED, scale: (0.5, 0.5));
				//items
				PBHud_DrawImage("1ITEMS", (26, 46), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, FormatNumber(Level.found_items,0,5).." / "..FormatNumber(Level.total_items,0,5), (35, 45), 0, Font.CR_GREEN, scale: (0.5, 0.5));
				//secrets
				PBHud_DrawImage("1SECRET", (26, 56), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (0.2, 0.2));
				PBHud_DrawString(mBoldFont, FormatNumber(Level.found_secrets,0,5).." / "..FormatNumber(Level.total_secrets,0,5), (35, 55), 0, Font.CR_PURPLE, scale: (0.5, 0.5));
				
				PBHud_DrawImage("LEVLSTAT", (15, 17), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, scale: (1.2, 1.0));
			}
			
            if(CPlayer.Health <= 0) {
              DeathSequence(true);
              PlayerWasDead = true;
            }
            
            if(CPlayer.Health >= 1 && PlayerWasDead) {
              DeathSequence(false);
              PlayerWasDead = false;
            }

            ////////////////////////////////////
            //         AMMOBAR HUD            //
            ////////////////////////////////////
            
            if(CPlayer.ReadyWeapon)
			{

                
                //Equipment
                if(CheckInventory("FragGrenadeSelected")) {
                    PBHud_DrawImage("HFRAGY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("HandGrenadeAmmo")), (-39, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("ProximityMineSelected")) {
                    PBHud_DrawImage("HMINEY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("MineAmmo")), (-39, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("StunGrenadeSelected")) {
                    PBHud_DrawImage("HSTUNY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("StunGrenadeAmmo")), (-39, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("RevGunSelected")) {
                    PBHud_DrawImage("HREVCY", (-24, -23), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, scale: (1.25, 1.25));
                    PBHud_DrawString(mIndexFont, Formatnumber(GetAmount("MiniHellRocketAmmo")), (-39, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }

                PBHud_DrawImage("EQUPBO", (-15, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);

                DrawReserveAmmoBar();
                
                //Ammo bars

                if(CheckWeaponSelected("Rifle")) 
                {
                    if(CheckInventory("DualWieldingDMRs"))
                    {
                        //Left Rifle Ammo
                        PBHud_DrawImage("BARBACY3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR1", "BGBARL", GetAmount("LeftRifleAmmo"), GetMaxAmount("LeftRifleAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftRifleAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                    }

                    if(CheckInventory("HDMRGrenadeMode"))
                    {
                        //Underbarrel Grenade Ammo
                        PBHud_DrawImage("BARBACR3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("RocketAmmo"), GetMaxAmount("RocketAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                    }
                }

                if(CheckWeaponSelected("PB_Carbine") && !CheckWeaponSelected("PB_LMG"))
                {
                    if(CheckInventory("DualWieldingCarbines"))
                    {
                        PBHud_DrawImage("BARBACY3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR1", "BGBARL", GetAmount("LeftXRifleAmmo"), GetMaxAmount("LeftXRifleAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftXRifleAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                    }
                }

                if(CheckWeaponSelected("PB_Pistol"))
                {
                    if(CheckInventory("DualWieldingPistols"))
                    {
                        PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR2", "BGBARL", GetAmount("SecondaryPistolAmmo"), GetMaxAmount("SecondaryPistolAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("SecondaryPistolAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_Revolver") && !CheckWeaponSelected("PB_Deagle"))
                {
                    if(CheckInventory("DualWieldingRevolver"))
                    {
                        PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR2", "BGBARL", GetAmount("LeftRevolverAmmo"), GetMaxAmount("LeftRevolverAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftRevolverAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_SMG"))
                {
                    if(CheckInventory("DualWieldingSMGs"))
                    {
                        PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR2", "BGBARL", GetAmount("LeftSMGAmmo"), GetMaxAmount("LeftSMGAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftSMGAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_Deagle"))
                {
                    if(CheckInventory("DualWieldingDeagles"))
                    {
                        PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR2", "BGBARL", GetAmount("LeftDeagleAmmo"), GetMaxAmount("LeftDeagleAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftDeagleAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_MP40"))
                {
                    if(CheckInventory("DualWieldingMP40"))
                    {
                        PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR2", "BGBARL", GetAmount("LeftMP40Ammo"), GetMaxAmount("LeftMP40Ammo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftMP40Ammo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_SSG") && !CheckWeaponSelected("PB_QuadSG"))
                {
                    if(CheckInventory("DualWieldingSSG"))
                    {
                        PBHud_DrawImage("BARBACO3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR3", "BGBARL", GetAmount("LeftSSGAmmo"), GetMaxAmount("LeftSSGAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftSSGAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_AUTOSHOTGUN"))
                {
                    if(CheckInventory("DualWieldingAutoshotguns"))
                    {
                        PBHud_DrawImage("BARBACO3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR3", "BGBARL", GetAmount("LeftASGAmmo"), GetMaxAmount("LeftASGAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftASGAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_QuadSG"))
                {
                    if(CheckInventory("QuadAkimboMode"))
                    {
                        PBHud_DrawImage("BARBACO3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR3", "BGBARL", GetAmount("LeftQSSGAmmoCounter"), GetMaxAmount("LeftQSSGAmmoCounter"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftQSSGAmmoCounter")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_M1Plasma"))
                {
                    if(CheckInventory("DualWieldingPlasma"))
                    {
                        PBHud_DrawImage("BARBACP3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR5", "BGBARL", GetAmount("LeftPlasmaAmmo"), GetMaxAmount("LeftPlasmaAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftPlasmaAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
                    }
                }

                if(CheckWeaponSelected("PB_M2Plasma"))
                {
                    if(CheckInventory("DualWieldingM2Plasma"))
                    {
                        PBHud_DrawImage("BARBACP3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR5", "BGBARL", GetAmount("LeftM2PlasmaAmmo"), GetMaxAmount("LeftM2PlasmaAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("LeftM2PlasmaAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
                    }
                }

                if(CheckWeaponSelected("PB_CryoRifle"))
                {
                    if(CheckInventory("CryoRiflePistolToken"))
                    {
                        PBHud_DrawImage("BARBACT3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                        
                        PBHud_DrawBar("ABAR2", "BGBARL", GetAmount("PrimaryPistolAmmo"), GetMaxAmount("PrimaryPistolAmmo"), (-100, -72), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                        PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PrimaryPistolAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }
                
                if(WeaponUsesAmmoType("PistolBullets"))
                {
                    DrawAmmoBar("BARBACT1", "BARBACT2", "BAMBAR2", "ABAR2", "ABAR2", "AMMOIC2", Font.CR_TAN);
                }
                if(WeaponUsesAmmoType("NewClip") && !CheckWeaponSelected("PB_MG42"))
                {
                    DrawAmmoBar("BARBACY1", "BARBACY2", "BAMBAR1", "ABAR1", "ABAR1", "AMMOIC1", Font.CR_YELLOW);
                }
                if(WeaponUsesAmmoType("NewShell"))
                {
                    DrawAmmoBar("BARBACO1", "BARBACO2", "BAMBAR3", "ABAR3", "ABAR3", "AMMOIC3", Font.CR_ORANGE);
                }
                if(WeaponUsesAmmoType("RocketAmmo"))
                {
                    DrawAmmoBar("BARBACR1", "BARBACR2", "BAMBAR4", "ABAR4", "ABAR4", "AMMOIC4", Font.CR_RED);
                }
                if(WeaponUsesAmmoType("Cell"))
                {
                    DrawAmmoBar("BARBACP1", "BARBACP2", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE);
                }
                if(WeaponUsesAmmoType("Gas") && !CheckWeaponSelected("PB_Chainsaw"))
                {
                    DrawAmmoBar("BARBACD1", "BARBACD2", "BAMBAR6", "ABAR6", "ABAR6", "AMMOIC6", Font.CR_ORANGE);
                }
                if(WeaponUsesAmmoType("Demonpower") && !CheckWeaponSelected("PB_Unmaker"))
                {
                    DrawAmmoBar("BARBACZ1", "BARBACZ2", "BAMBAR7", "ABAR7", "ABAR7", "AMMOIC7", Font.CR_DARKRED);
                }
                
                //Special weapons
                
                Ammo Primary, Secondary;
                [Primary, Secondary] = GetCurrentAmmo();
                
                if(CheckWeaponSelected("PB_Unmaker"))
                {
                    PBHud_DrawImage("BARBACZ1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                    PBHud_DrawImage("BARBACZ2", (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                    //Bars
                    PBHud_DrawBar("ABAR7", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-112, -51), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                    PBHud_DrawBar("ABAR7", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                    //Numbers
                    PBHud_DrawString(mDefaultFont, "SOULS", (-207, -69), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKRED);
                    PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKRED);
                    //Icon
                    PBHud_DrawImage("AMMOIC7", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
                }
                
                if(CheckWeaponSelected("PB_Chainsaw"))
                {
                    PBHud_DrawImage("BARBACD1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                    PBHud_DrawBar("ABAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                    //Numbers
                    PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    //Icon
                    PBHud_DrawImage("AMMOIC6", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));

                    if(CheckInventory("ChainsawResourceGather"))
                    {
                        PBHud_DrawImage("CHAINHL", (-90, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (32, 32));
                    }
                }
                
                if(CheckWeaponSelected("PB_MG42"))
                {
                    PBHud_DrawImage("BARBACY1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                    PBHud_DrawImage("BARBACR2", (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                    //Bars
                    PBHud_DrawBar("ABAR4", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-112, -51), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                    PBHud_DrawBar("ABAR1", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                    //Numbers
                    PBHud_DrawString(mDefaultFont, "HEAT", (-207, -69), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                    PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                    //Icon
                    PBHud_DrawImage("AMMOIC1", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
                }

                if(CheckWeaponSelected("PB_Flamethrower"))
                {
                    PBHud_DrawImage("BARBACD1", (-72, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1);
                    if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawImage("BARBACD2", (-73, -50), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1); }
                    //Bars
                    if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawBar("ABAR6", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-112, -51), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM); }
                    PBHud_DrawBar("ABAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-112, -30), 0, rtlAmmoBar, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                    //Numbers
                    if(!CheckInventory("FlamerUpgraded")) { PBHud_DrawString(mDefaultFont, FormatNumber(Secondary.Amount), (-207, -69), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE); }
                    PBHud_DrawString(mDefaultFont, Formatnumber(Primary.Amount), (-207, -48), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    //Icon
                    PBHud_DrawImage("AMMOIC6", (-77, -24), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (27, 19));
                }
            }
        }
    }
}