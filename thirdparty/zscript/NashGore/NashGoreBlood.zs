// Copyright 2006-2019 Nash Muhandes
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//===========================================================================
//
//
//
//===========================================================================

const NGORE_BLOOD_FLAGS = SXF_TRANSFERTRANSLATION | SXF_ABSOLUTEPOSITION | SXF_ABSOLUTEANGLE | 
                            SXF_ABSOLUTEVELOCITY | SXF_TRANSFERPOINTERS | SXF_SETMASTER;


class PB_GreenTranslationDummy : Actor
{
    Default {
        Translation "168:191=112:127", "16:47=123:127";
    }
}

class PB_BlueTranslationDummy : Actor
{
    Default {
        Translation "168:191=192:207", "16:47=240:247";
    }
}

class NashGoreBloodBase : Blood
{
	Default
	{
		FloatBobPhase 0;
		+NOBLOCKMAP
		+PUFFGETSOWNER
		+FORCEXYBILLBOARD
		-RANDOMIZE
		+DONTSPLASH
		+NOTELEPORT
		-SOLID
	}

	const BLOOD_FLAGS = SXF_TRANSFERTRANSLATION | SXF_ABSOLUTEPOSITION | SXF_ABSOLUTEANGLE |
		SXF_ABSOLUTEVELOCITY | SXF_TRANSFERPOINTERS | SXF_SETMASTER;

	//===========================================================================
	//
	//
	//
	//===========================================================================

	action void SpawnCeilingBlood() {
		FLineTraceData t;
		int flags = TRF_THRUACTORS;

		double ang = frandom(0, 360);

		LineTrace(ang, 32, frandom(-90, 0), flags, 0, data: t);

		if (t.HitType == t.TRACE_HitCeiling)
		{
			bool result;
			Actor obj;

			// ceiling blood
			if (nashgore_bloodtype == 0 || nashgore_bloodtype == 1)
			{
				class<Actor> cls;
				cls = "PB_BloodSpotCeiling";

				[result, obj] = A_SpawnItemEx(cls, flags: SXF_USEBLOODCOLOR | BLOOD_FLAGS, 150);
				if (obj)
				{
					obj.Gravity = 0;
					obj.SetOrigin(t.HitLocation, true);
					PB_BloodSpotCeiling(obj).bOnCeiling = true;

					// flip sprite Y
					if (nashgore_spriteblood) obj.Scale.Y *= -1;
				}
			}
		}
	}
	
	override void BeginPlay(void)
	{
		Super.BeginPlay();

		if (!level.IsPointInLevel(Pos))
		{
			Destroy();
			return;
		}

		NashGoreStatics.RandomXFlip(self);
	}

	override void PostBeginPlay(void)
	{
		if (random() < (255 - nashgore_bloodamount)) { Destroy(); return; }

        if(int(self.Translation) == 0)
        {
            if(target) CopyBloodColor(target);
            else if(master) CopyBloodColor(master);
            else if(tracer) CopyBloodColor(tracer);

            // this means you found a new translation so set it
            if(int(bloodtranslation) != 0) 
                self.Translation = bloodtranslation;
        }

		Super.PostBeginPlay();
	}
	
	//from nashgore next
	static void SprayBloodDecals(Actor self, int defaultAmount = 14)
	{
		if (defaultAmount <= 0)
			defaultAmount = 1;
		int amt = NashGoreStatics.GetAmountMult(nashgore_bloodmult);
		for (int i = 0; i < defaultAmount; i++)
		{
			for (int j = 0; j < amt; j++)
				self.TraceBleedAngle(random[rnd_SprayBloodDecals](10, 100), frandom[rnd_SprayBloodDecals](0.0, 360.0), frandom[rnd_SprayBloodDecals](-70.0, 0.0));
		}
	}
	
	
}

//===========================================================================
//
//
//
//===========================================================================


class NashGoreBloodImpact : NashGoreBloodBase
{
	Default
	{
		Scale 0.2;
		+NOINTERACTION
		+NOGRAVITY
        +ROLLSPRITE
	}

    override void BeginPlay(void)
	{
		if (!level.IsPointInLevel(Pos))
		{
			Destroy();
			return;
		}

        scale = (frandom(0.2, 0.3), frandom(0.2, 0.3));
        NashGoreStatics.RandomXFlip(self);
        roll = random(-20, 40) * (bSPRITEFLIP ? -1 : 1);
	}

    override void Tick() 
    {
        Super.Tick();
        if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

        if(GetAge() < 5)
        {
            scale.x *= 1.23;
            scale.y *= 1.23;
        }
        else
        {
            //scale.x *= 1.05;
            scale.y *= 1.09;
            A_FadeOut(0.08, FTF_REMOVE);
            vel.z -= 0.3;
            roll += bSPRITEFLIP ? 3 : -3;
        }
    }

