// Ammo Class
Class PB_SSGMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_SSG.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_SSG.MAGAZINE_SIZE;
		Inventory.Icon "SGN3A0";
	}
}

Class PB_SSGLeftMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_SSG.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_SSG.MAGAZINE_SIZE;
		Inventory.Icon "SGN3A0";
	}
}

// The Actual Weapon
class PB_SSG : PB_WeaponBase
{
    Default
    {
        //$Title Double Barreled Shotgun
        //$Category Project Brutality - Weapons
        //$Sprite SGN3A0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        // Game Doom
        Weapon.Kickback 50;
        weapon.slotpriority 0.25;
        Weapon.SelectionOrder 400;

        Weapon.AmmoGive1 8;
        Weapon.AmmoType "PB_Shell";
        Weapon.AmmoType2 "PB_SSGMag";
        PB_WeaponBase.AmmoTypeLeft "PB_SSGLeftMag";

        Inventory.MaxAmount 2;
        Scale 0.5;
        FloatBobStrength 0.5;

        Inventory.AltHUDIcon "SGN3A0";
        PB_WeaponBase.Upgrade "PB_QuadSG";
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.PickupSound "CLIPINQS";
        Inventory.PickupMessage "$PB_SSG_PICKUP";
        Obituary "%o was splattered by %k's SSG";
	    Tag "$PB_SSG_TAG";
        //FloatBobStrength 0.5
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    // AmmoTakes (Is this stupid? yes)
    const AMMO_TAKE_FULL      = 2;
    const AMMO_TAKE_HALF      = 1;
    // Tracks the spent casings
    int ssgSpentR;
    int ssgSpentL;
    // Fire Animation
    int ssgFireAnimation;
	const MAGAZINE_SIZE = 2; // This is just for consistency

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    
    action int getSpentR()
    {
        return invoker.ssgSpentR;
    }

    action int getSpentL()
    {
        return invoker.ssgSpentL;
    }

    action int getFireAnimation()
    {
        return invoker.ssgFireAnimation;
    }

    action void setSpentR(int set)
    {
        invoker.ssgSpentR = set;
    }

    action void setSpentL(int set)
    {
        invoker.ssgSpentL = set;
    }

    action void setFireAnimation(int set)
    {
        invoker.ssgFireAnimation = set;
    }

    action void SSG_Altfire(int tic, bool isLeft)
    {
        double smokeOfs   = isLeft ?  2 : -2;
        double wadOfs     = isLeft ? -4 :  3;

        switch(tic)
        {
            case 1:
                if(isLeft) A_FlashOverlay(state:"HalfFlash2");
                else       A_FlashOverlay(state:"HalfFlash1");

                PB_IncrementHeat(10, isLeft);
                PB_FireBullets("PB_10GAPellet", 10, 7, 0, 0, 6);
                PB_GunSmoke(smokeOfs, 0, 0); PB_MuzzleFlashEffects(smokeOfs, 0, 0);
                A_StartSound("weapons/shh2", CHAN_Weapon, CHANF_DEFAULT, 1.0);
                PB_DynamicTail("shotgun", "shotgun");
                PB_TakeAmmo(invoker.ammo2.getClassName(), AMMO_TAKE_HALF, 0);
                setSpentR(AMMO_TAKE_HALF);
                A_ZoomFactor(0.98);
                break;

            // This is just effects stuff
            case 2: case 3:
                A_ZoomFactor(tic == 2 ? 0.99 : 1.0);
                PB_GunSmoke(smokeOfs, 0, 0); PB_MuzzleFlashEffects(smokeOfs, 0, 0);
                if(tic == 2) A_FireProjectile("ShotgunWad", random(-2,2), 0, wadOfs, -4, FPF_NOAUTOAIM, random(-2,2));
                PB_WeaponRecoil(-1.50, +1.0);
                break;
        }
    }

    action void SSG_FireNormal(int tic)
    {
        switch(tic)
        {
            case 0:
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(40);
                A_SetInventory("PB_LockScreenTilt",0);
                break;

            case 1:
                // Overlays
                PB_IncrementHeat(10);
                PB_IncrementHeat(10, true);
                A_FlashOverlay();

                // Fire
                PB_FireBullets("PB_10GAPellet_LP",1,0,0,0,0);
                PB_FireBullets("PB_10GAPellet",20,8,0,0,6);

                // Effects and Sounds
                PB_GunSmoke(-2,0,0); PB_MuzzleFlashEffects(-2,0,0);
                PB_GunSmoke(2,0,0); PB_MuzzleFlashEffects(2,0,0);
                A_StartSound("SSHFIRE", CHAN_Weapon, CHANF_DEFAULT, 1.0);
                PB_DynamicTail("shotgun", "dbshotgun");
                A_ZoomFactor(0.95);
                
                // Take Ammo + More Effects
                PB_TakeAmmo(invoker.ammo2.getClassName(),AMMO_TAKE_FULL,0);
                setSpentR(AMMO_TAKE_FULL);
                A_AlertMonsters();
                break;

            case 2:
                PB_GunSmoke(2,0,0); PB_MuzzleFlashEffects(2,0,0);
                PB_GunSmoke(-2,0,0); PB_MuzzleFlashEffects(-2,0,0);
                A_FireProjectile("ShotgunWad",random(-2,2),0,3,-4,FPF_NOAUTOAIM,random(-2,2));
                A_FireProjectile("ShotgunWad",random(-2,2),0,-3,-4,FPF_NOAUTOAIM,random(-2,2));
                break;

            case 3: case 4:
                A_ZoomFactor(tic == 3 ? 0.975 : 1.0);
                PB_WeaponRecoil(-2.20,+0.40);
                break;
        }
    }

    action void HandleSSGShot(int ammoLeft, bool isLeft)
    {
        bool singleShot = (ammoLeft == 1);
        double smokeA   = isLeft ?  3  : -3;
        double smokeB   = isLeft ?  5  : -5;
        double wadA     = isLeft ? -10 :  6;
        double wadB     = isLeft ?  -6 : 10;

        // Bullets
        if (singleShot) {
            PB_FireBullets("PB_10GAPellet", 10, 8, 0, 0, 6);
            A_StartSound("weapons/shh2", CHAN_Weapon, CHANF_DEFAULT, 1.0);
        }
        else {
            PB_FireBullets("PB_10GAPellet_LP", 1, 0, 0, 0, 0);
            PB_FireBullets("PB_10GAPellet", 20, 8, 0, 0, 6);
            A_StartSound("SSHFIRE", CHAN_Weapon, CHANF_DEFAULT, 1.0);
        }

        // Shared effects
        PB_DynamicTail("shotgun", "shotgun");
        PB_GunSmoke(smokeA, 0, 0); PB_MuzzleFlashEffects(smokeA, 0, 0);
        PB_GunSmoke(smokeB, 0, 0); PB_MuzzleFlashEffects(smokeB, 0, 0);
        A_ZoomFactor(0.95);

        setFireAnimation(isLeft ? 2 : 1);

        // Ammo
        int ammoToTake = singleShot ? AMMO_TAKE_HALF : AMMO_TAKE_FULL;
        if (isLeft) {
            PB_TakeAmmo(invoker.AmmoLeft.getClassName(), ammoToTake, 0, 0, true);
            setSpentL(ammoToTake);
        }
        else {
            PB_TakeAmmo(invoker.ammo2.getClassName(), ammoToTake, 0);
            setSpentR(ammoToTake);
        }

        // Wads
        A_FireProjectile("ShotgunWad", random(-1,1), 0, wadA, -2, FPF_NOAUTOAIM, random(-1,1));
        if (!singleShot) A_FireProjectile("ShotgunWad", random(-1,1), 0, wadB, -2, FPF_NOAUTOAIM, random(-1,1));
    }

    action void SSG_FireOverlay(int tic, bool isLeft)
    {
        double recoilY    = isLeft ? +2.40 : -2.40;
        int    ammoNow    = isLeft ? invoker.AmmoLeft.amount : invoker.ammo2.amount;

        switch(tic)
        {
            case 1:
                PB_IncrementHeat(10, isLeft);
                // Blame the zdoom bug for this one
                if(isLeft) {
					A_FlashOverlay(LEFT_FLASH_LAYER, "LeftFlash");
					A_SetFiringLeftWeapon(true);
				}
                else {
					A_FlashOverlay(RIGHT_FLASH_LAYER, "RightFlash");
					A_SetFiringRightWeapon(true);
				}
                A_AlertMonsters();
                HandleSSGShot(ammoNow, isLeft);
                break;

            case 2:
                double smokeA = isLeft ?  3 : -3;
                double smokeB = isLeft ?  5 : -5;
                PB_GunSmoke(smokeA, 0, 0); PB_MuzzleFlashEffects(smokeA, 0, 0);
                PB_GunSmoke(smokeB, 0, 0); PB_MuzzleFlashEffects(smokeB, 0, 0);
                break;

            case 3: case 4: case 5:
                if(tic != 5) A_ZoomFactor(tic == 3 ? 0.975 : 1.0);
                PB_WeaponRecoil(-3.80, recoilY);
                break;

            case 6:
                if (isLeft) {
                    if (invoker.AmmoLeft.amount <= 0 || invoker.ammo2.amount > 0)
                        A_GiveInventory("DualFiring", 1);
                }
                else {
                    if (invoker.AmmoLeft.amount > 0 || invoker.ammo2.amount <= 0)
                        A_TakeInventory("DualFiring", 1);
                }
                break;

            case 7:
				if(isLeft) {
					A_SetFiringLeftWeapon(false);
				}
				else {
					A_SetFiringRightWeapon(false);
				}
                break;
        }
    }

    action state SSG_CheckAkimbo(bool switchtoDual)
    {
        if(!switchtoDual)
        {
            A_SetInventory("GoWeaponSpecialAbility",0);
            A_SetInventory("PB_LockScreenTilt",1);
            PB_ClearDualWield();
            PB_HandleCrosshair(40);

            if(invoker.amount >= 2) return ResolveState("SwitchToDualWield");

            A_Print("$PB_SSG_NOAKIMBO");
        }
        else
        {
            A_PlaySoundEx("Ironsights", "Auto");
            if (A_CheckAkimbo()) {
                A_SetAkimbo(False);
                return ResolveState("SwitchFromDualWield");
            }
            else {
                A_SetAkimbo(True);
                return ResolveState(null);
            }
        }
        return ResolveState(null);
    }

    action state SSG_Ready()
    {
        if(A_CheckAkimbo())
            return ResolveState("ReadyDualWield");

        PB_ClearDualWield();
        A_SetInventory("PB_LockScreenTilt",0);
        PB_HandleCrosshair(40);
        PB_SetRoll(0);

        if(A_CheckAkimbo())
            return ResolveState("ReadyToFireDualWield");
        return ResolveState(null);
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            VGN2 A 0 NoDelay;
            SGN3 A 10 A_PbvpFramework("VGN2");
            "####" "#" 0 A_PbvpInterpolate();
            Loop;

        WeaponRespect:
            TNT1 A 0 {
                A_SetInventory("PB_LockScreenTilt",1);
                A_PlaySoundEx("Ironsights", "Auto");
                A_SetCrosshair(-1);
            }
            SG50 EFGHIJKLMNO 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect1", "Auto");
            SG50 PQRSTUVWXYZ 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open", "Auto");
            SG51 ABCDEFGHIJKLMNOPQRST 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect2", "Auto");
            SG51 UVWXYZ 1 A_DoPBWeaponAction();
            SG52 ABCDEFGHIJK 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect2", "Auto");
            SG52 LMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
            SG53 ABCDE 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect3", "Auto");
            SG53 FGHIJKLMNOPQRST 1 A_DoPBWeaponAction();
            Goto Ready3;

        Deselect:
            TNT1 A 0 {
                PB_ClearDualWield();
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
            }
            TNT1 A 0 A_SetInventory("SSGSelected",0) ;
            TNT1 A 0; //A_JumpIfInventory("PB_QuadSG",1,"DeselectUpgrade")
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"DeselectAnimationDualWield");
            SHO9 FEDC 1;
            TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
            Wait;

        DeselectAnimationDualWield:
            P6SS DCBA 1;
            TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
            Wait;

        SelectAnimationDualWield:
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect4", "Auto");
            P6SS ABCD 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect4", "Auto");
            Goto ReadyDualWield;

        Select:
            TNT1 A 0 {
                PB_ClearDualWield();
                A_SetInventory("PB_LockScreenTilt",0);
                PB_WeapTokenSwitch("SSGSelected");
                A_SetInventory("HasNotPickedUpSSG",0);
                PB_HandleCrosshair(40);
                PB_SelectIfUpgrade("PB_QuadSG");
                PB_WeaponRaise("weapons/ssg/inspect4");
			    return PB_RespectIfNeeded();
            }
        SelectAnimation:
		    TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
		    SG1S DCBA 1;
        // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
		    TNT1 A 0 SSG_Ready();
	    ReadyToFire:	
            TNT1 A 0 PB_SelectIfUpgrade("PB_QuadSG"); //A_SelectWeapon("PB_QuadSG")
            SHT3 A 1 {
                PB_CoolDownBarrel(2, 0, 3);
                PB_CoolDownBarrel(-2, 0, 3);
                if (PressingFire() && invoker.AmmoLeft.amount > 0 ){
                        return ResolveState("Fire");
                }
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            }
            Loop;

        ReadyDualWield:
            TNT1 A 0 PB_SelectIfUpgrade("PB_QuadSG"); //A_SelectWeapon("PB_QuadSG")
            TNT1 A 0 PB_SetupDualWield(crosshair:40);
        ReadyToFireDualWield:
            TNT1 A 0 PB_SelectIfUpgrade("PB_QuadSG");
            TNT1 A 1 A_DoPBDualAction();
            Loop;

        IdleLeft_Overlay:
            P6SS H 1 {
                PB_CoolDownBarrel(13, 0, 3);
                PB_CoolDownBarrel(8, 0, 3);
                return A_DoPBLeftAction();
            }
            Loop;

        IdleRight_Overlay:
            P6SS G 1 {
                PB_CoolDownBarrel(-13, 0, 3);
                PB_CoolDownBarrel(-8, 0, 3);
                return A_DoPBRightAction();
            }
            Loop;

        StopDualWield:
            TNT1 A 0 {
                PB_ClearDualWield();
                A_SetAkimbo(false);
            }
            Goto Ready3;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        FireLeft_Overlay:
            P6W2 A 1 BRIGHT SSG_FireOverlay(1, true);
            P6W2 B 1 BRIGHT SSG_FireOverlay(2, true);
            P6W2 C 1        SSG_FireOverlay(3, true);
            P6W2 D 1        SSG_FireOverlay(4, true);
            P6W2 E 1        SSG_FireOverlay(5, true);
            P6W2 F 1        SSG_FireOverlay(6, true);
            P6W2 GHIJK 1;
			TNT1 A 0        SSG_FireOverlay(7, true);
            Goto IdleLeft_Overlay;

        FireRight_Overlay:
            P6W1 A 1 BRIGHT SSG_FireOverlay(1, false);
            P6W1 B 1 BRIGHT SSG_FireOverlay(2, false);
            P6W1 C 1        SSG_FireOverlay(3, false);
            P6W1 D 1        SSG_FireOverlay(4, false);
            P6W1 E 1        SSG_FireOverlay(5, false);
            P6W1 F 1        SSG_FireOverlay(6, false);
            P6W1 GHIJK 1;
            TNT1 A 0        SSG_FireOverlay(7, false);
            Goto IdleRight_Overlay;
        
        Fire:
            TNT1 A 0 SSG_FireNormal(0);
            TNT1 A 0 PB_JumpIfNoAmmo("AltFire2",2,true,true,"");
            SHO9 A 1 BRIGHT SSG_FireNormal(1);
            SHO9 B 1 BRIGHT SSG_FireNormal(2);
            SHO8 C 1        SSG_FireNormal(3);
            SHO8 D 1        SSG_FireNormal(4);
            SHO8 EFGHIJJKLM 1;
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount >= 1, "Reload"); 
            Goto Ready3;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
            TNT1 A 0 {
                A_WeaponOffset(0, 32);
                PB_SetRoll(0);
                PB_HandleCrosshair(40);
            }
            TNT1 A 0 PB_JumpIfNoAmmo("AltFire2", 2, true, true, "");
            SHTA A 1 BRIGHT SSG_Altfire(1, isLeft:false);
            SHTA B 1 BRIGHT SSG_Altfire(2, isLeft:false);
            SHO8 C 1        SSG_Altfire(3, isLeft:false);
            SHO8 LCM 1;
            SHT3 A 2;
            TNT1 A 0 PB_ReFire("AltFire2");
            Goto Ready3;

