// Tokens
class SelectMinigun_Chaingun : Inventory {Default{Inventory.MaxAmount 1;}}
class SelectMinigun_Triple : Inventory {Default{Inventory.MaxAmount 1;}}
class SelectMinigun_Gatling : Inventory {Default{Inventory.MaxAmount 1;}}
class MinigunUpgraded : Inventory {Default{Inventory.MaxAmount 1;}}

// The Upgrade Item
class PB_MinigunUpgrade : PB_UpgradeItem
{
	//$Title Minigun Upgrade
	//$Category Project Brutality - Weapon Upgrades
    // SpawnID 9410
	Default 
    {
        Inventory.Pickupsound "CHGNPKUP";
        Inventory.PickupMessage "$PB_MINIGUN_UPGRADE_PICKUP";
        Tag "Minigun Upgrade";
        FloatBobStrength 0.5;
        Height 24;
        Scale 0.52;
        -INVENTORY.ALWAYSPICKUP;
        -COUNTITEM;
    }
	
	override bool TryPickup(in out Actor toucher) {
		if(toucher.FindInventory("PB_Minigun") && toucher.FindInventory("MinigunUpgraded") && toucher.CountInv("PB_HighCalMag") == toucher.GetAmmoCapacity("PB_HighCalMag")) {
			return false;
		}
		return super.TryPickup(toucher);
	}
	
	States
	{
		Spawn:
			VGUN A 0 NoDelay;
            8GUN A 10 A_PbvpFramework("VGUN");
            "####" "#" 0 A_PbvpInterpolate();
            LOOP;
		Pickup:
			TNT1 A 0 {
				A_GiveInventory("PB_Minigun");
                A_SetInventory("MinigunUpgraded",1);
			    A_SetWeaponTag("PB_Minigun","$PB_MINIGUN_UPGRADE_TAG");
			}
			Stop;
	}
}

// The Actual Weapon
class PB_Minigun : PB_Weapon
{
    Default
    {
        //$Title Minigun
        //$Category Project Brutality - Weapons
        //$Sprite MG0ZA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        // Game Doom
        // SpawnID 9400
        //Weapon.SelectionOrder 700;
        Weapon.AmmoType "PB_HighCalMag";
        Weapon.AmmoGive 30;
        Weapon.AmmoUse 0;
        Inventory.AltHUDIcon "MG0ZA0";
        PB_WeaponBase.OffsetRecoilX 3.5;
        PB_WeaponBase.OffsetRecoilY 2.2;
        PB_WeaponBase.UsesWheel 1;
        PB_WeaponBase.WheelInfo "PB_MinigunWheel";
        FloatBobStrength 0.5;
        Scale 0.52;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.PickupSound "CBOXPKUP";
        Inventory.PickupMessage "$PB_MINIGUN_PICKUP";
        Obituary "%o became Swiss Cheese by %k's Gatling Gun";
        AttackSound "none";
        Tag "$PB_MINIGUN_TAG";
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM;
        +WEAPON.AMMO_OPTIONAL;
        +WEAPON.NOAUTOFIRE;
        +FLOORCLIP;
        +DONTGIB;
    }
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    int mode;
    int internalheat; // Used for the glow overlay

    const TRIPLE_MODE_AMMOTAKE = 2;

    enum PB_Minigun_Mode {
        CHAINGUN_MODE,
        GATLING_MODE,
        TRIPLE_MODE
    }

    enum PB_Minigun_Overlays {
        MUZZLE_FLASH_LAYER3     =  -5,
        MUZZLE_FLASH_LAYER2     =  -4,
        MUZZLE_FLASH_LAYER      =  -3,
        AMMO_METER_LAYER        =   3,
        AMMO_BELT_IDLE_LAYER    =   4,
        AMMO_METER_SWITCH_LAYER =   5,
        GLOW_LAYER              =   9,
        DEATHDEALER_CORE_LAYER  =  10,
        FLASH_AMMO_METER_LAYER  = 1001
    }
   

//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    // Set Defaults
    override void PostBeginPlay()
    {
        mode = GATLING_MODE;
        super.PostBeginPlay();
    }

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    action bool Minigun_IsUpgraded()
    {
        return FindInventory("MinigunUpgraded");
    }

    action void Minigun_SetSprite(name l1 = "", name l2 = "")
    {
        name spriteToUse;
        if(Minigun_IsUpgraded() && l1 != "") 
            spriteToUse = l1;
        else if (Minigun_GetMode() == TRIPLE_MODE && l2 != "")
            spriteToUse = l2;

        if(spriteToUse != "")
            A_SetWeaponSpriteEx(spriteToUse);
    }

    // Helper functions
    action void Minigun_SetMode(PB_Minigun_Mode set)
    {
        invoker.mode = set;
    }

    action PB_Minigun_Mode Minigun_GetMode()
    {
        return invoker.mode;
    }

    action void Minigun_ClearOverlays()
    {
        A_ClearOverlays(AMMO_METER_LAYER,DEATHDEALER_CORE_LAYER);
    }

