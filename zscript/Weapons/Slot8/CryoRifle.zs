// Gearbox Tokens
class FireModeCryoRifleMissile_WW : Inventory {Default{Inventory.MaxAmount 1;}}
class FireModeCryoRifleBeam_WW : Inventory {Default{Inventory.MaxAmount 1;}}
class FireModeCryoRifleSpear_WW : Inventory {Default{Inventory.MaxAmount 1;}}
class FireModeCryoRifleFlak_WW : Inventory {Default{Inventory.MaxAmount 1;}}

// Ammo Class
Class PB_CryoRifleMag : PB_WeaponAmmo
{
	default
	{
		Inventory.MaxAmount PB_CryoRifle.MAGAZINE_SIZE;
		Ammo.BackpackMaxAmount PB_CryoRifle.MAGAZINE_SIZE;
		Inventory.Icon "FRPKA0";
	}
}

// The Actual Weapon
class PB_CryoRifle : PB_WeaponBase {
	Default {
		//$Category Project Brutality - Weapons
		//$Sprite FRPKA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		// SpawnID 9700
		Weapon.SelectionOrder 100;
		Weapon.AmmoGive1 40;
		Weapon.AmmoType1 "PB_Cell";
		Weapon.AmmoType2 "PB_CryoRifleMag";
		PB_WeaponBase.OffsetRecoilX 1.5;
		PB_WeaponBase.OffsetRecoilY 1.8;
		PB_WeaponBase.UsesWheel 1;
		PB_WeaponBase.WheelInfo "PB_CryoRifleWheel";
		DamageType "Ice";
		Scale 0.48;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Inventory.PickupSound "weapons/CryoRifle/respect1";
		Inventory.PickupMessage "$PB_CRYO_PICKUP";
		Obituary "%o was iced by %k";
		Tag "$PB_CRYO_TAG";
	}

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	bool cryoPrimary;
	bool cryoSecondary;
	int cryoOvercooling;
	// Why did I make it like this? idk maybe so its easier to add other modes lol
	enum cryoEnum {
		// Modes, right now they are booleans but they can be changed to int if anyone wants to add other modes
		PRIM_MISSILE	= 0,
		PRIM_BEAM		= 1,
		SEC_SPEAR		= 0,
		SEC_FLAK		= 1,
		// Ammo Take, each mode takes different amounts
		TAKE_MISSILE	= 5,
		TAKE_BEAM		= 1,	 // This is taken per tic
		TAKE_SPEAR		= 10,
		TAKE_FLAK		= 2,
		// Over Cooling System, this dictates how cold the weapon is and set the sprites accordingly
		MAX_COOLING	 = 420,
		ADD_COOLING	 = 60,
		ADD_COOLING2	= 8,	 // The beam adds this much every tic
		COOL_RATE		= 1,	 // Decrease the overcool by this every tic when in Ready State
		HASOVERCOOLED	= 100,	// The weapon counts as "overcooled" when it has reached this number
		// Overlays
		BIG_TUBEGLOW	= 7,
		SMALL_TUBEGLOW	= 8,
		MUZZLE_GLOW	 = 9
	}
	const frozenspacepx = 15;	// This is from BaseWeapon_Functions
	const MAGAZINE_SIZE = 60;
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		cryoPrimary	= PRIM_BEAM;
		cryoSecondary = SEC_FLAK;
		super.postbeginplay();
	}

	// This is moved from BaseWeapon_Functions
	action void PB_FireCryoRifleBeam()
	{
		FLineTraceData t;
		double zoff = (height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor) - 9;
		bool hit = LineTrace(angle,8000,pitch,TRF_NOSKY ,zoff,data:t);
		
		vector3 fpos = t.hitlocation - t.hitdir; //substract one to the final pos so the puff doesnt spawn in the wall and therefore in a higher sector if any
		vector3 spos = (pos.xy, pos.z + zoff);
		
		vector3 dif = levellocals.Vec3Diff(spos,fpos);
		vector3 dr = dif.unit();
		double dist = dif.length();
		
		int steps = int(dist / frozenspacepx) + 1;
		
		FSpawnParticleParams FrostBeam;
		FrostBeam.Texture = TexMan.CheckForTexture("X027A0"); //FIR5G0 also looks cool
		FrostBeam.Color1 = "FFFFFF";
		FrostBeam.Style = STYLE_Add;
		FrostBeam.Flags = SPF_ROLL|SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		FrostBeam.Vel = (0,0,0); 
		FrostBeam.Startroll =random(0,360); //randompick(0,90,180,270,360);
		FrostBeam.RollVel = 0;
		FrostBeam.StartAlpha = 0.90;
		FrostBeam.FadeStep = 0.1;
		FrostBeam.Size = 20;
		FrostBeam.SizeStep = 0;
		FrostBeam.Lifetime = 1; 
		
		//basically, simulate a hitscan attack by damaging the actor the trace hits, spawning a puff and spraying a decal
		//damage victim (if any)
		if(t.hitactor)
		{
			actor v = t.hitactor;
			if(v && v.bismonster && v.health > 0 && !isfriend(v))
				v.damagemobj(self,self,2,"Freeze",DMG_THRUSTLESS);
		}
		
		//spawn puff if hit anything that is not sky
		if(hit)
		{
			actor p = Spawn("CryoRifleBeamPuff",fpos);
			if(p)
			{
				p.target = self; //no self damage
				p.A_SprayDecal("FreezerBurnSmall",2,(0,0,0),t.hitdir); //spray the decal manually
			}
		}
		
		for(int i = 0; i < steps; i++)
		{
			spos += (dr * frozenspacepx);
			FrostBeam.Pos = spos;
			if(i > 0) //skip the first iteration
				Level.SpawnParticle(FrostBeam);
		}
		
	}

	action void Cryo_SetGlowOverlay(int layer)
	{
		int heat = getOvercooling();
		int frame;

		if	 (heat >= 360) frame = 6;	// G
		else if(heat >= 300) frame = 5;	// F
		else if(heat >= 240) frame = 4;	// E
		else if(heat >= 180) frame = 3;	// D
		else if(heat >= 120) frame = 2;	// C
		else if(heat >= 60)	frame = 1;	// B (bright)
		else if(heat >= 40)	frame = 1;	// B (bright)
		else if(heat >= 35)	frame = 14; // O fade
		else if(heat >= 30)	frame = 13; // N fade
		else if(heat >= 25)	frame = 12; // M fade
		else if(heat >= 20)	frame = 11; // L fade
		else if(heat >= 15)	frame = 10; // K fade
		else if(heat >= 10)	frame = 9;	// J fade
		else if(heat >= 5)	frame = 8;	// I fade
		else if(heat >= 3)	frame = 7;	// H fade
		else				 frame = 0;	// A (off)

		A_SetWeaponFrame(frame);
	}

	action state Cryo_CheckRefire(bool isAlt)
	{
		if(!isAlt) {
			if(getPrimary() == PRIM_MISSILE && invoker.ammo2.amount < TAKE_MISSILE)
			{
				A_StartSound("weapons/CryoRifle/powerdown", CHAN_AUTO, CHANF_OVERLAP);
				return ResolveState("EndMissile");
			}
		}
		else {
			if( getSecondary() == SEC_SPEAR && invoker.ammo2.amount < TAKE_SPEAR ||
				getSecondary() == SEC_FLAK	&& invoker.ammo2.amount < TAKE_FLAK)
			{
				A_StartSound("weapons/CryoRifle/powerdown", CHAN_AUTO, CHANF_OVERLAP);
				return ResolveState("Ready3");
			}
		}
		return ResolveState(null);
	}

	// Handles firing except the beam
	action void Cryo_FireMissile(bool isAlt)
	{
		if(!isAlt) {
			if(getPrimary() == PRIM_MISSILE)
			{
				// PB_FireBullets("IceMissile",1,0,0,0,0);
				A_FireCustomMissile("IceMissile", 0, 0, 0, 0);
				PB_TakeAmmo(invoker.ammo2.getClassName(),TAKE_MISSILE, 0);
				A_StartSound("weapons/CryoRifle/missile", CHAN_WEAPON, CHANF_OVERLAP);
			}
		}
		else {
			if(getSecondary() == SEC_SPEAR)
			{
				// PB_FireBullets("IceSpear",1,0,0,0,0);
				A_FireCustomMissile("IceSpear", 0, 0, 0, 0);
				PB_TakeAmmo(invoker.ammo2.getClassName(),TAKE_SPEAR, 0);
				A_StartSound("weapons/CryoRifle/spearfire", CHAN_WEAPON, CHANF_OVERLAP);
			}
			if (getSecondary() == SEC_FLAK)
			{
				A_FireProjectile("IceFlak1", frandom(-2.0, 2.0), pitch:frandom(-2.0, 2.0));
				A_FireProjectile("IceFlak2", frandom(-2.0, 2.0), pitch:frandom(-2.0, 2.0));
				A_FireProjectile("IceFlak3", frandom(-2.0, 2.0), pitch:frandom(-2.0, 2.0));
				A_FireProjectile("IceFlak4", frandom(-2.0, 2.0), pitch:frandom(-2.0, 2.0));
				A_FireProjectile("IceFlak1", frandom(-2.0, 2.0), pitch:frandom(-2.0, 2.0));
				PB_TakeAmmo(invoker.ammo2.getClassName(),TAKE_FLAK, 0);
				A_StartSound("weapons/CryoRifle/flak", CHAN_WEAPON, CHANF_OVERLAP);
			}
		}
		PB_WeaponRecoil(-0.32, -0.16);
		PB_FireOffset();
		A_GunFlash();
		A_AlertMonsters();
		setOvercooling(min(invoker.cryoOvercooling + ADD_COOLING, MAX_COOLING));
		// console.printf("Current Overcooling is %d",invoker.cryoOvercooling);
		PB_GunSmoke(0, 0, 0);
		PB_GunSmoke(0, 0, 0);
		PB_GunSmoke(0, 0, 0);
		A_ZoomFactor(0.98);
	}

	action void cryo_firePrimary(int tic, bool isBeam = false)
	{
		switch(tic)
		{
			 case 0:
				A_WeaponOffset(0, 32);
				A_ClearOverlays(BIG_TUBEGLOW,MUZZLE_GLOW);
				PB_SetRoll(0);
				PB_HandleCrosshair(79);
				A_SetInventory("PB_LockScreenTilt", 0);
				break;
				
			case 1:
				A_StopSound(CHAN_6);
				A_StopSound(CHAN_7);
				A_StartSound("weapons/CryoRifle/powerup", CHAN_AUTO, CHANF_OVERLAP);
				break;

			case 2:
				PB_FireOffset();
				setSprite('FR10', 'FR11');
				break;

			// Hold
			case 3:
				if(isBeam)
				{
					setSprite('FR13', 'FR14');
					PB_FireCryoRifleBeam();
					PB_FireOffset();
					PB_WeaponRecoil(-0.20, -0.08);
					A_GunFlash();
					A_Overlay(FLASH_LAYER, "BeamMuzzleFlash");
					A_StartSound("weapons/cryobowflyby", CHAN_WEAPON, CHANF_LOOPING);
					A_AlertMonsters();
					PB_GunSmoke(0, 0, 0);
					setOvercooling(min(invoker.cryoOvercooling + ADD_COOLING2, MAX_COOLING));
					// console.printf("Current Overcooling is %d",invoker.cryoOvercooling);
				}
				else
				{
					setSprite('FR10', 'FR11');
					Cryo_FireMissile(isAlt:false);
				}
				break;

			case 4:
				PB_FireOffset();
				A_ZoomFactor(1.0);
				setSprite('FR10', 'FR11');
				break;
		}
	}

	action void cryo_fireSecondary(int tic)
	{
		switch(tic)
		{
			case 0:
				A_WeaponOffset(0, 32);
				A_ClearOverlays(BIG_TUBEGLOW,MUZZLE_GLOW);
				PB_SetRoll(0);
				PB_HandleCrosshair(79);
				A_SetInventory("PB_LockScreenTilt", 0);
				break;

			case 1:
				PB_FireOffset();
				setSprite('FR10', 'FR11');
				break;

			// Hold
			case 2:
				setSprite('FR10', 'FR11');
				Cryo_FireMissile(true);
				break;

			case 3:
				PB_FireOffset();
				A_ZoomFactor(1.0);
				setSprite('FR10', 'FR11');
				break;

			case 4: case 5: case 6:
				PB_GunSmoke(frandom(-2,2), frandom(-2,2), frandom(-2,2));
				setSprite('FR10', 'FR11');
				A_WeaponOffset(random(1,-1), random(32,33));
				break;
		}
	}

	action state cryo_checkSecondary()
	{
		bool goSpear = getSecondary() == SEC_SPEAR;
		bool goFlak	= getSecondary() == SEC_FLAK;

		if(goSpear) return PB_jumpIfNoAmmo("Reload",TAKE_SPEAR);
		if(goFlak)	return PB_jumpIfNoAmmo("Reload",TAKE_FLAK);

		A_StopSound(CHAN_6);
		A_StopSound(CHAN_7);
		A_StartSound("weapons/CryoRifle/powerup", CHAN_AUTO, CHANF_OVERLAP);

		return ResolveState(null);
	}

	action state cryo_ready(bool isEmpty = false)
	{
		if(!isEmpty && invoker.ammo2.amount == 0) return Resolvestate("GunEmpty");
		A_Overlay(BIG_TUBEGLOW, "BigTubeGlow");
		A_Overlay(SMALL_TUBEGLOW, "SmallTubeGlow");
		A_Overlay(MUZZLE_GLOW, "MuzzleGlow");
		setOvercooling(invoker.cryoOvercooling - COOL_RATE);
		// invoker.cryoOvercooling--;
		if(!isEmpty) A_FireCustomMissile("TinyGunSmoker", 0, 0, 0, -3, 0, 0);
		return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
	}

	action state Cryo_WeaponSpecial()
	{
		A_StopSound(2);
		A_SetInventory("GoWeaponSpecialAbility", 0);
		PB_HandleCrosshair(79);
		A_ZoomFactor(1.0);
		A_ClearOverlays(BIG_TUBEGLOW,MUZZLE_GLOW);

		// Get tokens
		bool goMissile = CountInv("FireModeCryoRifleMissile_WW") > 0;
		bool goBeam	= CountInv("FireModeCryoRifleBeam_WW")	> 0;
		bool goSpear	= CountInv("FireModeCryoRifleSpear_WW")	> 0;
		bool goFlak	= CountInv("FireModeCryoRifleFlak_WW")	> 0;

		// Check if already selected, if yes go to ready3
		if( goMissile && getPrimary() == PRIM_MISSILE || goSpear && getSecondary() == SEC_SPEAR ||
			goBeam	&& getPrimary() == PRIM_BEAM	|| goFlak	&& getSecondary() == SEC_FLAK) 
		{
			A_Print("$PB_ALREADYSELECTED"); 
			clearModeTokens(); 
			return ResolveState("Ready3");
		}

		A_StartSound("weapons/CryoRifle/up", CHAN_AUTO, CHANF_OVERLAP);
		A_StartSound("weapons/CryoRifle/reload1", CHAN_AUTO, CHANF_OVERLAP);

		// Change Mode and then fallthrough to the switch animation
		if(goMissile) { A_Print("$PB_CRYO_MISSILE"); setPrimary(PRIM_MISSILE);} 
		if(goBeam)	{ A_Print("$PB_CRYO_BEAM");	setPrimary(PRIM_BEAM);}
		if(goSpear)	{ A_Print("$PB_CRYO_SPEAR");	setSecondary(SEC_SPEAR);}
		if(goFlak)	{ A_Print("$PB_CRYO_FLAK");	setSecondary(SEC_FLAK);}	 

		clearModeTokens();
		return ResolveState(null);
	}

	action bool hasCooled()
	{
		return getOvercooling() >= HASOVERCOOLED;
	}

	action void setSprite(name normal, name overcooled)
	{
		A_SetWeaponSprite(hasCooled() ? overcooled : normal);
	}

	action void clearModeTokens()
	{
		A_SetInventory("FireModeCryoRifleMissile_WW", 0);
		A_SetInventory("FireModeCryoRifleBeam_WW", 0);
		A_SetInventory("FireModeCryoRifleSpear_WW", 0);
		A_SetInventory("FireModeCryoRifleFlak_WW", 0);
	}

	action void setOvercooling(int set)
	{
		invoker.cryoOvercooling = set;
	}

	action int getOvercooling()
	{
		return invoker.cryoOvercooling;
	}

	action void setPrimary(bool set)
	{
		invoker.cryoPrimary = set;
	}

	action void setSecondary(bool set)
	{
		invoker.cryoSecondary = set;
	}

	action bool getPrimary()
	{
		return invoker.cryoPrimary;
	}

	action bool getSecondary()
	{
		return invoker.cryoSecondary;
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
			FRPK A 1;
			Loop;

		WeaponRespect:
				TNT1 A 0 A_SetCrosshair(-1);
				TNT1 A 0 A_StartSound("weapons/CryoRifle/up", CHAN_AUTO, CHANF_OVERLAP);
				FR00 ABCDEFGHIJKLMNO 1 A_DoPBWeaponAction();
				TNT1 A 0 A_StartSound("weapons/CryoRifle/respect2", CHAN_AUTO, CHANF_OVERLAP);
				FR00 PQRSTUVWXYZ 1 A_DoPBWeaponAction();
				FR01 ABCD 1 A_DoPBWeaponAction();
				TNT1 A 0 {
					A_StartSound("weapons/CryoRifle/respect3", CHAN_AUTO, CHANF_OVERLAP);
					A_StartSound("weapons/CryoRifle/respect1", CHAN_AUTO, CHANF_OVERLAP);
				}
				FR01 EFGHIJKLMNOPQRSTUVWXYZ 1 {
					A_FireCustomMissile("GunFireSmoke", 0, 0, -2, -5, 0, 0);
					return A_DoPBWeaponAction();
				}
				FR02 ABCDEFGH 1 {
					A_FireCustomMissile("GunFireSmoke", 0, 0, -2, -5, 0, 0);
					return A_DoPBWeaponAction();
				}
				FR02 IJKL 1 A_DoPBWeaponAction();
				TNT1 A 0 {
					A_StartSound("weapons/CryoRifle/idle", CHAN_6, CHANF_LOOPING|CHANF_OVERLAP);
					A_StartSound("PLSIDLE", CHAN_7, CHANF_LOOPING|CHANF_OVERLAP);
				}
				FR02 MNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
				FR60 ABCDEFGHIJKLMNOPQ 1 A_DoPBWeaponAction();
				Goto Ready3;

		Deselect:
			// Cache Sprites
			FR93 NOPQ 0;
			// Code
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_ClearOverlays(BIG_TUBEGLOW,MUZZLE_GLOW);
				PB_SetRoll(0);
				A_Setinventory("PB_LockScreenTilt",0);
				A_StopSound(1);
				A_StopSound(2);
				A_StopSound(CHAN_6);
				A_StopSound(CHAN_7);
			}
			FR03 NOPQ 1 setSprite("FR03","FR93");
			TNT1 A 0 setOvercooling(0);
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
			Wait;

		Select:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",0);
				PB_WeapTokenSwitch("CryoRifleSelected");
				PB_HandleCrosshair(79);
				PB_WeaponRaise("weapons/CryoRifle/respect1");
				return PB_RespectIfNeeded();
			}
		SelectAnimation:
			FR03 ABCD 1;
		// Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			TNT1 A 0 {
				A_TakeInventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(79);
				A_StartSound("weapons/CryoRifle/idle", CHAN_6, CHANF_LOOPING|CHANF_OVERLAP);
				A_StartSound("PLSIDLE", CHAN_7, CHANF_LOOPING|CHANF_OVERLAP);
			}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "GunEmpty");
		ReadyToFire1:
			FR03 EFGHIJKLMMLKJIHGFE 1 cryo_ready();
			FR03 EFGHIJKLMMLKJIHGFE 1 cryo_ready();
			Loop;

		GunEmpty:
			TNT1 A 0 A_StopSound(CHAN_6);
			TNT1 A 0 A_StopSound(CHAN_7);
			FR03 EE 1 cryo_ready(true);
			Goto GunEmpty+3; // This is so it skips the stop sound I guess

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			// Cache Sprites
			FR11 ABCDEFGHI 0;
			// Code
			TNT1 A 0			cryo_firePrimary(0);
			TNT1 A 0 A_JumpIf(getPrimary() == PRIM_BEAM, "FireBeam");
		FireMissile:
			TNT1 A 0 PB_JumpIfNoAmmo("Reload", TAKE_MISSILE);
			TNT1 A 0			cryo_firePrimary(1);
			FR10 HGFEDCB 1		cryo_firePrimary(2);
		HoldMissile:
			FR10 A 1 BRIGHT	 cryo_firePrimary(3);
			FR10 BCD 1 BRIGHT	cryo_firePrimary(4);
			FR10 EFGHI 1 setSprite('FR10', 'FR11');
			TNT1 A 0 Cryo_CheckRefire(false);
			TNT1 A 0 A_ReFire("HoldMissile");
			TNT1 A 0 A_StartSound("weapons/CryoRifle/powerdown", CHAN_AUTO, CHANF_OVERLAP);
		EndMissile:
			Goto Ready3;

		FireBeam:
			TNT1 A 0 PB_JumpIfNoAmmo();
			TNT1 A 0			cryo_firePrimary(1,true);
			FR10 HGFEDCB 1		cryo_firePrimary(2,true);
		HoldBeam:
			// Cache Sprites
			FR14 ABC 0;
			// Code
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount < 1, "EndBeam");
			FR13 ABCB 1 BRIGHT	cryo_firePrimary(3,true);
			TNT1 A 0 {
				PB_TakeAmmo(invoker.ammo2.getClassName(),TAKE_BEAM, 0);
				PB_ReFire("HoldBeam");
			}
		EndBeam:
			TNT1 A 0 {
				A_StopSound(CHAN_WEAPON);
				A_StopSound(CHAN_5);
				A_StartSound("weapons/CryoRifle/powerdown", CHAN_5, CHANF_OVERLAP);
			}
			FR10 CDEFGHI 1 setSprite('FR10', 'FR11');
			Goto Ready3;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
		AltFire:
			TNT1 A 0			cryo_fireSecondary(0);
		AltFireMissile:
			TNT1 A 0 cryo_checkSecondary();
			FR10 HGFEDCB 1		cryo_fireSecondary(1);
		AltHoldMissile:
			FR10 A 1			cryo_fireSecondary(2);
			FR10 BCD 1 BRIGHT	cryo_fireSecondary(3);
			FR10 EFGH 1 setSprite('FR10', 'FR11');
			TNT1 A 0 A_JumpIf(getSecondary() == SEC_FLAK, "AltRefire");
			FR10 IIIIII 1		cryo_fireSecondary(4);
			FR10 III 1			cryo_fireSecondary(5);
			FR10 III 1			cryo_fireSecondary(6);
			TNT1 A 0 A_WeaponOffset(0, 32);
		AltRefire:
			TNT1 A 0 Cryo_CheckRefire(true);
			TNT1 A 0 A_ReFire("AltHoldMissile");
			TNT1 A 0 A_StartSound("weapons/CryoRifle/powerdown", CHAN_AUTO, CHANF_OVERLAP);
			Goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		WeaponSpecial:
			TNT1 A 0 Cryo_WeaponSpecial(); // Handles all the weapon wheel logic
		SwitchMode:
			FR20 ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("weapons/CryoRifle/respect2", CHAN_AUTO, CHANF_OVERLAP);
			FR20 MNOPQRSTUU 1 A_FireCustomMissile("GunFireSmoke", 0, 0, -5, -5, 0, 0);
			TNT1 A 0 A_StartSound("weapons/CryoRifle/respect3", CHAN_AUTO, CHANF_OVERLAP);
			FR20 VWXYZ 1 A_FireCustomMissile("GunFireSmoke", 0, 0, -5, -5, 0, 0);
			FR21 ABCDEFGHIJKLMNOPQRS 1;
			Goto Ready3;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Reload:
			// Cache Sprites
			FR94 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			FR95 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			FR96 ABCDEFGHIJKLMN 0;
			// Code
			TNT1 A 0 PB_CheckReload("ReloadUnloaded",null,null,"Ready3","Ready3",MAGAZINE_SIZE);
			TNT1 A 0 {
				A_StopSound(1);
				A_StopSound(6);
				A_ClearOverlays(7,9);
				A_StartSound("weapons/CryoRifle/reload1", CHAN_AUTO, CHANF_OVERLAP);
			}
			FR04 ABCDEFGHIJ 1 setSprite("FR04","FR94");
			FR04 KLM 1 {
				setSprite("FR04","FR94");
				A_FireCustomMissile("GunFireSmoke", 0, 0, 5, -5, 0, 0);
			}
			TNT1 A 0 A_StartSound("weapons/CryoRifle/reload3", CHAN_AUTO, CHANF_OVERLAP);
			
			FR04 NOPQRSTUVW 1 {
				setSprite("FR04","FR94");
				A_FireCustomMissile("GunFireSmoke", 0, 0, 5, -5, 0, 0);
			}
			TNT1 A 0 {
				A_StartSound("weapons/CellEject", CHAN_AUTO, CHANF_OVERLAP);
				if (PB_GetMagEmpty()) PB_SpawnCasing("EmptyCell",10,-10,12,Frandom(-2,2),Frandom(-9,-6),Frandom(3,6));
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
			FR04 XYZ 1 {
				setSprite("FR04","FR94");
				A_FireCustomMissile("GunFireSmoke", 0, 0, 5, -6, 0, 0);
			}
			FR05 ABCDEF 1 {
				setSprite("FR05","FR95");
				A_FireCustomMissile("GunFireSmoke", 0, 0, 5, -5, 0, 0);
			}
		ContinueReload:
			FR05 GHIJKLM 1 {
				setSprite("FR05","FR95");
				A_FireCustomMissile("GunFireSmoke", 0, 0, 5, -5, 0, 0);
			}
			TNT1 A 0 A_StartSound("weapons/CryoRifle/reload2", CHAN_AUTO, CHANF_OVERLAP);
			FR05 NOOOPQRS 1 setSprite("FR05","FR95");
			TNT1 A 0 {
				A_StartSound("weapons/plasma/cellin", CHAN_AUTO, CHANF_OVERLAP);
				PB_AmmoIntoMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName(),MAGAZINE_SIZE);
				PB_SetMagEmpty(false);
				PB_SetMagUnloaded(false);
				PB_SetChamberEmpty(false);
			}
			FR05 TUVWXYZ 1 {
				setSprite("FR05","FR95");
			}
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", CHAN_AUTO, CHANF_OVERLAP);
			FR06 ABCDEFGHI 1 setSprite("FR06","FR96");
			TNT1 A 0 A_StartSound("weapons/CryoRifle/up", CHAN_AUTO, CHANF_OVERLAP);
			FR06 JKLMN 1 setSprite("FR06","FR96");
			Goto Ready3;

		ReloadUnloaded:
			TNT1 A 0 {
				A_StopSound(1);
				A_StopSound(6);
				A_ClearOverlays(7,9);
				A_StartSound("weapons/CryoRifle/reload1", CHAN_AUTO, CHANF_OVERLAP);
			}
			FR06 NMLKJIHGFEDCBA 1 setSprite("FR06","FR96");
			TNT1 A 0 A_StartSound("weapons/CryoRifle/reload3", CHAN_AUTO, CHANF_OVERLAP);
			Goto ContinueReload;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
		Unload:
			TNT1 A 0 {
				A_StopSound(1);
				A_StopSound(6);
				A_ClearOverlays(7,9);
				A_StartSound("weapons/CryoRifle/reload1", CHAN_AUTO, CHANF_OVERLAP);
			}
			TNT1 A 0 A_PlaySoundEx("weapons/CryoRifle/reload1", "Auto");
			FR06 NMLKJIHGFEDCBA 1 setSprite("FR06","FR96");
			TNT1 A 0 A_PlaySoundEx("weapons/CryoRifle/reload3", "Auto");
			TNT1 A 0 {
				A_StartSound("weapons/CellEject", CHAN_AUTO, CHANF_OVERLAP);
				if (PB_GetMagEmpty()) PB_SpawnCasing("EmptyCell",10,-10,12,Frandom(-2,2),Frandom(-9,-6),Frandom(3,6));
				PB_UnloadMag(invoker.ammo2.getClassName(),invoker.ammo1.getClassName());
				PB_SetMagEmpty(true);
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
			FR05 ZYXWVUTSTRQPONMLKJIHG 1 setSprite("FR05","FR95");
			FR04 IHGFEDCBA 1 setSprite("FR04","FR94");
			Goto Ready3;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
			TNT1 A 0 A_JumpIf(hasCooled(), "FlashPunchingFrost");
			FR42 ABCDEFGGHIJKLM 1;
			Goto Ready3;

		FlashPunchingFrost:
			FR72 ABCDEFGGHIJKLM 1;
			Goto Ready3;

		FlashKicking:
			TNT1 A 0 A_JumpIf(hasCooled(), "FlashKickingFrost");
			FR40 ABCDEFGGHIJKLM 1;
			Goto Ready3;

		FlashKickingFrost:
			FR70 ABCDEFGGHIJKLM 1;
			Goto Ready3;

		FlashAirKicking:
			TNT1 A 0 A_JumpIf(hasCooled(), "FlashAirKickingFrost");
			FR40 ABCDEFGGGHIJKLM 1;
			Goto Ready3;

		FlashAirKickingFrost:
			FR70 ABCDEFGGGHIJKLM 1;
			Goto Ready3;

		FlashSlideKicking:
			TNT1 A 0 A_JumpIf(hasCooled(), "FlashSlideKickingFrost");
			FR41 ABCDEFGHIJKLMNOPQRSSSTUVWX 1;
			Goto Ready3;

		FlashSlideKickingFrost:
			FR71 ABCDEFGHIJKLMNOPQRRRRRSTUV 1;
			Goto Ready3;

		FlashSlideKickingStop:
			TNT1 A 0 A_JumpIf(hasCooled(), "FlashSlideKickingStopFrost");
			FR41 TTTUVWX 1;
			Goto Ready3;
			
		FlashSlideKickingStopFrost:
			FR71 RRRSTUV 1;
			Goto Ready3;

		Flash:
			TNT1 A 1;
			Goto LightDone;

		BigTubeGlow:
			// Cache Sprites
			FR50 ABCDEFGHIJKLMNO 0;
			FR51 ABCDEFGHIJKLMNO 0;
			FR52 ABCDEFGHIJKLMNO 0;
			// Code
			FR50 A 1 Cryo_SetGlowOverlay(BIG_TUBEGLOW);
			Stop;

		SmallTubeGlow:
			FR51 A 1 Cryo_SetGlowOverlay(SMALL_TUBEGLOW);
			Stop;

		MuzzleGlow:
			FR52 A 1 Cryo_SetGlowOverlay(MUZZLE_GLOW);
			Stop;

	}
}