        AltFire2:
            TNT1 A 0 PB_JumpIfNoAmmo();
            SHTA C 1 BRIGHT SSG_Altfire(1, isLeft:true);
            SHTA D 1 BRIGHT SSG_Altfire(2, isLeft:true);
            SHO8 C 1        SSG_Altfire(3, isLeft:true);
            SHO8 LCM 1;
            Goto Reload;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
            TNT1 A 0 SSG_CheckAkimbo(switchtoDual:false);
            Goto Ready3;
            
        SwitchToDualWield:
            TNT1 A 0 SSG_CheckAkimbo(switchtoDual:true);
            SG3S ABCD 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect4", "Auto");
            SG3S EFGHIJ 1;
            Goto ReadyDualWield;
        
        SwitchFromDualWield:
            SG3S JIHGFE 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect4", "Auto");
            SG3S DCBA 1 ;
            Goto Ready3;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
        Reload:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
            TNT1 A 0 PB_CheckReload(null,null,null,"Ready3","Ready3",MAGAZINE_SIZE);
            TNT1 A 0 {
                A_SetInventory("PB_LockScreenTilt",1);
                setFireAnimation(0);
                A_SetCrosshair(-1);
            }
            TNT1 A 0 A_DoPBWeaponAction(WRF_NOFIRE);
            SG10 ABC 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open", "Auto");
            SG10 DEFG 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            TNT1 A 0 A_JumpIf(invoker.ammo2.amount < 1, "FullReload");
        HalfReload:
            TNT1 A 0 {
                if(getSpentR() > 0) PB_SpawnCasing("ShotgunCasing",15,3,30,-1,5,4);
                setSpentR(0);
            }
            SG12 AB 1 PB_SetRoll(roll-1.0);
            SG12 CDEFGHIJ 1;
            SG12 KL 1 PB_SetRoll(roll+2.0);
            SG12 MNO 1 PB_SetRoll(roll-1.0);
            TNT1 A 0 {
                A_PlaySoundEx("weapons/ssg/inspect2", "Auto");
                PB_AmmoIntoMag(invoker.ammo2.getClassName(), invoker.ammo1.getClassName(), MAGAZINE_SIZE);
                PB_SetMagEmpty(false);
                PB_SetChamberEmpty(false);
            }
            SG10 WXY 1 PB_SetRoll(roll-1.0);
            SG10 Z 1;
            SG11 ABC 1;
            SG12 YZ 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect3", "Auto");
            SG11 FGHIJKLMNOPQRST 1;
            SHT3 A 1 PB_ReFire();
            Goto Ready3;

