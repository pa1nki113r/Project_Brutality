// Tokens
class HasIncendiaryWeapon : Inventory {Default{Inventory.MaxAmount 1;}}

// Ammo Class
Class PB_DTechRifleMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_DTechRifle.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_DTechRifle.MAGAZINE_SIZE;
		Inventory.Icon "HRPUA0";
	}
}

// The Actual Weapon
class PB_DTechRifle : PB_WeaponBase
{
    Default
    {
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        Weapon.SelectionOrder 400;
        Weapon.AmmoType1 "PB_DTech";
        Weapon.AmmoType2 "PB_DTechRifleMag";
        Weapon.AmmoGive1 20;
        PB_WeaponBase.OffsetRecoilX 3.5;
        PB_WeaponBase.OffsetRecoilY 0;
        Inventory.AltHUDIcon "HRPUA0";
        FloatBobStrength 0.5;
        Scale 0.48;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.PickupSound "HRPickup";
        Obituary "%o was set ablaze by %k's hellish rifle.";
        Tag "$PB_DTECH_NAME";
        Inventory.PickupMessage "$PB_DTECH_PICKUP";
    }
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    // Weapon Modes
    bool causticMode;
    int  causticCharge;
    enum dtech_mode{RESET,INFERNO,CAUSTIC}
    // Constants 
    const CHARGE_RATE        = 1;  // How many caustic charge to increase for it to shoot the bigger ball
    const CHARGE_MAX         = 20; // Max Caustic Charges, also dictates how much ammo to take at full charge
    const TAKE_ALT_INFERNO   = 20;
    const TAKE_ALT_CAUSTIC   = 5;  // Note that for the bigger ball to shoot it needs to be 3 times this value
    const MUZZLEFLASH        = -4;
	const MAGAZINE_SIZE = 60;
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    
    // Select Animation
    action void DTech_SelectAnimation()
    {
        bool caustic = getCausticMode(); 
        bool unloaded = PB_GetMagUnloaded(); 
        if (caustic) { 
            setHasWeapon(CAUSTIC); 
            if (unloaded) A_SetWeaponSprite("D2T3"); 
            else A_SetWeaponSprite("D2T1"); 
        } 
        else {   
            setHasWeapon(INFERNO); 
            if (unloaded) A_SetWeaponSprite("D2T2"); 
            else A_SetWeaponSprite("D2T0"); 
        } 
    }

    // Fire Function
    action void DTech_FireTic(int tic)
    {
        bool   caustic    = getCausticMode();
        string projectile = caustic ? "Hellbullet2"  : "Hellbullet";
        string sound      = caustic ? "8FGGFIRE"     : "HRFire";
        // string flash   = caustic ? "CausticFlash" : "InfernoFlash";
        double recoilX    = caustic ? -0.68 : -0.52;
        double recoilY    = caustic ? -0.36 : -0.20;

        switch(tic)
        {
            case 1:
                PB_FireOffset();

                if(!caustic) setHasWeapon(INFERNO);
                else         setHasWeapon(CAUSTIC);

                A_FireCustomMissile(projectile, 0, 0, 0, 0, 0, random(-1,1));
                // PB_FireBullets(projectile,1,0,0,0,random(-1,1));
                PB_GunSmoke(0, 0, 0);
                PB_MuzzleFlashEffects(0, 0, 0, "FF0000");
                A_PlaySoundEx(sound, "Weapon");
                PB_TakeAmmo(invoker.ammo2.getClassName(), 1, 0);
                A_AlertMonsters();
                A_ZoomFactor(0.99);

                if(caustic) A_FlashOverlay(state:"CausticFlash");
                else A_Overlay(FLASH_LAYER, "MuzzleFlash");

                PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 2:
                A_ZoomFactor(0.995);
                PB_WeaponRecoil(caustic ? -0.68 : -0.52, caustic ? -0.36 : -0.20);
                break;

            case 3:
                A_ZoomFactor(1.0);
                break;
        }
    }

    // Altfire Functions
    action void DTech_ChargedBlast()
    {
        string projectile;
        int charge = getCausticCharge();

        // No idea why the fire uncharged and charge 5 fires the same projectile
        if(charge      >= TAKE_ALT_CAUSTIC*3)  projectile = "CausticGreenPlasmaBall";
        else if(charge >= TAKE_ALT_CAUSTIC)    projectile = "ShrinkBeam";
        else                                   projectile = "ShrinkBeam";

        PB_TakeAmmo(invoker.ammo2.getClassName(), min(getCausticCharge(),CHARGE_MAX), 0); // So you only tak 20 ammo at max charge
        // console.Printf("Take Ammo %d", invoker.causticcharge);
        A_StopSound(5);
        A_StopSound(6);
        A_ClearReFire();

        A_AlertMonsters();
        A_PlaySoundEx("Weapons/StachanovAddFire", "Weapon");
        A_FireCustomMissile("GreenFlareSpawn", 0, 0, 0, 0);
        A_FireCustomMissile(projectile, 0, 1);
        // console.Printf("Shot projectile: %s with Charge: %d",projectile,invoker.causticcharge);
        PB_GunSmoke(0, 0, 0);
        PB_MuzzleFlashEffects(0, 0, 0, "FF0000");
        setCausticCharge(0);
        A_FlashOverlay(state:"CausticFlash");
    }

    action void DTech_ChargeLevel()
    {
        int charge = getCausticCharge();
        double blend;

        if     (charge >= TAKE_ALT_CAUSTIC*4) blend = 0.30; // Level 4
        else if(charge >= TAKE_ALT_CAUSTIC*3) blend = 0.25; // Level 3
        else if(charge >= TAKE_ALT_CAUSTIC*2) blend = 0.20; // Level 2
        else if(charge >= TAKE_ALT_CAUSTIC)   blend = 0.15; // Level 1
        else                                  blend = 0.10;

        // PB_FireOffset();
        // A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
        A_PlaySound("HRCharge", 3);
        A_SetBlend("Green", blend, 16);
        // console.Printf("Current Caustic Charge: %d", invoker.causticcharge);
        // console.printf("addedcausticcharge");
    }

