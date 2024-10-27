Class PB_Deagle : PB_WeaponBase
{
	default
	{
		weapon.slotnumber 2;							
		weapon.ammotype1 "PB_LowCalMag";								
		weapon.ammogive1 8;		
		weapon.ammotype2 "DeagleAmmo";								
		Inventory.MaxAmount 2;
		PB_WeaponBase.unloadertoken "DeagleHasUnloaded";	
		PB_WeaponBase.respectItem "RespectDeagle";		
		PB_WeaponBase.DualWieldToken "DualWieldingDeagles";	
		Inventory.PickupSound "weapons/deagle/equip";
		inventory.pickupmessage "UAC-H54 Martian Raptor .50 (Slot 2, Upgrade)";
		Obituary "%o was popped by %k's .50 Caliber Hand Cannon.";
		Inventory.AltHUDIcon "D4E0Z0";					
		PB_WeaponBase.TailPitch 0.6;
		+weapon.CHEATNOTWEAPON;
		+weapon.noalert;
		+weapon.noautofire;
		Scale 0.48;
		Tag "UAC-H54 Martian Raptor .50";
		FloatBobStrength 0.5;
	}
	
	states
	{
	
		Spawn:
			V4E0 Z 0 NoDelay;
			D4E0 Z 10 A_PbvpFramework("V4E0");
			"####" Z 0 A_PbvpInterpolate();
			loop;
		
		WeaponRespect:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",1);
				A_SetCrosshair(5);
				}
			D4E1 ABCDEEE 1 A_DoPBWeaponAction();
			D4E1 FGHI 1 A_DoPBWeaponAction();
			TNT1 A 0 A_Startsound("weapons/smg_magfly1",18,CHANF_OVERLAP );
			TNT1 A 0 A_QuakeEx(0,0,0,12,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.6,0,0.2,0,0,0.3,0.40);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			D4E1 JKLMNOPQ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_Startsound("Ironsights",11,CHANF_OVERLAP);
			D4E1 RST 1 A_DoPBWeaponAction();
			TNT1 A 0 A_Startsound("weapons/deagle/click1",18,CHANF_OVERLAP);
			D4E1 UU 1 A_DoPBWeaponAction();
			D4E1 UUUUU 1 { A_DoPBWeaponAction(); A_weaponoffset(-0.25,-0.25,WOF_ADD);}
			D4E1 UU 1 A_DoPBWeaponAction();
			D4E1 UUUUU 1 { A_DoPBWeaponAction(); A_weaponoffset(0.25,0.25,WOF_ADD);}
			D4E1 U 1 A_DoPBWeaponAction();
			D4E1 U 1 { A_DoPBWeaponAction(); A_weaponoffset(0,32,WOF_interpolate);}
			TNT1 A 0 A_QuakeEx(0,0,0,10,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.75,0,0.25,0,0,-0.3,0.45);
			TNT1 A 0 A_startsound("PSRLFIN",24,CHANF_OVERLAP);
			D4E1 VWXYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_Startsound("Ironsights",13,CHANF_OVERLAP);
			D4E2 A 1 A_DoPBWeaponAction();
			D4E2 B 1 A_DoPBWeaponAction();
			D4E2 BBBBBBB 1 { A_DoPBWeaponAction(); A_weaponoffset(-0.75,-0.4,WOF_ADD);}
			D4E2 BB 1 A_DoPBWeaponAction();
			D4E2 BBBBBBB 1 { A_DoPBWeaponAction(); A_weaponoffset(0.75,0.4,WOF_ADD);}
			D4E2 B 1 { A_DoPBWeaponAction(); A_weaponoffset(0,32,WOF_interpolate);}
			TNT1 A 0 A_startsound("Weapons/Revolver/Click2",23,CHANF_OVERLAP);
			D4E2 CDEFG 1 A_DoPBWeaponAction();
			goto ready3;
			
		Select:
			TNT1 A 0 PB_WeaponRaise("weapons/deagle/equip");
			TNT1 A 0 PB_WeapTokenSwitch("DeagleSelected");
			TNT1 A 0 A_SetInventory("RandomHeadExploder",1);	//little test
			TNT1 A 0 PB_TakeIfUpgrade("PB_Revolver");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
			D4E0 ABCD 1 PB_SetSpriteIfUnload("D4U0");
			goto ready;
		
		Deselect:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DeselectAnimationDualWield");
			D4E0 DCBA 1 PB_SetSpriteIfUnload("D4U0");
			TNT1 A 0 A_lower(120);
			wait;
		
		Ready:
			TNT1 A 0 A_WeaponOffset(0,32);
		Ready3:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"ReadyUnloaded");
			D4E0 E 1 {
				PB_CoolDownBarrel(0, 0, 3);
return A_DoPBWeaponAction();
			}
			loop;
		ReadyUnloaded:
		Ready4:	//man i hate this
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_jumpif(invoker.ammo2.amount > 0,"Ready3");
			D1E0 A 1 A_DoPBWeaponAction();
			loop;
		
		////////////////////////////////////////////////////////////////////////
		// Main Attacks states
		////////////////////////////////////////////////////////////////////////
		
		Fire:
			TNT1 A 0 PB_jumpIfHasBarrel("ThrowBarrel","ThrowFlameBarrel","ThrowIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIfInventory("Zoomed",1,"Fire2");
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			D2E0 A 1 BRIGHT {	
					A_StartSound("weapons/deagle/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0);
					PB_DynamicTail("shotgun", "pistol_mag");
					PB_LowAmmoSoundWarning("pistol");
					A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_IncrementHeat(2);
					PB_GunSmoke(0,0,0);
					A_FireProjectile("YellowFlareSpawn",0,0,0,0);
					PB_SpawnCasing("EmptyBrassDeagle",30,0,31,-frandom(1, 2),Frandom(2,6),Frandom(3,6));
					A_Takeinventory("DeagleAmmo",1);
					A_ZoomFactor(0.96);
					PB_WeaponRecoil(-1.15,-0.36);	//-1.15, -0.26
				}
			D2E0 B 1 BRIGHT PB_WeaponRecoil(-1.15,-0.56);
			D2E0 CD 1 A_ZoomFactor(0.98);
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"EndFireNoAmmo");
			D2E0 E 1;
			D2E0 FG 1 A_ZoomFactor(1.0);
			D4E0 EEEE 1 {
				if (JustPressed(BT_ATTACK))
					return resolvestate("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOPRIMARY);
			}
			TNT1 A 0 PB_Refire();
			Goto Ready3;
		
		EndFireNoAmmo:
			D2E2 E 1;
			D2E2 FG 1 A_ZoomFactor(1.0);
			D1E0 AAAA 1 {
				if (JustPressed(BT_ATTACK))
					return resolvestate("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOPRIMARY);
			}
			TNT1 A 0 PB_Refire();
			Goto Ready3;
			
		////////////////////////////////////////////////////////////////////////
		// Weapon Special things 
		////////////////////////////////////////////////////////////////////////
		
		WeaponSpecial:
			TNT1 A 0 A_setinventory("GoWeaponSpecialAbility",0);
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 {
				A_SetInventory("GoWeaponSpecialAbility",0);
				A_SetInventory("Zoomed",0);
				A_SetInventory("ADSmode",0);
				A_SetInventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				PB_HandleCrosshair(42);
				A_ZoomFactor(1.0);
				A_ClearOverlays(10,11);
				}
			TNT1 A 0 A_jumpif(A_CheckAkimbo(),"StopDualWield");
			TNT1 A 0 A_JumpIfInventory(invoker.getclassname(), 2,"SwitchToDualWield");
			TNT1 A 0 A_Print("You need two Deagles to dual wield!");
			Goto Ready3;
		SwitchToDualWield:
			TNT1 A 0 A_SetInventory("CantDoAction", 1);
			TNT1 A 0 {
				A_SetAkimbo(True);
				A_Startsound("Ironsights",15,CHANF_OVERLAP);
				//A_Startsound("weapons/deagle/equip",10,CHANF_OVERLAP);
				A_SetInventory(invoker.DualWieldToken,1); 
			}
			D6E2 A 1 PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
			D6E2 BCD 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_Setroll(roll - 0.5, SPF_INTERPOLATE);
			}
			D6E2 EFG 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_Setroll(roll + 0.5, SPF_INTERPOLATE);
			}
			TNT1 A 0 A_SetInventory("CantDoAction", 0);
			Goto ReadyDualWield;
			
		StopDualWield:
			TNT1 A 0 A_SetInventory("CantDoAction", 1);
			TNT1 A 0 {
				A_SetAkimbo(False);
				A_Startsound("Ironsights",15,CHANF_OVERLAP);
				A_SetInventory(invoker.DualWieldToken,0);
				A_ClearOverlays(10,11);
				//A_Startsound("weapons/deagle/equip",10,CHANF_OVERLAP);
			}
			D6E2 GFE 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_Setroll(roll + 0.5, SPF_INTERPOLATE);
			}
			D6E2 DCBA 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_Setroll(roll - 0.5, SPF_INTERPOLATE);
			}
			D6E2 A 1 PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
			TNT1 A 0 A_SetInventory("CantDoAction", 0);
			Goto Ready3;
		
		////////////////////////////////////////////////////////////////////////
		// Reload / Unload
		////////////////////////////////////////////////////////////////////////
		
		NoAmmo:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"NoAmmoUnloaded");
			D4E0 E 1 A_StartSound("weapons/empty");
			goto ready;
		NoAmmoUnloaded:
			D1E0 A 1 A_StartSound("weapons/empty");
			goto ready;
		NoAmmoDual:
			TNT1 A 1;
			goto ready;
		
		Reload:
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_ZoomFactor(1.0);
				A_WeaponOffset(0,32);
				PB_HandleCrosshair(69);
			}
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
			TNT1 A 0 PB_checkReload("EmptyReload","Ready","NoAmmo",8,2);
			TNT1 A 0 {
				A_setinventory(invoker.UnloaderToken,0);
				A_ZoomFactor(1.0);
				A_SetCrosshair(5);
				A_SetInventory("ADSmode",0);
				A_SetInventory("Zoomed",0);
				A_SetInventory("PB_LockScreenTilt",1);
				A_Startsound("Ironsights",16,CHANF_OVERLAP);
				A_ClearOverlays(10,11);
				}

			D0E0 ABCDEFGHIJKLMNOPQRST 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",18,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			D0E0 UVWXY 1;
			TNT1 A 0 PB_AmmoIntoMag("DeagleAmmo","PB_LowCalMag",8,2);
			TNT1 A 0 A_SetInventory("DeagleHasUnloaded",0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",11,CHANF_OVERLAP);
			D0E0 Z 1;
			D0E1 ABCDEFGHI 1;
			TNT1 A 0 A_Startsound("Ironsights",13,CHANF_OVERLAP);
			D0E1 JKL 1;
			goto ready;
		
		EmptyReload:
			D1E0 ABCDEFGHI 1;
			TNT1 A 0 A_Startsound("weapons/smg_magfly1",11,CHANF_OVERLAP);
			D1E0 J 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click1",19);
			D1E0 KLMNOPQRST 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",13,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			TNT1 A 0 {
				if(!findinventory(invoker.UnloaderToken))
					PB_SpawnCasing("EmptyDeagleMag",30,12,16,1,-2,-2,false); //only drop mags if wasnt unloaded already
			}
			D1E0 UVWXYZ 1;
			D1E1 ABCDEFGHI 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magin",18,CHANF_OVERLAP);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 PB_AmmoIntoMag("DeagleAmmo","PB_LowCalMag",7,2);
			D1E1 JKLMNOPQRSTUVWXYZ 1;
			D1E2 ABC 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click1",14,CHANF_OVERLAP);
			D1E2 DEF 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click2",15,CHANF_OVERLAP);
			D1E2 GHIJKL 1;
			goto ready;
		
		ReloadDualWield:
			TNT1 A 0 {
				int am1 = countinv(invoker.ammotype1);
				int am2 = countinv(invoker.ammotype2);
				int tr = countinv("LeftDeagleAmmo");
				
				if(am1 < 2)
					return resolvestate("NoAmmoDual");	// some futureproofing
				
				if(tr >= 8 && am2 >= 8)
					return resolvestate("Ready");
				
				//A_setinventory(invoker.UnloaderToken,0);
				A_setinventory("DualFireReload",0);
				return resolvestate(null);
			}
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_jumpif(countinv("LeftDeagleAmmo") <= 0 || countinv(invoker.ammotype2) <= 1,"EmptyDualReload");
			DR30 ABCDE 1;
			TNT1 A 0 A_Startsound("Ironsights", 23,CHANF_OVERLAP);
			DR30 FGHIJ 1;
			TNT1 A 0 A_jumpif(countinv(invoker.ammotype2) >= 8,"OnlyReloadLeft");
			
		//partial but both
			DR34 ABCDE 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",22,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			DR34 FGHIJKL 1;
		PartialReloadRight:
			//right
			DR32 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("DeagleAmmo","PB_LowCalMag",8,2);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",21,CHANF_OVERLAP);
			DR32 FGHIJ 1;
			DR32 KLMNO 1;
			TNT1 A 1;
			TNT1 A 0 A_jumpif(countinv("LeftDeagleAmmo") < 8 && countinv(invoker.ammotype1) > 1,"ToPartialLeft");
			goto FinishDualReload;
			
		ToPartialLeft:
			DR35 ABCD 1;
			goto PartialReloadLeft;
		PartialReloadLeft:
			//left
			DR31 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("LeftDeagleAmmo","PB_LowCalMag",8,2);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",22,CHANF_OVERLAP);
			DR31 FGHIJ 1;
			DR31 KLMNO 1;
			TNT1 A 1;
			
			DR37 ABC 1;
			goto ready;
		
		OnlyReloadLeft:
			TNT1 A 0 A_Startsound("Ironsights", 23,CHANF_OVERLAP);
			DR33 ABCDE 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",25,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			DR33 FGHIJKL 1;
			DR31 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("LeftDeagleAmmo","PB_LowCalMag",8,2);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",14,CHANF_OVERLAP);
			DR31 FGHIJ 1;
			DR31 KLMNO 1;
			TNT1 A 1;
			
			DR37 ABC 1;
			goto ready;
		
		ToPartialRight:
			DR36 ABCD 1;
			goto PartialReloadRightFromLeft;
		
		PartialReloadRightFromLeft:
			//right
			DR32 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("DeagleAmmo","PB_LowCalMag",8,2);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",16,CHANF_OVERLAP);
			DR32 FGHIJ 1;
			DR32 KLMNO 1;
			TNT1 A 1;
			goto FinishDualReload;
			
		EmptyDualReload:
			TNT1 A 0 {
				int lda = countinv("LeftDeagleAmmo");
				int rda = countinv(invoker.ammotype2);
				if((lda <= 0 && (rda <= 0 || findinventory(invoker.unloadertoken)) )) //|| findinventory(invoker.unloadertoken))
					return resolvestate(null);
				//A_setinventory(invoker.UnloaderToken,0);
				A_setinventory("DualFireReload",0);
				if(lda <= 0)
					return resolvestate("OnlyLeftEmpty");
				
				if(rda <= 0 || findinventory(invoker.unloadertoken))
					return resolvestate("OnlyRightEmpty");
				
				return resolvestate(null);
			}
			DR00 ABCDE 1;
			TNT1 A 0 A_Startsound("Ironsights", 23,CHANF_OVERLAP);
			DR00 FGHIJKL 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",17,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			TNT1 A 0 {
				if(!findinventory(invoker.UnloaderToken))
				{
					PB_SpawnCasing("EmptyDeagleMag",30,12,16,1,-2,-2,false);
					PB_SpawnCasing("EmptyDeagleMag",30,-12,16,1,2,-2,false);
				}
			}
			DR00 MNOPQRS 1;
			DR00 TUV 1;
			//Insert Right w/left empty
			DR01 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("DeagleAmmo","PB_LowCalMag",7,2);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",16,CHANF_OVERLAP);
			DR01 FGHIJ 1;
			DR01 KLMNO 1;
			TNT1 A 1;
			//Rechamber Right w/left empty
			DR02 ABCDE 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click1",18,CHANF_OVERLAP);
			DR02 FGHIJ 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click2",17,CHANF_OVERLAP);
			DR02 KLMNOP 1;
			TNT1 A 1;
			TNT1 A 0 A_jumpif(countinv("LeftDeagleAmmo") >= 8 || countinv(invoker.ammotype1) < 2,"FinishDualReload");
			
			//raise left w/right reloaded
			DR24 ABCD 1;
			//insert left w/right reloaded
			DR11 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("LeftDeagleAmmo","PB_LowCalMag",7,2);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",19,CHANF_OVERLAP);
			DR11 FGHIJ 1;
			DR11 KLMNO 1;
			TNT1 A 1;
			//rechamber left w/ right reloaded
			DR12 ABCDE 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click1",20,CHANF_OVERLAP);
			DR12 FGHIJ 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click2",18,CHANF_OVERLAP);
			DR12 KLMNOP 1;
			TNT1 A 1;
			
			DR37 ABC 1;
			goto ready;
			
			
		OnlyLeftEmpty:
			//start left empty w/right not empty
			DR10 ABCDE 1;
			TNT1 A 0 A_Startsound("Ironsights", 23,CHANF_OVERLAP);
			DR10 FGHIJKL 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",17,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			//TNT1 A 0 A_fireprojectile("EmptyDeagleMag",5,0,-12,-4);
			TNT1 A 0 {
				if(!findinventory(invoker.UnloaderToken))
					PB_SpawnCasing("EmptyDeagleMag",30,-12,16,1,2,-2,false);
					//A_fireprojectile("EmptyDeagleMag",5,0,-12,-4);
			}
			DR10 MNOPQRS 1;
			DR10 TUV 1;
			
			//insert left w/right reloaded
			DR11 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("LeftDeagleAmmo","PB_LowCalMag",7,2);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",16,CHANF_OVERLAP);
			DR11 FGHIJ 1;
			DR11 KLMNO 1;
			TNT1 A 1;
			
			//rechamber left w/ right reloaded
			DR12 ABCDE 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click1",21,CHANF_OVERLAP);
			DR12 FGHIJ 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click2",20,CHANF_OVERLAP);
			DR12 KLMNOP 1;
			TNT1 A 1;
			TNT1 A 0 A_jumpif(countinv("DeagleAmmo") >= 8 || countinv(invoker.ammotype1) < 2,"FinishDualReload");
			goto ToPartialRight;
			//DR36 ABCD 1;
			
		OnlyRightEmpty:
			DR20 ABCDE 1;
			TNT1 A 0 A_Startsound("Ironsights", 23,CHANF_OVERLAP);
			DR20 FGHIJKL 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",20,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			//TNT1 A 0 A_fireprojectile("EmptyDeagleMag",5,0,12,-4);
			TNT1 A 0 {
				if(!findinventory(invoker.UnloaderToken))
					PB_SpawnCasing("EmptyDeagleMag",30,12,16,1,-2,-2,false);
					//A_fireprojectile("EmptyDeagleMag",5,0,12,-4);
			}
			DR20 MNOPQRS 1;
			DR20 TUV 1;
			
			//insert right w/left reloaded
			DR21 ABCDE 1;
			TNT1 A 0 PB_AmmoIntoMag("DeagleAmmo","PB_LowCalMag",7,2);
			TNT1 A 0 A_setinventory(invoker.UnloaderToken,0);
			TNT1 A 0 A_Startsound("weapons/deagle/magin",19,CHANF_OVERLAP);
			DR21 FGHIJ 1;
			DR21 KLMNO 1;
			TNT1 A 1;
			
			//rechamber right w/ left reloaded
			DR22 ABCDE 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click1",18,CHANF_OVERLAP);
			DR22 FGHIJ 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click2",17,CHANF_OVERLAP);
			DR22 KLMNOP 1;
			TNT1 A 1;
			TNT1 A 0 A_jumpif(countinv("LeftDeagleAmmo") >= 8 || countinv(invoker.ammotype1) < 2,"FinishDualReload");
			goto ToPartialLeft;
		
		FinishDualReload:
			DR37 ABC 1;
			goto ready;
			
		Unload:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_setinventory("Unloading",0);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualUnload");
			TNT1 A 0 A_Jumpif(countinv(invoker.UnloaderToken) > 0 || countinv(invoker.ammotype2) < 1,"Ready3");
			D0E0 ABCDEFGHIJ 1;
			D0E0 KLMM 1;
			D2E1 ABCD 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",16,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			TNT1 A 0 PB_UnloadMag("DeagleAmmo","PB_LowCalMag",2);
			TNT1 A 0 A_giveinventory(invoker.UnloaderToken,1);
			D2E1 E 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click2",22,CHANF_OVERLAP);
			D2E1 FGHIJK 1;
			D1E0 HGFEDCBA 1;
			goto ready3;
		
		DualUnload:
			//TNT1 A 0 A_Jumpif(countinv(invoker.UnloaderToken) > 0 || (countinv(invoker.ammotype2) < 1 && countinv("LeftDeagleAmmo") < 1),"Ready3");
			TNT1 A 0 A_Jumpif((countinv(invoker.ammotype2) < 1 && countinv("LeftDeagleAmmo") < 1),"Ready3");
			DR30 ABCDEFGHIJ 1 PB_SetDualSpriteIfUnload("DR10","DR20","DR00");
			DR34 ABCDE 1;
			TNT1 A 0 A_Startsound("weapons/deagle/magout",21,CHANF_OVERLAP);
			TNT1 A 0 A_Startsound("PSRLOUT",24,CHANF_OVERLAP);
			DR34 F 1;
			TNT1 A 0 A_Startsound("weapons/deagle/click2",19,CHANF_OVERLAP);
			TNT1 A 0 PB_UnloadMag("DeagleAmmo","PB_LowCalMag",2);
			TNT1 A 0 PB_UnloadMag("LeftDeagleAmmo","PB_LowCalMag",2);
			TNT1 A 0 A_giveinventory(invoker.UnloaderToken,1);
			//DR00 H 1;
			DR00 GFEDCBA 1;
			goto ready3;
		
		////////////////////////////////////////////////////////////////////////
		// ADS things
		////////////////////////////////////////////////////////////////////////
		
		AltFire:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"zoomout");
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1 || findinventory(invoker.unloadertoken),"Ready");
		//zoomIn:
			TNT1 A 0 {
				 A_WeaponOffset(0,32);
				 A_StartSound("IronSights", 13,CHANF_OVERLAP);
				 A_SetInventory("Zoomed",1);
				 A_ZoomFactor(1.3);
				 A_SetCrosshair(5);
			}
			D3E1 ABCDE 1;
			Goto Ready2;
		Zoomout:	
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_ZoomFactor(1.0);
				PB_HandleCrosshair(69);
			}
			D3E1 EDCBA 1;
			Goto Ready3;
		
		Ready2:
			TNT1 A 0 {
				A_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:	//ads ready loop
			D3E0 A 1
			{		
				PB_CoolDownBarrel(0, 0, 4);
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					
					if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
							return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				}
				else 
				{
					if (PressingFire() && CountInv(invoker.ammotype2) > 0 )
						return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
			}
			Loop;
		
		Fire2:
			TNT1 A 0 {
					A_WeaponOffset(0,32);
				}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			D3E0 B 1 BRIGHT {	
					PB_IncrementHeat();
					A_StartSound("weapons/deagle/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0);
					PB_DynamicTail("shotgun", "pistol_mag");
					PB_LowAmmoSoundWarning("pistol");
					A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					A_AlertMonsters();
					PB_GunSmoke(0,0,0);
					PB_IncrementHeat(2);
					A_FireProjectile("YellowFlareSpawn",0,0,0,0);
					PB_SpawnCasing("EmptyBrassDeagle",26,0,38,-frandom(1, 2),Frandom(2,6),Frandom(3,6));
					A_Takeinventory("DeagleAmmo",1);
					A_ZoomFactor(1.19);
					PB_WeaponRecoil(-0.90,-0.25);
				}
			D3E0 C 1 BRIGHT PB_WeaponRecoil(-0.90,-0.25);
			D3E0 DEF 1 A_ZoomFactor(1.2);
			D3E0 GHA 1 A_ZoomFactor(1.18);
			D3E0 AAAA 1 {
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
					//A_Refire("Fire2");
				}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			Goto Ready2;
		
		////////////////////////////////////////////////////////////////////////
		// Dual wield things
		////////////////////////////////////////////////////////////////////////
		
		//
		//	check if its in akimbo mode by using A_CheckAkimbo() function
		//	
		
		SelectAnimationDualWield:
			TNT1 A 1;
			DR37 ABC 1 {
				bool rg = invoker.ammo2.amount < 1;
				bool lg = countinv("LeftDeagleAmmo") < 1;
				if(rg && lg)
					A_SetOverlaySprite(overlayID(),"DR03");
				else if(rg)
					A_SetOverlaySprite(overlayID(),"DR23");
				else if(lg)
					A_SetOverlaySprite(overlayID(),"DR13");
			}
			goto ReadyDualWield;
		
		DeselectAnimationDualWield:
			DR37 CBA 1 {
				bool rg = invoker.ammo2.amount < 1;
				bool lg = countinv("LeftDeagleAmmo") < 1;
				if(rg && lg)
					A_SetOverlaySprite(overlayID(),"DR03");
				else if(rg)
					A_SetOverlaySprite(overlayID(),"DR23");
				else if(lg)
					A_SetOverlaySprite(overlayID(),"DR13");
			}
			TNT1 A 1 A_Lower(120);
			wait;
		
		ReadyDualWield:
			TNT1 A 0 {
					//set the overlays for the sides and other things needed, like
					A_SetRoll(0);
					PB_HandleCrosshair(42);
					A_SetInventory("PB_LockScreenTilt",0);
					A_SetFiringRightWeapon(False);
					A_SetFiringLeftWeapon(False);
					A_overlay(10,"IdleLeft_Overlay",false);
					A_overlay(11,"IdleRight_Overlay",false);
				}
		ReadyToFireDualWield:
			TNT1 A 1 {
				if(CountInv("PB_LowCalMag")>0)
				{
					if(CountInv("LeftDeagleAmmo")<=0 || CountInv("DeagleAmmo")<=0)
					{
						if(CountInv("LeftDeagleAmmo")<=0 && CountInv("DeagleAmmo")<=0)
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
			D6E1 I 1 {
				PB_CoolDownBarrel(15, 0, 6);
				if(countinv("LeftDeagleAmmo") < 1)
					A_SetWeaponFrame(9);	//A0B1C2D3E4F5G6H7I8J9
					
				if(CountInv("LeftDeagleAmmo")<=0 && CountInv("DeagleAmmo")>0)
					A_GiveInventory("DualFiring",1);
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if((PressingAltFire() || JustPressed(BT_ALTATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar == 2)
				{
						if(CountInv("LeftDeagleAmmo") > 0)
							return resolvestate("FireLeft_Overlay");
						else 
						{
							A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
							return resolvestate(null);
						}
				}
				if(CountInv("DualFiring")==0 || (CountInv("DualFiring")==0 && CountInv("DeagleAmmo")<=0) || firemodecvar == 1)
				{
					if((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar < 2)
					{
						if(CountInv("LeftDeagleAmmo") > 0)
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
			D6E0 I 1 {
				PB_CoolDownBarrel(-15, 0, 6);
				if(countinv("DeagleAmmo") < 1)
					A_SetWeaponFrame(9);	//A0B1C2D3E4F5G6H7I8J9
				
				if(CountInv("LeftDeagleAmmo")>0 && CountInv("DeagleAmmo")<=0)
					A_TakeInventory("DualFiring",1);
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(CountInv("DualFiring")==1 || (CountInv("DualFiring")==1 && CountInv("LeftDeagleAmmo")<=0))
				{
					if((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar==0)
					{
						if(CountInv("DeagleAmmo") > 0)
							return resolvestate("FireRight_Overlay");
						else 
						{
							A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
							return resolvestate(null);
						}
					}
				}
				if((PressingAltfire() || JustPressed(BT_ALTATTACK)) && !A_IsFiringRightWeapon() && firemodecvar==1){
					if(CountInv("DeagleAmmo") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				if((Pressingfire() || JustPressed(BT_ATTACK)) && !A_IsFiringRightWeapon() && firemodecvar==2){
					if(CountInv("DeagleAmmo") > 0)
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
			D6E1 A 1 BRIGHT {	
				PB_IncrementHeat(2, true);
				A_SetFiringLeftWeapon(True);
				A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,-6,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				PB_GunSmoke(15,0,6);
				PB_SpawnCasing("EmptyBrassDeagle",26,-12,38,-frandom(1, 2),Frandom(2,6),Frandom(3,6));
				A_StartSound("weapons/deagle/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0);
				PB_DynamicTail("shotgun", "pistol_mag");
				PB_LowAmmoSoundWarning("pistol", "LeftDeagleAmmo");
				A_Takeinventory("LeftDeagleAmmo",1);
				A_AlertMonsters();
				A_ZoomFactor(0.985);
				PB_WeaponRecoil(-1.92,+1.8);
			}
			D6E1 B 1 bright {
				A_ZoomFactor(1.0);
				PB_WeaponRecoil(-1.92,+2.0);
			}
			D6E1 C 1 {
				A_SetFiringLeftWeapon(False);
				if(CountInv("LeftDeagleAmmo")<=0 || CountInv("DeagleAmmo")>0 ){
					A_GiveInventory("DualFiring",1);
				}
			}
			TNT1 A 0 A_jumpif(CountInv("LeftDeagleAmmo") < 1,"EndFireNoAmmoLeft");
			D6E1 DEFGH 1;
			D6E1 II 1 {
				//refire for dual wield
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("LeftDeagleAmmo") > 0)
						return resolvestate("FireLeft_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(Null);
					}
				}
				if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
				{
					if(CountInv("LeftDeagleAmmo") > 0)
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
				if(CountInv("LeftDeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;
		
		EndFireNoAmmoLeft:
			D6E7 ABCDEF 1;
			D6E1 JJ 1 {
				//refire for dual wield
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("LeftDeagleAmmo") > 0)
						return resolvestate("FireLeft_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(Null);
					}
				}
				if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
				{
					if(CountInv("LeftDeagleAmmo") > 0)
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
				if(CountInv("LeftDeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;
	
		FireRight_Overlay:
			D6E0 A 1 BRIGHT {
					PB_IncrementHeat(2);	
					A_SetFiringRightWeapon(True);
					A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,6,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
					PB_GunSmoke(-15,0,6);
					PB_SpawnCasing("EmptyBrassDeagle",26,25,38,-frandom(1, 2),Frandom(2,6),Frandom(3,6));
					A_StartSound("weapons/deagle/fire", CHAN_Weapon, CHANF_DEFAULT, 1.0);
					PB_DynamicTail("shotgun", "pistol_mag");
					PB_LowAmmoSoundWarning("pistol");
					A_ZoomFactor(0.985);
					A_Takeinventory("DeagleAmmo",1);
					A_AlertMonsters();
					A_SetFiringRightWeapon(True);
					PB_WeaponRecoil(-1.92,-1.8);
				}
			D6E0 B 1 BRIGHT {
				A_ZoomFactor(1.0);
				PB_WeaponRecoil(-1.92,-2.0);
				}
			D6E0 C 1 {
				A_SetFiringRightWeapon(False);
				if(CountInv("LeftDeagleAmmo")>0 || CountInv("DeagleAmmo")<=0 ){
					A_TakeInventory("DualFiring",1);
				}
			}
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"EndFireNoAmmoRight");
			D6E0 DEFGH 1;
			D6E0 II 1 {
				//refire for dual wield
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("DeagleAmmo") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar > 2){
					if(CountInv("DeagleAmmo") > 0)
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
				if(CountInv("DeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;
		
		EndFireNoAmmoRight:
			D6E6 ABCDEF 1;
			D6E0 JJ 1 {
				//refire for dual wield
				int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("DeagleAmmo") > 0)
						return resolvestate("FireRight_Overlay");
					else 
					{
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
						return resolvestate(null);
					}
				}
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar > 2){
					if(CountInv("DeagleAmmo") > 0)
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
				if(CountInv("DeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;
		
		
		////////////////////////////////////////////////////////////////////////
		//	kick flashes
		////////////////////////////////////////////////////////////////////////
		
		LoadSprites:
			D8E1 A 0;
			D5E1 A 0;
			D7E1 A 0;
			DR03 A 0;
			DR13 A 0;
			DR23 A 0;
			D4U0 A 0;
			D6E2 A 0;
			D6E3 A 0;
			D6E4 A 0;
			D6E5 A 0;
			DR10 A 0;
			DR20 A 0;
			DR00 A 0;
			stop;
			
		FlashPunching:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelPunching","FlashBarrelPunching","FlashBarrelPunching");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashPunchingDual");
			D8E0 ABCDEFGGFEDCBA 1 {
				if(invoker.ammo2.amount < 1)
					A_SetOverlaySprite(overlayID(),"D8E1");
			}
			stop;
		
		FlashPunchingDual:
			TNT1 ABCDEFGGFEDCBA 1;
			//D7E0 ABCDEFGGFEDCBA 1;
			stop;
		
		FlashKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelKicking","FlashBarrelKicking","FlashBarrelKicking");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashKickingDual");
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1 || findinventory(invoker.unloadertoken),"FlashKickingUnload");
			D5E0 ABCDEFGGGFEDCBA 1;
			goto ready3;
			
		FlashKickingUnload:
			D5E1 ABCDEFGGGFEDCBA 1;
			goto ready3;
			
		FlashKickingDual:
			D7E0 ABCDEFGGGFEDCBA 1 {
				if(invoker.ammo2.amount < 1)
					A_SetOverlaySprite(overlayID(),"D7E1");
			}
			goto ready3;
			
		FlashAirKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelAirKicking","FlashBarrelAirKicking","FlashBarrelAirKicking");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashAirKickingDual");
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"FlashAirKickingUnload");
			D5E0 ABCDEFGGGGFEDCBA 1;
			goto ready3;
		
		FlashAirKickingUnload:
			D5E1 ABCDEFGGGGFEDCBA 1;
			goto ready3;
		
		FlashAirKickingDual:
			D7E0 ABCDEFGGGGFEDCBA 1 {
				if(invoker.ammo2.amount < 1)
					A_SetOverlaySprite(overlayID(),"D7E1");
			}
			goto ready3;
			
		FlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKicking","FlashBarrelSlideKicking","FlashBarrelSlideKicking");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashSlideKickingDual");
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"FlashSlideKickingUnload");
			D5E0 ABCDEFGGGGGGGGGGGGGGGFEDCBA 1;
			goto ready3;
			
		FlashSlideKickingUnload:
			D5E1 ABCDEFGGGGGGGGGGGGGGGFEDCBA 1;
			goto ready3;
			
		FlashSlideKickingDual:
			D7E0 ABCDEFGGGGGGGGGGGGGGGFEDCBA 1 {
				if(invoker.ammo2.amount < 1)
					A_SetOverlaySprite(overlayID(),"D7E1");
			}
			goto ready3;
			
		FlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKickingStop","FlashBarrelSlideKickingStop","FlashBarrelSlideKicking");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashSlideKickingStopDual");
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"FlashSlideKickingStopUnload");
			D5E0 GFEDCBA 1;
			goto ready3;
		
		FlashSlideKickingStopUnload:
			D5E1 GFEDCBA 1;
			goto ready3;
		
		FlashSlideKickingStopDual:
			D7E0 GFEDCBA 1 {
				if(invoker.ammo2.amount < 1)
					A_SetOverlaySprite(overlayID(),"D7E1");
			}
			goto ready3;
	}
	
	
	action void PB_SetSpriteIfUnload(string sp)
	{
		if(invoker.ammo2.amount < 1 || findinventory(invoker.unloadertoken))
			A_setoverlaysprite(overlayID(),sp);
	}
	
	Action void PB_SetDualSpriteIfUnload(string leftuUnl,string rightUnl,string unloaded)
	{
		bool rightunloaded = (invoker.ammo2.amount < 1 || findinventory(invoker.unloadertoken));
		bool leftunloaded = (countinv("LeftDeagleAmmo") < 1);
		if(rightunloaded && leftunloaded)
		{
			A_setoverlaysprite(overlayID(),unloaded);
			return;
		}
		if(rightunloaded)
		{
			A_setoverlaysprite(overlayID(),rightUnl);
			return;
		}
		
		if(leftunloaded)
		{
			A_setoverlaysprite(overlayID(),leftuUnl);
			return;
		}
		//A_setoverlaysprite(overlayID(),normal);
	}
}


Class DeagleAmmo : Ammo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 8;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 8;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "D4E0Z0";
	}
}

Class LeftDeagleAmmo : Ammo
{
   default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 8;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 8;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "D4E0Z0";
	}
}

Class DeagleHasUnloaded: Inventory
{
	default
	{
		Inventory.maxamount 1;
	}
}


Class RespectDeagle : Inventory
{
	default
	{
		Inventory.maxamount 1;
	}
}

Class DualWieldingDeagles: Inventory
{
	default
	{
		Inventory.maxamount 1;
	}
}

Class DeagleSelected: Inventory
{
	default
	{
		Inventory.maxamount 1;
	}
}
