Class RailgunLaserBlast1 : FastProjectile
{
	default
	{
		Speed 300;
		Radius 12;
		Height 16;
		Damage 20;
		Renderstyle "Add";
		+RIPPER;
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
		Fly:
			TNT1 A 4;
			Loop;
		Death:
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
	
	override void Effect()
	{
		//copied from gzdoom.pk3/Zscript/Actors/Shared/Fastprojectile.zs
		//basically this is made to replace the actors trail for a lighter version with textured particles
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
		LaserGun.Size = 220;
		LaserGun.SizeStep = -10;
		LaserGun.Lifetime = 10; 
		LaserGun.Pos = where;
		Level.SpawnParticle(LaserGun);
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