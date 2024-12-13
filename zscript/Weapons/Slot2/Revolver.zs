Class PB_Revolver : PB_WeaponBase
{
	default
	{
		//$Category Project Brutality - Weapons
		//$Sprite RVICA0
		//SpawnID 9210;
		weapon.slotnumber 2;							
		weapon.ammotype1 "PB_LowCalMag";
		weapon.ammogive1 6;	
		weapon.ammotype2 "RevolverAmmo";
		PB_WeaponBase.AmmoTypeLeft "LeftRevolverAmmo";
		inventory.pickupsound "REVOUP";
		Inventory.Pickupmessage "UAC-B750 \"Death Adder\" .500 Magnum (Slot 2)";
		Inventory.MaxAmount 3;					
		Obituary "%o was shot down by %k's revolver.";
		Tag "UAC-B750 .500 Magnum";
		scale 0.4;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.NOALERT;
		PB_WeaponBase.UnloaderToken "RevolverHasUnloaded";
		Inventory.AltHUDIcon "RVICA0";
		PB_WeaponBase.respectItem "RespectRevolver";
		FloatBobStrength 0.5;
		PB_WeaponBase.DualWieldToken "DualWieldingRevolver";
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
				A_SetInventory("RespectRevolver",1);
				A_SetInventory("PB_LockScreenTilt",1);
				A_StartSound("REVOUP",10,CHANF_OVERLAP);
				A_SetCrosshair(5);
				}
			R2V1 ABCDEFGHIJ 1{
				A_DoPBWeaponAction();
				A_SetRoll(roll+0.1, SPF_INTERPOLATE);
				}
			R2V1 KLMNOPQRST 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll-0.1, SPF_INTERPOLATE);
				}
			R2V1 U 1 A_DoPBWeaponAction();
			R2V1 VWXYZ 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll+0.2, SPF_INTERPOLATE);
				}
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			R2V2 AB 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll+0.2, SPF_INTERPOLATE);
				}
			R2V2 CDEFGHI 1{
				A_DoPBWeaponAction();
				A_SetRoll(roll-0.2, SPF_INTERPOLATE);
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
				A_DoPBWeaponAction();
				A_SetRoll(roll-0.4, SPF_INTERPOLATE);
				}
			TNT1 A 0 A_StartSound("Weapons/Revolver/Close");
			R2V5 QRSTUVWX 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll+0.2, SPF_INTERPOLATE);
				}
			R2V5 YZ 1 A_DoPBWeaponAction();
			R2V6 ABCDEFGHIJKLM 1 A_DoPBWeaponAction();
			TNT1 A 0 A_SetRoll(0);
			Goto Ready3;
		
		Select:
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
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 A_zoomfactor(1.0);
			TNT1 A 0 A_SetInventory("Zoomed",0);
			40V1 FGHI 0;
			R1V1 FGHI 1 {	if(A_CheckAkimbo())A_SetWeaponSprite("40V1");	}
			TNT1 A 0 A_lower(120);
			wait;
			
		ready:
		Ready3:
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
		
		Fire:
			TNT1 A 0 PB_jumpIfHasBarrel("ThrowBarrel","ThrowFlameBarrel","ThrowIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			TNT1 A 0 A_jumpifinventory("zoomed",1,"Fire2");
			R4V1 A 1 BRIGHT {	
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
					A_Fireprojectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revolver");
					A_Takeinventory("RevolverAmmo",1);
					A_ZoomFactor(0.96);
					//A_GunFlash;
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
			TNT1 A 0 A_ZoomFactor(1.0);
			R4V1 GH 1 A_jumpif(JustPressed(BT_ATTACK),"FanFire");
			R1V1 EE 1 {
				if(JustPressed(BT_ATTACK))
					return resolvestate("FanFire");
				A_WeaponReady(WRF_ALLOWRELOAD);
				return resolvestate(null);
			}
			TNT1 A 0 PB_ReFire();
			Goto Ready3;
		
		AltFire:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			goto AltFire_Zoom;
			
		FanFire:
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			R5V1 A 1 BRIGHT {	
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
					A_FireProjectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revolver");
					A_Takeinventory("RevolverAmmo",1);
					A_ZoomFactor(0.96);
					//A_GunFlash;
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
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			R5V1 I 1 BRIGHT {	
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
					A_FireProjectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revolver");
					A_Takeinventory("RevolverAmmo",1);
					A_ZoomFactor(0.96);
					//A_GunFlash();
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
			TNT1 A 0 {
				A_zoomfactor(1.0);
				A_setinventory("zoomed",0);
			}
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
			TNT1 A 0 PB_checkReload(null,"Ready3","NoAmmo",6,2);
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",1);
				A_StartSound("Ironsights");
			}
			R6V1 ABCDDE 1 A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIfInventory("RevolverHasUnloaded",1,"ReloadEmpty");
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open",10,CHANF_OVERLAP);
			R6V1 FGHI 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			R6V1 J 1;
			R6V1 KLMNO 1;
			TNT1 A 0 A_StartSound("Weapons/Revolver/Click2",10,CHANF_OVERLAP);
			R6V1 PQRS 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 PB_RevolverCasingSpawn("RevolverAmmo");
			R6V1 T 1;
			R6V1 U 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
		ReloadEmpty:
			TNT1 A 0 A_SetInventory("RevolverHasUnloaded", 0);
			R6V1 VWXYZ 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			R6V2 A 1 A_StartSound("Weapons/Revolver/Load",10,CHANF_OVERLAP);
			R6V2 BCDEFF 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("CYLNSPIN",10,CHANF_OVERLAP);
			TNT1 A 0 PB_AmmoIntoMag("RevolverAmmo","PB_LowCalMag",6,2);
			TNT1 A 0 PB_SpawnCasing("RevolverSpeedLoader", 45.6, 9, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
			R6V2 GHI 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Close",10,CHANF_OVERLAP);
			R6V2 JKLMNOPQQ 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_SetRoll(0);
			Goto Ready3;
		
		Unload:
			TNT1 A 0 A_SetInventory("Unloading",0);
			TNT1 A 0 {
				A_zoomfactor(1.0);
				A_setinventory("zoomed",0);
			}
			TNT1 A 0 A_JumpIF(A_CheckAkimbo(), "DualUnload");
			TNT1 A 0 A_Jumpif(countinv(invoker.UnloaderToken) > 0 || countinv(invoker.ammotype2) < 1,"Ready3");
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",1);
				A_StartSound("Ironsights");
				A_ClearOverlays(10,11);
			}
			R7V1 ABCDDE 1 A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			R7V1 FGHI 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			R7V1 J 1;
			R7V1 KLMNO 1;
			TNT1 A 0 A_StartSound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
			R7V1 PQRST 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			R7V1 U 1;
			R7V1 VWXYZ 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			TNT1 A 0 PB_UnloadMag("RevolverAmmo","PB_LowCalMag",2);
			R7V2 ABCCDE 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			R7V2 EFGHII 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_SetRoll(0);
			TNT1 A 0 A_SetInventory(invoker.UnloaderToken, 1);
			Goto Ready3;
		
		Weaponspecial:
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
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
			TNT1 A 0 A_print("You need two revolvers to dual wield!");
			Goto Ready3;
			
			
		SwitchToDualWield:
				TNT1 A 0 {
					if (A_CheckAkimbo()) 
					{
						A_SetAkimbo(False);
						A_SetInventory("DualWieldingRevolver",0); // this
						A_ClearOverlays(10,11);
						return resolvestate("SwitchFromDualWield");
					}
					
					A_SetAkimbo(True);
					A_SetInventory("DualWieldingRevolver",1); // and this
					return resolvestate(null);
				}
			R3V1 ABCDE 1 A_SetRoll(roll+0.8, SPF_INTERPOLATE);
			R3V1 E 1;
			R3V1 EFGHI 1 A_SetRoll(roll-0.8, SPF_INTERPOLATE);
			Goto ReadyDualWield;
		StopDualWield:
			TNT1 A 0 {
				A_SetAkimbo(False);
				A_SetInventory("DualWieldingRevolver",0);
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
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"zoomout");
			TNT1 A 0 {
				 A_WeaponOffset(0,32);
				 A_StartSound("IronSights", 10,CHANF_OVERLAP);
				 A_SetInventory("Zoomed",1);
				 A_ZoomFactor(1.3);
				 A_SetCrosshair(5);
			}
			R4V2 ABCDE 1;
			Goto Ready2;
		Zoomout:	
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_ZoomFactor(1.0);
				PB_HandleCrosshair(42);
			}
			R4V2 EDCBA 1;
			Goto Ready3;
		
		Ready2:
			TNT1 A 0 {
				A_SetRoll(0);
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:
			R4V2 F 1
			{		
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					
					if (PressingFire() && PressingAltfire() && CountInv("RevolverAmmo") > 0)
							return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				}
				else 
				{
					if (PressingFire() && CountInv("RevolverAmmo") > 0 )
						return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
			}
			Loop;
		
		Fire2:
			TNT1 A 0 {
					A_WeaponOffset(0,32);
					A_SetCrosshair(5);
				}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
		ActualFire2:
			R4V3 A 1 BRIGHT {	
					A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
					PB_DynamicTail("pistol", "shotgun");
					A_overlay(-6,"ADS_FireFlash");
					A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
					A_Fireprojectile("YellowFlareSpawn",0,0,0,0);
					PB_LowAmmoSoundWarning("revolver");
					A_Takeinventory("RevolverAmmo",1);
					A_ZoomFactor(1.25);
					//A_GunFlash;
					PB_WeaponRecoil(-1.15,-0.26);
					A_SetInventory("CantDoAction",1);
				}
		Fire2Continue:
			R4V3 B 1 BRIGHT {
					A_ZoomFactor(1.28);
					PB_WeaponRecoil(-1.15,-0.26);
				}
			R4V3 C 1 {
					A_ZoomFactor(1.3);
					PB_WeaponRecoil(-1.15,-0.26);
				}
			R4V3 DEFGH 1;
			TNT1 A 0 A_ZoomFactor(1.3);
			R4V2 FF 1
			{
				A_SetInventory("CantDoAction",0);
				 
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint()) 
				{
					if(JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					if (JustPressed(BT_ATTACK) && PressingAltfire())
							return resolvestate("Fire2");
				}
				else 
				{
					if(PressingAltfire())
						return resolvestate("Zoomout");
					if (JustPressed(BT_ATTACK))
							return resolvestate("Fire2");
					PB_ReFire("Fire2");
				}
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
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetFiringRightWeapon(False);
				A_SetFiringLeftWeapon(False);
				if(CountInv("LeftRevolverAmmo") < CountInv("RevolverAmmo")){
					A_GiveInventory("DualFiring",1);
				}
				A_Overlay(10, "IdleLeft_Overlay", false);
				A_Overlay(11, "IdleRight_Overlay", false);
				}
		ReadyToFireDualWield:
			TNT1 A 0 PB_SelectIfUpgrade("PB_Deagle");
			TNT1 A 1 {
				if(CountInv("PB_LowCalMag")>0)
				{
					if(CountInv("LeftRevolverAmmo")<=0 || CountInv("RevolverAmmo")<=0)
					{
						if(CountInv("LeftRevolverAmmo")<=0 && CountInv("RevolverAmmo")<=0)
							A_SetInventory("DualFireReload",2);
						else
							A_SetInventory("DualFireReload",1);
					}
				}
				
				if(!PB_CanDualWield())
					return resolvestate("StopDualWield");
				
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			Loop;
		
		IdleLeft_Overlay:
			40V1 J 1 {
				if(CountInv("LeftRevolverAmmo")<=0 && CountInv("RevolverAmmo")>0)
					A_GiveInventory("DualFiring",1);
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if((PressingAltFire() || JustPressed(BT_ALTATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar == 2)
				{
						if(CountInv("LeftRevolverAmmo") > 0)
							return resolvestate("FireLeft_Overlay");
						else 
						{
							A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
							return resolvestate(null);
						}
				}
				if(CountInv("DualFiring")==0 || (CountInv("DualFiring")==0 && CountInv("RevolverAmmo")<=0) || firemodecvar == 1)
				{
					if((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar < 2)
					{
						if(CountInv("LeftRevolverAmmo") > 0)
							return resolvestate("FireLeft_Overlay");
						else 
						{
							A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
							return resolvestate(null);
						}
					}
				}
				return resolvestate(null);
			}
			Loop;
			
		IdleRight_Overlay:
			40V1 K 1 {
				if(CountInv("LeftRevolverAmmo")>0 && CountInv("RevolverAmmo")<=0)
					A_TakeInventory("DualFiring",1);
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(CountInv("DualFiring")==1 || (CountInv("DualFiring")==1 && CountInv("LeftRevolverAmmo")<=0))
				{
					if((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar==0)
					{
						if(CountInv("RevolverAmmo") > 0)
							return resolvestate("FireRight_Overlay");
						else 
						{
							A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
							return resolvestate(null);
						}
					}
				}
				if((PressingAltfire() || JustPressed(BT_ALTATTACK)) && !A_IsFiringRightWeapon() && firemodecvar==1){
					if(CountInv("RevolverAmmo") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				if((Pressingfire() || JustPressed(BT_ATTACK)) && !A_IsFiringRightWeapon() && firemodecvar==2){
					if(CountInv("RevolverAmmo") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				return resolvestate(null);
			}
			Loop;
		
		
		FireLeft_Overlay:
			41V1 A 1 BRIGHT {	
				A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				PB_GunSmoke(5,0,0);
				PB_LowAmmoSoundWarning("revolver", "LeftRevolverAmmo");
				A_Takeinventory("LeftRevolverAmmo",1);
				A_ZoomFactor(0.99);
				A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
				PB_DynamicTail("pistol", "shotgun");
				A_AlertMonsters();
				A_SetFiringLeftWeapon(True);
				//A_GunFlash();
                PB_WeaponRecoil(-1.9,+1.8);
			}
			
			41V1 B 1 BRIGHT {
				A_ZoomFactor(1.0);
                PB_WeaponRecoil(-1.9,+1.8);
			}
			41V1 C 1 PB_WeaponRecoil(-1.9,+1.8);
			41V1 D 1;
			41V1 E 1 {
				A_SetFiringLeftWeapon(False);
				if(CountInv("LeftRevolverAmmo")<=0 || CountInv("RevolverAmmo")>0 )
					A_GiveInventory("DualFiring",1);
			}
			41V1 F 1;
			41V1 GGG 1 {
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("LeftRevolverAmmo") > 0)
						return resolvestate("FireLeft_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(Null);
					}
				}
				if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
				{
					if(CountInv("LeftRevolverAmmo") > 0)
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
				if(CountInv("LeftRevolverAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;
	
		FireRight_Overlay:
			41V1 I 1 BRIGHT {	
				A_FireProjectile("PB_500SW", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				PB_GunSmoke(-5,0,0);
				PB_LowAmmoSoundWarning("revolver");
				A_Takeinventory("RevolverAmmo",1);
				A_ZoomFactor(0.99);
				A_StartSound("revolver/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
				PB_DynamicTail("pistol", "shotgun");
				A_AlertMonsters();
				A_SetFiringRightWeapon(True);
				//A_GunFlash();
				PB_WeaponRecoil(-1.9,-1.8);
				}
			41V1 J 1 BRIGHT {
					A_ZoomFactor(1.0);
					PB_WeaponRecoil(-1.9,-1.8);
			}
			41V1 K 1 PB_WeaponRecoil(-1.9,-1.8);
			41V1 L 1;
			41V1 M 1 {
				A_SetFiringRightWeapon(False);
				if(CountInv("LeftRevolverAmmo")>0 || CountInv("RevolverAmmo")<=0 )
					A_TakeInventory("DualFiring",1);
			}
			41V1 N 1;
			41V1 OOO 1 {
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("RevolverAmmo") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar > 2){
					if(CountInv("RevolverAmmo") > 0)
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
				if(CountInv("RevolverAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;
		
		NoAmmoDualWield:
			40V1 E 1;
			Goto Ready3;
			
		ReloadLeftOnly:
			40V1 EFGHI 1;
			Goto ReloadingLeft;
			
		ReloadDualWield: 
			TNT1 A 0 
			{
				if (CountInv("RevolverAmmo") >= 6 && CountInv("LeftRevolverAmmo") >= 6) 
					return resolvestate("Ready3");
				return resolvestate(null);
			}
			TNT1 A 0 A_jumpif(countinv("PB_LowCalMag") < 2,"NoAmmoDualWield");
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",1);
				A_Startsound("Ironsights");
				A_ClearOverlays(10,11);
			}
			TNT1 A 0 A_JumpIfInventory("RevolverAmmo", 6, "ReloadLeftOnly");
			TNT1 A 0 A_JumpIfInventory("RevolverHasUnloaded",1,"ReloadEmpty1");
			42V1 ABC 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			42V1 DEF 1 A_SetRoll(roll+0.3, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
			42V1 GHIJKLM 1 A_SetRoll(roll+0.4, SPF_INTERPOLATE);
			42V1 NO 1;
			TNT1 A 0 PB_RevolverCasingSpawn("RevolverAmmo");
			42V1 PQ 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
		ReloadEmpty1:
			42V1 RSTUV 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			42V1 W 1 A_Startsound("Weapons/Revolver/Load", 10,CHANF_OVERLAP);
			42V1 XYZ 1;
			TNT1 A 0 A_Startsound("CYLNSPIN", 10,CHANF_OVERLAP);
			42V2 ABBC 1	A_SetRoll(roll+0.6, SPF_INTERPOLATE);
			TNT1 A 0 PB_AmmoIntoMag("RevolverAmmo","PB_LowCalMag",6,2);
			TNT1 A 0 PB_SpawnCasing("RevolverSpeedLoader", 45.6, 11, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			TNT1 A 0 A_JumpIfInventory("LeftRevolverAmmo", 6, "ReloadEnd");
			42V2 DEF 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
		ReloadingLeft:
			42V2 G 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			TNT1 A 2;
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			TNT1 A 0 A_JumpIfInventory("RevolverHasUnloaded",1,"ReloadEmpty2");
			42V2 HIJ 1 A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			42V2 KLM 1 A_SetRoll(roll+0.3, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
			42V2 NOPQRST 1 A_SetRoll(roll+0.4, SPF_INTERPOLATE);
			TNT1 A 0 PB_RevolverCasingSpawn("LeftRevolverAmmo");
			42V2 UV 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
		ReloadEmpty2:
			42V2 WXYZ 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			42V3 A 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Load", 10,CHANF_OVERLAP);
			42V3 BCDE 1 A_SetRoll(roll+0.6, SPF_INTERPOLATE);
			TNT1 A 0 PB_AmmoIntoMag("LeftRevolverAmmo","PB_LowCalMag",6,2);
			TNT1 A 0 A_Startsound("CYLNSPIN", 10,CHANF_OVERLAP);
			42V3 FGGH 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			TNT1 A 0 PB_SpawnCasing("RevolverSpeedLoader", 45.6, 11, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
		ReloadEnd:
			42V3 IJKL 1;
			TNT1 A 0 A_Startsound("Ironsights", 10,CHANF_OVERLAP);
			42V3 MNOPQRSTUV 1;
			TNT1 A 0 A_SetInventory("RevolverHasUnloaded", 0);
			Goto Ready3;
		
		AlreadyUnloaded:
			TNT1 A 0 A_SetInventory("Unloading",0);
			Goto Ready3;
		
		DualUnload:
			TNT1 A 0 A_SetInventory("Unloading",0);
			TNT1 A 0 A_JumpIfInventory("RevolverHasUnloaded", 1, "AlreadyUnloaded");
			TNT1 A 0 A_JumpIf((CountInv("RevolverAmmo") < 1 && CountInv("LeftRevolverAmmo") < 1),"AlreadyUnloaded");
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",1);
				A_ClearOverlays(10,11);
			}
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			43V1 ABCDEFGHIJ 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
			43V1 KLMNOPQRST 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			TNT1 A 0 PB_UnloadMag("RevolverAmmo","PB_LowCalMag",2);
			43V1 UVW 1 A_SetRoll(roll+0.6, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			43V1 XYZ 1 A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			43V2 ABCDEF 1;
			TNT1 A 0 A_Startsound("Weapons/Revolver/Open", 10,CHANF_OVERLAP);
			43V2 GHIJKL 1 A_SetRoll(roll+0.5, SPF_INTERPOLATE);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Click2", 10,CHANF_OVERLAP);
			43V2 MNOPQR 1 A_SetRoll(roll-0.5, SPF_INTERPOLATE);
			43V2 STUVWXYZ 1;
			TNT1 A 0 A_SetInventory("RevolverHasUnloaded",1);
			TNT1 A 0 PB_UnloadMag("LeftRevolverAmmo","PB_LowCalMag",2);
			TNT1 A 0 A_Startsound("Weapons/Revolver/Close", 10,CHANF_OVERLAP);
			43V3 ABCD 1 A_SetRoll(roll+0.4, SPF_INTERPOLATE);
			43V3 EFGH 1 A_SetRoll(roll-0.4, SPF_INTERPOLATE);
		FInishUnloadDual:
			TNT1 A 0 A_SetInventory("RevolverHasUnloaded", 1);
			TNT1 A 0 A_SetInventory("Unloading",0);
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
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelAirKicking","FlashBarrelAirKicking","FlashBarrelAirKicking");
		FlashKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelKicking","FlashBarrelKicking","FlashBarrelKicking");
			TNT1 A 0 A_Jumpif(A_CheckAkimbo(), "DualFlashKicking");
			R8V1 ABCDEFGHHIJKLMN 1 A_DoPBWeaponAction();
			Goto Ready3;
		
		FlashPunching:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelPunching","FlashBarrelPunching","FlashBarrelPunching");
			TNT1 A 0 A_JumpIF(A_CheckAkimbo(), "DualFlashPunching");
			R0V1 ABCDEFGHHIJKLMN 1;
			Stop;
		FlashSlideKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKicking","FlashBarrelSlideKicking","FlashBarrelSlideKicking");
			TNT1 A 0 A_JumpIF(A_CheckAkimbo(), "DualFlashSlideKicking");
			R9V1 ABCDEFGHIJKLMNONOPQRSTUVWX 1 A_DoPBWeaponAction();
			Goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKickingStop","FlashBarrelSlideKickingStop","FlashBarrelSlideKicking");
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
			Stop;
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


Class LeftRevolverAmmo : PB_WeaponAmmo //Your weapon's magazine ammo.
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

Class RevolverAmmo : PB_WeaponAmmo
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

//revolver tokens

Class RevolverHasUnloaded: Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class RespectRevolver : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class SwitchingFromDualWieldRevolver : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class SwitchingToDualWieldRevolver : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class DualWieldingRevolver: Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}