    // Auxilliary Functions
    action bool getCausticMode()
    {
        return invoker.causticMode;
    }

    action void setCausticMode(bool set)
    {
        invoker.causticMode = set;
    }

    action int getCausticCharge()
    {
        return invoker.causticCharge;
    }

    action void setCausticCharge(int set)
    {
        invoker.causticCharge = set;
    }

    // Turns out this is used for the monsters death states
    action void setHasWeapon(int mode)
    {
        switch(mode)
        {
            // Reset
            case RESET:
                A_SetInventory("HasAcidWeapon", 0);
                A_SetInventory("HasIncendiaryWeapon", 0);
                break;

            // Inferno Mode
            case INFERNO:
                A_SetInventory("HasAcidWeapon", 0);
                A_SetInventory("HasIncendiaryWeapon", 1);
                break;

            // Caustic mode
            case CAUSTIC:
                A_SetInventory("HasAcidWeapon", 1);
                A_SetInventory("HasIncendiaryWeapon", 0);
                break;
        }
    }

    action state DTech_WeaponSpecial()
    {
        A_SetInventory("GoWeaponSpecialAbility", 0);
        PB_HandleDTechCrosshair();
        A_StopSound(1);

        // Toggle
        invoker.causticMode = !invoker.causticMode;

        // Go to Caustic mode
        if(getCausticMode())
        {
            setHasWeapon(CAUSTIC);
            A_Print("$PB_DTECH_CAUSTIC");
            A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
            return ResolveState("WeaponSpecialCausticAnim");
        }
        // Go to Inferno mode
        else
        {
            setHasWeapon(INFERNO);
            A_Print("$PB_DTECH_INFERNO");
            A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
            return ResolveState("WeaponSpecialInfernoAnim");
        }
        return ResolveState(null);
    }
	
	action void PB_HandleDTechCrosshair() {
		if(getCausticMode()) {
			PB_HandleCrosshair(95);
		}
		else {
			PB_HandleCrosshair(39);
		}
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            VRPU A 0 NoDelay;
            HRPU A 10 A_PbvpFramework("VRPU");
            "####" "#" 0 A_PbvpInterpolate();
            loop;

        WeaponRespect:
            TNT1 A 0 {
				A_SetCrosshair(-1);
				A_PlaySoundEx("weapons/carbine/up", "Auto");
			}
			D0T0 ABCDEFGHIJKLMNOPQRSSSSS 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect1", "Auto");
			D0T1 ABCDEF 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect2", "Auto");
			D0T1 GHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			D0T2 ABCDE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect3", "Auto");
			D0T2 FGHIJKLMNOPQRSTUVW 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			D0T2 XYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			D0T3 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			Goto Ready3;

        Deselect:
            TNT1 A 0 {
                A_WeaponOffset(0, 32);
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt", 0);
            }
            TNT1 A 0 A_StopSound(1);
            TNT1 A 0 setHasWeapon(RESET);
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "DeselectUnloaded");
            TNT1 A 0 A_JumpIf(getCausticMode(), "DeselectAcid");
            D2T0 DCBA 1;
            Goto FinishDeselect;
            
        DeselectAcid:
            D2T1 DCBA 1;
            Goto FinishDeselect;

        DeselectUnloaded:
            TNT1 A 0 A_JumpIf(getCausticMode(), "DeselectUnloadedAcid");
            D2T2 DCBA 1;
            Goto FinishDeselect;
            
