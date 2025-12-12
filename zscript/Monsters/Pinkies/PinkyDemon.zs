class PB_Demon : PB_Monster
{
    Default
    {
        Health 200;
        GibHealth 35;
		PainChance 180;
		Speed 10;
		Radius 22;
		Height 56;
		Mass 400;
		Monster;
		+FLOORCLIP;
		SeeSound "demon/sight";
		AttackSound "demon/melee";
		PainSound "demon/pain";
		DeathSound "demon/death";
		ActiveSound "demon/active";
        DamageType "Eat";
		Obituary "$OB_DEMONHIT";
		Tag "$FN_DEMON";
        MaxStepHeight 32;
	    MaxDropOffHeight 32;
        //BLoodType "NashGoreBlood";
        Species "Demon";
        PB_Monster.PBMonSpeed 10, 10, 4, 2;
		PB_Monster.MonPosHB 0.85, 0.3, 0.18, 0.20;
		
		PB_Monster.ignoreDickDamage true;
		PB_Monster.CanIFallback false;
		PB_Monster.CanIRoll false;
		PB_Monster.CanIReload false;
        PB_Monster.CanISuppress false;
    }

    States
	{
        Spawn:
            SARG AB 10 A_Look();
            Loop;
        See:
            SARG AA 2 Fast A_SmartChase();
            TNT1 A 0 A_StartSound("pinky/step");
            SARG BB 2 Fast A_SmartChase();

            SARG CC 2 Fast A_SmartChase();
            TNT1 A 0 A_StartSound("pinky/step");
            SARG DD 2 Fast A_SmartChase();
            Loop;
        Melee:
            SARG EF 6 Fast A_FaceTarget;
            SARG G 12 Fast A_CustomMeleeAttack(random(5, 6) * 3, "misc/death1", "", "Eat");
            Goto See;
        Pain:
            SARG H 2 Fast;
            SARG H 2 Fast A_Pain;
            Goto See;

        Possession:
            TNT1 A 0 A_SetInvulnerable();
            SARG H 3;
            SARG H 3 A_Pain();
            "####" "#" 35 ACS_NamedExecuteAlways("Pos - Flicker effect");
            TNT1 A 0 A_UnSetInvulnerable();
            Goto See;

        Pain.Stun:
            TNT1 A 0 A_SpawnItemEx("StunElectrocute", random(-4, 4), random(-4, 4),  random(16, 32), 0, 0);
            SARG H 1 A_Pain();
            SARG HHHHHHHHHH 3 A_SpawnItemEx("StunElectrocute", random(-12, 12), random(-12, 12), random(16, 52), 0, 0);
            SARG H 1 A_Pain();
            SARG HHHHHHHHHH 3 A_SpawnItemEx("StunElectrocute", random(-12, 12), random(-12, 12), random(16, 52), 0, 0);
            SARG H 1 A_Pain();
            SARG HHHHHHHHHH 3 A_SpawnItemEx("StunElectrocute", random(-12, 12), random(-12, 12), random(16, 52), 0, 0);
            SARG H 1 A_Pain();
            SARG HHHHHHHHHH 3 A_SpawnItemEx("StunElectrocute", random(-12, 12), random(-12, 12), random(16, 52), 0, 0);
            SARG H 1 A_Pain();
            SARG HHHHHHHHHH 3 A_SpawnItemEx("StunElectrocute", random(-12, 12), random(-12, 12), random(16, 52), 0, 0);
            SARG H 1 A_Pain();
            Goto See;

        Pain.Siphon:
            TNT1 AAA 0 A_SpawnItemEx("RedLightning_Small", random(-12, 12), random(-12, 12), random(16, 52), 0, 0);
            SARG H 1
            {
                A_FaceTarget;
                A_GiveToTarget("HealthBonus", 4);
            }
            SARG H 5 A_FaceTarget();
            TNT1 A 0 A_Pain();
            Goto See;

        Pain.Shotgun:
            TNT1 A 0 {
                A_Pain();
                A_FaceTarget();
                A_Recoil(2);
            }
            SARG H 4;
            Goto See;	

        Pain.Kick:
        Pain.ExtremePunches:
            TNT1 A 0 {
                A_Pain();
                A_FaceTarget();
                A_Recoil(23);
            }
            SARG H 12;
            Goto See;	

        Death:
            TNT1 A 0 A_Jump(160, "CleanDeath");
            SAAR A 8 {
                A_SpawnProjectile("PB_MuchBlood", 50, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(0, 160));
                A_SpawnProjectile("XDeathDemonArm", 35, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(0, 160));
                A_SpawnProjectile("PB_XDeath1", 40, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(0, 160));
            }
            SAAR B 8 A_Scream();
            TNT1 A 0 {
                A_NoBlocking();
                A_SpawnItemEx("PoorPinkyLostHisArm",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            }
            Stop;

        CleanDeath:
            SARG I 8;
            SARG J 8 A_Scream();
            SARG K 4;
            SARG L 4 A_NoBlocking();
            SARG M 4;
            TNT1 A 0 {
                A_SpawnItemEx("PB_DeadDemon1");
                A_SpawnItemEX("GrowingBloodPool", 0, 0, 0, 0, 0, 0, 0, SXF_USEBLOODCOLOR | SXF_SETTARGET | SXF_NOCHECKPOSITION);
            }
            Stop;

        Death.Kick:
        Death.Melee:
        Death.SuperKick:
            TNT1 A 0 {
                A_FaceTarget();
                A_Recoil(5);
                ThrustThingZ(0, 20, 0, 1);
            }
            Goto CleanDeath;

        Death.Strong:
            TNT1 A 0 A_Jump(128, "Death.Strong2");
            TNT1 A 0 A_Jump(86, "DeathRemoveArm");
            TNT1 A 0 A_FaceTarget();
            TNT1 A 0 {
                A_SpawnProjectile("PB_MuchBlood2", 60, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(0, 160));
                for(int i = 0; i < 2; i++)
                {
                    A_SpawnProjectile("PB_SmallBrainPiece", 60, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(0, 160));
                    A_SpawnProjectile("PB_SmallBrainPiece", 60, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(0, 160));
                    A_SpawnProjectile("PB_XDeath3", random(45, 55), random(5, -5), random(160, 200), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(-10, 10));
                    A_SpawnProjectile("PB_XDeath2", random(45, 55), random(5, -5), random(160, 200), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(-10, 10));
                    A_SpawnProjectile("PinkyHeadPiece", 52, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(0, 160));
                }

                for(int i = 0; i < 4; i++)
                {
                    A_SpawnProjectile("PB_BloodmistBig", 50, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(30, 90));
                }

                for(int i = 0; i < 5; i++)
                {
                    A_SpawnProjectile("PB_SmallBrainPieceFast", random(45, 55), random(5, -5), random(170, 190), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(-10, 10));
                }
            }                
            SARH AAAAAAA 2 A_SpawnProjectile("PB_SquirtingBloodTrail", 40, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(30, 110));
            SARH BBBBBB 2 A_SpawnProjectile("PB_SquirtingBloodTrail", 40, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(30, 110));
            TNT1 A 0 {
                A_NoBlocking();
                A_Scream();
            }
            SARH CCCCCC 2 A_SpawnProjectile("PB_SquirtingBloodTrail", 30, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(30, 110));
            TNT1 A 0 A_SpawnItemEX("GrowingBloodPool", 0, 0, 0, 0, 0, 0, 0, SXF_USEBLOODCOLOR | SXF_SETTARGET | SXF_NOCHECKPOSITION);
            SARH DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD 2 A_SpawnProjectile("PB_SquirtingBloodTrail", 20, 0, random(0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random(30, 110));
            TNT1 A 0 A_SpawnItemEx("PB_DeadDemonNoHead");
            Stop;

        Death.Shotgun:
            TNT1 A 0 A_JumpIfCloser(200, "Death.Strong");
            Goto CleanDeath + 3;

        Raise:
            SARG N 5;
            SARG MLKJI 5;
            Goto See;
	}
}

/*
*************************
***** CORPSE ACTORS *****
*************************
*/
// Base Corpse
class PB_DeadDemon1: PB_CurbstompedMarine Replaces DeadDemon
{
	Default {
		Mass 100;
		Health 200;
		Radius 8;
		Height 6;
	}
	States {
		Spawn:
            SARG NNN 120;
            SARG NN 1 A_SpawnItemEx("SwarmFly",frandom(-16,16),frandom(-16,16),frandom(-16,16));
            SARG N -1;
            Stop;
		Raise:
			TNT1 A 2 A_SpawnProjectile ("RealFlameTrailsSmall", 6, 0, random(0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random(70, 110));
			TNT1 A 0 A_SpawnItem("PentagramSpawner", 0, 60);
			TNT1 A 2 A_SpawnProjectile ("RealFlameTrailsSmall", 6, 0, random(0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random(70, 110));
			TNT1 A 0 A_SpawnItem("PentagramSpawner", 0, 60);
			TNT1 A 2 A_SpawnProjectile ("RealFlameTrailsSmall", 6, 0, random(0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random(70, 110));
			TNT1 A 0 A_SpawnItem("PentagramSpawner", 0, 60);
			TNT1 A 0 A_SpawnItem("TeleportFog");
			TNT1 A 0 A_NoBlocking();
			TNT1 A 0 A_SpawnItem("PB_Demon");
			Stop;
		Death:
			TNT1 A 0 {
				A_XScream();
				A_NoBlocking();
				NashGoreGibs.SpawnGibs(self);
				A_SpawnItemEx("PB_DeadDemonNoHead");
			}
			Stop;
	}
}

class PB_DeadDemonNoHead : PB_DeadDemon1
{
    States {
        Spawn:
            SARH DDD 98;
            SARH DDDD 1 A_SpawnItemEx("SwarmFly",frandom(-16,16),frandom(-16,16),frandom(-16,16));
            SARH D -1;
            Stop;
        Death:
            TNT1 A 0 {
                NashGoreGibs.SpawnGibs(self);
                A_NoBlocking();
                A_SpawnProjectile("XDeathStomach", 50, 0, random (0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random (0, 160));
                A_SpawnItem("PB_DeadDemonHalf23");
                A_SpawnProjectile("PinkyJaw", 22, 0, random (0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random (0, 160));

                for(int i = 0; i < 2; i++)
                {
                    A_SpawnProjectile("XDeathDemonArm", 35, 0, random (0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random (10, 40));
                    A_SpawnItemEx("MeatDeathSmall", 0, 20);
                }
            }
            Stop;
    }
}

class PB_DeadDemonHalf23 : PB_DeadDemon1
{
    States
    {
        Spawn:
            SARC D -1;
            Stop;

        Death:
        Death.Saw:
        Death.Tear:
        Death.Cut:
        Death.Cutless:
            TNT1 A 0 {
                NashGoreGibs.SpawnGibs(self);
                A_SpawnProjectile("XDeathBullLeg12", 35, 0, random (0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random (10, 40));
                A_SpawnProjectile("XDeathBullLeg12", 35, 0, random (0, 360), CMF_ABSOLUTEPITCH | CMF_BADPITCH, random (10, 40));

                for(int i = 0; i < 7; i++)
                {
                    A_SpawnProjectile ("PB_XDeath1", 42, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
                    A_SpawnProjectile ("NashGoreBloodParticle1", 42, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 160));
                }
            }
            Stop;
    }
}