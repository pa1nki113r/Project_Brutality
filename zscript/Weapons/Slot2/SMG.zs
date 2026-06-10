// Gearbox Tokens
class SelectSilencedSMG : Inventory {Default{Inventory.MaxAmount 1;}}
class SelectDualWieldSMG : Inventory {Default{Inventory.MaxAmount 1;}}
class SelectBurstFireSMG : Inventory {Default{Inventory.MaxAmount 1;}}

// Why is this even needed?
class KeepLaserDeactivated : Inventory {Default{Inventory.MaxAmount 1;}}

// Ammo Class
Class PB_SMGMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_SMG.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_SMG.MAGAZINE_SIZE;
		Inventory.Icon "ATFLA0";
	}
}

Class PB_SMGLeftMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_SMG.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_SMG.MAGAZINE_SIZE;
		Inventory.Icon "ATFLA0";
	}
}

// The Actual Weapon
class PB_SMG : PB_WeaponBase
{
    Default
    {
        //$Category Project Brutality - Weapons
	    //$Sprite ATFLA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        // SpawnID 9200
        Inventory.MaxAmount 2;
        Weapon.AmmoGive1 20;
        Weapon.AmmoType1 "PB_LowCalMag";
        Weapon.AmmoType2 "PB_SMGMag";
        PB_WeaponBase.AmmoTypeLeft "PB_SMGLeftMag";
        weapon.slotpriority 0.75;
        Inventory.Amount 1;
        Inventory.AltHUDIcon "ATFLA0";
        PB_WeaponBase.OffsetRecoilX 5.0;
        PB_WeaponBase.OffsetRecoilY 2.5;
        PB_WeaponBase.UsesWheel 1;
        PB_WeaponBase.WheelInfo "PB_SMGWheel";
        PB_WeaponBase.TailPitch 1.2;
        FloatBobStrength 0.5;
        Scale 0.4;
        // PB_WeaponBase.BarrelAttachmentPoint (6, 0, 0), (6, 0, 0)
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.Pickupmessage "$PB_SMG_PICKUP";
        Inventory.PickupSound "CLIPIN";
        Obituary "%o was shot down by %k's UAC-17 Compact Submachine Gun.";
        Tag "$PB_SMG_TAG";
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.WIMPY_WEAPON;
        +WEAPON.CHEATNOTWEAPON
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    // bool pistolLastShotLeft;
    bool hasSilencer;
    bool burstFire;
    bool smgWasEmpty;
    int smgADSFireAnimation;
    int smgBurstCount;
    int smgBurstCountLeft;
    // Overlays
    const SILENCER_OVERLAY       = -2;
    const SILENCERRIGHT_OVERLAY  = -3;
    const FLASHDW_LEFT_SUPP      = 8;
    const FLASHDW_RIGHT_SUPP     = 9;
    const EMPTYBOLT_OVERLAY      = 2;
    const LEFTMUZZLEFLASH        = -5;
    const RIGHTMUZZLEFLASH       = -6;
	const MAGAZINE_SIZE = 36;
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

    action void SMG_Fire(int tic)
    {
        bool ads        = PB_GetZoom();
        bool sil        = getSilencer();
        double recoilX  = ads ? -0.2   : -0.24;
        double recoilY  = ads ? +0.18  : +0.22;
        double zoomA    = ads ?  1.24  :  0.985;
        double zoomB    = ads ?  1.245 :  0.99;
        double zoomC    = ads ?  1.25  :  1.0;
        double d3       = ads ?  4.3   :  0.0;
        double d2       = ads ?  6.0   :  0.0;
        int xOfs        = ads ?  19    :  21;
        int vertOfs     = ads ?  35    :  30;
        string tail     = sil ? "pistol_sup" : "smg";

        switch(tic)
        {
            case 1:
                if(sil)
                {
                    A_StartSound("weapons/silencedsmg", CHAN_7, CHANF_DEFAULT, 1.0);
                    PB_GunSmoke_FlashHider(0, 0, d3);
                    PB_MuzzleFlashEffects(0, d2, d3, "FF9D2E", true, false);
                    if(!ads) SMG_SetSprite("A1S1",unloaded:"A1S2");
                }
                else
                {
                    PB_IncrementHeat();
                    PB_GunSmoke_Compensator(0, 0, d3);
                    PB_MuzzleFlashEffects(0, 0, d3);
                    A_AlertMonsters();
                    A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
                    if(!ads) SMG_SetSprite("A1F1",unloaded:"A1F2");
                }
                PB_DynamicTail(tail,tail);
                if(ads) SMG_SetSprite("A1F3",silenced:"A1S3");
				A_StartSound("ZSpecOps/MGun", CHAN_Weapon, CHANF_DEFAULT, sil ? 0.15 : 1.0, ATTN_NORM, frandom(0.93, 1.07));
                PB_FireOffset();
                PB_FireBullets("PB_9x19mmSubsonic", 1, 2, 0, 0, 2);
                PB_SpawnCasing("EmptyBrassPistol", xOfs, 3, vertOfs, frandom(-3,3), frandom(2,7), frandom(1,2), true, true);
                PB_LowAmmoSoundWarning("smg");
                PB_TakeAmmo(invoker.ammo2.getClassName(), 1);
                A_ZoomFactor(zoomA);
                PB_WeaponRecoil(recoilX, recoilY);
                invoker.smgBurstCount++;
                if(ads) {
                    setADSAnimation(random(0, 1));
                    A_GunFlash();
                }
                break;

            case 2:
                A_ZoomFactor(zoomB);
                PB_WeaponRecoil(recoilX, recoilY);
                if(ads && getADSAnimation()) A_SetWeaponSprite("A1F6");
                PB_SetRoll(roll - 0.5);
                if(!ads) SMG_SetSprite("A1F1",silenced:"A1S1",unloaded:"A1F2",silUnloaded:"A1S2");
                break;

            case 3:
                A_ZoomFactor(zoomC);
                if(ads && getADSAnimation()) {
                    A_SetWeaponSprite("A1F6");
                    PB_SetRoll(roll + 0.5);
                }
                else PB_SetRoll(roll - 0.5);
                if(!ads) SMG_SetSprite("A1F1",silenced:"A1S1",unloaded:"A1F2",silUnloaded:"A1S2");
                break;

            case 4: // cooldown frames
                setBurstCount(0);
                PB_CoolDownBarrel();
                if(ads) setADSAnimation(0);
                if(!ads) SMG_SetSprite("A1F1",silenced:"A1S1",unloaded:"A1U1",silUnloaded:"A1SU");
                break;
        }
    }

    action void SMG_FireOverlay(int tic, bool isLeft)
    {
        bool sil        = getSilencer();
        double recoilX  = -1.1;
        double recoilY  = isLeft ? +0.76 : -0.76;
        double smokeOfs = isLeft ?  6.0  : -6.0;
        double flareOfs = isLeft ? -6.0  :  6.0;
        int horOfs     = isLeft ? -10   :  16;
        int vertOfs     = isLeft ?  33   :  28;
        int flashLayer  = isLeft ? LEFTMUZZLEFLASH : RIGHTMUZZLEFLASH;

        switch(tic)
        {
            case 1:
                if(sil)
                {
                    PB_DynamicTail("pistol_sup", "pistol_sup");
                    A_StartSound("weapons/silencedsmg", CHAN_7, CHANF_DEFAULT, 1.0);
                    PB_GunSmoke_FlashHider(-6, 0, 0);
                    PB_MuzzleFlashEffects(-6, 0, 0, "FF9D2E", true, false);
                    SMG_SetSprite("A2F1", silenced: "A2S1", silUnloaded: "A2SU", leftMag: isLeft);
                }
                else
                {
                    PB_IncrementHeat(1, isLeft);
                    PB_DynamicTail("smg", "smg");
                    PB_GunSmoke_Compensator(smokeOfs, 0, 0);
                    PB_MuzzleFlashEffects(smokeOfs, 0, 0);
                    A_AlertMonsters();
                    A_FireCustomMissile("YellowFlareSpawn", 0, 0, flareOfs, 0);
                    SMG_SetSprite("A2F1", unloaded: "A2FU", leftMag: isLeft);
                }
                A_StartSound("ZSpecOps/MGun", CHAN_Weapon, CHANF_DEFAULT, sil ? 0.15 : 1, ATTN_NORM, frandom(0.93, 1.07));
                PB_FireBullets("PB_9x19mmSubsonic", 1, 2, 0, 0, 2);
                PB_SpawnCasing("EmptyBrassPistol", 20, horOfs, vertOfs, frandom(-3,3), frandom(2,7), frandom(1,2), true, true);
                if(isLeft)
                {
                    PB_LowAmmoSoundWarning("smg", invoker.ammoleft.getClassName());
                    PB_TakeAmmo(invoker.ammoleft.getClassName(), 1, 1, 0, true);
                    invoker.smgBurstCountLeft++;
                }
                else
                {
                    PB_LowAmmoSoundWarning("smg");
                    PB_TakeAmmo(invoker.ammo2.getClassName());
                    invoker.smgBurstCount++;
                }
                A_ZoomFactor(0.985);
                if(isLeft) A_Overlay(flashLayer, "LeftFlash", true);
                else       A_Overlay(flashLayer, "RightFlash", true);
                A_OverlayFlags(flashLayer, PSPF_RENDERSTYLE, true);
                A_OverlayRenderStyle(flashLayer, STYLE_Add);
                PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 2:
                A_ZoomFactor(0.99);
                if(isLeft) {
                    if(invoker.ammoleft.amount <= 0 || invoker.ammo2.amount > 0)
                        A_GiveInventory("DualFiring", 1);
                }
                else {
                    if(invoker.ammoleft.amount > 0 || invoker.ammo2.amount <= 0)
                        A_TakeInventory("DualFiring", 1);
                }
                PB_WeaponRecoil(recoilX, recoilY);
                SMG_SetSprite("A2F1", silenced: "A2S1", unloaded: "A2FU", silUnloaded: "A2SU", leftMag: isLeft);
                break;

            case 3:
                A_ZoomFactor(1.0);
                SMG_SetSprite("A2F1", silenced: "A2S1", unloaded: "A2FU", silUnloaded: "A2SU", leftMag: isLeft);
                break;

            case 4: // DualFireReload + burst reset
                if(isLeft)
                {
                    if(invoker.ammoleft.amount <= 0) A_GiveInventory("DualFireReload", 1);
                    setBurstCount(0, true);
                }
                else
                {
                    if(invoker.ammo2.amount <= 0) A_GiveInventory("DualFireReload", 1);
                    setBurstCount(0, false);
                }
                break;
        }
    }

    action state SMG_WeaponSpecial()
    {
        A_SetInventory("GoWeaponSpecialAbility", 0);
        PB_SetZoom(false);
        A_ZoomFactor(1.0);
        PB_ClearDualWield();

        bool selectBurst    = CountInv("SelectBurstFireSMG")  > 0;
        bool selectDual     = CountInv("SelectDualWieldSMG")  > 0;
        bool selectSilencer = CountInv("SelectSilencedSMG")   > 0;

        // Clear all tokens
        clearTokens();

        // Check Burst
        if(selectBurst)
        {
            invoker.burstFire = !invoker.burstFire;
            A_Print(getBurstFire() ? "$PB_FIREMODE_BURST" : "$PB_FIREMODE_FULL");
            if(A_CheckAkimbo()) return ResolveState("ToggleBurst_Dual");
            return ResolveState("ToggleBurst");
        }
        // Check Suppressor
        if(selectSilencer)
        {
            if(invoker.hasSilencer)
            {
                A_Print("$PB_PISTOL_SUPPRESSOFF");
                // setSilencer(false);
                return ResolveState("ScrewOffSilencer");
            }
            A_Print("$PB_PISTOL_SUPPRESSON");
            // setSilencer(true);
            return ResolveState("ScrewOnSilencer");
        }
        // Check Dual Wield
        if(selectDual)
        {
            if(A_CheckAkimbo())     return ResolveState("StopDualWield");
            if(invoker.amount >= 2) return ResolveState("SwitchToDualWield");
            A_Print("$PB_SMG_NOAKIMBO");
            return ResolveState(null);
        }
        return ResolveState(null);
    }

    action void clearTokens()
    {
        A_SetInventory("SelectBurstFireSMG",0);
        A_SetInventory("SelectDualWieldSMG",0);
        A_SetInventory("SelectSilencedSMG",0);
    }

    action void SMG_SetSprite(
        name normal, 
        name silenced    = '', 
        name unloaded    = '', 
        name silUnloaded = '',
        bool leftMag     = false)
    {
        bool sil      = getSilencer();
        bool unload   = PB_GetMagUnloaded(leftMag);

        // Suppressor + Unloaded
        if(sil && unload && silUnloaded != '')
            A_SetWeaponSpriteEx(silUnloaded);
        // Suppressor
        else if(sil && silenced != '')
            A_SetWeaponSpriteEx(silenced);
        // Unloaded
        else if(unload && unloaded != '')
            A_SetWeaponSpriteEx(unloaded);
        // Normal
        else if(normal != '')
            A_SetWeaponSpriteEx(normal);
    }

    // Auxilliary Functions
    action bool getADSAnimation()
    {
        return invoker.smgADSFireAnimation;
    }

    action void setADSAnimation(bool set)
    {
        invoker.smgADSFireAnimation = set;
    }

    action bool getSilencer()
    {
        return invoker.hasSilencer;
    }

    action void setSilencer(bool set)
    {
        invoker.hasSilencer = set;
    }

    action void setBurstFire(bool set)
    {
        invoker.burstFire = set;
    }

    action bool getBurstFire()
    {
        return invoker.burstFire;
    }

    action void setBurstCount(int set, bool isLeft = false)
    {
        if(!isLeft) invoker.smgBurstCount  = set;
        else        invoker.smgBurstCountLeft = set;
    }

    action int getBurstCount(bool isLeft = false)
    {
        if(!isLeft) return invoker.smgBurstCount;
        else        return invoker.smgBurstCountLeft;
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            VTFL A 0 NoDelay;
            ATFL A 10 A_PbvpFramework("VTFL");
            "####" A 0 A_PbvpInterpolate();
            Loop;

        CacheFire:
            A1S1 A 0;
            A1S2 A 0;
            A1F6 A 0;
            A1S3 A 0;
            A1F2 A 0;
            A3U1 A 0;
            Stop;

        WeaponRespect:
            TNT1 A 0 {
                A_SetInventory("PB_LockScreenTilt",1);
                A_PlaySoundEx("weapons/smg_raise", "Auto");
                A_SetCrosshair(-1);
            }
            A5F5 ABCDEFGHI 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg/screw/on", CHAN_AUTO, CHANF_DEFAULT, 0.2);
            A5F5 JJ 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg/screw_3", CHAN_AUTO);
            A5F5 LMNOJJ 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg/screw_2", CHAN_AUTO);
            A5F5 LMNOJJ 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg/screw_1", CHAN_AUTO);
            A5F5 JLMNOOOOO 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg/screw/off", CHAN_AUTO);
            A5F6 GHIJJJKLMNOPQRSTUVW 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg/respectmagup", CHAN_AUTO);
            A5F6 XYZ 1 A_DoPBWeaponAction();
            A5F7 ABCDEFG 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg_out", CHAN_AUTO);
            A5F7 HIJJJJJO 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg/armup", CHAN_AUTO);
            A5F7 PQRSTU 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg_in", CHAN_AUTO);
            A5F7 VWXXX 1 A_DoPBWeaponAction();
            A5F8 ABC 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/smg_lower", CHAN_AUTO);
            A5F8 DEFG 1 A_DoPBWeaponAction();
            Goto Ready3;

        Deselect:
            TNT1 A 0 {
                A_DestroyLaserPuff();
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
                PB_ClearDualWield();
                PB_SetZoom(false);
                A_ClearOverlays(EMPTYBOLT_OVERLAY,EMPTYBOLT_OVERLAY);
                A_ClearOverlays(SILENCER_OVERLAY,SILENCER_OVERLAY);
            }
            TNT1 A 0 A_Overlay(-9, "Null");
            TNT1 A 0 A_ZoomFactor(1.0);
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DeselectDualWield");
            TNT1 A 0 {
                if(getSilencer()) A_overlay(SILENCER_OVERLAY,"DeselectSilencerOverlay");
            }
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"DeselectUnloaded");
            A1F1 DCBA 1;
            TNT1 A 0 A_DestroyLaserPuff();
            TNT1 A 0 A_Lower(120);	//its 2077, we have parameters now! 
            Wait;

        DeselectDWUnloaded:
            A0F2 IHGF 1 A_Lower();
            A0F2 EDC 1;
            TNT1 A 0 A_Lower(120);
            Wait;

        DeselectUnloaded:
            A0F1 DCB 1;
            A1F1 A 1;
            TNT1 A 0 A_Lower(120);
            Wait;

        DeselectDualWield:
            TNT1 A 4 {
                A_Overlay(PSP_LEFTGUN, "StopDualWield_Left", false);
                A_Overlay(PSP_RIGHTGUN, "StopDualWield_Right", false);
            }
            TNT1 A 0 A_DestroyLaserPuff();
            TNT1 A 0 A_Lower(120);
            Wait;

        SwitchToDualWield:
            TNT1 A 0 {
                A_SetAkimbo(true);
                A_PlaySoundEx("weapons/smg_up", "Auto");
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "SwitchToDualWield_Silencer");
            }
            A0F2 A 0 A_JumpIf(PB_GetMagUnloaded(),2); //Load the unloaded frames into memory
            A1F2 A 0;
            "####" ABCDE 1;
            TNT1 A 0 A_Overlay(PSP_LEFTGUN, "SwitchToDualWield_Left");
            A2FR A 4 {
                if(PB_GetMagUnloaded()) {
                    if(getSilencer()) A_SetWeaponFrame(3);
                    else A_SetWeaponFrame(1);
                }
                else if(getSilencer()) A_SetWeaponFrame(2);
            }
            Goto ReadyDualWield;