        DeselectUnloadedAcid:
            D2T3 DCBA 1;
        FinishDeselect:
            TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
            Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleDTechCrosshair();
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeapTokenSwitch("HellRifleSelected");
                PB_WeaponRaise("HRReady");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation: 
            TNT1 A 0 DTech_SelectAnimation(); // This function handles which sprite to use for the select animation
            "####" BCDE 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
            TNT1 A 0 {
                A_SetInventory("PB_LockScreenTilt", 0);
                PB_HandleDTechCrosshair();
            }
        ReadyToFire1:
        ReadyToFireInferno:
            // Main loop route check
            TNT1 A 0 A_JumpIf(getCausticMode(), "ReadyToFireAcid");
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "ReadyUnloaded");
            TNT1 A 0 A_PlaySound("DTCHHUM", 1, 1, 1);
        InfernoLoop:
            D5T0 ABCDEFGHIJKLMAABMBAAABAA 3 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            TNT1 A 0 A_JumpIf(getCausticMode() || PB_GetMagUnloaded(), "ReadyToFireInferno");
            Loop;

        ReadyUnloaded:
            D5T0 Z 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            TNT1 A 0 A_JumpIf(getCausticMode() || !PB_GetMagUnloaded(), "ReadyToFireInferno");
            Loop;

        ReadyToFire2:
        ReadyToFireAcid:
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "ReadyUnloadedAcid");
            TNT1 A 0 setCausticCharge(0);
            TNT1 A 0 A_PlaySound("DTCHGUM", 1, 1, 1);
        AcidLoop:
            D5T1 ABCDEFGHIJKLMAABMBAAABAA 3 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            TNT1 A 0 A_JumpIf(!getCausticMode() || PB_GetMagUnloaded(), "ReadyToFireInferno");
            Loop;

        ReadyUnloadedAcid:
            D5T1 Z 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            TNT1 A 0 A_JumpIf(!getCausticMode() || !PB_GetMagUnloaded(), "ReadyToFireInferno");
            Loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
            TNT1 A 0 PB_JumpIfNoAmmo();
            TNT1 A 0 {
                A_WeaponOffset(0, 32);
                PB_SetRoll(0);
                PB_HandleDTechCrosshair();
                A_SetInventory("PB_LockScreenTilt", 0);
            }
            TNT1 A 0 A_JumpIf(getCausticMode(), "FireCaustic");
            D3T0 A 1 BRIGHT DTech_FireTic(1);
            D3T0 B 1 BRIGHT DTech_FireTic(2);
            D3T0 C 1        DTech_FireTic(3);
            D3T0 D 1;
            D2T0 E 0 PB_ReFire();
            TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
            D3T0 EFGHIJKLMNOPQRS 1;
            TNT1 A 0 setHasWeapon(RESET);
            Goto ReadyToFireInferno;

        Fire2:
        FireCaustic:
            D3T1 A 1 BRIGHT DTech_FireTic(1);
            D3T1 B 1 BRIGHT DTech_FireTic(2);
            D3T1 C 1        DTech_FireTic(3);
            D3T1 D 1;
            D2T1 E 0 PB_ReFire();
            TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
            D3T1 EFGHIJKLMNOPQRS 1;
            Goto ReadyToFireAcid;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
        AltFireInferno:
			TNT1 A 0 PB_JumpIfNoAmmo("Reload",TAKE_ALT_INFERNO);
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleDTechCrosshair();
				A_SetInventory("PB_LockScreenTilt",0);
			}
            TNT1 A 0 A_JumpIf(getCausticMode(), "AltFireCaustic");
			TNT1 A 0 A_PlaySound("HRCharge");
			D5T0 ABCDABCDABCDABCD 1 BRIGHT {
				A_WeaponOffset(random(-1,1),random(32,34));
				A_GunFlash2();
			}
			TNT1 A 0 PB_ReFire("AltFire");// No idea why this just loops lol
			TNT1 A 0 A_PlaySoundEx("unmbal", "Weapon");
			TNT1 A 0 A_FireCustomMissile("RedFlareSpawn",0,0,0,0);
			TNT1 A 0 A_FireCustomMissile("PossessionGhost");
			TNT1 A 0 A_AlertMonsters();
			TNT1 A 0 A_Overlay(FLASH_LAYER, "MuzzleFLash");
			D3T0 AB 1 BRIGHT;
			D3T0 CD 1;
			TNT1 A 0 PB_TakeAmmo(invoker.ammo2.getClassName(), TAKE_ALT_INFERNO, 0);
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			D3T0 EFGHIJKLNOPQRS 1;
			Goto ReadyToFireInferno;

        AltFireCaustic:
            TNT1 A 0 A_JumpIf(invoker.ammo2.amount >= TAKE_ALT_CAUSTIC, "CausticCharging");
			Goto Reload;

		CausticCharging:
            TNT1 A 0 A_PlaySound("CNTCTBM", 6);
            TNT1 A 0 A_PlaySound("Weapons/StachanovCharge", 5, 1.0, 1);
        CausticChargingLoop:
            TNT1 A 0 {
                if(getCausticCharge() > invoker.ammo2.amount) return ResolveState("CausticChargedBlast");
                return ResolveState(null);
            }
            TNT1 A 0 A_JumpIf(invoker.ammo2.amount >= TAKE_ALT_CAUSTIC, "ChargingContinue");
            Goto CausticChargedBlast;

        ChargingContinue:
            TNT1 A 0 DTech_ChargeLevel();
            D5T1 ABCD 1 BRIGHT {
                setCausticCharge(min(invoker.causticcharge + CHARGE_RATE, CHARGE_MAX));
                A_WeaponOffset(random(-1,1), random(32,34));
                // console.Printf("Current Charge: %d",invoker.causticcharge);
                // PB_FireOffset();
                // A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
            }
            D5T1 BCDABCDABCD 1 BRIGHT {
                A_WeaponOffset(random(-1,1), random(32,34));
                // PB_FireOffset();
                // A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
            }
            TNT1 A 0 PB_ReFire("CausticChargingLoop");
		CausticChargedBlast:
			D3T1 A 1 BRIGHT DTech_ChargedBlast(); // This function handles which projectile to shoot based on the charge levels
			D3T1 B 1 BRIGHT A_ZoomFactor(0.96);
			D3T1 C 1 BRIGHT A_ZoomFactor(0.98);
			D3T1 D 1 BRIGHT A_ZoomFactor(1.0);
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			D3T1 EFGHIJKLMNOPQRS 1;
			goto ReadyToFireAcid;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
            TNT1 A 0 DTech_WeaponSpecial();
            Goto Ready3;

        WeaponSpecialCausticAnim:
            D1T0 ABCD 1        { if(PB_GetMagUnloaded()) A_SetWeaponSprite("D1T2"); }
            TNT1 A 0 {
				A_PlaySoundEx("weapons/demontech/weaponspecial2", "Auto");
				PB_HandleDTechCrosshair();
			}
            D1T0 EFGHIJKLMN 2  { if(PB_GetMagUnloaded()) A_SetWeaponSprite("D1T2"); }
            Goto ReadyToFireAcid;

        WeaponSpecialInfernoAnim:
            D1T1 ABCD 1        { if(PB_GetMagUnloaded()) A_SetWeaponSprite("D1T3"); }
            TNT1 A 0 {
				A_PlaySoundEx("weapons/demontech/weaponspecial2", "Auto");
				PB_HandleDTechCrosshair();
			}
            D1T1 EFGHIJKLMN 2  { if(PB_GetMagUnloaded()) A_SetWeaponSprite("D1T3"); }
            Goto ReadyToFireInferno;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
        Reload:
            // Cache Sprites
            D6T0 A 0;
			D6T1 A 0;
			D6T2 A 0;
			D6T3 A 0;
			D6T4 A 0;
			D6T5 A 0;
            // Actual Reload
			TNT1 A 0 PB_CheckReload("ReloadUnloaded",null,null,"Ready3","Ready3",MAGAZINE_SIZE);
			TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
			D4T0 ABCDEFGHIJK 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T0");}}
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			D4T0 LMN 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T0");}}
			TNT1 A 0 {
				A_PlaySoundEx("weapons/demontech/respect1", "Auto");
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
				PB_SetChamberEmpty(true);
			}
			D4T0 OPQRSTUVWXYZ 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T0");}}
			D4T1 ABC 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T1");}}
			Goto ReloadContinue;

		ReloadEmpty:
			D4T5 ABCDGOP 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T5");}}
			TNT1 A 4;
			D4T5 QRSTUV 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T5");}}
		ReloadContinue:
			D4T1 DEFGH 1;
			D4T1 I 1  {if(getCausticMode()) {A_SetWeaponSprite("D6T1");} A_PlaySound("weapons/fistwhoosh2");}
			D4T1 JKLM 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T1");}}
			D4T1 N 1 {
				A_PlaySoundEx("weapons/demontech/respect4", "Auto");
				PB_AmmoIntoMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(), MAGAZINE_SIZE);
				PB_SetMagEmpty(false);
			}
			TNT1 A 0 {
				A_PlaySoundEx("weapons/demontech/respect2", "Auto");
				A_PlaySoundEx("HRPickup", "Auto");
			}
			D4T1 OPQRSTUVWXYZ 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T1");}}
			D4T2 ABCDKL 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T2");}}
			D4T2 U 1 A_PlaySoundEx("Ironsights", "Auto");
			D4T2 VWXYZ 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T2");}}
			D4T3 ABC 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T3");}}
			TNT1 A 0 A_JumpIf(getCausticMode(),"Reload2Finish");
		ReloadFinish:
			D4T3 DEFGH 1   {if(getCausticMode()) {A_SetWeaponSprite("D6T3");}}
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect3", "Auto");
			D4T3 I 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T3");}}
			Goto ContinueReloadFinish;

		ReloadUnloaded:
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(),"ReloadEmpty");
			D4T5 ABCDEF 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T5");}}
			D4T5 G 4 {if(getCausticMode()) {A_SetWeaponSprite("D6T5");}}
			D4T5 HIJKLM 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T5");}}
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect3", "Auto");
			D4T5 N 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T5");}}
		ContinueReloadFinish:
			D4T3 JKLMNOPQRSTUV 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T3");}}
			TNT1 A 0 {
				A_PlaySoundEx("weapons/riflemagslap", "Auto");
				PB_SetMagUnloaded(false);
				PB_SetChamberEmpty(false);
			}
			D4T3 WXYZ 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T3");}}
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			D4T4 ABCDEFGHIJKLMNOPQRST 1 {if(getCausticMode()) {A_SetWeaponSprite("D6T4");}}
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
        // No idea why this wepona doesnt have an unload

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        MuzzleFlash:
			TNT1 A 0 A_Jump(256, "FMuzzle1", "FMuzzle2", "FMuzzle3");
		FMuzzle1:
			D3T2 AB 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdFMuzzle1");
			Stop;
		FMuzzle2:
			D3T2 DE 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdFMuzzle2");
			Stop;
		FMuzzle3:
			D3T2 GH 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdFMuzzle3");
			Stop;
			
		ThirdFMuzzle1:
			D3T2 C 1 BRIGHT A_GunFlash();
			Stop;
		ThirdFMuzzle2:
			D3T2 F 1 BRIGHT A_GunFlash();
			Stop;
		ThirdFMuzzle3:
			D3T2 I 1 BRIGHT A_GunFlash();
			Stop;
			
		CausticFlash:
			TNT1 A 0 A_Jump(256, "CMuzzle1", "CMuzzle2", "CMuzzle3", "CMuzzle4", "CMuzzle5", "CMuzzle6");
		CMuzzle1:
			D3T3 AB 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle1");
			Stop;
		CMuzzle2:
			D3T3 DE 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle2");
			Stop;
		CMuzzle3:
			D3T3 GH 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle3");
			Stop;
		CMuzzle4:
			D3T3 JK 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle4");
			Stop;
		CMuzzle5:
			D3T3 MN 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle5");
			Stop;
		CMuzzle6:
			D3T3 PQ 1 BRIGHT A_GunFlash();
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle6");
			Stop;
			
		ThirdCMuzzle1:
			D3T3 C 1 BRIGHT A_GunFlash();
			Stop;
		ThirdCMuzzle2:
			D3T3 F 1 BRIGHT A_GunFlash();
			Stop;
		ThirdCMuzzle3:
			D3T3 I 1 BRIGHT A_GunFlash();
			Stop;
		ThirdCMuzzle4:
			D3T3 L 1 BRIGHT A_GunFlash();
			Stop;
		ThirdCMuzzle5:
			D3T3 O 1 BRIGHT A_GunFlash();
			Stop;
		ThirdCMuzzle6:
			D3T3 R 1 BRIGHT A_GunFlash();
			Stop;

        FlashKicking:
            // Cache Sprites
            D7T1 A 0;
            // Actual Flash Kick
            D7T0 ABCDEFFFGHIJKLM 1 {if(getCausticMode()) {A_SetWeaponSprite("D7T1");}}
            Goto Ready3;

        FlashAirKicking:
            D7T0 ABCDEFFFFFGHIJKLM 1 {if(getCausticMode()) {A_SetWeaponSprite("D7T1");}}
            Goto Ready3;

        FlashSlideKicking:
            // Cache Sprites
            D7T3 A 0;
            // Actual Flash Slide Kick
            D7T2 ABCDEFGHIJKLMNOPPPPPQRST 1 {if(getCausticMode()) {A_SetWeaponSprite("D7T3");}}
            Goto Ready3;

        FlashSlideKickingStop:
            D7T2 QRST 1 {if(getCausticMode()) {A_SetWeaponSprite("D7T3");}}
            Goto Ready3;

        FlashPunching:
            // Cache Sprites
            D7T5 A 0;
            // Actual Flash Punch
            D7T4 ABCDEFFFFFFGHI 1 {if(getCausticMode()) {A_SetWeaponSpriteEx("D7T5");}}
            Goto Ready3;

    }
}

