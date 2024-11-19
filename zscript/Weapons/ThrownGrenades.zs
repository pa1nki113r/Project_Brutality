class PB_ThrownGrenade : Actor
{
	const FUSE_LENGTH = 70.0;
	
	int grenadeTicks;
	int nextBeepTime;
	bool wentKaput;
	Actor flareActor;

	int pbGrenadeDamage;
	int pbGrenadeRange;
	Property GrenadeExplosionParams : pbGrenadeDamage, pbGrenadeRange;

	string flareActorName;
	Property FlareActorName : flareActorName;

	Default {
		Radius 2;
		Height 3;
		Projectile;
		Speed 30;
		Damage 0;
		Gravity 0.7;
		Scale 0.2;
		+MISSILE;
		-NOGRAVITY;
		-BLOODSPLATTER;
		+EXPLODEONWATER;
		+SKYEXPLODE;
		BounceType 'Doom';
		+FLOORCLIP;
		+DONTGIB;
		-NOBLOCKMAP;
		Species "Marine";
		+MTHRUSPECIES;
		+THRUSPECIES;
		+DontHarmSpecies;
		+UseBounceState;
		+RollSprite;
		+RollCenter;
		DamageType "ExplosiveImpact";
		BounceFactor 0.5;
		WallBounceFactor 0.25;
		BounceSound "GBOUNCE";
		DeathSound "none";
		Obituary "%o gobbled %k's grenade.";
		+FORCEXYBILLBOARD;

		PB_ThrownGrenade.GrenadeExplosionParams 120, 150;
		PB_ThrownGrenade.FlareActorName 'PB_GrenadeWarningFlare_Green';
	}

	override void Tick()
	{   
		Super.Tick();

		if(wentKaput || IsFrozen())
			return;
		
		if(flareActor)
			flareActor.SetOrigin(self.pos, true);

		GrenadeTicks++;
			
		if(grenadeTicks >= nextBeepTime)
		{
			A_StartSound("grenade/beep", CHAN_AUTO);
			//A_SpawnItemEx("RedFlareSpawn");
			
			double delay = max(0.1 + 0.9 * ((FUSE_LENGTH - grenadeTicks) / FUSE_LENGTH), 0.15);
			nextBeepTime = grenadeTicks + delay * 15;
			// console.printf("%i %i %i %f", grenadeTicks, nextBeepTime, grenadeTime, delay);
			
			if(flareActor)
				flareActor.alpha = flareActor.default.alpha;
		}
		else if(flareActor)
			flareActor.alpha *= 0.7;

		if(grenadeTicks >= FUSE_LENGTH)
			SetStateLabel("Explode");
	}
	
	override int SpecialBounceHit(Actor bounceMobj, Line bounceLine, SecPlane bouncePlane)
	{
		if(bouncePlane)
			roll = 0;
		else if(bounceLine)
			roll = 90;
			
		roll += frandom(-4.2, 4.2);
		GrenadeBounceSmoke();
		
		if(pb_grenadeimpact && target && target.Player)
			SetStateLabel("Explode");
			
		return Super.SpecialBounceHit(bounceMobj, bounceLine, bouncePlane);
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		
		flareActor = Spawn(flareActorName, self.pos);
		nextBeepTime = 1;
	}
	
	int smokephase;
	
	States
	{
		Spawn:
			GRND G 1 NoDelay A_SetRoll(roll += 15, SPF_INTERPOLATE);
			Loop;
		Death:
			GRND G 1 { 
				A_SetRoll(0);
				A_Explode(1, 128, XF_EXPLICITDAMAGETYPE, true, 128, 0, 0, NULL, 'Avoid');
			}
		DeathLoop:
			GRND G 1;
			Loop;
		Explode:
			TNT1 A 0 
			{
				wentKaput = true;
				
				bBOUNCEONWALLS = bBOUNCEONFLOORS = bBOUNCEONCEILINGS = bALLOWBOUNCEONACTORS = false;
				
				if(flareActor)
					flareActor.Destroy();
					
				A_SetRoll(0);
				A_Stop();
				A_Explode(pbGrenadeDamage, pbGrenadeRange, XF_HURTSOURCE | XF_CIRCULAR);

				if(target && target.Player)
					A_Explode(180, 220, XF_HURTSOURCE | XF_CIRCULAR);

				//A_SpawnItemEx("WhiteShockwave");
				//A_SpawnProjectile("SparkSpawner",0,0,frandom(0,359),2,-15);
				A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_StartSound("handgrenade/Explosion", CHAN_AUTO, CHANF_OVERLAP);
				A_StartSound("FAREXPL", CHAN_AUTO, CHANF_OVERLAP);
					
				if(pos.z == floorz)
					A_SpawnItemEx("BarrelExplosionSmokeColumn");

				//A_SpawnItemEx("FragGrenadeExplosionSmoke");
				A_AlertMonsters();
				Radius_Quake(2, 24, 0, 15, 0);
				
				A_SpawnItemEx("PB_ExplosionFlames", zofs: 10, flags: SXF_NOCHECKPOSITION);
				A_SpawnItemEx("NewExplosionFlare", zofs: 15, flags: SXF_NOCHECKPOSITION);
				
				if(pb_grenadeshrapnel)
				{
					for(int i = 0; i < 20; i++)
					{
						A_SpawnProjectile("PB_Shrapnel", 0, 0, random (0, 360), 2, random (-90, 90));
					}
				}
			}
			TNT1 AAA 0
			{	
				for(int i = 0; i < 10; i++)
				{
					SpawnExplosionParticleHeavySpark();
					SpawnShrapnerParticleSpark();
				}
			}
			TNT1 AAAAA 2 {
				smokephase++;
				for(int i = 0; i < 5; i++)
				{
					GrenadeSmokeSpam();
				}
			}
			Stop;
	}

	void SpawnExplosionParticleHeavySpark()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("SPRKS0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_Add;
		PUFSPRK.Flags = SPF_ROLL | SPF_FULLBRIGHT;
		PUFSPRK.Vel = (random(-38,28),random(-38,38),frandom(2, 10));
		PUFSPRK.accel = (-PUFSPRK.vel.xy * 0.2,-0.1);
		PUFSPRK.Startroll = random(0, 359);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = 7;
		PUFSPRK.SizeStep = -0.5;
		PUFSPRK.Lifetime = 5; 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}

	void SpawnShrapnerParticleSpark()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("SPKOA0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_Add;
		PUFSPRK.Flags = SPF_ROLL | SPF_FULLBRIGHT;
		PUFSPRK.Vel = (random(-37,37),random(-37,37),frandom(2,10));
		PUFSPRK.accel = (-PUFSPRK.vel.xy * 0.14,frandom(-0.5, -0.3));
		PUFSPRK.Startroll = random(0, 359);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = 8;
		PUFSPRK.SizeStep = -0.05;
		PUFSPRK.Lifetime = 7; 
		PUFSPRK.Pos = pos/* + (random(-60, 60), random(-60, 60), random(0, 50))*/;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void GrenadeSmokeSpam()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[grenade](0, 25)).."0");
		PUFSPRK.Color1 = "7a7a7a";
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL;
		PUFSPRK.Vel = (0, 0, (6-smokephase) * 0.5);
		PUFSPRK.Startroll = random[grenade](0, 359);
		PUFSPRK.RollVel = frandom[grenade](-3, 3);
		PUFSPRK.StartAlpha = 0.8;
		PUFSPRK.Size = 100;
		PUFSPRK.SizeStep = 2;
		PUFSPRK.Lifetime = random[grenade](55,100); 
		PUFSPRK.RollAcc = -PUFSPRK.RollVel / float(PUFSPRK.Lifetime);
		
		PUFSPRK.accel = (0, 0, -PUFSPRK.Vel.z / float(PUFSPRK.Lifetime));
		//if(CeilingPic == SkyFlatNum)
		//	PUFSPRK.accel += (-0.05, 0.1, 0);
			
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Pos = pos + ((frandom(-25, 25), frandom(-25, 25), frandom(0,10)) * smokePhase);
		Level.SpawnParticle(PUFSPRK);
	}
	
	void GrenadeBounceSmoke()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[grenade](0, 25)).."0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL;
		PUFSPRK.Vel = (0, 0, 0);
		PUFSPRK.Startroll = random[grenade](0, 359);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 0.8;
		PUFSPRK.Size = 40;
		PUFSPRK.SizeStep = 2;
		PUFSPRK.Lifetime = 20; 
		PUFSPRK.RollAcc = -PUFSPRK.RollVel / float(PUFSPRK.Lifetime);
		
		PUFSPRK.accel = (0, 0, -0.02);
		//if(CeilingPic == SkyFlatNum)
		//	PUFSPRK.accel += (-0.05, 0.1, 0);
			
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
}

