class PB_Monster_Projectile : FastProjectile
{
	int drop_rate;

	override void BeginPlay()
	{
		super.BeginPlay();
		drop_rate = -5;
	
	}

/* 	override int SpecialMissileHit(Actor victim) 
    {
        if (victim && target && (victim != target)) 
        {
            

			if (victim.GetClassName() == target.GetClassName())
			{
				return 0;
			}
			
			if (victim.species == target.species)
			{
				return 0;
			}

			victim.DamageMobj(self, target, damage, damagetype);
   
        }
		
		else if (victim && target && (victim == target))
		{return 1;}
		
		victim.DamageMobj(self, target, damage, damagetype);
		return 0;

    } */
	
	double ComputeFlightTime(double dist)
	{
		if(dist < 600)
			return 13 + ((dist - 300) / 300.0) * (20 - 13);
		else if(dist > 900)
			return 27 + ((dist - 900) / 600.0) * (30 - 27);
		else
			return 20 + ((dist - 600) / 300.0) * (27 - 20);
	}
	
	double ComputeFlightTime2(double dist)
	{
		if (dist <= 700)
			return 15; // Fixed time for short ranges

		double baseTime = 15;   // Minimum time for short ranges
		double maxTime = 35;    // Max time for long ranges
		double scaleFactor = 15 / 1100.0; // Smooth scaling beyond 700

		// Linear interpolation for distances beyond 700
		double time = baseTime + (dist - 400) * scaleFactor;

		// Clamp time to avoid excessive values
		time = min(time, maxTime);

//		Console.Printf("\ccTime: %.2f , \cgDistance: %.2f", time, dist);
		return time;
	}


	double,double,double,double AdjustProjectileForArc(Actor projectile, Actor target, double dropRate, double pitchOffset = 0)
	{
		double pitchOffset = random(-pitchOffset,pitchOffset);
		double dist = (self.target ? distance3d(self.target) + pitchOffset : 4096);
		double t = ComputeFlightTime(dist);
		double heightDiff = (self.target ? self.target.pos.z - projectile.pos.z : 0);
		
		double Vx = dist / t;
		double Vz = (heightDiff - 0.5 * dropRate * t * t) / t;
			
		vector3 currentXY = (projectile.vel.x, projectile.vel.y, 0);
		double currentSpeed = sqrt(projectile.vel.x * projectile.vel.x + projectile.vel.y * projectile.vel.y);
//		Console.Printf("Before Adjustment speed: %.2f,", currentSpeed);
		currentSpeed = max(currentSpeed, 1);
		double scaleFactor = Vx / currentSpeed;
		
		projectile.vel.x *= scaleFactor;
		projectile.vel.y *= scaleFactor;
		projectile.vel.z = Vz;
		
//		Console.Printf("\ccAdjusted: Vx=%.2f, Vz=%.2f, t=%.2f, scale=%.2f", Vx, Vz, t, scaleFactor);
		return t, Vx , Vz , dist;
	}

	double, double, double, double AdjustProjectileForArc2(Actor projectile, Actor target, double dropRate)
	{
		// Safety: if no target exists, do nothing.
		if (target == null)
		{
			Console.Printf("AdjustProjectileForArc2: target is null!");
			return 0, 0, 0, 0;
		}

		double dist = distance3d(target);

		double t = ComputeFlightTime2(dist);

		//t = t * 0.9;
		double reduced_t = t * 0.8;
		vector3 targetFuturePos = target.pos + (target.vel * reduced_t);

		// Compute the full displacement vector from projectile to predicted target position.
		vector3 diff = targetFuturePos - projectile.pos;
		
		// Get only the horizontal (XY) component.
		vector3 diffHoriz = (diff.x, diff.y, 0);
		double predictedDist = sqrt(diffHoriz.x * diffHoriz.x + diffHoriz.y * diffHoriz.y);
		
		// Vertical difference.
		double heightDiff = diff.z;
		
		// Desired horizontal speed: distance divided by time.
		double desiredHorizSpeed = predictedDist / t ;
		
		// Desired vertical speed, compensating for drop (gravity).
		double desiredVz = (heightDiff - 0.5 * dropRate * t * t) / t;
		
		// Compute normalized horizontal direction.
		double horizMag = sqrt(diffHoriz.x * diffHoriz.x + diffHoriz.y * diffHoriz.y);
		if (horizMag < 0.0001)
		{
			horizMag = 0.0001; // Avoid division by zero.
		}
		vector3 horizDir = (diffHoriz.x / horizMag, diffHoriz.y / horizMag, 0);
		
		// Set the projectile's velocity directly.
		projectile.vel.x = horizDir.x * desiredHorizSpeed;
		projectile.vel.y = horizDir.y * desiredHorizSpeed;
		projectile.vel.z = desiredVz;
		

		
		return t, desiredHorizSpeed, desiredVz, predictedDist;
	}


	
	