        SwitchToDualWield_Left:
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "SwitchToDualWield_Left_Silencer");
            }
            A2L3 D 1;
            A2L3 C 1 {
                if(PB_GetMagUnloaded(true)) { A_SetWeaponFrame(6); }
            }
            A2L3 B 1 {
                if(PB_GetMagUnloaded(true)) { A_SetWeaponFrame(5); }
            }
            A2L3 A 1 {
                if(PB_GetMagUnloaded(true)) { A_SetWeaponFrame(4); }
            }
            Stop;

        SwitchToDualWield_Right:
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCERRIGHT_OVERLAY, "SwitchToDualWield_Right_Silencer");
            }
            A2R3 DC 1;
            A2R3 B 1 {
                if(PB_GetMagUnloaded()) { A_SetWeaponFrame(5); }
            }
            A2R3 A 1 {
                if(PB_GetMagUnloaded()) { A_SetWeaponFrame(4); }
            }
            Stop;

        SwitchToDualWield_Left_Silencer:
            A2LS DCBA 1;
            Stop;

        SwitchToDualWield_Right_Silencer:
            A2RS DCBA 1;
            Stop;

        SwitchToDualWield_Silencer:
            A2FS ABCDE 1;
            Stop;

        StopDualWield:
            TNT1 A 0 {
                A_SetAkimbo(false);
                A_PlaySoundEx("weapons/smg_up", "Auto");
                A_Overlay(PSP_LEFTGUN, "StopDualWield_Left");
            }
            A2FR A 4 {
                if(PB_GetMagUnloaded())
                {
                    if(getSilencer()) A_SetWeaponFrame(3);
                    else A_SetWeaponFrame(1);
                }
                else if(getSilencer()) A_SetWeaponFrame(2);
            }
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "StopDualWield_Silencer");
            }
            A0F2 A 0 A_JumpIf(PB_GetMagUnloaded(),2); //Load the unloaded frames into memory
            A1F2 A 0;
            "####" EDCBA 1;
            Goto Ready3;

        StopDualWield_Left:
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "StopDualWield_Left_Silencer");
            }
            A2L3 A 1 {
                if(PB_GetMagUnloaded(true)) A_SetWeaponFrame(4);
            }
            A2L3 B 1 {
                if(PB_GetMagUnloaded(true)) A_SetWeaponFrame(5);
            }
            A2L3 C 1 {
                if(PB_GetMagUnloaded(true)) A_SetWeaponFrame(6);
            }
            A2L3 D 1;
            Stop;

        StopDualWield_Right:
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCERRIGHT_OVERLAY, "StopDualWield_Right_Silencer");
            }
            A2R3 A 1 {
                if(PB_GetMagUnloaded()) A_SetWeaponFrame(5);
            }
            A2R3 B 1 {
                if(PB_GetMagUnloaded()) A_SetWeaponFrame(6);
            }
            A2R3 CD 1;
            Stop;

        StopDualWield_Left_Silencer:
            A2LS ABCD 1;
            Stop;

        StopDualWield_Right_Silencer:
            A2RS ABCD 1;
            Stop;

        StopDualWield_Silencer:
            A2FS EDCBA 1;
            Stop;

        SelectAnimationDualWield:
            TNT1 A 4 {
                A_Overlay(PSP_LEFTGUN, "SwitchToDualWield_Left", false);
                A_Overlay(PSP_RIGHTGUN, "SwitchToDualWield_Right", false);
                return A_WeaponReady(WRF_NOFIRE);
            }
            TNT1 A 0 A_PlaySoundEx("weapons/smg_up", "Auto");
            Goto ReadyDualWield;

        SelectAnimationUnloaded:
            A1F1 A 1;
            A0F1 BCD 1;
            Goto Ready3;

        SelectSilencerOverlay:
            A0S1 ABCD 1;
            Stop;

        DeselectSilencerOverlay:
            A0S1 DCBA 1;
            Stop;

        AimSilencerOverlay:
            A1S3 ABC 1;
            Stop;
            
        AimOutSilencerOverlay:
            A1S3 CBA 1;
            Stop;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
                PB_ClearDualWield();
			    PB_HandleCrosshair(67);
                PB_TakeIfUpgrade("PB_Pistol");
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeapTokenSwitch("UACSMGSelected");
                PB_WeaponRaise("weapons/smg_up");
                invoker.smgBurstCount = 0;
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            TNT1 A 0 PB_SetZoom(false);
		    TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
            TNT1 A 0 {
                if(getSilencer()) A_overlay(SILENCER_OVERLAY,"SelectSilencerOverlay");
            }
		    TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "SelectAnimationUnloaded");
		    A1F1 ABCD 1;
        // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        // Ready Normal
	    Ready3:
            // TNT1 A 0 A_SetInventory("KeepLaserDeactivated",0);
            TNT1 A 0 {
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
                PB_HandleCrosshair(67);
            }
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
        ReadyToFire:
            // Cache Sprites
            A1SU E 0;
            A1S1 E 0;
            // Code
            A1U1 E 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "SilencerOverlay");
            }
            A1F1 E 1 {
                PB_CoolDownBarrel();
                SMG_SetSprite("A1F1","A1S1","A1U1","A1SU");
                return PB_ReadyFire();
                // if(PB_GetMagUnloaded())
                // {
                //     if(getSilencer()) A_SetWeaponSprite("A1SU");
                //     else A_SetWeaponSprite("A1U1");
                // }
                // else if(getSilencer()) A_SetWeaponSprite("A1S1");
            }
            Loop;
            
        Ready2:
            TNT1 A 0 {
                PB_SetRoll(0);
                A_SetCrosshair(-1);
                A_SetInventory("PB_LockScreenTilt",0);
            }
        ReadyToFire2:
            A1F3 F 1 {
                if(getSilencer()) PB_CoolDownBarrel(0, 0, 4.3);
                return PB_ReadyFire(ads:true);
            }
            Loop;

        UnloadedReady:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "UnloadedReadyDualWield");
            A1F1 Z 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD, PBWEAP_UNLOADED);
            Loop;

        UnloadedReadyDualWield:
            A2F3 Z 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD, PBWEAP_UNLOADED);
            Loop;

        ReadyDualWield:
            TNT1 A 0 {
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
                PB_SetupDualWield(crosshair:67);
            }
        ReadyToFireDualWield:
			TNT1 A 1 A_DoPBDualAction();
            Loop;
            
        IdleLeft_Overlay:
            A2FL A 1 {
                if(PB_GetMagUnloaded(true))
                {
                    if(getSilencer()) A_SetWeaponFrame(3);
                    else {
                        A_SetWeaponFrame(1);
                        PB_CoolDownBarrel(15, 0, 0);
                    }
                }
                else if(getSilencer()) A_SetWeaponFrame(2);
                else PB_CoolDownBarrel(15, 0, 0);
                return A_DoPBLeftAction();

                // if(PB_GetChamberEmpty(true) && !PB_GetChamberEmpty){
                //     A_GiveInventory("DualFiring",1);
                // }
                // if((PressingAltFire() && CountInv("PB_SMGBurstFire") == 0 || JustPressed(BT_ALTATTACK)) && !A_IsFiringLeftWeapon() && GetCvar("SingleDualFire") == 2){
                //         if(!PB_GetChamberEmpty(true)){
                //             return state("FireLeft_Overlay");
                //         }
                //         else if(JustPressed(BT_ALTATTACK)) {
                //             A_PlaySoundEx("weapons/empty", "Auto");
                //             return state(null);
                //         }
                //     }
                // if(CountInv("DualFiring")==0 || (CountInv("DualFiring")==0 && CountInv("PB_SMGMag")<=0) || GetCvar("SingleDualFire")==1){
                //     if((PressingFire() && CountInv("PB_SMGBurstFire") == 0 || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && GetCvar("SingleDualFire") < 2){
                //         if(!PB_GetChamberEmpty(true)){
                //             return state("FireLeft_Overlay");
                //         }
                //         else if(JustPressed(BT_ATTACK)) {
                //             A_PlaySoundEx("weapons/empty", "Auto");
                //             return state(null);
                //         }
                //     }
                // }
                // return state(null);
            }
            Loop;

        IdleRight_Overlay:
            A2FR A 1 {
                if(PB_GetMagUnloaded())
                {
                    if(getSilencer()) A_SetWeaponFrame(3);
                    else {
                        A_SetWeaponFrame(1);
                        PB_CoolDownBarrel(-15, 0, 0);
                    }
                }
                else if(getSilencer()) A_SetWeaponFrame(2);
                else PB_CoolDownBarrel(-15, 0, 0);
                return A_DoPBRightAction();

                // if(!PB_GetChamberEmpty(true) && PB_GetChamberEmpty){
                //     A_TakeInventory("DualFiring",1);
                // }
                // if(CountInv("DualFiring")==1 || (CountInv("DualFiring")==1 && invoker.ammoleft.amount<=0)){
                //     if((PressingFire() && CountInv("PB_SMGBurstFire") == 0 || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && GetCvar("SingleDualFire")==0){
                //         if(!PB_GetChamberEmpty){
                //             return state("FireRight_Overlay");
                //         }
                //         else if(JustPressed(BT_ATTACK)) {
                //             A_PlaySoundEx("weapons/empty", "Auto");
                //             return state(null);
                //         }
                //     }
                // }
                // if((PressingAltfire() && CountInv("PB_SMGBurstFire") == 0 || JustPressed(BT_ALTATTACK)) && !A_IsFiringRightWeapon() && GetCvar("SingleDualFire")==1){
                //     if(!PB_GetChamberEmpty) {
                //         return state("FireRight_Overlay");
                //     }
                //     else if(JustPressed(BT_ALTATTACK)) {
                //         A_PlaySoundEx("weapons/empty", "Auto");
                //         return state(null);
                //     }
                // }
                // if((PressingFire() && CountInv("PB_SMGBurstFire") == 0 || JustPressed(BT_ATTACK)) && !A_IsFiringRightWeapon() && GetCvar("SingleDualFire")==2){
                //     if(!PB_GetChamberEmpty){
                //         return state("FireRight_Overlay");
                //     }
                //     else if(JustPressed(BT_ATTACK)) {
                //         A_PlaySoundEx("weapons/empty", "Auto");
                //         return state(null);
                //     }
                // }
                // return state(null);
            }
            Loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
            TNT1 A 0 {
                setBurstCount(0);
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
                PB_HandleCrosshair(67);
            }
        Burst:
            TNT1 A 0 PB_JumpIfNoAmmo();
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Fire2");
            TNT1 A 0 A_Jump(256, "Flash_Variant1", "Flash_Variant2", "Flash_Variant3", "Flash_Variant4", "Flash_Variant5");
        ActualFire:
            "####" "#" 1 SMG_Fire(1);
            A1F1 G 1     SMG_Fire(2);
            A1F1 H 1     SMG_Fire(3);
		    TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurstFire() && !PB_GetChamberEmpty(), "Burst");
            A1F1 EEEE 1 {
                SMG_Fire(4);
                if(PressingAltfire()) return Resolvestate("ZoomIn");
                if(PressingFire() && !getBurstFire() || JustPressed(BT_ATTACK)) return Resolvestate("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            }
            TNT1 A 0 PB_ReFire("Fire");
            Goto Ready3;

        Fire2:
            TNT1 A 0 {
                setBurstCount(0);
                A_WeaponOffset(0,32);
                A_SetCrosshair(-1);
            }
        Burst2:
            TNT1 A 0 PB_JumpIfNoAmmo();
            A1F3 G 1 SMG_Fire(1);
            A1F3 H 1 SMG_Fire(2);
            A1F3 I 1 SMG_Fire(3);
		    TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurstFire() && !PB_GetChamberEmpty(), "Burst2");
            A1F3 FFFFFFFF 1 {
                SMG_Fire(4);
                if(PB_GetAimMode()) {
                    if(!PressingAltfire())
                        return Resolvestate("Zoomout");
                    if ((!getBurstFire() && PressingFire() || JustPressed(BT_ATTACK)) && PressingAltfire())
                        return Resolvestate("Fire2");
                }
                else {
                    if(PressingAltfire())
                        return Resolvestate("Zoomout");
                    if (!getBurstFire() && PressingFire() || JustPressed(BT_ATTACK))
                        return Resolvestate("Fire2");
                }
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            }
            TNT1 A 0 A_JumpIf(PressingFire(), "Fire2");
            Goto Ready2;

        FireLeft_Overlay:
            // Cache Sprites
            A2S1 DEF 0;
            A2FU A 0;
            A2SU A 0;
            // Code
            TNT1 A 0 setBurstCount(0,true);
        BurstLeft_Overlay:
            A2F1 D 1 SMG_FireOverlay(1,true);
            A2F1 E 1 SMG_FireOverlay(2,true);
            A2F1 F 1 SMG_FireOverlay(3,true);
		    TNT1 A 0 A_JumpIf(getBurstCount(true) < 3 && getBurstFire() && !PB_GetChamberEmpty(true), "BurstLeft_Overlay");
            TNT1 A 0 SMG_FireOverlay(4,true);
            Goto IdleLeft_Overlay;

        FireRight_Overlay:
            // Cache Sprites
            A2S1 ABC 0;
            // Code
            TNT1 A 0 setBurstCount(0);
        BurstRight_Overlay:
            A2F1 A 1 SMG_FireOverlay(1,false);
            A2F1 B 1 SMG_FireOverlay(2,false);
            A2F1 C 1 SMG_FireOverlay(3,false);
		    TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurstFire() && !PB_GetChamberEmpty(), "BurstRight_Overlay");
            TNT1 A 0 SMG_FireOverlay(4,false);
            Goto IdleRight_Overlay;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(67);
                A_SetInventory("PB_LockScreenTilt",0);
            }
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "Ready3");
            TNT1 A 0 A_PlaySound("IronSights", 0);
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Zoomout");
        ZoomIn:
            TNT1 A 0 {
                A_SetCrosshair(-1);
                A_ZoomFactor(1.25);
                PB_SetZoom(true);
            }
            TNTI A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "AimSilencerOverlay");
            }
            A1F3 ABCDE 1;
            Goto Ready2;
            
        Zoomout:
            TNT1 A 0 {
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
            }
            A1F3 ED 1;
            TNTI A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "AimOutSilencerOverlay");
            }
            A1F3 CBA 1;
            TNT1 A 0 PB_HandleCrosshair(67);
            Goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
            TNT1 A 0 SMG_WeaponSpecial();
            Goto Ready3;

        ScrewOnSilencer:
            // Cache Sprites
            A4F3 ABCDEFGHIJKLMNOP 0;
            A4F4 NOPQR 0;
            // Code
            TNT1 A 0 A_JumpIf(!A_CheckAkimbo(), "ContinueScrewing");
            TNT1 A 4 {
                A_Overlay(PSP_LEFTGUN, "StopDualWield_Left", false);
                A_Overlay(PSP_RIGHTGUN, "StopDualWield_Right", false);
            }
            A1F1 ABCD 1;
        ContinueScrewing:
            TNT1 A 0 A_StartSound("weapons/smg/tilt", CHAN_AUTO);
            A0F3 ABCDEFG 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/armup", CHAN_AUTO);
            A0F3 HIKLMNO 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw/on", CHAN_AUTO);
            A0F3 PP 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw_1", CHAN_AUTO);
            A0F3 RSTUUPP 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw_2", CHAN_AUTO);
            A0F3 RSTUUPP 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw_3", CHAN_AUTO);
            A0F3 RSTUUUU 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 {
                A_StartSound("weapons/smg/screw/off", CHAN_AUTO, CHANF_DEFAULT, 0.2);
                setSilencer(true);
            }
            A0F4 N 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/raise", CHAN_AUTO);
            A0F4 OPQR 1 {
                SMG_SetSprite("A0F4",unloaded:"A4F4");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SwitchToDualWield");
            Goto Ready3;

        ScrewOffSilencer:
            TNT1 A 0 A_JumpIf(!A_CheckAkimbo(), "ContinueUnscrewing");
            TNT1 A 4 {
                A_Overlay(PSP_LEFTGUN, "StopDualWield_Left", false);
                A_Overlay(PSP_RIGHTGUN, "StopDualWield_Right", false);
            }
            A1F1 ABCD 1;
        ContinueUnscrewing:
            TNT1 A 0 A_StartSound("weapons/smg/tilt", CHAN_AUTO);
            A0F4 RQPON 1 {
                SMG_SetSprite("A0F4",unloaded:"A4F4");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw/on", CHAN_AUTO, CHANF_DEFAULT, 0.2);
            A0F3 UUUUTSR 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw_3", CHAN_AUTO);
            A0F3 PPUUTSR 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw_2", CHAN_AUTO);
            A0F3 PPUUTSR 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw_1", CHAN_AUTO);
            A0F3 PPO 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/screw/off", CHAN_AUTO);
            A0F3 NMLKIHG 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_StartSound("weapons/smg/respectmagup", CHAN_AUTO);
            A0F3 FEDCBA 1 {
                SMG_SetSprite("A0F3",unloaded:"A4F3");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 setSilencer(false);
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SwitchToDualWield");
            Goto Ready3;

        ToggleBurst:
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "FlashPunching_Silencer");
            }
            A3F1 ABCDEFF 1 SMG_SetSprite("A3F1",unloaded:"A3U1");
            TNT1 A 0 A_StartSound("LIGHTON",CHAN_AUTO);
            A3F1 FFEDCBA 1 SMG_SetSprite("A3F1",unloaded:"A3U1");
            Goto Ready3;

        ToggleBurst_Dual:
            TNT1 A 0 {
                if(getSilencer()) {
                    A_Overlay(FLASHDW_LEFT_SUPP, "FlashKickingDW_Left_Silencer");
                    A_Overlay(FLASHDW_RIGHT_SUPP, "FlashKickingDW_Right_Silencer");
                }

                if(PB_GetMagUnloaded(true)) A_Overlay(PSP_LEFTGUN, "FlashKickingDW_Left_Unloaded");
                else                        A_Overlay(PSP_LEFTGUN, "FlashKickingDW_Left");

                if(PB_GetMagUnloaded())     A_Overlay(PSP_RIGHTGUN, "FlashKickingDW_Right_Unloaded");
                else                        A_Overlay(PSP_RIGHTGUN, "FlashKickingDW_Right");
            }
            TNT1 AAAAAAA 1;
            TNT1 A 0 A_StartSound("LIGHTON",CHAN_AUTO);
            TNT1 AAAAAAAA 1;
            Goto Ready3;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
            Reload:
                TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
                TNT1 A 0 PB_CheckReload("ReloadUnloaded","BoltPull","Rechamber","Ready3","Ready3",MAGAZINE_SIZE);
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadSilencer");
                }
                TNT1 A 0 A_StartSound("weapons/smg/raise");
                A1F4 ABCD 1;
                TNT1 A 0 A_StartSound("weapons/rifle/magchange", CHAN_AUTO);
                A1F4 F 1 A_WeaponOffset(1, 32);
                A1F4 F 1 A_WeaponOffset(3, 32);
                A1F4 F 2 A_WeaponOffset(5, 32);
                A1F4 F 2 A_WeaponOffset(2, 32);
                A1F4 F 1 A_WeaponOffset(1, 32);
                TNT1 A 0 {
                    A_StartSound("weapons/smg_out", CHAN_AUTO);
                    PB_SetMagUnloaded(true);
                    if(PB_GetMagEmpty()) PB_SpawnCasing("SMGEmptyMagazine",30,0,16,1,2,-2,false);
                }
                TNT1 A 0 A_WeaponOffset(0,32);
                A1F4 GGHIJ 1 PB_SetRoll(roll-0.4);
                A1F4 KLLLO 1 PB_SetRoll(roll+0.4);
                A1F4 OPQ 1;
                A1F4 RR 1 PB_SetRoll(roll+0.5);
                TNT1 A 0 A_PlaySoundEx("weapons/smg_in", "Auto");
                A1F4 T 1 PB_SetRoll(roll+0.5);
                Goto ReloadContinue;
                
            BoltPull:
                A4FP A 1 {
                    A_StartSound("weapons/smg/raise");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullSilencer");
                }
                A4FP B 1;
                A4FP C 1 A_StartSound("weapons/smg/armup", CHAN_AUTO);
                A4FP DEFFF 1;
                A4FP I 1 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
                A4FP J 3;
                A4FP KLLLLOP 1;
                Goto Reload2;

            BoltPullSilencer:
                ASF1 ABCDEEEE 1;
                A4FS ABBBCDDDDEF 1;
                Stop;

            Reload2:
                A4F1 B 1 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "Reload2Silencer");
                }
                A4F1 C 1 {
                    A_WeaponOffset(1, 32);
                    A_StartSound("weapons/rifle/magchange", CHAN_AUTO);
                }
                A4F1 C 1 A_WeaponOffset(3, 32);
                A4F1 C 2 A_WeaponOffset(5, 32);
                A4F1 C 2 A_WeaponOffset(2, 32);
                A4F1 C 1 A_WeaponOffset(1, 32);
                TNT1 A 0 {
                    A_StartSound("weapons/smg_out", CHAN_AUTO);
                    PB_SetMagUnloaded(true);
                    if(PB_GetMagEmpty()) PB_SpawnCasing("SMGEmptyMagazine",30,0,16,1,2,-2,false);
                }
                TNT1 A 0 A_WeaponOffset(0,32);
                A4F1 DDEFG 1 PB_SetRoll(roll-0.4);
                A4F1 HIJKL 1 PB_SetRoll(roll+0.4);
                A4F1 LMN 1;
                A4F1 OO 1 PB_SetRoll(roll+0.5);
                TNT1 A 0 A_StartSound("weapons/smg_in", CHAN_AUTO);
                A4F1 P 1 PB_SetRoll(roll+0.5);
            ReloadContinue:
                TNT1 A 0 {
                    if(PB_GetChamberEmpty()) A_Overlay(EMPTYBOLT_OVERLAY, "EmptyBoltOverlay");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadContinueSilencer");
                    A_StartSound("weapons/smg/tilt");
                }
                A1F4 UVWXY 1 A_WeaponOffset(0,32,SPF_INTERPOLATE);
                A1F4 Z 1 PB_SetRoll(roll-0.5);
                TNT1 A 0 {
                    PB_AmmoIntoMag(
                        invoker.ammo2.getClassName(),
                        invoker.ammo1.getClassName(),
                        PB_GetChamberEmpty() ? MAGAZINE_SIZE-1 : MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                }
                TNT1 A 0 A_StartSound("weapons/smg/raise", CHAN_AUTO);
                A1F5 ABCDE 1;
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"LoadChamber");
                TNT1 A 0 {
                    if(getSilencer() && !PB_GetChamberEmpty())
                        A_Overlay(SILENCER_OVERLAY, "InsertBullets2Silencer");
                }
                A1F5 F 1 A_JumpIf(A_CheckAkimbo(), "InsertBulletsRight");
                TNT1 A 0 A_StartSound("weapons/smg/lower");
                A1F5 GHIJKL 1 PB_SetRoll(roll-0.5);
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

            RechamberSilencer:
                ASF2 FFEDCBA 1;
                Stop;

            Rechamber:
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "RechamberSilencer");
                }
                A1F5 LKJIHGF 1;
            LoadChamber:
                // Cache Sprites
                HKSR A 0;
                HKSS A 0;
                // Code
                HKSP ABCDEFG 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                TNT1 A 0 A_StartSound("weapons/smg/armswing", CHAN_AUTO);
                HKSP HIJKL 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                TNT1 A 0 {
                    A_StartSound("weapons/smg_click", CHAN_AUTO);
                    PB_SetChamberEmpty(false);
                }
                HKSP MOPRSTUVWXYZ 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                HKSQ AB 1 SMG_SetSprite("HKSQ",silenced:"HKSS");
                TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "InsertBulletsRight");
                HKSQ CDE 1 SMG_SetSprite("HKSQ",silenced:"HKSS");
                Goto Ready3;

            ReloadUnloaded:
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"BoltPullUnloaded");
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadUnloadedSilencer");
                    A_StartSound("weapons/smg/raise");
                }
                A4F1 UVW 1;
                TNT1 A 0 A_StartSound("weapons/smg_in", CHAN_AUTO);
                A4F1 X 1;
                TNT1 A 0 A_Overlay(EMPTYBOLT_OVERLAY, "UnloadedBoltOverlay");
                Goto ReloadContinue;

            BoltPullUnloaded:
                A4FU A 1 {
                    A_StartSound("weapons/smg/raise");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullSilencer");
                }
                A4FU B 1;
                A4FU C 1 A_StartSound("weapons/smg/armup", CHAN_AUTO);
                A4FU DEFFF 1;
                A4FU I 1 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
                A4FU J 3;
                A4FU KLLLL 1;
                TNT1 A 0 {
                    A_StartSound("weapons/smg/raise");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullSilencer2");
                }
                A4FU OPRR 1;
                TNT1 A 0 A_StartSound("weapons/smg_in", CHAN_AUTO);
                A4FU R 1;
                Goto ReloadContinue;

            ReloadUnloadedSilencer:
                ASF3 ABCD 1;
                Stop;

            UnloadedBoltOverlay:
                A4FB ABCDEFGHIJJKLM 1;
                Stop;

            EmptyBoltOverlay:
                A4FB ABCDEFGHIJJ 1;
                Stop;

            ReloadDWSilencer:
                A3S4 ABCD 1;
                Goto DualReloadSilencer2;

            ReloadSilencer:
                ASF1 ABC 1;
            Reload2Silencer:
                ASF1 D 1;
            DualReloadSilencer2:
                ASF1 E 1;
                ASF1 E 1;
                ASF1 E 2;
                ASF1 E 2;
                ASF1 E 1;
                ASF1 FFGHI 1;
                ASF1 JKKKL 1;
                ASF1 LMN 1;
                ASF1 OOP 1;
                Stop;

            ReloadContinueSilencer:
                ASF1 QRSTUVWXYZZ 1;
                Stop;

            ReloadDWEndSilencer:
                A3S4 DCBA 1;
                Stop;

            InsertBullets2Silencer:
                ASF2 ABCDEFF 1;
                Stop;

            InsertBulletsRight:
                HKSQ FGH 1;
                TNT1 A 0 A_JumpIf(invoker.ammoleft.amount < MAGAZINE_SIZE || PB_GetMagUnloaded(true),"ReloadLeftGun");
                Goto FinishInsertBullets;

            BoltPullRight:
                A3F4 A 1 {
                    A_StartSound("weapons/smg/raise");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullDWSilencer");
                }
                A3F4 B 1;
                A3F4 C 1 A_StartSound("weapons/smg/armup", CHAN_AUTO);
                A4FP DEFFF 1;
                A4FP I 1 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
                A4FP J 3;
                A4FP KLLLLOP 1;
                Goto Reload2DW;

            ReloadDualWield:
                TNT1 A 0 PB_CheckReload(null,null,null,"ReloadLeftGunOnly","Ready3",MAGAZINE_SIZE);
                TNT1 A 6 {
                    A_Overlay(PSP_LEFTGUN, "StopDualWield_Left", false);
                    A_Overlay(PSP_RIGHTGUN, "StopDualWield_Right", false);
                }
                TNT1 A 0 PB_CheckReload("ReloadUnloaded","BoltPullRight","RechamberRight","ReloadLeftGunOnly","Ready3",MAGAZINE_SIZE);
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadSilencer");
                }
                TNT1 A 0 A_StartSound("weapons/smg/raise");
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadDWSilencer");
                }
                A3F4 ABCD 1;
                TNT1 A 0 A_StartSound("weapons/rifle/magchange", CHAN_AUTO);
                A1F4 F 1 A_WeaponOffset(1, 32);
                A1F4 F 1 A_WeaponOffset(3, 32);
                A1F4 F 2 A_WeaponOffset(5, 32);
                A1F4 F 2 A_WeaponOffset(2, 32);
                A1F4 F 1 A_WeaponOffset(1, 32);
                TNT1 A 0 {
                    A_StartSound("weapons/smg_out", CHAN_AUTO);
                    PB_SetMagUnloaded(true);
                    if(PB_GetMagEmpty()) PB_SpawnCasing("SMGEmptyMagazine",30,0,16,1,2,-2,false);
                }
                TNT1 A 0 A_WeaponOffset(0,32);
                A1F4 GGHIJ 1 PB_SetRoll(roll-0.4);
                A1F4 KLLLO 1 PB_SetRoll(roll+0.4);
                A1F4 OPQ 1;
                A1F4 RR 1 PB_SetRoll(roll+0.5);
                TNT1 A 0 A_PlaySoundEx("weapons/smg_in", "Auto");
                A1F4 T 1 PB_SetRoll(roll+0.5);
                Goto ReloadDWContinue;

            Reload2DW:
                A4F1 B 1 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "Reload2Silencer");
                }
                A4F1 C 1 {
                    A_WeaponOffset(1, 32);
                    A_StartSound("weapons/rifle/magchange", CHAN_AUTO);
                }
                A4F1 C 1 A_WeaponOffset(3, 32);
                A4F1 C 2 A_WeaponOffset(5, 32);
                A4F1 C 2 A_WeaponOffset(2, 32);
                A4F1 C 1 A_WeaponOffset(1, 32);
                TNT1 A 0 {
                    A_StartSound("weapons/smg_out", CHAN_AUTO);
                    PB_SetMagUnloaded(true);
                    if(PB_GetMagEmpty()) PB_SpawnCasing("SMGEmptyMagazine",30,0,16,1,2,-2,false);
                }
                TNT1 A 0 A_WeaponOffset(0,32);
                A4F1 DDEFG 1 PB_SetRoll(roll-0.4);
                A4F1 HIJKL 1 PB_SetRoll(roll+0.4);
                A4F1 LMN 1;
                A4F1 OO 1 PB_SetRoll(roll+0.5);
                TNT1 A 0 A_StartSound("weapons/smg_in", CHAN_AUTO);
                A4F1 P 1 PB_SetRoll(roll+0.5);
            ReloadDWContinue:
                TNT1 A 0 {
                    if(PB_GetChamberEmpty()) A_Overlay(EMPTYBOLT_OVERLAY, "EmptyBoltOverlay");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadContinueSilencer");
                    A_StartSound("weapons/smg/tilt");
                }
                A1F4 UVWXY 1 A_WeaponOffset(0,32,SPF_INTERPOLATE);
                A1F4 Z 1 PB_SetRoll(roll-0.5);
                TNT1 A 0 {
                    PB_AmmoIntoMag(
                        invoker.ammo2.getClassName(),
                        invoker.ammo1.getClassName(),
                        PB_GetChamberEmpty() ? MAGAZINE_SIZE-1 : MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                }
                TNT1 A 0 A_StartSound("weapons/smg/raise", CHAN_AUTO);
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"LoadChamberRight");
                A1F5 ABCDE 1;
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadDWEndSilencer");
                }	
                A3F4 DCBA 1;
                TNT1 A 0 A_JumpIf(invoker.ammoleft.amount < MAGAZINE_SIZE || PB_GetMagUnloaded(true),"ReloadLeftGun");
                Goto FinishInsertBullets;

            RechamberDWSilencer:
                ASF1 EFG 1;
                ASF2 CBA 1;
                Stop;

            RechamberRight:
                TNT1 A 3;
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "RechamberDWSilencer");
                }
                A3F4 EFG 1;
                A1F5 HGF 1;
            LoadChamberRight:
                // Cache Sprites
                HKSR ABCDEFGHIJKL 0;
                HKSS ABCDE 0;
                // Code
                TNT1 A 0 A_PlaySoundEx("weapons/smg/raise", "Auto");
                A1F5 ABCDE 1;
                HKSP ABCDEFG 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                TNT1 A 0 A_StartSound("weapons/smg/armswing", CHAN_AUTO);
                HKSP HIJKL 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/smg_click", "Auto");
                    PB_SetChamberEmpty(false);
                }
                HKSP MOPRSTUVWXYZ 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                HKSQ AB 1 SMG_SetSprite("HKSQ",silenced:"HKSS");
                HKSQ FGH 1 SMG_SetSprite("HKSQ",silenced:"HKSS");
                TNT1 A 0 A_JumpIf(invoker.ammoleft.amount < MAGAZINE_SIZE || PB_GetMagUnloaded(true),"ReloadLeftGun");
                Goto FinishInsertBullets;

            BoltPullLeft:
                A3F4 A 1 {
                    A_StartSound("weapons/smg/raise");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullDWSilencer");
                }
                A3F4 B 1;
                A3F4 C 1 A_StartSound("weapons/smg/armup", CHAN_AUTO);
                A4FP DEFFF 1;
                A4FP I 1 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
                A4FP J 3;
                A4FP KLLLLOP 1;
                Goto ReloadLeft2;

            BoltPullDWSilencer:
                A3S4 ABCD 1;
                ASF1 EEEE 1;
                A4FS ABBBCDDDDEF 1;
                Stop;

            ReloadLeftGunOnly:
                TNT1 A 0 PB_CheckReload(null,null,null,"Ready3","Ready3",MAGAZINE_SIZE,invoker.reservetomagammofactor,true);
                TNT1 A 3 {
                    A_Overlay(PSP_LEFTGUN, "StopDualWield_Left", false);
                    A_Overlay(PSP_RIGHTGUN, "StopDualWield_Right", false);
                }
            ReloadLeftGun:
                TNT1 A 0 PB_CheckReload("ReloadLeftUnloaded","BoltPullLeft","RechamberLeft","Ready3","Ready3",MAGAZINE_SIZE,invoker.reservetomagammofactor,true);
                TNT1 A 3;
                TNT1 A 0 A_PlaySoundEx("weapons/smg_up", "Auto");
                TNT1 A 0 {
                    if(invoker.ammoleft.amount < 1) invoker.smgWasEmpty = true;
                    else invoker.smgWasEmpty = false;
                }
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadDWSilencer");
                }
                A3F4 ABCD 1;
                TNT1 A 0 A_StartSound("weapons/rifle/magchange", CHAN_AUTO);
                A1F4 F 1 Offset(1, 32);
                A1F4 F 1 Offset(3, 32);
                A1F4 F 2 Offset(5, 32);
                A1F4 F 2 Offset(2, 32);
                A1F4 F 1 Offset(1, 32);
                TNT1 A 0 {
                    A_StartSound("weapons/smg_out", CHAN_AUTO);
                    PB_SetMagUnloaded(true,true);
                    if(PB_GetMagEmpty(true)) PB_SpawnCasing("SMGEmptyMagazine",30,0,16,1,2,-2,false);
                }
                TNT1 A 0 A_WeaponOffset(0,32);
                A1F4 GGHIJ 1 PB_SetRoll(roll-0.4);
                A1F4 KLLLO 1 PB_SetRoll(roll+0.4);
                A1F4 OPQ 1;
                A1F4 RRT 1 PB_SetRoll(roll+0.5);
                TNT1 A 0 A_PlaySoundEx("weapons/smg_in", "Auto");
                Goto ReloadLeftContinue;

            ReloadLeftUnloaded:
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(true),"BoltPullLeftUnloaded");
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadUnloadedSilencer");
                    A_StartSound("weapons/smg/raise");
                }
                A4F1 UVW 1;
                TNT1 A 0 A_StartSound("weapons/smg_in", CHAN_AUTO);
                A4F1 X 1;
                Goto ReloadLeftContinue;

            BoltPullSilencer2:
                ASFU ABCCC 1;
                Stop;

            BoltPullLeftUnloaded:
                A4FU A 1 {
                    A_StartSound("weapons/smg/raise");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullSilencer");
                }
                A4FU B 1;
                A4FU C 1 A_StartSound("weapons/smg/armup", CHAN_AUTO);
                A4FU DEFFF 1;
                A4FU I 1 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
                A4FU J 3;
                A4FU KLLLL 1;
                TNT1 A 0 {
                    A_StartSound("weapons/smg/raise");
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullSilencer2");
                }
                A4FU OPRR 1;
                TNT1 A 0 A_StartSound("weapons/smg_in", CHAN_AUTO);
                A4FU R 1;
                TNT1 A 0 A_Overlay(EMPTYBOLT_OVERLAY, "UnloadedBoltOverlay");
                Goto ReloadLeftContinue;

            ReloadLeft2:
                //A1F4 AB 1
                A4F1 B 1 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "Reload2Silencer");
                }
                A4F1 C 1 Offset(1, 32) A_StartSound("weapons/rifle/magchange", CHAN_AUTO);
                A4F1 C 1 Offset(3, 32);
                A4F1 C 2 Offset(5, 32);
                A4F1 C 2 Offset(2, 32);
                A4F1 C 1 Offset(1, 32);
                TNT1 A 0 {
                    A_StartSound("weapons/smg_out", CHAN_AUTO);
                    PB_SetMagUnloaded(true,true);
                    if(PB_GetMagEmpty(true)) PB_SpawnCasing("SMGEmptyMagazine",30,0,16,1,2,-2,false);
                }
                TNT1 A 0 A_WeaponOffset(0,32);
                A4F1 DDEFG 1 PB_SetRoll(roll-0.4);
                A4F1 HIJKL 1 PB_SetRoll(roll+0.4);
                A4F1 LMN 1;
                A4F1 OOP 1 PB_SetRoll(roll+0.5);
            ReloadLeftContinue:
                TNT1 A 0 {
                    A_PlaySoundEx("Ironsights", "Auto");
                    if(invoker.smgWasEmpty) A_Overlay(EMPTYBOLT_OVERLAY, "EmptyBoltOverlay");
                }
                TNTI A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadContinueSilencer");
                }
                A1F4 UVWXYZ 1 A_WeaponOffset(0,32,SPF_INTERPOLATE);
                TNT1 A 0 {
                    PB_AmmoIntoMag(
                        invoker.ammoleft.getClassName(),
                        invoker.ammo1.getClassName(),
                        PB_GetChamberEmpty(true) ? MAGAZINE_SIZE-1 : MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false,true);
                    PB_SetMagEmpty(false,true);
                }
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(true),"LoadChamberLeft");
                TNT1 A 0 PB_SetRoll(roll-0.5);
                A1F5 ABCDE 1;
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadDWEndSilencer");
                }	
                A3F4 DCBA 1;
                Goto FinishInsertBullets;

            RechamberLeft:
                TNT1 A 3;
                TNT1 A 0 {
                    if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "RechamberDWSilencer");
                }
                A3F4 EFG 1;
                A1F5 HGF 1;
            LoadChamberLeft:
                // Cache Sprites
                HKSR ABCDEFGHIJKL 0;
                HKSS ABCDE 0;
                // Code
                TNT1 A 0 A_PlaySoundEx("weapons/smg/raise", "Auto");
                A1F5 ABCDE 1;
                HKSP ABCDEFG 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                TNT1 A 0 A_StartSound("weapons/smg/armswing", CHAN_AUTO);
                HKSP HIJKL 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                TNT1 A 0 {
                    A_PlaySoundEx("weapons/smg_click", "Auto");
                    PB_SetChamberEmpty(false,true);
                }
                HKSP MOPRSTUVWXYZ 1 SMG_SetSprite("HKSP",silenced:"HKSR");
                HKSQ AB 1 SMG_SetSprite("HKSQ",silenced:"HKSS");
                HKSQ FGH 1 SMG_SetSprite("HKSQ",silenced:"HKSS");
            FinishInsertBullets:
                TNT1 A 2;
                TNT1 A 4 {
                    A_Overlay(PSP_LEFTGUN, "SwitchToDualWield_Left", false);
                    A_Overlay(PSP_RIGHTGUN, "SwitchToDualWield_Right", false);
                }
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
            Unload:
            TNT1 A 0 {
                A_ZoomFactor(1.0);
                A_SetCrosshair(-1);
                A_SetInventory("PB_LockScreenTilt",1);
                A_StartSound("weapons/smg/raise");
                PB_SetZoom(false);
                PB_ClearDualWield();
            }
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"UnloadDualWield");
            A4FP I 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullSilencer");
            }
            A4FP AB 1;
            TNT1 A 0 A_StartSound("weapons/smg/armup", CHAN_AUTO);
            A4FP CDEFFF 1;
            TNT1 A 0 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
            A4FP IJJJ 1;
            A4FP KLLLLOP 1;
            TNTI A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "UnloadSilencer");
            }
            //TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO)
            A4F1 B 1;
            A4F1 C 1 Offset(1, 32);
            A4F1 C 1 Offset(3, 32);
            A4F1 C 2 Offset(5, 32);
            A4F1 C 2 Offset(2, 32);
            TNT1 A 0 {
                A_StartSound("weapons/smg_out", CHAN_AUTO);
                PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName());
                PB_SetMagUnloaded(true);
                PB_SetChamberEmpty(true);
            }
            A4F1 C 1 Offset(1, 32);
            A4F1 GHIJKLMN 1;
            TNT1 A 0 A_StartSound("weapons/smg/lower", CHAN_AUTO);
            A4F1 OQRST 1;
        FInishUnload:
            TNT1 A 0 PB_SetReloading(false);
            Goto Ready3;

        UnloadDualWield:
            TNT1 A 6 {
                A_Overlay(PSP_LEFTGUN, "StopDualWield_Left", false);
                A_Overlay(PSP_RIGHTGUN, "StopDualWield_Right", false);
            }
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"UnloadLeft");
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadSilencer");
            }
            TNT1 A 0 A_StartSound("weapons/smg/raise");
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadDWSilencer");
            }
            A3F4 A 1 {
                A_StartSound("weapons/smg/raise");
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullDWSilencer");
            }
            A3F4 B 1;
            A3F4 C 1 A_StartSound("weapons/smg/armup", CHAN_AUTO);
            A4FP DEFFF 1;
            A4FP I 1 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
            A4FP JJJ 1;
            A4FP KLLLLOP 1;
            TNTI A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "UnloadSilencer");
            }
            A4F1 B 1;
            A4F1 C 1 Offset(1, 32);
            A4F1 C 1 Offset(3, 32);
            A4F1 C 2 Offset(5, 32);
            A4F1 C 2 Offset(2, 32);
            TNT1 A 0 {
                A_StartSound("weapons/smg_out", CHAN_AUTO);
                PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName());
                PB_SetMagUnloaded(true);
                PB_SetChamberEmpty(true);
            }
            A4F1 C 1 Offset(1, 32);
            A4F1 GHIJKLMN 1;
            TNT1 A 0 A_StartSound("weapons/smg/lower", CHAN_AUTO);
            A4F1 OQR 1;
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true),"FInishUnloadDW");
            TNT1 A 2;
        UnloadLeft:
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadSilencer");
            }
            TNT1 A 0 A_StartSound("weapons/smg/raise");
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "ReloadDWSilencer");
            }
            A3F4 A 1 {
                A_StartSound("weapons/smg/raise");
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "BoltPullDWSilencer");
            }
            A3F4 B 1;
            A3F4 C 1 A_StartSound("weapons/smg/armup", CHAN_AUTO);
            A4FP DEFFF 1;
            A4FP I 1 A_StartSound("weapons/smg/boltlock", CHAN_AUTO);
            A4FP IJJJ 1;
            A4FP KLLLLOP 1;
            TNTI A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "UnloadSilencer");
            }
            A4F1 B 1;
            A4F1 C 1 Offset(1, 32);
            A4F1 C 1 Offset(3, 32);
            A4F1 C 2 Offset(5, 32);
            A4F1 C 2 Offset(2, 32);
            TNT1 A 0 {
                A_StartSound("weapons/smg_out", CHAN_AUTO);
                PB_UnloadMag(invoker.ammoleft.getClassName(),invoker.ammo1.getClassName());
                PB_SetMagUnloaded(true,true);
                PB_SetChamberEmpty(true,true);
            }
            A4F1 C 1 Offset(1, 32);
            A4F1 GHIJKLMN 1;
            TNT1 A 0 A_StartSound("weapons/smg/lower", CHAN_AUTO);
            A4F1 OQR 1;
        FInishUnloadDW:
            TNT1 A 4 {
                A_Overlay(PSP_LEFTGUN, "SwitchToDualWield_Left", false);
                A_Overlay(PSP_RIGHTGUN, "SwitchToDualWield_Right", false);
            }
            TNT1 A 0 PB_SetReloading(false);
            Goto Ready3;

        UnloadSilencer:
            ASF1 D 1;
            ASF1 E 1;
            ASF1 E 1;
            ASF1 E 2;
            ASF1 E 2;
            ASF1 E 1;
            ASF1 IJKKKLMNO 1;
            ASF4 ABCD 1;
            Stop;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        Flash_Variant1:
            A1F1 F 0 {
                SMG_SetSprite("A1F1",silenced:"A1S1");
                A_Overlay(LEFTMUZZLEFLASH, "GunFlash1", true);
                A_OverlayFlags(LEFTMUZZLEFLASH,PSPF_RENDERSTYLE,true);
                A_OverlayRenderStyle(LEFTMUZZLEFLASH,STYLE_Add);
            }
            Goto ActualFire;

        Flash_Variant2:
            A1F1 I 0 {
                SMG_SetSprite("A1F1",silenced:"A1S1");
                A_Overlay(LEFTMUZZLEFLASH, "GunFlash2", true);
                A_OverlayFlags(LEFTMUZZLEFLASH,PSPF_RENDERSTYLE,true);
                A_OverlayRenderStyle(LEFTMUZZLEFLASH,STYLE_Add);
            }
            Goto ActualFire;
            
        Flash_Variant3:
            A1F1 J 0 {
                SMG_SetSprite("A1F1",silenced:"A1S1");
                A_Overlay(LEFTMUZZLEFLASH, "GunFlash3", true);
                A_OverlayFlags(LEFTMUZZLEFLASH,PSPF_RENDERSTYLE,true);
                A_OverlayRenderStyle(LEFTMUZZLEFLASH,STYLE_Add);
            }
            Goto ActualFire;

        Flash_Variant4:
            A1F1 K 0 {
                SMG_SetSprite("A1F1",silenced:"A1S1");
                A_Overlay(LEFTMUZZLEFLASH, "GunFlash4", true);
                A_OverlayFlags(LEFTMUZZLEFLASH,PSPF_RENDERSTYLE,true);
                A_OverlayRenderStyle(LEFTMUZZLEFLASH,STYLE_Add);
            }
            Goto ActualFire;

        Flash_Variant5:
            A1F1 L 0 {
                SMG_SetSprite("A1F1",silenced:"A1S1");
                A_Overlay(LEFTMUZZLEFLASH, "GunFlash5", true);
                A_OverlayFlags(LEFTMUZZLEFLASH,PSPF_RENDERSTYLE,true);
                A_OverlayRenderStyle(LEFTMUZZLEFLASH,STYLE_Add);
            }
            Goto ActualFire;

        GunFlash1:
            // Cache Sprites
            A1SM F 0;
            // Code
            A1FM F 1 Bright {
                SMG_SetSprite("A1FM",silenced:"A1SM");
                A_GunFlash();
            }
            Stop;

        GunFlash2:
            A1FM I 1 Bright {
                SMG_SetSprite("A1FM",silenced:"A1SM");
                A_GunFlash();
            }
            Stop;

        GunFlash3:
            A1FM J 1 Bright {
                SMG_SetSprite("A1FM",silenced:"A1SM");
                A_GunFlash();
            }
            Stop;

        GunFlash4:
            A1FM K 1 Bright {
                SMG_SetSprite("A1FM",silenced:"A1SM");
                A_GunFlash();
            }
            Stop;

        GunFlash5:
            A1FM L 1 Bright {
                SMG_SetSprite("A1FM",silenced:"A1SM");
                A_GunFlash();
            }
            Stop;
        
        LeftFlash:
            A2FM B 1 Bright {
                SMG_SetSprite("A2FM",silenced:"A2SM");
                A_GunFlash();
            }
            Stop;

        RightFlash:
            // Cache Sprites
            A2SM AB 0;
            // Code
            A2FM A 1 Bright {
                SMG_SetSprite("A2FM",silenced:"A2SM");
                A_GunFlash();
            }
            Stop;

		FlashKicking:
            // Cache Sprites
            A4F7 ABCDEFGH 0;
            A4Z7 ABCDEFGH 0;
            A1U7 ABCDEFGH 0;
            // Code
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashKickingDW");
            A1F7 ABCDEFGHFEDCBA 1 {
                SMG_SetSprite("A1F7",silenced:"A4F7",unloaded:"A1U7",silUnloaded:"A4Z7");
                return A_DoPBWeaponAction();
            }
            Goto Ready3;


        FlashPunching:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashPunchingDW");
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "FlashPunching_Silencer");
            }
            A3F1 ABCDEFFFFEDCBA 1 SMG_SetSprite("A3F1",unloaded:"A3U1");
            Goto Ready3;
            
        FlashPunching_Silencer:
            A3S1 ABCDEFFFFEDCBA 1;
            Stop;
            
        FlashAirKicking:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashAirKickingDW");
            A1F7 ABCDEFGHHGFEDCBA 1 {
                SMG_SetSprite("A1F7",silenced:"A4F7",unloaded:"A1U7",silUnloaded:"A4Z7");
                return A_DoPBWeaponAction();
            }
            Goto Ready3;
            
        FlashKickingDW:
            TNT1 A 0 {
                if(getSilencer())
                {
                    A_Overlay(FLASHDW_LEFT_SUPP, "FlashKickingDW_Left_Silencer");
                    A_Overlay(FLASHDW_RIGHT_SUPP, "FlashKickingDW_Right_Silencer");
                }
                if(PB_GetMagUnloaded(true)) A_Overlay(PSP_LEFTGUN, "FlashKickingDW_Left_Unloaded");
                else                        A_Overlay(PSP_LEFTGUN, "FlashKickingDW_Left");
                if(PB_GetMagUnloaded())     A_Overlay(PSP_RIGHTGUN, "FlashKickingDW_Right_Unloaded");
                else                        A_Overlay(PSP_RIGHTGUN, "FlashKickingDW_Right");
            }
            TNT1 AAAAAAAAAAAAAAA 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            Goto Ready3;
        
        FlashKickingDW_Left:
            A2F3 ABCDEFFFFFEDCBA 1;
            Stop;

        FlashKickingDW_Right:
            A2F4 ABCDEFFFFFEDCBA 1;
            Stop;

        FlashKickingDW_Left_Silencer:
            A2S3 ABCDEFFFFFEDCBA 1;
            Stop;

        FlashKickingDW_Right_Silencer:
            A2S4 ABCDEFFFFFEDCBA 1;
            Stop;

        FlashKickingDW_Left_Unloaded:
            A2F3 GHIJEFFFFFEJIHG 1;
            Stop;

        FlashKickingDW_Right_Unloaded:
            A2F4 GHIJKLLLLLKJIHG 1;
            Stop;

            
        FlashAirKickingDW:
            TNT1 A 0 {
                if(getSilencer())
                {
                    A_Overlay(FLASHDW_LEFT_SUPP, "FlashAirKickingDW_Left_Silencer");
                    A_Overlay(FLASHDW_RIGHT_SUPP, "FlashAirKickingDW_Right_Silencer");
                }
                if(PB_GetMagUnloaded(true)) A_Overlay(PSP_LEFTGUN, "FlashAirKickingDW_Left_Unloaded");
                else                        A_Overlay(PSP_LEFTGUN, "FlashAirKickingDW_Left");
                if(PB_GetMagUnloaded())     A_Overlay(PSP_RIGHTGUN, "FlashAirKickingDW_Right_Unloaded");
                else                        A_Overlay(PSP_RIGHTGUN, "FlashAirKickingDW_Right");
            }
            TNT1 AAAAAAAAAAAAAAAAA 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            Goto Ready3;

        FlashAirKickingDW_Left:
            A2F3 ABCDEFFFFFEDCBAAA 1 ;
            Stop;

        FlashAirKickingDW_Left_Unloaded:
            A2F3 GHIJEFFFFFEJIHGGG 1 ;
            Stop;

        FlashAirKickingDW_Right:
            A2F4 ABCDEFFFFFEDCBAAA 1 ;
            Stop;

        FlashAirKickingDW_Right_Unloaded:
            A2F4 GHIJKLLLLLKJIHGGG 1 ;
            Stop;

        FlashAirKickingDW_Left_Silencer:
            A2S3 ABCDEFFFFFEDCBAAA 1;
            Stop;

        FlashAirKickingDW_Right_Silencer:
            A2S4 ABCDEFFFFFEDCBAAA 1;
            Stop;

        FlashPunchingDW:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 15;
            Goto Ready3;
            
        FlashSlideKicking:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingDW");
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "FlashSlideKicking_Silencer");
            }
            A3F1 ABCDEFFFFFFFFFFFFFF 1 {
                SMG_SetSprite("A3F1",unloaded:"A3U1");
                return A_DoPBWeaponAction();
            }
            Goto Ready3;

        FlashSlideKicking_Silencer:
            A3S1 ABCDEFFFFFFFFFFFFFF 1;
            Stop;
            
        FlashSlideKickingDW:
            TNT1 A 0 {
                if(getSilencer())
                {
                    A_Overlay(FLASHDW_LEFT_SUPP, "FlashSlideKickingDW_Left_Silencer");
                    A_Overlay(FLASHDW_RIGHT_SUPP, "FlashSlideKickingDW_Right_Silencer");
                }
                if(PB_GetMagUnloaded(true)) A_Overlay(PSP_LEFTGUN, "FlashSlideKickingDW_Left_Unloaded");
                else                        A_Overlay(PSP_LEFTGUN, "FlashSlideKickingDW_Left");
                if(PB_GetMagUnloaded())     A_Overlay(PSP_RIGHTGUN, "FlashSlideKickingDW_Right_Unloaded");
                else                        A_Overlay(PSP_RIGHTGUN, "FlashSlideKickingDW_Right");
            }
            TNT1 ABCDEFFFFFFFFFFFFFF 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            Goto Ready3;

        FlashSlideKickingDW_Left:
            A2F3 ABCDEFFFFFFFFFFFFFF 1;
            Stop;

        FlashSlideKickingDW_Right:
            A2F4 ABCDEFFFFFFFFFFFFFF 1;
            Stop;

        FlashSlideKickingDW_Left_Unloaded:
            A2F3 GHIJEFFFFFFFFFFFFFF 1;
            Stop;

        FlashSlideKickingDW_Right_Unloaded:
            A2F4 GHIJKLLLLLLLLLLLLLL 1;
            Stop;

        FlashSlideKickingDW_Left_Silencer:
            A2S3 ABCDEFFFFFFFFFFFFFF 1;
            Stop;

        FlashSlideKickingDW_Right_Silencer:
            A2S4 ABCDEFFFFFFFFFFFFFF 1;
            Stop;
            
        FlashSlideKickingStop:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingStopDW");
            TNT1 A 0 {
                if(getSilencer()) A_Overlay(SILENCER_OVERLAY, "FlashSlideKickingStop_Silencer");
            }
            A3F1 EDCBA 1 {
                SMG_SetSprite("A3F1",unloaded:"A3U1");
                return A_DoPBWeaponAction();
            } 
            Goto Ready3;

        FlashSlideKickingStop_Silencer:
            A3S1 EDCBA 1;
            Stop;
            
        FlashSlideKickingStopDW:
            TNT1 A 0 {
                if(getSilencer())
                {
                    A_Overlay(FLASHDW_LEFT_SUPP, "FlashSlideKickingStopDW_Left_Silencer");
                    A_Overlay(FLASHDW_RIGHT_SUPP, "FlashSlideKickingStopDW_Right_Silencer");
                }
                if(PB_GetMagUnloaded(true)) A_Overlay(PSP_LEFTGUN, "FlashSlideKickingStopDW_Left_Unloaded");
                else                        A_Overlay(PSP_LEFTGUN, "FlashSlideKickingStopDW_Left");
                if(PB_GetMagUnloaded())     A_Overlay(PSP_RIGHTGUN, "FlashSlideKickingStopDW_Right_Unloaded");
                else                        A_Overlay(PSP_RIGHTGUN, "FlashSlideKickingStopDW_Right");
            }
            TNT1 EDCBA 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            Goto Ready3;

        FlashSlideKickingStopDW_Left:
            A2F3 EDCBA 1;
            Stop;

        FlashSlideKickingStopDW_Right:
            A2F4 EDCBA 1;
            Stop;

        FlashSlideKickingStopDW_Left_Unloaded:
            A2F3 EJIHG 1;
            Stop;

        FlashSlideKickingStopDW_Right_Unloaded:
            A2F4 KJIHG 1;
            Stop;

        FlashSlideKickingStopDW_Left_Silencer:
            A2S3 EDCBA 1;
            Stop;

        FlashSlideKickingStopDW_Right_Silencer:
            A2S4 EDCBA 1;
            Stop;

    }
}