//////////////////////////// PROJECTILES/OTHERS ////////////////////////////////////////////////////////////////////////////////////
class Hellbullet : PB_ProjectileAlt
{
    Default
    {
        PB_Projectile.BaseDamage 54;
        +PB_PROJECTILE.NOCRITICALS
        +FORCEXYBILLBOARD
        +SQUAREPIXELS
        +BLOODSPLATTER
        +NOEXTREMEDEATH
        damagetype "fire";
        radius 2;
        height 1;
        //alpha 0.8
        scale .3;
        speed 130;
        Decal "Scorch";
        Deathsound "Weapons/Demontech/Crash";
    }

    States
    {
        Spawn:
            PBAL L 1 BRIGHT ;
            TNT1 A 0 A_SpawnItemEx("DTechTrailSpark", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
            PBAL M 1 BRIGHT ;
            Loop;

        Xdeath:
            TNT1 A 0; //A_CustomMissile ("Flametrails", 0, 0, random (0, 180), 2, random (0, 360))
            TNT1 A 0 A_SpawnItem("HellRifle_Puff",0);
            TNT1 A 0 A_Jump(128, 2);
            TNT1 A 0 A_SpawnItem("DTechBurningPiece",0);
            //TNT1 AAA 0 A_SpawnItemEx("ExplosionParticleVerySlow", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0)
            TNT1 AAA 0 A_SpawnItemEx("DTechTrailSpark", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0);
            TNT1 A 4;
            TNT2 AAA 3 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
            Stop;

        Death:
            TNT1 A 0 A_SpawnItem("HellRifle_Puff2",0);
            TNT1 A 0 A_Jump(128, 2);
            TNT1 A 0 A_SpawnItem("DTechBurningPiece2",0);
            TNT1 AAA 0 A_SpawnItemEx("ExplosionParticleVerySlow", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0);
            //TNT1 AA 0 A_SpawnItemEx("BurningEmberParticlesFloating_Bigger", random(19,-19), random(19,-19), random(4,-4), 0, 0, 0, 0, 128, 0)
            TNT1 AAA 0 A_SpawnItemEx("DTechTrailSpark", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0);
            TNT1 A 4;
            TNT2 AAAAA 4 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
            Stop;
    }
}

class DTechTrailSpark : actor
{
    Default {
	Scale 0.0125;
	+NOINTERACTION;
	+FORCEXYBILLBOARD;
	+SQUAREPIXELS;
	+NOGRAVITY;
    }
	States
	{
	Spawn:
	YAE4 B 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
	YAE4 B 0 A_SetScale(Scale.X-0.00075);
	YAE4 B 4 bright A_ChangeVelocity (frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
	Loop;
	}
}
	
//GreenPlasma_Puff

class Hellbullet2 : PB_ProjectileAlt
{
    Default {
    PB_Projectile.BaseDamage 60;
    +PB_PROJECTILE.NOCRITICALS
	+FORCEXYBILLBOARD
	+SQUAREPIXELS
	+BLOODSPLATTER
	+NOEXTREMEDEATH
	damagetype "Disintegrate";
	radius 2;
	height 1;
	renderstyle "ADD";
	//alpha 0.7;
	scale .19;
	speed 100;
	Decal "Scorch";
	Deathsound "Weapons/Demontech/Crash";
  }
	states
	{
	Spawn:
		TNT1 AA 0 NODELAY A_SpawnItem("GreenFlareSmall",0);
		DB57 AB 1 BRIGHT Light("CausticProjectile");
		TNT1 A 0 A_CustomMissile ("GreenTracerSmall", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
		DB57 C 1 BRIGHT;
		Loop;
	Xdeath:
		TNT1 A 0 A_SpawnItem("GreenPlasma_Puff_Medium",0);
		TNT1 A 0 A_CustomMissile ("PlasmaParticleSpawner", 0, 0, random (0, 180), 2, random (0, 360));
		TNT1 A 4;
		//TNT2 AAA 3 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
		
		Stop;

	Death:
		TNT1 A 0 A_SpawnItem("GreenPlasma_Puff_Medium",0);
		TNT1 A 0 A_CustomMissile ("PlasmaParticleSpawner", 0, 0, random (0, 180), 2, random (0, 360));
		TNT1 A 4	;
		//TNT2 AAAAA 4 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
		Stop;
	}
}



class DemonSoulHeal : CustomInventory //23167
{
    Default {
	// Game Doom
	Radius 80;
	-COUNTITEM;
	+INVENTORY.ALWAYSPICKUP;
	Inventory.PickupMessage "Your Demon Spirits have granted you health!";
	Inventory.PickupSound "DemonHeal";
  }
	States
	{
		Spawn:
			TNT1 A 80;
			Stop;
			
		Pickup:
			TNT1 A 0 ACS_NamedExecute("CrueltyBonus10", 0)	;
			Stop;
	}
}

// Demon Power Pickups ---------------------------------------------------------------

// lesser ammo item
class DemonPower : Ammo
{
    Default {
	//$Title Lesser Demon Energy
	//$Category Ammunition
	//$Sprite MSP2A0
	Inventory.PickupMessage "Lesser demon energy";
	Inventory.PickupSound "HellPickup";
	Inventory.Amount 20 ;
	Inventory.MaxAmount 300;
	Inventory.Icon "MSP2A0";
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 600;
	renderstyle "add";
	scale 0.25;
	+INVENTORY.ALWAYSPICKUP;
	+INVENTORY.IGNORESKILL;
  }
	states
	{
		Spawn:
			DB61 A 1 BRIGHT nodelay A_spawnitemex("DemonPowerAddedEffect");
			DB61 ABCCDEEFGGHIIJJ 1 bright ;
			loop;
			
		ReplaceVanilla:
			TNT1 A 0 ;
			TNT1 A 1 ;
			Stop;
		}
}

class DemonPowerAddedEffect : inventory
{
    Default {
+INVENTORY.ALWAYSPICKUP;
Inventory.MaxAmount 1;
Inventory.Amount 1;
scale 0.214;
alpha .8;
  }
	states
	{
		Spawn:
			DB61 KLMNOPQRR 2 BRIGHT;
			stop;
	}
}
//greater ammo item
class LargeDemonPower : DemonPower
{
    Default {
	//$Title Greater Demon Energy
	//$Category Ammunition
	//$Sprite MSP2A0
	Inventory.PickupMessage "Greater demon energy";
	Inventory.Amount 40;
	scale 0.35;
  }
	states
	{
		Spawn:
			DB61 A 1 BRIGHT nodelay A_spawnitemex("DemonPowerAddedEffectLarge");
			DB61 ABCCDEEFGGHIIJJ 1 bright ;
			loop;
			
		ReplaceVanilla:
			TNT1 A 0 ;
			TNT1 A 1 ;
			Stop;
		}
}

class DemonPowerAddedEffectLarge : DemonPowerAddedEffect
{
    Default {
	scale 0.3;
  }
}

class RedTracerSmall : actor
{
    Default {
  Height 0;
  Radius 0;
  Mass 0;
  +Missile;
  +NoBlockMap;
  -NoGravity;
  //+LowGravity;
  +DontSplash;
  +FORCEXYBILLBOARD;
  BounceFactor 0.2;
  Gravity 0.8;
  Scale 0.035;
  //Speed 2;
  Speed 0;
	+NoGravity;
  RenderStyle "Add";
  Scale 0.25;
  Alpha 0.6;
  }
  States
  {
  Spawn:
  Death:
	SHOQ A 2 Bright A_FadeOut(0.04);
	TNT1 A 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(4,-4), 0, 0, 0, 0, 128, 0);
	SHOQ B 2 Bright A_FadeOut(0.04);
	SHOQ C 2 Bright A_FadeOut(0.04);
	TNT1 A 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(4,-4), 0, 0, 0, 0, 128, 0);
	SHOQ D 2 Bright A_FadeOut(0.04);
	SHOQ E 2 Bright A_FadeOut(0.04);
	TNT1 A 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(4,-4), 0, 0, 0, 0, 128, 0);
	SHOQ F 2 Bright A_FadeOut(0.04);
	SHOQ G 2 Bright A_FadeOut(0.04);
	TNT1 A 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(4,-4), 0, 0, 0, 0, 128, 0);
	Stop;
  }
}

