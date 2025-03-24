Class PB_DragonsBreathTracer : PB_Projectile
{
	default
	{
		PB_Projectile.BaseDamage 14;
		PB_Projectile.RipperCount 0;
		Damagetype "Shotgun";
		PoisonDamageType "Fire";
		PoisonDamage 2;
		+ADDITIVEPOISONDURATION;
		speed 80;
	}
	States
	{
		Spawn:
			TNT1 A 1;
		Fly:
			IPF2 CDEFGH 1 bright;
			loop;
			
		Death: // [Ace] Wall.
			TNT1 A 0
			{
				CallOwnerDied();
				OnExplode(EType_Geometry);
				//A_SpawnProjectile("PB_BulletPuff",0,0,0,0);
				if(random(0, 100) < 25)
				{
					A_StartSound("ricochet/hit");
				}
			}
			Stop;
		Crash: // [Ace] Dormant/NoBlood enemies.
			TNT1 A 0
			{
				CallOwnerDied();
				OnExplode(EType_Actor);
				//A_SpawnProjectile("PB_BulletPuff",0,0,0,0);
			}
			Stop;
		XDeath: // [Ace] Bleeding enemies.
			TNT1 A 0
			{

				CallOwnerDied();
				OnExplode(EType_BleedingActor);
			}
			Stop;
	}
	bool ticked;
	override void Tick()
	{
		super.tick();
		if(isfrozen())
			return;
		if(!ticked)
			ticked = true;
		spawnflameFlare(pos);
		spawnFirespark(pos);
	}
	
	override void effect()
	{
		if(ticked)
			SpawnFlameTrail(pos);
	}
	
	override void OnHitActor(Actor target, Name dmgType)
	{
		if(pos.z < floorz)
			SetZ(floorz);
		A_Explode(3, 30, 0);
		A_Spawnitem("PB_DragonBreath");
		spawnflameFlare(pos,true);
		SpawnImpactFx();
	}
	override void OnExplode(int type)
	{
		if(pos.z < floorz)
			SetZ(floorz);
		A_Explode(3, 30, 0);
		A_Spawnitem("PB_DragonBreath");
		spawnflameFlare(pos,true);
		SpawnImpactFx();
	}
	
	
	void spawnFirespark(vector3 position)
	{
		FSpawnParticleParams DBSPK;
		DBSPK.Texture = TexMan.CheckForTexture("REXPA0");
		DBSPK.Color1 = "FFFFFF";//"FF8400";
		DBSPK.Style = STYLE_ADD;
		DBSPK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		DBSPK.Vel = (frandom(-5,5),frandom(-5,5),frandom(-5,5)); 
		DBSPK.Startroll = random(0,360);
		DBSPK.RollVel = frandom(-15,15);
		DBSPK.StartAlpha = 0.85;
		//DBSPK.FadeStep = 0.1;
		DBSPK.Size = random(12,26);
		DBSPK.SizeStep = -2;
		DBSPK.Lifetime = random(4,8); 
		DBSPK.Pos = position;
		Level.SpawnParticle(DBSPK);
	}
	
	void SpawnFlameTrail(vector3 position, bool small = false)
	{
		FSpawnParticleParams FTrail;
		string f = String.Format("%c", int("C") + random(0,5));
		FTrail.Texture = TexMan.CheckForTexture("IPF2"..f..0);
		FTrail.Color1 = "FFFFFF";
		FTrail.Style = STYLE_ADD;
		FTrail.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FTrail.Vel = (frandom(-1.5,1.5),frandom(-1.5,1.5),frandom(-1.5,1.5)); 
		FTrail.Startroll = random(0,360);
		FTrail.RollVel = frandom(-3,3);
		FTrail.StartAlpha = 0.70;
		//FTrail.FadeStep = 0.20;
		FTrail.Size = small ? random(6,12) : random(12,24);
		FTrail.SizeStep = small ? random(3,6) : random(6,10);
		FTrail.Lifetime = small ? random(8,10) : random(2,3); 
		FTrail.Pos = position;
		Level.SpawnParticle(FTrail);
	}
	
	void spawnflameFlare(vector3 position, bool bigger = false)
	{
		FSpawnParticleParams FFLAR;
		FFLAR.Texture = TexMan.CheckForTexture("FSO1A0");
		FFLAR.Color1 = "FFFFFF";//"FE9900";
		FFLAR.Style = STYLE_ADD;
		FFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FFLAR.Vel = (0,0,0);
		FFLAR.Startroll = random(0,360);
		FFLAR.RollVel = frandom(-3,3);
		FFLAR.StartAlpha = 0.85;
		FFLAR.FadeStep = bigger ? 0.15 : 0.25;
		FFLAR.Size = random(100,120);
		FFLAR.SizeStep = 10;
		FFLAR.Lifetime = bigger ? random(3,6): 1; 
		FFLAR.Pos = position;
		Level.SpawnParticle(FFLAR);
	}
	
	void A_SpawnPuffSmoke(vector3 position)
	{
		if(!ticked)
			return;
		FSpawnParticleParams PFSMK;
		PFSMK.Texture = TexMan.CheckForTexture ("SMK1K0");
		PFSMK.Color1 = "FFFFFF";
		PFSMK.Style = STYLE_TRANSLUCENT;
		PFSMK.Flags = SPF_ROLL;
		PFSMK.Vel = (frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.3,0.3)); 
		PFSMK.Startroll = random(0,360);
		PFSMK.RollVel = frandom(-10,10);
		PFSMK.StartAlpha = 0.25;
		//PFSMK.FadeStep = 0.1;
		PFSMK.Size = frandom(18,28);
		PFSMK.SizeStep = 6;
		PFSMK.Lifetime = FRandom(6,8); 
		PFSMK.Pos = position;
		Level.SpawnParticle(PFSMK);
	}
	
	//this draws the impact effect
	void SpawnImpactFx()
	{
		int it = random(1,3);
		
		for(int i = 0; i < it; i++)
		{
			vector3 dir = (random(-1,1),random(-1,1),random(-1,1));
			int dist = random(25,60);
			
			for(int k = 0; k < dist; k += 5)
				SpawnFlameTrail(pos + dir * k,true);
			
		}
	}
	
}

