// Ammo Class
Class PB_MP40Mag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_MP40.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_MP40.MAGAZINE_SIZE;
		Inventory.Icon "AMP4A0";
	}
}

Class PB_MP40LeftMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_MP40.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_MP40.MAGAZINE_SIZE;
		Inventory.Icon "AMP4A0";
	}
}

// The Actual Weapon
class PB_MP40 : PB_WeaponBase
{
    Default
    {
        //$Title MP-40
        //$Category Project Brutality - Weapons
        //$Sprite AMP4A0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        // SpawnID 9200
        Weapon.AmmoGive1 20;
        Weapon.AmmoType1 "PB_LowCalMag";
        Weapon.AmmoType2 "PB_MP40Mag";

        PB_WeaponBase.AmmoTypeLeft "PB_MP40LeftMag";
        PB_WeaponBase.OffsetRecoilX 2.5;
        PB_WeaponBase.OffsetRecoilY 2.5;

        Inventory.MaxAmount 2;
        Inventory.Amount 1;
        Inventory.AltHUDIcon "AMP4A0";
        FloatBobStrength 0.5;
        Scale 0.25;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Obituary "%o was put against the wall by %k's Maschinenpistole 40.";
        Inventory.PickupSound "weapons/MP40_pickup";
        Inventory.Pickupmessage "$PB_MP40_PICKUP";
        Tag "$PB_MP40_TAG";
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.WIMPY_WEAPON;
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	const MAGAZINE_SIZE = 32;
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

    // This is for the normal fire
    action void MP40_Fire(int tic)
    {
        bool ads        = PB_GetZoom();         // So we dont need to make another function just for zoom fire
        double recoilX  = ads ? -0.15 : -0.19;  // Sets recoil
        double recoilY  = ads ? +0.13 : +0.17;
        double zoomA    = ads ?  1.24 :  0.985; // Sets the different zoomfactor
        double zoomB    = ads ?  1.245:  0.99;
        double zoomC    = ads ?  1.25 :  1.0;
        int casingDist  = ads ?  18   :  21;    // Just casing stuff
        int casingY     = ads ?   3   :   2;
        int casingZ     = ads ?  40   :  32;
        // string flashAnim = ads ? "Flash2Variation" : "FlashVariation"; // Zdoom bug lol

        switch(tic)
        {
            case 0:
                A_WeaponOffset(0, 32);
                PB_SetRoll(0);
                if(ads) A_SetCrosshair(-1);
                else    PB_HandleCrosshair(44);
                A_SetInventory("PB_LockScreenTilt", 0);
                break;

            case 1:
                PB_IncrementHeat();
                if(!ads) PB_FireOffset();
                A_AlertMonsters();
                A_StartSound("weapons/mp40_fire", CHAN_Weapon, CHANF_DEFAULT, 1.0);
                PB_DynamicTail("smg", "smg");
                PB_LowAmmoSoundWarning("smg");
                PB_FireBullets("PB_9x19mm", 1, 1.5, 0, 0, 1.5);
                A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
                PB_GunSmoke(0, 0, 0);
                PB_MuzzleFlashEffects(0, 0, 0);
                // A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
                PB_SpawnCasing("EmptyBrassMP40", casingDist, casingY, casingZ, frandom(-2,2), frandom(2,5), frandom(2,5), true, true);
                PB_TakeAmmo("PB_MP40Mag", 1, 0, 0);
                A_ZoomFactor(zoomA);
                A_GunFlash();

                if(ads) A_FlashOverlay(state:"Flash2Variation");
                else A_FlashOverlay(state:"FlashVariation");

                PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 2: case 3:
                A_ZoomFactor(tic == 2 ? zoomB : zoomC);
                if(tic == 2) PB_WeaponRecoil(recoilX, recoilY);
                break;
        }
    }

    // This is for the dual fire
    action void MP40_FireOverlay(int tic, bool isLeft)
    {
        // Sets up variables
        double smokeOfs     = isLeft ?  7 : -7;
        double flareOfs     = isLeft ? -4 :  4;
        double horOfs       = isLeft ? -11 : 14;
        double vertOfs      = isLeft ? 32 : 31;
        double horSpeed     = frandom(2,5);
        double vertSpeed    = isLeft ? frandom(0,3) : frandom(4,7);
        double recoilY      = isLeft ? +0.70 : -0.70;
        int flashLayer      = isLeft ? LEFT_FLASH_LAYER : RIGHT_FLASH_LAYER;
        string ammoClass    = isLeft 
            ? invoker.AmmoLeft.getClassName() 
            : invoker.ammo2.getClassName();

        switch(tic)
        {
            case 1:
                // This is for the gun smoke
                PB_IncrementHeat(1, isLeft);

                // Set up flashes
                if(isLeft) A_FlashOverlay(LEFT_FLASH_LAYER, "LeftFlashVariation");
                else A_FlashOverlay(RIGHT_FLASH_LAYER, "RightFlashVariation");

                // Start firing the weapon
                A_AlertMonsters();
                A_StartSound("weapons/mp40_fire", isLeft ? CHAN_7 : CHAN_6, CHANF_DEFAULT, 1.0);
                PB_DynamicTail("smg", "smg");
                
                if(isLeft) PB_LowAmmoSoundWarning("smg", invoker.AmmoLeft.getClassName());
                else PB_LowAmmoSoundWarning("smg");

                // Fire the bullet
                PB_FireBullets("PB_9x19mm", 1, 1.5, 0, 0, 1.5);

                // Effects
                A_FireCustomMissile("YellowFlareSpawn", 0, 0, flareOfs, 0);
                PB_GunSmoke(smokeOfs, 0, 0);
                PB_MuzzleFlashEffects(smokeOfs, 0, 0);
                PB_SpawnCasing("EmptyBrassMP40", 21, horOfs, vertOfs, frandom(-2,2), horSpeed, vertSpeed, true, true);

                // Take the ammo and end firing
                PB_TakeAmmo(ammoClass, 1, 0, 0, isLeft);
                A_ZoomFactor(0.985);
                A_GunFlash();
                PB_WeaponRecoil(-1.05, recoilY);
                break;

            case 2:
                A_ZoomFactor(0.99);
                if(isLeft) {
                    if(invoker.ammoleft.amount <= 0 || invoker.ammo1.amount > 0)
                        A_GiveInventory("DualFiring", 1);
                }
                else {
                    if(invoker.ammoleft.amount > 0 || invoker.ammo1.amount <= 0)
                        A_TakeInventory("DualFiring", 1);
                }
                PB_WeaponRecoil(-1.05, recoilY);
                break;

            case 3:
                A_ZoomFactor(1.0);
                PB_WeaponRecoil(-1.05, recoilY);
                break;

            case 4:
                if(isLeft && invoker.ammoleft.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                else if(!isLeft && invoker.ammo1.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                break;
        }
    }

    action state MP40_CheckSpecial()
    {
        A_SetInventory("GoWeaponSpecialAbility",0);
        PB_SetZoom(false);
        PB_ClearDualWield();
        A_SetInventory("PB_LockScreenTilt",1);
        PB_HandleCrosshair(44);
        A_ZoomFactor(1.0);

        if(A_CheckAkimbo())
            return ResolveState("StopDualWield");
        if(invoker.amount >= 2)
            return ResolveState("SwitchToDualWield");

        A_Print("$PB_MP40_NOAKIMBO");

        return ResolveState(null);
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            VMP4 A 0 NoDelay;
			AMP4 A 10 A_PbvpFramework("VMP4");
			"####" A 0 A_PbvpInterpolate();
		    Loop;
        WeaponRespect:
            TNT1 A 0 A_SetCrosshair(-1);
			MPSE ABCDE 1 A_DoPBWeaponAction();
			MRE1 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			MRE2 ABCDE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MP4DGT", 5);
			MRE2 FGHIJKLMNOPQRST 1 A_DoPBWeaponAction();
// 			TNT1 A 0 A_PlaySoundEx("weapons/MP40_up", "Auto")
			MRE2 TUVWXYZ 1 A_DoPBWeaponAction();
			MRE3 ABCDEFG 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MP4DGG", 5);
			MRE3 HIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			MRE4 ABCDE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MP4DG2", 5);
			MRE4 FGHIJKLMNOPQ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/MP40_striswhoosh", "Auto") ;
			TNT1 A 0 A_PlaySound("MP4DG2", 5);
			MRE4 RS 1 A_DoPBWeaponAction();
			MRE4 T 1 {
				A_DoPBWeaponAction();
				A_FireProjectile("MP40DogTag", 0, 0, 0, 0, FPF_NOAUTOAIM, 3);
			}
			MRE4 UVWXYZ 1 A_DoPBWeaponAction();
			MRE5 ABC 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/MP40_up", "Auto");
			MPSE ABCD 1 A_DoPBWeaponAction();
			Goto Ready3;
        Deselect:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
				PB_ClearDualWield();
			}
			TNT1 A 0 PB_SetZoom(false);
			TNT1 A 0 A_DestroyLaserPuff();
			TNT1 A 0 A_Overlay(-9, "Null");
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DeselectDualWield");
			MPSE DCBA 1;
			TNT1 A 0 A_Lower();
			Wait;
        DeselectDualWield:
			MP25 PONM 1;
			TNT1 A 0 A_Lower();
			Wait;
        SelectAnimationDualWield:
			MP25 MNOP 1;
			TNT1 A 0 A_StartSound("weapons/MP40_up", CHAN_AUTO);
            Goto ReadyDualWield;
        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
                PB_ClearDualWield();
				PB_HandleCrosshair(44);
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeaponRaise("weapons/MP40_up");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            TNT1 A 0 PB_SetZoom(false);
		    TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
			MPSE ABCD 1;
        // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        // Ready Normal
		Ready3:
            TNT1 A 0 {
				PB_SetRoll(0);
				PB_HandleCrosshair(44);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "UnloadedReady");
        ReadyToFire:
			MPSE E 1 {
				PB_CoolDownBarrel(-4.5, -2, -3, 0, frandom(0.5, 1.0), 0., 1, 0.5);
				PB_CoolDownBarrel(-4.5, -3.5, -3, 0, frandom(0.5, 1.0), 0, 1, 0.5);
				PB_CoolDownBarrel(-4.5, -5, -3, 0, frandom(0.5, 1.0), 0, 1, 0.5);
				return PB_ReadyFire(ads:false);
			}
			Loop;

        // Ready ADS
        Ready2:
			TNT1 A 0 {
				PB_SetRoll(0);
				A_SetCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:
			MPZO E 1 {
				PB_CoolDownBarrel(-1, 0, 0);
				return PB_ReadyFire(ads:true);
			}
			Loop;

        // Ready Dual Wield
        ReadyDualWield:
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "UnloadedReadyDualWield");
			TNT1 A 0 PB_SetupDualWield(crosshair:44);
		ReadyToFireDualWield:
			TNT1 A 1 A_DoPBDualAction();
			Loop;

        IdleLeft_Overlay:
			MP21 A 1 {
				PB_CoolDownBarrel(12.5,-3,-1.5);
                return A_DoPBLeftAction();
            }
			Loop;

		IdleRight_Overlay:
			MP22 A 1 {
				PB_CoolDownBarrel(-19,-3,1);
				return A_DoPBRightAction();
			}
			Loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        FireLeft_Overlay:
            MP21 B 1 BRIGHT MP40_FireOverlay(1, isLeft:true);
            MP21 C 1        MP40_FireOverlay(2, isLeft:true);
            MP21 D 1        MP40_FireOverlay(3, isLeft:true);
            MP21 E 1;
            TNT1 A 0        MP40_FireOverlay(4, isLeft:true);
            Goto IdleLeft_Overlay;

        FireRight_Overlay:
            MP22 B 1 BRIGHT MP40_FireOverlay(1, isLeft:false);
            MP22 C 1        MP40_FireOverlay(2, isLeft:false);
            MP22 D 1        MP40_FireOverlay(3, isLeft:false);
            MP22 E 1;
            TNT1 A 0        MP40_FireOverlay(4, isLeft:false);
            Goto IdleRight_Overlay;

        Fire:
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1,false);
			TNT1 A 0 MP40_Fire(0);
            TNT1 A 0 A_JumpIf(PB_GetZoom(), "Fire2");
		ActualFire:
			MPFI A 1 BRIGHT MP40_Fire(1);
			MPFI B 1        MP40_Fire(2);
			MPFI C 1        MP40_Fire(3);
			MPFI D 1;
			TNT1 A 0 PB_ReFire("Fire");
			Goto Ready3;
			
		Fire2:
			TNT1 A 0 MP40_Fire(0);
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1,false);
		ActualFire2:
			MPZO F 1 BRIGHT MP40_Fire(1);
			MPZO G 1 MP40_Fire(2);
			MPZO H 1 A_ZoomFactor(1.25);
			MPZO G 1 Offset(0,31);
			TNT1 A 0 Offset(0,32) PB_ReadyFire(ads:true);
			Goto Ready2;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(44);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "UnloadedReady");
			TNT1 A 0 A_PlaySound("IronSights", 0);
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "Zoomout");
        ZoomIn:
			TNT1 A 0 {
				A_SetCrosshair(-1);
				PB_SetZoom(true);
				A_ZoomFactor(1.25);
			}
			MPZO ABCD 1;
			Goto Ready2;
		
		Zoomout:
			TNT1 A 0{
				PB_SetZoom(false);
				A_ZoomFactor(1.0);
			}
			MPZO DCBA 1;
			TNT1 A 0 PB_HandleCrosshair(44);
			Goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
			TNT1 A 0 MP40_CheckSpecial();
			Goto Ready3;

		SwitchToDualWield:
			TNT1 A 0 {
				A_SetAkimbo(True);
				A_PlaySoundEx("weapons/MP40_up", "Auto");
			}
			MP25 BCDEFG 1 PB_SetRoll(roll-0.5);
			MP25 HIJKL 1 PB_SetRoll(roll+1.0);
			Goto ReadyDualWield;

		StopDualWield:
			TNT1 A 0 {
				A_SetAkimbo(False);
				A_PlaySoundEx("weapons/MP40_up", "Auto");
			}
			MP25 LKJIH 1 PB_SetRoll(roll+0.5);
			MP25 GFEDCB 1 PB_SetRoll(roll-1.0);
			Goto Ready3;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
            Reload:
                TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
                TNT1 A 0 PB_CheckReload("ReloadUnloaded","ReloadEmpty","Rechamber","Ready3","Ready3",MAGAZINE_SIZE);
                MPR1 ABC 1;
                TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
                MPR1 DEFG 1;
                MPR1 HIJKLMN 1 PB_SetRoll(roll+1.3);
                MPR1 OPQRS 1;
                TNT1 A 0 {
                    A_PlaySoundEx("MP40CLR", "Auto");
                    PB_SetMagUnloaded(true);
                }
                MPR1 TUVWXYZ 1 PB_SetRoll(roll-1.3);
            ReloadInsert:
                MPR2 ABCDE 1 PB_SetRoll(roll-1.3);
                TNT1 A 0 A_PlaySoundEx("MP40CLI", "Auto");
                MPR2 FGHIJ 1 PB_SetRoll(roll+1.4);
                MPR2 KLMNOPQ 1;
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/riflemagslap", "Auto");
                    PB_AmmoIntoMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                }
                MPR2 R 1 PB_SetRoll(roll-2);
                MPR2 S 1 PB_SetRoll(roll+3);
                MPR2 TU 1 PB_SetRoll(roll-1.5);
                MPR2 VWXYZ 1;
                MPR3 ABCD 1;
            FinishReload:
                MPR3 EFG 1;
                TNT1 A 0 PB_SetReloading(false);
                goto Ready3;
                
            ReloadEmpty:
                MR21 ABC 1;
                TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
                MR21 DEFG 1;
                MR21 HIJKLMN 1 PB_SetRoll(roll+1.3);
                MR21 OP 1;
                TNT1 A 0 {
                    A_PlaySoundEx("MP40CLR", "Auto");
                    PB_SetMagUnloaded(true);
                    A_FireCustomMissile("EmptyMagMP40",5,0,6,-4);
                }
                MR21 QRSTUVWXYZ 1 PB_SetRoll(roll-1.3);
            ReloadEmptyInsert:
                MR22 ABCDEFG 1 PB_SetRoll(roll-1);
                TNT1 A 0 A_PlaySoundEx("MP40CLI", "Auto");
                MR22 HIJKLMN 1 PB_SetRoll(roll-1.3);
                MR22 OPQRS 1 PB_SetRoll(roll+1.4);
                TNT1 A 0
                {
                    A_PlaySoundEx("weapons/riflemagslap", "Auto");
                    PB_AmmoIntoMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                }
                MR22 T 1;
                MR22 UV 1 PB_SetRoll(roll-2);
                MR22 WX 1 PB_SetRoll(roll+3);
                MR22 YZ 1 PB_SetRoll(roll-1.5);
                MR23 ABCDEFGH 1;
                TNT1 A 0 A_JumpIf(!PB_GetChamberEmpty(),"FinishReload");
                MR23 IJK 1;
                goto Rechamber;

            ReloadUnloaded:
                MR21 ABC 1;
                TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
                MR21 DEFG 1;
                MPR1 HIJ 1 PB_SetRoll(roll+1.3);
                TNT1 A 0 A_JumpIf(PB_GetMagEmpty(),"ReloadUnloadedEmpty");
                MP4U IJKLMN 1 PB_SetRoll(roll+1.3);
                Goto ReloadInsert;

            ReloadUnloadedEmpty:
                MP4U OPQRST 1 PB_SetRoll(roll+1.3);
                Goto ReloadEmptyInsert;

            Rechamber:
                TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
                MR24 BCDEFGH 1 PB_SetRoll(roll+0.35);
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/MP40_chamber", "Auto");
                    PB_SetChamberEmpty(false);
                }
                MR24 IJKLMN 1 PB_SetRoll(roll-0.35);
                MR24 NOPQRST 1;
                TNT1 A 0 PB_SetReloading(false);
                goto Ready3;
            
            ReloadLeftGunOnly:
                TNT1 A 0 PB_CheckReload("ReloadLeftUnloadedAlone",null,"StartRechamberLeft","Ready3","Ready3",MAGAZINE_SIZE,invoker.ReserveToMagAmmoFactor,true);
                M2R1 A 1 A_PlaySoundEx("IronSights", "Auto");
                M2R4 A 0 A_JumpIf(PB_GetMagEmpty(true), 2);
                M2R2 A 0;
                "####" A 0;
                "####" BCDE 1;
                Goto ReloadLeftGunSequence;

            ReloadLeftUnloadedAlone:
                TNT1 A 0 A_JumpIf(PB_GetMagEmpty(true),"LeftUnloadedEmptyAlone");
                M2U2 ABCDEF 1;
                Goto ReloadLeftGunInsert;

            LeftUnloadedEmptyAlone:
                M2U2 MNOPQR 1;
                Goto ReloadLeftGunInsert;

            ReloadDualWield:
                TNT1 A 0 PB_CheckReload("ReloadRightUnloaded","ReloadRightEmpty","StartRechamberRight","ReloadLeftGunOnly","Ready3",MAGAZINE_SIZE);
                M2R1 A 1 A_PlaySoundEx("IronSights", "Auto");
                M2R1 BCDE 1;
                Goto ReloadRight;

            ReloadRightUnloaded:
                M2R1 A 1 A_PlaySoundEx("IronSights", "Auto");
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty,"RightUnloadedEmpty");
                M2U1 EFGH 1;
                goto ReloadRightInsert;

            RightUnloadedEmpty:
                M2U1 RSTUVW 1;
                goto ReloadRightEmptyInsert;

            ReloadRightEmpty:
                M2E1 ABCD 1;
                MR21 MN 1 PB_SetRoll(roll+1.3);
                MR21 OP 1;
                TNT1 A 0 {
                    A_PlaySoundEx("MP40CLR", "Auto");
                    PB_SetMagUnloaded(true);
                    A_FireCustomMissile("EmptyMagMP40",-5,0,6,-4);
                }
                MR21 QRSTUVWXYZ 1 PB_SetRoll(roll-1.3);
            ReloadRightEmptyInsert:
                MR22 ABCDEFG 1 PB_SetRoll(roll-1);
                TNT1 A 0 A_PlaySoundEx("MP40CLI", "Auto");
                MR22 HIJKLMN 1 PB_SetRoll(roll-1.3);
                MR22 OPQRS 1 PB_SetRoll(roll+1.4);
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/riflemagslap", "Auto");
                    PB_AmmoIntoMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                }
                MR22 T 1;
                MR22 UV 1 PB_SetRoll(roll-2);
                MR22 WX 1 PB_SetRoll(roll+3);
                MR22 YZ 1 PB_SetRoll(roll-1.5);
                MR23 ABCDEFGHIJK 1;
                TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
                Goto RechamberRight;

            StartRechamberRight:
                MP25 LKJIHGE 1;
            RechamberRight:
                MR24 BCDEFGH 1 PB_SetRoll(roll+0.35);
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/MP40_chamber", "Auto");
                    PB_SetChamberEmpty(false);
                }
                MR24 IJKLMN 1 PB_SetRoll(roll-0.35);
                MR24 NOO 1;
                MRCO ABCDE 1;
                TNT1 A 0 A_JumpIf((PB_GetMagUnloaded(true) || PB_GetChamberEmpty(true) || invoker.AmmoLeft.amount < MAGAZINE_SIZE) && invoker.ammo1.amount > 0, "ReloadLeftGunAfterEmpty");
                TNT1 AAAA 1;
                M2R1 A 0 A_PlaySoundEx("IronSights", "Auto");
                MP25 MNOPQ 1;
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

            ReloadRight:
                MPR1 MN 1 PB_SetRoll(roll+1.3);
                MPR1 OPQRS 1;
                TNT1 A 0 {
                    A_PlaySoundEx("MP40CLR", "Auto");
                    PB_SetMagUnloaded(true);
                }
                MPR1 TUVWX 1 PB_SetRoll(roll-1.3);
                MPR1 YZ 1 PB_SetRoll(roll-1.3);
            ReloadRightInsert:
                MPR2 ABCDE 1 PB_SetRoll(roll-1.3);
                TNT1 A 0 A_PlaySoundEx("MP40CLI", "Auto");
                MPR2 FGHIJ 1 PB_SetRoll(roll+1.4);
                MPR2 KLMNOPQ 1;
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/riflemagslap", "Auto");
                    PB_AmmoIntoMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                }
                MPR2 R 1 PB_SetRoll(roll-2);
                MPR2 S 1 PB_SetRoll(roll+3);
                MPR2 TU 1 PB_SetRoll(roll-1.5);
                MPR2 VWXYZ 1;
                MPR3 A 1;
                TNT1 A 0 A_JumpIf((PB_GetMagUnloaded(true) || PB_GetChamberEmpty(true) || invoker.AmmoLeft.amount < MAGAZINE_SIZE) && invoker.ammo1.amount > 0, "ReloadLeftGun");
                M2R1 A 0;
                "####" A 0;
                M2R1 DCBA 1;
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

            ReloadLeftUnloaded:
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(true),"ReloadLeftUnloadedEmpty");
                M2U2 LKJIHGF 1;
                Goto ReloadLeftGunInsert;

            ReloadLeftUnloadedEmpty:
                M2U2 XWVUTSR 1;
                Goto ReloadLeftGunInsert;

            ReloadLeftGun:
                M2R1 IJ 1;
            ReloadLeftGunAfterEmpty:
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(true) && !PB_GetMagEmpty(true),"RechamberLeftFromNothing");
                TNT1 A 6;
                TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
                TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true), "ReloadLeftUnloaded");
                M2R7 A 0 A_JumpIf(PB_GetChamberEmpty(true), 2);
                M2R8 A 0;
                "####" A 0;
                "####" EDCBA 1;
            ReloadLeftGunSequence:
                M2R4 A 0 A_JumpIf(PB_GetChamberEmpty(true), 2);
                M2R2 A 0;
                "####" A 0;
                "####" FG 1 PB_SetRoll(roll-1.3);
                "####" HIJKLM 1;
                "####" A 0 {
                    A_PlaySoundEx("MP40CLR", "Auto");
                    PB_SetMagUnloaded(true,true);
                    if (PB_GetMagEmpty(true))
                        A_FireCustomMissile("EmptyMagMP40",5,0,-6,-4);
                }
                "####" NOPQ 1 PB_SetRoll(roll-1.3);
                "####" RS 1 PB_SetRoll(roll+1.3);
                "####" TU 1 PB_SetRoll(roll+1.3);
            ReloadLeftGunInsert:
                M2R4 A 0 A_JumpIf(PB_GetChamberEmpty(true), 2);
                M2R2 A 0;
                "####" VW 1;
                "####" A 0 A_PlaySoundEx("MP40CLI", "Auto");
                "####" XYZ 1 PB_SetRoll(roll+1.4);
                M2R5 A 0 A_JumpIf(PB_GetChamberEmpty(true), 2);
                M2R3 A 0;
                "####" A 0;
                "####" ABCDEFGHI 1;
                "####" A 0 {
                    A_PlaySoundEx("weapons/riflemagslap", "Auto");
                    PB_AmmoIntoMag(invoker.AmmoLeft.getClassName(),invoker.ammo1.getClassName(),MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false,true);
                    PB_SetMagEmpty(false,true);
                }
                "####" JKLMNO 1 PB_SetRoll(roll+2);
                "####" PQRSTUV 1 PB_SetRoll(roll-0.75);
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(true), "RechamberLeft");
                M2R3 WXY 1;
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

            RechamberLeftFromNothing:
                TNT1 A 6;
                MRCO EDCBA 1;
                Goto RechamberLeft;

            StartRechamberLeft:
                M2R6 VUT 1;
            RechamberLeft:
                MR24 BCDEFGH 1 PB_SetRoll(roll+0.35);
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/MP40_chamber", "Auto");
                    PB_SetChamberEmpty(false,true);
                }
                MR24 IJKLMN 1 PB_SetRoll(roll-0.35);
                MR24 NO 1;
                M2R6 RSTUV 1;
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
            Unload:
			TNT1 A 0 PB_SetReloading(true);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"UnloadDual");
			TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_SetCrosshair(-1);
                PB_SetZoom(0);
				A_PlaySoundEx("IronSights", "Auto");
			}
			MPR1 ABC 1;
			MPR1 DEFG 1;
			MPR1 HIJKLMN 1 PB_SetRoll(roll+1.3);
			MPR1 OPQRS 1;
			TNT1 A 0 {
				A_PlaySoundEx("MP40CLR", "Auto");
				PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),invoker.ReserveToMagAmmoFactor);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			MPR1 TUVWX 1 PB_SetRoll(roll-1.3);
			MPR1 YZZZZ 1;
			MP4U ABCDEFGH 1;
			Goto Ready3;

		UnloadDual:
			TNT1 A 0 A_StopSound(CHAN_AUTO);
			TNT1 A 0 {
				A_SetCrosshair(-1);
                PB_ClearDualWield();
			}
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty() || PB_GetMagUnloaded(), "UnloadLeftOnly");
		UnloadRight:
			TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
			M2R1 ABCDE 1;
			MPR1 MN 1 PB_SetRoll(roll+1.3);
			MPR1 OPQRS 1;
			TNT1 A 0 {
				A_PlaySoundEx("MP40CLR", "Auto");
				PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),invoker.ReserveToMagAmmoFactor);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			MPR1 TUVWXYZ 1 PB_SetRoll(roll-1.3);
            TNT1 A 0 A_JumpIf(invoker.AmmoLeft.amount >= 1, "UnloadLeft");
			M2U1 HGFEDCBA 1;
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;

		UnloadLeftOnly:
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(true) || PB_GetMagUnloaded(true),"Ready3");
			M2R1 A 1 A_PlaySoundEx("IronSights", "Auto");
			M2R2 A 0	;
			"####" A 0;
			"####" BCDE 1;
			Goto UnloadLeftSequence;

		UnloadLeft:
			M2U1 HIJKLMN 1;
			TNT1 A 6;
			M2R1 A 0 A_PlaySoundEx("IronSights", "Auto");
			M2R8 EDCBA 1;
		UnloadLeftSequence:
			M2R2 FG 1 PB_SetRoll(roll-1.3);
			M2R2 HIJKLM 1;
			TNT1 A 0 {
				A_PlaySoundEx("MP40CLR", "Auto");
				PB_UnloadMag(invoker.AmmoLeft.getClassName(),invoker.ammo1.getClassName(),invoker.ReserveToMagAmmoFactor);
				PB_SetMagUnloaded(true,true);
				PB_SetMagEmpty(true,true);
			}
			M2R2 NOPQ 1 PB_SetRoll(roll-1.3);
			M2R2 RS 1 PB_SetRoll(roll+1.3);
			M2R2 TU 1 PB_SetRoll(roll+1.3);
			M2U2 FEDCBA 1;
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        FlashVariation:
			TNT1 A 1 A_Jump(256, "Flash_Variant1", "Flash_Variant2", "Flash_Variant3", "Flash_Variant4", "Flash_Variant5", "Flash_Variant6");
		Flash_Variant1:
			MPFI E 1 BRIGHT;
			stop;
		Flash_Variant2:
			MPFI F 1 BRIGHT;
			stop;
		Flash_Variant3:
			MPFI G 1 BRIGHT;
			stop;
		Flash_Variant4:
			MPFI H 1 BRIGHT;
			stop;
		Flash_Variant5:
			MPFI I 1 BRIGHT;
			stop;
		Flash_Variant6:
			MPFI J 1 BRIGHT;
			stop;
		
		Flash2Variation:
			TNT1 A 1 A_Jump(256, "Flash2_Variant1", "Flash2_Variant2", "Flash2_Variant3", "Flash2_Variant4", "Flash2_Variant5", "Flash2_Variant6");
		Flash2_Variant1: 
			MPZO I 1 BRIGHT;
			stop;
		Flash2_Variant2: 
			MPZO J 1 BRIGHT;
			stop;
		Flash2_Variant3:
			MPZO K 1 BRIGHT;
			stop;
		Flash2_Variant4:
			MPZO L 1 BRIGHT;
			stop;
		Flash2_Variant5:
			MPZO M 1 BRIGHT;
			stop;
		Flash2_Variant6:
			MPZO N 1 BRIGHT;
			stop;
		
		LeftFlashVariation:
			TNT1 A 0 A_Jump(256, "LeftFlash_Variant1", "LeftFlash_Variant2", "LeftFlash_Variant3", "LeftFlash_Variant4");
		LeftFlash_Variant1:
			MP21 F 1 BRIGHT;
			stop ;
		LeftFlash_Variant2:
			MP21 G 1 BRIGHT;
			stop;
		LeftFlash_Variant3:
			MP21 H 1 BRIGHT;
			stop;
		LeftFlash_Variant4:
			MP21 I 1 BRIGHT;
			stop;

		RightFlashVariation:
			TNT1 A 0 A_Jump(256, "RightFlash_Variant1", "RightFlash_Variant2", "RightFlash_Variant3", "RightFlash_Variant4");
		RightFlash_Variant1: 
			MP22 F 1 BRIGHT;
			stop;
		RightFlash_Variant2:
			MP22 G 1 BRIGHT;
			stop;
		RightFlash_Variant3:
			MP22 H 1 BRIGHT;
			stop;
		RightFlash_Variant4:
			MP22 I 1 BRIGHT;
			stop;
		
		
		FlashPunching:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashPunchingDW");
			MP4Q ABCDEF 1;
			MP4Q G 1 A_WeaponOffset(-1,33);
			MP4Q GFEDCBA 1 A_WeaponOffset(0,32);
			Goto Ready3;
			
		FlashKicking:
			TNT1 A 0 PB_ClearDualWield();
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashKickingDW");
			MPKI ACDEFHIHFEDCBA 1 A_DoPBWeaponAction();
			Goto Ready3;
		
		FlashAirKicking:
			TNT1 A 0 PB_ClearDualWield();
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashAirKickingDW");
			MPKI ABCDEFHIIHFEDCBA 1 A_DoPBWeaponAction();
			Goto Ready3;
		
		FlashKickingDW:
			MPKI JKLMNOOOONMLKJ 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			Goto Ready3;
		
		FlashAirKickingDW:
			MPKI JJKLMNNNNNNMLKJJ 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			Goto Ready3;
			
		FlashPunchingDW:
			TNT1 A 0 PB_ClearDualWield();
			TNT1 A 15;
			Goto Ready3;
		
		FlashSlideKicking:
			TNT1 A 0 PB_ClearDualWield();
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingDW");
			MPKI ABCDEGHHHGFGHHHGHHHGFEDCBA 1 A_DoPBWeaponAction();
			Goto Ready3;

		FlashSlideKickingDW:
			MPKI JKLMNNNNNNNNNNNNNNNNMLKJ 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			Goto Ready3;
		
		FlashSlideKickingStop:
			TNT1 A 0 PB_ClearDualWield();
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingStopDW");
			MPKI HGFEDCB 1 A_DoPBWeaponAction();
			Goto Ready3;
		
		FlashSlideKickingStopDW:
			MPKI OONMLKJ 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			Goto Ready3;

    }
}