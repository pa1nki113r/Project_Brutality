
// blood actor with trail, might be a little expensive
class PB_XDeath1 : PB_TinyGibBase
{
	Default
	{
		Radius 8;
		Height 8;
		Speed 10;
		Scale 1.2;
		Mass 1;

		+BLOODLESSIMPACT;
		+THRUGHOST;

		SeeSound "misc/xdeath4";
		DeathSound "misc/xdeath1";
		Decal "BloodSplat";
	}

	States
	{
		Spawn:
			BLOD A 4 NoDelay A_SpawnItemEx("NashGoreClassicBloodTrail", flags: NGORE_BLOOD_FLAGS);
			Loop;

		Death:
			TNT1 A 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS);
			XDT1 EFGHIJKL 3;
			Stop;
	}
}

// that one classic organ sprite
class PB_XDeath2: PB_XDeath1
{
	Default
	{
		Gravity 0.4;
		Scale 1.1;
		DeathSound "misc/xdeath2";
	}

	States
	{
		Spawn:
			XME1 ABCD 3 NoDelay A_SpawnItemEx("NashGoreClassicBloodTrail", flags: NGORE_BLOOD_FLAGS);
			Loop;
		Death:
			TNT1 AAAAAAA 0 A_SpawnProjectile ("NashGoreClassicBloodTrail", 0, 0, random (0, 180), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 180));
			TNT1 A 0 A_CheckFloor("SpawnFloor");
			Stop;
		SpawnFloor:
			XME1 E 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS & ~SXF_NOCHECKPOSITION, 150);
			XME1 EEEEEEEEEE 1 {
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NGORE_BLOOD_FLAGS, 175);
			}
			XME1 E -1;
			Stop;
	}
}

class PB_XDeath2b : PB_XDeath2
{
	Default
	{
		Speed 4;
	}
}

// looks like an exploded organ or something idk, tons of identical sprites
class PB_XDeath3 : PB_XDeath2
{
	Default
	{
		DeathSound "misc/xdeath3";
	}

	States
	{
		Spawn:
			XME2 ABCD 3 NoDelay A_SpawnItemEx("NashGoreClassicBloodTrail", flags: NGORE_BLOOD_FLAGS);
			Loop;
		Death:
			TNT1 AAAAAAA 0 A_SpawnProjectile("NashGoreClassicBloodTrail", 0, 0, random (0, 180), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 180));
			TNT1 A 0 {
				A_CheckFloor("SpawnFloor");
				//A_SpawnItemEx ("DetectCeilBloodSimplerLarge",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx ("PB_DetectCeilXDeath2",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			}
			Stop;
		SpawnFloor:
			TNT1 A 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS);
			XME2 EEEEEEEEEE 1 {
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NGORE_BLOOD_FLAGS, 175);
			}
			XME2 E -1;
			Stop;
	}
}

class PB_XDeath3b : PB_XDeath3
{
	Default
	{
		Speed 4;
		Gravity 0.7;
	}
}

// big ribcage chunk
class PB_XDeath4 : PB_XDeath3
{
	Default
	{
		BounceType "Doom";
		BounceFactor 0.3;
	}
	
	States
	{
		Spawn:
			XME3 ABCDEFGH 3 NoDelay A_SpawnItemEx("NashGoreClassicBloodTrail", flags: NGORE_BLOOD_FLAGS);
			Loop;
		Death:
			TNT1 A 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS);
			TNT1 A 0 A_Jump(255, "Death1", "Death2");
		
		Death1:
			XME3 GH 3;
			XME3 A -1;
			Stop;
		Death2:
			XME3 I -1;
			Stop;
	}
}

// full ribcage
class PB_XDeath5 : PB_XDeath4
{
	States
	{
		Spawn:
			XME5 ABCD 3 NoDelay A_SpawnItemEx("NashGoreClassicBloodTrail", flags: NGORE_BLOOD_FLAGS);
			Loop;
		Death:
			TNT1 A 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS);
			XME5 E -1;
			Stop;
	}
}

// Smaller Gibs from Nash's base giblets
class PB_SmallGib : PB_TinyGibBase
{
	Default
	{
		Radius 8;
		Height 4;
		Gravity 0.875;

		BounceType 'Doom';
		BounceFactor 0.5;

		BounceSound "misc/xdeath1";
		SeeSound "misc/xdeath4";

		+CANBOUNCEWATER
	}

	States
	{
		Spawn:
			TNT1 A 0 NoDelay A_Jump(256, "Gib2", "Gib3", "Gib7", "Gib8", "Gib9");
			Stop;
		Gib2:
			GIB2 A 0;
			Goto SpawnLoop;
		Gib3:
			GIB3 A 0;
			Goto SpawnLoop;
		Gib7:
			GIB7 A 0;
			Goto SpawnLoop;
		Gib8:
			GIB8 A 0;
			Goto SpawnLoop;
		Gib9:
			GIB9 A 0;
			Goto SpawnLoop;
		SpawnLoop:
			"####" ABCD 3;
			Loop;
		Death:
			"####" E 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS);
			"####" EEEEEEEEEE 1 {
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NGORE_BLOOD_FLAGS, 175);
			}
			"####" E -1;
			Stop;
	}
}