//////////////////////////// PROJECTILES/OTHERS ////////////////////////////////////////////////////////////////////////////////////
class IceMissile : PB_ProjectileAlt {
	Default {
		PB_Projectile.BaseDamage 50;
		+PB_PROJECTILE.NOCRITICALS
		Radius 4;
		Height 8;
		Speed 52;
		DamageType "Ice";
		RenderStyle "Add";
		Alpha 0.95;
		-NODAMAGETHRUST
		+FORCEXYBILLBOARD
		+SQUAREPIXELS
		+FORCERADIUSDMG
		+BLOODLESSIMPACT
		+BRIGHT
		Decal "FreezerBurn";
	}
	States {
	Spawn:
		FRPJ ABC 1 A_SpawnItemEx("CryoRifleTrailSparksSmall", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0) ;
		TNT1 A 0 {
			A_SpawnProjectile("BlueFlareSpawn", 0);
			A_SpawnProjectile("Icetracer", 0, angle:random (0, 359), pitch:random (-180, 180));
		}
		Loop;
	Death:
		TNT1 A 0 {
			A_Explode(100, 80, 0, damagetype:"Ice");
			if(A_CheckFloor(1)) {
				for(int i = 0; i < 14; i++) {
					A_SpawnItemEx("DetectFloorIce", random(-30, 30), random(-30, 30), 1);
				}
			}
			if(A_CheckCeiling(1)) {
				for(int i = 0; i < 4; i++) {
					A_SpawnItemEx("DetectCeilIce", random(-15, 15), random(-15, 15), 1);
				}
			}
			for(int i = 0; i < 8; i++) {
				A_SpawnItemEx("CryoSmoke", xvel:frandom(1.0, 3.0), 0, frandom(0, 0.1), random(0, 359));
				A_SpawnItemEx("CryoSmoke3", xvel:frandom(0.4, 1.2), 0, frandom(0, 0.4), random(0, 359), failchance:64);
				A_SpawnItemEx("CryoRifleTrailSparksSmall", random(5, -5), random(5, -5), random(5, -5), frandom(0.4, 1.2), 0, frandom(0, 0.4), random(0, 359), failchance:64);
				A_SpawnItemEx("CryoSmoke2", xvel:frandom(0.4, 1.2), 0, frandom(0, 0.4), random(0, 359), failchance:64);
			}
			A_SpawnItemEx("IceExplosionImpact", angle:random(0,360));
			A_StartSound("weapons/CryoRifle/freezeobject", CHAN_AUTO);
			A_StartSound("weapons/CryoRifle/missiledeath", CHAN_AUTO);
		}
		BXPL ABCDEFGH 1;
		BXPL IJKLLM 1 A_FadeOut(0.1);
		Stop;
	}
}

