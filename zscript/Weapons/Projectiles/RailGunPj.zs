class PB_Rail : LineTracer
{
	double lastDist;
	int hitnum;
	array<Actor> hitActors;
	array<Double> hitX, hitY, hitZ;
	
	override ETraceStatus TraceCallback()
	{
		hitnum++;
		if(results.HitType == TRACE_HitActor && results.HitActor.bSHOOTABLE)
		{
			hitActors.Push(results.HitActor);
			hitX.Push(results.hitPos.x);
			hitY.Push(results.hitPos.y);
			hitZ.Push(results.hitPos.z);
			return TRACE_Continue;
		}
		if(results.HitType == TRACE_HitWall || results.HitType == TRACE_HitCeiling || results.HitType == TRACE_HitFloor)
		{
			return TRACE_Stop;
			/*if(lastDist == 0)
			{
				lastDist = results.distance;
				return 4;
			}
			else if(results.distance - lastDist < 64 && lastDist > 0)
			{
				lastDist = 0;
				return 4;
			}
			else
			{
				return TRACE_Abort;
			}*/
		}
		return TRACE_Skip;
	}
}

class PB_Laser : LineTracer
{
	array<Actor> hitActors;
	
	override ETraceStatus TraceCallback()
	{
		if(results.HitType == TRACE_HitActor && results.HitActor.bSHOOTABLE)
		{
			hitActors.Push(results.HitActor);
			return TRACE_Continue;
		}
		if(results.HitType == TRACE_HitWall || results.HitType == TRACE_HitCeiling || results.HitType == TRACE_HitFloor)
		{
			return TRACE_Stop;
		}
		return TRACE_Skip;
	}
}

class PB_RailImpact : Actor
{
	Default
	{
		+NOINTERACTION;
	}
	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 2 A_SpawnItemEx("GaussCannonPuffSiege",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION);
		TNT1 A 0;
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_Explode(120,15,0);
		TNT1 A 0 A_SpawnItem("WhiteShockwave");
		TNT1 A 0 A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("RailgunImpactExplosionSFX", 0, 0, 0, 0, 0, 0, 0, 128);
		TNT1 A 0 A_CustomMissile ("FireworkSFXType2", 0, 0, random (0, 360), 2, random (30, 60));
		TNT1 AA 0 A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180));
		X005 ABCDEFGHIJKLMNOPQRSTUVWX 1 BRIGHT;
		TNT1 AAA 10 A_CustomMissile ("BigBlackSmoke", 0, 0, random (0, 360), 2, random (40, 160));
		Stop;
	}
}
Class RailgunLaserBlast1 : Actor
{
	default
	{
		Radius 1;
		Height 1;
		Damage 20;
		Renderstyle "Add";
		-CANNOTPUSH;
		+NODAMAGETHRUST;
		+EXTREMEDEATH;
		+FORCERADIUSDMG;
		DamageType "Incinerate";
		DeathSound "";
		MissileType "LaserTrail"; //this is actually not needed anymore
		MissileHeight 10;
		Decal "BigScorch";
		DeathSound "belphegor/missile";
		Scale 1.5;
	}
	states
	{
		Spawn:
			TNT1 A 0 nodelay A_startsound("Weapons/StachanovFly",6,CHANF_LOOPING);
			TNT1 A 0;
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_startsound("Weapons/YamatoExp",5);
			TNT1 AAA 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(19,-19), 0, 0, 0, 0, 128, 0);
			TNT1 A 0 A_SpawnItemEx("ObeliskExplode",0,0,0,0,0,0,0,128,0);
			TNT1 A 0 A_Explode(200,250,0,1);
			TNT1 A 0 A_SpawnItem("WhiteShockwave");
			TNT1 A 0 A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 AAA 0 A_Spawnprojectile ("FireworkSFXType2", 0, 0, random (0, 360), 2, random (-60, -30));
			EXPL AAA 0 A_Spawnprojectile ("FlamethrowerFireParticles", 6, 0, random (0, 360), 2, random (-90,0));
			TNT1 AAA 0 A_Spawnprojectile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (-180,0));
			EXPL A 0 Radius_Quake(3, 120, 0, 120, 0);
			BEXP B 0 BRIGHT A_Scream();
			X001 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 BRIGHT;
			TNT1 AAA 10 A_Spawnprojectile("BigBlackSmoke", 0, 0, random (0, 360), 2, random (40, 160));
			stop;
	}
}


//this is basically the same as above, just made the effect a little smaller
Class EnemyRailPj : FastProjectile
{
	override void Effect()
	{
		double hitz = pos.z - 8;
		if (hitz < floorz)
		{
			hitz = floorz;
		}
		// Do not clip this offset to the floor.
		hitz += MissileHeight;
		
		SpawnLaserTrail((pos.xy, hitz));
	}
	
	void SpawnLaserTrail(vector3 where)
	{
		FSpawnParticleParams LaserGun;
		LaserGun.Texture = TexMan.CheckForTexture("YAE4A0");
		LaserGun.Style = STYLE_ADD;
		LaserGun.Color1 = "FFFFFF";
		LaserGun.Flags =SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		LaserGun.StartAlpha = 1.0;
		LaserGun.FadeStep = 0.25;
		LaserGun.Size = 125;
		LaserGun.SizeStep = -10;
		LaserGun.Lifetime = 10; 
		LaserGun.Pos = where;
		Level.SpawnParticle(LaserGun);
	}
}