class PB_GrenadeWarningFlare_Green : Actor
{
	bool ticked;
	
	Default
	{
		+NOINTERACTION;
		+NOGRAVITY;
		+NOBLOCKMAP;
		+FORCEXYBILLBOARD;

		RenderStyle "Add";
		Alpha 0.8;
		Scale 0.15;
	}

	override void Tick()
	{
		if(!ticked)
		{
			Super.Tick();
			ticked = true;
		}
	}
	
	States
	{
		Spawn:
			LENG B 1 bright;
			Loop;
	}
}

class PB_GrenadeWarningFlare_Red : PB_GrenadeWarningFlare_Green
{
	States
	{
		Spawn:
			LENR B 1 bright;
			Loop;
	}
}

/*class PB_NewFragGrenadeExplosion : Actor
{
	Default
	{
		+NOBLOCKMAP;
		+MISSILE;
		Damagetype ExplosiveImpact;
		DeathSound "Explosion";
	}
	
	States
	{
		Spawn:
			TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner", flags: SXF_NOCHECKPOSITION)
			TNT1 AAA 0 A_CustomMissile ("ExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360))
			TNT1 AAA 0 A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180))
			TNT1 AAA 0 A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180))
			BEXP B 0 BRIGHT A_Scream
			TNT1 A 0 A_Playsound("excavator/explode", 1)
			TNT1 A 0 A_SpawnItem("BarrelExplosionSmokeColumn")
			TNT1 AAA 8 A_CustomMissile ("ExplosionSmoke", 1, 0, random (0, 360), 2, random (50, 130))
			Stop
	}
}*/

class PB_ExplosionFlames : PB_LightActor
{
	Default {
		Scale 0.7;
		RenderStyle "Add";
		+NOBLOCKMAP;
		+NOTELEPORT;
		+NOCLIP;
		+NOINTERACTION;
		+FORCEXYBILLBOARD;
	}
	
	States
	{
		Spawn:
			X125 ABCD 2 BRIGHT Light("EXPLOSIONFLASH");
			X125 EFGHIJKLMOPQR 1 {
				Scale *= 1.05;
			}
			Stop;
	}
}