class IceSpear : PB_ProjectileAlt {
	Default {
		PB_Projectile.BaseDamage 340;
		PB_Projectile.RipperCount 100;
		+PB_PROJECTILE.NOCRITICALS;
		-NOGRAVITY
		+RIPPER
		+BRIGHT
		Gravity 0.1;
		+BloodSplatter;
		Radius 4;
		Height 8;
		Speed 110;
		Damagetype "Blast";
		Scale 1.25;
		RipperLevel 1;
		SeeSound " ";
		DeathSound "weapons/CryoRifle/speardeath";
		Decal "FreezerBurnSmall";
	}
	States {
	Spawn:
		ISPR A 1 A_CustomMissile ("Icetracer", 0, 0, random (0, 360), 2, random (0, 360));
		Loop;
	Death:
		TNT1 A 0 {
			A_ChangeFlag("NOGRAVITY",1);
			A_Stop();
			for(int i = 0; i < 8; i++) {
				A_SpawnItemEx("CryoSmoke", xvel:frandom(1.0, 3.0), 0, frandom(0, 0.1), random(0, 359));
				A_SpawnItemEx("CryoSmoke3", xvel:frandom(0.4, 1.2), 0, frandom(0, 0.4), random(0, 359), failchance:64);
				A_SpawnItemEx("CryoRifleTrailSparksSmall", random(5, -5), random(5, -5), random(5, -5), frandom(0.4, 1.2), 0, frandom(0, 0.4), random(0, 359), failchance:64);
				A_SpawnItemEx("CryoSmoke2", xvel:frandom(0.4, 1.2), 0, frandom(0, 0.4), random(0, 359), failchance:64);
			}
		}
		ISPR A 70 Bright;
		ISPR A 1 Bright A_FadeOut(0.02);
		Wait;
	}
}