    // Glow and ammo belt overlays
    action void Minigun_Glow()
    {
        int heat = invoker.internalheat;
        int glowframe;

        if(heat>=20)
            A_SetWeaponSpriteEx("G10W");

        if      (heat >= 90) glowframe = 5;
        else if (heat >= 75) glowframe = 4;
        else if (heat >= 60) glowframe = 3;
        else if (heat >= 45) glowframe = 2;
        else if (heat >= 35) glowframe = 1;
        else if (heat >= 20) glowframe = 0;
        A_SetWeaponFrame(glowframe);
    }

    action void Minigun_AmmoMeter()
    {
        int amt = invoker.ammo1.amount;
        int ammoframe;

        if(amt>=120)
            A_SetWeaponSpriteEx("MG05");

        if      (amt == 600) ammoframe = 0;
        else if (amt >= 540) ammoframe = 1;
        else if (amt >= 480) ammoframe = 2;
        else if (amt >= 420) ammoframe = 3;
        else if (amt >= 360) ammoframe = 4;
        else if (amt >= 300) ammoframe = 5;
        else if (amt >= 240) ammoframe = 6;
        else if (amt >= 180) ammoframe = 7;
        else if (amt >= 120) ammoframe = 8;
        A_SetWeaponFrame(ammoframe);
    }

    // Weapon special logic
    action state Minigun_HandleSpecial()
    {
        int mode = Minigun_GetMode();
        int tokens = Minigun_GetTokens();

        A_Setinventory("GoWeaponSpecialAbility",0);
        Minigun_ClearOverlays();
        A_StopSound(5);
        A_StopSound(1);

        if(mode == tokens)
        {
            A_Print("$PB_ALREADYSELECTED");
            return resolvestate("Ready3");
        }

        switch(tokens)
        {
            case CHAINGUN_MODE:
                Minigun_ClearTokens();
                if(mode == TRIPLE_MODE)
                {
                    A_Print("$PB_MINIGUN_CHAINGUN");
                    Minigun_SetMode(tokens);
                    A_StartSound("8HAINSW3", CHAN_AUTO);
                    return resolvestate("SwitchToChaingun_Upgraded");
                }
                
                A_Print("$PB_MINIGUN_CHAINGUN");
                Minigun_SetMode(tokens);
                A_StartSound("weapons/minigun/respect3", CHAN_AUTO);
                return resolvestate("RealReady");

            case GATLING_MODE:
                Minigun_ClearTokens();
                if(mode == TRIPLE_MODE)
                {
                    A_Print("$PB_MINIGUN_GATLING");
                    Minigun_SetMode(tokens);
                    A_StartSound("8HAINSW3", CHAN_AUTO);
                    return resolvestate("SwitchToGatling_Upgraded");
                }

                A_Print("$PB_MINIGUN_GATLING");
                Minigun_SetMode(tokens);
                A_StartSound("weapons/minigun/respect3", CHAN_AUTO);
                return resolvestate("RealReady");

            case TRIPLE_MODE:
                A_ClearOverlays(DEATHDEALER_CORE_LAYER);
                Minigun_ClearTokens();

                if(!Minigun_IsUpgraded()) 
                {
                    A_Print("$PB_NOTAVAILABLE");
                    return resolvestate("RealReady");
                }

                invoker.internalheat = 0;
                Minigun_SetMode(tokens);
                A_StartSound("8HAINSW2", CHAN_AUTO);
                A_Print("$PB_MINIGUN_TRIPLE");
                return resolvestate("SwitchToDeathDealer");
        }
        return resolvestate(null);
    }

    // Convert tokens into int for easier use
    action PB_Minigun_Mode Minigun_GetTokens()
    {
        if(FindInventory("SelectMinigun_Chaingun"))
            return CHAINGUN_MODE;
        else if(FindInventory("SelectMinigun_Gatling"))
            return GATLING_MODE;
        else //if(FindInventory("SelectMinigun_Triple"))
            return TRIPLE_MODE;
    }

    // Clear tokens
    action void Minigun_ClearTokens()
    {
        A_SetInventory("SelectMinigun_Chaingun",0);
        A_SetInventory("SelectMinigun_Gatling",0);
        A_SetInventory("SelectMinigun_Triple",0);
    }

    // Firing Functions
    action void Minigun_StartFire()
    {
        A_WeaponOffset(0,32);
        A_SetRoll(0);
        PB_HandleCrosshair(75);
        A_SetInventory("PB_LockScreenTilt",0);
        if(Minigun_GetMode() == CHAINGUN_MODE) 
            A_StartSound("weapons/minigun/chaingunmode/spinup", CHAN_5);
        else 
            A_StartSound("CHAINSTA", CHAN_5);
    }

