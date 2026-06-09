// Gearbox Tokens
class SelectPistolBurstFire : Inventory {Default{Inventory.MaxAmount 1;}}
class SelectDualWieldPistols : Inventory {Default{Inventory.MaxAmount 1;}}
class SelectPistolSuppressor : Inventory {Default{Inventory.MaxAmount 1;}}

// Ammo Class
Class PB_PistolMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_Pistol.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_Pistol.MAGAZINE_SIZE;
		Inventory.Icon "DEGTA0";
	}
}

Class PB_PistolLeftMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_Pistol.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_Pistol.MAGAZINE_SIZE;
		Inventory.Icon "DEGTA0";
	}
}

// The Actual Weapon
class PB_Pistol : PB_WeaponBase
{
    Default
    {
        //$Category Project Brutality - Weapons
        //$Sprite DEGTA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        // SpawnID 9220
        Weapon.AmmoGive1 20;
        Weapon.AmmoType1 "PB_LowCalMag";
        Weapon.AmmoType2 "PB_PistolMag";
        PB_WeaponBase.AmmoTypeLeft "PB_PistolLeftMag";
        weapon.slotpriority 0.5;

        PB_WeaponBase.OffsetRecoilX 3.5;
        PB_WeaponBase.OffsetRecoilY 2.5;
        PB_WeaponBase.UsesWheel 1;
        PB_WeaponBase.WheelInfo "PB_pistolWheel";
        PB_WeaponBase.TailPitch 0.8;
        PB_WeaponBase.Upgrade "PB_SMG";

        Inventory.MaxAmount 2;
        Inventory.Amount 1;
        Inventory.AltHUDIcon "DEGTA0";
        FloatBobStrength 0.5;
        Scale 0.44;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.PickupSound "weapons/pistolup";
        Inventory.Pickupmessage "$PB_PISTOL_PICKUP";
        Obituary "%o was shot down by %k's Pistol";
        AttackSound "None";
        Tag "$PB_PISTOL_TAG";
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.WIMPY_WEAPON;
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    bool pistolLastShotLeft;
    bool hasSilencer;
    bool burstFire;
    int pistolFireAnimation;
    int pistolBurstCount;
    int pistolBurstCountLeft;
    // Overlays
    const LEFTMUZZLEFLASH   = -5;
    const RIGHTMUZZLEFLASH  = -6;
	const MAGAZINE_SIZE = 16; // You only need to change this value to modify the pistol ammo lol
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

    // I added the useMag so its easier to turn it into a generic function
    // This thing is pretty inconsistent but I dont know if theres any other way
	action state PB_DualRefire(bool isLeft, bool useMag = true)
    {
        // Get the CVAR and weapon side
        int firemode = Cvar.GetCvar("SingleDualFire", player).GetInt();
        bool isFiring = isLeft ? A_IsFiringLeftWeapon() : A_IsFiringRightWeapon();
        
        // Separates the input based on the mode
        bool inputPressed = false;
        // Mode 0: Single Button
        if (firemode == 0)
        {
            bool shouldFire = (isLeft && !invoker.pistolLastShotLeft) || (!isLeft && invoker.pistolLastShotLeft);
            inputPressed = JustPressed(BT_ATTACK) && shouldFire;
        }
        // Mode 1: Default (Primary fire: Fire left weapon, Alt-fire: Fire right weapon)
        else if (firemode == 1)
        {
            int fireButton = isLeft ? BT_ATTACK : BT_ALTATTACK;
            inputPressed = JustPressed(fireButton);
        }
        // Mode 2: Inverted (Primary fire: Fire right weapon, Alt-fire: Fire left weapon)
        else if (firemode == 2)
        {
            int fireButton = isLeft ? BT_ALTATTACK : BT_ATTACK;
            inputPressed = JustPressed(fireButton);
        }

        // Actually do the Refire
        if (inputPressed && !isFiring)
        {
			int ammoCount = 0;
			// Checks if the weapon uses a mag (just in case)
			if(useMag) ammoCount = isLeft ? invoker.ammoleft.amount : invoker.ammo2.amount;
			else ammoCount = invoker.ammo1.amount;
			// Checks if the weapon has the mag unloaded, this is skipped if the weapon doesnt use a mag
            bool magUnloaded = isLeft ? PB_GetMagUnloaded(true) : PB_GetMagUnloaded();

            if (ammoCount > 0 && !magUnloaded && useMag || ammoCount > 0 && !useMag)
            {
                if(isLeft) return ResolveState("FireLeft_Overlay");
                else return ResolveState("FireRight_Overlay");
            }
            A_PlaySoundEx("weapons/empty", "Auto");
        }
        return ResolveState(null);
    }

    // Normal / ADS Fire
    action void Pistol_Fire(int tic)
    {
        // Set up Variables
        bool burst          = getBurstFire();
        bool ads            = PB_GetZoom();
        bool silenced       = getSilencer();
        int  heat           = burst ? 3 : 1;
        double recoilX      = burst ? (ads ? -0.44 : -0.54) : -0.18;
        double recoilY      = burst ? -0.24 : -0.08;
        double zoomA        = ads ? 1.24  : 0.985;
        double zoomB        = ads ? 1.245 : 0.99;
        double zoomC        = ads ? 1.25  : 1.0;
        double smokeZ       = ads ? 0.0   : 1.6;
        int    xOfs         = ads ? 22  : 26;
        int    vertOfs      = ads ? 40  : 32;
        name silSprite      = ads ? "D8GG" : "D3GF";
        name idleSprite     = ads ? "D8GG" : "D3GG";
        string sound        = silenced ? "weapons/suppressedpistol" : "weapons/firepistol";
        string dynamicTail  = silenced ? "pistol_sup" : "pistol";

        switch(tic)
        {
            case 1:
                // Start
                if(!ads) A_OverlayOffset(PSP_WEAPON, 0, 33.5);
                PB_IncrementHeat(heat);
                PB_FireOffset(); // I'll just make it so fireoffset is always called

                // Sets up muzzle flash
                if(ads) A_Overlay(LEFTMUZZLEFLASH, "GunFlash2", true);
                else    A_Overlay(LEFTMUZZLEFLASH, "GunFlash", true);
                
                A_OverlayFlags(LEFTMUZZLEFLASH, PSPF_RENDERSTYLE, true);
                A_OverlayRenderStyle(LEFTMUZZLEFLASH, STYLE_Add);

                // Condition based Effects
                if(silenced) {
                    setSilencerSprites(silSprite);
                }
                else {
                    A_AlertMonsters();
                    PB_GunSmoke(0, 0, smokeZ);
                    PB_MuzzleFlashEffects(0, 0, smokeZ);
                    if(!ads) A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
                }
                
                invoker.pistolBurstCount++;

                // Fire Bullet + Take Ammo + More Effects
                A_StartSound(sound, CHAN_Weapon, CHANF_DEFAULT, 1.0);
                PB_FireBullets("PB_45ACPHP", 1, 0.1, 0, 0, 0.1);
                PB_DynamicTail(dynamicTail,dynamicTail); // Inside tail and Outside tail are the same for the pistol
                A_ZoomFactor(zoomA);
                PB_LowAmmoSoundWarning("pistol");
                PB_TakeAmmo(invoker.ammo2.getClassName(), 1);
                PB_SpawnCasing("EmptyBrassPistol", xOfs, -2, vertOfs, frandom(-2,2), -frandom(2,5), frandom(3,6), true, true);
                PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 2:
                if(!ads) A_OverlayOffset(PSP_WEAPON, 0, 33.6, WOF_INTERPOLATE);
                setSilencerSprites(silSprite);
                A_ZoomFactor(zoomB);
                PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 3:
                if(!ads) A_OverlayOffset(PSP_WEAPON, 0, 32.5, WOF_INTERPOLATE);
                setSilencerSprites(silSprite);
                A_ZoomFactor(zoomC);
                if(!burst) PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 4: case 5:
                if(!ads) A_OverlayOffset(PSP_WEAPON, 0, 32, WOF_INTERPOLATE);
                setSilencerSprites(tic == 4 ? silSprite : idleSprite);
                break;

        }
    }

    // Dual Wield Fire
    action void Pistol_FireOverlay(int tic, bool isLeft)
    {
        bool burst          = getBurstFire();
        bool silenced       = getSilencer();
        int  heat           = burst ? 3 : 1;
        double recoilX      = burst ? -0.6  : -0.24;
        double recoilY      = isLeft ? (burst ? +0.8 : +0.6) : (burst ? -0.8 : -0.6);
        double smokeOfs     = isLeft ?  6  : -6;
        double vertOfs      = isLeft ? -16 :  9;
        int    flashLayer   = isLeft ? LEFTMUZZLEFLASH : RIGHTMUZZLEFLASH;
        string ammoClass    = isLeft ? invoker.ammoleft.getClassName() : invoker.ammo2.getClassName();
        string sound        = silenced ? "weapons/suppressedpistol" : "weapons/firepistol";
        string dynamicTail  = silenced ? "pistol_sup" : "pistol";

        switch(tic)
        {
            case 1:
                // Sets up Overlays
                if(isLeft) A_Overlay(flashLayer, "LeftFlash", true);
                else       A_Overlay(flashLayer, "RightFlash", true);
                A_OverlayFlags(flashLayer, PSPF_RENDERSTYLE, true);
                A_OverlayRenderStyle(flashLayer, STYLE_Add);

                // Shoot + Effects
                PB_IncrementHeat(heat, isLeft);
                PB_FireBullets("PB_45ACPHP", 1, 0.1, 0, 0, 0.1);
                PB_SpawnCasing("EmptyBrassPistol", 26, vertOfs, 38, frandom(-2,2), -frandom(2,5), frandom(3,6), true, true);
                A_StartSound(sound, CHAN_Weapon, CHANF_DEFAULT, 1.0);
                PB_DynamicTail(dynamicTail,dynamicTail); // Inside tail and Outside tail are the same for the pistol
                A_ZoomFactor(0.985);
                PB_WeaponRecoil(recoilX, recoilY);
                setFireAnimation(isLeft ? 2 : 1);

                // Everything Else
                if(isLeft) {
                    invoker.pistolLastShotLeft = true;
                    invoker.pistolBurstCountLeft++;
                    PB_LowAmmoSoundWarning("pistol", ammoClass);
                    PB_TakeAmmo(ammoClass, 1, 1, 0, true);
                    A_SetFiringLeftWeapon(true);
                }
                else {
                    invoker.pistolLastShotLeft = false;
                    invoker.pistolBurstCount++;
                    PB_LowAmmoSoundWarning("pistol");
                    PB_TakeAmmo(ammoClass, 1);
                    A_SetFiringRightWeapon(true);
                }
                if(silenced) {
                    if(isLeft) setSilencerSprites(silencedLeft: "DL3F");
                    else       setSilencerSprites(silencedRight: "DR3F");
                }
                else {
                    A_AlertMonsters();
                    PB_GunSmoke(smokeOfs, 0, 1.6);
                    PB_MuzzleFlashEffects(smokeOfs, 0, 1.6);
                }
                break;

            case 2: case 3:
                if(tic == 2) A_ZoomFactor(1.0);
                if(isLeft) setSilencerSprites(silencedLeft: "DL3F");
                else       setSilencerSprites(silencedRight: "DR3F");
                PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 4: // DualFiring flag + clear firing state
                if(isLeft)
                {
                    setSilencerSprites(silencedLeft: "DL3F");
                    if(invoker.ammoleft.amount <= 0 || invoker.ammo2.amount > 0)
                        A_GiveInventory("DualFiring", 1);
                    A_SetFiringLeftWeapon(false);
                }
                else
                {
                    setSilencerSprites(silencedRight: "DR3F");
                    if(invoker.ammoleft.amount > 0 || invoker.ammo2.amount <= 0)
                        A_TakeInventory("DualFiring", 1);
                    A_SetFiringRightWeapon(false);
                }
                break;

            case 5: // DualFireReload check, reset burst
                setBurstCount(0, isLeft ? true : false);
                if(isLeft && invoker.ammo2.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                else if(!isLeft && invoker.ammoleft.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                break;
        }
    }

    // Sets the Flash State Sprites
    action void Pistol_SetMeleeSprite(name silencedSprite, name normalSprite)
    {
        let psp = player.FindPSprite(PSP_WEAPON);
        if (!psp) return;

        if (getSilencer()) psp.sprite = GetSpriteIndex(silencedSprite);
        else psp.sprite = GetSpriteIndex(normalSprite);
    }

    // Handles weapon special
    action state Pistol_WeaponSpecial()
    {
        A_SetInventory("PB_LockScreenTilt", 1);
        A_SetInventory("GoWeaponSpecialAbility", 0);
        PB_SetZoom(false);
        PB_HandleCrosshair(43);
        A_ZoomFactor(1.0);
        PB_ClearDualWield();
        A_PlaySoundEx("Ironsights", "Auto");

        bool selectSuppressor = CountInv("SelectPistolSuppressor") > 0;
        bool selectBurstFire  = CountInv("SelectPistolBurstFire")  > 0;
        bool selectDualWield  = CountInv("SelectDualWieldPistols") > 0;
    
        // Check Dual Wield
        if (selectDualWield)
        {
            clearTokens();
            if (A_CheckAkimbo())     return ResolveState("StopDualWield");
            if (invoker.amount >= 2) return ResolveState("SwitchToDualWield");

            A_Print("$PB_PISTOL_NOAKIMBO");
            return ResolveState("Ready3");
        } 

        // Check Suppressor/Burst Fire
        if (selectSuppressor || selectBurstFire)
        {
            A_WeaponOffset(0, 32);
            PB_SetRoll(0);
            A_SetInventory("PB_LockScreenTilt", 0);
        }

        // Check Suppressor
        if (selectSuppressor)
        {
            clearTokens();
            if (getSilencer())
            {
                A_Print("$PB_PISTOL_SUPPRESSOFF");
                setSilencer(false);
                return ResolveState("DetachSilencer");
            }

            A_Print("$PB_PISTOL_SUPPRESSON");
            setSilencer(true);
            return ResolveState("AttachSilencer");
        } 

        // Check Burst Fire
        if (selectBurstFire)
        {
            clearTokens();
            invoker.burstFire = !invoker.burstFire;
            A_Print(getBurstFire() ? "$PB_FIREMODE_BURST" : "$PB_FIREMODE_SEMI");
            if (A_CheckAkimbo()) return ResolveState("DualToggle");
            else return ResolveState("SingleToggle");
        }   
        return ResolveState(null);
    }

    action void clearTokens()
    {
        A_SetInventory("SelectPistolSuppressor",0);
        A_SetInventory("SelectDualWieldPistols",0);
        A_SetInventory("SelectPistolBurstFire",0);
    }

    // I should probably use A_SetWeaponSprite for these but oh well
    action void setSilencerSprites(
        name silenced       = '',
        name silencedLeft   = '', 
        name silencedRight  = '', 
        int leftLayer       = PSP_LEFTGUN,
        int rightLayer      = PSP_RIGHTGUN,
        int layer           = PSP_WEAPON)
    {
        if (!getSilencer()) return;

        let psp = player.FindPSprite(layer);
        if (psp && silenced != '') 
        {
            psp.sprite = GetSpriteIndex(silenced);
            return;
        }

        if(A_CheckAkimbo())
        {
            if(silencedLeft != '') {
                let pspLeft = player.FindPSprite(leftLayer);
                if(pspLeft) pspLeft.sprite = GetSpriteIndex(silencedLeft);
                return;
            }
            if(silencedRight != '') {
                let pspRight = player.FindPSprite(rightLayer);
                if(pspRight) pspRight.sprite = GetSpriteIndex(silencedRight);
                return;
            }
        }
    }

    // Auxilliary Functions

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

    action void setFireAnimation(bool set)
    {
        invoker.pistolFireAnimation = set;
    }

    action bool getFireAnimation()
    {
        return invoker.pistolFireAnimation;
    }

    action void setBurstCount(int set, bool isLeft = false)
    {
        if(!isLeft) invoker.pistolBurstCount  = set;
        else        invoker.pistolBurstCountLeft = set;
    }

    action int getBurstCount(bool isLeft = false)
    {
        if(!isLeft) return invoker.pistolBurstCount;
        else        return invoker.pistolBurstCountLeft;
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        CacheSprites:
        // I gave up lol
        D2LF ABCDE 0;
        DL3F ABCDE 0;
        D2RF ABCDE 0;
        DR3F ABCDE 0;
        D2GL A 0;
        D2GR A 0;
        D33L A 0;
        D33R A 0;
        D2GG A 0;
        D2GS ABCDEFGHIJKLM 0;
        D2GT ABCDEFGHIJKLM 0;
        D6GC ABCDEFGHIJKLMN 0;              // Attach Suppressor Dual Wield (This is unused?)
        D6GG ABCDEFGHIJKLMN 0;              // Kicking Dual Wield
        D6GH ABCDEFGHIJKLMN 0;              // Kicking Dual Wield Suppressor
        // Reload Dual Wield
        D6GW ABCDEFGHIJKLMNOPQRSTUVWZ 0;    // Eject Left
        D6GX ABCDEFGHIJKLMNOPZ 0;           // Eject Right
        D6GA ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;  // Reload Dual Wield
        D6GB ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;  // Reload Dual Wield
        // Reload Suppressor Dual Wield
        D6GY ABCDEFGHIJKLMNOPQRSTUVWZ 0;    // Eject Left
        D6GZ ABCDEFGHIJKLMNOPZ 0;           // Eject Right
        D6GE ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;  // Reload Suppressor Dual Wield
        D6GF ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;  // Reload Suppressor Dual Wield
        D6GD ABCDEFGHIJKLMNO 0;             // Remove Silencer Dual Wield (This is also unused)
        D6GI ABCDEFGHIJKLMNOPQRSTUVWZ 0;    // Slide Dual Wield
        D6GJ ABCDEFGHIJKLMNOPQRSTUVWZ 0;    // Slide Suppressor Dual Wield


        Spawn:
            VEGT A 0 NoDelay;
            DEGT A 10 A_PbvpFramework("VEGT");
            "####" A 0 A_PbvpInterpolate();
            Loop;

        WeaponRespect:
            TNT1 A 0 {
                A_SetInventory("PB_LockScreenTilt",1);
                A_PlaySoundEx("weapons/smg_magfly1", "Auto");
                A_SetCrosshair(-1);
            }
            D0G0 ABCDEFGHIJK 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            D0G0 LMNOPQRST 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            TNT1 A 0 A_PlaySoundEx("PSRLFIN", "Auto");
            D0G0 UVWXYZ 1 {
                PB_SetRoll(roll+0.5);
                A_DoPBWeaponAction();
            }
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            D0G1 ABCDE 1 {
                PB_SetRoll(roll-0.6);
                A_DoPBWeaponAction();
            }
            Goto Ready3;

        Deselect:
                TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
                PB_ClearDualWield();
                PB_SetZoom(false);
            }		
            
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldDeselect");
        NormalDeselect:
            DEGG BCDE 1	setSilencerSprites("D3GG");
            Goto FinishDeselect;

        DualWieldDeselect:
            DEGG DCBA 1 setSilencerSprites("D2GT");
        FinishDeselect:
            TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
            Wait;

        SelectAnimationDualWield:
            D2GT ABCD 0;
            D2GS ABCD 1 setSilencerSprites("D2GT");
            TNT1 A 0 A_PlaySoundEx("weapons/pistolup", "Auto");
            Goto ReadyDualWield;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
                PB_ClearDualWield();
			    PB_HandleCrosshair(43);
                PB_SelectIfUpgrade("PB_SMG");
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeapTokenSwitch("HandgunSelected");
                PB_WeaponRaise("weapons/pistolup");
                invoker.pistolBurstCount = 0;
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            TNT1 A 0 PB_SetZoom(false);
		    TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
			DEGG E 1 setSilencerSprites("D3GG");
            DEGG DCB 1 setSilencerSprites("D3GG");
        // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        // Ready Normal
		Ready3:
            // Cache Sprites
            D3GG ABCDE 0;
            // Actual Ready
            TNT1 A 0 {
				PB_SetRoll(0);
			    PB_HandleCrosshair(43);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "Ready2");
        ReadyToFire:
		    TNT1 A 0 PB_SelectIfUpgrade("PB_SMG");
            DEGG A 1 {
                setSilencerSprites("D3GG");
                if(!getSilencer()) PB_CoolDownBarrel(0, 0, 2);
                return PB_ReadyFire();
            }
			Loop;

        // Ready Empty
        NoAmmo:
            "####" "#" 1;
            Goto Ready3;

        // Ready ADS
        Ready2:
			TNT1 A 0 {
				PB_SetRoll(0);
				A_SetCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:
            TNT1 A 0 PB_SelectIfUpgrade("PB_SMG");
            D7GG F 1 {
                PB_CoolDownBarrel(0, 0, 6);
                return PB_ReadyFire(ads:true);
            }
            Loop;

        // Ready Dual Wield
        ReadyDualWield:
            // Cache Sprites
            D33L A 0;
            D33R A 0;
            DR3F ABCDE 0;
            DL3F ABCDE 0;
            // Actual Ready Dual Wield
			TNT1 A 0 PB_SetupDualWield(crosshair:43);
        ReadyToFireDualWield:
            TNT1 A 0 PB_SelectIfUpgrade("PB_SMG");
			TNT1 A 1 A_DoPBDualAction();
            Loop;

        IdleLeft_Overlay:
            // Cache Sprites
            D2GT ABCDEFGHIJKLM 0;
            D33R ABCDEFGHIJKLM 0;
            // Actual Ready Dual Wield
            D2GL A 1 {
                setSilencerSprites(silencedLeft:"D33L");
                if(!getSilencer()) PB_CoolDownBarrel(14, 0, 3.2);
                return A_DoPBLeftAction();
            }
            Loop;

		IdleRight_Overlay:
            D2GR A 1 {
                setSilencerSprites(silencedRight:"D33R");
                if(!getSilencer()) PB_CoolDownBarrel(-14, 0, 3.2);
				return A_DoPBRightAction();
            }
            Loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
            // Cache Sprites
            D3GF ABCD 0;
            // Actual Fire
            TNT1 A 0 A_JumpIf(PB_GetZoom(), "Fire2");
            TNT1 A 0 {
                A_WeaponOffset(0, 32);
                PB_SetRoll(0);
                PB_HandleCrosshair(43);
                A_SetInventory("PB_LockScreenTilt", 0);
            }
            TNT1 A 0 setBurstCount(0);
        FireBurst:
            TNT1 A 0 PB_JumpIfNoAmmo();
            DEGF A 1 BRIGHT Pistol_Fire(1);
            DEGF D 1        Pistol_Fire(2);
            DEGF B 1        Pistol_Fire(3);
		    TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurstFire() && !PB_GetChamberEmpty(), "FireBurst");
            DEGF D 1 {
                setBurstCount(0);
                Pistol_Fire(4);
                if(JustPressed(BT_ATTACK)) return ResolveState("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOPRIMARY);
            }
            DEGG AAAAAAAA 1 {
                Pistol_Fire(5);
                if(JustPressed(BT_ATTACK)) return ResolveState("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOPRIMARY);
            }
            Goto ReadyToFire;

        Fire2:
            TNT1 A 0 {
                A_WeaponOffset(0, 32);
                A_SetCrosshair(-1);
            }
        FireBurst2:
            TNT1 A 0 PB_JumpIfNoAmmo();
            D7GG G 1 BRIGHT Pistol_Fire(1);
            D7GG H 1        Pistol_Fire(2);
		    TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurstFire() && !PB_GetChamberEmpty(), "FireBurst2");
            D7GG I 1 {
                Pistol_Fire(3);
                setBurstCount(0);
                if(JustPressed(BT_ATTACK)) return ResolveState("Fire2");
                return ResolveState(null);
            }
            D7GG JKLFFFFFF 1 {
                if(JustPressed(BT_ATTACK)) return ResolveState("Fire2");
                return ResolveState(null);
            }
            Goto Ready2;

        FireRight_Overlay:
            TNT1 A 0 setBurstCount(0);
        BurstRight_Overlay:
            D2RF A 1 BRIGHT Pistol_FireOverlay(1, false);
            D2RF B 1 BRIGHT Pistol_FireOverlay(2, false);
            D2RF C 1        Pistol_FireOverlay(3, false);
            D2RF D 1        Pistol_FireOverlay(4, false);
		    TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurstFire() && !PB_GetChamberEmpty(), "BurstRight_Overlay");
            D2GR AAAAA 1 {
                setSilencerSprites(silencedRight: "D33R");
                return PB_DualRefire(false);
            }
            TNT1 A 0  Pistol_FireOverlay(5, false);
            D2GR AA 1 setSilencerSprites(silencedRight: "D33R");
            Goto IdleRight_Overlay;

        FireLeft_Overlay:
            TNT1 A 0 setBurstCount(0,true);
        BurstLeft_Overlay:
            D2LF A 1 BRIGHT Pistol_FireOverlay(1, true);
            D2LF B 1 BRIGHT Pistol_FireOverlay(2, true);
            D2LF C 1        Pistol_FireOverlay(3, true);
            D2LF D 1        Pistol_FireOverlay(4, true);
		    TNT1 A 0 A_JumpIf(getBurstCount(true) < 3 && getBurstFire() && !PB_GetChamberEmpty(true), "BurstLeft_Overlay");
            D2GL AAAAA 1 {
                setSilencerSprites(silencedLeft:"D33L");
                return PB_DualRefire(true);
            }
            D2GL AA 1 setSilencerSprites(silencedLeft:"D33L");
            TNT1 A 0  Pistol_FireOverlay(5, true);
            Goto IdleLeft_Overlay;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
            // Cache Sprites
            D8GG ABC 0;
            // Actual AltFire
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_SetCrosshair(-1);
                A_SetInventory("PB_LockScreenTilt",0);
            }
        ZoomIn:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyToFireDualWield");
            TNT1 A 0 A_StartSound("IronSights", 0);
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Zoomout");
            TNT1 A 0 A_ZoomFactor(1.25);
            D7GG BCD 1 setSilencerSprites("D8GG");
            D7GG EF 1;
            TNT1 A 0 PB_SetZoom(true);
            Goto Ready2;

        Zoomout:
            TNT1 A 0 {	
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
            }
            D7GG FED 1;
            D7GG CB 1 setSilencerSprites("D8GG");
            TNT1 A 0 PB_HandleCrosshair(43);
            Goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
            TNT1 A 0 Pistol_WeaponSpecial();
            Goto Ready3;

        SwitchToDualWield:
            D2GS FG 1 {
                setSilencerSprites("D2GT");
                PB_SetRoll(roll+.5);
            }
            D2GS HI 1 {
                setSilencerSprites("D2GT");
                PB_SetRoll(roll-.5);
            }
            TNT1 A 0 A_SetAkimbo(true);
            Goto ReadyDualWield;

        StopDualWield:
            D2GS JK 1 {
                setSilencerSprites("D2GT");
                PB_SetRoll(roll-0.2);
            }
            D2GS LM 1 {
                setSilencerSprites("D2GT");
                PB_SetRoll(roll+0.2);
            }
            TNT1 A 0 A_SetAkimbo(false);
            Goto Ready3;

        AttachSilencer:
            D5GA ABCDEFFFGHIJKLM 1 PB_SetRoll(roll+.2);
            TNT1 A 0 A_PlaySoundEx("weapons/pistolsuppressor_on", "Auto");
            D5GA NNNOPOPOQRRRSSS 1 PB_SetRoll(roll-.2);
            TNT1 A 0 A_PlaySoundEx("weapons/pistolup", "Auto");
            D5GA TUV 1;
            TNT1 A 0 PB_SetRoll(0);
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
            D5GA WXY 1;
            Goto Ready3;

        DetachSilencer:
            D5GF ABCDEFG 1 PB_SetRoll(roll+.2);
            TNT1 A 0 A_PlaySoundEx("weapons/pistolsuppressor_off", "Auto");
            D5GF FHIJJKKLLMMNOP 1 PB_SetRoll(roll-.1);
            D5GF QRSTUUU 1;
            TNT1 A 0 A_PlaySoundEx("weapons/pistolup", "Auto");
            D5GF VWX 1;
            TNT1 A 0 PB_SetRoll(0);
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
            D5GF YZ 1;
            D5GG AB 1;
            Goto Ready3;

        SingleToggle:
            D5GE AB 0;
            D5GD ZYXWVU 0;
            D5GC BA 1 setSilencerSprites("D5GE");
            D5GB ZYXWWVV 1 setSilencerSprites("D5GD");
            TNT1 A 0 A_PlaySoundEx("LIGHTON", "Auto");
            D5GB WWXYZ 1 setSilencerSprites("D5GD");
            Goto Ready3;

        DualToggle:
            D2GT ABCDE 0;
            D2GS EDCBB 1 setSilencerSprites("D2GT");
            TNT1 A 0 A_PlaySoundEx("LIGHTON", "Auto");
            D2GS BBCDE 1 setSilencerSprites("D2GT");
            TNT1 A 0 A_PlaySoundEx("LIGHTON", "Auto");
            Goto Ready3;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
            Reload:
                TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
                TNT1 A 0 PB_CheckReload(null,null,"LoadChamber","Ready3","Ready3",MAGAZINE_SIZE);
                D5GD ABCDEFGHIJKLMNOPQRSTUVWXY 0;
                D5GB ABCD 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll+.8);
                }
                D5GB EF 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.5);
                }
                TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ReloadFromEmpty");
                D5GB GH 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.5);
                }
                TNT1 A 0 {
                    if(PB_GetMagEmpty()) PB_SpawnCasing("EmptyPistolMag",30,26,20,1,5,-2,false);
                    PB_SetMagUnloaded(true);
                    A_PlaySoundEx("PSRLOUT", "Auto");
                }
                D5GB IIJ 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.5);
                }
                D5GB KKL 1 setSilencerSprites("D5GD");
                D5GB MNO 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.1);
                }
            ReloadFromEmpty:
                D5GB PQQRS 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.1);
                }
                TNT1 A 0 {
                    PB_AmmoIntoMag(
                        invoker.ammo2.getClassName(),
                        invoker.ammo1.getClassName(),
                        PB_GetChamberEmpty() ? MAGAZINE_SIZE-1 : MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                    A_PlaySoundEx("PSRLIN", "Auto");
                }
                D5GB TUVWX 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll+0.2);
                }
                D5GB YZ 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(0);
                }
                TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"LoadChamber");
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

            LoadChamber:
                TNT1 A 0 A_PlaySoundEx("PSRLFIN", "Auto");
                D5GE CDEFGHIJKLMNOPQ 0;
                D5GC CDEF 1 {
                    setSilencerSprites("D5GE");
                    PB_SetRoll(roll+.6);
                }
                TNT1 A 0 PB_SetChamberEmpty(false);
                D5GC GGHH 1 {
                    setSilencerSprites("D5GE");
                    PB_SetRoll(roll+.6);
                }
                D5GC I 1 setSilencerSprites("D5GE");
                D5GC JKLMNOPQ 1 {
                    setSilencerSprites("D5GE");
                    PB_SetRoll(roll-.6);
                }
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

            ReloadDualWield:
                // Cache Sprites
                D6GE ABCDEFGHIJKLMNOPQRSTUVWXY 0;
                D6GF ABCDEFGHIJKLMNOPQRSTUVW 0;
                // Actual Reload Dual Wield
                TNT1 A 0 PB_ClearDualWield();
                TNT1 A 0 PB_CheckReload(null,null,null,"ReloadLeftOnly","Ready3",MAGAZINE_SIZE);
                TNT1 A 0 A_JumpIf(invoker.ammoleft.amount >= MAGAZINE_SIZE, "ReloadRightOnly"); // If left weapon is full
                TNT1 A 0 A_JumpIf(invoker.ammo1.amount < 1, "NoAmmo");
                TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() || PB_GetMagUnloaded(true),"ReloadDualWieldUnloaded");
                TNT1 A 0 A_PlaySoundEx("PSRLOUT", "Auto");
                D6GA A 1 setSilencerSprites("D6GE");
                TNT1 A 0 A_PlaySoundEx("PSRLOUT", "Auto");
                D6GA BCDE 1 setSilencerSprites("D6GE");
                TNT1 A 0 {
                    if (PB_GetMagEmpty()) PB_SpawnCasing("EmptyPistolMag",30,12,16,1,-2,-2,false);
                    if (PB_GetMagEmpty(true)) PB_SpawnCasing("EmptyPistolMag",30,-12,16,1,2,-2,false);
                    PB_SetMagUnloaded(true);
                    PB_SetMagUnloaded(true,true);
                }
                D6GA FGHI 1 setSilencerSprites("D6GE");
                D6GA J 1 {
                    if (getSilencer()) {
                        A_SetWeaponSprite("D6GE");
                        if(!PB_GetMagEmpty() || !PB_GetMagEmpty(true)) {
                            A_SetWeaponSprite("D6GF");
                            A_SetWeaponFrame(25);
                        }
                        if(PB_GetMagEmpty(true) && !PB_GetMagEmpty())
                            A_SetWeaponFrame(24);
                        if(PB_GetMagEmpty() && !PB_GetMagEmpty(true))
                            A_SetWeaponFrame(23);
                    }
                    else {
                        if(!PB_GetMagEmpty() || !PB_GetMagEmpty(true)) {
                            A_SetWeaponSprite("D6GB");
                            A_SetWeaponFrame(25);
                        }
                        if(PB_GetMagEmpty(true) && !PB_GetMagEmpty())
                            A_SetWeaponFrame(24);
                        if(PB_GetMagEmpty() && !PB_GetMagEmpty(true))
                            A_SetWeaponFrame(23);
                    }
                }
            Goto ReloadDualWieldUnloaded;

            ReloadLeftOnly:
                // Cache Sprites
                D6GY ABCDEFGHIJKLMZ 0;
                // Actual Reload Left Only
                TNT1 A 0 PB_CheckReload(null,null,null,"ReloadRightOnly","Ready3",MAGAZINE_SIZE,invoker.reservetomagammofactor,true);
                TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true) && !PB_GetMagUnloaded(),"ReloadLeftOnlyUnloaded");
                TNT1 A 0 A_PlaySoundEx("PSRLOUT", "Auto");
                D6GW ABCDE 1 setSilencerSprites("D6GY");
                TNT1 A 0 {
                    if (PB_GetMagEmpty(true)) PB_SpawnCasing("EmptyPistolMag",30,-12,16,1,2,-2,false);
                    PB_SetMagUnloaded(true,true);
                }
                D6GW FGHI 1 setSilencerSprites("D6GY");
                D6GW Z 0;
                D6GW J 1 {
                    setSilencerSprites("D6GY");
                    if(!PB_GetMagEmpty(true))
                        A_SetWeaponFrame(25);
                }
                D6GW K 1 setSilencerSprites("D6GY");
                D6GW LM 1 {
                    setSilencerSprites("D6GY");
                    PB_SetRoll(roll+.5);
                }
                Goto ReloadLeftConted;

            ReloadRightOnly:
                // Cache Sprites
                D6GZ ABCDEFGHIJKLMNOPZ 0;
                // Actual Reload Right Only
                TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ReloadRightOnlyUnloaded");
                TNT1 A 0 A_PlaySoundEx("PSRLOUT", "Auto");
                D6GX ABCDE 1 setSilencerSprites("D6GZ");
                TNT1 A 0 {
                    if (PB_GetMagEmpty()) PB_SpawnCasing("EmptyPistolMag",30,12,16,1,-2,-2,false);
                    PB_SetMagUnloaded(true);
                }
                D6GX FGHI 1 setSilencerSprites("D6GZ");
                D6GX Z 0;
                D6GX J 1 {
                    setSilencerSprites("D6GZ");
                    if(!PB_GetMagEmpty()) A_SetWeaponFrame(25);
                }
            ReloadRightOnlyUnloaded:
                D6GX K 1 setSilencerSprites("D6GZ");
                D6GX LM 1 {
                    setSilencerSprites("D6GZ");
                    PB_SetRoll(roll+.5);
                }
                D6GX NOP 1 {
                    setSilencerSprites("D6GZ");
                    PB_SetRoll(roll+.5);
                }
                Goto ReloadRightConted;

            FinishReloadLeftOnly:
                D6GW NOPQRSTUVW 1 setSilencerSprites("D6GY");
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

            ReloadDualWieldUnloaded:
                D6GA K 1 setSilencerSprites("D6GE");
                D6GA LM 1 {
                    setSilencerSprites("D6GE");
                    PB_SetRoll(roll+.5);
                }
                Goto ReloadLeftConted;

            ReloadLeftOnlyUnloaded:
                D6GW WVUTSRQP 1 setSilencerSprites("D6GY");
            ReloadLeftConted:
                D6GA NOPQRS 1 {
                    setSilencerSprites("D6GE");
                    PB_SetRoll(roll+.5);
                }
                TNT1 A 0 A_PlaySoundEx("PSRLIN", "Auto");
                D6GA STTU 1 {
                    setSilencerSprites("D6GE");
                    PB_SetRoll(roll-.5);
                }
                TNT1 A 0 {
                    if(PB_GetChamberEmpty(true)) A_PlaySoundEx("PSRLFIN", "Auto");
                    PB_AmmoIntoMag(
                        invoker.ammoleft.getClassName(),
                        invoker.ammo1.getClassName(),
                        PB_GetChamberEmpty(true) ? MAGAZINE_SIZE-1 : MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false,true);
                    PB_SetMagEmpty(false,true);
                    PB_SetChamberEmpty(false,true);
                }
            ReloadDualWieldFromEmptyRight:	
                D6GA VV 1 {
                    setSilencerSprites("D6GE");
                    PB_SetRoll(roll-.5);
                }
                D6GA W 1 setSilencerSprites("D6GE");
                TNT1 A 0 A_JumpIf(invoker.ammo2.amount >= 16,"FinishReloadLeftOnly");
                D6GA XYZ 1 setSilencerSprites("D6GE");
                TNT1 A 1;
                D6GB ABCDE 1 {
                    setSilencerSprites("D6GF");
                    PB_SetRoll(roll+.5);
                }
            ReloadRightConted:
                D6GB FGH 1 {
                    setSilencerSprites("D6GF");
                    PB_SetRoll(roll+.5);
                }
                TNT1 A 0 A_PlaySoundEx("PSRLIN", "Auto");
                D6GB IIJJKK 1 {
                    setSilencerSprites("D6GF");
                    PB_SetRoll(roll-.5);
                }
                TNT1 A 0 A_JumpIf(invoker.ammo2.amount >= 1,2);
                TNT1 A 0 A_PlaySoundEx("PSRLFIN", "Auto");
                TNT1 A 0 {
                    PB_AmmoIntoMag(
                        invoker.ammo2.getClassName(),
                        invoker.ammo1.getClassName(),
                        PB_GetChamberEmpty() ? MAGAZINE_SIZE-1 : MAGAZINE_SIZE);
                    PB_SetMagUnloaded(false);
                    PB_SetMagEmpty(false);
                    PB_SetChamberEmpty(false);
                }
                D6GB LLMNOPQRSTUVW 1 setSilencerSprites("D6GF");
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
            Unload:
                TNT1 A 0 PB_SetReloading(true);
                TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(),"Unchamber");
                TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "UnloadDualWield");
                D5GB ABCD 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll+.8);
                }
                D5GB EF 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.5);
                }
                D5GB GH 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.5);
                }
                TNT1 A 0 {
                    if(PB_GetMagEmpty())
                        PB_SpawnCasing("EmptyPistolMag",30,26,20,1,5,-2,false);
                    PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),1,1,0,1);
                    PB_SetMagUnloaded(true);
                    PB_SetMagEmpty(true);
                    A_PlaySoundEx("PSRLOUT", "Auto");
                }
                D5GB IIJ 1 {
                    setSilencerSprites("D5GD");
                    PB_SetRoll(roll-.5);
                }
                D5GB KKLDCBA 1 setSilencerSprites("D5GD");
            Unchamber:
                TNT1 A 0 A_PlaySoundEx("PSRLFIN", "Auto");
                D5GC CDEF 1 {
                    setSilencerSprites("D5GE");
                    PB_SetRoll(roll+.6);
                }
                TNT1 A 0 {
                    PB_SetChamberEmpty(true);
                    PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),1,1,0,0,"PB_LowCalRound");
                }
                D5GC GGHH 1 {
                    setSilencerSprites("D5GE");
                    PB_SetRoll(roll+.6);
                }
                D5GC I 1 {
                    setSilencerSprites("D5GE");
                }
                D5GC JKLMNOPQ 1 {
                    setSilencerSprites("D5GE");
                    PB_SetRoll(roll-.6);
                }
                TNT1 A 0 PB_SetReloading(false);
                Goto Ready3;
                
            UnloadDualWield:
                TNT1 A 0 {
                    A_SetCrosshair(-1);
                    PB_SetZoom(false);
                    A_ZoomFactor(1.0);
                    A_SetInventory("PB_LockScreenTilt",1);
				    PB_ClearDualWield();
                    A_PlaySoundEx("PSRLOUT", "Auto");
                }
                D6GA ABC 1 setSilencerSprites("D6GE");
                D6GA DEFGHIJCCBA 1 setSilencerSprites("D6GE");
            RemoveBulletsDualWield1:
                TNT1 A 0
                {
                    PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),1,1,0,1);
                    PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),1,1,0,0,"PB_LowCalRound");
                    PB_UnloadMag(invoker.ammoleft.getClassName(),invoker.ammo1.getClassName(),1,1,0,1);
                    PB_UnloadMag(invoker.ammoleft.getClassName(),invoker.ammo1.getClassName(),1,1,0,0,"PB_LowCalRound");
                    PB_SetMagEmpty(true);
                    PB_SetChamberEmpty(true);
                    PB_SetMagUnloaded(true);
                    PB_SetMagEmpty(true,true);
                    PB_SetChamberEmpty(true,true);
                    PB_SetMagUnloaded(true,true);
                }
                Goto ReadyDualWield;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        GunFlash:
            TNT1 A 0 A_JumpIf(getSilencer(),"GunFlashSilenced");
            TNT1 A 0 A_Jump(256, "Flash1", "Flash2", "Flash3", "Flash4", "Flash5", "Flash6", "Flash7", "Flash8");
        Flash1:
            DEGM A 1 Bright A_GunFlash();
            Stop;
        Flash2:
            DEGM B 1 Bright A_GunFlash();
            Stop;
        Flash3:
            DEGM C 1 Bright A_GunFlash();
            Stop;
        Flash4:
            DEGM D 1 Bright A_GunFlash();
            Stop;
        Flash5:
            DEGM E 1 Bright A_GunFlash();
            Stop;
        Flash6:
            DEGM F 1 Bright A_GunFlash();
            Stop;
        Flash7:
            DEGM G 1 Bright A_GunFlash();
            Stop;
        Flash8:
            DEGM H 1 Bright A_GunFlash();
            Stop;
        GunFlashSilenced:
            D3GM A 1 Bright A_GunFlash();
            Stop;
        GunFlash2:
            TNT1 A 0 A_JumpIf(getSilencer(),"GunFlash2Silenced");
            D7GM A 1 Bright A_GunFlash();
            Stop;
        GunFlash2Silenced:
            D8GM A 1 Bright A_GunFlash();
            Stop;
        
        LeftFlash:
            TNT1 A 0 A_JumpIf(getSilencer(),"LeftFlashSilenced");
            TNT1 A 0 A_Jump(256, "LeftFlash1", "LeftFlash2");
        LeftFlash1:
            D2LM A 1 Bright A_GunFlash();
            TNT1 A 0 A_Jump(256, "LeftBigFlash1", "LeftBigFlash2", "LeftBigFlash3");
            Stop;
        LeftFlash2:
            D2LM C 1 Bright A_GunFlash();
            TNT1 A 0 A_Jump(256, "LeftBigFlash1", "LeftBigFlash2", "LeftBigFlash3");
            Stop;
        LeftBigFlash1:
            D2LM B 1 bright A_GunFlash();
            Stop;
        LeftBigFlash2:
            D2LM D 1 bright A_GunFlash();
            Stop;
        LeftBigFlash3:
            D2LM E 1 bright A_GunFlash();
            Stop;
        LeftFlashSilenced:
            DL3M AB 1 Bright A_GunFlash();
            Stop;
        RightFlash:
            TNT1 A 0 A_JumpIf(getSilencer(),"RightFlashSilenced");
            TNT1 A 0 A_Jump(256, "RightFlash1", "RightFlash2");
        RightFlash1:
            D2RM A 1 Bright A_GunFlash();
            TNT1 A 0 A_Jump(256, "RightBigFlash1", "RightBigFlash2", "RightBigFlash3");
            Stop;
        RightFlash2:
            D2RM C 1 Bright A_GunFlash();
            TNT1 A 0 A_Jump(256, "RightBigFlash1", "RightBigFlash2", "RightBigFlash3");
            Stop;
        RightBigFlash1:
            D2RM B 1 bright A_GunFlash();
            Stop;
        RightBigFlash2:
            D2RM D 1 bright A_GunFlash();
            Stop;
        RightBigFlash3:
            D2RM E 1 bright A_GunFlash();
            Stop;
        RightFlashSilenced:
            DR3M AB 1 Bright A_GunFlash();
            Stop;
		
		
		FlashKicking:
        FlashAirKicking:
            // Cache Sprites
            D5GV ABCDEFGHIJKLMN 0;
            D5GU ABCDEFGHIJKLMN 0;
            // Actual Flashes
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashKickingDualWield");
            TNT1 A 0 Pistol_SetMeleeSprite("D5GV", "D5GU");
            "####" ABCDEFGHIJKLMN 1;
            TNT1 A 0 Pistol_SetMeleeSprite("D3GG", "DEGG");
            "####" AA 1;
            Goto Ready3;
            
        FlashSlideKicking:
            // Cache Sprites
            D5GZ ABCDEFGHIJKKKKLMNOPQRSTUV 0;
            D5GY ABCDEFGHIJKKKKLMNOPQRSTUV 0;
            // Actual Flashes
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingDualWield");
            TNT1 A 0 Pistol_SetMeleeSprite("D5GZ", "D5GY");
            "####" ABCDEFGHIJKKKKLMNOPQRSTUV 1;
            Goto Ready3;
            
        FlashSlideKickingStop:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingDualWieldStop");
            TNT1 A 0 Pistol_SetMeleeSprite("D5GZ", "D5GY");
            "####" WXYZ 1;
            TNT1 A 0 Pistol_SetMeleeSprite("D3GG", "DEGG");
            "####" AAA 1;
            Goto Ready3;
            
        FlashPunching:
            // Cache Sprites
            D5GT ABCDEFGHIJKLMN 0;
            D5GS ABCDEFGHIJKLMN 0;
            // Actual Flashes
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashPunchingDualWield");
            TNT1 A 0 Pistol_SetMeleeSprite("D5GT", "D5GS");
            "####" ABCDEFGHIJKLMN 1;
            Goto Ready3;
            
        FlashPunchingDualWield:
            TNT1 A 15;
            Goto Ready3;
            
        FlashKickingDualWield:
        FlashAirKickingDualWield:
            // Cache Sprites
            D6GH ABCDEFGHIJKLMN 0;
            D6GG ABCDEFGHIJKLMN 0;
            D2GT ABCDEFGHIJKLMN 0;
            D2GS ABCDEFGHIJKLMN 0;
            // Actual Flashes
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 Pistol_SetMeleeSprite("D6GH", "D6GG");
            "####" ABCDEFGHIJKLMN 1;
            TNT1 A 0 Pistol_SetMeleeSprite("D2GT", "D2GS");
            "####" EE 1;
            Goto Ready3;

        FlashSlideKickingDualWield:
            // Cache Sprites
            D6GJ ABCDEFGHIJKLMNOPQRSTUV 0;
            D6GI ABCDEFGHIJKLMNOPQRSTUV 0;
            // Actual Flashes
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 Pistol_SetMeleeSprite("D6GJ", "D6GI");
            "####" ABCDEFGHIJKLMNOPQRSTUV 1;
            Goto Ready3;
            
        FlashSlideKickingDualWieldStop:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 Pistol_SetMeleeSprite("D6GJ", "D6GI");
            "####" WXYZ 1;
            TNT1 A 0 Pistol_SetMeleeSprite("D2GT", "D2GS");
            "####" EEE 1;
            Goto Ready3;

    }
}