//Project Brutality FULLSCREEN HUD
//Converted from SBARINFO to ZScript by generic name guy

class PB_Hud_ZS : BaseStatusBar
{
    HUDFont mIndexFont;
    HUDFont mNumFont;
    HUDFont mSmallFont;

	DynamicValueInterpolator mHealthInterpolator;
	DynamicValueInterpolator mArmorInterpolator;

	InventoryBarState InvBar;
    
	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 240);
		
		mIndexFont = HUDFont.Create("INDEXFONT");
        mNumFont = HUDFont.Create("AANUM3");
        mSmallFont = HUDFont.Create("NEWSMALLFONT");
		
        mHealthInterpolator = DynamicValueInterpolator.Create(0, 0.10, 2, 64);
		mArmorInterpolator = DynamicValueInterpolator.Create(0, 0.10, 2, 64);

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
		mHealthInterpolator.Reset(0);
		mArmorInterpolator.Reset(0);
	}

	override void Tick()
	{
		Super.Tick();
        
        mHealthInterpolator.Update(CPlayer.Health);
		mArmorInterpolator.Update(GetAmount("BasicArmor"));
	}

    ////////////////////////////////////
    //       RESERVE AMMO HUD         //
    ////////////////////////////////////

    void ReserveAmmoNum(string ammoIcon, string ammoType, vector2 ammoIconPos, vector2 ammoNumPos, int fontTranslation)
    {
        DrawImage(ammoIcon, ammoIconPos + (-10, 0), DI_SCREEN_RIGHT_BOTTOM, 1, (14, 12));
        DrawString(mIndexFont, Formatnumber(GetAmount(ammoType)), ammoNumPos + (-10, 0), DI_TEXT_ALIGN_RIGHT, fontTranslation, scale: (1.2, 1.2));
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
            
            Ammo Primary, Secondary;
            [Primary, Secondary] = GetCurrentAmmo();

            //Backgrounds
            DrawImage(lowerBG, (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
            if(Secondary) { DrawImage(upperBG, (-121, -32), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22)); }
            DrawImage(barBorder, (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
            if(Secondary) { DrawImage(barBorder, (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1); }
            //Bars
            if(Secondary) { DrawBar(currentBar, "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-113, -39), 0, 0, DI_SCREEN_RIGHT_BOTTOM); }
            DrawBar(reserveBar, "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
            //Numbers
            if(Secondary) { DrawString(mNumFont, Formatnumber(Secondary.Amount), (-150, -50), DI_TEXT_ALIGN_RIGHT, fontTranslation); }
            DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, fontTranslation);
            //Icon
            DrawImage(ammoIcon, (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
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
                    icon = texman.checkfortexture("KEYYCB");
                }
                
                if(TexMan.GetName(icon) == "RKEYA0")
                {
                    icon = texman.checkfortexture("KEYYCR");
                }
                
                if(TexMan.GetName(icon) == "YKEYA0")
                {
                    icon = texman.checkfortexture("KEYYCY");
                }

                if(TexMan.GetName(icon) == "BSKUA0")
                {
                    icon = texman.checkfortexture("SKKYYB");
                }
                
                if(TexMan.GetName(icon) == "RSKUA0")
                {
                    icon = texman.checkfortexture("SKKYYR");
                }
                
                if(TexMan.GetName(icon) == "YSKUA0")
                {
                    icon = texman.checkfortexture("SKKYYY");
                }
                
                //Scale the icon up if needed
                size = TexMan.GetScaledSize(icon);
                scaleup = (size.x <= 11 && size.y <= 11);
                DrawTexture(icon, pos, DI_ITEM_LEFT_BOTTOM | DI_ITEM_CENTER, box: (22, 22), scaleup? (2, 2) : (1, 1));
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
			int IntHealth = mHealthInterpolator.GetValue();
			int MaxHealth = CPlayer.mo.GetMaxHealth();

			int Armor = GetAmount("BasicArmor");
			int IntArmor = mArmorInterpolator.GetValue();
			int MaxArmor = GetMaxAmount("BasicArmor");
            
            //Healthbar
            DrawImage("BARBACK1", (124, -32), DI_SCREEN_LEFT_BOTTOM, 1, (180, 22));
            if(CheckInventory("PowerStrength", 1)) {
                DrawImage("bzkhud", (70, -35), DI_SCREEN_LEFT_BOTTOM);
            }
            else 
            {
                DrawImage("hlthhud", (70, -35), DI_SCREEN_LEFT_BOTTOM);
            }
            DrawImage("HTBAR1", (115, -36), DI_SCREEN_LEFT_BOTTOM, 1);
            DrawBar("BLUEBAR", "BGBARL", IntHealth, min(MaxHealth, 100), (115, -39), 0, 0, DI_SCREEN_LEFT_BOTTOM);
            DrawString(mNumFont, Formatnumber(IntHealth), (185, -50), DI_TEXT_ALIGN_RIGHT, Font.FindFontColor('HUDBLUEBAR'));
                
            //Armorbar
            DrawImage("BARBACK2", (124, -12), DI_SCREEN_LEFT_BOTTOM, 1, (180, 22));
            DrawImage("ARBAR1", (115, -18), DI_SCREEN_LEFT_BOTTOM, 1);
            DrawBar("GRBAR", "BGBARL", IntArmor, min(MaxArmor, 100), (115, -21), 0, 0, DI_SCREEN_LEFT_BOTTOM);
            DrawString(mNumFont, Formatnumber(IntArmor), (185, -32), DI_TEXT_ALIGN_RIGHT, Font.FindFontColor('HUDGREENBAR'));
            DrawImage("armrhud", (70, -14), DI_SCREEN_LEFT_BOTTOM, 1, (17, 17));
            
            //mugshot
            DrawImage("EQUPCO", (30, -13), DI_SCREEN_LEFT_BOTTOM, 1, (600, 900));
            DrawTexture(GetMugShot(5), (13, -50), DI_ITEM_OFFSETS);
            DrawImage("EQUPCO", (30, -13), DI_SCREEN_LEFT_BOTTOM, 1, (600, 900));
            DrawKeys((12, -68));

            ////////////////////////////////////
            //         AMMOBAR HUD            //
            ////////////////////////////////////
            
            if(CPlayer.ReadyWeapon)
			{

                
                //Equipment
                if(CheckInventory("FragGrenadeSelected")) {
                    DrawImage("HFRAGY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    DrawString(mIndexFont, Formatnumber(GetAmount("HandGrenadeAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("ProximityMineSelected")) {
                    DrawImage("HMINEY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    DrawString(mIndexFont, Formatnumber(GetAmount("MineAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("StunGrenadeSelected")) {
                    DrawImage("HSTUNY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    DrawString(mIndexFont, Formatnumber(GetAmount("StunGrenadeAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }
                if(CheckInventory("RevGunSelected")) {
                    DrawImage("HREVCY", (-30, -15), DI_SCREEN_RIGHT_BOTTOM);
                    DrawString(mIndexFont, Formatnumber(GetAmount("MiniHellRocketAmmo")), (-16, -26), DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                }

                DrawImage("EQUPBO", (-30, -15), DI_SCREEN_RIGHT_BOTTOM, 1, (600, 900));

                DrawReserveAmmoBar();
                
                //Ammo bars


                //Rifle Modes
                if(CheckWeaponSelected("Rifle")) 
                {
                    if(CheckInventory("DualWieldingDMRs"))
                    {
                        //Left Rifle Ammo
                        DrawImage("BARBACY2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR1", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR1", "BGBARL", GetAmount("LeftRifleAmmo"), GetMaxAmount("LeftRifleAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftRifleAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                    }

                    if(CheckInventory("HDMRGrenadeMode"))
                    {
                        //Underbarrel Grenade Ammo
                        DrawImage("BARBACR2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR4", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR4", "BGBARL", GetAmount("RocketAmmo"), GetMaxAmount("RocketAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("RocketAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                        DrawImage("AMMOIC4", (-66, -55), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                    }
                }

                if(CheckWeaponSelected("PB_Carbine"))
                {
                    if(CheckInventory("DualWieldingCarbines"))
                    {
                        DrawImage("BARBACY2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR1", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR1", "BGBARL", GetAmount("LeftXRifleAmmo"), GetMaxAmount("LeftXRifleAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftXRifleAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                    }
                }

                if(CheckWeaponSelected("PB_Pistol"))
                {
                    if(CheckInventory("DualWieldingPistols"))
                    {
                        DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR2", "BGBARL", GetAmount("SecondaryPistolAmmo"), GetMaxAmount("SecondaryPistolAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("SecondaryPistolAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_Revolver"))
                {
                    if(CheckInventory("DualWieldingRevolver"))
                    {
                        DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR2", "BGBARL", GetAmount("LeftRevolverAmmo"), GetMaxAmount("LeftRevolverAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftRevolverAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_SMG"))
                {
                    if(CheckInventory("DualWieldingSMGs"))
                    {
                        DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR2", "BGBARL", GetAmount("LeftSMGAmmo"), GetMaxAmount("LeftSMGAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftSMGAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_Deagle"))
                {
                    if(CheckInventory("DualWieldingDeagles"))
                    {
                        DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR2", "BGBARL", GetAmount("LeftDeagleAmmo"), GetMaxAmount("LeftDeagleAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftDeagleAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_MP40"))
                {
                    if(CheckInventory("DualWieldingMP40"))
                    {
                        DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR2", "BGBARL", GetAmount("LeftMP40Ammo"), GetMaxAmount("LeftMP40Ammo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftMP40Ammo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
                    }
                }

                if(CheckWeaponSelected("PB_SSG"))
                {
                    if(CheckInventory("DualWieldingSSG"))
                    {
                        DrawImage("BARBACO2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR3", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR3", "BGBARL", GetAmount("LeftSSGAmmo"), GetMaxAmount("LeftSSGAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftSSGAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_AUTOSHOTGUN"))
                {
                    if(CheckInventory("DualWieldingAutoshotguns"))
                    {
                        DrawImage("BARBACO2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR3", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR3", "BGBARL", GetAmount("LeftASGAmmo"), GetMaxAmount("LeftASGAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftASGAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_QuadSG"))
                {
                    if(CheckInventory("QuadAkimboMode"))
                    {
                        DrawImage("BARBACO2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR3", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR3", "BGBARL", GetAmount("LeftQSSGAmmoCounter"), GetMaxAmount("LeftQSSGAmmoCounter"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftQSSGAmmoCounter")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    }
                }

                if(CheckWeaponSelected("PB_M1Plasma"))
                {
                    if(CheckInventory("DualWieldingPlasma"))
                    {
                        DrawImage("BARBACP2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR5", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR5", "BGBARL", GetAmount("LeftPlasmaAmmo"), GetMaxAmount("LeftPlasmaAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftPlasmaAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
                    }
                }

                if(CheckWeaponSelected("PB_M2Plasma"))
                {
                    if(CheckInventory("DualWieldingM2Plasma"))
                    {
                        DrawImage("BARBACP2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR5", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR5", "BGBARL", GetAmount("LeftM2PlasmaAmmo"), GetMaxAmount("LeftM2PlasmaAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(GetAmount("LeftM2PlasmaAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_PURPLE);
                    }
                }

                if(CheckWeaponSelected("PB_Freezer"))
                {
                    DrawImage("BARBACT2", (-121, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                    DrawImage("BAMBAR2", (-113, -54), DI_SCREEN_RIGHT_BOTTOM, 1);
                    DrawBar("CURBAR2", "BGBARL", GetAmount("PrimaryPistolAmmo"), GetMaxAmount("PrimaryPistolAmmo"), (-113, -57), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                    DrawString(mNumFont, Formatnumber(GetAmount("PrimaryPistolAmmo")), (-150, -68), DI_TEXT_ALIGN_RIGHT, Font.CR_TAN);
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
                    //Backgrounds
                    DrawImage("BARBACD1", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                    DrawImage("BARBACZ2", (-121, -32), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22)); 
                    DrawImage("BAMBAR6", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                    DrawImage("BAMBAR7", (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1); 
                    //Bars
                    DrawBar("RESBAR7", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-113, -39), 0, 0, DI_SCREEN_RIGHT_BOTTOM); 
                    DrawBar("RESBAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                    //Numbers
                    DrawString(mNumFont, Formatnumber(Secondary.Amount), (-150, -50), DI_TEXT_ALIGN_RIGHT, Font.CR_DarkRed); 
                    DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    //Icon
                    DrawImage("AMMOIC6", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                    DrawImage("AMMOIC7", (-66, -37), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                }
                
                if(CheckWeaponSelected("PB_Chainsaw"))
                {
                    DrawImage("BARBACD1", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                    DrawImage("BAMBAR6", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                    DrawBar("RESBAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                    DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    DrawImage("AMMOIC6", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));

                    if(CheckInventory("ChainsawResourceGather"))
                    {
                        DrawImage("CHAINHL", (-90, -36), DI_SCREEN_RIGHT_BOTTOM, 1, (32, 32));
                    }
                }
                
                if(CheckWeaponSelected("PB_MG42"))
                {
                    if(CheckWeaponSelected("PB_MG42"))
                    {
                        //DrawImage("BARBACR2", (-121, -32), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR4", (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("CURBAR4", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-113, -39), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mSmallFont, "HEAT", (-150, -50), DI_TEXT_ALIGN_RIGHT, Font.CR_RED, linespacing: 8);
                        DrawImage("BARBACY1", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                        DrawImage("BAMBAR1", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                        DrawBar("RESBAR1", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                        DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_YELLOW);
                        DrawImage("AMMOIC1", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                    }
                }

                if(CheckWeaponSelected("PB_Flamethrower"))
                {
                    DrawImage("BARBACD1", (-121, -12), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22));
                    if(!CheckInventory("FlamerUpgraded")) { DrawImage("BARBACD2", (-121, -32), DI_SCREEN_RIGHT_BOTTOM, 1, (180, 22)); }
                    DrawImage("BAMBAR6", (-113, -18), DI_SCREEN_RIGHT_BOTTOM, 1);
                    if(!CheckInventory("FlamerUpgraded")) { DrawImage("BAMBAR6", (-113, -36), DI_SCREEN_RIGHT_BOTTOM, 1); }
                    if(!CheckInventory("FlamerUpgraded")) { DrawBar("CURBAR6", "BGBARL", Secondary.Amount, Secondary.MaxAmount, (-113, -39), 0, 0, DI_SCREEN_RIGHT_BOTTOM); }
                    DrawBar("RESBAR6", "BGBARL", Primary.Amount, Primary.MaxAmount, (-113, -21), 0, 0, DI_SCREEN_RIGHT_BOTTOM);
                    if(!CheckInventory("FlamerUpgraded")) { DrawString(mNumFont, Formatnumber(Secondary.Amount), (-150, -50), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE); }
                    DrawString(mNumFont, Formatnumber(Primary.Amount), (-150, -32), DI_TEXT_ALIGN_RIGHT, Font.CR_ORANGE);
                    DrawImage("AMMOIC6", (-66, -17), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 17));
                }
            }
        }
    }
}