	States
	{
        Spawn:
            TNT1 A 0 NoDelay { frame = random(0, 8); }
        BloodLoop:
            NGBI "#" 1;
            Loop;
	}
}

//===========================================================================
//
//
//
//===========================================================================

class NashGoreBlood : NashGoreBloodBase replaces Blood
{
	Default
	{
		+NOGRAVITY
	}

	int chanceMod;

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
        TNT1 A 0 { chanceMod = 0;		return ResolveState("Spawn2"); }
		TNT1 A 0 { chanceMod = 100;		return ResolveState("Spawn2"); }
		TNT1 A 0 { chanceMod = 220;		return ResolveState("Spawn2"); }
		
	Spawn2:
		TNT1 A 0
		{                
            A_SpawnItemEx("NashGoreBloodImpact", flags: BLOOD_FLAGS, chanceMod);
			
			let[amt, cmul] = NashGoreStatics.GetAmountMult(nashgore_bloodmult, chanceMod);
			for (int i = 0; i < amt; i++)
			{
				A_SpawnItemEx("NashGoreBloodParticle1",
					frandom[rnd_SpawnBloodParticle1](-8.0, 8.0), frandom[rnd_SpawnBloodParticle1](-8.0, 8.0), frandom[rnd_SpawnBloodParticle1](-8.0, 8.0),
					frandom[rnd_SpawnBloodParticle1](-3.0, 3.0), frandom[rnd_SpawnBloodParticle1](-3.0, 3.0), frandom[rnd_SpawnBloodParticle1](-2.0, 7.0),
					frandom[rnd_SpawnBloodParticle1](0.0, 360.0), BLOOD_FLAGS);
			}
		}
		TNT1 A 0 {
			let[amt, cmul] = NashGoreStatics.GetAmountMult(nashgore_bloodmult, chanceMod);
			for (int i = 0; i < amt; i++)
			{
				A_SpawnItemEx("NashGoreBloodParticle2",
					frandom[rnd_SpawnBloodParticle2](-8, 8), frandom[rnd_SpawnBloodParticle2](-8, 8), frandom[rnd_SpawnBloodParticle2](-8, 8),
					frandom[rnd_SpawnBloodParticle2](-5.5, 5.5), frandom[rnd_SpawnBloodParticle2](-5.5, 5.5), frandom[rnd_SpawnBloodParticle2](1.0, 3.0),
					frandom[rnd_SpawnBloodParticle2](0, 360), BLOOD_FLAGS, chanceMod);
			}
		}
		Stop;
	}
}

class NashGoreBlood_Green : NashGoreBlood
{
	Default {
		translation "168:191=112:127", "16:47=123:127";
	}
}

class NashGoreBlood_Blue : NashGoreBlood
{
	Default {
		translation "168:191=192:207","16:47=240:247";
	}
}
//===========================================================================
//
//
//
//===========================================================================


class NashGoreBloodParticle1 : NashGoreBloodBase
{
	Default
	{
		Scale 0.6;
		Gravity 0.9;
		+NOCLIP
		+CORPSE
		Speed 7;
		Radius 8;
		Height 1;
		+MISSILE;
		-NOGRAVITY;
		Decal "BloodSplat";
		+rollsprite;
		+rollcenter;
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================
	override void postbeginplay()
	{
		super.postbeginplay();
		A_SetRoll(random(0,360));
		A_SetScale(scale.x + frandom(-0.12,0.2));
	}
	override void Tick(void)
	{
		Super.Tick();
		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

		if (GetAge() == 10) A_SetRenderStyle(1, STYLE_Translucent);
		if (GetAge() > 10) Alpha *= 0.9;

		A_SetScale(Scale.X + 0.0075);

		if (GetAge() > 350)
		{
			Destroy();
			return;
		}

		if (waterlevel > 0 && waterlevel < 3)
		{
			SetZ(Pos.Z - Vel.Z);
			NashGoreLiquidBlood.SpawnLiquidBlood(self);
			Destroy();
			return;
		}
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		TNT1 A 1 NoDelay {
			SpawnCeilingBlood();
			return A_Jump(256, "Blood1", "Blood2", "Blood3", "Blood4", "Blood5", "Blood6");
		}
		Stop;
	Blood1:
		NBL1 A -1;
		Stop;
	Blood2:
		NBL1 B -1;
		Stop;
	Blood3:
		NBL1 C -1;
		Stop;
	Blood4:
		NBL1 D -1;
		Stop;
	Blood5:
		NBL1 E -1;
		Stop;
	Blood6:
		NBL1 F -1;
		Stop;
	Crash:
		TNT1 A 1 {
            A_StartSound("blooddrop2");
            A_SpawnItemEx("PB_BloodSpot", flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION);
        }
		Stop;
	}
}

class NashGoreBloodParticle2 : NashGoreBloodBase
{
	Default
	{
		Radius 1;
		Height 2;
		Gravity 0.4;
		Scale 0.6;
		+NOCLIP
		+NOBLOCKMAP
		+CORPSE
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	/*
	Spawn:
		NBL2 ABCD 4;
		Stop;
		*/
		
	Spawn:
		TNT1 A 1 NoDelay {
			SpawnCeilingBlood();
			return A_Jump(256, "Spawn1", "Spawn2", "Spawn3");
		}
	Spawn1:
		X057 ABCDEFGHIJKLMNOPQRS 1;
		Wait;
	Spawn2:
		X058 ABCDEFGHIJKLMNOPQR 1;
		Wait;
	Spawn3:
		X059 ABCDEFGHIJKLM 1;
		Wait;
	Crash:
		TNT1 A 1 {
            A_StartSound("blooddrop2");
            A_SpawnItemEx("PB_BloodSpot", flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, failchance: 220);
        }
		Stop;
	}
}

class PB_FlyingBlood : NashGoreBloodParticle2
{
    Default {
        Speed 7;
        Gravity 0.9;
        Decal "BloodSplat";
    }

