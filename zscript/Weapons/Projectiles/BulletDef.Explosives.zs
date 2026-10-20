class PB_MicroMissileProjectile : PB_ProjectileAlt
{
	int weavenum;
	Default
	{
		Radius 6;
		Height 6;
		DamageType "Explosive";
		Gravity 0.1;
		Scale 0.25;
		Decal "Scorch";
		SeeSound "weapons/RLL";
		Obituary "$OB_MPROCKET";
		-NOGRAVITY;
		
		PB_Projectile.BaseDamage 35;
		PB_Projectile.SpeedFPS 162;
	}
	
	States
	{
		Spawn:
			MICR A 0 NoDelay {
				A_StartSound("weapons/rocketloop", 105, CHANF_LOOP);
				weavenum = -25;
		}
		Fly:
			MICR ABC 1 Bright Light("PB_ROCKET")
			{
				if(weavenum < 25)
					weavenum++;
				if(weavenum > 0) {
					double weaveoffset = random(-weavenum, weavenum) * 0.2;
					A_Weave(3, 3, weaveoffset, weaveoffset);
				}
				if(waterlevel < 1)
					A_SpawnItemEx("RocketTrailSparks", -10, xvel:-5);
			}
			loop;
		Death:
			TNT1 A 0 {
				A_Stop();
				bNOINTERACTION = true;
				bNOGRAVITY = true;
				A_SetRenderstyle(1.0, STYLE_Add);
				A_Explode(90, 60);
				A_StopSound(105);
				A_StartSound("FAREXPL", CHAN_AUTO, 0, 0.5, 0, 1.1);
				Radius_Quake (2, 4, 0, 7, 0);
				A_SpawnItemEx ("DetectFloorCrater");
				A_SpawnItemEx ("DetectCeilCrater");
				A_SpawnItemEx ("ExplosionFlareSpawner");
				A_SpawnItemEx ("LiquidExplosionEffectSpawner");
				A_SpawnProjectile ("ExplosionSmokeFast22", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("MediumExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("PBExplosionparticles", 0, 0, random (0, 360), 2, random (40, 90));
				A_SpawnProjectile ("PBExplosionparticles2", 0, 0, random (0, 360), 2, random (40, 90));
				A_SpawnProjectile ("PBExplosionparticles3", 10, 0, random (0, 360), 2, random (40, 90));
			}
			TNT1 A 0 A_Jump(256, "Death1", "Death2", "Death3");
		Death1:
			X004 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X004 FGHIJKLMNOPQ 1 bright;
			stop;
		Death2:
			X003 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X003 FGHIJKLMNOPQRSTUVWXYZ 1 bright;
			stop;
		Death3:
			X125 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X125 FGHIJKLMNOPQR 1 bright;
			Stop;
	}
}
