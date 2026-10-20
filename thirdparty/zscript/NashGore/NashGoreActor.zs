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

class NashGoreActor : NashGorePlugin
{
	bool bSuperTicked;
	bool bCanBleed;
	bool bIsDead;
	bool bMirroredDeathSprite;
	bool bGibbed;
	bool bCorpseBlood;
	bool bShattered;
	bool bSquished;

	const MAX_FALLTICS = 20;
	int fallTics;

	const MAX_FOOTPRINT_DURATION = 65;
	const FOOTPRINT_INTERVAL = 7;
	int footprintFootSide;
	int footprintDuration;
	int footprintSpawnInterval;
	NashGoreCorpseBlood lastCorpseBlood;

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		if (!bSuperTicked)
		{
			Super.Tick();
			bSuperTicked = true;
		}

		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

		if (!Owner) return;

		// footprint stuff (only for players)
		if (Owner is "PlayerPawn")
		{
			footprintSpawnInterval--;
			if (NashGoreStatics.GetVelocity(Owner) > 0 && NashGoreStatics.bIsOnFloor(Owner) && footprintDuration > 0)
			{
				footprintDuration--;

				if (footprintSpawnInterval <= 0)
				{
					// lower intervals produce more dense footprints
					footprintSpawnInterval = FOOTPRINT_INTERVAL;

					bool result;
					Actor footprint;

					// find the last corpse blood that was stepped on
					if (lastCorpseBlood && lastCorpseBlood.target)
					{
						int flags = SXF_USEBLOODCOLOR | SXF_NOCHECKPOSITION | SXF_ABSOLUTEANGLE;

						double ang = Owner.Angle;

						[result, footprint] =
						lastCorpseBlood.target.A_SpawnItemEx("NashGoreFootprint", angle: ang, flags);

						//Console.Printf("%s", lastCorpseBlood.target.GetClassName());

						if (footprint)
						{
							// calculate footprint spawn offset
							if (footprintFootSide == 0) footprintFootSide = 1;
							else if (footprintFootside == 1) footprintFootSide = 0;
							double feetDistance = 5;
							double angAdjust = 90 * ((footprintFootSide == 0) ? -1 : 1);
							Vector3 sPos =
							(
								Owner.Pos.X + cos(ang + angAdjust) * feetDistance,
								Owner.Pos.Y + sin(ang + angAdjust) * feetDistance,
								Owner.Pos.Z
							);

							// move footprint to position
							footprint.SetOrigin(sPos, false);
						}
					}
				}
			}
		}

		// death stuff
		if (bIsDead)
		{
			// randomly mirror death sprite
			/*
			if (nashgore_deathflip && !Owner.bIceCorpse && !bMirroredDeathSprite)
			{
				NashGoreStatics.RandomXFlip(Owner);
				bMirroredDeathSprite = true;
			}
			*/

			// falling death. SPLAT!
			if (nashgore_splat && Owner.waterlevel < 2)
			{
				if (fallTics < MAX_FALLTICS && !NashGoreStatics.bIsOnFloor(Owner)) fallTics++;
				if (fallTics == MAX_FALLTICS && NashGoreStatics.bIsOnFloor(Owner) && !Owner.bIceCorpse)
				{
					Owner.A_StartSound("nashgore/bodydrop");
					if (bCanBleed)
					{
						for (int i = 0; i < 20; i++)
						{
							Owner.A_SpawnItemEx("NashGoreBloodSpurt",
								frandom(-4, 4), frandom(-4, 4), frandom(10, 20),
								frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(5.0, 10.0),
								frandom(0, 360), SXF_USEBLOODCOLOR);
						}
					}
					fallTics = MAX_FALLTICS + 1;
				}
			}

			if (nashgore_squish)
			{
				int spawnFlags = SXF_USEBLOODCOLOR | SXF_NOCHECKPOSITION;

				double crushHeight = (Owner.Pos.Z + Owner.Height) + Owner.GetDeathHeight();

				if (Owner.CeilingZ <= crushHeight && Owner.Pos.Z <= Owner.FloorZ && !bSquished)
				{
					if (bCanBleed)
					{
						// spawn crushed gib based on size
						if (Owner.Radius <= 20)
						{
							Owner.A_SpawnItemEx("NashGoreCrushedGibsSmall", flags: spawnFlags);
						}
						else if (Owner.Radius > 20 && Owner.Radius < 40)
						{
							Owner.A_SpawnItemEx("NashGoreCrushedGibsMedium", flags: spawnFlags);
						}
						else if (Owner.Radius >= 40)
						{
							Owner.A_SpawnItemEx("NashGoreCrushedGibsLarge", flags: spawnFlags);
						}
					}

					bSquished = true;
				}
			}

			// gibbed stuff
			/*
			bool canGib =
			(
				Owner.Health < Owner.GetGibHealth() ||
				(Owner.FindState('XDeath', true) != NULL && 
				Owner.InStateSequence(Owner.CurState, Owner.ResolveState('XDeath')))
			);
			
			bool shotInHead = (Owner.InStateSequence(Owner.CurState, Owner.ResolveState("Death.Head")));
			
			
			if (!bGibbed && canGib && bCanBleed && !shotInHead)
			{
				NashGoreGibs.SpawnGibs(Owner);
				bGibbed = true;
			}
			*/
			// spawn ice gore stuff
			if (Owner.bShattering && !bShattered && bCanBleed)
			{
				bShattered = true;
				for (int i = 0; i < 20; i++)
				{
					Owner.A_SpawnItemEx("NashGoreGibs",
						zofs: Owner.Height,
						frandom(-2, 2), frandom(-2, 2), frandom(-4, 4),
						flags: spawnFlags, 125);
				}
			}
		}
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	void ResetActor(void)
	{
		bIsDead = false;
		bCorpseBlood = false;
		bGibbed = false;
		fallTics = 0;
		footprintDuration = 0;
		lastCorpseBlood = NULL;
		bMirroredDeathSprite = false;
		Owner.bSpriteFlip = false;
	}
}
