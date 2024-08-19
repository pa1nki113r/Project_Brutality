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
            Loop
        Explode:
            TNT1 A 0 
            {
				wentKaput = true;
				
				if(flareActor)
					flareActor.Destroy();
					
                A_SetRoll(0);
                A_Stop();
                A_StopSound(6);            
                A_Explode(pbGrenadeDamage, pbGrenadeRange, XF_HURTSOURCE | XF_CIRCULAR);

                if(target && target.Player)
                    A_SpawnItemEx("HandGrenadeExplosion",0,0,30,0,0,0,0,SXF_NOCHECKPOSITION,0);

                A_SpawnItemEx("WhiteShockwave");
                A_SpawnProjectile("SparkSpawner",0,0,frandom(0,359),2,-15);
                A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx("NewGroundExplosionSmoke",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_StartSound("handgrenade/Explosion");
                A_StartSound("FAREXPL", 3);
                    
                if(pos.z == floorz)
                    A_SpawnItemEx("BarrelExplosionSmokeColumn");

                A_SpawnItemEx("FragGrenadeExplosionSmoke");
                A_AlertMonsters();
                A_Scream();
                Radius_Quake(2, 24, 0, 15, 0);
				
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
                A_SpawnProjectile("ExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
                A_SpawnProjectile("UnModHitSpark", 0, 0, random (0, 360), 2, random (0, 180));
                SpawnExplosionParticleHeavySpark();
                SpawnExplosionParticleHeavySpark();
                SpawnExplosionParticleHeavySpark();
                SpawnExplosionParticleHeavySpark();
                A_SpawnProjectile("HitSpark", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 160));
                A_SpawnProjectile("HitSpark22", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 160));
                A_SpawnProjectile("HitSpark23", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 160));
                SpawnShrapnerParticleSpark();
                SpawnShrapnerParticleSpark();
                SpawnShrapnerParticleSpark();
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
		PUFSPRK.Vel = (random(-5,5),random(-5,5),random(-2,9));
		PUFSPRK.accel = (0,0,frandom(-1.75,-0.75));
		PUFSPRK.Startroll = random(0, 359);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = 0.075;
		PUFSPRK.Size = 6.4;
		PUFSPRK.SizeStep = -0.5;
		PUFSPRK.Lifetime = random(12,18); 
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
		PUFSPRK.Vel = (random(-20, 20),random(-20, 20),random(-20, 20));
		PUFSPRK.accel = (0,0,0);
		PUFSPRK.Startroll = random(0, 359);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = 0.05;
		PUFSPRK.Size = 15.36;
		PUFSPRK.SizeStep = -0.05;
		PUFSPRK.Lifetime = 5; 
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