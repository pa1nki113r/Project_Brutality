//m1 plasma
Class Plasma_Ball : PB_ProjectileAlt
{
	default
	{
		Radius 5;
		Height 8;
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
			TNT1 A 0 A_SpawnItemEx("Plasma_Puff", zofs:4);
			TNT1 A 0 A_SpawnProjectile("BluePlasmaFire", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 AAAA 0 A_SpawnProjectile("RailGunTrailSpark", 0, 0, random(0, 360), 2, random(0, 360));
			TNT1 A 5;
			TNT2 AAA 9 SpawnPlasmaSmoke();//A_SpawnProjectile("PlasmaSmoke", 1, 0, random(0, 360), 2, -random(0, 160));
			Stop;

		Death:
			TNT1 A 0 A_SpawnItemEx("Plasma_Puff", zofs:4);
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

Class EnemyPlasmaBall : Plasma_Ball
{
	default
	{
		PB_Projectile.BaseDamage 13;
		Speed 40;
		SeeSound "PLSM9";
		//Species "NotMarines";
		-THRUACTORS;
		-THRUSPECIES;
		-MTHRUSPECIES;
		+THRUGHOST;
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

//demon-tech rifle
class Hellbullet : PB_ProjectileAlt
{
    Default
    {
        PB_Projectile.BaseDamage 54;
        +PB_PROJECTILE.NOCRITICALS
        +FORCEXYBILLBOARD
        +SQUAREPIXELS
        +BLOODSPLATTER
        +NOEXTREMEDEATH
        damagetype "fire";
        radius 5;
        height 8;
        //alpha 0.8
        scale .3;
        speed 130;
        Decal "Scorch";
        Deathsound "Weapons/Demontech/Crash";
    }

    States
    {
        Spawn:
            PBAL L 1 BRIGHT ;
            TNT1 A 0 A_SpawnItemEx("DTechTrailSpark", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
            PBAL M 1 BRIGHT ;
            Loop;

        Xdeath:
            TNT1 A 0; //A_CustomMissile ("Flametrails", 0, 0, random (0, 180), 2, random (0, 360))
            TNT1 A 0 A_SpawnItem("HellRifle_Puff",0);
            TNT1 A 0 A_Jump(128, 2);
            TNT1 A 0 A_SpawnItem("DTechBurningPiece",0);
            //TNT1 AAA 0 A_SpawnItemEx("ExplosionParticleVerySlow", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0)
            TNT1 AAA 0 A_SpawnItemEx("DTechTrailSpark", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0);
            TNT1 A 4;
            TNT2 AAA 3 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
            Stop;

        Death:
            TNT1 A 0 A_SpawnItem("HellRifle_Puff2",0);
            TNT1 A 0 A_Jump(128, 2);
            TNT1 A 0 A_SpawnItem("DTechBurningPiece2",0);
            TNT1 AAA 0 A_SpawnItemEx("ExplosionParticleVerySlow", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0);
            //TNT1 AA 0 A_SpawnItemEx("BurningEmberParticlesFloating_Bigger", random(19,-19), random(19,-19), random(4,-4), 0, 0, 0, 0, 128, 0)
            TNT1 AAA 0 A_SpawnItemEx("DTechTrailSpark", random(-8, 8), random(-8, 8), random(-2,2), 0, 0, 0, 0, 128, 0);
            TNT1 A 4;
            TNT2 AAAAA 4 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
            Stop;
    }
}

class Hellbullet2 : PB_ProjectileAlt
{
    Default {
    PB_Projectile.BaseDamage 60;
    +PB_PROJECTILE.NOCRITICALS
	+FORCEXYBILLBOARD
	+SQUAREPIXELS
	+BLOODSPLATTER
	+NOEXTREMEDEATH
	damagetype "Disintegrate";
	radius 2;
	height 1;
	renderstyle "ADD";
	//alpha 0.7;
	scale .19;
	speed 100;
	Decal "Scorch";
	Deathsound "Weapons/Demontech/Crash";
  }
	states
	{
	Spawn:
		TNT1 AA 0 NODELAY A_SpawnItem("GreenFlareSmall",0);
		DB57 AB 1 BRIGHT Light("CausticProjectile");
		TNT1 A 0 A_CustomMissile ("GreenTracerSmall", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 A 0 A_SpawnItemEx("GreenTrailSparks", random(5,-5), random(5,-5), random(5,-5), 0, 0, 0, 0, 128, 0);
		DB57 C 1 BRIGHT;
		Loop;
	Xdeath:
		TNT1 A 0 A_SpawnItem("GreenPlasma_Puff_Medium",0);
		TNT1 A 0 A_CustomMissile ("PlasmaParticleSpawner", 0, 0, random (0, 180), 2, random (0, 360));
		TNT1 A 4;
		//TNT2 AAA 3 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
		
		Stop;

	Death:
		TNT1 A 0 A_SpawnItem("GreenPlasma_Puff_Medium",0);
		TNT1 A 0 A_CustomMissile ("PlasmaParticleSpawner", 0, 0, random (0, 180), 2, random (0, 360));
		TNT1 A 4	;
		//TNT2 AAAAA 4 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
		Stop;
	}
}

//cryo rifle
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