// some generic organs
class PB_XDeathOrgan1: PB_XDeath2
{
	Default
	{
		Scale 0.9;
		Speed 4;
	}
    States
    {
		Spawn:
			XME8 A 4 NoDelay A_SpawnItemEx("NashGoreClassicBloodTrail", flags: NGORE_BLOOD_FLAGS);
			Loop;
		Death:
			XME8 A -1;
			Stop;
    }
}

class PB_XDeathOrgan1b: PB_XDeathOrgan1
{
	Default
	{
		XScale 0.7;
		YScale 0.5;
	}
}

class PB_XDeathOrgan2: PB_XDeathOrgan1
{
	States
	{
		Spawn:
			XME8 B 4 NoDelay A_SpawnItemEx("NashGoreClassicBloodTrail", flags: NGORE_BLOOD_FLAGS);
			Loop;
		Death:
			XME8 B -1;
			Stop;
	}
}

// hear me out they MIGHT be guts...
class PB_XDeathGuts: PB_XDeath2
{
    States
    {
		Spawn:
			XME4 ABCD 8;
			Loop;
		Death:
			TNT1 AAA 0 A_SpawnProjectile ("NashGoreClassicBloodTrail", 0, 0, random (0, 180), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 180));
			XME4 E -1;
			Stop;
    }
}

// pieces of skin
class PB_XDeathSkinPiece1: PB_XDeath1
{
	Default
	{
		Radius 2;
		Height 2;
		Scale 1.0;
		Mass 1;
		SeeSound "none";
		DeathSound "none";
	}
	
    States
    {
		Spawn:
			XSKI A 4;
			Loop;
		Death:
			TNT1 A 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS);
			XSKI B 1 {
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NGORE_BLOOD_FLAGS, 175);
			}
			XSKI B -1;
			Stop;
    }
}	

class PB_XDeathSkinPiece2: PB_XDeathSkinPiece1
{
    States
    {
		Spawn:
			XSKI C 4;
			Loop;
		Death:
			TNT1 A 0 A_SpawnItemEx("PB_BloodSpot", flags: NGORE_BLOOD_FLAGS);
			XSKI D 1 {
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NGORE_BLOOD_FLAGS, 175);
			}
			XSKI D -1;
			Stop;
	}
}

// burned meat
class PB_XDeathBurnedMeat : PB_GibBase
{
	Default
	{
		Radius 8;
		Height 8;
		Speed 5;
		Mass 6;
		BounceFactor 0.5;
		BounceType "Doom";
		+NOBLOCKMAP;
		+MISSILE;
	}
	
    States
    {
		Spawn:
			CARB A 10 NoDelay A_SpawnProjectile("PlasmaSmoke", 0, 0, 180, PB_GORE_PROJECTILE_FLAGS);
			Loop;
		Death:
			CARB A 1 A_SpawnItemEx("MicroSmokeColumnWide");
			CARB A -1;
			Stop;
    }
}

class PB_XDeathBurnedMeat2 : PB_XDeathBurnedMeat
{
    States
    {
		Spawn:
			CARB B 10 NoDelay A_SpawnProjectile("PlasmaSmoke", 0, 0, 180, PB_GORE_PROJECTILE_FLAGS);
			Loop;
		Death:
			CARB B 1 A_SpawnItemEx("MicroSmokeColumnWide", 0, 1);
			CARB B -1;
			Stop;
    }
}

class PB_XDeathBurnedMeat2 : PB_XDeathBurnedMeat
{
    States
    {
		Spawn:
			CARB C 10 NoDelay A_SpawnProjectile("PlasmaSmoke", 0, 0, 180, PB_GORE_PROJECTILE_FLAGS);
			Loop;
		Death:
			CARB C 1 A_SpawnItemEx("MicroSmokeColumnWide", 0, 1);
			CARB C -1;
			Stop;
    }
}

class PB_XDeathBurnedArm : PB_XDeathBurnedMeat
{
    States
    {
		Spawn:
			CARB D 10 NoDelay A_SpawnProjectile("PlasmaSmoke", 0, 0, 180, PB_GORE_PROJECTILE_FLAGS);
			Loop;
		Death:
			CARB D 1 A_SpawnItemEx("MicroSmokeColumnWide", 0, 1);
			CARB D -1;
			Stop;
    }
}

class PB_XDeathBurnedLeg : PB_XDeathBurnedMeat
{
    States
    {
		Spawn:
			CARB E 10 NoDelay A_SpawnProjectile("PlasmaSmoke", 0, 0, 180, PB_GORE_PROJECTILE_FLAGS);
			Loop;
		Death:
			CARB E 1 A_SpawnItemEx("MicroSmokeColumnWide", 0, 1);
			CARB E -1;
			Stop;
    }
}

class PB_XDeathBurnedSkull : PB_XDeathBurnedMeat
{
    States
    {
		Spawn:
			BURN B 10 NoDelay A_SpawnProjectile("PlasmaSmoke", 0, 0, 180, PB_GORE_PROJECTILE_FLAGS);
			Loop;
		Death:
			BURN B 1 A_SpawnItemEx("MicroSmokeColumnWide", 0, 1);
			BURN B -1;
			Stop;
    }
}
