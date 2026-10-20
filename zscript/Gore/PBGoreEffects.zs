class PB_ZombieXDeath : PB_GibBase
{
	Default
	{
		Radius 1;
		Height 1;
		Scale 0.8;
		Speed 0;
		Mass 1;
		Decal "BloodSuper";
		BounceFactor 0.5;
		+BOUNCEONWALLS; +BOUNCEONFLOORS; +ALLOWBOUNCEONACTORS; +BOUNCEAUTOOFF;
		+MISSILE;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+MOVEWITHSECTOR;
		+NOGRAVITY;
		+NOCLIP;
		+DONTSPLASH;
	}
    States
    {
    Spawn:
		 TNT1 A 0 A_Pain();
		 TNT1 A 0 A_FaceTarget();
		 TNT1 A 0 A_FaceMovementDirection();
	     TNT1 A 0 A_SpawnItem("BloodSplasher3");
		 TNT1 A 0 A_SpawnItem ("PB_BigBloodSpot");
		 TNT1 AAAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_SuperWallRedBlood", 40, 0, angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (-15, 15));
	     TNT1 A 0 A_SpawnProjectile ("PB_XDeathArm1", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath4", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath3", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathHalfZombiemanNoArmNoHead", 48, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan1", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan2", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAAAAA 0 A_SpawnProjectile ("PB_Intestine", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathZombieLeg", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_GibZombieBoot", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathZombiemanHeadOnXDeath", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
 
		 TNT1 AAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_BloodmistBig", 30, 0, random (0, 360), 2, random (20, 90));
		TNT1 A 1;
		 TNT1 A 2;
		  Stop;
	}
}

class PB_ZombieXDeathNoHead : PB_GibBase
{
	Default
	{
		Radius 1;
		Height 1;
		Scale 0.8;
		Speed 0;
		Mass 1;
		Decal "BloodSuper";
		BounceFactor 0.5;
		+BOUNCEONWALLS; +BOUNCEONFLOORS; +ALLOWBOUNCEONACTORS; +BOUNCEAUTOOFF;
		+MISSILE;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+MOVEWITHSECTOR;
		+NOGRAVITY;
		+NOCLIP;
		+DONTSPLASH;
	}
    States
    {
    Spawn:
		 TNT1 A 0 A_Pain();
		 TNT1 A 0 A_FaceTarget();
		 TNT1 A 0 A_FaceMovementDirection();
	     TNT1 A 0 A_SpawnItem("BloodSplasher3");
		 TNT1 A 0 A_SpawnItem ("PB_BigBloodSpot");
		 TNT1 AAAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_SuperWallRedBlood", 40, 0, angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (-15, 15));
	     TNT1 A 0 A_SpawnProjectile ("PB_XDeathArm1", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath4", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath3", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathHalfZombiemanNoArmNoHead", 48, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan1", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan2", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAAAAA 0 A_SpawnProjectile ("PB_Intestine", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathZombieLeg", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_GibZombieBoot", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		
		 TNT1 AAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_BloodmistBig", 30, 0, random (0, 360), 2, random (20, 90));
		TNT1 A 1;
		 TNT1 A 2;
		  Stop;
	}
}

class PB_HelmetZombieXDeath : PB_GibBase
{
	Default
	{
		Radius 1;
		Height 1;
		Scale 0.8;
		Speed 0;
		Mass 1;
		Decal "BloodSuper";
		BounceFactor 0.5;
		+BOUNCEONWALLS; +BOUNCEONFLOORS; +ALLOWBOUNCEONACTORS; +BOUNCEAUTOOFF;
		+MISSILE;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+MOVEWITHSECTOR;
		+NOGRAVITY;
		+NOCLIP;
		+DONTSPLASH;
	}
    States
    {
    Spawn:
		 TNT1 A 0 A_Pain();
		 TNT1 A 0 A_FaceTarget();
		 TNT1 A 0 A_FaceMovementDirection();
	     TNT1 A 0 A_SpawnItem("BloodSplasher3");
		 TNT1 A 0 A_SpawnItem ("PB_BigBloodSpot");
		 TNT1 AAAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_SuperWallRedBlood", 40, 0, angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (-15, 15));
	     TNT1 A 0 A_SpawnProjectile ("PB_XDeathArm1", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath4", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath3", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathHalfZombiemanNoArmNoHead", 48, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan1", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan2", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAAAAA 0 A_SpawnProjectile ("PB_Intestine", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathZombieLeg", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_GibZombieBoot", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathHelmetZombiemanHeadOnXDeath", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
 
		 TNT1 AAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_BloodmistBig", 30, 0, random (0, 360), 2, random (20, 90));
		TNT1 A 1;
		 TNT1 A 2;
		  Stop;
	}
}

class PB_ZombiemanHeadExplode: PB_ZombieXDeath
{
    Default {
        Height 0;
        Radius 0;
    }
    States
    {
		Spawn:
			TNT1 A 0 NoDelay A_StartSound("misc/xdeath4");
			TNT1 A 0 A_StartSound("gore/headshot", 2);
			TNT1 AAAAA 0 A_SpawnProjectile ("PB_BloodmistBig", 0, 0, random (0, 360), 2, random (30, 90));
			TNT1 AAAA 0 A_SpawnProjectile ("NashGoreBloodSpurt", 0, 0, random (0, 360), 2, random (30, 90));
			TNT1 A 0 A_SpawnProjectile ("PB_Brains2", 0, 0, random (0, 360), 2, random (0, 160));
			TNT1 A 0 A_SpawnProjectile ("PB_Brains3", 0, 0, random (0, 360), 2, random (0, 160));
			TNT1 A 0 A_SpawnProjectile ("PB_Brains4Green", 0, 0, random (0, 360), 2, random (0, 160));
			TNT1 A 0 A_SpawnProjectile ("PB_Brains4GreenBig", 0, 0, random (0, 360), 2, random (0, 160));
			TNT1 AAA 0 A_SpawnProjectile ("PB_SmallBrainPieceFast", random (45, 55), random (5, -5), random (170, 190), 2, random (-10, 10));
			TNT1 AAAAA 0 A_SpawnProjectile ("PB_SmallBrainPiece", 0, 0, random (0, 360), 2, random (0, 160));
			TNT1 AA 0 A_SpawnProjectile ("PB_SuperWallRedBlood", 6, 0, random (170, 190), 2, random (0, 40));
			TNT1 AAAA 0 A_SpawnProjectile ("PB_Teeth", 0, 0, random (0, 360), 2, random (0, 160));
			TNT1 AAA 0 A_SpawnProjectile ("PB_XDeath1", 0, 0, random (0, 360), 2, random (0, 160));
			TNT1 A 0 A_SpawnProjectile ("PB_XDeath3", 10, 0, random (0, 360), 2, random (50, 90));
			TNT1 A 10;
			Stop;
	}
}

class PB_CarbineZombieXDeath : PB_GibBase
{
	Default
	{
		Radius 1;
		Height 1;
		Scale 0.8;
		Speed 0;
		Mass 1;
		Decal "BloodSuper";
		BounceFactor 0.5;
		+BOUNCEONWALLS; +BOUNCEONFLOORS; +ALLOWBOUNCEONACTORS; +BOUNCEAUTOOFF;
		+MISSILE;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+MOVEWITHSECTOR;
		+NOGRAVITY;
		+NOCLIP;
		+DONTSPLASH;
	}
    States
    {
    Spawn:
		 TNT1 A 0 A_Pain();
		 TNT1 A 0 A_FaceTarget();
		 TNT1 A 0 A_FaceMovementDirection();
	     TNT1 A 0 A_SpawnItem("BloodSplasher3");
		 TNT1 A 0 A_SpawnItem ("PB_BigBloodSpot");
		 TNT1 AAAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_SuperWallRedBlood", 40, 0, angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (-15, 15));
	     TNT1 A 0 A_SpawnProjectile ("PB_XDeathArm1", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath4", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeath3", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathHalfZombiemanNoArmNoHead", 48, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAA 0 A_SpawnProjectile ("PB_XDeath1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece2", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AA 0 A_SpawnProjectile ("PB_XDeathSkinPiece1", 15, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan1", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathOrgan2", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 AAAAAAA 0 A_SpawnProjectile ("PB_Intestine", 24, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathZombieLeg", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_GibZombieBoot", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
		 TNT1 A 0 A_SpawnProjectile ("PB_XDeathARZombiemanHeadOnXDeath", 32, 0, Angle+random(-15,15), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
 
		 TNT1 AAAAAAAAAAAAAA 0 A_SpawnProjectile ("PB_BloodmistBig", 30, 0, random (0, 360), 2, random (20, 90));
		TNT1 A 1;
		 TNT1 A 2;
		  Stop;
	}
}