class GreenTracerSmall : actor
{
    Default {
  Height 0;
  Radius 0;
  Mass 0;
  +Missile;
  +NoBlockMap;
  -NoGravity;
  //+LowGravity;
  +DontSplash;
  +FORCEXYBILLBOARD;
  BounceFactor 0.2;
  Gravity 0.8;
  RenderStyle "Add";
  Scale 0.035;
  //Speed 2;
  Speed 0;
	+NoGravity;
  Scale 0.25;
  Alpha 0.6;
  }
  States
  {
  Spawn:
  Death:
	SH0Q ABCDEFG 1 Bright A_FadeOut(0.04);
	Stop;
  }
}

class ShrinkBeam : MageWandMissile
{
    Default {
  Speed 25;
  Radius 16;
  Height 16;
  Damage 3;
  Decal "Scorch";
  damagetype "Disintegrate";
  //-RIPPER;
	+NOBOSSRIP;
  -CANNOTPUSH;
  -NODAMAGETHRUST;
  +Bloodlessimpact;
  +NOBLOOD;
  }
  states
  {
  
  Spawn:
	APBX B 1 BRIGHT A_SpawnItem("GreenFlareSmall",0,0);
	TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
	APBX C 1 BRIGHT A_SpawnItem("GreenFlareSmall",0,0);
	TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
	APBX D 1 BRIGHT A_SpawnItem("GreenFlareSmall",0,0);
	TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
	TNT1 A 0 A_SpawnItemEx("SmallGreenFlameTrails", 0, 0, 0, 0, 0, 0, 0, 128);
	loop;
  
  Death:
	TNT1 A 0 A_Explode(30,70,1);
	TNT1 A 0 A_Explode(10,90,1);
	APBX B 1 bright A_SpawnItem("GreenFlare",0,0);
	TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
	APBX C 1 bright A_SpawnItem("GreenFlare",0,0);
	TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
	APBX D 1 bright A_SpawnItem("GreenFlare",0,0);
	TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
	APBX E 1 bright A_SpawnItem("GreenFlare",0,0);
	TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
	TNT1 A 0 A_SpawnItem("BFGAltShockWave",0,0);
	stop;
  }
}