    override void BeginPlay()
    {
        Speed *= frandom(0.7, 1.2);
        Super.BeginPlay();
    }
}

class PB_FlyingBloodFaster : PB_FlyingBlood
{
    Default {
        Speed 4;
        Gravity 0.9;
    }
}

class PB_FlyingBloodMuchFaster : PB_FlyingBlood
{
    Default {
        Speed 18;
        Gravity 0.9;
    }
}

class NashGoreBloodParticle_Large : NashGoreBloodBase
{
	Default
	{
		Radius 1;
		Height 2;
		Gravity 0.24;
		Scale 0.65;
		+NOCLIP
		+NOBLOCKMAP
		+CORPSE
		Speed 2;
		+MISSILE;
		-NOGRAVITY;
		Decal "BloodSuper";
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	/*
	Spawn:
		NBL2 ABCD 4;
		Stop;
		*/
		
	Spawn:
		TNT1 A 1 NoDelay {
			SpawnCeilingBlood();
			return A_Jump(256, "Spawn1", "Spawn2", "Spawn3");
		}
	Spawn1:
		X057 ABCDEFGHIJKLMNOPQRS 1;
		Wait;
	Spawn2:
		X058 ABCDEFGHIJKLMNOPQR 1;
		Wait;
	Spawn3:
		X059 ABCDEFGHIJKLM 1;
		Wait;
	Crash:
		TNT1 A 1 A_SpawnItemEx("PB_BloodSpot", flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, failchance: 255 - nashgore_bloodamount);
		Stop;
	}
}

//===========================================================================
//
//
//
//===========================================================================

class NashGoreClassicBlood : NashGoreBloodBase
{
	Default
	{
		-RANDOMIZE
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		TNT1 A 0 NoDelay
		{
			A_SpawnItemEx("NashGoreBloodImpact", flags: BLOOD_FLAGS);

			// This shit needs to be in the Spawn state for translations to work correctly. >8[
			A_SpawnItemEx("NashGoreClassicBloodTrailSpawner",
				xvel: frandom(-6, 6), frandom(-6, 6), frandom(0, 8),
				frandom(0.0, 360.0), SXF_TRANSFERTRANSLATION, 110);
		}
		Stop;
	}
}

class NashGoreClassicBloodTrailSpawner : NashGoreBloodBase
{
	Default
	{
		Radius 8;
		Height 2;
		Gravity 0.235;
		+NOFRICTION
		+NOCLIP
		+CORPSE
	}

	const DECELERATION_SPEED = 0.963;

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		Super.Tick();
		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

		Vel.XY *= DECELERATION_SPEED;

		if (waterlevel >= 3)
		{
			A_FadeOut(0.07);
		}
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		TNT1 A 3
		{
			A_SpawnItemEx("NashGoreClassicBloodTrail", flags: SXF_TRANSFERTRANSLATION);
		}
		Loop;
	Crash:
		TNT1 A 0
		{
			A_StartSound("nashgore/bloodsplash");
			A_SpawnItemEx("NashGoreBloodSpotClassic", flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, failchance: 245);
		}
		Stop;
	}
}

class NashGoreClassicBloodTrail : NashGoreBloodBase
{
	Default
	{
		Radius 1;
		Height 1;
		Gravity 0.235;
		Scale 0.67;
		+CORPSE
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		NTRL ABCD 4;
		Loop;
	Crash:
		TNT1 AAAAA 1 A_SpawnItemEx("NashGoreBloodFloorSplash", frandom(-32, 32), frandom(-32, 32), flags: SXF_TRANSFERTRANSLATION | SXF_ABSOLUTEPOSITION | SXF_NOCHECKPOSITION, 220);
        TNT1 A 0 A_SpawnItemEx("PB_BloodSpotTiny", frandom(-4, 4), frandom(-4, 4), flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, 220);
		Stop;
	}
}