        FullReload:
            TNT1 A 0 {
                if(getSpentR() > 0) {
                    PB_SpawnCasing("ShotgunCasing",14,-3,30,-1,4,4);
                    if(getSpentR() > 1) PB_SpawnCasing("ShotgunCasing",15,3,30,-1,5,4);
                }
                setSpentR(0);
            }
            SG10 HI 1 PB_SetRoll(roll-1.0);
            SG10 JKLMNOPQ 1;
            SG10 RS 1 PB_SetRoll(roll+2.0);
            SG10 TUV 1 PB_SetRoll(roll-1.0);
            TNT1 A 0 {
                A_PlaySoundEx("weapons/ssg/inspect2", "Auto");
                PB_AmmoIntoMag(invoker.ammo2.getClassName(), invoker.ammo1.getClassName(), MAGAZINE_SIZE);
                PB_SetMagEmpty(false);
                PB_SetChamberEmpty(false);
            }
            SG10 WXY 1 PB_SetRoll(roll-1.0);
            SG10 Z 1;
            SG11 ABCDE 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect3", "Auto");
            SG11 FGHIJKLMNOPQRST 1;
            SHT3 A 1 PB_ReFire();
            Goto Ready3;

        NoAmmoDualWield:
            TNT1 A 1;
            Goto Ready3;
            
