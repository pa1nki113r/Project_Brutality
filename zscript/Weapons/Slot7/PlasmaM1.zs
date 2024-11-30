Class PB_M1Plasma : PB_WeaponBase
{
	default
	{
		//$Category Project Brutality - Weapons
		//$Sprite PLASA0
		weapon.slotnumber 7;							
		weapon.ammotype1 "PB_Cell";	
		Weapon.AmmoGive1 60;		
		weapon.ammotype2 "PlasmaAmmo";
		PB_WeaponBase.AmmoTypeLeft "LeftPlasmaAmmo";
		Inventory.MaxAmount 3;
		PB_WeaponBase.unloadertoken "PlasmaRifleHasUnloaded";
		PB_WeaponBase.respectItem "RespectPlasmaGun";	
		PB_WeaponBase.DualWieldToken "DualWieldingPlasma";	
		inventory.pickupmessage "UAC-M1 Plasma Rifle (Slot 7)";
		Inventory.PickupSound "7LSPICK";
		Inventory.AltHUDIcon "PLASA0";
		Tag "UAC-M1 Plasma Rifle";
		Scale 0.51;
		FloatBobStrength 0.5;
		PB_WeaponBase.OffsetRecoilX 2.5;
		PB_WeaponBase.OffsetRecoilY 2.0;
		+WEAPON.NOAUTOAIM
	}
	
	states
	{
		Spawn:
			VLAS A 0 NoDelay;
			PLAS A 10 A_PbvpFramework("VLAS");
			"####" "#" 0 A_PbvpInterpolate();
			loop;
		
		WeaponRespect:
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_SetInventory("RespectPlasmaGun",1);
				A_Setinventory("PB_LockScreenTilt",1);
				A_StartSound("Ironsights", 22,CHANF_OVERLAP);
			}
			P0R0 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			P0R1 ABCDEFGHIJKLMNOPQ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/plasma/fancybutton", 20,CHANF_OVERLAP);
			P0R1 RSTUVWXYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/plasma/cellin", 22,CHANF_OVERLAP);
			P0R2 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			P0R3 ABCDEFGH 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/carbine/fancybutton", 32,CHANF_OVERLAP);
			P0R3 JKLLLL 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("Ironsights", 22,CHANF_OVERLAP);
			P0R3 MNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/plasma/startup", 16,CHANF_OVERLAP);
			P0R4 A 1{ 
				A_FireProjectile("SmokeSpawner",0,0,15,5);
				A_FireProjectile("PlasmaFlareSpawner",0,0,15,5);
				A_FireProjectile("BlueFlareSpawn",0,0,14,5);
				A_FireProjectile("BluePlasmaParticle",random(340,350),0,6,0,0,-random(7,18));
				A_SetRoll(roll-0.4, SPF_INTERPOLATE);		
				return A_DoPBWeaponAction();
				}
			P0R4 B 1{ 
				A_FireProjectile("SmokeSpawner",0,0,15,5);
				A_FireProjectile("PlasmaFlareSpawner",0,0,14,4);
				A_FireProjectile("BlueFlareSpawn",0,0,14,5);
				A_FireProjectile("BluePlasmaParticle",random(340,350),0,6,0,0,-random(7,18) );
				A_SetRoll(roll-0.4, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			P0R4 C 1{ 
				A_FireProjectile("SmokeSpawner",0,0,15,4);
				A_FireProjectile("PlasmaFlareSpawner",0,0,15,4);
				A_FireProjectile("BlueFlareSpawn",0,0,15,5);
				A_FireProjectile("BluePlasmaParticle",random(340,350),0,6,0,0,-random(7,18) );
				A_SetRoll(roll-0.4, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			P0R4 D 1{ 
				A_FireProjectile("SmokeSpawner",0,0,15,4);
				A_FireProjectile("PlasmaFlareSpawner",0,0,15,4);
				A_FireProjectile("BlueFlareSpawn",0,0,15,5);
				A_FireProjectile("BluePlasmaParticle",random(340,350),0,6,0,0,-random(7,18) );
				A_SetRoll(roll+0.4, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			P0R4 E 1{ 
				A_FireProjectile("SmokeSpawner",0,0,15,4);
				A_FireProjectile("PlasmaFlareSpawner",0,0,15,4);
				A_FireProjectile("BlueFlareSpawn",0,0,15,5);
				A_FireProjectile("BluePlasmaParticle",random(340,350),0,6,0,0,-random(7,18) );
				A_SetRoll(roll+0.4, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			P0R4 F 1{ 
				A_FireProjectile("SmokeSpawner",0,0,16,4);
				A_FireProjectile("PlasmaFlareSpawner",0,0,16,4);
				A_FireProjectile("BlueFlareSpawn",0,0,16,5);
				A_FireProjectile("BluePlasmaParticle",random(340,350),0,6,0,0,-random(7,18) );
				A_SetRoll(roll+0.4, SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
				}
			P0R4 GHI 1 { 
				A_FireProjectile("SmokeSpawner",0,0,16,4);
				A_FireProjectile("BluePlasmaParticle",random(340,350),0,6,0,0,-random(7,18) );
				return A_DoPBWeaponAction();
				}
			P0R4 JKLMNOPQRST 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("PLREADY", 62,CHANF_OVERLAP);
			P0R4 UVWXYZ 1 A_DoPBWeaponAction();
			P0R5 ABCDEF 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("PLSDRAW", 42,CHANF_OVERLAP);
			Goto Ready3;
		
		
		Select:
			//A_SelectWeapon("PB_Pulsecannon")
			TNT1 A 0 PB_WeaponRaise("PLSDRAW");
			TNT1 A 0 PB_WeapTokenSwitch("PlasmaGunSelected");
			TNT1 A 0 A_Setinventory("HasPlasmaWeapon",1);
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "SelectAnimationDualWield");
			PLSD ABCD 1;
			goto ready;
			
		
		Deselect:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_Setinventory("Unloading",0);
			TNT1 A 0 A_Setinventory("HasPlasmaWeapon",0);
			TNT1 A 0 A_SetInventory("PlasmaGunSelected",0);
			TNT1 A 0 A_Zoomfactor(1.0);
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_startsound("PLSOFF", 4);
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma",1,"DeselectDualWield");
			PLSD DCBA 1;
			TNT1 A 0 A_lower(120);
			wait;
		
		Ready:
		Ready3:
			TNT1 A 0 {
				A_Setinventory("PB_LockScreenTilt",0);
				PB_HandleCrosshair(76);
				}
			TNT1 A 0 A_startsound("PLSIDLE",6,CHANF_LOOPING);
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "ReadyDualWield");
		ReadyToFire:
			PLSG A 0 A_Overlay(60, "AmmoCounter");
			4LSG B 0 A_DoPBWeaponAction();
			4LSG BCDEFGHI 2 A_DoPBWeaponAction();
			//TNT1 A 0 A_SelectWeapon("PB_Pulsecannon")
			Loop;
		GunEmpty:
			P1R0 A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD, PBWEAP_UNLOADED);
			Loop;
		
		////////////////////////////////////////////////////////////////////////
		// Main Attacks states
		////////////////////////////////////////////////////////////////////////
		
		Fire:
			TNT1 A 0 PB_jumpIfHasBarrel("ThrowBarrel","ThrowFlameBarrel","ThrowIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(76);
				A_Setinventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "FireDualWield");
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			PLSF A 1 BRIGHT {	
				PB_FireOffset();
				A_AlertMonsters();
				A_StartSound("PLSM9", CHAN_WEAPON, CHANF_OVERLAP);
				A_FireProjectile("Plasma_Ball", 0, 1, 0, 0);
				A_FireProjectile("ShakeYourAssMinor", 0, 0, 0, 0);
				PB_GunSmoke(0,0,0);
				PB_LowAmmoSoundWarning("hdmr");
				A_Takeinventory("PlasmaAmmo",1);
				A_ZoomFactor(.98);
				A_GunFlash();
				PB_WeaponRecoil(-0.24,+0.06);
				A_Overlay(60, "AmmoCounterTens.Firing");
				}
			PLSF B 1 bright {
				A_ZoomFactor(.99);
				PB_FireOffset();
				PB_WeaponRecoil(-0.24,+0.06);
				}
			PLSF C 1 { 
				A_ZoomFactor(1.0);
				PB_FireOffset();
				PB_WeaponRecoil(-0.24,+0.06);
				}
			TNT1 A 0 A_ReFire();
			TNT1 A 0 A_JumpIf(pb_nocooldown, "Ready3");
			TNT1 A 0 A_StartSound("weapons/plasma/startup", 15,CHANF_OVERLAP);
			TNT1 A 0 A_Setinventory("PB_LockScreenTilt",1);
			TNT1 A 0 A_StartSound("PLSCOOL",CHAN_VOICE);
			PLSG BCDEEEEEEEEEEE 1 A_FireProjectile("SmokeSpawner",0,0,0,5);
			PLSG DCB 1 A_SetRoll(roll-0.5);
			TNT1 A 0 A_Setinventory("PB_LockScreenTilt",0);
			Goto Ready3;
		
		AltFire:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			PLHE A 1 A_ClearOverlays(60, 65);
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(76);
				A_Setinventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",20);
			TNT1 A 0 {
				A_StopSound(6);
				A_AlertMonsters();
				A_StartSound("ULTCHAR", CHAN_AUTO, CHANF_OVERLAP);
			}
			PLHE ABCD 1;
			PLHE E 1 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_1",CHAN_AUTO, CHANF_OVERLAP);
			}
			PLHE F 2 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_2",CHAN_AUTO, CHANF_OVERLAP);
			}
			PLHE G 3 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_3",CHAN_AUTO, CHANF_OVERLAP);
			}
			PLHE H 3 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_4",CHAN_AUTO, CHANF_OVERLAP);
			}
			PLHE IJK 1 BRIGHT A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
			PLSA ABCD 1 BRIGHT {
				A_FireProjectile("BlueFlareSpawn",0,0,0,0);
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				if(JustPressed(BT_RELOAD))
					return resolvestate ("DeCharge");
				return resolvestate (null);
				}
		AltHold:
			TNT1 A 0 A_StartSound("PLSFULL",1,CHANF_LOOPING);
			PLSA ABCD 1 BRIGHT {
				A_SpawnItem("PlasmaGauntlet", 0, 1, 0, 0);
				A_SpawnItem("PlasmaGauntlet", 0, 1, 0, 0);
				A_FireProjectile("ShakeYourAssMinor", 0, 0, 0, 0);
				A_FireProjectile("BlueFlareSpawn",0,0,0,0);
				PB_FireOffset();
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-5,5), -15, 0, random(-2,2));
				if(JustPressed(BT_RELOAD))
					return resolvestate ("DeCharge");
				return resolvestate (null);
				}
			TNT1 A 0 A_ReFire();
			PLSG I 1 BRIGHT {
				A_StopSound(CHAN_6);
				A_StartSound("PLSULT", CHAN_WEAPON);
				A_SetBlend("Blue", 0.6, 12);
				A_ZoomFactor(0.85);
				A_FireProjectile("M1_HeatWave", 0, 0, 0, 0);
				A_SpawnItemEx ("HeatBlastEffect3",0,0,16,0,0,0,0,SXF_NOCHECKPOSITION,0);
				
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
			}
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_FireProjectile("RailGunTrailSpark_Fast", random(-32,32), 0, random(-35,35), 0, 0, random(-12,12));
			TNT1 A 0 A_GunFlash();
		CoolAfterAltFire:
			TNT1 A 0 PB_WeaponRecoilBasic(-1.15); //A_SetPitch(Pitch - 1.15)
			TNT1 A 0 A_Takeinventory("PlasmaAmmo",20);
			PLSG J 1 {
				A_ZoomFactor(0.90);
				PB_WeaponRecoil(-2.4,-1.6);
				}
			PLSG K 1 {
				A_ZoomFactor(0.95);
				PB_WeaponRecoil(-2.4,-1.6);
				}
			PLSG L 1 {
				A_ZoomFactor(0.975);
				PB_WeaponRecoil(-2.4,-1.6);
				}
			PLSG K 1 A_ZoomFactor(0.99);
			PLSG J 1 A_ZoomFactor(1.0);
			PLSU BCDE 1;
			TNT1 A 0 A_StartSound("PLSCOOL",CHAN_VOICE);
			PLSU FFFFFFFFF 2 A_FireProjectile("SmokeSpawner",0,0,0,5);
			PLSG DCB 1;
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			TNT1 A 0 A_StartSound("BEPBEP");
			Goto Ready3;
		
		DeCharge:
			TNT1 A 0 {
				A_StopSound(1);
				A_StartSound("PLSDEARG",1);
				A_ZoomFactor(1.0);
				}
			PLSA A 1 BRIGHT A_FireProjectile("BlueFlareSpawn",0,0,0,0);
			PLSA B 1 BRIGHT A_FireProjectile("BlueFlareSpawn",0,0,0,0);
			PLSA C 1 BRIGHT A_FireProjectile("BlueFlareSpawn",0,0,0,0);
			PLSA D 1 BRIGHT A_FireProjectile("BlueFlareSpawn",0,0,0,0);
			PLSA C 1 BRIGHT A_FireProjectile("BlueFlareSpawn",0,0,0,0);
			PLHE I 2 BRIGHT;
			PLHE H 1 BRIGHT;
			PLHE G 2 BRIGHT;
			PLHE F 1 BRIGHT;
			PLHE E 2 BRIGHT;
			PLHE D 1 BRIGHT;
			PLHE C 2 BRIGHT;
			PLHE B 1 BRIGHT;
			PLHE A 2 BRIGHT;
			TNT1 A 0 A_StartSound("BEPBEP", 5);
			TNT1 A 0 A_ClearReFire();
			Goto Ready3;
		
		Flash:
			TNT1 A 4;
			Goto LightDone;
		
		////////////////////////////////////////////////////////////////////////
		// Weapon Special things 
		////////////////////////////////////////////////////////////////////////
		
		WeaponSpecial:
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 {
				A_Setinventory("GoWeaponSpecialAbility",0);
				A_Setinventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(76);
				A_StartSound("Ironsights", 12,CHANF_OVERLAP);
				A_ClearOverlays(10,65);
				}
			//TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1,"StopDualWield");
			TNT1 A 0 A_JumpIfInventory("PB_M1Plasma", 2,"SwitchToDualWield");
			TNT1 A 0 A_print("You need two plasma rifles to dual wield!");
			Goto Ready3;
		
		SwitchToDualWield:
				TNT1 A 0 {
						if (A_CheckAkimbo()) 
						{
							A_SetAkimbo(False);
							A_SetInventory(invoker.DualWieldToken,0);
							A_ClearOverlays(10,11);
							A_ClearOverlays(60,65);
							return resolvestate("SwitchFromDualWield");
						}
						
						A_SetAkimbo(True);
						A_SetInventory(invoker.DualWieldToken,1); 
						return resolvestate(null);
					}
				P2R0 ABCD 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
				P2R0 EGH 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
				Goto ReadyDualWield;
		StopDualWield:
			TNT1 A 0 {
				A_SetAkimbo(False);
				A_SetInventory(invoker.DualWieldToken,0);
				A_ClearOverlays(10,11);
				A_ClearOverlays(60,65);
			}
		SwitchFromDualWield:
				P2R0 HGE 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
				P2R0 DCBA 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
				Goto Ready3;
		
		////////////////////////////////////////////////////////////////////////
		// Reload / Unload
		////////////////////////////////////////////////////////////////////////
		
		Reload:
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 A_ClearReFire();
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "ReloadDualWield");
			TNT1 A 0 PB_checkReload(null,"Ready","Ready3",60,1);
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_SetInventory("RespectPlasmaGun",1);
				A_Setinventory("PB_LockScreenTilt",1);
				A_StartSound("PLSM2RL",26,CHANF_OVERLAP);
				A_ClearOverlays(10,65);
			}
			P1R0 ABCDE 1 A_SetRoll(roll-0.2);
			P1R0 FGHIJ 1 A_SetRoll(roll+0.2);
			P1R0 J 1 Offset(1,32);
			P1R0 J 1 Offset(2,34);
			P1R0 J 1 Offset(3, 36);
			P1R0 J 1 Offset(3, 38);
			P1R0 J 5 Offset(4, 40);
			TNT1 A 0 A_JumpIfInventory("PlasmaRifleHasUnloaded",1,"ReloadUnload");
			P1R0 M 1 Offset(4, 38);
			P1R0 M 1 Offset(3, 36);
			P1R0 R 1 Offset(1, 34);
			P1R0 R 1 Offset(0, 32);
			P1R0 RQ 1 A_SetRoll(roll-0.4);
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",18,CHANF_OVERLAP);
			P1R0 PO 1 A_SetRoll(roll-0.4);
			P1R0 NMLK 1 A_SetRoll(roll-0.4);
			TNT1 A 0 PB_SpawnCasing("EmptyCell",29,random(10,12),20,0,random(-4,-2),2);
			P1R0 K 10;
			P1R0 LLLL 1 A_SetRoll(roll+0.4);
		FinishingReload:
			TNT1 A 0 A_StartSound("weapons/plasma/cellin",17,CHANF_OVERLAP);
			TNT1 A 0 PB_AmmoIntoMag("PlasmaAmmo","PB_Cell",60,1);
			TNT1 A 0 A_setinventory("PlasmaRifleHasUnloaded",0);
			P1R0 MNOP 1 A_SetRoll(roll+0.4);
			P1R0 QRSSSSTUV 1;
			P1R0 WXYZ 1 A_SetRoll(roll-0.2);
			P1R1 ABCD 1 A_SetRoll(roll+0.2);
			Goto ready3;

		ReloadUnload:
			P1R0 KK 1 Offset(4, 38) A_SetRoll(roll-0.2);
			P1R0 KK 1 Offset(3, 36) A_SetRoll(roll-0.2);
			P1R0 LL 1 Offset(1, 34) A_SetRoll(roll-0.2);
			P1R0 LL 1 Offset(0, 32) A_SetRoll(roll-0.2);
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma",1,"ReloadDualUnloadContinue");
			Goto FinishingReload;
			
			
		ReloadDualWield:
			TNT1 A 0 {
				if (CountInv("PlasmaAmmo") >= 60 && CountInv("LeftPlasmaAmmo") >= 60) 
					return resolvestate("ReadyDualWield");
				return resolvestate(null);
			}
			TNT1 A 0 A_jumpif(countinv("PB_Cell") < 1,"ReadyDualWield");
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_SetInventory("RespectPlasmaGun",1);
				A_Setinventory("PB_LockScreenTilt",1);
				A_StartSound("PLSM2RL",26,CHANF_OVERLAP);
				A_ClearOverlays(10,65);
			}
			TNT1 A 0 A_JumpIf(CountInv("PlasmaAmmo") >= 60,"ReloadLeftOnly");
		//Reload Right
			P2R1 ABC 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R1 DEF 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1;
			P1R0 J 1 Offset(1,32);
			P1R0 J 1 Offset(2,34);
			P1R0 J 1 Offset(3, 36);
			P1R0 J 1 Offset(3, 38);
			P1R0 J 5 Offset(4, 40);
			TNT1 A 0 A_JumpIfInventory("PlasmaRifleHasUnloaded",1,"ReloadUnload");
			P1R0 M 1 Offset(4, 38);
			P1R0 M 1 Offset(3, 36);
			P1R0 R 1 Offset(1, 34);
			P1R0 R 1 Offset(0, 32);
			P1R0 RQ 1 A_SetRoll(roll-0.4);
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",17,CHANF_OVERLAP);
			P1R0 PO 1 A_SetRoll(roll-0.4);
			P1R0 NMLK 1 A_SetRoll(roll-0.4);
			TNT1 A 0 PB_SpawnCasing("EmptyCell",29,random(10,12),20,0,random(-4,-2),2);
			P1R0 K 10;
			P1R0 LLLL 1 A_SetRoll(roll+0.4);
		ReloadDualUnloadContinue:
			TNT1 A 0 A_StartSound("weapons/plasma/cellin",19,CHANF_OVERLAP);
			TNT1 A 0 PB_AmmoIntoMag("PlasmaAmmo","PB_Cell",60,1);
			P1R0 MNOP 1 A_SetRoll(roll+0.4);
			P1R0 QRSSSS 1;
			TNT1 A 0 A_JumpIfInventory("LeftPlasmaAmmo",60,"ReloadRightOnlyDone");
			P1R0 TUVWXYZ 1; 
			PLSS DCBA 1;
			Goto ReloadLeft;
			
		ReloadLeftOnly:
			P2R1 A 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R2 AB 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R2 CDE 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 D 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 E 1;
			Goto ReloadLeftContinue;
			
		ReloadRightOnlyDone:
			TNT1 A 0 A_setinventory("PlasmaRifleHasUnloaded",0);
			TNT1 A 0 A_WeaponOffset(0,32);
			P2R1 GHIJK 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R1 LMNO 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			Goto Ready3;
		
		ReloadLeft:
			P1R3 WXYZ 1;
			P1R3 ABCDE 1;
		ReloadLeftContinue:	
			P1R3 E 1 Offset(-1,32);
			P1R3 E 1 Offset(-2,34);
			P1R3 E 1 Offset(-3, 36);
			P1R3 E 1 Offset(-3, 38);
			P1R3 E 5 Offset(-4, 40);
			TNT1 A 0 A_JumpIfInventory("PlasmaRifleHasUnloaded",1,"ReloadFromUnloadedLeft");
			P1R3 H 1 Offset(-4, 38);
			P1R3 H 1 Offset(-3, 36);
			P1R3 M 1 Offset(-1, 34);
			P1R3 M 1 Offset(0, 32);
			P1R3 ML 1 A_SetRoll(roll-0.4);
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",18,CHANF_OVERLAP);
			P1R3 KJ 1 A_SetRoll(roll-0.4);
			P1R3 IHGF 1 A_SetRoll(roll-0.4);
			TNT1 A 0 PB_SpawnCasing("EmptyCell",29,random(-12,-10),20,0,random(2,4),2);
			P1R3 F 10;
			P1R3 GGGG 1 A_SetRoll(roll+0.4);
		ReloadDualUnloadLeftContinue:
			TNT1 A 0 A_StartSound("weapons/plasma/cellin",21,CHANF_OVERLAP);
			TNT1 A 0 PB_AmmoIntoMag("LeftPlasmaAmmo","PB_Cell",60,1);
			TNT1 A 0 A_setinventory("PlasmaRifleHasUnloaded",0);
			P1R3 HIJK 1 A_SetRoll(roll+0.4);
			P1R3 LMNNNN 1;
			Goto FinishDualReload;
		
		ReloadFromUnloadedLeft:
			P1R3 FF 1 Offset(-4, 38) A_SetRoll(roll+0.2);
			P1R3 FF 1 Offset(-3, 36) A_SetRoll(roll+0.2);
			P1R3 GG 1 Offset(-1, 34) A_SetRoll(roll+0.2);
			P1R3 GG 1 Offset(-0, 32) A_SetRoll(roll+0.2);
			Goto ReloadDualUnloadLeftContinue;
		
		FinishDualReload:
			TNT1 A 0 A_setinventory("PlasmaRifleHasUnloaded",0);
			TNT1 A 0 A_WeaponOffset(0,32);
			P2R2 FGHIJ 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R2 KLM 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P2R1 O 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			Goto Ready3;
			
		
		Unload:
			TNT1 A 0 A_setinventory("Unloading",0);
			TNT1 A 0 A_Jumpif(countinv(invoker.UnloaderToken) > 0 || countinv(invoker.ammotype2) < 1,"Ready3");	
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma",1,"UnloadDualWield");
			TNT1 A 0 {
				A_ClearOverlays(10,65);
				A_StopSound(6);
				A_ZoomFactor(1.0);
				A_SetInventory("Unloading",0);
				A_SetInventory("ADSmode",0);
				A_SetInventory("Zoomed",0);
			}
			TNT1 A 0 A_jumpif(countinv("PlasmaAmmo") < 1,"GunEmpty");
			P1R0 ABCDE 1 A_SetRoll(roll-0.2);
			P1R0 FGHIJ 1 A_SetRoll(roll+0.2);
			P1R0 J 1 Offset(1,32);
			P1R0 J 1 Offset(2,34);
			P1R0 J 1 Offset(3, 36);
			P1R0 J 1 Offset(3, 38);
			P1R0 J 5 Offset(4, 40);
			P1R0 M 1 Offset(4, 38);
			P1R0 M 1 Offset(3, 36);
			P1R0 R 1 Offset(1, 34);
			P1R0 R 1 Offset(0, 32);
			P1R0 RQ 1;
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",22,CHANF_OVERLAP);
			TNT1 A 0 PB_UnloadMag("PlasmaAmmo","PB_Cell",1);
			P1R0 PO 1;
			P1R0 NMLK 1; 
			P1R0 K 3;
			P1R0 JIHGFEDCBA 1;
		FInishUnload:
			TNT1 A 0 A_SetInventory("PlasmaRifleHasUnloaded", 1);
			TNT1 A 0 A_SetInventory("Unloading",0);
			Goto GunEmpty;
		
		FInishUnloadDualWield:
			TNT1 A 0 A_SetInventory("PlasmaRifleHasUnloaded", 1);
			TNT1 A 0 A_SetInventory("Unloading",0);
			P1R3 D 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P2R2 EDC 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P2R2 BA 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R1 A 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			Goto ReadyDualWield;
			
		UnloadFinishedRightOnly:
			TNT1 A 0 A_SetInventory("PlasmaRifleHasUnloaded", 1);
			TNT1 A 0 A_SetInventory("Unloading",0);
			P1R0 J 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P2R1 FED 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P2R1 CBA 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			Goto ReadyDualWield;
		
		UnloadDualWield:
			TNT1 A 0 A_Jumpif(countinv(invoker.UnloaderToken) > 0 || countinv(invoker.ammotype2) < 1,"Ready3");	
			TNT1 A 0 {
				A_ClearOverlays(10,65);
				A_StopSound(6);
				A_ZoomFactor(1.0);
				A_SetInventory("Unloading",0);
				A_SetInventory("ADSmode",0);
				A_SetInventory("Zoomed",0);
			}
			TNT1 A 0 {
				if (CountInv("PlasmaAmmo") <= 0 && CountInv("LeftPlasmaAmmo") <= 0) 
					return resolvestate("ReadyDualWield");
				else if(CountInv("PlasmaAmmo") <= 0 && CountInv("LeftPlasmaAmmo") != 0)
					return resolvestate("UnloadLeftOnly");
				return resolvestate(null);
			}
			P2R1 ABC 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R1 DEF 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1;
			P1R0 J 1 Offset(1,32);
			P1R0 J 1 Offset(2,34);
			P1R0 J 1 Offset(3, 36);
			P1R0 J 1 Offset(3, 38);
			P1R0 J 5 Offset(4, 40);
			P1R0 M 1 Offset(4, 38);
			P1R0 M 1 Offset(3, 36);
			P1R0 R 1 Offset(1, 34);
			P1R0 R 1 Offset(0, 32);
			P1R0 RQ 1;
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",32,CHANF_OVERLAP);
			TNT1 A 0 PB_UnloadMag("PlasmaAmmo","PB_Cell",1);
			P1R0 PO 1;
			P1R0 NMLK 1; 
			P1R0 K 3;
			TNT1 A 0 A_JumpIf(CountInv("LeftPlasmaAmmo") < 1, "UnloadLeft");
			P1R0 JIHGFF 1;
			PLSS DCBA 1;
			Goto UnloadLeft;
			
		UnloadLeftOnly:
			P2R1 A 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R2 AB 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R2 CDE 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 D 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 E 1;
			Goto UnloadLeftContinue;
			
		UnloadLeft:
			TNT1 A 0 A_jumpif(countinv("LeftPlasmaAmmo") < 1,"UnloadFinishedRightOnly");
			P1R3 WXYZU 1 A_SetRoll(roll+0.2);
			P1R3 ABCDE 1 A_SetRoll(roll-0.2);
		UnloadLeftContinue:
			P1R3 E 1 Offset(-1,32);
			P1R3 E 1 Offset(-2,34);
			P1R3 E 1 Offset(-3, 36);
			P1R3 E 1 Offset(-3, 38);
			P1R3 E 5 Offset(-4, 40);
			P1R3 H 1 Offset(-4, 38);
			P1R3 H 1 Offset(-3, 36);
			P1R3 M 1 Offset(-1, 34);
			P1R3 M 1 Offset(-0, 32);
			P1R3 LK 1 ;
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",42,CHANF_OVERLAP);
			TNT1 A 0 PB_UnloadMag("LeftPlasmaAmmo","PB_Cell",1);
			P1R3 JI 1 ;
			P1R3 HGFE 1;
			P1R3 E 3;
			Goto FInishUnloadDualWield;
		
		////////////////////////////////////////////////////////////////////////
		// Dual wield things
		////////////////////////////////////////////////////////////////////////
		
		//
		//	check if its in akimbo mode by using A_CheckAkimbo() function
		//	
		
		SelectAnimationDualWield:
			DPRS ABCD  1;
			TNT1 A 0 A_StartSound("PLSDRAW", 12,CHANF_OVERLAP);
			goto ReadyDualWield;
			
		DeselectDualWield:
			DPRS DCBA 1;
			TNT1 A 0 A_lower(120);
			wait;
			
		ReadyDualWield:
			TNT1 A 0 {
					//set the overlays for the sides and other things needed, like
					A_SetRoll(0);
					PB_HandleCrosshair(42);
					A_SetInventory("PB_LockScreenTilt",0);
					A_SetFiringRightWeapon(False);
					A_SetFiringLeftWeapon(False);
					if(CountInv("LeftPlasmaAmmo") < CountInv("PlasmaAmmo"))
						A_GiveInventory("DualFiring",1);
					A_overlay(10,"IdleLeft_Overlay",false);
					A_overlay(11,"IdleRight_Overlay",false);
					A_Overlay(60, "AmmoCounterLeftDW");
					A_Overlay(63, "AmmoCounterRightDW");
					A_startsound("PLSIDLE",6,CHANF_LOOPING);
				}
		ReadyToFireDualWield:
			TNT1 A 1 {
				if(CountInv("PB_Cell")>0)
				{
					if(CountInv("LeftPlasmaAmmo")<=0 || CountInv("PlasmaAmmo")<=0)
					{
						if(CountInv("LeftPlasmaAmmo")<=0 && CountInv("PlasmaAmmo")<=0)
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
			DPR3 ABCDEFGH 2 {
				if(CountInv("LeftPlasmaAmmo")<=0 && CountInv("PlasmaAmmo")>0)
					A_GiveInventory("DualFiring",1);
					
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if((PressingAltFire() || JustPressed(BT_ALTATTACK)) && firemodecvar == 2)
				{
						if(CountInv("LeftPlasmaAmmo") > 0)
							return resolvestate("FireLeft_Overlay");
						else 
						{
							A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
							return resolvestate(null);
						}
				}
				if(CountInv("DualFiring")==0 || (CountInv("DualFiring")==0 && CountInv("PlasmaAmmo")<=0) || firemodecvar == 1)
				{
					if((PressingFire() || JustPressed(BT_ATTACK)) && firemodecvar < 2)
					{
						if(CountInv("LeftPlasmaAmmo") > 0)
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
			DPR4 ABCDEFGH 2 {
				if(CountInv("LeftPlasmaAmmo")<=0 && CountInv("PlasmaAmmo")>0)
					A_GiveInventory("DualFiring",1);
				
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				
				if(CountInv("DualFiring")==1 || (CountInv("DualFiring")==1 && CountInv("LeftPlasmaAmmo")<=0))
				{
					if((PressingFire() || JustPressed(BT_ATTACK)) && firemodecvar==0)
					{
						if(CountInv("PlasmaAmmo") > 0)
							return resolvestate("FireRight_Overlay");
						else 
						{
							A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
							return resolvestate(null);
						}
					}
				}
				if((PressingAltfire() || JustPressed(BT_ALTATTACK)) && firemodecvar==1){
					if(CountInv("PlasmaAmmo") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				if((Pressingfire() || JustPressed(BT_ATTACK)) && firemodecvar==2){
					if(CountInv("PlasmaAmmo") > 0)
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
			DPR2 A 1 BRIGHT {
					A_FireProjectile("Plasma_Ball", 0.1, 0, -6, -4, 0, 0);
					PB_GunSmoke(4,0,0);//A_FireProjectile("GunFireSmoke", 0, 0, -4, 0, 0, 0);
					A_StartSound("PLSM9", CHAN_WEAPON);
					A_AlertMonsters();
					A_ZoomFactor(0.99);
					PB_LowAmmoSoundWarning("hdmr");
					A_Takeinventory("LeftPlasmaAmmo",1);
					A_GunFlash();
					PB_WeaponRecoil(-1.4,+0.8);
					A_Overlay(60,"AmmoCounterLeftDW.Firing");
				}
			DPR2 B 1 BRIGHT {
					A_ZoomFactor(0.99);
					if (CountInv("LeftPlasmaAmmo")<=0 || CountInv("PlasmaAmmo")>0 )
						A_GiveInventory("DualFiring",1);
					PB_WeaponRecoil(-1.4,+0.8);
				}
			DPR2 C 1 A_ZoomFactor(1.0);
			PLSG A 0 A_Overlay(60, "AmmoCounterLeftDW");
			TNT1 A 0 {
				if(CountInv("LeftPlasmaAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;
			
		
		FireRight_Overlay:
			DPR1 A 1 BRIGHT {
					A_FireProjectile("Plasma_Ball", 0.1, 0, 6, -4, 0, 0);
					PB_GunSmoke(-4,0,0);//A_FireProjectile("GunFireSmoke", 0, 0, 4, 0, 0, 0);
					A_StartSound("PLSM9", CHAN_WEAPON);
					A_AlertMonsters();
					A_ZoomFactor(0.98);
					PB_LowAmmoSoundWarning("hdmr");
					A_Takeinventory("PlasmaAmmo",1);
					A_GunFlash();
					PB_WeaponRecoil(-1.4,-0.8);
					A_Overlay(63,"AmmoCounterRightDW.Firing");
				}
			DPR1 B 1 BRIGHT {
					A_ZoomFactor(0.99);
					if(CountInv("LeftPlasmaAmmo")>0 || CountInv("PlasmaAmmo")<=0 )
						A_TakeInventory("DualFiring",1);
					PB_WeaponRecoil(-1.4,-0.8);
				}
			DPR1 C 1 A_ZoomFactor(1.0);
			PLSG A 0 A_Overlay(63, "AmmoCounterRightDW");
			TNT1 A 0 {
				if(CountInv("PlasmaAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;
		
		
		////////////////////////////////////////////////////////////////////////
		//	kick flashes
		////////////////////////////////////////////////////////////////////////
		FlashKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelKicking","FlashBarrelKicking","FlashBarrelKicking");
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "FlashKickingDualWield");
			PLSG WXYZ 1;
			P1R2 CDEEDC 1;
			PLSG ZYXW 1;
			PLSG AA 1 ;
			Goto Ready3;
		FlashAirKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelAirKicking","FlashBarrelAirKicking","FlashBarrelAirKicking");
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "FlashAirKickingDualWield");
			PLSG WXYZ 1;
			P1R2 BCDEEDCB 1;
			PLSG ZYXW 1;
			PLSG AA 1 ;
			Goto Ready3;
		FlashSlideKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKicking","FlashBarrelSlideKicking","FlashBarrelSlideKicking");
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "FlashSlideKickingDualWield");
			PLSG WXYZ 1;
			P1R2 ABCDEFGHHHIJKLMNEDCB 1;
			PLSG ZYXW 1;
			Goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKickingStop","FlashBarrelSlideKickingStop","FlashBarrelSlideKicking");
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "FlashSlideKickingStopDualWield");
			P1R2 DCB 1;
			PLSG ZYXW 1; 
			Goto Ready3;
		FlashPunching:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelPunching","FlashBarrelPunching","FlashBarrelPunching");
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_ClearReFire();
			TNT1 A 0 A_JumpIfInventory("DualWieldingPlasma", 1, "FlashPunchingDualWield");
			PLSG WXYZ 1;
			P1R2 CDEEDC 1;
			PLSG ZYXW 1;
			PLSG AA 1;
			Stop;
		FlashPunchingDualWield:
			TNT1 A 15;
			Stop;
			
		FlashKickingDualWield:
			P3R0 ABCDEF 1;
			P3R0 F 2 A_WeaponOffset(0, 36);
			P3R0 FEDCBA 1 A_WeaponOffset(0,32);
			Goto Ready3;
			
		FlashAirKickingDualWield:
			P3R0 ABCDEF 1;
			P3R0 F 4 A_WeaponOffset(0, 36);
			P3R0 FEDCBA 1 A_WeaponOffset(0,32);
			Goto Ready3;
			
		FlashSlideKickingDualWield:
			P3R0 ABCDEF 1;
			P3R0 F 1 A_WeaponOffset(0,34);
			P3R0 GHIIJJ 1;
			P3R0 KKLLM 1;
			P3R0 FF 1 A_WeaponOffset(0,32);
			P3R0 EDCBA 1 A_WeaponOffset(0,32);
			Goto Ready3;
			
		FlashSlideKickingStopDualWield:
			P3R0 FF 1 A_WeaponOffset(0,32);
			P3R0 EDCBA 1 A_WeaponOffset(0,32);
			Goto Ready3;
		
		
		//
		//	counters
		//
		AmmoCounter: 
			PNUM ABCDEFGHIJ 0;
			"####" "#" 0 A_Overlay(61,"AmmoCounter.Ones");
		AmmoCounter.Tens: //Single plasma tens
			TNT1 "#" 1 BRIGHT {
					A_OverlayOffset(60,1,0);
					PB_SetPRCounter(60, "PlasmaAmmo", "PNUM") ;
			}
			Loop;
			
		AmmoCounter.Ones: //Single plasma ones
			TNT1 "#" 1 BRIGHT {
					A_OverlayOffset(61,6,0);
					PB_SetPRCounter(61, "PlasmaAmmo", "PNUM", true);
			}
			Loop;

		AmmoCounterTens.Firing: //plasma firing tens
			"####" "#" 0 A_Overlay(61,"AmmoCounterOnes.Firing");
			TNT1 "#" 0 A_OverlayOffset(60,1,0);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(60, "PlasmaAmmo", "PNUM");
			"####" "#" 1 BRIGHT A_OverlayOffset(60,6,1,WOF_KEEPX);
			"####" "#" 1 BRIGHT A_OverlayOffset(60,6,4,WOF_KEEPX);
			Stop;
			
		AmmoCounterOnes.Firing: //plasma firing ones
			TNT1 "#" 0 A_OverlayOffset(61,6,0);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(61, "PlasmaAmmo", "PNUM", true);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,6,1,WOF_KEEPX);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,6,4, WOF_KEEPX);
			Stop;
			
	//Dual Wield Plasma Ammo Counters
		AmmoCounterLeftDW: //left plasma tens
			"####" "#" 0 A_Overlay(61,"AmmoCounterLeftDW.Ones");
			 TNT1 "#" 1 BRIGHT {
					A_OverlayOffset(60,-73,-2);
					PB_SetPRCounter(60, "LeftPlasmaAmmo", "PNUM") ;
			}
			Loop;
			
		AmmoCounterLeftDW.Ones: //left plasma ones
			TNT1 "#" 1 BRIGHT {
					A_OverlayOffset(61,-68,-2);
					PB_SetPRCounter(61, "LeftPlasmaAmmo", "PNUM", true) ;
			}
			Loop;
				
		AmmoCounterLeftDW.Firing: //Dual plasma left tens
			"####" "#" 0 A_Overlay(61,"AmmoCounterLeftDW.Firing2");
			TNT1 "#" 0 A_OverlayOffset(60,-73,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(60, "LeftPlasmaAmmo", "PNUM");
			"####" "#" 1 BRIGHT A_OverlayOffset(60,-78,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(60,-76,2);
			Stop;
			
		AmmoCounterLeftDW.Firing2: //Dual plasma left ones
			TNT1 "#" 0 A_OverlayOffset(61,-68,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(61, "LeftPlasmaAmmo", "PNUM", true);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,-73,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,-71,2);
			Stop;
			
		AmmoCounterRightDW: //Dual plasma right tens
			"####" "#" 0 A_Overlay(64,"AmmoCounterRightDWOnes");
			TNT1 "#" 0 A_OverlayOffset(63,76,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(63, "PlasmaAmmo", "PNUM");
			Loop;
			
		AmmoCounterRightDWOnes: //Dual plasma right ones
			TNT1 "#" 0 A_OverlayOffset(64,81,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(64, "PlasmaAmmo", "PNUM", true);
			Loop;
	
		AmmoCounterRightDW.Firing: //Dual plasma right tens
			"####" "#" 0 A_Overlay(64,"AmmoCounterRightDW.Firing2");
			TNT1 "#" 0 A_OverlayOffset(63,76,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(63, "PlasmaAmmo", "PNUM");
			"####" "#" 1 BRIGHT A_OverlayOffset(63,81,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(63,79,2);
			Stop;
			
		AmmoCounterRightDW.Firing2: //Dual plasma right ones
			TNT1 "#" 0 A_OverlayOffset(64,81,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(64, "PlasmaAmmo", "PNUM", true);
			"####" "#" 1 BRIGHT A_OverlayOffset(64,86,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(64,84,2);
			Stop;
	}
	
}

//
//	tokens
//
Class PlasmaAmmo : PB_WeaponAmmo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 60;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 60;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "PLASA0";
	}
}

Class LeftPlasmaAmmo : PB_WeaponAmmo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 60;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 60;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "PLASA0";
	}
}

Class HasPlasmaWeapon: Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class RespectPlasmaGun : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class DualWieldingPlasma : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}
Class PlasmaRifleHasUnloaded : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

//
//attacks ig
//

Class PlasmaGauntlet : Actor
{
	default
	{
		Projectile;
		Height 12;
		Radius 40;
		Speed 6;
		DamageFunction random(1,2);
		//Damage (random(1,2));
		DamageType "Plasma";
		+NOEXTREMEDEATH;
		-EXTREMEDEATH;
		Obituary "%o became an electrical conductor for %k";
	}
	States
	{
		Spawn:
			TNT1 A 1;
			Stop;
	}
}

Class Plasma_Ball : FastProjectile Replaces PlasmaBall
{
	default
	{
		Radius 10;
		Height 2;
		Speed 60;
		Damage 8;
		DamageType "Plasma";
		Decal "SmallerScorch";
		Projectile;
		Gravity 0;
		+RANDOMIZE;
		
		//+SHOOTABLE;
		//-NOBLOCKMAP;
		+NOBLOCKMAP;
		+NOBLOOD;
		+NORADIUSDMG;
		+THRUSPECIES;
		+MTHRUSPECIES;
		//Species "Marines";
		//damagefactor "Blood", 0.0; damagefactor "BlueBlood", 0.0; damagefactor "GreenBlood", 0.0; damagefactor "Taunt", 0.0; damagefactor "KillMe", 0.0; damagefactor "Shrapnel", 0.0;
		//Health 5;
		
		renderstyle "Add";
		Scale 0.19;
		DeathSound "weapons/plasmax";
		//SeeSound "PLSM9";
		SeeSound "None";
		Obituary "$OB_MPPLASMARIFLE";
	}
	States
	{
		Spawn:
			DB19 ABC 1 BRIGHT Light("PLASMABALLSMALL");
			Loop;

		Xdeath:
			TNT1 A 0 A_SpawnItem ("Plasma_Puff", 0);
			TNT1 A 0 A_SpawnProjectile ("BluePlasmaFire", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAAA 0 A_SpawnProjectile ("RailGunTrailSpark", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 A 1 A_Explode(8,50,0);
			TNT1 A 4;
			TNT2 AAA 9 SpawnPlasmaSmoke();//A_SpawnProjectile ("PlasmaSmoke", 1, 0, random (0, 360), 2, -random (0, 160));
			Stop;

		Death:
			TNT1 A 0 A_SpawnItem ("Plasma_Puff", 0);
			TNT1 B 1; //A_Explode(6,50,1)
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectCeilCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnProjectile ("BluePlasmaFire", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAA 0 A_SpawnProjectile ("BluePlasmaParticle", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 B 4;
			TNT2 AAAAAA 9 SpawnPlasmaSmoke();//A_SpawnProjectile ("PlasmaSmoke", 1, 0, random (0, 360), 2, -random (0, 160));
			Stop;
	}
	
	void SpawnPlasmaSmoke()
	{
		FSpawnParticleParams Plsmk;
		Plsmk.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random(0, 25)).."0");
		Plsmk.Style = STYLE_TRANSLUCENT;
		Plsmk.Color1 = "404040";
		vector3 vls = (frandom(-0.3,0.3),frandom(-0.3,0.3),frandom(0.2,0.4));
		if(pos.z >= ceilingz - 2)
			vls.z *= -1;
		Plsmk.vel = vls;
		//Plsmk.accel = -(vls * 0.02);
		Plsmk.Flags = SPF_ROLL;
		Plsmk.StartRoll = random(0,360);
		Plsmk.RollVel = random(-4,4);
		Plsmk.StartAlpha = 1.0;
		Plsmk.FadeStep = 0.080;
		Plsmk.Size = random(50,74);
		Plsmk.SizeStep = random(2,4);
		Plsmk.Lifetime = 12; 
		Plsmk.Pos = pos;
		Level.SpawnParticle(Plsmk);
	}
}

Class M1_HeatWave : Actor
{
	default
	{
		Speed 25;
		Radius 12;
		Height 12;
		Damage 10;
		Decal "none";
		damagetype "Plasma";
		RenderStyle "Add";
		Alpha 0.4;
		Projectile;
		+RIPPER;
		-NOBOSSRIP;
		-CANNOTPUSH;
		-NODAMAGETHRUST;
		//+DontHurtSpecies;
		+RollSprite;
		+NOGRAVITY;
		//Species "Marine";
		ReactionTime 7;
		Scale 0.3;
	}

	states
	{
		Spawn:
			TNT1 A 1 NoDelay A_RadiusThrust(5000, 150, 0, 100);
			Q05S BCDEF 1 BRIGHT Light("M1HeatWave") {
				A_Setroll(roll-0.5);
				A_SetScale(Scale.X+0.02, Scale.Y+0.02);
				A_Explode(60,180,0,0,150);
				A_SpawnItemEx("HeatBlastEffect2", 0, 0, 0, 0, 0, 0, 0, 128);
				A_SpawnItemEx("HeatBlastEffect2", 0, 0, 0, 0, 0, 0, 0, 128);
				A_SpawnProjectile ("RailGunTrailSpark_Fast", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("RailGunTrailSpark_Fast", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("RailGunTrailSpark_Fast", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("RailGunTrailSpark_Fast", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("RailGunTrailSpark_Fast", 0, 0, random (0, 360), 2, random (0, 360));
			}
		Fly:
			TNT1 A 1 BRIGHT Light("M1HeatWave") {
				A_Setroll(roll-0.5);
				A_SetScale(Scale.X+0.02, Scale.Y+0.02);
				A_CountDown();
				A_Explode(60,180,0,0,150);
				A_SpawnItemEx("HeatBlastEffect1", 0, 0, 0, 0, 0, 0, 0, 128);
				A_SpawnItemEx("HeatBlastEffect2", 0, 0, 0, 0, 0, 0, 0, 128);
				A_SpawnProjectile ("RailGunTrailSpark_Fast", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("RailGunTrailSpark_Fast", 0, 0, random (0, 360), 2, random (0, 360));
			}
			Loop;

	  
		Death:
			TNT1 A 1 BRIGHT Light("M1HeatWave") A_FadeOut(0.1);
			Loop;
	}
}

Class HeatBlastEffect1 : Actor
{ 
	default
	{
		 RenderStyle "add";
		 scale 0.03;
		 alpha 0.9;
		 +rollsprite;
		 +nointeraction;
		 Translation "0:255=%[0,0,0]:[0,0.6,1]";
	}
	states
	{
		Spawn:
			 X060 A 1 BRIGHT {
				A_FadeOut(0.04);
				A_SetRoll(roll-2);
				A_SetScale(self.Scale.X+0.08);
			 }
			 loop;
	}
}

Class HeatBlastEffect2 : HeatBlastEffect1
{ 
	default
	{
		Scale 0.01;
		Alpha 0.99;
	}
	
	states
	{
		Spawn:
			 X060 B 1 BRIGHT {
				A_FadeOut(0.04);
				A_SetRoll(roll-5);
				A_SetScale(self.Scale.X+0.04);
			 }
			 loop;
	}
}

Class HeatBlastEffect3 : HeatBlastEffect1
{ 
	default
	{
		alpha 0.99;
		+FLATSPRITE;
	}
	states
	{
		Spawn:
			 X060 A 1 BRIGHT {
				A_FadeOut(0.05);
				A_SetRoll(roll-2);
				A_SetScale(self.Scale.X+0.3);
			 }
			 loop;
	}
}

Class UltPlasma_Ball : Plasma_Ball
{
	states
	{
		Death:
			TNT1 A 0 A_SpawnItem ("Plasma_Puff", 0);
			TNT1 B 1 A_Explode(4,50,0);
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectCeilCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnProjectile ("BluePlasmaFire", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAA 0 A_SpawnProjectile ("BluePlasmaParticle", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 B 4;
			TNT2 AAAAAA 9 A_SpawnProjectile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
			Stop;
	}
}

//not sure if these are even used
Class PlasmaBall75 : Plasma_Ball
{
	default
	{
		SeeSound "PLSM9";
	}
}

Class PlasmaBall76: Plasma_Ball
{
	default
	{
		SeeSound "PLSULT";
	}
}
Class PlasmaBall65: Plasma_Ball
{
	default
	{
		SeeSound "PLSM4";
	}
}


Class EnemyPlasmaBall : PlasmaBall75
{
	default
	{
		DamageFunction random(10,15);
		//Damage (random(10,15));
		DamageType "Plasma";
		Speed 40;
		//Species "NotMarines";
		-THRUACTORS;
		-THRUSPECIES;
		-MTHRUSPECIES;
		+THRUGHOST;
	}
	States 
	{
		Spawn:
			DB19 ABC 2 BRIGHT Light("PLASMABALLSMALL");
			Loop;
	}
}


Class ZombiePlasma : EnemyPlasmaBall
{
	default
	{
		Radius 8;
		Height 2;
		DamageFunction random(5,7);
		//Damage (random(5,7));
		Scale 0.18;
	}
}


/*
Class PB_M1PlasmaPickup : PB_UpgradeItem
{
	default
	{
		Inventory.PickupSound "";
		Inventory.PickupMessage "UAC-M1 Plasma Rifle (Slot 7)";
		Inventory.MaxAmount 3;
		Tag "UAC-M1 Plasma Rifle";
		Scale 0.51;
		FloatBobStrength 0.5;
	}
	States
	{
	Spawn:
		VLAS A 0 NoDelay
		PLAS A 10 A_PbvpFramework("VLAS")
		"####" "#" 0 A_PbvpInterpolate()
		LOOP
// I'm sorry if this is a fucking hackjob, but it's the only way I can prevent
// the M1 Plasma pickup from happen if the ammo count is full.
	Pickup:
		TNT1 A 0 {
			if(CountInv("PB_Cell") == 300 && CountInv("PB_M1Plasma") >=3  ) {
				return state("FullAmmo");
				}
			else if(CountInv("PB_Cell") == 600 && CountInv("PB_M1Plasma") >=3  ) {
				return state("FullAmmo");
				}
			else if(CountInv("PB_Cell") == 800 && CountInv("PB_M1Plasma") >=3  ) {
				return state("FullAmmo");
				}
				return state("");
			}
		TNT1 A 0 {
			A_GiveInventory("PB_M1Plasma");
			if(GetCvar("nodoomguytalk") >= 1) {
				A_StartSound("7LSPICK",3,CHANF_NOPAUSE );
				}
			else {
				A_StartSound("PLSPICK",3,CHANF_NOPAUSE );
				}
		}
		Stop
	FullAmmo:
		TNT1 A 1
		TNT1 A 0
		Fail
	}
}
*/