class CausticGreenPlasmaBall : BaronBall
{
    Default {
	Radius 10;
	Height 16;
	Speed 30;
	FastSpeed 30;
	Projectile ;
	+RANDOMIZE;
	+FORCEXYBILLBOARD;
	+THRUGHOST;
	Damage 120;
	RenderStyle "Add";
	Alpha 0.9;
	Scale 1.45;
	SeeSound "baron/attack";
	DeathSound "belphegor/missile";
	Decal "Scorch";
	DamageType "Disintegrate";
  }

	States
	{
	Spawn:
		TNT1 A 0 A_SpawnItem("GreenFlare22",0,0);
		FRPG K 1 BRIGHT A_SpawnItemEx("GreenExplosionFlameTrail", 0, 0, 0, 0, 0, 0, 0, 128) ;
		Loop;

	Death:
	BFE1 A 0 A_PlaySound("FAREXPL", 3);
	EXPL A 0 Radius_Quake (2, 54, 0, 15, 0);
	BFE1 A 0 Bright A_Explode(27, 135, 1);
		TNT1 A 0 A_SpawnItem ("GreenExplosionMushroom", 0);
		TNT1 AAAAAAAAA 0 A_CustomMissile ("GreenExplosionFire", 2, 0, random (0, 360), 2, random (0, 360));
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_PlaySound ("barlp1",3);
		TNT1 A 0 A_SpawnItem("ACIDFOGSHRINK", 0, 0);
		EXPL AA 0 A_CustomMissile ("BigNeoSmoke", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 A 19 A_CustomMissile("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
	TNT1 BCDEF 2 Bright;
	TNT1 AAAAAAA 2 A_CustomMissile ("BigNeoSmoke", 2, 0, random (0, 360), 2, random (0, 360));
	Stop;
	}
}

class ACIDFOGSHRINK : actor
{
    Default {
	Radius 2;
	Height 1;
	//Alpha .8;
	Decal "Scorch";
	//RenderStyle Translucent;
	Damage 5;
	DamageType "Disintegrate";
	Scale 1.32;
	Speed 0;
	Gravity 0;
	+NOBLOCKMAP;
	+NOTELEPORT;
	+NOEXTREMEDEATH;
	-EXTREMEDEATH;
	+FORCEXYBILLBOARD;
	+ALLOWPARTICLES;
	//+CLIENTSIDEONLY;
	+DONTSPLASH;
	+PAINLESS;
	-CAUSEPAIN;
	-FORCEPAIN;
  }
	States
	{
	Spawn:
		TNT1 A 0 A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 6, 6, 6, 0, 128);
		TNT1 A 0 A_Explode ( 50, 190 );
		TNT1 AAAAAAAA 0 A_SpawnItemEx("GreenCloudLarge", random(3,-3), random(3,-3), random(3,-3), random(1,-1), random(1,-1), 0, 0, SXF_NOCHECKPOSITION, 0);
		TNT1 AAAAAAAA 0 A_SpawnItemEx("GreenCloudMedium", random(3,-3), random(3,-3), random(3,-3), random(1,-1), random(1,-1), 0, 0, SXF_NOCHECKPOSITION, 0);
		TNT1 AAAAAAAA 0 A_SpawnItemEx("GreenCloudMediumShrink", random(3,-3), random(3,-3), random(3,-3), random(1,-1), random(1,-1), 0, 0, SXF_NOCHECKPOSITION, 0);
		TNT1 AAAAAAAA 0 A_SpawnItemEx("GreenCloudSmallShrink", random(3,-3), random(3,-3), random(3,-3), random(1,-1), random(1,-1), 0, 0, SXF_NOCHECKPOSITION, 0);
		TNT1 AAAAAAAAAAAA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
		TNT1 A 0 A_SpawnItem("NewAcidExplosionSmoke", 0, 0);
		TNT1 AAAA 2 BRIGHT Light("BARONBALL") A_SpawnItem("GreenFlare",0,20);
		Goto Death;
		
	Death:
		TNT1 A 0 A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 6, 6, 6, 0, 128);
		Stop;
	}
}