class IceFlak1 : PB_ProjectileAlt {
	Default {
		PB_Projectile.BaseDamage 32;
		+PB_PROJECTILE.NOCRITICALS
		+BLOODSPLATTER
		+ROLLSPRITE
		+SQUAREPIXELS
		+FORCEXYBILLBOARD
		-NOGRAVITY
		Radius 2;
		Height 4;
		Speed 45;
		Mass 200;
		Scale 0.75;
		Damagetype "Cutless";
		BounceType "Doom";
		BounceFactor 0.65;
		BounceSound "IceShardBounce";
		Decal "FreezerBurnSmall";
	}
	States {
	Spawn:
		CSC2 C 1 Bright {
			A_SpawnProjectile("SmallIcetracer", 0, angle:random (0, 359), pitch:random (-180, 180));
			A_SetRoll(Roll+45);
		}
		Loop;
	Death:
		EXPL A 0 A_CustomMissile ("IceDust", 4, 0, random (0, 360), 2, random (0, 360));
		Stop;
	}
}

class IceFlak2 : IceFlak1 {
	Default {
		Damagetype "Saw";
	}
	States {
	Spawn:
		CSD8 B 1 Bright {
			A_CustomMissile ("SmallIcetracer", 0, 0, random (0, 360), 2, random (0, 360));
			A_SetRoll(Roll+45);
		}
		Loop;
	}
}

