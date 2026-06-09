Class PB_M1Plasma : PB_WeaponBase
{
	default
	{
		//$Category Project Brutality - Weapons
		//$Sprite PL4SA0
		weapon.slotnumber 7;							
		weapon.ammotype1 "PB_Cell";	
		Weapon.AmmoGive1 40;		
		weapon.ammotype2 "PB_M1PlasmaMag";
		PB_WeaponBase.AmmoTypeLeft "PB_M1PlasmaLeftMag";
		Inventory.MaxAmount 2;
		inventory.pickupmessage "$PB_M1_PICKUP";
		Inventory.PickupSound "7LSPICK";
		Inventory.AltHUDIcon "PL4SA0";
		Tag "$PB_M1_Tag";
		Scale 0.51;
		FloatBobStrength 0.5;
		PB_WeaponBase.OffsetRecoilX 2.5;
		PB_WeaponBase.OffsetRecoilY 2.0;
	}
	
	override void AttachToOwner(Actor Other)
	{
		Super.AttachToOwner(other);
		if(!PB_HelpNotificationsHandler.CheckTipEvent(1 << 12, CVar.GetCvar("pb_helpflags", Other.Player))) {
			Array<String> pbTipsBuf;
			pbTipsBuf.Push("$PB_BARREL_TIP_3");
			PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 12);
		}
	}
	
	states
	{
		Spawn:
			VLAS A 0 NoDelay;
			PL4S A 10 A_PbvpFramework("VLAS");
			"####" "#" 0 A_PbvpInterpolate();
			loop;
		
		WeaponRespect:
			TNT1 A 0 {
				A_SetCrosshair(-1);
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
			TNT1 A 0 PB_HandleCrosshair(71);
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
			PLSD ABCD 1;
			goto ready;
			
		
		Deselect:
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_Setinventory("Unloading",0);
			TNT1 A 0 A_Setinventory("HasPlasmaWeapon",0);
			TNT1 A 0 A_SetInventory("PlasmaGunSelected",0);
			TNT1 A 0 A_Zoomfactor(1.0);
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_StopSound(26);
			TNT1 A 0 A_startsound("PLSOFF", 4);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"DeselectDualWield");
			PLSD EFGH 1;
			TNT1 A 0 A_lower(120);
			wait;
		
		Ready:
		Ready3:
			TNT1 A 0 {
				A_Setinventory("PB_LockScreenTilt",0);
				PB_HandleCrosshair(71);
				}
			TNT1 A 0 A_startsound("PLSIDLE",6,CHANF_LOOPING);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
		ReadyToFire:
			P1SG A 0 A_Overlay(60, "AmmoCounter");
			4LSG B 0 A_DoPBWeaponAction();
			4LSG BBCCDDEEFFGGHHII 1 A_DoPBWeaponAction();
			//TNT1 A 0 A_SelectWeapon("PB_Pulsecannon")
			Loop;
		GunEmpty:
			4LSG J 1 {
				A_ClearOverlays(60,61);
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD, PBWEAP_UNLOADED);
			}
			Loop;
		////////////////////////////////////////////////////////////////////////
		// Main Attacks states
		////////////////////////////////////////////////////////////////////////
		
		FireRecoil:
			/*
			TNT1 A 1 {
				A_OverlayPivotAlign(PSP_WEAPON,PSPA_CENTER,PSPA_TOP);
				A_OverlayScale(PSP_WEAPON,1.20,1.0,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
			}
			TNT1 A 1 {
				A_OverlayPivotAlign(PSP_WEAPON,PSPA_CENTER,PSPA_TOP);
				A_OverlayScale(PSP_WEAPON,1.15,1.15,WOF_INTERPOLATE);
				//A_OverlayScale(60,1.15,1.15,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
			}
			TNT1 A 1 {
				A_OverlayPivotAlign(PSP_WEAPON,PSPA_CENTER,PSPA_TOP);
				A_OverlayPivotAlign(60,PSPA_CENTER,PSPA_TOP);
				A_OverlayScale(PSP_WEAPON,1.10,1.10,WOF_INTERPOLATE);
				A_OverlayScale(60,1.10,1.10,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
				A_OverlayOffset(60,0,32);
			}
			*/
			TNT1 A 1 {
				A_OverlayPivotAlign(PSP_WEAPON,PSPA_CENTER,PSPA_TOP);
				A_OverlayPivotAlign(60,PSPA_CENTER,PSPA_TOP);
				A_OverlayOffset(PSP_WEAPON,0,32);
				A_OverlayOffset(60,0,2,WOF_KEEPX|WOF_ADD);
			}
			TNT1 A 1 {
				A_OverlayScale(PSP_WEAPON,1.05,1.05,WOF_INTERPOLATE);
				A_OverlayScale(60,1.05,1.05,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
				A_OverlayOffset(60,0,-1,WOF_KEEPX|WOF_ADD);
			}
			TNT1 A 0 {
				A_OverlayScale(PSP_WEAPON,1.00,1.00,WOF_INTERPOLATE);
				A_OverlayScale(60,1.00,1.00,WOF_INTERPOLATE);
				A_OverlayOffset(60,0,-1,WOF_KEEPX|WOF_ADD);
			}
			stop;
		
		MuzzleFlashCenter:
			P1SF D 1 BRIGHT {A_SetWeaponFrame(3 + random(0, 2)); A_GunFlash();}
			P1SF G 1 BRIGHT {A_SetWeaponFrame(6 + random(0, 2)); A_GunFlash();}
			stop;
		
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(71);
				A_Setinventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FireDualWield");
			TNT1 A 0 PB_jumpIfNoAmmo();
			P1SF A 1 BRIGHT {	
				A_Overlay(-5,"FireRecoil");
				PB_FireOffset();
				A_AlertMonsters();
				A_StartSound("PLSM9", CHAN_WEAPON, CHANF_OVERLAP);
				A_FireProjectile("Plasma_Ball", 0, 1, 0, 0);
				//A_FireProjectile("ShakeYourAssMinor", 0, 0, 0, 0);
				PB_GunSmoke(0,0,0);
                PB_MuzzleFlashEffects(0, 0, 0, "1265ff");
				PB_LowAmmoSoundWarning("hdmr");
				PB_TakeAmmo("PB_M1PlasmaMag",1,0);
				A_ZoomFactor(.98);
				PB_WeaponRecoil(-0.24,+0.06);
				A_Overlay(60, "AmmoCounterTens.Firing");
				A_Overlay(-3,"MuzzleFlashCenter");
				A_OverlayFlags(-3,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-3,STYLE_Add);
				}
			P1SF B 1 bright {
				A_ZoomFactor(.99);
				PB_FireOffset();
				PB_WeaponRecoil(-0.24,+0.06);
				}
			P1SF C 1 { 
				A_ZoomFactor(1.0);
				PB_FireOffset();
				PB_WeaponRecoil(-0.24,+0.06);
				}
			TNT1 A 0 A_ReFire();
			TNT1 A 0 A_StartSound("weapons/plasma/startup", 15,CHANF_OVERLAP);
			TNT1 A 0 A_Setinventory("PB_LockScreenTilt",1);
			TNT1 A 0 A_StartSound("PLSCOOL",CHAN_VOICE);
			P1SG BCDEEEEEEEEEEE 1 A_FireProjectile("SmokeSpawner",0,0,0,5);
			P1SG DCB 1 A_SetRoll(roll-0.5);
			TNT1 A 0 A_Setinventory("PB_LockScreenTilt",0);
			TNT1 A 0 PB_ReFire();
			Goto Ready3;
		
		AltFireRecoil:
			TNT1 A 1 {
				A_OverlayPivotAlign(PSP_WEAPON,PSPA_CENTER,PSPA_TOP);
				A_OverlayScale(PSP_WEAPON,1.30,1.0,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
			}
			TNT1 A 1 {
				A_OverlayScale(PSP_WEAPON,1.225,1.0,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
			}
			TNT1 A 1 {
				A_OverlayScale(PSP_WEAPON,1.15,1.0,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
			}
			TNT1 A 1 {
				A_OverlayScale(PSP_WEAPON,1.075,1.0,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
			}
			TNT1 A 0 {
				A_OverlayScale(PSP_WEAPON,1.00,1.0,WOF_INTERPOLATE);
				A_OverlayOffset(PSP_WEAPON,0,32);
			}
			stop;
		AltHoldFlash:
			PLSM ABCD 1 BRIGHT A_GunFlash();
			stop;
		AltFire:
			TNT1 A 0 PB_jumpIfNoAmmo(min:20);
			PLHE A 1 A_ClearOverlays(60, 65);
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(71);
				A_Setinventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 {
				A_StopSound(6);
				A_AlertMonsters();
				A_StartSound("ULTCHAR", CHAN_AUTO, CHANF_OVERLAP);
			}
			
			PLHE ABCD 1 A_GunFlash2();
			PLHE E 1 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_1",CHAN_AUTO, CHANF_OVERLAP);
			}
			//TNT1 A 0 A_Takeinventory("PB_M1PlasmaMag",5);
			TNT1 A 0 A_Overlay(60, "AmmoCounter");
			PLHE F 2 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_2",CHAN_AUTO, CHANF_OVERLAP);
				A_GunFlash2();
			}
			//TNT1 A 0 A_Takeinventory("PB_M1PlasmaMag",5);
			PLHE G 3 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_3",CHAN_AUTO, CHANF_OVERLAP);
				A_GunFlash2();
			}
			//TNT1 A 0 A_Takeinventory("PB_M1PlasmaMag",5);
			PLHE H 3 BRIGHT {
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				A_StartSound("PLSC_4",CHAN_AUTO, CHANF_OVERLAP);
				A_GunFlash2();
			}
			//TNT1 A 0 A_Takeinventory("PB_M1PlasmaMag",5);
			PLHE IJK 1 BRIGHT A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
			TNT1 A 0 {
				A_ClearOverlays(60, 65);
				A_Overlay(-3,"AltHoldFlash");
				A_OverlayFlags(-3,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-3,STYLE_Add);
			}
			PLSA ABCD 1 BRIGHT {
				A_FireProjectile("BlueFlareSpawn",0,0,0,0);
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-2,2), -15, 0, random(-2,2));
				if(JustPressed(BT_RELOAD))
					return resolvestate("DeCharge");
				return resolvestate(null);
				}
		AltHold:
			TNT1 A 0 {
				A_StartSound("PLSFULL",1,CHANF_LOOPING);
				A_Overlay(-3,"AltHoldFlash");
				A_OverlayFlags(-3,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-3,STYLE_Add);
			}
			PLSA ABCD 1 BRIGHT {
				if(JustReleased(BT_ALTATTACK)){return resolvestate("AltBlast");}
				A_SpawnItem("PlasmaGauntlet", 0, 1, 0, 0);
				A_SpawnItem("PlasmaGauntlet", 0, 1, 0, 0);
				A_FireProjectile("ShakeYourAssMinor", 0, 0, 0, 0);
				A_FireProjectile("BlueFlareSpawn",0,0,0,0);
				PB_FireOffset();
				A_FireProjectile("RailGunTrailSpark_Fast", random(-2,2), 0, random(-5,5), -15, 0, random(-2,2));
				if(JustPressed(BT_RELOAD))
					return resolvestate("DeCharge");
				return resolvestate(null);
				}
		AltBlast:
			TNT1 A 0 A_ReFire();
			P1SG I 1 BRIGHT {
				A_Overlay(-5,"AltFireRecoil");
				A_StopSound(CHAN_6);
				A_StartSound("PLSULT", CHAN_WEAPON);
				A_SetBlend("Blue", 0.6, 12);
				EventHandler.SendInterfaceEvent(PlayerNumber(), "PB_HUDInterference", 20);
				A_ZoomFactor(0.85);
				A_FireProjectile("M1_HeatWave", 0, 0, 0, 0);
				A_SpawnItemEx("HeatBlastEffect3",0,0,16,0,0,0,0,SXF_NOCHECKPOSITION,0);
				
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
				A_FireProjectile("GunFireSmokeBig", 0, 0, 0, 0, 0, 0);
			}
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_FireProjectile("RailGunTrailSpark_Fast", random(-32,32), 0, random(-35,35), 0, 0, random(-12,12));
		CoolAfterAltFire:
			TNT1 A 0 {
				PB_WeaponRecoilBasic(-1.15); //A_SetPitch(Pitch - 1.15)
				PB_TakeAmmo("PB_M1PlasmaMag",20,0);
			}
			P1SG J 1 {
				A_ZoomFactor(0.90);
				PB_WeaponRecoil(-2.4,-1.6);
				}
			P1SG K 1 {
				A_ZoomFactor(0.95);
				PB_WeaponRecoil(-2.4,-1.6);
				}
			P1SG L 1 {
				A_ZoomFactor(0.975);
				PB_WeaponRecoil(-2.4,-1.6);
				}
			P1SG K 1 A_ZoomFactor(0.99);
			P1SG J 1 A_ZoomFactor(1.0);
			PLSU BCDE 1;
			TNT1 A 0 A_StartSound("PLSCOOL",CHAN_VOICE);
			PLSU FFFFFFFFF 2 A_FireProjectile("SmokeSpawner",0,0,0,5);
			P1SG DCB 1;
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(),"Ready3");
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
			TNT1 A 0 {
				A_Setinventory("GoWeaponSpecialAbility",0);
				A_Setinventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(71);
				A_StartSound("Ironsights", 12,CHANF_OVERLAP);
				A_ClearOverlays(10,65);
				}
			TNT1 A 0 A_JumpIfInventory("PB_M1Plasma", 2,"SwitchToDualWield");
			TNT1 A 0 A_print("$PB_M1_NOAKIMBO");
			Goto Ready3;
		
		SwitchToDualWield:
				TNT1 A 0 {
						if(A_CheckAkimbo()) 
						{
							A_SetAkimbo(False);
							A_ClearOverlays(10,11);
							A_ClearOverlays(60,65);
							return resolvestate("SwitchFromDualWield");
						}
						
						A_SetAkimbo(True);
						if(PB_GetMagUnloaded())
							A_Overlay(2,"OverlayGunEmpty");
						return resolvestate(null);
					}
				P2R0 ABC 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
				P2R0 DEFG 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
				P2R0 H 1 {
					if(PB_GetMagUnloaded(true))
						A_Overlay(10,"LeftGunEmpty");
					if(PB_GetMagUnloaded())
						A_Overlay(11,"RightGunEmpty");
				}
				Goto ReadyDualWield;
		SwitchFromDualWield:
				TNT1 A 0 {
					if(PB_GetMagUnloaded(true))
						A_Overlay(10,"LeftGunEmpty");
					if(PB_GetMagUnloaded())
						A_Overlay(11,"RightGunEmpty");
				}
				P2R0 HGF 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
				P2R0 EDCB 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
				P2R0 A 1 {
					if(PB_GetMagUnloaded())
						A_Overlay(2,"OverlayGunEmpty");
				}
				Goto Ready3;
		OverlayGunEmpty:
			4LSG J 1;
			Stop;
		LeftGunEmpty:
			DPR3 I 1;
			Stop;
		RightGunEmpty:
			DPR4 I 1;
			Stop;
		////////////////////////////////////////////////////////////////////////
		// Reload / Unload
		////////////////////////////////////////////////////////////////////////
		
		Reload:
			TNT1 A 0 A_ClearReFire();
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
			TNT1 A 0 PB_CheckReload(null,null,null,"Ready","Ready3",60);
			TNT1 A 0 {
				A_StartSound("PLSM2RL",26,CHANF_OVERLAP);
				A_ClearOverlays(2,2);
				A_ClearOverlays(60,65);
				if(PB_GetMagUnloaded())
					A_Overlay(2,"OverlayGunEmpty");
			}
			P1R0 ABCDE 1 A_SetRoll(roll-0.2);
			P1R0 FGHIJ 1 A_SetRoll(roll+0.2);
			P1R0 J 1 A_WeaponOffset(1,32);
			P1R0 J 1 A_WeaponOffset(2,34);
			P1R0 J 1 A_WeaponOffset(3, 36);
			P1R0 J 1 A_WeaponOffset(3, 38);
			P1R0 J 5 A_WeaponOffset(4, 40);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ReloadUnload");
			P1R0 M 1 A_WeaponOffset(4, 38);
			P1R0 M 1 A_WeaponOffset(3, 36);
			P1R0 R 1 A_WeaponOffset(1, 34);
			P1R0 R 1 A_WeaponOffset(0, 32);
			P1R0 RQ 1 A_SetRoll(roll-0.4);
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",18,CHANF_OVERLAP);
			P1R0 PO 1 A_SetRoll(roll-0.4);
			P1R0 NML 1 A_SetRoll(roll-0.4);
			TNT1 A 0 {
				if(PB_GetMagEmpty())
					PB_SpawnCasing("EmptyCell",29,random(10,12),20,0,random(-4,-2),2);
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
			P1R0 K 11 A_SetRoll(roll-0.4);
			P1R0 LLLL 1 A_SetRoll(roll+0.4);
		FinishingReload:
			TNT1 A 0 {
				A_StartSound("weapons/plasma/cellin",17,CHANF_OVERLAP);
				PB_AmmoIntoMag("PB_M1PlasmaMag","PB_Cell",60,1);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
				PB_SetMagUnloaded(false);
			}
			P1R0 MNOP 1 A_SetRoll(roll+0.4);
			P1R0 QRSSSSTUV 1;
			P1R0 WXYZ 1 A_SetRoll(roll-0.2);
			P1R1 ABCD 1 A_SetRoll(roll+0.2);
			TNT1 A 0 PB_SetReloading(false);
			Goto ready3;
		ReloadUnload:
			P1R0 KK 1 {
				A_WeaponOffset(4, 38);
				A_SetRoll(roll-0.2);
			}
			P1R0 KK 1 {
				A_WeaponOffset(3, 36);
				A_SetRoll(roll-0.2);
			}
			P1R0 LL 1 {
				A_WeaponOffset(1, 34);
				A_SetRoll(roll-0.2);
			}
			P1R0 LL 1 {
				A_WeaponOffset(0, 32);
				A_SetRoll(roll-0.2);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"ReloadDualUnloadContinue");
			Goto FinishingReload;
		ReloadDualWield:
			TNT1 A 0 PB_CheckReload(null,null,null,"ReloadLeftOnly","Ready3",60);
			TNT1 A 0 {
				A_StartSound("PLSM2RL",26,CHANF_OVERLAP);
				A_ClearOverlays(10,11);
				A_ClearOverlays(60,64);
			}
		//Reload Right
			TNT1 A 0 {
				if(PB_GetMagUnloaded(true))
					A_Overlay(10,"LeftGunEmpty");
				if(PB_GetMagUnloaded())
					A_Overlay(11,"RightGunEmpty");
			}
			P2R1 ABC 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R1 DEF 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1;
			P1R0 J 1 A_WeaponOffset(1,32);
			P1R0 J 1 A_WeaponOffset(2,34);
			P1R0 J 1 A_WeaponOffset(3, 36);
			P1R0 J 1 A_WeaponOffset(3, 38);
			P1R0 J 5 A_WeaponOffset(4, 40);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ReloadUnload");
			P1R0 M 1 A_WeaponOffset(4, 38);
			P1R0 M 1 A_WeaponOffset(3, 36);
			P1R0 R 1 A_WeaponOffset(1, 34);
			P1R0 R 1 A_WeaponOffset(0, 32);
			P1R0 RQ 1 A_SetRoll(roll-0.4);
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",17,CHANF_OVERLAP);
			P1R0 PO 1 A_SetRoll(roll-0.4);
			P1R0 NML 1 A_SetRoll(roll-0.4);
			TNT1 A 0 {
				if(PB_GetMagEmpty())
					PB_SpawnCasing("EmptyCell",29,random(10,12),20,0,random(-4,-2),2);
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
			P1R0 K 11 A_SetRoll(roll-0.4);
			P1R0 LLLL 1 A_SetRoll(roll+0.4);
		ReloadDualUnloadContinue:
			TNT1 A 0 {
				A_StartSound("weapons/plasma/cellin",19,CHANF_OVERLAP);
				PB_AmmoIntoMag("PB_M1PlasmaMag","PB_Cell",60,1);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
				PB_SetMagUnloaded(false);
			}
			P1R0 MNOP 1 A_SetRoll(roll+0.4);
			P1R0 QRSSSS 1;
			TNT1 A 0 PB_CheckReload(null,null,null,"ReloadRightOnlyDone","ReloadRightOnlyDone",60,1,true);
			P1R0 TUVWXYZ 1; 
			P1SS DCBA 1;
			TNT1 A 3;
			Goto ReloadLeft;
		ReloadRightOnlyDone:
			P2R1 GHIJK 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R1 LMNO 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;
		ReloadLeftOnly:
			TNT1 A 0 PB_CheckReload(null,null,null,"Ready","Ready3",60,1,true);
			TNT1 A 0 {
				A_StartSound("PLSM2RL",26,CHANF_OVERLAP);
				A_ClearOverlays(10,11);
				A_ClearOverlays(60,64);
			}
			TNT1 A 0 {
				if(PB_GetMagUnloaded(true))
					A_Overlay(10,"LeftGunEmpty");
			}
			P2R1 A 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R2 AB 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R2 CDE 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 D 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 E 1;
			Goto ReloadLeftContinue;
		ReloadLeft:
			P1R3 VU 1;
			TNT1 A 0 A_StartSound("PLSM2RL",26,CHANF_OVERLAP);
			P1R3 TSRQPO 1;
		ReloadLeftContinue:
			P1R3 E 1 A_WeaponOffset(-1,32);
			P1R3 E 1 A_WeaponOffset(-2,34);
			P1R3 E 1 A_WeaponOffset(-3, 36);
			P1R3 E 1 A_WeaponOffset(-3, 38);
			P1R3 E 5 A_WeaponOffset(-4, 40);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true),"ReloadFromUnloadedLeft");
			P1R3 H 1 A_WeaponOffset(-4, 38);
			P1R3 H 1 A_WeaponOffset(-3, 36);
			P1R3 M 1 A_WeaponOffset(-1, 34);
			P1R3 M 1 A_WeaponOffset(0, 32);
			P1R3 ML 1 A_SetRoll(roll-0.4);
			TNT1 A 0 A_StartSound("weapons/plasma/cellout",18,CHANF_OVERLAP);
			P1R3 KJ 1 A_SetRoll(roll-0.4);
			P1R3 IHG 1 A_SetRoll(roll-0.4);
			TNT1 A 0 {
				if(PB_GetMagEmpty(true))
					PB_SpawnCasing("EmptyCell",29,random(-12,-10),20,0,random(2,4),2);
				PB_SetMagUnloaded(true,true);
				PB_SetChamberEmpty(true,true);
			}
			P1R3 F 11 A_SetRoll(roll-0.4);
			P1R3 GGGG 1 A_SetRoll(roll+0.4);
		ReloadDualUnloadLeftContinue:
			TNT1 A 0 {
				A_StartSound("weapons/plasma/cellin",21,CHANF_OVERLAP);
				PB_AmmoIntoMag("PB_M1PlasmaLeftMag","PB_Cell",60,1);
				PB_SetMagEmpty(false,true);
				PB_SetMagUnloaded(false,true);
				PB_SetChamberEmpty(false,true);
			}
			P1R3 HIJK 1 A_SetRoll(roll+0.4);
			P1R3 LMNNNN 1;
			Goto FinishDualReload;
		ReloadFromUnloadedLeft:
			P1R3 FF 1 {
				A_WeaponOffset(-4, 38);
				A_SetRoll(roll+0.2);
			}
			P1R3 FF 1 {
				A_WeaponOffset(-3, 36);
				A_SetRoll(roll+0.2);
			}
			P1R3 GG 1 {
				A_WeaponOffset(-1, 34);
				A_SetRoll(roll+0.2);
			}
			P1R3 GG 1 {
				A_WeaponOffset(0, 32);
				A_SetRoll(roll+0.2);
			}
			Goto ReloadDualUnloadLeftContinue;
		FinishDualReload:
			P2R2 FGHIJ 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R2 KLM 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P2R1 O 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;
		Unload:
			TNT1 A 0 {
				A_ClearOverlays(10,65);
				A_StopSound(6);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"UnloadDualWield");
			P1R0 ABCDE 1 A_SetRoll(roll-0.2);
			P1R0 FGHIJ 1 A_SetRoll(roll+0.2);
			P1R0 J 1 A_WeaponOffset(1,32);
			P1R0 J 1 A_WeaponOffset(2,34);
			P1R0 J 1 A_WeaponOffset(3, 36);
			P1R0 J 1 A_WeaponOffset(3, 38);
			P1R0 J 5 A_WeaponOffset(4, 40);
			P1R0 M 1 A_WeaponOffset(4, 38);
			P1R0 M 1 A_WeaponOffset(3, 36);
			P1R0 R 1 A_WeaponOffset(1, 34);
			P1R0 R 1 A_WeaponOffset(0, 32);
			P1R0 RQ 1;
			TNT1 A 0 {
				A_StartSound("weapons/plasma/cellout",22,CHANF_OVERLAP);
				PB_UnloadMag("PB_M1PlasmaMag","PB_Cell",1);
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
				PB_SetMagEmpty(true);
			}
			P1R0 PO 1;
			P1R0 NMLK 1; 
			P1R0 K 3;
			P1R0 JIHGFEDCB 1;
			4LSG J 1;
			TNT1 A 0 PB_SetReloading(false);
			Goto GunEmpty;
		
		FInishUnloadDualWield:
			P1R3 D 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P2R2 EDC 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P2R2 BA 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R1 A 1 {
				A_Setroll(roll+0.4, SPF_INTERPOLATE);
				A_Overlay(10,"LeftGunEmpty");
				A_Overlay(11,"RightGunEmpty");
			}
			TNT1 A 0 PB_SetReloading(false);
			Goto ReadyDualWield;
			
		UnloadFinishedRightOnly:
			TNT1 A 0 A_SetInventory("Unloading",0);
			P1R0 J 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P2R1 FED 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P2R1 CBA 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			TNT1 A 0 PB_SetReloading(false);
			Goto ReadyDualWield;
		
		UnloadDualWield:
			TNT1 A 0 {
				if(PB_GetMagEmpty() && PB_GetMagEmpty(true)) 
					return resolvestate("ReadyDualWield");
				else if(PB_GetMagEmpty() && !PB_GetMagEmpty(true))
					return resolvestate("UnloadLeftOnly");
				if(PB_GetMagUnloaded(true))
					A_Overlay(10,"LeftGunEmpty");
				return resolvestate(null);
			}
			P2R1 ABC 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
			P2R1 DEF 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1 A_Setroll(roll-0.3, SPF_INTERPOLATE);
			P1R0 J 1;
			P1R0 J 1 A_WeaponOffset(1,32);
			P1R0 J 1 A_WeaponOffset(2,34);
			P1R0 J 1 A_WeaponOffset(3, 36);
			P1R0 J 1 A_WeaponOffset(3, 38);
			P1R0 J 5 A_WeaponOffset(4, 40);
			P1R0 M 1 A_WeaponOffset(4, 38);
			P1R0 M 1 A_WeaponOffset(3, 36);
			P1R0 R 1 A_WeaponOffset(1, 34);
			P1R0 R 1 A_WeaponOffset(0, 32);
			P1R0 RQ 1;
			TNT1 A 0 {
				A_StartSound("weapons/plasma/cellout",32,CHANF_OVERLAP);
				PB_UnloadMag("PB_M1PlasmaMag","PB_Cell",1);
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
				PB_SetMagEmpty(true);
			}
			P1R0 PO 1;
			P1R0 NMLK 1; 
			P1R0 K 3;
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(true) || PB_GetMagUnloaded(true), "UnloadFinishedRightOnly");
			P1R0 JIHGFF 1;
			P1SS DCBA 1;
			TNT1 A 3;
			Goto UnloadLeft;
			
		UnloadLeftOnly:
			P2R1 A 1 {
				A_Setroll(roll-0.4, SPF_INTERPOLATE);
				if(PB_GetMagUnloaded())
					A_Overlay(11,"RightGunEmpty");
			}
			P2R2 AB 1 A_Setroll(roll-0.4, SPF_INTERPOLATE);
			P2R2 CDE 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 D 1 A_Setroll(roll+0.3, SPF_INTERPOLATE);
			P1R3 E 1;
			Goto UnloadLeftContinue;
			
		UnloadLeft:
			P1R3 VUTS 1 A_SetRoll(roll+0.2);
			P1R3 RQPO 1 A_SetRoll(roll-0.2);
			P1R3 E 1;
		UnloadLeftContinue:
			P1R3 E 1 A_WeaponOffset(-1,32);
			P1R3 E 1 A_WeaponOffset(-2,34);
			P1R3 E 1 A_WeaponOffset(-3, 36);
			P1R3 E 1 A_WeaponOffset(-3, 38);
			P1R3 E 5 A_WeaponOffset(-4, 40);
			P1R3 H 1 A_WeaponOffset(-4, 38);
			P1R3 H 1 A_WeaponOffset(-3, 36);
			P1R3 M 1 A_WeaponOffset(-1, 34);
			P1R3 M 1 A_WeaponOffset(-0, 32);
			P1R3 LK 1 ;
			TNT1 A 0 {
				A_StartSound("weapons/plasma/cellout",42,CHANF_OVERLAP);
				PB_UnloadMag("PB_M1PlasmaLeftMag","PB_Cell",1);
				PB_SetMagUnloaded(true,true);
				PB_SetChamberEmpty(true,true);
				PB_SetMagEmpty(true,true);
			}
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
					PB_HandleCrosshair(71);
					A_SetInventory("PB_LockScreenTilt",0);
					A_SetFiringRightWeapon(False);
					A_SetFiringLeftWeapon(False);
					if(CountInv("PB_M1PlasmaLeftMag") < CountInv("PB_M1PlasmaMag"))
						A_GiveInventory("DualFiring",1);
					A_overlay(10,"IdleLeft_Overlay",false);
					A_overlay(11,"IdleRight_Overlay",false);
					if(!PB_GetMagUnloaded(true))
						A_Overlay(60, "AmmoCounterLeftDW");
					if(!PB_GetMagUnloaded())
						A_Overlay(63, "AmmoCounterRightDW");
					A_startsound("PLSIDLE",6,CHANF_LOOPING);
				}
		ReadyToFireDualWield:
			TNT1 A 1 A_DoPBDualAction();
			Loop;
		
		IdleLeft_Overlay:
			DPR3 AABBCCDDEEFFGGHH 1 {
				if(PB_GetMagUnloaded(true))
				{
					A_ClearOverlays(60,61);
					A_SetWeaponFrame(8);
				}
				return A_DoPBLeftAction();
			}
			Loop;
			
		IdleRight_Overlay:
			DPR4 AABBCCDDEEFFGGHH 1 {
				if(PB_GetMagUnloaded())
				{
					A_ClearOverlays(63,64);
					A_SetWeaponFrame(8);
				}
				return A_DoPBRightAction();
			}
			Loop;
		
		MuzzleFlashDual:
			DPR1 D 1 BRIGHT {A_SetWeaponFrame(3 + random(0, 2)); A_GunFlash();}
			DPR1 G 1 BRIGHT {A_SetWeaponFrame(6 + random(0, 2)); A_GunFlash();}
			stop;
		
		FireLeft_Overlay:
			DPR2 A 1 BRIGHT {
					A_FireProjectile("Plasma_Ball", 0.1, 0, -6, -4, 0, 0);
					PB_GunSmoke(4,0,0);//A_FireProjectile("GunFireSmoke", 0, 0, -4, 0, 0, 0);
                    PB_MuzzleFlashEffects(4, 0, 0, "1265ff");
					A_StartSound("PLSM9", CHAN_WEAPON);
					A_AlertMonsters();
					A_ZoomFactor(0.99);
					PB_LowAmmoSoundWarning("hdmr","PB_M1PlasmaLeftMag");
					PB_TakeAmmo("PB_M1PlasmaLeftMag",1,0,0,true);
					PB_WeaponRecoil(-1.4,+0.8);
					A_Overlay(60,"AmmoCounterLeftDW.Firing");
					A_Overlay(-4,"MuzzleFlashDual");
					A_OverlayFlags(-4,PSPF_RENDERSTYLE,true);
					A_OverlayRenderStyle(-4,STYLE_Add);
					A_OverlayFlags(-4,PSPF_FLIP|PSPF_MIRROR,1);
				}
			DPR2 B 1 BRIGHT {
					A_ZoomFactor(0.99);
					if(CountInv("PB_M1PlasmaLeftMag")<=0 || CountInv("PB_M1PlasmaMag")>0 )
						A_GiveInventory("DualFiring",1);
					PB_WeaponRecoil(-1.4,+0.8);
				}
			DPR2 C 1 A_ZoomFactor(1.0);
			P1SG A 0 A_Overlay(60, "AmmoCounterLeftDW");
			TNT1 A 0 {
				if(CountInv("PB_M1PlasmaLeftMag")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;
			
		
		FireRight_Overlay:
			DPR1 A 1 BRIGHT {
					A_FireProjectile("Plasma_Ball", 0.1, 0, 6, -4, 0, 0);
					PB_GunSmoke(-4,0,0);//A_FireProjectile("GunFireSmoke", 0, 0, 4, 0, 0, 0);
                    PB_MuzzleFlashEffects(-4, 0, 0, "1265ff");
					A_StartSound("PLSM9", CHAN_WEAPON);
					A_AlertMonsters();
					A_ZoomFactor(0.98);
					PB_LowAmmoSoundWarning("hdmr");
					PB_TakeAmmo("PB_M1PlasmaMag",1,0);
					PB_WeaponRecoil(-1.4,-0.8);
					A_Overlay(63,"AmmoCounterRightDW.Firing");
					A_Overlay(-5,"MuzzleFlashDual");
					A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
					A_OverlayRenderStyle(-5,STYLE_Add);
				}
			DPR1 B 1 BRIGHT {
					A_ZoomFactor(0.99);
					if(CountInv("PB_M1PlasmaLeftMag")>0 || CountInv("PB_M1PlasmaMag")<=0 )
						A_TakeInventory("DualFiring",1);
					PB_WeaponRecoil(-1.4,-0.8);
				}
			DPR1 C 1 A_ZoomFactor(1.0);
			P1SG A 0 A_Overlay(63, "AmmoCounterRightDW");
			TNT1 A 0 {
				if(CountInv("PB_M1PlasmaMag")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;
		
		
		////////////////////////////////////////////////////////////////////////
		//	kick flashes
		////////////////////////////////////////////////////////////////////////
		FlashKicking:
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashKickingDualWield");
			P1SG WXYZ 1;
			P1R2 CDEEDC 1;
			P1SG ZYXW 1;
			P1SG AA 1 ;
			Goto Ready3;
		FlashAirKicking:
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashAirKickingDualWield");
			P1SG WXYZ 1;
			P1R2 BCDEEDCB 1;
			P1SG ZYXW 1;
			P1SG AA 1 ;
			Goto Ready3;
		FlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingDualWield");
			P1SG WXYZ 1;
			P1R2 ABCDEFGHHHIJKLMNEDCB 1;
			P1SG ZYXW 1;
			Goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingStopDualWield");
			P1R2 DCB 1;
			P1SG ZYXW 1; 
			Goto Ready3;
		FlashPunching:
			TNT1 A 0 A_ClearOverlays(10,65);
			TNT1 A 0 A_ClearReFire();
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashPunchingDualWield");
			P1SG WXYZ 1;
			P1R2 CDEEDC 1;
			P1SG ZYXW 1;
			P1SG AA 1;
			Goto Ready3;
		FlashPunchingDualWield:
			TNT1 A 15;
			Goto Ready3;
			
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
					PB_SetPRCounter(60, "PB_M1PlasmaMag", "PNUM") ;
			}
			Loop;
			
		AmmoCounter.Ones: //Single plasma ones
			TNT1 "#" 1 BRIGHT {
					A_OverlayOffset(61,6,0);
					PB_SetPRCounter(61, "PB_M1PlasmaMag", "PNUM", true);
			}
			Loop;

		AmmoCounterTens.Firing: //plasma firing tens
			"####" "#" 0 A_Overlay(61,"AmmoCounterOnes.Firing");
			TNT1 "#" 0 A_OverlayOffset(60,1,0);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(60, "PB_M1PlasmaMag", "PNUM");
			"####" "#" 1 BRIGHT A_OverlayOffset(60,6,1,WOF_KEEPX);
			"####" "#" 1 BRIGHT A_OverlayOffset(60,6,4,WOF_KEEPX);
			Stop;
			
		AmmoCounterOnes.Firing: //plasma firing ones
			TNT1 "#" 0 A_OverlayOffset(61,6,0);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(61, "PB_M1PlasmaMag", "PNUM", true);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,6,1,WOF_KEEPX);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,6,4, WOF_KEEPX);
			Stop;
			
	//Dual Wield Plasma Ammo Counters
		AmmoCounterLeftDW: //left plasma tens
			"####" "#" 0 A_Overlay(61,"AmmoCounterLeftDW.Ones");
			 TNT1 "#" 1 BRIGHT {
					A_OverlayOffset(60,-73,-2);
					PB_SetPRCounter(60, "PB_M1PlasmaLeftMag", "PNUM") ;
			}
			Loop;
			
		AmmoCounterLeftDW.Ones: //left plasma ones
			TNT1 "#" 1 BRIGHT {
					A_OverlayOffset(61,-68,-2);
					PB_SetPRCounter(61, "PB_M1PlasmaLeftMag", "PNUM", true) ;
			}
			Loop;
				
		AmmoCounterLeftDW.Firing: //Dual plasma left tens
			"####" "#" 0 A_Overlay(61,"AmmoCounterLeftDW.Firing2");
			TNT1 "#" 0 A_OverlayOffset(60,-73,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(60, "PB_M1PlasmaLeftMag", "PNUM");
			"####" "#" 1 BRIGHT A_OverlayOffset(60,-78,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(60,-76,2);
			Stop;
			
		AmmoCounterLeftDW.Firing2: //Dual plasma left ones
			TNT1 "#" 0 A_OverlayOffset(61,-68,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(61, "PB_M1PlasmaLeftMag", "PNUM", true);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,-73,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(61,-71,2);
			Stop;
			
		AmmoCounterRightDW: //Dual plasma right tens
			"####" "#" 0 A_Overlay(64,"AmmoCounterRightDWOnes");
			TNT1 "#" 0 A_OverlayOffset(63,74,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(63, "PB_M1PlasmaMag", "PNUM");
			Loop;
			
		AmmoCounterRightDWOnes: //Dual plasma right ones
			TNT1 "#" 0 A_OverlayOffset(64,79,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(64, "PB_M1PlasmaMag", "PNUM", true);
			Loop;
	
		AmmoCounterRightDW.Firing: //Dual plasma right tens
			"####" "#" 0 A_Overlay(64,"AmmoCounterRightDW.Firing2");
			TNT1 "#" 0 A_OverlayOffset(63,74,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(63, "PB_M1PlasmaMag", "PNUM");
			"####" "#" 1 BRIGHT A_OverlayOffset(63,79,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(63,77,2);
			Stop;
			
		AmmoCounterRightDW.Firing2: //Dual plasma right ones
			TNT1 "#" 0 A_OverlayOffset(64,79,-2);
			TNT1 "#" 1 BRIGHT PB_SetPRCounter(64, "PB_M1PlasmaMag", "PNUM", true);
			"####" "#" 1 BRIGHT A_OverlayOffset(64,84,3);
			"####" "#" 1 BRIGHT A_OverlayOffset(64,82,2);
			Stop;
	}
	
}

//
//	tokens
//
Class PB_M1PlasmaMag : PB_WeaponAmmo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 60;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 60;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "PL4SA0";
	}
}

Class PB_M1PlasmaLeftMag : PB_WeaponAmmo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 60;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 60;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "PL4SA0";
	}
}

Class HasPlasmaWeapon: Inventory
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
		//Damage(random(1,2));
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

Class Plasma_Ball : PB_ProjectileAlt
{
	default
	{
		Radius 10;
		Height 2;
		Speed 60;
		PB_Projectile.BaseDamage 44;
		+PB_PROJECTILE.NOCRITICALS
		DamageType "Plasma";
		Decal "SmallerScorch";
		Projectile;
		+BLOODLESSIMPACT;
		+FORCEXYBILLBOARD;
		+SQUAREPIXELS;
		
		renderstyle "Add";
		Scale 0.19;
		DeathSound "weapons/plasma/explode";
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
			TNT1 A 0 A_SpawnItem("Plasma_Puff", 0);
			TNT1 A 0 A_SpawnProjectile("BluePlasmaFire", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 AAAA 0 A_SpawnProjectile("RailGunTrailSpark", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 A 5;
			TNT2 AAA 9 SpawnPlasmaSmoke();//A_SpawnProjectile("PlasmaSmoke", 1, 0, random(0, 360), 2, -random(0, 160));
			Stop;

		Death:
			TNT1 A 0 A_SpawnItem("Plasma_Puff", 0);
			TNT1 B 1; //A_Explode(6,50,1)
			TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnProjectile("BluePlasmaFire", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 AAA 0 A_SpawnProjectile("BluePlasmaParticle", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 B 4;
			TNT2 AAAAAA 9 SpawnPlasmaSmoke();//A_SpawnProjectile("PlasmaSmoke", 1, 0, random(0, 360), 2, -random(0, 160));
			Stop;
	}
	
	void SpawnPlasmaSmoke()
	{
		FSpawnParticleParams Plsmk;
		Plsmk.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random(0, 25)).."0");
		Plsmk.Style = STYLE_TRANSLUCENT;
		Plsmk.Color1 = "404040";
		vector3 vls =(frandom(-0.3,0.3),frandom(-0.3,0.3),frandom(0.2,0.4));
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
		+FORCEXYBILLBOARD;
		+SQUAREPIXELS;
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
				A_SpawnProjectile("RailGunTrailSpark_Fast", 0, 0, random(0, 360), 2, random(0, 360));
				A_SpawnProjectile("RailGunTrailSpark_Fast", 0, 0, random(0, 360), 2, random(0, 360));
				A_SpawnProjectile("RailGunTrailSpark_Fast", 0, 0, random(0, 360), 2, random(0, 360));
				A_SpawnProjectile("RailGunTrailSpark_Fast", 0, 0, random(0, 360), 2, random(0, 360));
				A_SpawnProjectile("RailGunTrailSpark_Fast", 0, 0, random(0, 360), 2, random(0, 360));
			}
		Fly:
			TNT1 A 1 BRIGHT Light("M1HeatWave") {
				A_Setroll(roll-0.5);
				A_SetScale(Scale.X+0.02, Scale.Y+0.02);
				A_CountDown();
				A_Explode(60,180,0,0,150);
				A_SpawnItemEx("HeatBlastEffect1", 0, 0, 0, 0, 0, 0, 0, 128);
				A_SpawnItemEx("HeatBlastEffect2", 0, 0, 0, 0, 0, 0, 0, 128);
				A_SpawnProjectile("RailGunTrailSpark_Fast", 0, 0, random(0, 360), 2, random(0, 360));
				A_SpawnProjectile("RailGunTrailSpark_Fast", 0, 0, random(0, 360), 2, random(0, 360));
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
		 +forcexybillboard;
		 +squarepixels;
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
		XScale 0.025;
		YScale 0.03;
		alpha 0.99;
		+FLATSPRITE;
	}
	states
	{
		Spawn:
			 X060 A 1 BRIGHT {
				A_FadeOut(0.05);
				A_SetRoll(roll-2);
				A_SetScale(self.Scale.X+0.25,self.Scale.y+0.3);
			 }
			 loop;
	}
}

Class UltPlasma_Ball : Plasma_Ball
{
	states
	{
		Death:
			TNT1 A 0 A_SpawnItem("Plasma_Puff", 0);
			TNT1 B 1 A_Explode(4,50,0);
			TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnProjectile("BluePlasmaFire", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 AAA 0 A_SpawnProjectile("BluePlasmaParticle", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 B 4;
			TNT2 AAAAAA 9 A_SpawnProjectile("PlasmaSmoke", 1, 0, random(0, 360), 2, random(0, 160));
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
		//Damage(random(10,15));
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
		//Damage(random(5,7));
		Scale 0.18;
	}
}


/*
Class PB_M1PlasmaPickup : PB_UpgradeItem
{
	default
	{
		Inventory.PickupSound "";
		Inventory.PickupMessage "UAC-M1 Plasma Rifle(Slot 7)";
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