        ReloadDualWield:
            TNT1 A 0 PB_CheckReload(null,null,null,"ReloadOnlyLeft","Ready3",MAGAZINE_SIZE);
            TNT1 A 0 PB_ClearDualWield();
            P6SS DC 1 A_SetPitch(pitch-0.4, SPF_INTERPOLATE);
            P6SS BA 1 A_SetPitch(pitch+0.4, SPF_INTERPOLATE);
            TNT1 A 3;
        ReloadRight:
            SGAR ABCDEFGHI 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open", "Auto");
            SGAR KJOP 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            TNT1 A 0 A_JumpIf(invoker.ammo2.amount >= 1, "HalfReloadRight");
            TNT1 A 0 {
                if(getSpentR() > 0) {
                    PB_SpawnCasing("ShotgunCasing",14,-3,30,-1,4,4);
                    if(getSpentR() > 1) PB_SpawnCasing("ShotgunCasing",15,3,30,-1,5,4);
                }
                setSpentR(0);
            }
            SG10 HI 1 PB_SetRoll(roll-1.0);
            SG10 JKLMNOPQ 1;
            SG10 RS 1 PB_SetRoll(roll+2.0);
            SG10 TUV 1 PB_SetRoll(roll-1.0);
            TNT1 A 0 {
                A_PlaySoundEx("weapons/ssg/inspect2", "Auto");
                PB_AmmoIntoMag(invoker.ammo2.getClassName(), invoker.ammo1.getClassName(), MAGAZINE_SIZE);
                PB_SetMagEmpty(false);
                PB_SetChamberEmpty(false);
            }
            SG10 WXY 1 PB_SetRoll(roll-1.0);
            SG10 Z 1;
            SG11 ABCDE 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect3", "Auto");
            SG11 FGHIJKLMNO 1;
            SGAR QR 1;
            TNT1 A 3;
            TNT1 A 0 A_JumpIf(invoker.AmmoLeft.amount == 2 || invoker.ammo1.amount < 1, "FinishReloadDualWield");
            Goto ReloadLeft;

