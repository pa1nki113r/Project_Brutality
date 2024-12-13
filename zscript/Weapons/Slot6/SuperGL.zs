Class PB_SuperGL : PB_Weapon
{
	default
	{
		//$Title Automatic Grenade Launcher
		//$Category Project Brutality - Weapons
		//$Sprite SGL0Z0
		//SpawnID 9520;
		//Game Doom
		//SpawnID 29;
		weapon.slotnumber 6;
		Speed 20;
		Damage 20;
		Scale 0.48;
		Weapon.SelectionOrder 2500;
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		Weapon.AmmoGive1 6;
		Weapon.AmmoType1 "PB_RocketAmmo";
		Weapon.AmmoType2 "GrenadeRounds";
		Inventory.PickupSound "misc/rockboxa";
		+WEAPON.NOAUTOAIM;
		+WEAPON.EXPLOSIVE;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		+FLOORCLIP;
		Inventory.PickupMessage "UAC-MGL Automatic Grenade Launcher (Slot 6)";
		Tag "UAC-M7 Super Grenade Launcher";
		Inventory.AltHUDIcon "SGL0Z0";
		PB_WeaponBase.respectItem "RespectSGL";
		PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "PB_SGLWheel";
		PB_WeaponBase.unloadertoken "SGLUnloaded";
	}
	
	int GrenadeMode;
	const Det_layer = -52;
	enum SGL_Mode {
		SGL_Impact = 0,
		SGL_Sticky = 1,
		SGL_Acid = 2,
		SGL_Fire = 3,
		SGL_Cryo = 4
	}
	
	states
	{
		Spawn:
			SGL0 Z -1;
			stop;
		
		WeaponRespect:
			TNT1 A 0 {
				A_SetInventory("RespectSGL",1);
				A_SetInventory("PB_LockScreenTilt",1);
				A_StartSound("weapons/sgl/inspect1", CHAN_AUTO);
				A_SetCurrentGrenadeType("Impact");
			}
			SL00 ABCDEFGHIJKLMNOP 1 { 
				A_SetRoll(roll+0.8,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
				
			TNT1 A 0 A_StartSound("weapons/carbine/fancybutton", CHAN_AUTO);
			
			SL00 QRSTUVWV 1 {
				A_SetRoll(roll-1.6,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			
			TNT1 A 0 A_StartSound("Ironsights", CHAN_AUTO);
			SL00 XYZ 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			SL01 ABCD 1 {
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 {
				A_StartSound("LIGHTON", CHAN_AUTO);
				A_SetRoll(roll+0.7,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 {
				A_SetPitch(pitch-4.2, SPF_INTERPOLATE);
				A_SetAngle(angle-4.2, SPF_INTERPOLATE);
			}
			SL01 EFGHIJK 1 {
					A_SetRoll(roll-0.1,SPF_INTERPOLATE);
					return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_StartSound("Ironsights", CHAN_AUTO);
			SL01 LMNOPQR 1 {
					A_SetPitch(pitch+0.6, SPF_INTERPOLATE);
					A_SetAngle(angle+0.6, SPF_INTERPOLATE);
					A_SetRoll(roll-0.15,SPF_INTERPOLATE);
					return A_DoPBWeaponAction();		
			}
			SL01 ST 1 {
					A_SetRoll(0,SPF_INTERPOLATE);
					return A_DoPBWeaponAction();
			}
			Goto Ready;
		
		Select:
			TNT1 A 0 PB_WeaponRaise("weapons/sgl/inspect2");	//this replaces the jump to SelectFirstPersonLegs state and a lot of other things
			TNT1 A 0 PB_WeapTokenSwitch("SGLSelected");
			TNT1 A 0 A_SetInventory("HasExplosiveWeapon",1);
			TNT1 A 0 A_SetInventory("CycleAnimation",0);
			TNT1 A 0 A_overlay(Det_layer,"DetonatorLayer");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			SL02 ABCD 1 SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42","S001");
			goto ready;
		
		Deselect:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 {
				A_SetInventory("CycleAnimation", 0);
				A_SetInventory("HasExplosiveWeapon", 0);
				A_ClearOverlays(Det_layer,Det_layer);
			}
			SL02 FGHI 1 SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42","S001");
			TNT1 A 0 A_lower(120);
			wait;
		Ready:
			TNT1 A 0 {
				A_overlay(Det_layer,"DetonatorLayer",true);
			}
		Ready3:
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(89);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("CycleAnimation", 0);
				A_SetInventory("CantWeaponSpecial",0);
			}
		ReadyToFire:
			SL02 E 1 {
				SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42","S001");
				if (PressingFire() && CountInv("GrenadeRounds") > 0){
					return resolvestate("Fire");
				}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			Loop;
		
		AltFire:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			SL02 E 1 {
				SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42","S001");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			goto ready;
		
		Fire:
			TNT1 A 0 PB_jumpIfHasBarrel("ThrowBarrel","ThrowFlameBarrel","ThrowIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(89);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			SL60 A 1 BRIGHT {
				PB_FireSGL();
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				A_Alertmonsters();
				A_Startsound("weapons/firegrenade", CHAN_WEAPON);
				A_TakeInventory("GrenadeRounds",1);
				A_ZoomFactor(0.98);
				A_GunFlash();
			}
			SL60 B 1 BRIGHT {
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				//A_Spawnprojectile("ShakeYourAssDouble", 0, 0, 0, 0);
				PB_SpawnCasing("EmptyGrenadeBrass", 30, 0, 34, -frandom(1, 3), -frandom(2, 4), 5);
				A_ZoomFactor(0.99);
				PB_WeaponRecoil(-3.2,+1.61);
			}
			SL60 C 1 {
				A_Overlay(-6, "MuzzleSparks", true);
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				A_ZoomFactor(1.0);
				PB_WeaponRecoil(-3.2,+1.61);
			}
			//TNT1 A 0 A_GunFlash("CyclingAnimation")
			Goto CyclingAnimation;
			
		CyclingAnimation:
			TNT1 A 0 A_SetInventory("CycleAnimation", 1);
			TNT1 A 0 A_StartSound("RLCYCLE2", 13);
			SL60 DEFGHIJKLMNOPQ 1 {
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOBOB|WRF_NOSWITCH); //A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOBOB|WRF_NOSWITCH);
			}
			TNT1 A 0 A_StartSound("weapons/sgl/cycle", 9);
			SL60 RSTUVWX 1 {
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOBOB|WRF_NOSWITCH); //A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOBOB|WRF_NOSWITCH);
			}
			TNT1 A 0 A_SetInventory("CycleAnimation", 0);
			SL02 E 1 SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42");
			Goto CycleDone;
		
		CycleDone:
			SL02 E 1 {
				//A_TakeInventory("SGLDetonateSoundCooldown",22);
				SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42");
				PB_ReFire();
			}
			Goto Ready;
			
			
		
		//
		//	reload
		//
		
		Reload:
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 PB_checkReload(null,"Ready","NoAmmo",8,1);
			TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_JumpIfInventory("SGLUnloaded",1,"ReloadUnloaded");
			TNT1 A 0 A_StartSound("Ironsights",15);
			SL03 ABCDEFGHIJ 1 {
				A_SetRoll(roll-0.5,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 14);
			SL03 KLMNO 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			
			SL03 PQRSTU 1 {
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			TNT1 A 0 PB_SpawnSGLDrum();	//
			SL03 VWXYZ 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			SL04 ABC 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			SL04 DEFG 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
		ContinueFromReloadUnloaded:
			TNT1 A 0 A_StartSound("weapons/nailgun/up", 10);
			SL04 HIJKLM 1 {
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			TNT1 A 0 A_StartSound("weapons/sgl/inspect1", 16);
			SL04 NOPQRST 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			
			SL04 UVW 1 {
				A_SetRoll(roll+0.8,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			
			SL04 XYZ 1 {
				A_SetRoll(roll-1.2,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			TNT1 A 0 A_JumpIfInventory("GrenadeRounds",1,"ChamberedReload");
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", 9, CHANF_OVERLAP);
		//Rechamber Animation
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("RLCYCLE2", 13);
			SL72 BCDEFGHIJK 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			TNT1 A 0 A_StartSound("weapons/sgl/cycle", 18);
			SL72 LMNO 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			TNT1 A 0 PB_AmmoIntoMag("GrenadeRounds","PB_RocketAmmo",6,1);
			TNT1 A 0 A_StartSound("weapons/sgl/cycle", 12);
			TNT1 A 0 A_setinventory(invoker.unloadertoken,0);
			SL72 PQRSTUVWXYZ 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			SL73 ABCDEF 1 SGL_ChangeModeSprite("SL73","S073","S273","S173","S373");
			goto ready;
		
		ChamberedReload:
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("weapons/sgl/slap", 9, CHANF_OVERLAP );
			SL05 A 1 SGL_ChangeModeSprite("SL05","SL16","SL26","SL36","SL46");
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", 17, CHANF_OVERLAP);
			SL05 BCDEF 1 SGL_ChangeModeSprite("SL05","SL16","SL26","SL36","SL46");
			TNT1 A 0 PB_AmmoIntoMag("GrenadeRounds","PB_RocketAmmo",7,1);
			TNT1 A 0 A_setinventory(invoker.unloadertoken,0);
			TNT1 A 0 A_StartSound("Ironsights", 12);
			SL05 GHIJKL 1 SGL_ChangeModeSprite("SL05","SL16","SL26","SL36","SL46");
			goto ready;
		
		ReloadUnloaded:
			TNT1 A 0 A_StartSound("Ironsights",15);
			S003 ABCD 1;
			Goto ContinueFromReloadUnloaded;
		
		
		//
		//	fking unload
		//
		Unload:
			TNT1 A 0 A_setinventory("Unloading",0);
			TNT1 A 0 A_Jumpif(countinv(invoker.UnloaderToken) > 0 || countinv(invoker.ammotype2) < 1,"Ready3");
			TNT1 A 0 A_JumpIfInventory("GrenadeRounds",1,"UnloadChamber");
		UnloadNormal:
			TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StartSound("Weapons/GrenadeLoad", 9);
			S402 ABCDEFGHIJKL 1 SGL_ChangeModeSprite("S402","S412","S422","S432","S442");
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", 10);
			S402 MNOPQRST 1 SGL_ChangeModeSprite("S402","S412","S422","S432","S442");
			TNT1 A 0 A_StartSound("weapons/nailgun/up", 11);
			TNT1 A 0 PB_UnloadMag("GrenadeRounds","PB_RocketAmmo",1);
			TNT1 A 0 {
				A_SetInventory("SGLUnloaded",1);
				A_SetInventory("Unloading",0);
			}
			S402 UVWXYZ 1 SGL_ChangeModeSprite("S402","S412","S422","S432","S442");
			S403 ABCDE 1 SGL_ChangeModeSprite("S403","S413","S423","S433","S443");
			goto ready;
		
		UnloadChamber:
			TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StartSound("Weapons/GrenadeLoad", 9);
			S400 ABCDEFGHIJKL 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", 10);
			S400 MNOPQRST 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 A_StartSound("weapons/nailgun/up", 11);
			TNT1 A 0 PB_UnloadMag("GrenadeRounds","PB_RocketAmmo",1);
			TNT1 A 0 {
				A_SetInventory("SGLUnloaded",1);
				A_SetInventory("Unloading",0);
			}
			S400 UVWXYZ 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			S401 ABCDE 1 SGL_ChangeModeSprite("S401","S411","S421","S431","S441");
			Goto ready;
		
		//
		//	weapon special
		//
		
		WeaponSpecial:
			TNT1 A 0 A_setinventory("GoWeaponSpecialAbility",0);
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 {
				A_SetInventory("CantWeaponSpecial" ,1 );
				A_SetInventory("PB_LockScreenTilt",1);
				A_SetInventory("GoWeaponSpecialAbility", 0);
			}
			TNT1 A 0 PB_PreHandleSGLWheel();
			//Unload Previous Ammo Type
			TNT1 A 0 A_JumpIf(findinventory("SGLUnloaded"), "LoadNewAmmoType");
			TNT1 A 0 A_StartSound("Ironsights",15);
			TNT1 A 0 PrintSGLMode();
			SL03 ABCDEF 1 {
				A_SetRoll(roll-0.6,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			SL03 GHIJKL 1 {
				A_SetRoll(roll+0.6,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 14);
			SL03 MNOPQRST 1 SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			SL03 WXYZ 1 
			{
				A_SetRoll(roll+0.8,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			
		LoadNewAmmoType:
			TNT1 A 0 A_JumpIf(CountInv("SGLUnloaded") <= 0, 5);	//why
			S003 ABCD 1;
			SL04 ABCDEF 1 SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			TNT1 A 0 A_StartSound("weapons/nailgun/up", 10);
			TNT1 A 0 PB_HandleWheel();	//do the mode change here, so the next animations plays the new ammo type 
			SL04 GHIJKLMN 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			TNT1 A 0 A_StartSound("weapons/sgl/inspect1", 16);
			SL04 OPQRST 1 {
				A_SetRoll(roll-0.5,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			//TNT1 A 0 A_StartSound("RLCYCLE2", 13)
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", 15);
			SL04 UVWXY 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			TNT1 A 0 A_StartSound("RLCYCLE2", 13);
			SL04 Z 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				A_StartSound("weapons/nailgun/inspect4", 9, CHANF_OVERLAP );
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			SL72 BCDEFGHIJK 1 {
				A_SetRoll(roll-0.5,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			}
			TNT1 A 0 A_StartSound("weapons/sgl/cycle", 18);
			SL72 LMNO 1 {
				A_SetRoll(roll+2.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			}
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			SL72 PQRSTUVWXYZ 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			SL73 ABCD 1 {
				A_SetRoll(roll+0.5,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL73","S073","S273","S173","S373");
			}
			SL73 EF 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL73","S073","S273","S173","S373");
			}
			TNT1 A 0 {
				A_SetInventory("CantWeaponSpecial" ,0 );
				A_SetInventory("GrenadeTypeImpact", 0);
				A_SetInventory("GrenadeTypeSticky", 0);
				A_SetInventory("GrenadeTypeIncendiary", 0);
				A_SetInventory("GrenadeTypeCryo", 0);
				A_SetInventory("GrenadeTypeAcid", 0);
				
				if(invoker.ammo1.amount > 0 && invoker.ammo2.amount < 7)
					PB_AmmoIntoMag("GrenadeRounds","PB_RocketAmmo",7,1);
				
			}  
			goto ready;
		
		//
		//flashes
		//
		
		DetonatorLayer:
			TNT1 A 1 {
				if(JustPressed(BT_ALTATTACK))
				{
					PB_LookAndDetonateGrenades();
					A_Startsound("weapons/pbarm",36,CHANF_NOSTOP);
				}
			}
			loop;
		
		
		MuzzleSparks:
			TNT1 A 0 A_Jump(256, "Spark1", "Spark2");
		Spark1:
			S060 A 1 Bright;
			Stop;
		Spark2:
			S060 B 1 Bright;
			Stop;
		
		FlashKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelKicking","FlashBarrelKicking","FlashBarrelKicking");
			S006 ABCDEFGGGHIJKLM 1 SGL_ChangeModeSprite("S006","S007","S019","S008","S009",layer:OverlayID());
			Goto Ready3;
		
		FlashAirKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelAirKicking","FlashBarrelAirKicking","FlashBarrelAirKicking");
			S006 ABCDEFGGGGHIJKLM 1 SGL_ChangeModeSprite("S006","S007","S019","S008","S009",layer:OverlayID());
			Goto Ready3;
			
		FlashSlideKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKicking","FlashBarrelSlideKicking","FlashBarrelSlideKicking");
			S020 ABCDEFGHIJKLMNOPQRSSSTUVWX 1 SGL_ChangeModeSprite("S020","S021","S022","S023","S024",layer:OverlayID());
			Goto Ready3;
			
		FlashSlideKickingStop:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKickingStop","FlashBarrelSlideKickingStop","FlashBarrelSlideKicking");
			S020 TTTUVWX 1 SGL_ChangeModeSprite("S020","S021","S022","S023","S024",layer:OverlayID());
			Goto Ready3;
	
		FlashPunching:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelPunching","FlashBarrelPunching","FlashBarrelPunching");
			S030 ABCDEFGHHIJKLM 1 SGL_ChangeModeSprite("S030","S031","S032","S033","S034",layer:OverlayID());
			Stop;
		
		LoadSprites:
			S001 ABCDEFGHI 0;
			SL02 ABCDEFGHI 0;
			SL12 ABCDEFGHI 0;
			SL22 ABCDEFGHI 0;
			SL32 ABCDEFGHI 0;
			SL42 ABCDEFGHI 0;
			SL03 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL04 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL05 ABCDEFGHIJKL 0;
			SL14 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL15 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL16 ABCDEFGHIJKL 0;
			SL24 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL25 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL26 ABCDEFGHIJKL 0;
			SL34 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL35 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL36 ABCDEFGHIJKL 0; 
			SL44 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL45 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL46 ABCDEFGHIJKL 0;
			SL60 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL61 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL62 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL63 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL64 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL60 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL61 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL62 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL63 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL64 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL72 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S072 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S272 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S172 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S372 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL73 ABCDEF 0;
			S073 ABCDEF 0;
			S273 ABCDEF 0;
			S173 ABCDEF 0;
			S373 ABCDEF 0;
			S030 ABCDEFGHIJKLM 0;
			S031 ABCDEFGHIJKLM 0;
			S032 ABCDEFGHIJKLM 0;
			S033 ABCDEFGHIJKLM 0;
			S034 ABCDEFGHIJKLM 0;
			S020 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S021 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S022 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S023 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S024 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S006 ABCDEFGGGHIJKLM 0;
			S007 ABCDEFGGGHIJKLM 0;
			S019 ABCDEFGGGHIJKLM 0;
			S008 ABCDEFGGGHIJKLM 0;
			S009 ABCDEFGGGHIJKLM 0;
			S402 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S403 ABCDE 0;
			S412 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S413 ABCDE 0;
			S422 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S423 ABCDE 0;
			S432 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S433 ABCDE 0;
			S442 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S443 ABCDE 0;
			S400 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S401 ABCDE 0;
			S410 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S411 ABCDE 0;
			S420 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S421 ABCDE 0;
			S430 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S431 ABCDE 0;
			S440 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S441 ABCDE 0;
			stop;
	}
	
	action int getSGLMode()
	{
		return invoker.GrenadeMode;
	}
	
	action void SetSGLMode(int mode = SGL_Impact)
	{
		invoker.GrenadeMode = mode;
	}
	
	Action void SGL_ChangeModeSprite(name imp,name stk,name acid, name inc, name cryo, name unloaded = '', int layer = PSP_WEAPON)
	{
		let psp = player.findpsprite(layer);
		
		if(!psp)
			return;
			
		if(findinventory(invoker.unloadertoken) && unloaded != '')
		{
			psp.sprite = getspriteindex(unloaded);
			return;
		}
		
		int mod = getSGLMode();
		
		switch(mod)
		{
			case SGL_Impact: 	psp.sprite = getspriteindex(imp); 	break;
			case SGL_Sticky: 	psp.sprite = getspriteindex(stk); 	break;
			case SGL_Acid: 		psp.sprite = getspriteindex(acid); 	break;
			case SGL_Fire: 		psp.sprite = getspriteindex(inc); 	break;
			case SGL_Cryo: 		psp.sprite = getspriteindex(cryo); 	break;
		}
	}
	
	action void SGL_ChangeModeSpriteNew(name imp,name stk,name acid, name inc, name cryo,int layer = PSP_WEAPON)
	{
		let psp = player.findpsprite(layer);
		
		if(!psp)
			return;
		if(findinventory("GrenadeTypeImpact"))
			psp.sprite = GetspriteIndex(imp);
		else if(findinventory("GrenadeTypeSticky"))
			psp.sprite = GetspriteIndex(stk);
		else if(findinventory("GrenadeTypeAcid"))
			psp.sprite = GetspriteIndex(acid);
		else if(findinventory("GrenadeTypeIncendiary"))
			psp.sprite = GetspriteIndex(inc);
		else if(findinventory("GrenadeTypeCryo"))
			psp.sprite = GetspriteIndex(cryo);
	}
	
	action void PB_FireSGL()
	{
		string msl = "PB_FragGrenade";
					
		switch(getSGLMode())
		{
			case SGL_Impact: 	msl = "PB_FragGrenade";			break;
			case SGL_Sticky: 	msl = "PB_StickyGrenade";		break;
			case SGL_Acid: 		msl = "PB_AcidGrenade";			break;
			case SGL_Fire: 		msl = "PB_IncendiaryGrenade";	break;
			case SGL_Cryo: 		msl = "PB_CryoGrenade";			break;
		}
		A_fireprojectile(msl,0,0);		
	}
	
	action void PB_SpawnSGLDrum()
	{
		if(invoker.ammo2.amount < 1)
		{
			string csng = "SGL_Drum";
			switch(getSGLMode())
			{
				case SGL_Impact: 	csng = "SGL_Drum";				break;
				case SGL_Sticky: 	csng = "SGL_StickyDrum";		break;
				case SGL_Acid: 		csng = "SGL_AcidDrum";			break;
				case SGL_Fire: 		csng = "SGL_IncendiaryDrum";	break;
				case SGL_Cryo: 		csng = "SGL_CryoDrum";			break;
			}
			PB_SpawnCasing(csng,25,0,20,Frandom(3,4),Frandom(3,4),1);
		}
	}
	
	action state PB_PreHandleSGLWheel()
	{
		if(
		findinventory("GrenadeTypeImpact") && getSGLMode() == 			SGL_Impact ||
		findinventory("GrenadeTypeSticky") && getSGLMode() == 			SGL_Sticky ||
		findinventory("GrenadeTypeAcid") && getSGLMode() == 			SGL_Acid ||
		findinventory("GrenadeTypeIncendiary") && getSGLMode() == 		SGL_Fire ||
		findinventory("GrenadeTypeCryo") && getSGLMode() == 			SGL_Cryo)
		{
			A_SetInventory("CantWeaponSpecial" ,0 );
			A_SetInventory("GrenadeTypeImpact", 0);
			A_SetInventory("GrenadeTypeSticky", 0);
			A_SetInventory("GrenadeTypeIncendiary", 0);
			A_SetInventory("GrenadeTypeCryo", 0);
			A_SetInventory("GrenadeTypeAcid", 0);
			return resolvestate("ready");
		}
		
		return resolvestate(null);
	}
	
	action void PB_HandleWheel()
	{
		if (CountInv("GrenadeTypeImpact") == 1) {SetSGLMode(SGL_Impact);	A_SetCurrentGrenadeType("Impact");}
		if (CountInv("GrenadeTypeSticky") == 1) {SetSGLMode(SGL_Sticky);	A_SetCurrentGrenadeType("Sticky");}
		if (CountInv("GrenadeTypeAcid") == 1) {	SetSGLMode(SGL_Acid);		A_SetCurrentGrenadeType("Acid");}
		if (CountInv("GrenadeTypeIncendiary") == 1) {SetSGLMode(SGL_Fire);	A_SetCurrentGrenadeType("Incendiary");}
		if (CountInv("GrenadeTypeCryo") == 1) {SetSGLMode(SGL_Cryo);	A_SetCurrentGrenadeType("Cryo");}
	}
	
	action void PrintSGLMode()
	{
		if(findinventory("GrenadeTypeImpact")) A_Print("$PB_SGLIMPACT", 2);
		if(findinventory("GrenadeTypeSticky")) A_Print("$PB_SGLSTICKY", 2);
		if(findinventory("GrenadeTypeIncendiary")) A_Print("$PB_SGLINCEN", 2);
		if(findinventory("GrenadeTypeCryo")) A_Print("$PB_SGLCRYO", 2);
		if(findinventory("GrenadeTypeAcid")) A_Print("$PB_SGLACID", 2);	
	}
	
	action void PB_LookAndDetonateGrenades()
	{
		ThinkerIterator tit = ThinkerIterator.Create("PB_FragGrenade");
		PB_FragGrenade FG;
		while(FG = PB_FragGrenade(tit.Next()))
		{
			if(FG)
			{
				FG.detonateNow = true;
			}
		}
	}
	
}

//
//	sgl tokens
//

Class GrenadeRounds : PB_WeaponAmmo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 7;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 7;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "SGL0Z0";
	}
}

Class RespectSGL : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class GrenadeTypeImpact : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class GrenadeTypeSticky : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class GrenadeTypeIncendiary : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class GrenadeTypeCryo : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}
Class GrenadeTypeAcid : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class GrenadeDetonator : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class CycleAnimation : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}
/*
Class SGLDetonateSoundCooldown : Inventory
{
	default
	{
		Inventory.MaxAmount 22;
	}
}*/


Class SGLUnloaded : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}



//
//
//

Class PB_FragGrenade : Actor
{
	default
	{
		Radius 2;
		Height 2;
		speed 44;
		Damage 30;
		DamageType "Explosive";
		+MISSILE;
		+BLOODSPLATTER;
		+EXTREMEDEATH;
		+FORCEXYBILLBOARD;
		+CANBOUNCEWATER;
		+DONTBOUNCEONSHOOTABLES;
		+USEBOUNCESTATE;
		+BOUNCEONWALLS;
		+BOUNCEONFLOORS;
		+BOUNCEONCEILINGS;
		Bouncetype "Doom";
		BounceFactor 0.5;
		Scale 0.35;
		Gravity 1.0;
		Decal "Scorch";
		SeeSound "weapon/grenade";
		BounceSound "weapon/grenade";
		DeathSound "Explosion";
		Obituary "$OB_MPROCKET";
	}
	
	bool detonateNow;
	
	States
	{
		Spawn:
			TNT1 A 0 {
				if(waterlevel > 1) 
					spawnGrenadeTrailSmoke();
				spawnGrenadeFlare();
			}
			GRNP A 1 Bright Light("SGL_FRAG") A_Jumpif(CheckDetonation(),"Detonate");
			Loop;
		Bounce:
			TNT1 A 0;
			TNT1 A 0 {
				if(pb_sglgrenadeimpact == 1)
					return resolvestate("Death");
				else if(pb_sglgrenadeimpact >= 2)
				{
					A_Stop();
					Return resolvestate("Rest");
				}
				return resolvestate(null);
			}
			Goto spawn;
		Rest:
			GRNP A 35 Bright Light("SGL_FRAG") A_Jumpif(CheckDetonation(),"Detonate");
		Detonate:
			TNT1 A 0;
			TNT1 A 0 A_StartSound("Explosion");
		Death:
		XDeath:
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("ImpactGrenadeExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("NewRocketExploFX", 0, 0, 0);
			TNT1 A 1;
			XXXX A 0 A_Spawnprojectile ("ExplosionQuake", 1, 0, random (0, 360), 2, random (0, 160));
			TNT1 AAAAAAAAA 0 A_Spawnprojectile ("MediumExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 A 0 A_StartSound("FAREXPL",3);
			EXPL AAA 0 A_Spawnprojectile ("ExplosionSmoke", 0, 0, random (0, 360), 2, random (0, 360));
			Stop;
	}
	
	bool CheckDetonation()
	{
		return detonateNow;
	}
	
	void spawnGrenadeFlare(string flarsp = "LENYA0")
	{
		FSpawnParticleParams GrenFlar;
		GrenFlar.Texture = TexMan.CheckForTexture(flarsp);
		GrenFlar.Style = STYLE_ADD;
		GrenFlar.Color1 = "FFFFFF";
		GrenFlar.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		GrenFlar.StartRoll = random(-30,30);
		GrenFlar.StartAlpha = 0.8;
		GrenFlar.FadeStep = 0.2;
		GrenFlar.Size = random(35,52);
		GrenFlar.SizeStep = -5; 
		GrenFlar.Lifetime = 2; 
		GrenFlar.Pos = pos + (0,0,height * 0.5);
		Level.SpawnParticle(GrenFlar);
	}
	
	void spawnGrenadeTrailSmoke()
	{
		//SMK3
		FSpawnParticleParams GrenSmk;
		GrenSmk.Texture = TexMan.CheckForTexture("SMK3D0");
		GrenSmk.Color1 = "FFFFFF";
		GrenSmk.Style = STYLE_TRANSLUCENT;
		GrenSmk.Flags = SPF_ROLL;
		GrenSmk.Vel = (0,0,0);
		GrenSmk.Startroll = random(0,360);
		GrenSmk.RollVel = random(-10,10);
		GrenSmk.StartAlpha = 0.35;
		GrenSmk.Lifetime = random(24,28); 
		GrenSmk.FadeStep = 0.044;
		GrenSmk.Size = random(45,58);
		GrenSmk.SizeStep = 8;
		GrenSmk.Pos = pos;
		Level.SpawnParticle(GrenSmk);
	}
	
}

Class PB_StickyGrenade: PB_FragGrenade
{
	default
	{
		-EXPLODEONWATER
		-NOEXTREMEDEATH
		+CANBOUNCEWATER
		+BOUNCEONWALLS
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+MOVEWITHSECTOR
		+USEBOUNCESTATE
		+DONTSPLASH
		+HITTRACER
		Gravity 1.0;
		Damage 0;
		BounceFactor 0.1;
		Radius 2;
		Height 2;
		Damagetype "ExplosiveImpact";
		DeathSound "";
	}
	//var int user_stickycounter;
	//var int user_stuckEnemy;
	int stickyCounter;
	bool StuckEnemy;
	States
	{
		Spawn:
			TNT1 A 0 {
				if(waterlevel > 1) 
					spawnGrenadeTrailSmoke();
				spawnGrenadeFlare("LENRA0");
			}
			GRNP A 1 Bright Light("SGL_STICKY") A_Jumpif(CheckDetonation(),"Detonate");
			Loop;

		Bounce:
		Death:
		Crash:
			TNT1 A 0 {
				stickyCounter = 0;
				//if (AAPTR_TRACER && CheckClass ("SwitchableDecoration", AAPTR_TRACER, TRUE)) //i dont get this
				if(tracer && (tracer.bsolid || tracer.bshootable)) //&& tracer is "SwitchableDecoration")
					StuckEnemy = true;
				A_NoGravity();
				//A_ScaleVelocity(0);
				A_stop();
			}
		Stuck:
			GRNP AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 BRIGHT Light("SGL_STICKY") {
				//A_Fire(22);
				if(StuckEnemy) 
				{
					if(AAPTR_TRACER) 
						A_Warp(AAPTR_TRACER,0,0,0,0,WARPF_NOCHECKPOSITION,null,0.5);
					else 
						A_Fall();
				}
				if(CheckDetonation()) 
					return resolvestate("Detonate");
				
				return resolvestate(null);
			}
			TNT1 A 0 {
				spawnGrenadeFlare("LENRA0");
				A_StartSound("BEPBEP", 4);
				stickyCounter++;
			}
			TNT1 A 0 A_JumpIf(stickyCounter < 10, "Stuck");
			TNT1 A 0 A_StartSound("StunGrenadeDetonate", 6);
			TNT1 A 0 A_JumpIf(stickyCounter > 10, "Detonate");
			Loop;

		XDeath:
		Bounce.Creature:
			GRNP A 1 {
				//A_Changeflag("THRUClassS", 1);
				//A_Changeflag("Solid", 1);
				self.bsolid = true;
				stuckEnemy = 1;
				A_Stop();
			}
			GRNP A 1 {
				//A_Changeflag("THRUClassS", 0);
				//A_Changeflag("Solid", 0);
				//bthruclass
				self.bsolid = false;
			}
			Goto Stuck;

		Detonate:
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_StartSound("Explosion",4);
			EXPL AAA 0 A_Spawnprojectile ("BigNeoSmoke", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAA 0 A_Spawnprojectile ("ExplosionSmoke", 22, 0, random (0, 360), 2, random (0, 360));
			TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("StickyExplosion",0,0,-2,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("NewRocketExploFX", 0, 0, 0);
			TNT1 AAAAAAAAA 0 A_Spawnprojectile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAAAAAAAA 0 A_Spawnprojectile ("ExplosionParticleVeryFast", 0, 0, random (0, 360), 2, random (0, 360));
			XXXX A 0 A_Spawnprojectile ("ExplosionQuake", 1, 0, random (0, 360), 2, random (0, 160));
			TNT1 AAAAAAAAA 0 A_Spawnprojectile ("MediumExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 A 0 A_StartSound("excavator/explode", 1);
			TNT1 A 0 A_StartSound("FAREXPL",3);
			EXPL AAA 0 A_Spawnprojectile ("ExplosionSmoke", 0, 0, random (0, 360), 2, random (0, 360));
			Stop;
	}
}


Class IncendiaryGrenadeFX : Actor
{
	default
	{
		Radius 0;
		Height 0;
		RenderStyle "Add";
		Alpha 1;
		Scale 1.35;
		+NOINTERACTION
		+NOTELEPORT
		+ForceXYBillboard
	}
  //+CLIENTSIDEONLY
	States
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 0 A_StartSound("Afrit/Hellfire", CHAN_BODY);
			TNT1 A 0 A_Jump(256, "Spawn1", "Spawn2");
		Spawn1:
			X007 ABCDEFGHIJ 1 bright;
			stop;
		Spawn2:
			X007 KLMNOPQRST 1 bright;
			stop;
	}
}

Class IncendiaryGrenadeExplosion : Actor
{
	default
	{
		Radius 2;
		Height 1;
		Decal "Scorch";
		Damage 1;
		DamageType "Fire";
		Scale 1.32;
		Speed 0;
		Gravity 0;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+NOEXTREMEDEATH
		-EXTREMEDEATH
		+FORCEXYBILLBOARD
		+ALLOWPARTICLES
		//+CLIENTSIDEONLY
		+DONTSPLASH
		+PAINLESS
		-CAUSEPAIN
		-FORCEPAIN
	}
	States
	{
		Spawn:
			TNT1 A 0 A_Explode(100, 150);
			TNT1 A 0 { self.bnogravity = false; }
			TNT1 A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			FRFX ZZ 0 BRIGHT A_Spawnprojectile ("BigNeoSmoke", 2, 0, random (0, 360), 2, random (0, 360));
			EXPL AAAAA 0 A_Spawnprojectile("FT_GroundFireSpawner", 12, random(-20,20), random (0, 360), 2, random (-60, -40));
			EXPL AAAAA 0 A_Spawnprojectile("FT_GroundFireSpawner", 12, random(-20,20), random (0, 360), 2, random (-130,-50));
		Death:
			TNT1 A 1;
			Stop;
	}
}

Class CryoGrenadeExplosion : Actor
{
	default
	{
		Radius 2;
		Height 1;
		Decal "FreezerBurn";
		Damage 1;
		DamageType "Ice";
		Scale 1.32;
		Speed 0;
		Gravity 0;
		+NOBLOCKMAP
		+NOTELEPORT
		+NOEXTREMEDEATH
		-EXTREMEDEATH
		+FORCEXYBILLBOARD
		+ALLOWPARTICLES
		//+CLIENTSIDEONLY
		+DONTSPLASH
		+PAINLESS
		-CAUSEPAIN
		-FORCEPAIN
	}
	States
	{
		Spawn:
			TNT1 A 0 Bright A_Explode(100,150,0,0,150);
			TNT1 AAAA 0 Bright A_SpawnItemEx("CryoSmoke", 0, 0, 0, random(10, 30)*0.1, 0, random(0, 10)*0.1, random(1,360), SXF_NOCHECKPOSITION);
			TNT1 AAAA 0 Bright A_SpawnItemEx("CryoSmoke3", 0, 0, 0, random(10, 30)*0.04, 0, random(0, 10)*0.04, random(1,360), SXF_NOCHECKPOSITION,64);
			TNT1 AAA 0 Bright A_SpawnItemEx("CryoRifleTrailSparksSmall", random(5,-5), random(5,-5), random(5,-5), random(10, 30)*0.04, 0, random(0, 10)*0.04, random(1,360), SXF_NOCHECKPOSITION,64);
			TNT1 AAAA 0 Bright A_SpawnItemEx("CryoSmoke2", 0, 0, 0, random(10, 30)*0.04, 0, random(0, 10)*0.04, random(1,360), SXF_NOCHECKPOSITION,64);
			TNT1 AAA 0 Bright A_SpawnItemEx("IceExplosionImpact", random(-2,2), random(-2,2), random(-2,2), 0, 0, 0, random(1,360), SXF_NOCHECKPOSITION);
			TNT1 AAAAAAAAAA 0 A_SpawnItemEx ("DetectFloorIce",random(-150,150), random(-150,150),1,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCraterIce",0,0,1,0,0,0,0,SXF_NOCHECKPOSITION,0);
		Death:
			TNT1 A 1;
			Stop;
	}
}

Class PB_IncendiaryGrenade : PB_FragGrenade
{
	default
	{
		DamageType "Fire";
		Decal "BigScorch";
		SeeSound "weapon/grenade";
		DeathSound "weapons/sgl/incendiary";
	}
	States
	{
		Spawn:
			TNT1 A 0 {
				if(waterlevel > 1) A_SpawnItem ("BurningEmberParticlesFloating_Bigger");
				spawnGrenadeFlare("LEYSO0");
			}
			GRNP A 1 Bright Light("SGL_INCENDIARY") A_Jumpif(CheckDetonation(),"Detonate");
			Loop;

		Bounce:
			TNT1 A 0;
			TNT1 A 0 {
				if(pb_sglgrenadeimpact == 1)
					return resolvestate("Death");
				else if(pb_sglgrenadeimpact >= 2)
				{
					A_Stop();
					Return resolvestate("Rest");
				}
				return resolvestate(null);
			}
			Goto spawn;

		Rest:
			GRNP A 35 Bright Light("SGL_INCENDIARY") A_Jumpif(CheckDetonation(),"Detonate");
		Detonate:
			TNT1 A 0;
			TNT1 A 0 A_StartSound("weapons/sgl/incendiary");
		Death:
		XDeath:
			TNT1 A 0 A_Explode(100, 100);
			TNT1 A 0 {bnogravity = false;}
			EXPL A 0 A_SpawnItem("ExplosionParticleSpawner");
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("IncendiaryGrenadeFX", 0, 0, 0);
			TNT1 AAAA 0 A_Spawnprojectile ("FireworkSFXType2", 64, 0, random (0, 360), 2, random (30, 60));
			EXPL AAAAAAAAAA 0 A_Spawnprojectile ("FireballExplosionFlamesBig", 6, 0, random (0, 360), 2, random (0, 360));
			FRFX ZZZ 0 BRIGHT A_Spawnprojectile ("BigNeoSmoke", 2, 0, random (0, 360), 2, random (0, 360));
			EXPL AAAAA 0 A_Spawnprojectile ("FT_GroundFireSpawner", 12, random(-32,32), random (0, 360), 2, random (40, 60));
			EXPL AAAAAAAAAA 0 A_Spawnprojectile ("FT_GroundFireSpawner", random(-32,32), 0, random (0, 360), 2, random (50, 130));
			Stop;
	}
}

Class PB_CryoGrenade: PB_FragGrenade
{
	default
	{
		DamageType "Freeze";
		DeathSound "weapons/CryoRifle/missiledeath";
		Decal "FreezerBurn";
		+NODAMAGETHRUST;
		+FORCEXYBILLBOARD;
		+FORCERADIUSDMG;
		+BLOODLESSIMPACT;
	}
	States
	{

		Spawn:
			TNT1 A 0 {
				if(waterlevel > 1) A_SpawnItem ("CryoRifleTrailSparksSmall");
				spawnGrenadeFlare("LENBA0");
			}
			GRNP A 1 Bright Light("SGL_CRYO") A_Jumpif(CheckDetonation(),"Detonate");
			Loop;

		Bounce:
			TNT1 A 0;
			TNT1 A 0 {
				if(pb_sglgrenadeimpact == 1)
					return resolvestate("Death");
				else if(pb_sglgrenadeimpact >= 2)
				{
					A_Stop();
					Return resolvestate("Rest");
				}
				return resolvestate(null);
			}
			Goto spawn;

		Rest:
			GRNP A 35 Bright Light("SGL_CRYO") A_Jumpif(CheckDetonation(),"Detonate");
		Detonate:
			TNT1 A 0;
			TNT1 A 0 A_Scream();
		Death:
		XDeath:
			TNT1 A 0 Bright A_StopSound(CHAN_BODY);
			//TNT1 A 0 Bright A_ChangeFlag("ICEDAMAGE", 1);
			//TNT1 A 0 {bIceDamage = false;}
			TNT1 A 0 {bnodamagethrust = false;}
			TNT1 A 0 Bright A_Explode(200,120, 0, 0, 120);
			TNT1 AAA 0 Bright A_SpawnItemEx("CryoSmoke", 0, 0, 0, random(10, 30)*0.1, 0, random(0, 10)*0.1, random(1,360), SXF_NOCHECKPOSITION);
			TNT1 AAA 0 Bright A_SpawnItemEx("CryoSmoke3", 0, 0, 0, random(10, 30)*0.04, 0, random(0, 10)*0.04, random(1,360), SXF_NOCHECKPOSITION,64);
			TNT1 AAA 0 Bright A_SpawnItemEx("CryoRifleTrailSparksSmall", random(5,-5), random(5,-5), random(5,-5), random(10, 30)*0.04, 0, random(0, 10)*0.04, random(1,360), SXF_NOCHECKPOSITION,64);
			TNT1 AAA 0 Bright A_SpawnItemEx("CryoSmoke2", 0, 0, 0, random(10, 30)*0.04, 0, random(0, 10)*0.04, random(1,360), SXF_NOCHECKPOSITION,64);
			TNT1 AAA 0 Bright A_SpawnItemEx("IceExplosionImpact", random(-2,2), random(-2,2), random(-2,2), 0, 0, 0, random(1,360), SXF_NOCHECKPOSITION);
			TNT1 AAAAA 0 A_SpawnItemEx ("DetectFloorIce",random(-150,150), random(-150,150),1,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCraterIce",0,0,1,0,0,0,0,SXF_NOCHECKPOSITION,0);
			Stop;
	}
}

Class PB_AcidGrenade : PB_FragGrenade
{
	default
	{
		Damage 15;
		DamageType "Disintegrate";
		Decal "Scorch";
		DeathSound "Daedabus/impact";
		Obituary "$OB_MPROCKET";
	}
	States
	{
		Spawn:
			TNT1 A 0 {
				if(waterlevel > 1) {A_SpawnItem ("GreenTrailSparks"); }
				spawnGrenadeFlare("LENGA0");
			}
			GRNP A 1 Bright Light("SGL_ACID") A_Jumpif(CheckDetonation(),"Detonate");
			Loop;

		Bounce:
			TNT1 A 0;
			TNT1 A 0 {
				if(pb_sglgrenadeimpact == 1)
					return resolvestate("Death");
				else if(pb_sglgrenadeimpact >= 2)
				{
					A_Stop();
					Return resolvestate("Rest");
				}
				return resolvestate(null);
			}
			Goto spawn;

		Rest:
			GRNP A 35 Bright Light("SGL_ACID") A_Jumpif(CheckDetonation(),"Detonate");
		Detonate:
			TNT1 A 0;
			TNT1 A 0 A_StartSound("Daedabus/impact");
		Death:
		XDeath:
			TNT1 A 0 A_SpawnItem("BFGAltShockWave",0,0);
			TNT1 A 0 A_SpawnItem("ACIDFOG", 0, 0);
			TNT1 A 1;
			Stop;
	}

}



Class ACIDFOG : Actor
{
	default
	{
		Radius 2;
		Height 1;
		//Alpha .8
		Decal "Scorch";
		//RenderStyle Translucent
		Damage 1;
		DamageType "Disintegrate";
		Scale 1.32;
		Speed 0;
		Gravity 0;
		+NOBLOCKMAP
		+NOTELEPORT
		+NOEXTREMEDEATH
		-EXTREMEDEATH
		+FORCEXYBILLBOARD
		+ALLOWPARTICLES
		//+CLIENTSIDEONLY
		+DONTSPLASH
		+PAINLESS
		-CAUSEPAIN
		-FORCEPAIN
	}
	States
	{
		Spawn:
			TNT1 A 0 A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 6, 6, 6, 0, 128);
			TNT1 A 0 A_Explode ( 100, 120, 0, 0, 90 );
			TNT1 AAAAAA 0 A_SpawnItemEx("GreenCloudLarge", random(3,-3), random(3,-3), random(3,-3), random(1,-1), random(1,-1), 0, 0, SXF_NOCHECKPOSITION, 0);
			TNT1 AAAAAA 0 A_SpawnItemEx("GreenCloudMedium", random(3,-3), random(3,-3), random(3,-3), random(1,-1), random(1,-1), 0, 0, SXF_NOCHECKPOSITION, 0);
			TNT1 AAAAAA 0 A_SpawnItemEx("GreenCloudSmall", random(3,-3), random(3,-3), random(3,-3), random(1,-1), random(1,-1), 0, 0, SXF_NOCHECKPOSITION, 0);
			TNT1 AAAAA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);

			TNT1 A 0 A_SpawnItemEx("NewAcidExplosionSmoke", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
			TNT1 AAAA 2 BRIGHT Light("BARONBALL") A_SpawnItem("GreenFlare",0,20);
			Goto Death;

		Death:
			TNT1 A 60;
			Stop;
	}
}

Class ACIDFOG_GASPIPE : ACIDFOG 
{
	States 
	{
		Spawn:
			TNT1 A 0 A_Explode ( 50, 100 );
			Goto Death;
	}
}

Class GreenCloudSmall : Actor
{
	default
	{
		PROJECTILE;
		-ACTIVATEIMPACT
		-ACTIVATEPCROSS
		+NODAMAGETHRUST
		+ADDITIVEPOISONDAMAGE
		+BLOODLESSIMPACT
		+NOTELEPORT
		+RIPPER
		+NOBLOOD
		+NOEXTREMEDEATH
		-EXTREMEDEATH
		+FORCEXYBILLBOARD
		-ALLOWPARTICLES
		+DONTSPLASH
		+PAINLESS
		-CAUSEPAIN
		-FORCEPAIN
		-SOLID
		Radius 0;
		Height 0;
		Scale 0.85;
		PoisonDamage 1;
		DamageType "Disintegrate";
		PoisonDamageType "Disintegrate";
		Speed 1;
		Alpha 0.55;
		RenderStyle "add";
		Seesound "redburn";
	}
	int timer555;
	States
	{
		Spawn:
			GTXL KLMNOPQRST 1 
			{
				if(timer555 < 1)
					A_FadeIn(0.10);
			}
			TNT1 A 0 {timer555++;}
			TNT1 A 0 A_Explode ( 7, 100, 0, 40);
			GTXL TSRQPONMLK 1;
			TNT1 A 0 A_Explode ( 7, 100, 0, 40 );
			TNT1 A 0 A_JumpIf(timer555 >= 5,1);
			Loop;
			TNT1 AA 0;
			GTXL KLMNOPQRST 1  A_FadeOut( 0.10);
			Stop;
	}
}

Class GreenCloudMedium : GreenCloudSmall
{
	default
	{
		Scale 1.3;
		DamageType "Disintegrate";
	}
	States
	{
		Spawn:
			GTXL KLMNOPQRST 1 
			{
				if(timer555 < 1)
					A_FadeIn(0.10);
			}
			TNT1 A 0 {timer555++;}
			TNT1 A 0 A_Explode ( 9, 100, 0, 60);
			GTXL TSRQPONMLK 1;
			TNT1 A 0 A_Explode ( 9, 100, 0, 60);
			TNT1 A 0 A_JumpIf(timer555 >= 5,1);
			Loop;
			TNT1 AA 0;
			GTXL KLMNOPQRST 1  A_FadeOut( 0.10);
			Stop;
	}
}

Class GreenCloudLarge : GreenCloudSmall
{
	default
	{
		Scale 1.55;
		DamageType "Disintegrate";
		SeeSound "world/barrelloop";
	}
	States
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 0 A_StartSound("world/barrelloop", 4, CHANF_LOOPING);
		SpawnLoop:
			GTXL KLMNOPQRST 1 
			{
				if(timer555 < 1)
					A_FadeIn(0.10);
			}
			TNT1 A 0 {timer555++;}
			TNT1 AA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 12, 100, 0, 80);
			GTXL TSRQPONMLK 1;
			TNT1 AA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 12, 100, 0, 80);
			TNT1 A 0 A_JumpIf(timer555 >= 5,1);
			Loop;
			TNT1 AA 0;
			TNT1 A 0 A_StopSound(4);
			GTXL KLMNOPQRST 1  A_FadeOut( 0.10);
			Stop;
	}
}

Class GreenCloudMissile : Actor
{
	default
	{
		+MISSILE
		+NoGravity
		-SHOOTABLE
		+NOBLOOD
		+RIPPER
		+BLOODLESSIMPACT
		+NODAMAGETHRUST
		//+THRUClassS
		Damage 0;
		RenderStyle "add";
		DamageType "Disintegrate";
		Speed 12;
		Scale 0.25;
		Alpha 0.7;
		Seesound "redburn";
	}
	States
	{
		Spawn:
			GTXL KLMNOPQRST 1 BRIGHT Light("BARONBALL") A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 20, 100, 0);
			GTXL TSRQPONMLK 1 BRIGHT Light("BARONBALL") A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 AA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 20, 100, 0 );
			GTXL KLMNOPQRST 1 BRIGHT A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 20, 100, 0);
			GTXL TSRQPONMLK 1 BRIGHT A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 A 0 A_Explode ( 20, 100, 0 );
			TNT1 AA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 20, 100, 0 );
		Death:
			TNT1 A 0 A_StartSound("SZZLL", 3);
			TNT1 A 0 A_Explode ( 20, 100, 0 );
			TNT1 A 0 A_SpawnItem("MediumNewAcidExplosionSmoke_NoSound", 0, 0);
			GTXL TSRQPONMLK 1 A_FadeOut( 0.05);
			TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 20, 100, 0 );
			GTXL KLMNOPQRST 1  A_FadeOut( 0.05);
			Stop;
	}
}

Class GreenCloudMissile_Enemy : GreenCloudMissile
{
	default
	{
		DamageType "Disintegrate";
		Speed 10;
		Scale 0.15;
		Alpha 0.3;
		Seesound "redburn";
		-RIPPER;
		-SOLID;
		//+THRUClassS
	}
	States
	{
		Spawn:
			GTXL KLMNOPQRST 1 BRIGHT Light("BARONBALL") A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 2, 100, 0);
			GTXL TSRQPONMLK 1 BRIGHT Light("BARONBALL") A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 AA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 2, 100, 0 );
			GTXL KLMNOPQRST 1 BRIGHT A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 2, 100, 0);
			GTXL TSRQPONMLK 1 BRIGHT A_SetScale(scale.x+0.05, scale.y+0.05);
			TNT1 A 0 A_Explode ( 2, 100, 0 );
			TNT1 AA 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 2, 100, 0 );
			GTXL TSRQPONMLK 1 A_FadeOut( 0.05);
			TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(10,-10), random(10,-10), random(10,-10), random(-2, 2), random(-2, 2), random(-2, 2), 0, SXF_NOCHECKPOSITION, 0);
			TNT1 A 0 A_Explode ( 2, 100, 0 );
			Goto Death;
		Death:
			TNT1 A 0 A_StartSound("SZZLL", 3);
			TNT1 A 0 A_Explode ( 8, 100, 0 );
			TNT1 A 0 A_SpawnItem("SmallNewAcidExplosionSmoke", 0, 0);
			GTXL KLMNOPQRST 1  A_FadeOut( 0.05);
			Stop;
	}
}


//are these even used somewhere?

Class FlakShell : Actor
{
	default
	{
		Radius 2;
		Height 2;
		Speed 30;
		Scale 0.40;
		Damagefunction (random(11,12));
		DamageType "Massacre";
		+MISSILE;
		+Friendly
		+RANDOMIZE
		+BLOODSPLATTER
		+EXTREMEDEATH
		+FORCEXYBILLBOARD
		+CANBOUNCEWATER
		+DOOMBOUNCE
		-EXPLODEONWATER
		+CANBOUNCEWATER
		BounceFactor 0.75;
		Gravity 0.55;
		Decal "Scorch";
		SeeSound "";
		DeathSound "weapons/chainwiz";
		Obituary "%o was shredded by shrapnel";
		alpha 0.25;
	}
	States
	{
		Spawn:
			JNK3 ABCDEFGH 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			TNT1 A 0 A_Spawnprojectile ("SubFlakShell", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AA 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			JNK1 ABCDEFGH 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			TNT1 AA 0 A_Spawnprojectile ("SubFlakShell", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AA 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			JNK2 ABCDEFGH 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			TNT1 A 0 A_Spawnprojectile ("SubFlakShell", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AA 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			JNK1 ABCD 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			TNT1 A 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			goto Death;
		Death:
		XDeath:
			EXPL A 0 A_Explode (4, 55, 0);
			TNT1 A 1 A_SpawnItem("HitPuff");
			TNT1 AAA 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAA 0 A_Spawnprojectile ("SubFlakShell", 0, 0, random (0, 360), 2, random (0, 360));
			Stop;
	}
}

Class SubFlakShell : actor 
{
	default
	{
		Radius 1;
		Height 1;
		Speed 35;
		Scale 0.20;
		Damagefunction (random(10,11));
		DamageType "Massacre";
		+MISSILE
		+Friendly
		+RANDOMIZE
		+BLOODSPLATTER
		+EXTREMEDEATH
		+FORCEXYBILLBOARD
		+CANBOUNCEWATER
		+DOOMBOUNCE
		-EXPLODEONWATER
		+CANBOUNCEWATER
		Gravity 0.8;
		BounceFactor 0.4;
		Decal "Scorch";
		SeeSound "weapons/chainwiz";
		Obituary "%o was shredded by shrapnel";
		DeathSound "";
		alpha 0.40;
	}
	States
	{
		Spawn:
			JNK2 ABCDEFGH 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			EXPL A 0 A_Explode (random(4,5), 45, 0);
			TNT1 A 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			JNK2 ABCDEFGH 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			EXPL A 0 A_Explode (random(4,5), 45, 0);
			TNT1 A 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			JNK1 ABCDEFGH 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			EXPL A 0 A_Explode (random(4,5), 45, 0);
			TNT1 A 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			JNK3 ABCDEFGH 1 Bright A_Spawnprojectile("YellowFlareSpawn", 0, 0, 0, 0);
			EXPL A 0 A_Explode (random(4,5), 45, 0);
			TNT1 A 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			goto Death;
		Death:
		XDeath:
			TNT1 A 0;
			EXPL A 0 A_Explode (random(5,6), 55, 1);
			TNT1 AA 0 A_Spawnprojectile ("FlackTracer", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 A 1 A_SpawnItem("HitPuff");
			Stop;
	}
}