//===========================================================================
//
//
//
//===========================================================================

class NashGoreBloodSpurtSpawner : Actor
{
	Default
	{
		FloatBobPhase 0;
		+DONTSPLASH
		+NOTELEPORT
		+NOBLOCKMONST
		+NOBLOCKMAP
		+MOVEWITHSECTOR
		-SOLID
	}

	uint8 spurtInterval;
	uint8 spurtDuration;

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		Super.Tick();
		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

		if (spurtInterval == 0)
		{
			spurtInterval = random(10, 75);
			spurtDuration = random(5, 20);
		}
		else if (spurtInterval > 0)
		{
			spurtInterval--;
		}

		if (spurtDuration > 0)
		{
			int amt, cmul;
			[amt, cmul] = NashGoreStatics.GetAmountMult(nashgore_bloodmult);
			for (int i = 0; i < amt; i++)
			{
				A_SpawnItemEx("NashGoreBloodSpurt",
					frandom[rnd_SpawnBloodSpurt](-5.0, 5.0), frandom[rnd_SpawnBloodSpurt](-5.0, 5.0), frandom[rnd_SpawnBloodSpurt](15.0, 25.0),
					frandom[rnd_SpawnBloodSpurt](-2.0, 2.0), frandom[rnd_SpawnBloodSpurt](-2.0, 2.0), frandom[rnd_SpawnBloodSpurt](4.0, 8.0),
					frandom[rnd_SpawnBloodSpurt](0.0, 360.0),
					NashGoreBloodBase.BLOOD_FLAGS);
			}

			if (WaterLevel == 0)
			{
				if (random[rnd_SprayBloodDecals]() < 20)
					NashGoreBloodBase.SprayBloodDecals(self, 1);
			}

			spurtDuration--;
		}
		
		

		if (GetAge() >= Thinker.TICRATE * 5)
		{
			Destroy();
			return;
		}
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	}
}

class NashGoreBloodSpurt : NashGoreBloodBase
{
	Default
	{
		Gravity 0.4326;
        Scale 0.6;
		+CORPSE
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void BeginPlay(void)
	{
		Super.BeginPlay();

		Gravity *= frandom(1.0, 1.5);
	}

	override void Tick(void)
	{
		Super.Tick();
		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

		if (waterlevel > 1)
		{
			NashGoreLiquidBlood.SpawnLiquidBlood(self);
			Destroy();
			return;
		}
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		NBL2 ABCD 5;
		Loop;
	Crash:
		TNT1 A 1
		{
			A_SpawnItemEx("PB_BloodSpotTiny", frandom(-4, 4), frandom(-4, 4), flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION);
			A_SpawnItemEx("NashGoreBloodFloorSplash",
				frandom(-32, 32), frandom(-32, 32),
				flags: SXF_TRANSFERTRANSLATION | SXF_ABSOLUTEPOSITION | SXF_NOCHECKPOSITION);
            if(random(0, 100) > 25) A_StartSound("blooddrop3", volume: 0.6);
		}
		Stop;
	}
}

//===========================================================================
//
//
//
//===========================================================================

class NashGoreBloodFloorSplashSpawner : Actor
{
	Default
	{
		Radius 1;
		Height 1;
		Gravity 0.5;
		FloatBobPhase 0;
		+CORPSE
		+DONTSPLASH
		+NOTELEPORT
		+NOBLOCKMONST
		+NOBLOCKMAP
		-SOLID
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	Crash:
		TNT1 A 0 A_SpawnItemEx("NashGoreBloodFloorSplash", flags: NashGoreBloodBase.BLOOD_FLAGS);
		Stop;
	}
}

class NashGoreBloodFloorSplash : NashGoreBloodBase
{
	Default
	{
		Radius 1;
		Height 2;
		Scale 0.5;
		-NOBLOCKMAP
		-RANDOMIZE
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		Super.Tick();
		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

		if (waterlevel > 1)
		{
			Destroy();
			return;
		}
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		BDRP BCDEF 2;
		Stop;
	}
}

//===========================================================================
//
//
//
//===========================================================================

class NashGoreBloodDrop : NashGoreBloodBase
{
	Default
	{
		Scale 0.35;
		+FORCEYBILLBOARD
		+CORPSE
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		BDRP A -1;
		Stop;
	Crash:
		TNT1 A 0
		{
			A_SpawnItemEx("NashGoreBloodFloorSplash", flags: BLOOD_FLAGS);
			A_SpawnItemEx("PB_BloodSpotTiny", flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION);
			if (random() < 180) A_StartSound("nashgore/blooddrop");
		}
		Stop;
	}
}