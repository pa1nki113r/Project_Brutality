class PB_ThrownGrenade : Actor
{
    int grenadeTicks, grenadeTime, grenadeBeepSpeed, exploRandom;

    private int zscriptTick;
    flagdef DOZSCRIPTTICK: zscriptTick, 0;

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
        +DOOMBOUNCE;
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
        Health 5;
        SeeSound "GBOUNCE";
        DeathSound "none";
        Obituary "%o gobbled %k's grenade.";
        +PB_ThrownGrenade.DOZSCRIPTTICK;
    }

	override void Tick()
    {
        Super.Tick();

        //console.printf("%i %i %i %i", grenadeTicks, grenadeBeepSpeed, exploRandom, grenadeTime);

        if(bDOZSCRIPTTICK)
        {
            GrenadeTicks++;

            if(GrenadeTicks % 8 == 0)                
                GrenadeTime++;

            if(GrenadeTicks % 3 == 0 && GrenadeBeepSpeed > 1)
                grenadeBeepSpeed--;

            if(GrenadeTicks % 4 == 0)
            {
                A_StartSound("grenade/beep", CHAN_AUTO);
                A_SpawnItemEx("RedFlareSpawn");
            }

            if(GrenadeTime == exploRandom)
                SetStateLabel("Explode");
        }
    }

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        grenadeBeepSpeed = 8;
        exploRandom = random(3, 6);
    }
    
    States
	{
        Spawn:
            TNT1 A 0 NoDelay {
                if(GetCvar("pb_grenadeimpact") < 1)
                {
                    bUSEBOUNCESTATE == FALSE;
                }
            }
            GRND A 2 A_SetRoll(roll += 50, SPF_INTERPOLATE);
            Loop;
        
        Bounce:
        Bounce.Floor:
        Bounce.Ceiling:
        Bounce.Wall:
            TNT1 A 0 
            {
                A_SetRoll(0);

                if(GetCvar("pb_grenadeimpact") == 1)
                { 
                    return ResolveState("Explode");
                }
                else if(GetCvar("pb_grenadeimpact") >=2)
                {
                    A_Stop();
                    return ResolveState("Death");
                }
                return ResolveState(null);
            }
            Goto Spawn;

        Death:
        XDeath:
            TNT1 A 0 
            {
                A_SetRoll(0);
                A_Jumpif(GetCvar("pb_grenadeimpact") == 1, "Explode");
            }
            GRND G 17;
            Loop;
                
        Explode:
            TNT1 A 0 
            {
                A_SetRoll(0);
                A_Stop();
                A_StopSound(6);            
                A_Explode(120,150, XF_HURTSOURCE);
                A_SpawnItemEx ("HandGrenadeExplosion",0,0,30,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItem("WhiteShockwave");
                A_SpawnProjectile("SparkSpawner",0,0,frandom(0,359),2,-15);
                A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx("NewGroundExplosionSmoke",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_StartSound("handgrenade/Explosion");
                A_StartSound("FAREXPL", 3);
                A_SpawnItem("BarrelExplosionSmokeColumn");
                A_SpawnItem("FragGrenadeExplosionSmoke");
                A_AlertMonsters();
                A_Scream();
                Radius_Quake(2, 24, 0, 15, 0);
            }
            TNT1 AAA 0
            { 
                A_SpawnProjectile("ExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
                A_SpawnProjectile("UnModHitSpark", 0, 0, random (0, 360), 2, random (0, 180));
                A_SpawnProjectile("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180));
                A_SpawnProjectile("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180));
                A_SpawnProjectile("HitSpark", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 160));
                A_SpawnProjectile("HitSpark22", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 160));
                A_SpawnProjectile("HitSpark23", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 160));
                A_SpawnProjectile("ShrapnelParticle2", 0, 0, random (0, 360), 2, random (5, 90));
            }
            Stop;
	}
}