class IceFlak3 : IceFlak1 {
	Default {
		Damagetype "Blast";
	}
	States {
	Spawn:
		CSD9 C 1 Bright {
			A_CustomMissile ("SmallIcetracer", 0, 0, random (0, 360), 2, random (0, 360));
			A_SetRoll(Roll+45);
		}
		Loop;
	}
}
class IceFlak4 : IceFlak1 {
	Default {
		Damagetype "Shotgun";
	}
	States {
	Spawn:
		ICC5 D 1 Bright {
			A_CustomMissile ("SmallIcetracer", 0, 0, random (0, 360), 2, random (0, 360));
			A_SetRoll(Roll+45);
		}
		Loop;
	}
}

/////EFFECTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////
class CryoSmoke : actor
{
	Default {
	Radius 2;
	Height 2;
	+NOINTERACTION;
	+FORCEXYBILLBOARD;
	RenderStyle "Shaded";
	StencilColor "A0 FF FF";
	Alpha 0.8;
	Scale 0.85;
	}
		States {
			Spawn:
				SMKO A 0;
				SMK2 A 2 A_FadeOut (0.05);
				Wait;	}}
class CryoSmoke2 : CryoSmoke { 
	Default {
	StencilColor "DD DD DD"; Scale 0.7; Alpha 0.5; VSpeed 2.5;
	}
		States {
			Spawn:
				TNT1 A 0;
				SMK2 A 6 A_FadeOut(0.04);
				Wait;	}}