    action void Minigun_NormalFire(int tic)
    {
        Minigun_SetSprite("UCHF");
        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        A_FlashOverlay(MUZZLE_FLASH_LAYER);
        A_Overlay(GLOW_LAYER,"Glow");
        switch(tic)
        {
            case 1: case 5:
                A_TakeInventory(invoker.ammo1.getClassName(), 1, TIF_NOTAKEINFINITE);
                PB_FireBullets("PB_556x45mmAP", 1, 3, 0, 0, 3);
                PB_GunSmoke_Basic(0,0,2);//A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
                PB_DynamicTail("lmg", "lmg");
                A_AlertMonsters();
                PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);
                PB_SpawnCasing("LMGBeltLink", 19,-13,24,0,-frandom(1,2),frandom(-3,3), false);
                PB_FireOffset();
                invoker.internalheat++;
                break;

            case 2: case 4: case 6: case 8:
                A_OverlayOffset(AMMO_METER_LAYER,-0.5,0.5);
                A_OverlayFlags(MUZZLE_FLASH_LAYER,PSPF_FLIP|PSPF_MIRROR,true);
                PB_WeaponRecoil(-0.6,frandom(1.6, -1.6));
                break;
                
            case 3: case 7:
                A_TakeInventory(invoker.ammo1.getClassName(), 1, TIF_NOTAKEINFINITE);
                PB_FireBullets("PB_556x45mmAP", 1, 3, 0, 0, 3);
                PB_DynamicTail("lmg", "lmg");
                A_AlertMonsters();
                PB_FireOffset();
                invoker.internalheat++;
                break;
        }        
    }
    
    action state Minigun_SpinDown()
    {
        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        Minigun_SetSprite("UCHG");
        if (invoker.ammo1.amount > 0 ) 
        {
            A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
            A_FireCustomMissile("SmokeSpawner11",0,0,0,0);
        }
        A_Overlay(GLOW_LAYER,"Glow");
        return A_DoPBWeaponAction();
    }

    action void Minigun_ChaingunFire(int tic)
    {
        name spriteToUse = tic == 3 || tic == 6 ? "UCHG" : "UCHF";
        Minigun_SetSprite(spriteToUse);

        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        A_Overlay(GLOW_LAYER,"Glow");
        switch(tic)
        {
            case 1: case 4:
                PB_FireOffset();
                A_StartSound("weapons/minigun/chaingunmode/fire", CHAN_WEAPON, CHANF_OVERLAP);
                A_TakeInventory(invoker.ammo1.getClassName(), 1, TIF_NOTAKEINFINITE);
                PB_FireBullets("PB_556x45mmAP", 1, 3, 0, 0, 3);
                PB_GunSmoke_Basic(0,0,2);//A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
                PB_DynamicTail("lmg", "lmg");
                A_AlertMonsters();
                A_FlashOverlay(MUZZLE_FLASH_LAYER);
                PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);

                if(tic == 4)
                    PB_SpawnCasing("LMGBeltLink", 19,-13,24,0,-frandom(1,2),frandom(-3,3), false);

                invoker.internalheat++;
                break;

            case 2: case 5:
                A_OverlayOffset(AMMO_METER_LAYER,-0.5,0.5);
                A_FlashOverlay(MUZZLE_FLASH_LAYER);
                PB_WeaponRecoil(-0.4,frandom(1.2, -1.2));
                break;

            case 3: case 6:
                break;

        }
    }

    action state Minigun_ChaingunSpinDown()
    {
        Minigun_SetSprite("UCHG");
        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");

        if(invoker.ammo1.amount > 0) 
            A_FireCustomMissile("SmokeSpawner11",0,0,0,0);
            
        A_Overlay(GLOW_LAYER,"Glow");
        return A_DoPBWeaponAction();
    }

    action void Minigun_TripleFire(int tic)
    {
        bool isEven        = !(tic & 1);
        int overlayOffsetX = isEven ? -28 : -27;
        int overlayOffsetY = isEven ?   1 :   0;

        PB_FireOffset();

        if(!isEven)
        {
            PB_GunSmoke_Basic(0,0,2);
            PB_GunSmoke_Basic(5,0,-1);
            PB_GunSmoke_Basic(-5,0,-1);
        }

        PB_DynamicTail("lmg", "lmg");
        A_AlertMonsters();

        for(int i = 0; i < 2; i++)
        {
            PB_SpawnCasing("PB_EmptyBrass", 19,-19,24,0,-frandom(3,6),frandom(-1,1), false);
            PB_FireBullets("PB_556x45mmAP", 1, 5, 0, 0, 5);
        }

        PB_SpawnCasing("LMGBeltLink", 19,-19,24,0,-frandom(1,2),frandom(-3,3), false);
        
        if(isEven)
            PB_SpawnCasing("LMGBeltLink", 19,-19,24,0,-frandom(1,2),frandom(-3,3), false);

        A_TakeInventory(invoker.ammo1.getClassName(),TRIPLE_MODE_AMMOTAKE, TIF_NOTAKEINFINITE);

        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        A_Overlayoffset(AMMO_METER_LAYER,overlayOffsetX,overlayOffsetY);

        A_FlashOverlay(MUZZLE_FLASH_LAYER);
        A_FlashOverlay(MUZZLE_FLASH_LAYER2);
        A_FlashOverlay(MUZZLE_FLASH_LAYER3);
        A_OverlayOffset(MUZZLE_FLASH_LAYER2,-27,14);
        A_OverlayOffset(MUZZLE_FLASH_LAYER3,27,14);

        A_OverlayOffset(DEATHDEALER_CORE_LAYER,0,overlayOffsetY);

        PB_WeaponRecoil(-0.8,frandom(2.4, -2.4));
    }

    action void Minigun_TripleSpinDown()
    {
        if(invoker.ammo1.amount > 0) 
            A_FireCustomMissile("SmokeSpawner11",0,0,0,0);
        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
        A_OverlayOffset(AMMO_BELT_IDLE_LAYER,22,0,WOF_ADD);
        PB_ReFire("Fire_DeathDealer");
    }

    // Alt fire functions
    action void Minigun_AltFire(int tic)
    {
        Minigun_SetSprite("UCHF");
        A_TakeInventory(invoker.ammo1.getClassName(), 1, TIF_NOTAKEINFINITE);
        PB_FireBullets("PB_556x45mmAP", 1, 5, 0, 0, 5);

        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        A_FlashOverlay(MUZZLE_FLASH_LAYER);

        PB_DynamicTail("lmg", "lmg");
        A_AlertMonsters();

        invoker.internalheat++;
        A_Overlay(GLOW_LAYER,"Glow");
        
        switch(tic)
        {
            case 1: case 4:
                PB_FireOffset();
                PB_GunSmoke_Basic(0,0,2);//A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);

                if(tic == 4)
                    A_OverlayFlags(MUZZLE_FLASH_LAYER,PSPF_FLIP|PSPF_MIRROR,true);

                PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);
                PB_SpawnCasing("LMGBeltLink", 19,-13,24,0,-frandom(1,2),frandom(-3,3), false);
                PB_WeaponRecoil(-0.8,frandom(2.4, -2.4));
                break;

            case 2: case 5:
                if(tic == 2)
                    A_OverlayFlags(MUZZLE_FLASH_LAYER,PSPF_FLIP|PSPF_MIRROR,true);
                    
                PB_WeaponRecoil(-0.8,frandom(2.4, -2.4));
                break;

            case 3:
                break;

            case 6:
                A_OverlayFlags(MUZZLE_FLASH_LAYER,PSPF_FLIP|PSPF_MIRROR,true);
                break;

            case 7:
                PB_FireOffset();
                PB_WeaponRecoil(-0.8,frandom(2.4, -2.4));
                break;

            case 8:
                PB_GunSmoke_Basic(0,0,2);//A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
                A_OverlayFlags(MUZZLE_FLASH_LAYER,PSPF_FLIP|PSPF_MIRROR,true);

                PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);
                PB_SpawnCasing("LMGBeltLink", 19,-13,24,0,-frandom(1,2),frandom(-3,3), false);
                break;
            
        }
    }

    action void Minigun_AltChaingun(int tic)
    {
        name spriteToUse = tic == 3 || tic == 6 || tic == 7 ? "UCHG" : "UCHF";
        Minigun_SetSprite(spriteToUse);
        A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
        A_Overlay(GLOW_LAYER,"Glow");

        switch(tic)
        {
            case 1: case 4:
                PB_FireOffset();
                A_StartSound("weapons/minigun/chaingunmode/fire", CHAN_WEAPON, CHANF_OVERLAP);
                A_TakeInventory(invoker.ammo1.getClassName(), 1, TIF_NOTAKEINFINITE);
                PB_FireBullets("PB_556x45mmAP", 1, 1, 0, 0, 1);
                PB_GunSmoke_Basic(0,0,2);//A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
                PB_DynamicTail("lmg", "lmg");
                A_AlertMonsters();
                A_FlashOverlay(MUZZLE_FLASH_LAYER);
                PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);
                if(tic == 4)
                    PB_SpawnCasing("LMGBeltLink", 19,-13,24,0,-frandom(1,2),frandom(-3,3), false);
                invoker.internalheat++;
                break;

            case 2: case 5:
                A_OverlayOffset(AMMO_METER_LAYER,-0.5,0.5);
                A_FlashOverlay(MUZZLE_FLASH_LAYER);
                PB_WeaponRecoil(-0.4,frandom(1.2, -1.2));
                break;

            case 3: case 6:
                break;

            case 7:
                if (invoker.ammo1.amount > 0 ) 
                    A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                break;
        }
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            VG0Z A 0 NoDelay;
			MG0Z A 10 A_PbvpFramework("VG0Z");
			"####" "#" 0 A_PbvpInterpolate();
			LOOP;
        WeaponRespect:
            TNT1 A 0 {
				A_SetCrosshair(-1);
				A_Setinventory("PB_LockScreenTilt",1);
				A_StartSound("Ironsights", CHAN_AUTO);
			}
			TNT1 A 0 A_JumpIf(Minigun_IsUpgraded(),"SelectAnimation");
			MG10 ABCDEFGHIJKLMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("CHGNPKUP", CHAN_AUTO);
			MG10 QRSTUVWXYZ 1 A_DoPBWeaponAction();
			MG11 ABCDEFGHIJKLMNO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/minigun/respect1", CHAN_AUTO);
			MG11 PQRSTUVWXYZ 1 A_DoPBWeaponAction();
			MG12 ABCDEFGHIJKLMNOPQRS 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/minigun/respect4", CHAN_AUTO);
			MG12 TUVWXYZ 1 A_DoPBWeaponAction();
			MG13 ABC 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/minigun/chaingunmode/spinup", CHAN_AUTO);
			MG13 DEFGHIJKLMNO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/minigun/chaingunmode/spin", CHAN_AUTO);
			MG13 PQRSTUVWXYZ 1 A_DoPBWeaponAction();
			MG14 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			MG15 ABC 1 A_DoPBWeaponAction();
			Goto Ready3;
        Deselect:
            TNT1 A 0 {
                Minigun_ClearOverlays();
                A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                A_OverlayOffset(AMMO_METER_LAYER,1,1);

                if (Minigun_GetMode() == TRIPLE_MODE)
                    A_OverlayOffset(AMMO_METER_LAYER,-26,1);

                A_WeaponOffset(0,32);
                A_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
                //A_ZoomFactor(1.0);
                A_StopSound(5);
                A_StopSound(1);
                invoker.internalheat = 0;
                SetPlayerProperty(0,0,0);
            }
            
            MG04 DCBA 1 Minigun_SetSprite("MG23","MG24");
            TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
            Wait;

        Select:
            TNT1 A 0 {
			    PB_HandleCrosshair(75);
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeaponRaise("weapons/minigun/respect1");
                invoker.internalheat = 0;
		        A_Overlay(GLOW_LAYER,"Glow");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
			MG23 A 0;
			MG24 A 0;
			MG04 ABC 1 Minigun_SetSprite("MG23","MG24");
			TNT1 A 0 {
				A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
				A_OverlayOffset(AMMO_METER_LAYER,1,1);
                if(Minigun_GetMode() == TRIPLE_MODE)
                    A_OverlayOffset(AMMO_METER_LAYER,-26,1);
			}
			MG04 D 1 Minigun_SetSprite("MG23","MG24");
        // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
            Ready3:
            RealReady:
                TNT1 A 0 {
                    A_SetRoll(0);
                    PB_HandleCrosshair(75);
                    A_SetInventory("PB_LockScreenTilt",0);
                }
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == TRIPLE_MODE, "Ready_DeathDealer");
			    TNT1 A 0 A_JumpIf(Minigun_IsUpgraded(),"RealReady_Upgraded");
            ReadyToFire:
                //Not Upgraded, Idle
			    TNT1 A 0 A_JumpIf(Minigun_IsUpgraded(),"RealReady_Upgraded");
                CHAG A 1 {
                    if (CountInv("PB_HighCalMag") > 0 ) { A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle"); }
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlay(GLOW_LAYER,"Glow");
                    invoker.internalheat--;
                    return A_DoPBWeaponAction();
                }
                Loop;
            RealReady_Upgraded:
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == TRIPLE_MODE, "Ready_DeathDealer");
            ReadyToFire_Upgraded:
            ReadyToFire2: //To make the kicking animation work
                //Upgraded, Idle
                UCHG A 1 {
                    if (CountInv("PB_HighCalMag") > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlay(GLOW_LAYER,"Glow");
                    invoker.internalheat--;
                    return A_DoPBWeaponAction();
                }
                Loop;

            Ready_DeathDealer:
                TNT1 A 0 {
                    A_SetRoll(0);
                    PB_HandleCrosshair(75);
                    A_SetInventory("PB_LockScreenTilt",0);
                    A_Overlay(DEATHDEALER_CORE_LAYER,"DeathDealerCore");
                }
            ReadyToFire_DeathDealer:
            Ready4: //To make the kicking animation work
                8HAF A 0 A_JumpIf(Minigun_GetMode() != TRIPLE_MODE, "ReadyToFire");
                8HAF A 1 {
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                    A_OverlayOffset(AMMO_BELT_IDLE_LAYER,22,0,WOF_ADD);

                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
                    return A_DoPBWeaponAction();
                }
                Loop;
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
            Fire:
                TNT1 A 0 Minigun_StartFire();
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == TRIPLE_MODE, "Fire_DeathDealer");
                CHAG ABCDEFGH 1 {
                    A_Overlay(GLOW_LAYER,"Glow");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    Minigun_SetSprite("UCHG");
                }
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == CHAINGUN_MODE, "Fire_Chaingun");
                TNT1 A 0 {
                    A_StartSound("weapons/minigunfire", CHAN_WEAPON, CHANF_LOOPING);
                    A_StartSound("CHAINSPI", CHAN_5, CHANF_LOOPING);
                    A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltAnimation");
                }
            Hold:
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin",1,false,false);
                CHAF A 1 BRIGHT Minigun_NormalFire(1);
                CHAF B 1 BRIGHT Minigun_NormalFire(2);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin",1,false,false);
                CHAF C 1 BRIGHT Minigun_NormalFire(3);
                CHAF D 1 BRIGHT Minigun_NormalFire(4);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin",1,false,false);
                CHAF E 1 BRIGHT Minigun_NormalFire(5);
                CHAF F 1 BRIGHT Minigun_NormalFire(6);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin",1,false,false);
                CHAF G 1 BRIGHT Minigun_NormalFire(7);
                CHAF H 1 BRIGHT Minigun_NormalFire(8);
                TNT1 A 0 PB_ReFire("Hold");
            SpinDown:
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == CHAINGUN_MODE,"SpinDown_Chaingun");
                TNT1 A 0 {
                    A_ClearOverlays(AMMO_BELT_IDLE_LAYER,AMMO_BELT_IDLE_LAYER);
                    A_StopSound(5);
                    A_StopSound(1);
                    A_StartSound("CHAINSTO", CHAN_5);
                    A_Overlay(GLOW_LAYER,"Glow");
                }
                CHAG ABCD 1 Minigun_SpinDown();
                CHAG EEFFGGHH 1 Minigun_SpinDown();
                CHAG AAABBBCCCDDD 1 Minigun_SpinDown();
                CHAG EEEEFFFFGGGGHHHH 1 Minigun_SpinDown();
                goto RealReady;

            Fire_Chaingun:
                TNT1 A 0 {
                    A_StartSound("weapons/minigun/chaingunmode/spin", CHAN_5, CHANF_LOOPING);
                    A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltChaingun");
                    //A_ZoomFactor(0.980);
                }
            Hold_Chaingun:
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin",1,false,false);
                CHAF A 1 BRIGHT Minigun_ChaingunFire(1);
                CHAF B 1 BRIGHT Minigun_ChaingunFire(2);
                CHAG CD 1 Minigun_ChaingunFire(3);
                //CHAG C 1
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin",1,false,false);
                CHAF E 1 BRIGHT Minigun_ChaingunFire(4);
                CHAF F 1 BRIGHT Minigun_ChaingunFire(5);
                CHAG GH 1 Minigun_ChaingunFire(6);
                TNT1 A 0 PB_ReFire("Hold_Chaingun");
            SpinDown_Chaingun:
            //Stop firing chaingun
                TNT1 A 0 {
                    A_ClearOverlays(AMMO_BELT_IDLE_LAYER,AMMO_BELT_IDLE_LAYER);
                    A_StartSound("weapons/minigun/chaingunmode/spindown", CHAN_5);
                }
                CHAG AABB 1 Minigun_ChaingunSpinDown();
                CHAG CCDD 1 Minigun_ChaingunSpinDown();
                CHAG EEFFF 1 Minigun_ChaingunSpinDown();
                CHAG GGGH 1 Minigun_ChaingunSpinDown();
                CHAG HH 1 Minigun_ChaingunSpinDown();
                goto RealReady;

            EmptySpin_DeathDealer:
                TNT1 A 0 {
                    A_StopSound(CHAN_WEAPON);
                    A_ClearOverlays(AMMO_BELT_IDLE_LAYER,AMMO_BELT_IDLE_LAYER);
                }
                8HAF A 1 {
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
                }
                8HAF BCDEFGH 1 {
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
                    A_StartSound("weapons/empty",0);
                }
                TNT1 A 0 PB_Refire("Hold_DeathDealer");
                Goto SpinDown_DeathDealer;

            Fire_DeathDealer:
                TNT1 A 0 A_StartSound("DTHDLRST",CHAN_6);
                8HAF ABCDEFGH 1 {
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
                }
                TNT1 A 0 {
                    A_StopSound(CHAN_6);
                    A_StartSound("DTHDRSN", CHAN_5, CHANF_LOOPING);
                    A_StartSound("8HAINFIR", CHAN_WEAPON, CHANF_LOOPING);
                    A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltAnimation");
                    A_OverlayOffset(AMMO_BELT_IDLE_LAYER,22,0);
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0);
                }
            Hold_DeathDealer:
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF A 1 BRIGHT Minigun_TripleFire(1);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF B 1 BRIGHT Minigun_TripleFire(2);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF C 1 BRIGHT Minigun_TripleFire(3);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF D 1 BRIGHT Minigun_TripleFire(4);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF E 1 BRIGHT Minigun_TripleFire(5);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF F 1 BRIGHT Minigun_TripleFire(6);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF G 1 BRIGHT Minigun_TripleFire(7);
                TNT1 A 0 PB_jumpIfNoAmmo("EmptySpin_DeathDealer",TRIPLE_MODE_AMMOTAKE,false,false);
                8HBF H 1 BRIGHT Minigun_TripleFire(8);
                TNT1 A 0 PB_ReFire("Hold_DeathDealer");
            SpinDown_DeathDealer:
                TNT1 A 0 {
                    A_StopSound(1);
                    A_StopSound(5);
                    A_OverlayOffset(DEATHDEALER_CORE_LAYER,0,0);
                    A_StartSound("CHAINSTO", CHAN_5,CHANF_OVERLAP);
                    A_StartSound("DTHDLRSP", CHAN_5,CHANF_OVERLAP);
                }
                8HAF ABCD 1 Minigun_TripleSpinDown();
                8HAF EEFFGGHHAABB 1 Minigun_TripleSpinDown();
                8HAF CCCDDDEEEFFFGGGHHH 1 Minigun_TripleSpinDown();
                goto ReadyToFire_DeathDealer;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
            Altfire:
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == TRIPLE_MODE, "ReadyToFire_DeathDealer");
                TNT1 A 0 Minigun_StartFire();
                UCHG ABCDEFGH 0;
                UCHF ABCDEFG 0;
                CHAG ABCDEFGH 1 {
                    A_Overlay(GLOW_LAYER,"Glow");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    Minigun_SetSprite("UCHG");
                }
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == CHAINGUN_MODE, "Altfire_ChainGun");
                TNT1 A 0 {
                    A_StartSound("weapons/minigunfirefast", CHAN_WEAPON, CHANF_LOOPING);
                    A_StartSound("CHAINSPI", CHAN_5, CHANF_LOOPING);
                    A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltAnimation");
                }
            AltHold:
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                TNT1 A 0 A_JumpIf(Minigun_GetMode() == CHAINGUN_MODE, "Hold_Chaingun");
                CHAF A 1 BRIGHT Minigun_AltFire(1);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF B 1 BRIGHT Minigun_AltFire(2);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF C 1 BRIGHT Minigun_AltFire(3);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF D 1 BRIGHT Minigun_AltFire(4);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF E 1 BRIGHT Minigun_AltFire(5);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF F 1 BRIGHT Minigun_AltFire(6);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF G 1 BRIGHT Minigun_AltFire(7);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF H 1 BRIGHT Minigun_AltFire(8);
                TNT1 A 0 PB_ReFire("AltHold");
                Goto SpinDown;

            Altfire_Chaingun:
                TNT1 A 0 {
                    A_WeaponOffset(0,32);
                    A_SetRoll(0);
                    PB_HandleCrosshair(75);
                    A_SetInventory("PB_LockScreenTilt",0);
                    A_StartSound("weapons/minigun/chaingunmode/spin", CHAN_5, CHANF_LOOPING);
                    A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltChaingun");
                }
            AltHold_Chaingun:
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                CHAF A 1 BRIGHT Minigun_AltChaingun(1);
                CHAF B 1 BRIGHT Minigun_AltChaingun(2);
                CHAG CD 1 Minigun_AltChaingun(3);
                TNT1 A 0 PB_jumpIfNoAmmo("AltEmptySpin",1,false,false);
                //CHAG C 1
                CHAF E 1 BRIGHT Minigun_AltChaingun(4);
                CHAF F 1 BRIGHT Minigun_AltChaingun(5);
                CHAG GH 1 Minigun_AltChaingun(6);
                CHAG ABCDEFGH 1 Minigun_AltChaingun(7);
                TNT1 A 0 PB_ReFire("Altfire_Chaingun");
                Goto SpinDown_Chaingun;

            EmptySpin:
                TNT1 A 0 {
                    A_StopSound(CHAN_WEAPON);
                    A_ClearOverlays(AMMO_BELT_IDLE_LAYER,AMMO_BELT_IDLE_LAYER);
                }
                CHAG ABCD 1 {
                    A_Overlay(GLOW_LAYER,"Glow");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    Minigun_SetSprite("UCHG");
                }
                TNT1 A 0 A_StartSound("weapons/empty",0);
                CHAG EFGH 1 {
                    A_Overlay(GLOW_LAYER,"Glow");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    Minigun_SetSprite("UCHG");
                }
                TNT1 A 0 PB_Refire("Hold");
                Goto SpinDown;

            AltEmptySpin:
                TNT1 A 0 {
                    A_StopSound(CHAN_WEAPON);
                    A_ClearOverlays(AMMO_BELT_IDLE_LAYER,AMMO_BELT_IDLE_LAYER);
                }
                CHAG ABCD 1 {
                    A_Overlay(GLOW_LAYER,"Glow");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    Minigun_SetSprite("UCHG");
                }
                TNT1 A 0 A_StartSound("weapons/empty",0);
                CHAG EFGH 1 {
                    A_Overlay(GLOW_LAYER,"Glow");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    Minigun_SetSprite("UCHG");
                }
                TNT1 A 0 PB_Refire("AltHold");
                Goto SpinDown;

            
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
            WeaponSpecial:
                TNT1 A 0 Minigun_HandleSpecial();
            SwitchToChaingun_Upgraded:
                8HAF ABCDE 1 {
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");

                    A_OverlayOffset(AMMO_BELT_IDLE_LAYER,22,0,WOF_ADD);
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
                }
                TNT1 A 0 {
                    A_ClearOverlays(AMMO_METER_LAYER,AMMO_BELT_IDLE_LAYER);
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltSwitchBack");
                    A_Overlay(AMMO_METER_SWITCH_LAYER,"AmmoMeterOverlaySwitchBack");
                }
                1CHT LKJIHGFEDCBA 1;
                UCHG EDCBA 1 {
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                }
                Goto RealReady;

            SwitchToGatling_Upgraded:
                8HAF ABCDE 1 {
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                    A_OverlayOffset(AMMO_BELT_IDLE_LAYER,22,0,WOF_ADD);
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
                }
                TNT1 A 0 {
                    A_ClearOverlays(AMMO_METER_LAYER,AMMO_BELT_IDLE_LAYER);
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltSwitchBack");
                    A_Overlay(AMMO_METER_SWITCH_LAYER,"AmmoMeterOverlaySwitchBack");
                }
                1CHT LKJIHGFEDCBA 1;
                UCHG EDCBA 1 {
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                }
                Goto RealReady;
                
            SwitchToDeathDealer:
                UCHG ABCDE 1 {
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                }
                TNT1 A 0 {
                    A_ClearOverlays(AMMO_METER_LAYER,4);
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltSwitch");
                    A_Overlay(AMMO_METER_SWITCH_LAYER,"AmmoMeterOverlaySwitch");
                }
                1CHT ABCDEFGHIJKL 1;
                8HAF EDCBA 1 {
                    if (invoker.ammo1.amount > 0 ) 
                        A_Overlay(AMMO_BELT_IDLE_LAYER,"AmmoBeltIdle");
                    A_OverlayOffset(AMMO_BELT_IDLE_LAYER,22,0,WOF_ADD);
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_Overlayoffset(AMMO_METER_LAYER,-27,0,WOF_ADD);
                }
                Goto Ready_DeathDealer;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
            AmmoMeterOverlaySwitchBack:
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-4);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-6);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-8);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-10);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-22,-10);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-16,-9);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-7,-7);}
                1CHT M 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-1,-6);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,-4);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,-2);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,-1);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,0);}
                Stop;
            AmmoBeltSwitchBack:
                MG09 LKJIHGFEDCBA 1;
                Stop;

            AmmoMeterOverlaySwitch:
		        TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,0);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,-1);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,-2);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,0,-4);}
                1CHT M 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-1,-6);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-7,-7);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-16,-9);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-22,-10);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-10);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-8);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-6);}
                TNT1 A 1 {A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay"); A_OverlayOffset(3,-27,-4);}
                Stop;
            AmmoBeltSwitch:
                MG09 ABCDEFGHIJKL 1;
                Stop;

            MuzzleFlash:
                TNT1 A 0 A_Jump(256, "M1", "M2", "M3", "M4");
            M1:
                MZ14 A 1 BRIGHT A_GunFlash();
                Stop;
            M2:
                MZ14 B 1 BRIGHT A_GunFlash();
                Stop;
            M3:
                MZ14 C 1 BRIGHT A_GunFlash();
                Stop;
            M4:
                MZ14 D 1 BRIGHT A_GunFlash();
                Stop;

            AmmoBeltAnimation:
                MG08 A 0;
                MG07 BC 1 Minigun_SetSprite("MG08");
                Loop;
            AmmoBeltChaingun:
                MG07 BCDA 1 Minigun_SetSprite("MG08");
                Loop;
            AmmoBeltIdle:
                TNT1 A 0 A_JumpIf(invoker.ammo1.amount >= 1,1);
                Stop;
                MG07 A 1 Minigun_SetSprite("MG08");
                Loop;
            
            Glow:
                G10W A 0;
                TNT1 A 0 {
                    A_OverlayFlags(GLOW_LAYER,PSPF_RENDERSTYLE,true);
                    A_OverlayRenderStyle(GLOW_LAYER,STYLE_Add);
                }
                TNT1 A 2 BRIGHT Minigun_Glow();
                Stop;

            AmmoMeterOverlay:
                MG05 J 0;
                TNT1 A 1 BRIGHT Minigun_AmmoMeter();
                Stop;
                
            DeathDealerCore:
                DEDC ABCDEFGHIJKL 1 BRIGHT;
                Loop;

            FlashKicking:
                MG33 A 0;
                MG35 A 0;
                TNT1 A 0 {
                    Minigun_ClearOverlays();
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(AMMO_METER_LAYER,-1,1);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(AMMO_METER_LAYER,-28,1);
                }
                MG03 ABCDEFGHIJKLM 1 Minigun_SetSprite("MG33","MG35");
                TNT1 A 0 {
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(AMMO_METER_LAYER,-1,1);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(AMMO_METER_LAYER,-28,1);
                }
                MG03 N 1 Minigun_SetSprite("MG33","MG35");
                Goto Ready3;

            FlashPunching:
                TNT1 A 0 {
                    A_ClearOverlays(FLASH_AMMO_METER_LAYER,10);
                    A_Overlay(FLASH_AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(FLASH_AMMO_METER_LAYER,-1,1);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(FLASH_AMMO_METER_LAYER,-28,1);
                }
                MG03 ABCDEFGHIJKLM 1 Minigun_SetSprite("MG33","MG35");
                TNT1 A 0 {
                    A_Overlay(FLASH_AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(FLASH_AMMO_METER_LAYER,-1,1);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(FLASH_AMMO_METER_LAYER,-28,1);
                }
                MG03 N 1 Minigun_SetSprite("MG33","MG35");
                Goto Ready3;
                
            FlashAirKicking:
                TNT1 A 0 {
                    Minigun_ClearOverlays();
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(AMMO_METER_LAYER,-1,1);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(AMMO_METER_LAYER,-28,1);
                }
                MG03 ABCDEFGGGGHIJKLM 1 Minigun_SetSprite("MG33","MG35");
                TNT1 A 0 {
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(AMMO_METER_LAYER,-1,1);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(AMMO_METER_LAYER,-28,1);
                }
                MG03 N 1 Minigun_SetSprite("MG33","MG35");
                Goto Ready3;
                
            FlashSlideKicking:
                MG34 A 0;
                MG36 A 0;
                TNT1 A 0 {
                    Minigun_ClearOverlays();
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(AMMO_METER_LAYER,-3,1);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(AMMO_METER_LAYER,-30,1);
                }
                MG18 ABCDEFGHHHHHHIJKLMNOPQRST 1 Minigun_SetSprite("MG34","MG36");
                TNT1 A 0 {
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(AMMO_METER_LAYER,-7,2);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(AMMO_METER_LAYER,-33,2);
                }
                MG18 U 1 Minigun_SetSprite("MG34","MG36");
                Goto Ready3;
                
                
            FlashSlideKickingStop:
                TNT1 A 0 Minigun_ClearOverlays();
                MG18 OPQRST 1 Minigun_SetSprite("MG34","MG36");
                TNT1 A 0 {
                    A_Overlay(AMMO_METER_LAYER,"AmmoMeterOverlay");
                    A_OverlayOffset(AMMO_METER_LAYER,-7,2);
                    if (Minigun_GetMode() == TRIPLE_MODE) 
                        A_OverlayOffset(AMMO_METER_LAYER,-33,2);
                }
                MG18 U 1 Minigun_SetSprite("MG34","MG36");
                Goto Ready3;
    }
}