//this is basically just a port of the one in decorate
Class PB_DragonBreath : Actor
{
	default
	{
		Projectile;
		+RANDOMIZE;
		+FORCEXYBILLBOARD;
		+RIPPER;
		+NOEXTREMEDEATH;
		damage 1;
		radius 1;
		height 1;
		speed 40;
		renderstyle "ADD";
		alpha 0.9;
		scale .15;
		DamageType "Fire";
		SeeSound "Afrit/Hellfire";
		Decal "SmallerScorch";
	}
	states
		{
			Spawn:
				TNT1 A 0 nodelay A_Startsound("Afrit/Hellfire");
				TNT1 A 0 A_Explode(10,66,0);
				//TNT1 AAAA 0 A_SpawnItemEx ("DragonsBreathFlare",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				EXPL A 0 A_SpawnItemEx ("ExplosionParticleSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				//EXPL AAAAAAAAAAA 0 A_SpawnProjectile("ShotgunParticles", 6, 0, random (0, 360), 2, random (0, 90));//ShotgunParticles
				TNT1 A 0 A_Jump(76, 2, 3,4);
				TNT1 A 0 A_SpawnItemEx("DragonsBreathPiece1", random (-15, 15), random (-15, 15));
				TNT1 A 0 A_Spawnprojectile ("FireworkSFXType2", 0, 0, random (0, 360), 2, random (-60, -30));
				TNT1 A 0 A_SpawnItemEx("DragonsBreathPiece2", random (-35, 35), random (-35, 35));
				TNT1 A 0 A_SpawnItemEx("DragonsBreathPiece3", random (-45, 45), random (-45, 35));
				TNT1 AAAAAAAAAAA 0 A_Spawnprojectile("SparkX", 2, 0, random (0, 360), 2, random (0, 360));
				TNT1 A 0 A_SpawnItemEx ("PB_BulletPuff",0,0,-5,0,0,0,0,SXF_NOCHECKPOSITION,0);
				Stop;
			Death:
				Stop;
			XDeath:
				TNT1 A 0;
				Stop;
	}
}