class CryoSmoke3 : CryoSmoke { 
	Default {
	StencilColor "AA FF FF"; Scale 0.7; Alpha 0.4; VSpeed 2.25;
	}
		States {
			Spawn:
				TNT1 A 0;
				TNT1 A 0 A_PlaySound("Weapons/CryoRifleRecharge");
				SMK2 A 6 A_FadeOut(0.04);
				Wait;	}}
class MiniCryoSmoke1 : CryoSmoke { 
	Default {
	StencilColor "AA FF FF"; Scale 0.7; Alpha 0.4; VSpeed 2.25;
	Scale 0.25;
	}
		States {
			Spawn:
				TNT1 A 0;
				TNT1 A 0 A_PlaySound("Weapons/CryoRifleRecharge");
				SMK2 A 6 A_FadeOut(0.04);
				Wait;	}}

class IceTracer : Actor {
	Default {
		Height 0;
		Radius 0;
		Mass 0;
		+RollSprite;
		+Missile;
		+NoBlockMap;
		+DontSplash;
		+FORCEXYBILLBOARD;
		Gravity 0.1;
		RenderStyle "Add";
		Alpha 0.9;
		StencilColor "A0 FF FF";
		Scale 0.4;
		Speed 0;
	}
	States {
	Spawn:
	Death:
		TNT1 A 2;
		FRPJ HHHEEEFFFGGG 1 Bright {
			A_FadeOut(0.04);
			A_SetRoll(roll-frandom(-15,15));
		}
		Stop;
	}
}

class SmallIceTracer : IceTracer {
	States {
	Spawn:
	Death:
		TNT1 A 2;
		SHEX AABBCCDDEE 1 Bright {
			A_FadeOut(0.04);
			A_SetRoll(roll-frandom(-15,15));
		}
		Stop;
	}
}

class CryoTrail : Actor {
	Default {
	+NOINTERACTION;
	Radius 4;
	Height 8;
	Renderstyle "Add";
	Alpha 0.5;
	YScale 0.3;
	XScale 0.6;
	}
	States {
	Spawn:
		X027 ABCDEFGHIJK 1 Bright;
		Stop;
	}
}