class GreenCloudMediumShrink : GreenCloudSmall
{
    Default {
	Scale 1.3;
	DamageType "Disintegrate";
  }
	States
	{
	Spawn:
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 8, 100 );
		GTXL KLMNOPQRST 1  A_FadeOut( 0.10);
		Stop;
	}
}

class GreenCloudSmallShrink : GreenCloudSmall
{
    Default {
	Scale 1.05;
	DamageType "Disintegrate";
  }
	States
	{
	
	Spawn:
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL KLMNOPQRST 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL TSRQPONMLK 1 ;
		TNT1 A 0 A_Explode ( 6, 100 );
		GTXL KLMNOPQRST 1  A_FadeOut( 0.10);
		Stop;
	}
}

//////////////////////////////////////////Possession

// Homing ghost projectile fired upon the item's use ----------------------------------------------

class PossessionGhost : actor
{
    Default {
  Height 2;
  MaxTargetRange 32;
  Projectile;
  Radius 2;
  SeeSound "HRReady";
  Speed 20;
  Scale 0.1;
  +BRIGHT;
  +SCREENSEEKER;
  +SEEKERMISSILE;
  +THRUACTORS;

  }

  const PSGH_JITC_DISTANCE = 20; // A_JumpIfTracerCloser distance parameter

  States
  {
	Spawn:
		TNT1 A 0 A_PlaySound("SpiritSeeker", 3, 1.0, 1);
	SpawnLoop:
		BLHS ABCD 2 BRIGHT {
			A_SpawnItem("RedFlareSpawn",0,0,0,0);
			A_SpawnItem("RedLightningTrial_Small", 5);
			A_SpawnItemEx("DTechTrailSpark", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
			A_GiveInventory("PossessionGhostRoutine", 1);
			A_SeekerMissile (4,8);
			if(Scale.X <= 1.0){
				A_SetScale(Scale.X+0.08, Scale.Y+0.08);
			}
			if(A_JumpIfTracerCloser(PSGH_JITC_DISTANCE, "Possess")){
				return A_Jump(256, "Possess");
			}
			return Resolvestate(null);
		}
		loop;

	Possess:
		TNT1 A 0 {
			A_StopSound(3);
			A_SpawnItem("HellRifle_Puff2",0);
			A_Playsound("weapons/demontech/respect2");
			A_GiveInventory("PossessMonster", 1 , AAPTR_TRACER);
		}
		Stop;

	Death:
		TNT1 A 0 A_SpawnItem("HellRifle_Puff2",0);
		Stop;
	}
}

class PossessionGhostTrail : actor
{
    Default {
    Alpha 0.5;
    RenderStyle "Add";
    +NOINTERACTION;
  }
  States
  {
  Spawn:
	TNT1 A 2;
	BLHS ABCD 2 Bright A_FadeOut(0.08);
	Wait;
  }
}

class PossessionGhostRoutine : CustomInventory
{
  States
  {
  Pickup:
	TNT1 A 0 A_SeekerMissile(5.0, 10.0, SMF_LOOK, 256);
	//TNT1 A 0 A_SpawnItemEx("PossessionGhostTrail", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
	Stop;
  }
}

// Possession state indicators (the things that spawn on top of the possessed monster) ------------

class PossessionWarperA : actor
{
    Default {
  RenderStyle "Translucent";
  Scale 0.75;
  //+ISMONSTER;
  +NOINTERACTION;
  +FRIENDLY;
  +NOTARGET;
  +NEVERTARGET;

 
  }
  int user_angle;
  int user_xoffset;
  int user_yoffset;
  int user_zoffset;

