Class PB_BossBrain : Actor
{
	Default
	{
		Radius 16;
		Height 16;
		Mass 100;
		PainSound "brain/pain";
		DeathSound "brain/death";
		Health 500;
		PainChance 255;
		damagefactor "GibRemoving", 0.0;
		damagefactor "DontCallTheBaron", 0.0;
		damagefactor "Blood", 0.0; damagefactor "BlueBlood", 0.0; damagefactor "GreenBlood", 0.0;
		damagefactor "Shrapnel", 0.0;
		damagefactor "killme", 0.0;
		DamageFactor "CauseObjectsToSplash", 0.0;
		damagefactor "TeleportRemover", 0.0;
		DamageFactor "Railgun", 0.0;
		
		+SOLID;
		+SHOOTABLE;
		+NOICEDEATH;
		+OLDRADIUSDMG;
		+DONTTHRUST;
		
		Species "Icon Of Sin";
	}
	
	States
	{
		Spawn:
			BBR1 A 1;
			Loop;
		Pain:
			BBR1 A 36 A_BrainPain();
			Goto Spawn;
		Death:
			BBR1 A 100 PB_BrainScream();
			BBR1 AA 10;
			BBR1 A -1 A_BrainDie();
			Stop;
	}
	
	void PB_BrainScream()
	{
		for (double x = -196; x < +320; x += 8)
		{
			// (1 / 512.) is actually what the original value of 128 did, even though it probably meant 128 map units.
			PB_BrainExplode(Vec2OffsetZ(x, -320, (1 / 512.) + random[BrainExplode](0, 255) * 2));
		}
		A_StartSound("brain/death", CHAN_VOICE, CHANF_DEFAULT, 1., ATTN_NONE);
		PB_EverythingDies();
	}
	
	private static void PB_BrainExplode(vector3 pos)
	{
		Actor boom = Actor.Spawn("PB_BrainExploder", pos);
		if (boom)
		{
			boom.tics -= random[BrainScream](0, 120);
			if (boom.tics < 1) boom.tics = 1;
		}
	}
	
	void PB_EverythingDies()
	{
		let ti = ThinkerIterator.Create("Actor");
		Actor a;
		while(a = Actor(ti.Next()))
		{
			//remove all of the BossEye and SpawnShot actors in a map
			if(a is 'BossEye') a.SetStateLabel("Null");
			else if(a is 'SpawnShot')
			{
				a.Spawn("SpawnFire",a.pos,ALLOW_REPLACE);
				a.SetStateLabel("Null");
			}
			//kill all monsters (map placed or boss spawned)
			else if((a.Health > 0)&&(a.bBOSSSPAWNED||a.bCOUNTKILL))
			{
				a.DamageMobj(self,self,a.Health,"IOS",DMG_FORCED|DMG_THRUSTLESS);
			}
		}
	}
}

class PB_BrainExploder : Actor
{
	Default
	{
		+NOINTERACTION;
		Gravity 0.00;
	}
	States
	{
		Spawn:
			TNT1 A 120;
			TNT1 A 0 {
				A_StopSound(CHAN_BODY);
				A_StartSound("Explosion", CHAN_AUTO,CHANF_OVERLAP);
				A_StartSound("FAREXPL", CHAN_AUTO,CHANF_OVERLAP);
				Radius_Quake(3, 8, 0, 15, 0);
				A_SpawnItemEx("DetectFloorCrater");
				A_SpawnItemEx("DetectCeilCrater");
				A_SpawnItemEx("ExplosionFlareSpawner");
				A_SpawnItemEx("NewRocketExploFX");
				A_SpawnItemEx("WhiteShockwave");
				A_SpawnProjectile("ExplosionSmokeFast22", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (0, -360));
				A_SpawnProjectile("ExplosionSmokeFast22", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (0, -360));
				A_SpawnProjectile("ExplosionSmokeFast22", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (0, -360));
				A_SpawnProjectile("MediumExplosionFlames", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (0, -360));
				A_SpawnProjectile("MediumExplosionFlames", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (0, -360));
				A_SpawnProjectile("MediumExplosionFlames", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (0, -360));
				A_SpawnProjectile("PBExplosionparticles", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (-40, -90));
				A_SpawnProjectile("PBExplosionparticles", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (-40, -90));
				A_SpawnProjectile("PBExplosionparticles2", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (-40, -90));
				A_SpawnProjectile("PBExplosionparticles2", 0, 0, random (0, 360), CMF_AIMDIRECTION, random (-40, -90));
				A_SpawnProjectile("PBExplosionparticles3", 10, 0, random (0, 360), CMF_AIMDIRECTION, random (-40, -90));
			}
			TNT1 A 25;
			Stop;
	}
}
