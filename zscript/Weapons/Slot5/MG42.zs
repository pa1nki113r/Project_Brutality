class PB_MG42 : PB_WeaponBase
{
	Default
	{
		//$Title MG-42
		//$Category Project Brutality - Weapons
		//$Sprite HBUSD0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		// Game Doom
		// SpawnID 9400
		Weapon.AmmoType "PB_HighCalMag";
		Weapon.AmmoGive 30;
		// Weapon.AmmoUse 0
		PB_WeaponBase.OffsetRecoilX 7;
		PB_WeaponBase.OffsetRecoilY 5;
		PB_WeaponBase.MaxOverheat 500;
		Inventory.AltHUDIcon "HBUSD0";
		PB_WeaponBase.OverheatCoolingRate 4;
		Scale 0.28;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Inventory.PickupSound "weapons/MG42/Pickup";
		Inventory.PickupMessage "$PB_MG42_PICKUP";
		Obituary "%o tasted the power of %k's MG42";		
		Tag "$PB_MG42_TAG";
		//FloatBobStrength 0.5
	}

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	bool	barrelOverheating;
	bool	hasOverheated; // Checks for the MG42 heat meter to increase higher if the barrel has overheated
	const ammoTake				= 1; // Just for consistency
	// Overlays
	const COOLING_OVERLAY		= 3;
	const SELECT_OVERLAY		 = 999;
	const BELT_OVERLAY			= 5;
	const BELT_OVERLAY_ADS		= -6;

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	action void MG42_CoolDownBarrel()
	{
		int heat = PB_GetOverheat();
		
		if (heat < 175)
		{
			PB_CoolDownBarrel(0, 0, 2, 0, 0, 0, 1.0, 1.0, true);
			return;
		}
		
		double scale = PB_Math.LinearMap(double(heat), 175.0, 500.0, 0.8, 2.5);
		double alpha = PB_Math.LinearMap(double(heat), 175.0, 500.0, 0.5, 1.5);
		
		PB_CoolDownBarrel(0, 0, 2, 0, 0, 0, scale, alpha, true);
	}

	// Different function because this one returns a state
	action state MG42_FinishFire(int tic)
	{
		switch(tic)
		{
			case 0:
				if(PB_GetOverheat() == 500) return ResolveState("UnzoomOverheat");
				else return ResolveState("FinishedZoomFire");
				return ResolveState(null);
				break;

			case 1:
				if(PB_GetAimMode())	{
					if(JustReleased(BT_ALTATTACK)) return ResolveState("UnZoom");
					if (PressingFire() && PressingAltfire()) return ResolveState("Fire2");
				}
				else	{
					if(PressingAltfire()) return ResolveState("UnZoom");
					PB_ReFire("Fire2");
				}
				return ResolveState(null);
				break;
		}
		return ResolveState(null);
	}

	action void MG42_Fire(int tic)
	{
		bool ads = PB_GetZoom();
		bool overheating = getBarrelIsOverheating();
		
		switch(tic)
		{
			case 0:
				// Crosshair
				if(ads) A_SetCrosshair(-1);
				else	PB_HandleCrosshair(50);
				
				// Overlays
				PB_IncrementHeat();
				A_ClearOverlays(COOLING_OVERLAY,BELT_OVERLAY);
				if(ads) {
					A_FlashOverlay(state:"MuzzleFlashZoom");
					A_Overlay(BELT_OVERLAY_ADS,"BeltFlashZoomFire");
				}
				else {
					A_FlashOverlay();
					A_Overlay(BELT_OVERLAY_ADS,"BeltFlash");
				}
				
				// Overheat
				PB_ModifyOverheat(overheating ? 15 : 5);
				
				// Take Ammo
				A_TakeInventory(invoker.ammo1.getClassName(), ammoTake, TIF_NOTAKEINFINITE);
				A_StartSound("MG42FIR", CHAN_WEAPON, CHANF_DEFAULT, 1.0);
				PB_DynamicTail("lmg", "lmg");
				break;

			case 1:
				// Bullet spread
				double spread;
				if(overheating)				 spread = 7;
				else if(PB_GetOverheat() > 300) spread = 1.0 + (PB_GetOverheat() / 100.0);
				else							spread = 4;
				PB_FireBullets("PB_792x57mm", 1, spread, 0, 0, spread);
				
				// Casings
				int casingY = ads ? 19 : 10;
				int beltY	= ads ? 39 : 34;
				int beltX	= ads ?	3 :	5;
				int beltOfs = ads ? 10 : 13;
				PB_SpawnCasing("MG42Casing", 13, 0, casingY, 0, 0, 0, false);
				PB_SpawnCasing("LMGBeltLink", beltOfs, beltX, beltY, 0, 2, frandom(-2.0, 0.5), false);
				
				// Effcts
				A_FireCustomMissile("MinigunTracer", random(-3, 3), 0, -1, random(-3, 3));
				PB_GunSmoke_Basic(0, 0, 0);
				A_AlertMonsters();
				PB_WeaponRecoil(ads ? -2.0 : -2.2, ads ? -0.5 : -0.6);
				PB_FireOffset(); //Always call fire offset
				break;
		}
	}

	action state MG42_FireStart(bool zoomed = false)
	{
		if(!zoomed) {
			if(getbarrelHasOverheated())							return ResolveState("BarrelChange");
			if(PB_GetZoom())										return ResolveState("Fire2");
			if(invoker.ammo1.amount >= 1 && PB_GetOverheat() < 500) return ResolveState("FireNormal");
			else if(PB_GetOverheat() == 500)						return ResolveState("Overheat");
			else													A_StartSound("weapons/empty", 0);	return ResolveState("Ready");
		}
		else {
			if(getbarrelHasOverheated())							return ResolveState("UnzoomBarrelChange");
			if(invoker.ammo1.amount >= 1 && PB_GetOverheat() < 500) return ResolveState("FireADS");
			else if(PB_GetOverheat() == 500)						return ResolveState("UnzoomOverheat");
			else													A_StartSound("weapons/empty", 0); return ResolveState("Ready2");
		}
		return ResolveState(null);
	}

	action void MG42_SetBeltSprite(
		name l5, 
		name l4, 
		name l3, 
		name l2, 
		name l1, 
		int layer = PSP_WEAPON)
	{
		let psp = player.FindPSprite(layer);
		if (!psp) return;

		int ammo = invoker.ammo1.amount;

		if		(ammo >= 14) psp.sprite = GetSpriteIndex(l5);
		else if (ammo >= 12) psp.sprite = GetSpriteIndex(l4);
		else if (ammo >= 10) psp.sprite = GetSpriteIndex(l3);
		else if (ammo >= 8)	psp.sprite = GetSpriteIndex(l2);
		else				 psp.sprite = GetSpriteIndex(l1);
	}

	// These are mostly auxilliary functions
	action bool getbarrelIsOverheating()
	{
		return invoker.barrelOverheating;
	}

	action bool getbarrelHasOverheated()
	{
		return invoker.hasOverheated;
	}

	action void setbarrelIsOverheating(bool set)
	{
		invoker.barrelOverheating = set;
	}

	action void setbarrelHasOverheated(bool set)
	{
		invoker.hasOverheated = set;
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
			HBUS D 1;
			Loop;

		WeaponRespect:
			TNT1 A 0 {
				A_SetCrosshair(-1);
				A_PlaySound("weapons/MG42/Select");
			}
			MGR1 ABCDEFGHIJKLMNOPQRST 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MG42OP");
			MGR1 UVWXYZ 1 A_DoPBWeaponAction();
			MGR2 ABCDEFGHIJK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MG42RE");
			MGR2 LMNOPQRSRSTUVWXYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("weapons/smg_magfly1");
			MGR3 ABCDEFGHIJKLMNOPQRST 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MG42BUL");
			MGR3 UVWXYZ 1 A_DoPBWeaponAction();
			MGR4 ABCDE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MG42BUL");
			MGR4 FGHIJKLMNOPQRSTUV 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("weapons/MG42/Pickup");
			MGR4 WXYZ 1 A_DoPBWeaponAction();
			MGR5 ABCDEF 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MG42IN");
			MGR5 GHIJKLMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			MGR5 QRSTUVWXYZ 1 A_DoPBWeaponAction();
			MGR6 ABCDEFHI 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MG42CL");
			MGR6 JKLMNOPQRST 1 A_DoPBWeaponAction();
			MGRC EFGH 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("MG42RC");
			MGRC HHHHGFE 1 A_DoPBWeaponAction();
			MGR6 UVWX 1 A_DoPBWeaponAction();
			TNT1 A 0 PB_HandleCrosshair(50);
			Goto Ready3;

		Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				A_ClearOverlays(10,11);
			}
			TNT1 A 0 {
				A_Overlay(SELECT_OVERLAY,"DeselectFlash");
				PB_SetZoom(false);
				A_ZoomFactor(1.0);
				A_PlaySoundEx("weapons/changing", "Auto");
				A_Overlay(SELECT_OVERLAY,"DeselectBelt");
			}
			MGSE BCDF 1;
			TNT1 A 0 A_ClearOverlays(COOLING_OVERLAY);
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
			Wait;

		// This is called from SelectAnimation
		SelectBelt:
			// Cache Sprites
			MGS5 ABC 0;
			MGS4 ABC 0;
			MGS3 ABC 0;
			MGKS ABC 0;
			// Actual Select Belt
			MGKS CBA 1 MG42_SetBeltSprite("MGS5","MGS4","MGS3","MGKS","TNT1",layer:overlayID());
			Stop;
		DeselectBelt:
			MGKS ABC 1 MG42_SetBeltSprite("MGS5","MGS4","MGS3","MGKS","TNT1",layer:overlayID());
			Stop;
		

		Select:
			TNT1 A 0 {
				PB_HandleCrosshair(50);
				PB_WeapTokenSwitch("MG42Selected");
				PB_WeaponRaise("weapons/MG42/Select");
				return PB_RespectIfNeeded();
			}
		SelectAnimation:
			TNT1 A 0 {
				if(PB_GetOverheat() > 1)
					A_Overlay(COOLING_OVERLAY,"Cooling",true);
			}
			MGSE F 1;
			TNT1 A 0 A_Overlay(SELECT_OVERLAY,"SelectBelt");
			MGSE DCB 1;
		WeaponSpecial:
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
		// Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			// Cache Sprites
			MG5R A 0;
			MG4R A 0;
			MG3R A 0;
			MG2R A 0;
			MG1R A 0;
			// Actual Ready
			"####" A 0 {
				if(PB_GetOverheat() > 1) A_Overlay(COOLING_OVERLAY,"Cooling",true);
				PB_HandleCrosshair(50);
			}
		ReadyToFire:	
			MG1R A 1 {
				MG42_CoolDownBarrel();
				MG42_SetBeltSprite("MG5R","MG4R","MG3R","MG2R","MG1R");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD, PB_FORCERELOAD);
			}
			Loop;

		Ready2:
			// Cache Sprites
			MG3Z A 0;
			MG2Z A 0;
			MG1Z A 0;
			// Actual Ready Zoom
			TNT1 A 0 MG42_SetBeltSprite("MG3Z","MG3Z","MG3Z","MG2Z","MG1Z");
			"####" A 1 {
				MG42_CoolDownBarrel();
				A_SetCrosshair(-1);
				if(PB_GetAimMode()) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK) ) 
						return ResolveState("Unzoom");
					if (PressingFire() && PressingAltfire() && invoker.ammo1.amount > 1 && PB_GetOverheat() < 500)
						Return ResolveState("Fire2");
					else if (PressingFire() && PressingAltfire() && invoker.ammo1.amount > 1 && PB_GetOverheat() == 500) 
						Return ResolveState("UnzoomOverheat");
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY, PB_FORCERELOAD);
				}
				else return A_DoPBWeaponAction();
			}
			Loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			TNT1 A 0 MG42_FireStart();
		FireNormal:
			TNT1 A 0 MG42_Fire(0);
			TNT1 A 0 MG42_Fire(1);
			MGFI AB 1;
			TNT1 A 0 PB_ReFire();
			MGFI CD 1;
			TNT1 A 0 A_Overlay(COOLING_OVERLAY, "Cooling", true);
			Goto Ready3;

		Fire2:
			TNT1 A 0 MG42_FireStart(zoomed:true);
		FireADS:
			TNT1 A 0 MG42_Fire(0);
			TNT1 A 0 MG42_Fire(1);
			MGZF AB 1;
			TNT1 A 0 MG42_FinishFire(0);
		FinishedZoomFire:
			TNT1 A 0 MG42_FinishFire(1);
			MGZF C 1 {
				A_Overlay(BELT_OVERLAY, "BeltFlashZoomFireFinished");
				A_Overlay(COOLING_OVERLAY, "Cooling",true);
			}
			MG1Z A 1 MG42_SetBeltSprite("MG3Z","MG3Z","MG3Z","MG2Z","MG1Z",layer:overlayID());
			TNT1 A 0 A_Overlay(COOLING_OVERLAY, "Cooling", true);
			Goto Ready2;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
		AltFire:
		TNT1 A 0 A_JumpIf(PB_GetZoom(), "Unzoom");
		TNT1 A 0 {
			PB_SetZoom(true);
			A_PlaySoundEx("IronSights", "Auto");
			A_Overlay(5, "BeltZoomFlash");
			A_ZoomFactor(1.25);
			A_SetCrosshair(-1);
		}
		MRGZ BCD 1;
		Goto Ready2;

		Unzoom:
		TNT1 A 0 {
			PB_SetZoom(false);
			A_PlaySoundEx("IronSights", "Auto");
			A_Overlay(BELT_OVERLAY, "BeltUnzoomFlash");
			A_ZoomFactor(1.0);
			PB_HandleCrosshair(50);
		}
		MRGZ DCB 1;
		Goto Ready3;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Reload:
			TNT1 A 0 A_JumpIf(getbarrelHasOverheated() || getbarrelIsOverheating(), "BarrelChange");
			Goto ReadyToFire;

		ChangeBullet:
			// Cache Sprites
			MA15 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			MA14 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			MA13 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			MA12 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;

			MA25 ABCDEFGHIJKLMNOPQRST 0;
			MA24 ABCDEFGHIJKLMNOPQRST 0;
			MA23 ABCDEFGHIJKLMNOPQRST 0;
			MA22 ABCDEFGHIJKLMNOPQRST 0;

			MG5C ABCD 0;
			MG4C ABCD 0;
			MG3C ABCD 0;
			MG2C ABCD 0;
			
			// Actual ChangeBullet
			TNT1 A 0 MG42_SetBeltSprite("MA15","MA14","MA13","MA12","TNT1",layer:overlayID());
			"####" ABCDEFGHIIIJKLMNOPQRSTTTTTTUVVVVWXYZ 1;
			TNT1 A 0 MG42_SetBeltSprite("MA25","MA24","MA23","MA22","TNT1",layer:overlayID());
			"####" AAAAAABCDEFFFFFFGHHHHIJKLMNNNN 1;
			//RECHAMBER
			TNT1 A 0 MG42_SetBeltSprite("MG5C","MG4C","MG3C","MG2C","TNT1",layer:overlayID());
			"####" ABCDDDDCBA 1;
			TNT1 A 0 MG42_SetBeltSprite("MA25","MA24","MA23","MA22","TNT1",layer:overlayID());
			"####" NNOPQRST 1;
			Stop;

		UnzoomBarrelChange:
			TNT1 A 0 {
				PB_SetZoom(false);
				A_PlaySoundEx("IronSights", "Auto");
				A_Overlay(BELT_OVERLAY, "BeltUnzoomFlash");
				A_ZoomFactor(1.0);
				PB_HandleCrosshair(50);
			}
			MRGZ DCB 1;
			Goto BarrelChange+2;
		BarrelChange:
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "UnzoomBarrelChange");
			TNT1 AA 0;
			TNT1 A 0{
				A_ClearOverlays(BELT_OVERLAY);
				A_Overlay(COOLING_OVERLAY, "ChangeBullet");
				A_SetInventory("CantDoAction",1);
				A_SetCrosshair(-1);
				PB_SetReloading(true);
			}
			MGC1 ABCDEFGHIJKLMNO 1;
			TNT1 A 0 A_PlaySound("MG42OP");
			MGC1 PQRSTUVWXYZ 1;
			MGC2 ABCDEF 1;
			TNT1 A 0 A_PlaySound("MG42RE");
			MGC2 GHIJKLMNOP 1;
			TNT1 A 0 A_PlaySound("MG42IN");
			MGC2 QRSTUVWXYZ 1;
			MGC3 ABCDEFG 1;
			TNT1 A 0 A_PlaySound("MG42CL");
			MGC3 HIJKLMN 1;
			MGRC ABC 1;
			TNT1 A 0 A_PlaySound("MG42RC");
			MGRC DDDDCBA 1;
			MGC3 OPQRST 1;
			TNT1 A 0 A_Overlay(COOLING_OVERLAY,"Cooling",true);
			TNT1 A 0 {
				A_SetInventory("CantDoAction",0);
				PB_SetOverheat(0);
				setbarrelIsOverheating(false);
				setbarrelHasOverheated(false);
			}
			Goto Ready3;

		UnzoomOverheat:
			TNT1 A 0 {
				PB_SetZoom(false);
				A_PlaySoundEx("IronSights", "Auto");
				A_Overlay(BELT_OVERLAY, "BeltUnzoomFlash");
				A_ZoomFactor(1.0);
				A_PlaySound("MG42HEAT");
				PB_HandleCrosshair(50);
			}
			MRGZ DCB 1;
			Goto Overheat+1;

		Overheat:
			TNT1 A 0 A_PlaySound("MG42HEAT");
			TNT1 A 0 {
				setbarrelIsOverheating(true);
				setbarrelHasOverheated(true);
			}
			TNT1 A 0 MG42_SetBeltSprite("MG5R","MG4R","MG3R","MG2R","MG1R");
			"####" A 0 A_Overlay(COOLING_OVERLAY,"Cooling");
			"####" A 45 A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOSWITCH);
			Goto ReadyToFire;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashKicking:
			// Cache Sprites
			MGK5 ABCDEFGHI 0;
			MGK4 ABCDEFGHI 0;
			MGK3 ABCDEFGHI 0;
			MGK2 ABCDEFGHI 0;
			MGKI ABCDEFGHI 0;
			// Actual Kick
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" BCD 1;
			MGKI EFGHHGFE 1;
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" DCB 1;
			Goto Ready3;

		FlashAirKicking:
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" BCD 1;
			MGKI EFGHIIIHGFE 1;
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" DCB 1;
			Goto Ready3;

		FlashSlideKicking:
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" BCD 1;
			MGKI EFGHIIIIIIIIIIHGFE 1;
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" DCB 1;
			Goto Ready3;

		FlashSlideKickingStop:
			MGKI IIII 1;
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" DCB 1;
			Goto Ready3;

		FlashPunching:
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" BCD 1;
			MGKI EFGHHGFE 1;
			TNT1 A 0 MG42_SetBeltSprite("MGK5","MGK4","MGK3","MGK2","MGKI");
			"####" DCB 1;
			Goto Ready3;

		// Normal Fire Muzzle Flashes
		MuzzleFlash:
			TNT1 A 0 A_Jump(128, "Flash1", "Flash2", "Flash3");
		Flash3:
			MGMZ EF 1 BRIGHT A_GunFlash();
			Stop;
		Flash2:
			MGMZ CD 1 BRIGHT A_GunFlash();
			Stop;
		Flash1:
			MGMZ AB 1 BRIGHT A_GunFlash();
			Stop;

		// ADS Fire Muzzle Flashes
		MuzzleFlashZoom:
			TNT1 A 0 A_Jump(128, "MuzzleZoom1", "MuzzleZoom2", "MuzzleZoom3");
		MuzzleZoom1:
			MGZM A 1 BRIGHT A_GunFlash();
			Stop;
		MuzzleZoom2:
			MGZM B 1 BRIGHT A_GunFlash();
			Stop;
		MuzzleZoom3:
			MGZM C 1 BRIGHT A_GunFlash();
			Stop;
		
		// Belt Flashes
		BeltFlash:
			// Cache Sprites
			MGF5 ABCD 0;
			MGF4 ABCD 0;
			MGF3 ABCD 0;
			MGF2 ABCD 0;
			// Actual Belt Flash
			TNT1 A 0 MG42_SetBeltSprite("MGF5","MGF4","MGF3","MGF2","TNT1",layer:overlayID());
			"####" ABCD 1;
			Stop;
		BeltZoomFlash:
			// Cache Sprites
			MGZ5 ABC 0;
			MGZ4 ABC 0;
			MGZ3 ABC 0;
			MGZ2 ABC 0;
			// Actual Belt Zoom Flash
			TNT1 A 0 MG42_SetBeltSprite("MGZ5","MGZ4","MGZ3","MGZ2","TNT1",layer:overlayID());
			"####" AB 1;
			TNT1 A 0 MG42_SetBeltSprite("MGZ3","MGZ3","MGZ3","MGZ2","TNT1",layer:overlayID());
			"####" C 1;
			Stop;
		BeltUnzoomFlash:
			TNT1 A 0 MG42_SetBeltSprite("MGZ3","MGZ3","MGZ3","MGZ2","TNT1",layer:overlayID());
			"####" C 1;
			TNT1 A 0 MG42_SetBeltSprite("MGZ5","MGZ4","MGZ3","MGZ2","TNT1",layer:overlayID());
			"####" BA 1;
			Stop;
		BeltFlashZoomFire:
			// Cache Sprites
			MZF3 ABC 0;
			MZF2 ABC 0;
			// Actual Belt Zoom Fire Flash
			TNT1 A 0 MG42_SetBeltSprite("MZF3","MZF3","MZF3","MZF2","TNT1",layer:overlayID());
			"####" AC 1;
			Stop;
		BeltFlashZoomFireFinished:
			TNT1 A 0 MG42_SetBeltSprite("MZF3","MZF3","MZF3","MZF2","TNT1",layer:overlayID());
			"####" B 1;
			Stop;
	}
}