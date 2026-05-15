class PB_BFG9000 : PB_Weapon
{
    Default
    {
        //$Category Project Brutality - Weapons
        //$Sprite 097GA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        SpawnID 9800;
        Weapon.AmmoGive1 40;
        PB_WeaponBase.OffsetRecoilX 1.9;
        PB_WeaponBase.OffsetRecoilY 1.6;
        DamageType "Disintegrate";
        Height 20;
        Weapon.SelectionOrder 2800;
        Weapon.AmmoType "PB_Cell";
        Scale .45;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.PickupSound "8FGPICK";
        Inventory.PickupMessage "$PB_BFG_PICKUP";
        Tag "$PB_BFG_TAG";
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +FLOORCLIP;
        +DONTGIB;
    //	+WEAPON.BFG
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    bool blackholeMode;
	//temporal thing for the bfg alt fire, move this to the bfg when/if it gets rewritten in zscript
	// beef: done
    const bfgpartstep = 30;

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    action bool getBlackholeMode()
    {
        return invoker.blackholeMode;
    }

    action void setBlackholeMode(bool set)
    {
        invoker.blackholeMode = set;
    }

    action void BFG_Primary(int weaponMode, int tic)
    {
        switch(weaponMode)
        {
            // Fire Green
            case 1:
                switch(tic)
                {  
                    case 0:
                    A_StopSound(CHAN_WEAPON);
                    A_StartSound("weapons/bfg_chargestart2", CHAN_6);
                    A_Overlay(-3,"MuzzleFlash");
                    A_OverlayFlags(-3,PSPF_RENDERSTYLE,true);
                    A_OverlayRenderStyle(-3,STYLE_Add);
                    A_AlertMonsters();
                    break;

                    case 1:
                    PB_FireOffset();
				    A_GunFlash();
                    break;

                    case 2:
                    A_SetBlend("GREEN",0.5,18);
                    A_StopSound(CHAN_WEAPON);
                    A_StopSound(CHAN_6);
                    A_StartSound("bfg/fire_primary", CHAN_WEAPON);
                    break;

                    case 3:
                    A_FireCustomMissile("PB_SuperBFGBall");
                    A_TakeInventory(invoker.ammo1.getClassName(), 40, TIF_NOTAKEINFINITE);
                    A_ZoomFactor(0.98, ZOOM_INSTANT);
                    A_GunFlash();
                    A_AlertMonsters();
                    break;

                    case 4:
                    A_ZoomFactor(1.0);
                    break;
                }
                break;

            // Fire Black Hole
            case 2:
                switch(tic)
                {
                    case 0:
                    A_StopSound(CHAN_WEAPON);
                    A_StartSound("bh_Charge", CHAN_WEAPON,1.0, ATTN_NORM, false); //CHAN_WEAPON
                    A_AlertMonsters();
                    break;

                    case 1:
                    A_StopSound(CHAN_6);
                    A_StopSound(CHAN_7);
                    A_FireCustomMissile("Blackhole_Ball",0,1,0,0);
                    A_TakeInventory(invoker.ammo1.getClassName(), 80, TIF_NOTAKEINFINITE);
                    A_AlertMonsters();
                    break;
                }
                break;
        }
    }

    acion state BFG_SwitchMode()
    {
        A_WeaponOffset(0,32);
        A_SetRoll(0);
        PB_HandleCrosshair(72);
        A_SetInventory("PB_LockScreenTilt",0);
        A_SetInventory("GoWeaponSpecialAbility",0);

        if(invoker.ammo1.amount < 1)
            return ResolveState("FailedToFireEmpty");
        else if(getBlackholeMode())
            return ResolveState("SwitchToGreen");
        return ResolveState(null);
    }

    action state BFG_Ready()
    {
		PB_HandleCrosshair(72);
        string sound;
		if(getBlackholeMode() && invoker.ammo1.amount > 0) 
            string = "weapons/bfg_idle";
        else if(invoker.ammo1.amount > 0) 
            string = "weapons/bhg_idle";
        A_StartSound(string, CHAN_WEAPON, CHANF_LOOPING|CHANF_OVERLAP );

        if(invoker.ammo1.amount => 1)
            return ResolveState("ReadyToFire")
        else
            return ResolveState("ReadyToFire2")
        return ResolveState(null)
    }

    action void BFG_ChangeSprite(
        name blackHole, 
        name empty = '', 
        name default =,
        int layer = PSP_WEAPON,
        bool checkPurpleOnly = false)
    {
		let psp = player.findpsprite(layer);
		if(!psp) return;

        name sprite;

        if(getBlackholeMode())
            sprite = blackHole;
        else if(invoker.ammo1.amount <= 0 && !checkPurpleOnly)
            sprite = empty;
        else
            sprite = default;

        psp.sprite = GetspriteIndex(sprite);
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            097G A -1;
			Stop;
        
        WeaponRespect:
            TNT1 A 0 {
                    A_SetCrosshair(-1);
                    A_SetInventory("PB_LockScreenTilt",1);
                    A_StartSound("Ironsights", CHAN_AUTO);
                    A_StartSound("IronSights", CHAN_AUTO);
                    A_StartSound("weapons/railgun/inspect1", CHAN_AUTO);
                }
			000G ABCDEFGHIJKLMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_raise", CHAN_AUTO);
			000G QRSTUVWXYZ 1 {
				A_SetRoll(roll-2.0);
				return A_DoPBWeaponAction();
			}
			001G ABCDEFGHIJKLMNO 1 {
				A_SetRoll(roll+3.0);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 {
				A_StartSound("GENREADY", CHAN_AUTO);
				A_SetRoll(0);
			}
			001G PQRSTUVWXYZ 1 {
				A_SetRoll(roll+1.0);
				return A_DoPBWeaponAction();
			}
			002G ABCDEFGHIJKLMNOPQRSTUVW 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_beep", CHAN_AUTO);
			002G XYZ 1 A_DoPBWeaponAction();
			003G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			004G ABCDE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_boop", CHAN_AUTO);
			TNT1 A 0 A_StartSound("weapons/bfg_windup", CHAN_AUTO);
			004G FGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			005G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			006G ABCDEFGHIJKLMNO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/railgun/powerdownred", CHAN_AUTO);
			006G PQRSTUVWXYZ 1 A_DoPBWeaponAction();
			007G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			008G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_brap", CHAN_AUTO);
			009G ABCD 1 A_DoPBWeaponAction();
			009G EFGHIJKLMNOPQRST 1 A_DoPBWeaponAction();
			TNT1 A 0 A_JumpIf(invoker.ammo1.amount => 1, "Ready3"); // Jump to ready if have cells
		RespectButEmpty:
			TNT1 A 0 A_StartSound("weapons/railgun/deselectblue", CHAN_AUTO);
			017G ABCDEFGHIJKLMNOP 1;
			Goto Ready3;

        Deselect:
            // Cache Sprites
            044G ABCD 0;
			045G ABCD 0;
            // Actual Deselect
            TNT1 A 0 {
				A_StopSound(CHAN_BODY);
				A_ClearOverlays(-52,-52);
			}
			013G ABCD 1 BFG_ChangeSprite("044G", "045G");
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
                PB_WeapTokenSwitch("BFGSelected");
				PB_HandleCrosshair(72);
                PB_WeaponRaise("weapons/bfg_raise");
			    return PB_RespectIfNeeded();
            }
        SelectAnimation:
            // Cache Sprites
			042G ABCD 0;
			043G ABCD 0;
            // Actual Select
            010G ABCD 1 BFG_ChangeSprite("042G", "043G");
        // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
            // Cache Sprites
			021G ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			022G ABCD 0;
            // Actual Ready
			TNT1 A 0 BFG_Ready();
        ReadyToFire:
			011G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 {
                BFG_ChangeSprite("021G", default:"011G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
			}
			012G ABCD 1 {
                BFG_ChangeSprite("022G", default:"012G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
			}
			Loop;

        // This is basically Ready Empty
        ReadyToFire2:
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount => 1, "PowerOn");
			046G A 1 A_DoPBWeaponAction();
			Loop;

        PowerOn:
            // Cache Sprites
            019G QRSTUVWXYZ 0;
			020G ABCD 0;
            // Actual PowerOn
			TNT1 A 0 A_StartSound("weapons/bfg_switch", CHAN_WEAPON, CHANF_OVERLAP );
			017G QRSTUVWXYZ 1 {
                BFG_ChangeSprite("019G", default:"017G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
			}
			018G ABCD 1 {
                BFG_ChangeSprite("020G", default:"018G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
            }
			Goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
			TNT1 A 0 BFG_SwitchMode();
		SwitchToBlackhole:
			TNT1 A 0 {
				A_Print("$PB_BFG_BLACKHOLE");
				setBlackholeMode(true);
				A_StopSound(CHAN_WEAPON);
				A_StartSound("weapons/bfg_switch2", CHAN_AUTO);
			}
			017G ABCDEFGHIJKLMNO 1;
			017G PP 1;
			TNT1 A 0 A_StartSound("weapons/bfg_switch", CHAN_AUTO);
			019G QRSTUVWXYZ 1;
			020G ABCD 1;
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			Goto Ready3;

        SwitchToGreen:
			TNT1 A 0 {
				A_Print("$PB_BFG_PLASMA");
				setBlackholeMode(false);
				A_StopSound(CHAN_WEAPON);
				A_StartSound("weapons/bfg_switch2", CHAN_AUTO);
			}
			019G ABCDEFGHIJKLMNO 1;
			019G PP 1;
			TNT1 A 0 A_StartSound("weapons/bfg_switch", CHAN_AUTO);
			017G QRSTUVWXYZ 1;
			018G ABCD 1;
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			Goto Ready3;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(72);
				A_SetInventory("PB_LockScreenTilt",0);
			}
            TNT1 A 0 A_JumpIf(getBlackholeMode(), "Fire_Blackhole");
            TNT1 A 0 PB_jumpIfNoAmmo("FailedToFire",40,false,false);
        Fire_Green:
			TNT1 A 0 BFG_Primary(1,0);
			014G ABCD 1 LIGHT("BARONBALL_X2");
			TNT1 A 0 A_StartSound("weapons/bfg_chargeloop", CHAN_BODY);
			014G EFGHI 1 LIGHT("BARONBALL_X2");
			TNT1 A 0 A_StartSound("weapons/bfg_chargestart", CHAN_5);
			014G JKLMNOPQRSTUVWXYZ 1 LIGHT("BARONBALL_X2") A_GunFlash();
			015G ABCDEFGH 1 LIGHT("BARONBALL_X3") BFG_Primary(1,1);
			TNT1 A 0 BFG_Primary(1,2);
			015G I 1 BFG_Primary(1,3);
			015G JKLMNOPQRST 1 BFG_Primary(1,4);
			TNT1 A 0 PB_Refire();
			Goto Ready3;

        Fire_Blackhole:
            TNT1 A 0 PB_jumpIfNoAmmo("FailedToFire",80,false,false);
			TNT1 A 0 BFG_Primary(2,0);
			023G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			024G ABCDEFGH 1;
			024G IJKLMNOPQRSTUVWXYZ 1;
			025G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 PB_FireOffset();
			026G ABC 1 PB_FireOffset();
			TNT1 A 0 BFG_Primary(2,1);
			026G DEFGHIJKLMNOPQRSTUVW 1;
			TNT1 A 0 PB_Refire();
			Goto Ready3;

        FailedToFire:
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount == 0, "FailedToFireEmpty");
			TNT1 A 0 A_StartSound("weapons/railgun/deselectblue", CHAN_AUTO);
			017G ABCDEFGHIJKLMNO 1 BFG_ChangeSprite("019G", default:"017G", checkPurpleOnly: true);
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			017G PPPPPPP 1 BFG_ChangeSprite("019G", default:"017G", checkPurpleOnly: true);
			017G PP 1 BFG_ChangeSprite("019G", default:"017G", checkPurpleOnly: true);
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			017G PPPPPPP 1 BFG_ChangeSprite("019G", default:"017G", checkPurpleOnly: true);
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount == 0, "Ready3");
			017G QRSTUVWXYZ 1 BFG_ChangeSprite("019G", default:"017G", checkPurpleOnly: true);
			018G ABCD 1 BFG_ChangeSprite("020G", default:"018G", checkPurpleOnly: true);
			Goto Ready3;

        FailedToFireEmpty:
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			046G AAAAAAA 1;
			046G AA 1 ;
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			046G AAAAAAA 1;
			Goto Ready3;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(72);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIfInventory("BFGBlackHoleMode", 1, "AltFire_Blackhole")
			TNT1 A 0 A_JumpIfInventory("PB_Cell",5,1)
			Goto FailedToFireGreen
			TNT1 A 0 A_StartSound("weapons/bfg_beamstart", CHAN_5)
			016G ABCDE 1
			016G FGHIJKLFGHIJK 1 {
				PB_FireOffset;
				A_GunFlash;
			}
			TNT1 A 0 {
				A_SetBlend("GREEN",0.2,7);
				A_StartSound("SUPERBFG", CHAN_AUTO);
				A_StartSound("Weapons/BFSG/Fire", CHAN_AUTO);
				A_ZoomFactor(0.94, ZOOM_INSTANT);
			}
			016G L 1 {
				A_ZoomFactor(1.0);
				PB_FireOffset;
				A_GunFlash;
			}
		BeamLoop:
			016G GHIJKL 1 {
				PB_FireOffset;
				//A_FireCustomMissile ("BFG_BeamProjectile", 0, 0, 0, -8, 0,0);
				PB_FireAltBFGRail();  //function defined in BaseWeapon_Function.zsc to replace the rail and the projectilew
				//A_RailAttack(0, 0, 0,"None", "Green", RGF_SILENT || RGF_NOPIERCING || RGF_FULLBRIGHT, 2.0, "NullPuff", 0, 0, 0, 0, 10.0, 1.0, "BFGLightningTrial_Small", -7,0,0);
				A_TakeInventory("PB_Cell", 1, TIF_NOTAKEINFINITE);
				A_GunFlash;
				if(CountInv("PB_Cell") < 1) {
					return state("AltHoldStop");
				}
				return state("");
			}
			TNT1 A 0 {
				A_StartSound("Leech/Fire", CHAN_WEAPON, CHANF_LOOPING);
			}
			TNT1 A 0 PB_ReFire("BeamLoop")
		AltHoldStop:
			TNT1 A 0 {
				A_StopSound(CHAN_WEAPON);
				A_StartSound("Weapons/BFGG/Explode", CHAN_AUTO);
			}
			016G MNOPQR 1
			Goto Ready3
			
		AltFire_Blackhole:
			TNT1 A 0 A_JumpIfInventory("PB_Cell",30,1)
			Goto FailedToFirePurple
			TNT1 A 0 A_StartSound("weapons/bh_sec_charge1", CHAN_AUTO)
			027G ABCDEFGH 1 PB_FireOffset
			TNT1 A 0 A_StartSound("weapons/bh_sec_charge2", CHAN_BODY)
			027G IJKLMNOPQRSTUVWXYZ 1 {PB_FireOffset; A_GunFlash;}
			028G ABCD 1 {PB_FireOffset; A_GunFlash;}
			
			028G E 1 {
				A_StopSound(CHAN_BODY);
				A_StartSound("weapons/bh_secondary", CHAN_WEAPON);
				A_FireCustomMissile("BlackHole_GravityBomb",0,1,0,0);
				A_TakeInventory("PB_Cell", 30, TIF_NOTAKEINFINITE);
				A_GunFlash;
			}
			
			028G FGHI 1 A_GunFlash
			TNT1 A 0 A_ReFire
			Goto Ready3
            
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        FlashKicking:
		FlashAirKicking:
            // Cache Sprites
			034G ABCDEFGGGHIJKLMNO 0;
			035G ABCDEFGGGHIJKLMNO 0;
            // Actual Kick
			033G ABCDEFGGGHIJKLMNO 1 BFG_ChangeSprite("034G","035G","033G");
			Goto Ready3
			
		FlashSlideKicking:
            // Cache Sprites
			037G ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			038G ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
            // Actual Slide
			036G ABCDEFGHIJKLMNOPQRSTUVWX 1 BFG_ChangeSprite("037G","038G","036G");
			Goto Ready3;

		FlashSlideKickingStop:
			036G RSTUVWX 1 BFG_ChangeSprite("037G","038G","036G");
			Goto Ready3;

		FlashPunching:
            // Cache Sprites
			040G ABCDEFGHIJKLMNO 0;
			041G ABCDEFGHIJKLMNO 0;
            // Actual Punch
			039G ABCDEFGHIJKLMNO 1 BFG_ChangeSprite("040G","041G","039G");
			Goto Ready3;

        MuzzleFlash:
			014M ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			015M ABCDEFGHIJKLMNOPQRST 1;
			Stop;
            

    }
}