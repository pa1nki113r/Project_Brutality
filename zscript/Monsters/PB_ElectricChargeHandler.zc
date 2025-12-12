class PB_ElectricChargeHandler : EventHandler
{
    Array<Actor> chargeTargets;  // Stores charged actors
    Array<int> chargeLevels;     // Stores charge amount (0-100)
    Array<int> chargeTimers;     // Stores countdown for delayed damage

    override void WorldThingDamaged(WorldEvent e)
    {
        if (e.DamageSource == null || e.Thing == null)
            return;

//		Console.Printf("\cyDamage Event: %s hit %s for %d damage", e.DamageSource ? e.DamageSource.GetTag() : "UNKNOWN",e.Thing ? e.Thing.GetTag() : "UNKNOWN",e.Damage);
		
		if (e.DamageSource && e.Inflictor && e.Thing)
		{
//			Console.Printf("\cgDamageSource Class: %s, \cuInflictor Class: %s, \cde.Thing: %s ", e.DamageSource.GetClassName(),e.Inflictor.GetClassName(),e.Thing.GetClassName());
		}


        if (e.Inflictor && (e.Inflictor is "PB_CacodemonBall" || e.Inflictor is "PB_CacodemonBall2"))
		{
			int chargeAmount = (e.Inflictor is "PB_CacodemonBall2") ? 50 : 25;
			Actor target = e.Thing;

	//		Console.Printf("\cyHit: %s took %d charge from %s", target.GetTag(), chargeAmount, e.Inflictor.GetTag());
		


            // Find existing entry
            for (int i = 0; i < chargeTargets.Size(); i++)
            {
                if (chargeTargets[i] == target)
                {
                    chargeLevels[i] += chargeAmount;
      //              Console.Printf("\ctUpdated Charge: %s now at %d%%", target.GetTag(), chargeLevels[i]);

                    if (chargeLevels[i] >= 100 && chargeTimers[i] <= 0)
                    {
                        chargeTimers[i] = 100;  // Set delay for extra damage
        //                Console.Printf("\cy%s is fully charged! Damage in 100 tics.", target.GetTag());
						S_StartSound("Thunder",0);
                    }
                    return;
                }
            }

            // New entry if not found
            chargeTargets.Push(target);
            chargeLevels.Push(chargeAmount);
            chargeTimers.Push((chargeAmount >= 100) ? 100 : 0);
   //         Console.Printf("\cyNew target tracked: %s at %d%% charge", target.GetTag(), chargeAmount);
        }
		

		if (e.DamageSource && e.DamageSource.GetClassName() == "LightningBolt" && e.Thing.player)
		{
			e.Thing.A_SetBlend("Blue", 0.8, 40, "Blue");
		}


    }

	override void WorldTick()
	{
		for (int i = chargeTargets.Size() - 1; i >= 0; i--)
		{
			if (chargeTargets[i] == null || !chargeTargets[i])
			{
		//		Console.Printf("\coRemoving: %s (dead or null)", chargeTargets[i] ? chargeTargets[i].GetTag() : "NULL");
				
				chargeTargets.Delete(i);
				chargeLevels.Delete(i);
				chargeTimers.Delete(i);
				continue;
			}

		//	Console.Printf("\co%s: Charge %d%% | Timer: %d", chargeTargets[i].GetTag(), chargeLevels[i], chargeTimers[i]);

			if (chargeTimers[i] > 0)
			{
				chargeTimers[i]--;
				if (chargeTimers[i] == 0)
				{
					S_StartSound("ThunderStrike",0);
					Actor target = chargeTargets[i];

					chargeLevels[i] = 0;

					// Compute angles for LineTraceVisual
					double yaw = 0;         // Straight up
					double pitch = -90;     // -90 degrees (purely vertical)

					FLineTraceData traceData;
/* 					bool traceResult = Line3d.LineTraceVisual(
						target,             // Source actor
						yaw,                // Yaw (straight up)
						2000,               // Distance to check
						pitch,              // Pitch (-90° up)
						TRF_NOSKY | TRF_THRUACTORS, // Ignore actors, but stop at sky
						target.Height,                 // OffsetZ (check from above)
						0,                  // OffsetXY
						0,                  // OffsetSide
						data: traceData,    // Output trace data
						LineClassName: "Line3d",
						TimeToLive: 1,
						TimeToCycle: 0,
						MarkerClassName: "Marker3d"
					); */
					
					bool traceResult = target.LineTrace(
						yaw,                // Yaw (straight up)
						2000,               // Distance to check
						pitch,              // Pitch (-90° up)
						TRF_NOSKY | TRF_THRUACTORS, // Ignore actors, but stop at sky
						target.Height,                 // OffsetZ (check from above)
						0,                  // OffsetXY
						0,                  // OffsetSide
						data: traceData
					);

					if (!traceResult) 
					{
	//					Console.Printf("\cy%s is under open sky! Spawning explosion.", target.GetTag());
						Actor.Spawn("LightningBolt",(target.pos.x,target.pos.y,target.pos.z));
					}
				else
					{
	//					Console.Printf("\cy%s is NOT under open sky! Finding nearest valid spot...", target.GetTag());
						FireGroundTracers(target);
					} 
				}
			}
		}
	}

	void FireGroundTracers(Actor target)
	{
		double distance = 256;  // Distance outward
		double pitch = 25;      // Downward pitch in degrees

		// Separate arrays for X, Y, Z coordinates of valid locations
		Array<double> validX;
		Array<double> validY;
		Array<double> validZ;

		for (int i = 0; i < 8; i++)
		{
			double yaw = i * 45; // 0°, 45°, 90°, ..., 315°

			FLineTraceData traceData;
/*			bool traceResult = Line3d.LineTraceVisual(
				target,               // Source actor (target)
				yaw,                  // Yaw angle (fixed-point Doom angle)
				distance,             // Distance of the trace
				pitch,                // Downward pitch
				TRF_THRUACTORS,       // Pass through actors, but hit ground
				target.Height,        // Start at the actor’s height
				0,                    // OffsetXY
				0,                    // OffsetSide
				data: traceData,      // Output trace data
				LineClassName: "LaserBlast", // Debug visual
				TimeToLive: 105,
				TimeToCycle: 0,
				MarkerClassName: "Marker3d"
			);
			*/
			
			bool traceResult = target.LineTrace(
				yaw,                  // Yaw angle (fixed-point Doom angle)
				distance,             // Distance of the trace
				pitch,                // Downward pitch
				TRF_THRUACTORS,       // Pass through actors, but hit ground
				target.Height,        // Start at the actor’s height
				0,                    // OffsetXY
				0,                    // OffsetSide
				data: traceData
			);

			if (traceResult && traceData.HitType == TRACE_HitFloor)
			{
//				Console.Printf("\cdTracer %d hit ground at: (%f, %f, %f)", i, traceData.HitLocation.X, traceData.HitLocation.Y, traceData.HitLocation.Z);

				// SECOND TRACE UPWARD
				FLineTraceData skyTraceData;
			/*	bool skyTraceResult = Line3d.LineTraceVisual(
					target,                // Source actor (target)
					0,                     // Yaw angle (same as before)
					2000,                  // Large upward distance
					-90,                   // Straight up
					TRF_NOSKY | TRF_THRUACTORS | TRF_ABSPOSITION | TRF_ABSOFFSET, // Ignore actors, check for sky
					traceData.HitLocation.Z,    // Start from ground hit location
					traceData.HitLocation.X,    // X offset (from previous hit)
					traceData.HitLocation.Y,    // Y offset (from previous hit)
					data: skyTraceData,         // Output trace data
					LineClassName: "Line3d",    // Debug visual
					TimeToLive: 105,
					TimeToCycle: 0,
					MarkerClassName: "Marker3d"
				);
				*/
				
				bool skyTraceResult = target.LineTrace(
					0,                     // Yaw angle (same as before)
					2000,                  // Large upward distance
					-90,                   // Straight up
					TRF_NOSKY | TRF_THRUACTORS | TRF_ABSPOSITION | TRF_ABSOFFSET, // Ignore actors, check for sky
					traceData.HitLocation.Z,    // Start from ground hit location
					traceData.HitLocation.X,    // X offset (from previous hit)
					traceData.HitLocation.Y,    // Y offset (from previous hit)
					data: skyTraceData
				);

				if (!skyTraceResult) // Sky is clear
				{
//					Console.Printf("\cySky is clear above: (%f, %f, %f)", traceData.HitLocation.X, traceData.HitLocation.Y, traceData.HitLocation.Z);

					// Store X, Y, Z separately
					validX.Push(traceData.HitLocation.X);
					validY.Push(traceData.HitLocation.Y);
					validZ.Push(traceData.HitLocation.Z);
				//	Actor.Spawn("LightningBolt",(traceData.HitLocation.X,traceData.HitLocation.Y,traceData.HitLocation.Z));
				}
				else
				{
//					Console.Printf("\cgSky blocked at: (%f, %f, %f)", skyTraceData.HitLocation.X, skyTraceData.HitLocation.Y, skyTraceData.HitLocation.Z);
				}
			}
			else
			{
//				Console.Printf("\coTracer %d missed ground! No valid hit location.", i);
			}
		}

		// Spawn explosion at a random valid location if we have any
		if (validX.Size() > 0)
		{
			int randomIndex = Random(0, validX.Size() - 1);
			double chosenX = validX[randomIndex];
			double chosenY = validY[randomIndex];
			double chosenZ = validZ[randomIndex];

//			Console.Printf("\cGSpawning explosion at: (%f, %f, %f)", chosenX, chosenY, chosenZ);

			// Spawn the explosion
			Actor.Spawn("LightningBolt", (chosenX, chosenY, chosenZ));
		}
/* 
		{
			Console.Printf("\cRNo valid locations found for explosion!");
		}
	}
 */
	}




}