	bool CheckArcUnobstructed(
		Actor projectil,       // Projectile actor
		vector3 startPos,      // Spawn position
		vector3 horizDir,      // Unit direction vector (XY)
		double new_targdist,   // Target horizontal distance
		double t,              // Estimated flight time (tics)
		double Vx,             // Horizontal velocity
		double Vz,             // Initial vertical velocity
		double drop_rateZ,     // Gravity per tic
		double segmentLength,  // Segment distance
		double offZ,           // Offset for line tracer (vertical)
		double offForward,     // Forward offset
		double offSide,         // Side offset
		string LineType,
		Actor arcTarget = null
	)
	{
		vector3 currentPos = startPos;  // Start at projectile position
		double totalHoriz = 0;
		double currentVz = Vz;  // Maintain vertical velocity

	//	Console.Printf("Starting laser at (%.1f, %.1f, %.1f)", startPos.x, startPos.y, startPos.z);

		
	//	Console.Printf("HorizDir: (%.3f, %.3f)", horizDir.x, horizDir.y);

		if (arcTarget == null)
		{
			arcTarget = self.target;
		}
		

		while (totalHoriz < new_targdist)  // Keep going until reaching the target distance
		{
			double dt = segmentLength / Vx;  // Time step for this segment

			// Compute displacement for this step
			double dx = segmentLength * horizDir.x;
			double dy = segmentLength * horizDir.y;
			double dz = (currentVz * dt) + (0.5 * drop_rateZ * dt * dt);

			vector3 nextPos = (
				   currentPos.x + dx + offForward, 
                   currentPos.y + dy + offSide, 
                   currentPos.z + dz + offZ);

			double segYaw = VectorAngle(dx, dy);
			double segPitch = -atan2(dz, segmentLength); 
			
	//		if (dx < 0) segYaw += 180;


			vector3 predictedEnd = (currentPos.x + dx, currentPos.y + dy, currentPos.z + dz);
			// **Spawn laser at the correct position and angle**
			FLineTraceData segTrace;
/* 	bool segResult = Line3d.LineTraceVisual(
				projectil,      // Source actor
				segYaw,         // Yaw angle
				segmentLength,  // Distance per segment
				segPitch,       // Pitch angle
				TRF_THRUACTORS,
 				offZ,              // Height offset
				offForward,     // Forward offset
				offSide,         // Side offset
				data: segTrace,
				LineClassName: LineType,
				TimeToLive: 60,
				TimeToCycle: 0,
				MarkerClassName: "Marker3d"
			);  */


			
 	bool segResult = projectil.LineTrace(
				segYaw,         // Yaw angle
				segmentLength,  // Distance per segment
				segPitch,       // Pitch angle
				TRF_THRUACTORS,
 				offZ,              // Height offset
				offForward,     // Forward offset
				offSide,         // Side offset
				data: segTrace
			);
 
 



			if (segResult && segTrace.HitActor != null)
			{
				Actor hitActor = segTrace.HitActor;

				// **Ignore self-hit**
				if (hitActor == projectil)
				{
					//Console.Printf("\cbSkipping self-hit.");
					continue;  // Skip to the next iteration
				}
				
				
				if(segTrace.TRACE_HitCeiling || segTrace.TRACE_HitWall)
				{
				
				//Console.Printf("Laser blocked at (%.1f, %.1f, %.1f)", currentPos.x, currentPos.y, currentPos.z);
				return false;	
				
				}
			}
			
			

				vector3 targetPos = arcTarget.pos;
				double dx_target = segTrace.HitLocation.x - targetPos.x;
				double dy_target = segTrace.HitLocation.y - targetPos.y;
				double distToTarget = sqrt(dx_target * dx_target + dy_target * dy_target);
				double detection_tolerance = arcTarget.radius + 2* segmentLength;
				
			//	Console.Printf("\cdHitLocation is %.2f units from target (target radius = %.2f), tolerance: %.2f", distToTarget, self.target.radius, detection_tolerance);
				
				if (distToTarget <= arcTarget.radius + 2* segmentLength)
				{
			//		Console.Printf("\ch Target is HIT");
					return true;
			//		segResult = false;  // Override the hit; treat it as if nothing obstructed this segment.
				}

				
				


/* 			Console.Printf("Laser %d: Start=(%.1f,%.1f,%.1f) End=(%.1f,%.1f,%.1f) Yaw=%.2f Pitch=%.2f",
					   int(totalHoriz / segmentLength),
					   currentPos.x, currentPos.y, currentPos.z,
					   nextPos.x, nextPos.y, nextPos.z,
					   segYaw, segPitch); */

/* 			Console.Printf("Step %d -> horizDir: (%.3f, %.3f), dx: %.3f, dy: %.3f, segYaw: %.2f",
               int(totalHoriz / segmentLength),
               horizDir.x, horizDir.y, dx, dy, segYaw); */

			if (!segResult) // No hit, use predictedEnd
			{
				vector3 hitVector = predictedEnd;  
				offZ = segTrace.HitLocation.z - currentPos.z;
				offForward += (hitVector.x - currentPos.x) * horizDir.x;
				offForward += (hitVector.y - currentPos.y) * horizDir.y;
				double perpX = -horizDir.y;
				double perpY = horizDir.x;
				offSide += (hitVector.x - currentPos.x) * perpX;
				offSide += (hitVector.y - currentPos.y) * perpY;
				
		//		Console.Printf("Offsets -> Forward: %.3f, Side: %.3f, Z: %.3f", offForward, offSide, offZ);

			}


			else
			{

			//	Console.Printf("\caArc blocked at segment starting at (%.1f, %.1f, %.1f)", currentPos.x, currentPos.y, currentPos.z);
				return false;
			}

			totalHoriz += segmentLength;

			// **Update vertical velocity for gravity**
			currentVz += drop_rateZ * dt;
			
			

		}

		return true;  // If all lasers were fired successfully
	}

	
	
}