        ReloadOnlyLeft:
            TNT1 A 0 PB_CheckReload(null,null,null,"Ready3","Ready3",MAGAZINE_SIZE,1,true);
            TNT1 A 0 PB_ClearDualWield();
            P6SS DC 1 A_SetPitch(pitch-0.4, SPF_INTERPOLATE);
            P6SS BA 1 A_SetPitch(pitch+0.4, SPF_INTERPOLATE);
            TNT1 A 3;
        ReloadLeft:
            SGAL ABCDEFGHI 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open", "Auto");
            SGAL KJOP 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            TNT1 A 0 A_JumpIf(invoker.AmmoLeft.amount >= 1, "HalfReloadLeft");
            TNT1 A 0 {
                if(getSpentL() > 1) {
                    PB_SpawnCasing("ShotgunCasing",14,3,30,-1,-5,4);
                    PB_SpawnCasing("ShotgunCasing",15,-3,30,-1,-4,4);
                }
                setSpentL(0);
            }
            SGAL QR 1 PB_SetRoll(roll+1.0);
            SGAL STUVWXYZ 1;
            S1AL AB 1 PB_SetRoll(roll-2.0);
            S1AL CDE 1 PB_SetRoll(roll+1.0);
            TNT1 A 0 {
                A_PlaySoundEx("weapons/ssg/inspect2", "Auto");
                PB_AmmoIntoMag(invoker.AmmoLeft.getClassName(), invoker.ammo1.getClassName(), MAGAZINE_SIZE);
                PB_SetMagEmpty(false,true);
                PB_SetChamberEmpty(false,true);
            }
            S1AL FGH 1 PB_SetRoll(roll+1.0);
            S1AL IJKLMN 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/inspect3", "Auto");
            S1AL OPQRSTUVWXYZ 1;
        FinishReloadDualWield:
            TNT1 A 0 A_SetInventory("DualFireReload",0);
            TNT1 A 3;
            P6SS AB 1 A_SetPitch(pitch-0.4, SPF_INTERPOLATE);
            P6SS CD 1 A_SetPitch(pitch+0.4, SPF_INTERPOLATE);
            Goto ReadyDualWield;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
        Unload:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "UnloadDualWield");
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty() && getSpentR() == 0, "Ready3");
            SG10 ABC 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open", "Auto");
            SG10 DEF 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_JumpIf(invoker.ammo2.amount < 1,"UnloadEmpty");
            SG10 Y 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            SG10 XW 1;
            TNT1 A 0 {
                if(getSpentR() > 0) 
                    PB_SpawnCasing("ShotgunCasing",15,3,30,-1,5,4);
                setSpentR(0);
                A_PlaySound("weapons/ssg/inspect2", 0);
                PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),1,1,1,0,"PB_SingleShell");
                PB_SetChamberEmpty(true);
                PB_SetMagEmpty(true);
            }
            SG10 VUTSRQPONMLK 1;
            Goto FinishUnload;

        UnloadEmpty:
            SG10 G 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            TNT1 A 0 {
                if(getSpentR() > 0)  {
                    PB_SpawnCasing("ShotgunCasing",14,-3,30,-1,4,4);
                    if(getSpentR() > 1) {
                        PB_SpawnCasing("ShotgunCasing",15,3,30,-1,5,4);
                        PB_SetChamberEmpty(true);
                    }
                }
                setSpentR(0);
            }
            SG10 HI 1 PB_SetRoll(roll-1.0);
        FinishUnload:
            SG10 J 5;
            SG10 IHG 1;
            TNT1 A 0 A_PlaySound("weapons/ssg/inspect3", 0);
            SG1S DCBA 1;
            Goto Ready3;

        UnloadDualWield:
            TNT1 A 0 A_JumpIf(
                PB_GetChamberEmpty() && 
                getSpentR() == 0 && 
                PB_GetChamberEmpty(true) && 
                getSpentL() == 0, 
                "Ready3");
            TNT1 A 0 PB_ClearDualWield();
            P6SS DC 1 A_SetPitch(pitch-0.4, SPF_INTERPOLATE);
            P6SS BA 1 A_SetPitch(pitch+0.4, SPF_INTERPOLATE);
            TNT1 A 3;
            TNT1 A 0 A_JumpIf(getSpentR() == 0 && PB_GetChamberEmpty(),"UnloadLeft");
            SGAR ABCDEFGHI 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open", "Auto");
            SGAR KJOP 1;
            TNT1 A 0 A_JumpIf(invoker.ammo2.amount < 1, "UnloadEmptyRight");
            SG10 Y 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            SG10 XW 1;
            TNT1 A 0 {
                if(getSpentR() > 0) 
                    PB_SpawnCasing("ShotgunCasing",15,3,30,-1,5,4);
                setSpentR(0);
                A_PlaySound("weapons/ssg/inspect2", 0);
                PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),1,1,1,0,"PB_SingleShell");
                PB_SetChamberEmpty(true);
                PB_SetMagEmpty(true);
            }
            SG10 VUTSRQPONMLK 1;
            Goto FinishUnloadRight;

        UnloadEmptyRight:
            SG10 G 1 PB_SetRoll(roll+0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            TNT1 A 0 {
                if(getSpentR() > 0)  {
                    PB_SpawnCasing("ShotgunCasing",14,-3,30,-1,4,4);
                    if(getSpentR() > 1) {
                        PB_SpawnCasing("ShotgunCasing",15,3,30,-1,5,4);
                        PB_SetChamberEmpty(true);
                    }
                }
                setSpentR(0);
            }
            SG10 HI 1 PB_SetRoll(roll-1.0);
        FinishUnloadRight:
            SG10 J 5;
            SG10 IHG 1;
            TNT1 A 0 A_PlaySound("weapons/ssg/inspect3", 0);
            TNT1 A 3;
            TNT1 A 0 A_JumpIf(getSpentL() == 0 && PB_GetChamberEmpty(true), "FinishDualUnload");
        UnloadLeft:
            SGAL ABCDEFGHI 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open", "Auto");
            SGAL KJOP 1;
            TNT1 A 0 A_JumpIf(invoker.AmmoLeft.amount < 1, "UnloadEmptyLeft");
            S1AL F 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            S1AL ED 1;
            TNT1 A 0 {
                setSpentL(0);
                A_PlaySound("weapons/ssg/inspect2", 0);
                PB_UnloadMag(invoker.AmmoLeft.getClassName(),invoker.ammo1.getClassName(),1,1,1,0,"PB_SingleShell");
                PB_SetChamberEmpty(true,true);
                PB_SetMagEmpty(true,true);
            }
            S1AL CBA 1;
            SGAL YXWVU 1;
            Goto FinishUnloadLeft;

        UnloadEmptyLeft:
            SGAL Q 1 PB_SetRoll(roll-0.5);
            TNT1 A 0 A_PlaySoundEx("weapons/ssg/open2", "Auto");
            TNT1 A 0 {
                PB_SpawnCasing("ShotgunCasing",14,3,30,-1,-5,4);
                PB_SpawnCasing("ShotgunCasing",15,-3,30,-1,-4,4);
                setSpentL(0);
                A_PlaySound("weapons/ssg/inspect2", 0);
                PB_UnloadMag(invoker.AmmoLeft.getClassName(),invoker.ammo1.getClassName(),1,1,1,0,"PB_SingleShell");
                PB_SetChamberEmpty(true,true);
                PB_SetMagEmpty(true,true);
            }
            SGAL RS 1 PB_SetRoll(roll+1.0);
        FinishUnloadLeft:
            SGAL T 5;
            SGAL SRQ 1;
            TNT1 A 0 A_PlaySound("weapons/ssg/inspect3", 0);
            TNT1 A 3;
        FinishDualUnload:
            P6SS AB 1 A_SetPitch(pitch-0.4, SPF_INTERPOLATE);
            P6SS CD 1 A_SetPitch(pitch+0.4, SPF_INTERPOLATE);
            Goto Ready3;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        MuzzleFlash:
			SH2M AB 1 Bright A_GunFlash();
			Stop;
		HalfFlash1:
			SH2M CD 1 Bright A_GunFlash();
			Stop;
		HalfFlash2:
			SH2M EF 1 Bright A_GunFlash();
			Stop;
        LeftFlash:
			P6WM CD 1 Bright A_GunFlash();
			Stop;
        RightFlash:
			P6WM AB 1 Bright A_GunFlash();
			Stop;

        DualWieldFlashPunching:
            TNT1 A 15;
            Goto Ready3;
        DualWieldFlashKicking:
            P6SK ABCDEFGGGFEDCBA 1;
            Goto Ready3;
        DualWieldFlashAirKicking:
            P6SK ABCDEFGGGFEDCBA 1;
            P6SK AAA 1;
            Goto Ready3;
        DualWieldFlashSlideKicking:
            P6SK ABCDEFGGGGGGGGGGGGGFEDCBA 1;
            Goto Ready3;
        DualWieldFlashSlideKickingStop:
            P6SK FEDCA 1 ;
            P6SK AAA 1;
            Goto Ready3;
            
        FlashPunching:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldFlashPunching");
            SG21 ABCDEFGGGFEDCBA 1;
            Goto Ready3;
        FlashKicking:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldFlashKicking");
            SG20 ABCDEFGGGFEDCBA 1;
            Goto Ready3;
        FlashAirKicking:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldFlashAirKicking");
            SG20 ABCDEFGGGFEDCBA 1;
            SHT3 AAA 1;
            Goto Ready3;
        FlashSlideKicking:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldFlashSlideKicking");
            SG20 ABCDEFGGGGGGGGGGGGGFEDCBA 1;
            Goto Ready3;
        FlashSlideKickingStop:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldFlashSlideKickingStop");
            SG20 FEDCA 1;
            SHT3 AAA 1;
            Goto Ready3;
    }
}