  States
  {
  Spawn:
	TNT1 A 0 NoDelay A_SetUserVar("user_xoffset", 32);
  SetVars:
	TNT1 A 0 A_SetUserVar("user_yoffset", 0);
	TNT1 A 0 A_SetUserVar("user_zoffset", CallACS("Pos - Adjust height"));
	TNT1 A 0 A_SetUserVar("user_angle", 0);
  AnimInit:
	TNT1 A 1 A_Warp(AAPTR_MASTER, user_xoffset, user_yoffset, user_zoffset, user_angle,
					WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE|WARPF_ABSOLUTEANGLE);
  AnimLoop:
	TNT1 A 1 Bright A_Warp(AAPTR_MASTER, user_xoffset, user_yoffset, user_zoffset, user_angle,
							WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE|WARPF_ABSOLUTEANGLE);
	TNT1 A 0 A_SetUserVar("user_angle", user_angle + 8);
	TNT1 A 0 A_SpawnItemEx("PossessionWarperTrail", 0, 0, 0, 0, 0, 0, 0,
							SXF_NOCHECKPOSITION|SXF_TRANSFERTRANSLATION);
	TNT1 A 0 A_JumpIf(CallACS("Pos - Check possession state") == TRUE, "Destroy");
	TNT1 A 1;
	Loop;
  Destroy:
	TNT1 A 1 Bright A_Warp(AAPTR_MASTER, user_xoffset, user_yoffset, user_zoffset, user_angle,
							WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE|WARPF_ABSOLUTEANGLE);
	TNT1 A 0 A_SetUserVar("user_angle", user_angle + 8);
	TNT1 A 0 A_SpawnItemEx("PossessionWarperTrail", 0, 0, 0, 0, 0, 0, 0,
							SXF_NOCHECKPOSITION|SXF_TRANSFERTRANSLATION);
	TNT1 A 0 A_FadeOut(0.02);
	Loop;
  }
}

class PossessionWarperB : PossessionWarperA
{
  States
  {
  Spawn:
	TNT1 A 0 NoDelay A_SetUserVar("user_xoffset", -32);
	Goto SetVars;
  }
}

class PossessionWarperTrail : actor
{
    Default {
  RenderStyle "Translucent";
  Scale 0.7;
  +NOINTERACTION;
  +SQUAREPIXELS;
  +FORCEXYBILLBOARD;
  }
  States
  {
  Spawn:
	MSP2 A 1 Bright {
			if(Scale.X <= 0.0){
				A_FadeOut(1.0);
			}
			A_SetScale(Scale.X-0.05, Scale.Y-0.05);
	}
	Wait;
  }
}

// Possession setup "scripts" ---------------------------------------------------------------------

class PossessMonster : CustomInventory
{
  States
  {
  Pickup: // "Forces" the to-be-possessed monster to enter the Possession state
	TNT1 A 0 ACS_NamedExecuteAlways("Pos - Execute Possession state");
	Stop;
  }
}

class UnSkullFly : CustomInventory
{
  States
  {
  Pickup:
	// The Lost Soul or any monster that charges at its target using A_SkullAttack or variant of
	// the function gets the following exectued on it in case it was charging at the moment when it
	// was struck by the possession projectile.
	TNT1 A 0 A_ChangeFlag("SKULLFLY", FALSE); // Free the monster from the shackles of SKULLFLY...
	TNT1 A 0 A_Stop; // ... and stop it in its tracks.
	Stop;
  }
}

// Effect timer
class PossessionEffect : Powerup { Default{Powerup.Duration -45;} }

class SpawnPossessionWarpers : CustomInventory
{
  States
  {
  Pickup:
	TNT1 A 0 A_GiveInventory("PossessionEffect", 1);
	TNT1 A 0 A_SpawnItemEx("PossessionWarperA", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER|SXF_NOCHECKPOSITION);
	TNT1 A 0 A_SpawnItemEx("PossessionWarperB", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER|SXF_NOCHECKPOSITION);
	Stop;
  }
}

// Theres somehow a modeldef for this one
class TossedHellRifle : actor
{
    Default
    {
        // SpawnID 9900
        Radius 8;
        Height 8;
        Scale 0.48;
        Speed 8;
        Mass 1;
        gravity 0.5;
        Decal "BrutalBloodSplat";
        BounceFactor 0.4;
        BounceCount 3;
        BounceType "Doom";
        +MOVEWITHSECTOR;
        //+CLIENTSIDEONLY
        +NOBLOCKMAP;
        +NOTELEPORT;
        +MISSILE;
        -EXPLODEONWATER;
        +DONTSPLASH;
        +Rollsprite;
    }
	States
	{
	Spawn.V5:
		TNT1 A 0 A_jumpif( V5_MODELS == 0 , "Spawn");
		VRPU A 2 A_SetRoll(roll+30);
	Spawn:
		TNT1 A 0 NoDelay A_jumpif( V5_MODELS == 1 , "Spawn.V5");
		HRPU A 2 A_SetRoll(roll+30);
		LOOP;
	Death:
		TNT1 A 0 A_jumpif( V5_MODELS == 1 , "Death.V5");
		HRPU A 1 A_SetRoll(0);
		TNT1 A 0 A_SpawnItemEx("PB_DTechRifle",0,0,0,0,0,0,0,SXF_TRANSFERSPECIAL | 288);
		Stop;
	Death.V5:
		VRPU A 1 A_SetRoll(0);
		TNT1 A 0 A_SpawnItemEx("PB_DTechRifle",0,0,0,0,0,0,0,SXF_TRANSFERSPECIAL | 288);
		Stop;
		
	
	ReplaceVanilla:
		TNT1 A 1;
		TNT1 A 0 A_SpawnItemEx("PB_Shell",0,0,0,0,0,0,0,SXF_TRANSFERSPECIAL | 288);
		Stop;
	}
}