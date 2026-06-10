Class PB_Revolver : PB_WeaponBase
{
	default
	{
		//$Category Project Brutality - Weapons
		//$Sprite RVICA0
		//SpawnID 9210;
		weapon.slotnumber 2;							
		weapon.ammotype1 "PB_LowCalMag";
		weapon.ammogive1 20;	
		weapon.ammotype2 "PB_RevolverMag";
		weapon.slotpriority 0.25;
		PB_WeaponBase.ReserveToMagAmmoFactor 2;
		PB_WeaponBase.AmmoTypeLeft "PB_RevolverLeftMag";
		inventory.pickupsound "REVOUP";
		Inventory.Pickupmessage "$PB_REVOLVER_PICKUP";
		Inventory.MaxAmount 2;					
		Obituary "%o was shot down by %k's revolver.";
		Tag "$PB_REVOLVER_TAG";
		scale 0.4;
		Inventory.AltHUDIcon "RVICA0";
		FloatBobStrength 0.5;
		PB_WeaponBase.Upgrade "PB_Deagle";
	}
	
	override void AttachToOwner(Actor Other)
	{
		Super.AttachToOwner(other);
		if(!PB_HelpNotificationsHandler.CheckTipEvent(1 << 9, CVar.GetCvar("pb_helpflags", Other.Player))) {
			Array<String> pbTipsBuf;
			pbTipsBuf.Push("$PB_REVOLVER_TIP");
			PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 9);
		}
	}
	
	states
	{
		Spawn:
			VVIC A 0 NoDelay;
			RVIC A 10 A_PbvpFramework("VVIC");
			"####" A 0 A_PbvpInterpolate();
			loop;
		
		WeaponRespect:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",1);
				A_StartSound("REVOUP",10,CHANF_OVERLAP);
				A_SetCrosshair(-1);
				}
			R2V1 ABCDEFGHIJ 1{
				A_SetRoll(roll+0.1, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			R2V1 KLMNOPQRST 1 {
				A_SetRoll(roll-0.1, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			R2V1 U 1 A_DoPBWeaponAction();
			R2V1 VWXYZ 1 {
				A_SetRoll(roll+0.2, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			R2V2 AB 1 {
				A_SetRoll(roll+0.2, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			R2V2 CDEFGHI 1{
				A_SetRoll(roll-0.2, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			R2V2 JKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			R2V3 ABCDEFGH 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("Weapons/Revolver/Click1");
			R2V3 IJK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("Weapons/Revolver/Click1");
			R2V3 LMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			R2V4 ABCDEFGHIJKL 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("CYLNSPIN");
			R2V4 MNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			R2V5 ABCDEFGHIJKL 1 A_DoPBWeaponAction ();
			R2V5 MNOP 1 {
				A_SetRoll(roll-0.4, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			TNT1 A 0 A_StartSound("Weapons/Revolver/Close");
			R2V5 QRSTUVWX 1 {
				A_SetRoll(roll+0.2, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			R2V5 YZ 1 A_DoPBWeaponAction();
			R2V6 ABCDEFGHIJKLM 1 A_DoPBWeaponAction();
			TNT1 A 0 A_SetRoll(0);
			Goto Ready3;
		
		Select:
			R1V1 E 0 PB_SelectIfUpgrade("PB_Deagle");
			TNT1 A 0 PB_WeaponRaise("REVOUP");
			//goto SelectFirstPersonLegs;	//pb_Weaponraise already handles this
		SelectContinue:
			TNT1 A 0 PB_WeapTokenSwitch("RevolverSelected");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
			R1V1 ABCD 1;
			goto Ready3;
		
		Deselect:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_zoomfactor(1.0);
			TNT1 A 0 A_SetInventory("Zoomed",0);
			40V1 FGHI 0;
			R1V1 FGHI 1 {	if(A_CheckAkimbo())A_SetWeaponSprite("40V1");	}
			TNT1 A 0 A_lower(120);
			wait;
			
		ready:
		Ready3:
			TNT1 A 0 A_JumpIfInventory("Zoomed",1,"Ready2");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 {
				A_SetRoll(0, SPF_INTERPOLATE);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyLoop:
			R1V1 E 0 PB_SelectIfUpgrade("PB_Deagle");
			R1V1 E 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("RevolverHasUnloaded"));
			Loop;
		MuzzleFlash:
			R4VM AB 1 Bright A_GunFlash();
			Stop;
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 PB_jumpIfNoAmmo();
			TNT1 A 0 A_jumpifinventory("zoomed",1,"Fire2");
			R4V1 A 1 BRIGHT {
					A_Overlay(-5, "MuzzleFlash", true);
					A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
					A_OverlayRenderStyle(-5,STYLE_Add);
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
                    PB_MuzzleFlashEffects(0, 0, 0);
					A_Fireprojectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revolver");
					PB_TakeAmmo("PB_RevolverMag",1,0);
					A_ZoomFactor(0.96);
					PB_WeaponRecoil(-1.15,-0.26);
				}
			R4V1 B 1 BRIGHT {
					A_ZoomFactor(0.98);
					PB_WeaponRecoil(-1.15,-0.26);
				}
			R4V1 C 1 {
					A_ZoomFactor(1.0);
					PB_WeaponRecoil(-1.15,-0.26);
				}
			R4V1 DEF 1;
			R4V1 GH 1 A_jumpif(JustPressed(BT_ATTACK),"FanFire");
			R1V1 EE 1 {
				if(JustPressed(BT_ATTACK))
					return resolvestate("FanFire");
				if(JustPressed(BT_ALTATTACK))
					return resolvestate("Altfire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			TNT1 A 0 PB_ReFire();
			Goto Ready3;
		
		AltFire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			goto AltFire_Zoom;
		FanMuzzleFlash:
			R5VM AB 1 Bright A_GunFlash();
			Stop;
		FanMuzzleFlash2:
			R5VM AC 1 Bright A_GunFlash();
			Stop;
		FanFire:
			TNT1 A 0 PB_jumpIfNoAmmo();
			R5V1 A 1 BRIGHT {
					A_Overlay(-5, "FanMuzzleFlash", true);
					A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
					A_OverlayRenderStyle(-5,STYLE_Add);
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
                    PB_MuzzleFlashEffects(0, 0, 0);
					A_FireProjectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revolver");
					PB_TakeAmmo("PB_RevolverMag",1,0);
					A_ZoomFactor(0.96);
					PB_WeaponRecoil(-1.15,-0.35);
				}
			R5V1 B 1 BRIGHT {
					A_ZoomFactor(0.98);
					PB_WeaponRecoil(-1.15,-0.35);
				}
			R5V1 C 1 {
					A_ZoomFactor(1.0);
					A_StartSound("Weapons/Revolver/Click1",10);
					PB_WeaponRecoil(-1.15,-0.35);
				}
			R5V1 DEFG 1;
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 PB_ReFire("AltFan_Hold");
			R5V1 UVWX 1;
			Goto Ready3;
		AltFan_Hold:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 PB_jumpIfNoAmmo();
			R5V1 I 1 BRIGHT {
					A_Overlay(-5, "FanMuzzleFlash2", true);
					A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
					A_OverlayRenderStyle(-5,STYLE_Add);
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
                    PB_MuzzleFlashEffects(0, 0, 0);
					A_FireProjectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revolver");
					PB_TakeAmmo("PB_RevolverMag",1,0);
					A_ZoomFactor(0.96);
					PB_WeaponRecoil(-1.2,-0.36);
				}
			R5V1 J 1 BRIGHT {
					A_ZoomFactor(0.98);
					PB_WeaponRecoil(-1.2,-0.36);
				}
			R5V1 K 1 {
					A_ZoomFactor(1.0);
					A_StartSound("Weapons/Revolver/Click1",10);
					PB_WeaponRecoil(-1.2,-0.36);
				}
			R5V1 LMNO 1;
			TNT1 A 0 PB_ReFire("AltFan_Hold");
			R5V1 UVWX 1;
			Goto Ready3;
		
		NoAmmo:
			R1V1 E 1 A_StartSound("weapons/empty");
			Goto Ready3;
		Reload:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
			TNT1 A 0 PB_CheckReload("ReloadUnloaded",null,null,"Ready3","Ready3",6,2);
			TNT1 A 0 A_StartSound("Ironsights");
			R6V1 ABCDDE 1 A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open",10,CHANF_OVERLAP);
			R6V1 FGHI 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			R6V1 J 1;
			R6V1 KLMNO 1;
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Click2",10,CHANF_OVERLAP);
				PB_RevolverCasingSpawn("PB_RevolverMag");
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
			R6V1 PQRS 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			R6V1 T 1;
			R6V1 U 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			Goto ContinueReload;
		ReloadUnloaded:
			TNT1 A 0 A_StartSound("Ironsights");
			R7V2 IHGFED 1 A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open",10,CHANF_OVERLAP);
			R7V2 CBA 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
		ContinueReload:
			R6V1 VWXYZ 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Load",10,CHANF_OVERLAP);
				PB_AmmoIntoMag("PB_RevolverMag","PB_LowCalMag",6,2);
				PB_SpawnCasing("RevolverSpeedLoader", 45.6, 9, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
				PB_SetMagUnloaded(false);
				PB_SetChamberEmpty(false);
				PB_SetMagEmpty(false);
			}
			R6V2 ABCDEFF 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("CYLNSPIN",10,CHANF_OVERLAP);
			R6V2 GHI 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Close",10,CHANF_OVERLAP);
			R6V2 JKL 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_SetRoll(0,SPF_INTERPOLATE);
				PB_SetReloading(false);
			}
			Goto Ready3;
		ReloadDualWield:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 PB_CheckReload("ReloadUnloadedRight",null,null,"ReloadLeftOnly","Ready3",6,2);
			42V1 ABC 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			42V1 DEF 1 A_SetRoll(roll+0.3, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Click2",10,CHANF_OVERLAP);
				PB_RevolverCasingSpawn("PB_RevolverMag");
				PB_SetChamberEmpty(true);
				PB_SetMagUnloaded(true);
			}
			42V1 GHIJKLM 1 A_SetRoll(roll+0.4, SPF_INTERPOLATE);
			42V1 NO 1;
			42V1 PQ 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			Goto ContinueReloadRight;
		ReloadUnloadedRight:
			43V3 HGFEDCBA 1;
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open",10,CHANF_OVERLAP);
			43V2 ZY 1;
		ContinueReloadRight:
			42V1 RSTUV 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Load",10,CHANF_OVERLAP);
				PB_AmmoIntoMag("PB_RevolverMag","PB_LowCalMag",6,2);
				PB_SpawnCasing("RevolverSpeedLoader", 45.6, 9, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
				PB_SetMagUnloaded(false);
				PB_SetChamberEmpty(false);
				PB_SetMagEmpty(false);
			}
			42V1 WXYZ 1;
			TNT1 A 0 A_Startsound("CYLNSPIN", 10,CHANF_OVERLAP);
			42V2 ABBC 1	A_SetRoll(roll+0.6, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			TNT1 A 0 A_JumpIfInventory("PB_RevolverLeftMag", 6, "FinishDualReload");
			42V2 DEF 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			TNT1 A 2;
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true), "ReloadUnloadedLeft");
			Goto ReloadLeft;
		ReloadLeftOnly:
			TNT1 A 0 PB_CheckReload("ReloadUnloadedLeft",null,null,"Ready3","Ready3",6,2,true);
			40V1 EFGHI 1;
		ReloadLeft:
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true),"ReloadEmptyLeft");
			42V2 G 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			42V2 HIJ 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			42V2 KLM 1 A_SetRoll(roll+0.3, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Click2",10,CHANF_OVERLAP);
				PB_RevolverCasingSpawn("PB_RevolverLeftMag");
				PB_SetChamberEmpty(true,true);
				PB_SetMagUnloaded(true,true);
			}
			42V2 NOPQRST 1 A_SetRoll(roll+0.4, SPF_INTERPOLATE);
			42V2 UV 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			Goto ContinueReloadLeft;
		ReloadUnloadedLeft:
			43V2 CBA 1;
			43V1 ZY 1;
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open",10,CHANF_OVERLAP);
			43V1 XW 1;
		ContinueReloadLeft:
			42V2 WXYZ 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			42V3 A 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Load",10,CHANF_OVERLAP);
				PB_AmmoIntoMag("PB_RevolverLeftMag","PB_LowCalMag",6,2);
				PB_SpawnCasing("RevolverSpeedLoader", 45.6, 9, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
				PB_SetChamberEmpty(false,true);
				PB_SetMagUnloaded(false,true);
				PB_SetMagEmpty(false,true);
			}
			42V3 BCDE 1 A_SetRoll(roll+0.6, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("CYLNSPIN", 10,CHANF_OVERLAP);
			42V3 FGGH 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
		FinishDualReload:
			42V3 IJKL 1;
			TNT1 A 0 A_Startsound("Ironsights", 10,CHANF_OVERLAP);
			42V3 MN 1;
			TNT1 A 0 {
				A_SetRoll(0);
				PB_SetReloading(false);
			}
			Goto Ready3;
			
		Unload:
			TNT1 A 0 A_StartSound("Ironsights");
			TNT1 A 0 A_JumpIF(A_CheckAkimbo(), "DualUnload");
			R7V1 ABCDDE 1 A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			R7V1 FGHI 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			R7V1 J 1;
			R7V1 KLMNO 1;
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
				PB_RevolverCasingSpawn("PB_RevolverMag");
				PB_UnloadMag("PB_RevolverMag","PB_LowCalMag",2,1,2,0,"PB_MagnumRound");
				PB_SetChamberEmpty(true);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			R7V1 PQRST 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			R7V1 U 1;
			R7V1 VWXYZ 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			R7V2 ABCCDE 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			R7V2 EFGHII 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_SetRoll(0);
				PB_SetReloading(false);
			}
			Goto Ready3;
		DualUnload:
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"StartUnloadLeft");
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			43V1 ABCDEFGHIJ 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
				PB_RevolverCasingSpawn("PB_RevolverMag");
				PB_UnloadMag("PB_RevolverMag","PB_LowCalMag",2,1,2,0,"PB_MagnumRound");
				PB_SetChamberEmpty(true);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			43V1 KLMNOPQRST 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			43V1 UVW 1 A_SetRoll(roll+0.6, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			43V1 XYZ 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true),"FinishDualUnload");
			43V2 ABC 1;
			Goto UnloadLeft;
		StartUnloadLeft:
			40V1 EFGHI 1;
		UnloadLeft:
			TNT1 A 2;
			43V2 DEF 1;
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			43V2 GHIJKL 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_StartSound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
				PB_RevolverCasingSpawn("PB_RevolverLeftMag");
				PB_UnloadMag("PB_RevolverLeftMag","PB_LowCalMag",2,1,2,0,"PB_MagnumRound");
				PB_SetChamberEmpty(true,true);
				PB_SetMagUnloaded(true,true);
				PB_SetMagEmpty(true,true);
			}
			43V2 MNOPQR 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			43V2 STUVWXYZ 1;
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			43V3 A 1 A_SetRoll(roll+0.4, SPF_INTERPOLATE);
		FinishDualUnload:
			43V3 BCD 1 A_SetRoll(roll+0.4, SPF_INTERPOLATE);
			43V3 EFGH 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;
		
		Weaponspecial:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",1);
				A_Setinventory("GoWeaponSpecialAbility",0);
				PB_HandleCrosshair(42);
				A_ZoomFactor(1.0);
				A_setinventory("zoomed",0);
				A_ClearOverlays(10,11);
				A_StartSound("Ironsights", 10);
			}
			TNT1 A 0 A_JumpIfInventory("PB_Revolver", 2,"SwitchToDualWield");
			TNT1 A 0 A_print("$PB_REVOLVER_NOAKIMBO");
			Goto Ready3;
			
			
		SwitchToDualWield:
				TNT1 A 0 {
					if (A_CheckAkimbo()) 
					{
						A_SetAkimbo(False);
						A_ClearOverlays(10,11);
						return resolvestate("SwitchFromDualWield");
					}
					
					A_SetAkimbo(True);
					return resolvestate(null);
				}
			R3V1 ABCDJ 1 A_SetRoll(roll+0.8, SPF_INTERPOLATE);
			R3V1 J 1;
			R3V1 EFGHI 1 A_SetRoll(roll-0.8, SPF_INTERPOLATE);
			Goto ReadyDualWield;
		StopDualWield:
			TNT1 A 0 {
				A_SetAkimbo(False);
				A_ClearOverlays(10,11);
			}
		SwitchFromDualWield:
			R3V2 ABCDE 1 A_SetRoll(roll-0.8, SPF_INTERPOLATE);
			R3V2 E 1;
			R3V2 EFGHI 1 A_SetRoll(roll+0.8, SPF_INTERPOLATE);
			Goto Ready3;
		
		////////////////////////////////////////////////////////////////////////
		//
		//	ADS Stuff
		//
		////////////////////////////////////////////////////////////////////////
		
		AltFire_Zoom:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				A_SetCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"zoomout");
			TNT1 A 0 {
				 A_WeaponOffset(0,32);
				 A_StartSound("IronSights", 10,CHANF_OVERLAP);
				 A_SetInventory("Zoomed",1);
				 A_ZoomFactor(1.25);
				 A_SetCrosshair(-1);
			}
			R4V2 ABCDE 1;
			Goto Ready2;
		Zoomout:	
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_ZoomFactor(1.0);
			}
			R4V2 EDCBA 1;
			TNT1 A 0 PB_HandleCrosshair(42);
			Goto Ready3;
		
		Ready2:
			TNT1 A 0 {
				A_SetRoll(0);
				A_SetCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:
			R4V2 F 1
			{		
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					if (PressingFire() && CountInv("PB_RevolverMag") > 0 )
						return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				}
				else 
				{
					if (PressingFire() && CountInv("PB_RevolverMag") > 0 )
						return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
			}
			Loop;
		
		Fire2:
			TNT1 A 0 {
					A_WeaponOffset(0,32);
					A_SetCrosshair(-1);
				}
			TNT1 A 0 PB_jumpIfNoAmmo();
		ActualFire2:
			R4V3 A 1 BRIGHT {	
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_overlay(-6,"ADS_FireFlash");
					A_OverlayFlags(-6,PSPF_RENDERSTYLE,true);
					A_OverlayRenderStyle(-6,STYLE_Add);
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
                    PB_MuzzleFlashEffects(0, 0, 0);
					A_Fireprojectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revoPB_TakeAmmolver");
					PB_TakeAmmo("PB_RevolverMag",1,0);
					A_ZoomFactor(1.20);
					A_GunFlash();
					PB_WeaponRecoil(-1.15,-0.26);
					A_SetInventory("CantDoAction",1);
				}
		Fire2Continue:
			R4V3 B 1 BRIGHT {
					A_ZoomFactor(1.23);
					A_GunFlash();
					PB_WeaponRecoil(-1.15,-0.26);
				}
			R4V3 C 1 {
					A_ZoomFactor(1.25);
					PB_WeaponRecoil(-1.15,-0.26);
				}
			R4V3 DEFGH 1 {
				if(PB_GetAimMode() && JustReleased(BT_ALTATTACK) || !PB_GetAimMode() && JustPressed(BT_ALTATTACK)) 
					return resolvestate("Altfire");
				return resolvestate(null);
			}
			R4V2 FF 1
			{
				A_SetInventory("CantDoAction",0);
				if(PB_GetAimMode() && JustReleased(BT_ALTATTACK) || !PB_GetAimMode() && JustPressed(BT_ALTATTACK)) 
					return resolvestate("Altfire");
				if(JustPressed(BT_ATTACK))
					return resolvestate("Fire2");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			Goto Ready2;
			
		///////////////////////////////////////////////////////////////////////
		//
		//	Dual Wield Things
		//
		///////////////////////////////////////////////////////////////////////
		
		SelectAnimationDualWield:
			TNT1 A 0 A_StartSound("REVOUP",10,CHANF_OVERLAP);
			40V1 ABCD 1;
			TNT1 A 0 A_StartSound("REVOUP",10,CHANF_OVERLAP);
			goto ReadyDualWield;
		
		ReadyDualWield:
			TNT1 A 0 PB_SetupDualWield(crosshair:42);
		ReadyToFireDualWield:
			TNT1 A 0 PB_SelectIfUpgrade("PB_Deagle");
			TNT1 A 1 A_DoPBDualAction(2);
			Loop;
		
		IdleLeft_Overlay:
			40V1 J 1 A_DoPBLeftAction();
			Loop;
			
		IdleRight_Overlay:
			40V1 K 1 A_DoPBRightAction();
			Loop;
		
		MuzzleFlashLeft:
			41VM AB 1 Bright A_GunFlash();
			Stop;
		FireLeft_Overlay:
			41V1 A 1 BRIGHT {
				A_Overlay(-5, "MuzzleFlashLeft", true);
				A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-5,STYLE_Add);
				A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				PB_GunSmoke(5,0,0);
                PB_MuzzleFlashEffects(5, 0, 0);
				PB_LowAmmoSoundWarning("revolver", "PB_RevolverLeftMag");
				PB_TakeAmmo("PB_RevolverLeftMag",1,0,0,true);
				A_ZoomFactor(0.99);
				A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
				PB_DynamicTail("pistol", "shotgun");
				A_AlertMonsters();
				A_SetFiringLeftWeapon(True);
				A_GunFlash();
                PB_WeaponRecoil(-1.9,+1.8);
			}
			41V1 B 1 BRIGHT {
				A_ZoomFactor(1.0);
				A_GunFlash();
                PB_WeaponRecoil(-1.9,+1.8);
			}
			41V1 C 1 PB_WeaponRecoil(-1.9,+1.8);
			41V1 D 1;
			41V1 E 1 {
				A_SetFiringLeftWeapon(False);
				if(CountInv("PB_RevolverLeftMag")<=0 || CountInv("PB_RevolverMag")>0 )
					A_GiveInventory("DualFiring",1);
			}
			41V1 F 1;
			41V1 GGG 1 {
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("PB_RevolverLeftMag") > 0)
						return resolvestate("FireLeft_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(Null);
					}
				}
				if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
				{
					if(CountInv("PB_RevolverLeftMag") > 0)
					{
						return resolvestate("FireLeft_Overlay");
					}
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				return resolvestate(Null);
			}
			TNT1 A 0 {
				if(CountInv("PB_RevolverLeftMag")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;
		MuzzleFlashRight:
			41VM CD 1 Bright A_GunFlash();
			Stop;
		FireRight_Overlay:
			41V1 I 1 BRIGHT {
				A_Overlay(-6, "MuzzleFlashRight", true);
				A_OverlayFlags(-6,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-6,STYLE_Add);
				A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				PB_GunSmoke(-5,0,0);
                PB_MuzzleFlashEffects(-5, 0, 0);
				PB_LowAmmoSoundWarning("revolver");
				PB_TakeAmmo("PB_RevolverMag",1,0);
				A_ZoomFactor(0.99);
				A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
				PB_DynamicTail("pistol", "shotgun");
				A_AlertMonsters();
				A_SetFiringRightWeapon(True);
				A_GunFlash();
				PB_WeaponRecoil(-1.9,-1.8);
				}
			41V1 J 1 BRIGHT {
					A_ZoomFactor(1.0);
					A_GunFlash();
					PB_WeaponRecoil(-1.9,-1.8);
			}
			41V1 K 1 PB_WeaponRecoil(-1.9,-1.8);
			41V1 L 1;
			41V1 M 1 {
				A_SetFiringRightWeapon(False);
				if(CountInv("PB_RevolverLeftMag")>0 || CountInv("PB_RevolverMag")<=0 )
					A_TakeInventory("DualFiring",1);
			}
			41V1 N 1;
			41V1 OOO 1 {
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("PB_RevolverMag") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar > 2){
					if(CountInv("PB_RevolverMag") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				return resolvestate(null);
			}
			TNT1 A 0 {
				if(CountInv("PB_RevolverMag")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;
		
		NoAmmoDualWield:
			40V1 E 1;
			Goto Ready3;
	//
	//	fire flashes
	//
	ADS_FireFlash:
		R4V4 A 1 bright {
			let ps = player.findpsprite(overlayID());
			if(ps)
				ps.frame = random(0,1);
		}
		R4V4 C 1 bright {
			let ps = player.findpsprite(overlayID());
			if(ps)
				ps.frame = random(2,3);
		}
		stop;
	////////////////////////////////////////////////////////////////////////////
	//
	//	kick flashes
	//
	////////////////////////////////////////////////////////////////////////////
		
		FlashAirKicking:
		FlashKicking:
			TNT1 A 0 A_Jumpif(A_CheckAkimbo(), "DualFlashKicking");
			R8V1 ABCDEFGHHIJKLMN 1 A_DoPBWeaponAction();
			Goto Ready3;
		
		FlashPunching:
			TNT1 A 0 A_JumpIF(A_CheckAkimbo(), "DualFlashPunching");
			R0V1 ABCDEFGHIJKLMN 1;
			Goto Ready3;
		FlashSlideKicking:
			TNT1 A 0 A_JumpIF(A_CheckAkimbo(), "DualFlashSlideKicking");
			R9V1 ABCDEFGHIJKLMNONOPQRSTUVWX 1 A_DoPBWeaponAction();
			Goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 A_JumpIF(A_CheckAkimbo(), "DualFlashSlideKickingStop");
			R9V1 RSTUVWX 1 A_DoPBWeaponAction();
			Goto Ready3;
			
		
		DualFlashKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			44V1 ABCDEFGHHIJKLMN 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			Goto Ready3;
		DualFlashPunching:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 AAAAAAAAAAAAAAA 1;
			Goto Ready3;
		DualFlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			44V2 ABCDEFGHIJKLMNONOPQRSTUVWX 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			Goto Ready3;
		DualFlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10,11);
			44V2 RSTUVWX 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			Goto Ready3;
	}
	
}


Class PB_RevolverLeftMag : PB_WeaponAmmo //Your weapon's magazine ammo.
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 6; //Your weapon's magazine ammo limit. Always leave one more bullet, so you can do the 12+1 effect.
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 6;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "RVICA0";
	}
}

Class PB_RevolverMag : PB_WeaponAmmo
{
   default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 6;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 6;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "RVICA0";
	}
}