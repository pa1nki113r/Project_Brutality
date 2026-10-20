Class PB_Elemental : PB_Monster{
	Array<PB_LSoul> LostSouls;
	int deployedSouls;
	int PESoulStorage;
	float soul_orbit_radius;
	//soulOrbitRadius
	int user_ang1;
	string LSFXType;
	class<actor> LSType;
	property LSType : LSType;
	const angleOffset = 30;
	const maxLSOrbiting = 6;
	const user_maxradius = 60;
	const orbitheightoffset = 10;
	const orbitforwardoffset = 3;
	const orbitsideoffset = 0;
	float orbitSpeed;
	float orbitFactor;
	override void PostBeginPlay(){
		orbitSpeed = 1;
		orbitFactor = 7.5;
		//soul_orbit_radius = 0;
		//if(LSFXType.Length() < 1){SetLSFXType();}
		if(!LSType){SetLSType();}
		//deployedSouls = 3;//random(3,6);
		//PB_DeploySouls(3,LSType.GetClassName());
		Super.PostBeginPlay();
	}
	int GetDeployedSouls(){
		LostSouls.ShrinkToFit();
		return LostSouls.Size();
	}
	void PB_PrepareSoul(){
		if(LostSouls.Size() > 0){
			PB_LSoul soulToPrepare = LostSouls[LostSouls.Size()-1];
			ReleaseSoul(soulToPrepare);
			soulToPrepare.Destroy();
			if(soulToPrepare){
				soulToPrepare.A_Die();
			}
			PESoulStorage += 1;
		}
	}
	bool PB_ExpendSoul(int expenditure = 1){
		PESoulStorage -= expenditure;
		if(PESoulStorage < 0){
			PESoulStorage += expenditure;
			return false;
		}else{return true;}
	}//PESoulStorage
	void ReleaseSoul(actor soul){
		let PBSoul = PB_LSoul(soul);
		if( LostSouls.Size() > 0 && LostSouls.Find(PBSoul) != LostSouls.Size() ){
			LostSouls.Delete(LostSouls.Find(PBSoul));
			LostSouls.ShrinkToFit();
		}
	}
	void CheckSoulHealth(actor soul){
		let PBSoul = PB_LSoul(soul);
		if( LostSouls.Size() > 0 && LostSouls.Find(PBSoul) != LostSouls.Size() ){
			LostSouls.Delete(LostSouls.Find(PBSoul));
			LostSouls.ShrinkToFit();
		}
	}
	void SetLSFXType(){
		if(self.GetClassName() == "PB_SufferingElemental"){
			LSFXType = "PB_PhantasmOrbitActor";
		}
		if(self.GetClassName() == "PB_PainElemental"){
			LSFXType = "PB_LSOrbitActor";
		}
	}
	void setLSType(){
		if(self.GetClassName() == "PB_SufferingElemental"){
			LSType = "PB_Phantasm";
		}
		if(self.GetClassName() == "PB_PainElemental"){
			LSType = "PB_LostSoul";
		}
	}
	override bool CanCollideWith(Actor other, bool passive){
		let otherActor = PB_LSoul(other);
		if( otherActor && LostSouls.Find(otherActor) != LostSouls.Size() ){return false;}
		return super.CanCollideWith(other, passive);
	}
	void PB_DeploySouls(int amount = 3, int maxAmount = maxLSOrbiting, string LSToDeploy = ""){
		//deployedSouls += amount;soul_orbit_radius = 0;
		if(!(LSToDeploy.Length() > 0)){LSToDeploy = LSType.GetClassName();}
		//soul_orbit_radius = 0;
		for(int i = 0; i < amount && GetDeployedSouls() < maxAmount; i++){
			actor a; bool b;
			[b, a] = A_SpawnItemEx(LSToDeploy,5,0,orbitheightoffset,0,0,0,0,SXF_NOCHECKPOSITION|SXF_SETMASTER);
			let deployedSoul = PB_LSoul(a);
			if(deployedSoul){
				LostSouls.push(deployedSoul);
				deployedSoul.bFRIENDLY = bFRIENDLY;
			}
		}
		
	}
	/*
	override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath){
		super.Die(source, inflictor, dmgflags, MeansOfDeath);
	}
	*/
	void PB_PainShootSkull(Class<Actor> spawntype, double angle, int flags = 0, int limit = -1)
	{
		// Don't spawn if we get massacred.
		if (DamageType == 'Massacre') return;

		if (spawntype == null) spawntype = "LostSoul";

		// [RH] check to make sure it's not too close to the ceiling
		if (pos.z + height + 8 > ceilingz)
		{
			if (bFloat)
			{
				Vel.Z -= 2;
				bInFloat = true;
				bVFriction = true;
			}
			return;
		}

		// [RH] make this optional
		if (limit < 0 && (Level.compatflags & COMPATF_LIMITPAIN))
			limit = 21;

		if (limit > 0)
		{
			// count total number of skulls currently on the level
			// if there are already 21 skulls on the level, don't spit another one
			int count = limit;
			ThinkerIterator it = ThinkerIterator.Create(spawntype);
			Thinker othink;

			while ( (othink = it.Next ()) )
			{
				if (--count == 0)
					return;
			}
		}

		// okay, there's room for another one
		double otherradius = GetDefaultByType(spawntype).radius;
		double prestep = 4 + (radius + otherradius) * 1.5;

		Vector2 move = AngleToVector(angle, prestep);
		Vector3 spawnpos = pos + (0,0,8);
		Vector3 destpos = spawnpos + move;

		Actor other = Spawn(spawntype, spawnpos, ALLOW_REPLACE);

		// Now check if the spawn is legal. Unlike Boom's hopeless attempt at fixing it, let's do it the same way
		// P_XYMovement solves the line skipping: Spawn the Lost Soul near the PE's center and then use multiple
		// smaller steps to get it to its intended position. This will also result in proper clipping, but
		// it will avoid all the problems of the Boom method, which checked too many lines that weren't even touched
		// and despite some adjustments never worked with portals.

		if (other != null)
		{
			double maxmove = other.radius - 1;

			if (maxmove <= 0) maxmove = 16;

			double xspeed = abs(move.X);
			double yspeed = abs(move.Y);

			int steps = 1;

			if (xspeed > yspeed)
			{
				if (xspeed > maxmove)
				{
					steps = int(1 + xspeed / maxmove);
				}
			}
			else
			{
				if (yspeed > maxmove)
				{
					steps = int(1 + yspeed / maxmove);
				}
			}

			Vector2 stepmove = move / steps;
			bool savedsolid = bSolid;
			bool savednoteleport = other.bNoTeleport;
			
			// make the PE nonsolid for the check and the LS non-teleporting so that P_TryMove doesn't do unwanted things.
			bSolid = false;
			other.bNoTeleport = true;
			FCheckPosition tm;
			for (int i = 0; i < steps; i++)
			{
				Vector2 ptry = other.pos.xy + stepmove;
				double oldangle = other.angle;
				bool DontDestroy = other.TryMove(ptry, 0);
				if (!DontDestroy)
				{
					// kill it immediately
					other.ClearCounters();
					other.DamageMobj(self, self, TELEFRAG_DAMAGE, 'None');
					bSolid = savedsolid;
					other.bNoTeleport = savednoteleport;
					return;
				}

				if (other.pos.xy != ptry)
				{
					// If the new position does not match the desired position, the player
					// must have gone through a portal.
					// For that we need to adjust the movement vector for the following steps.
					double anglediff = deltaangle(oldangle, other.angle);

					if (anglediff != 0)
					{
						stepmove = RotateVector(stepmove, anglediff);
					}
				}

			}
			bSolid = savedsolid;
			other.bNoTeleport = savednoteleport;

			// [RH] Lost souls hate the same things as their pain elementals
			other.CopyFriendliness (self, !(flags & PAF_NOTARGET));
			other.master = self;
			if (!(flags & PAF_NOSKULLATTACK))
			{
				other.A_SkullAttack();
				other.bSKULLFLY;
			}
		}
	}

	void PB_PainDie(class<Actor> spawntype = "LostSoul")
	{
		if (target && IsFriend(target)){ // And I thought you were my friend!
			A_SetFriendly(false);
		}
		A_NoBlocking();
		/*
		PB_PainShootSkull(spawntype, angle + 90);
		PB_PainShootSkull(spawntype, angle + 180);
		PB_PainShootSkull(spawntype, angle + 270);
		*/
		if(LostSouls.Size() > 0){
			for(int i = 0; i < LostSouls.Size(); i++){
				if( LostSouls[i] && LostSouls[i].health > 0 ){
					if(target && LostSouls.Size() > 0){
						LostSouls[i].target = target;
						if(LostSouls[i].ResolveState("Missile")){
							LostSouls[i].SetState(LostSouls[i].ResolveState("Missile"));
						}
					}
					LostSouls[i].master = null;
					LostSouls[i] = null;
				}
			}
		}
	}

	override void Tick(){
		if(orbitSpeed == 0){orbitSpeed = 1;}//GetDefaultByType(self.GetClass()).orbitSpeed;}
		if(orbitFactor == 0){orbitFactor = 7.5;}//GetDefaultByType(self.GetClass()).orbitFactor;}
		Super.Tick();
		LostSouls.ShrinkToFit();
		int circularAngleX = 0;
		int circularAngleY = 0;
		int circularAngleZ = 0;
		if(LostSouls.Size() > 0 && health > 0){
			int numSoulsX = 0;
			int numSoulsY = 0;
			int numSoulsZ = 0;
			for(int i = 0; i < LostSouls.Size(); i++){
				if(i%3 == 0){numSoulsX +=1;}
				if(i%3 == 1){numSoulsY +=1;}
				if(i%3 == 2){numSoulsZ +=1;}
			}
			
			/*
			if( InStateSequence(self.curstate, ResolveState("Missile.Special")) && 
				soul_orbit_radius > 0 )
				{soul_orbit_radius -= 2;
			}else if(soul_orbit_radius < user_maxradius) {soul_orbit_radius += 2;}
			
			if( InStateSequence(self.curstate, ResolveState("DeploySouls")) && 
				orbitSpeed > 0.5 )
				{orbitSpeed -= 0.1;
			}else if(orbitSpeed < 1) {orbitSpeed += 0.1;}
			
			if( InStateSequence(self.curstate, ResolveState("PrepareSoul")) && 
				soul_orbit_radius > 20 )
				{soul_orbit_radius -= 2;
			}else if(soul_orbit_radius < 1) {soul_orbit_radius += 2;}
			*/
			
			for(int i = 0; i < LostSouls.Size(); i++){
				if(numSoulsX > 0){circularAngleX = angleOffset + 360/numSoulsX * i;}
				if(numSoulsY > 0){circularAngleY = angleOffset + 360/numSoulsY * i;}
				if(numSoulsZ > 0){circularAngleZ = angleOffset + 360/numSoulsZ * i;}
				//orbitSpeed = 1;

				if( InStateSequence(self.curstate, ResolveState("Missile.Special")) && 
					LostSouls[i].soulOrbitRadius > 0 )
					{LostSouls[i].soulOrbitRadius -= 2;
				}else if(LostSouls[i].soulOrbitRadius < user_maxradius) {LostSouls[i].soulOrbitRadius += 2;}
				/*
				if( InStateSequence(self.curstate, ResolveState("DeploySouls")) && 
					orbitSpeed > 0.5 )
					{orbitSpeed -= 0.1;
				}else if(orbitSpeed < 1) {orbitSpeed += 0.1;}
				*/
				if( InStateSequence(self.curstate, ResolveState("PrepareSoul")) && 
					LostSouls[i].soulOrbitRadius > 20 )
					{LostSouls[i].soulOrbitRadius -= 2;
				}else if(LostSouls[i].soulOrbitRadius < 1) {LostSouls[i].soulOrbitRadius += 2;}
				/*
				if(i%3 == 0){
					Warp(LostSouls[i],
						orbitforwardoffset + (LostSouls[i].soulOrbitRadius*sin(user_ang1+circularAngleX)) //+ (LostSouls[i].soulOrbitRadius * ( cos(user_ang1*orbitFactor+circularAngleX) * sin(user_ang1*orbitFactor+circularAngleX) * 1.0 ) )//+ LostSouls[i].soulOrbitRadius*atan(user_ang1*orbitFactor+circularAngleX) //
						,
						orbitsideoffset + (LostSouls[i].soulOrbitRadius*cos((LostSouls[i].soulOrbitRadius*cos(user_ang1+circularAngleX))*orbitFactor+circularAngleX))
						,
						orbitheightoffset + (LostSouls[i].soulOrbitRadius*cos(LostSouls[i].soulOrbitRadius*sin(user_ang1+circularAngleX)*orbitFactor+circularAngleX))
						,
						0,WARPF_MOVEPTR|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
				}
				if(i%3 == 1){
					Warp(LostSouls[i],
						orbitforwardoffset + (LostSouls[i].soulOrbitRadius*sin((LostSouls[i].soulOrbitRadius*sin(user_ang1+circularAngleY))*orbitFactor+circularAngleY))
						,
						orbitsideoffset + (LostSouls[i].soulOrbitRadius*cos(user_ang1+circularAngleY)) //+ (LostSouls[i].soulOrbitRadius * ( cos(user_ang1*orbitFactor+circularAngleY) * sin(user_ang1*orbitFactor+circularAngleY) * 1.0 ) )//+ LostSouls[i].soulOrbitRadius*atan(user_ang1*orbitFactor+circularAngleY) //
						,
						orbitheightoffset + (LostSouls[i].soulOrbitRadius*cos(user_ang1*orbitFactor+circularAngleY))
						,
						0,WARPF_MOVEPTR|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
				}
				if(i%3 == 2){
					Warp(LostSouls[i],
						orbitforwardoffset + (LostSouls[i].soulOrbitRadius*sin(user_ang1*orbitFactor+circularAngleZ))
						,
						orbitsideoffset + (LostSouls[i].soulOrbitRadius*cos(user_ang1*orbitFactor+circularAngleZ))
						,
						orbitheightoffset //+ (LostSouls[i].soulOrbitRadius * ( cos(user_ang1*orbitFactor+circularAngleZ) * sin(user_ang1*orbitFactor+circularAngleZ) * 1.0 ) )//+ (LostSouls[i].soulOrbitRadius*atan(user_ang1*orbitFactor+circularAngleZ)) //
						,
						0,WARPF_MOVEPTR|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
				}
				*/
				
				if(i%3 == 0){
					Warp(LostSouls[i],
						orbitforwardoffset //+ (LostSouls[i].soulOrbitRadius*sin(user_ang1*orbitFactor+circularAngleX)) //+ (LostSouls[i].soulOrbitRadius * ( cos(user_ang1*orbitFactor+circularAngleX) * sin(user_ang1*orbitFactor+circularAngleX) * 1.0 ) )//+ LostSouls[i].soulOrbitRadius*atan(user_ang1*orbitFactor+circularAngleX) //
						,
						orbitsideoffset + (LostSouls[i].soulOrbitRadius*sin(user_ang1*orbitFactor+circularAngleX))
						,
						orbitheightoffset + (LostSouls[i].soulOrbitRadius*cos(user_ang1*orbitFactor+circularAngleX))
						,
						0,WARPF_MOVEPTR|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
				}
				if(i%3 == 1){
					Warp(LostSouls[i],
						orbitforwardoffset + (LostSouls[i].soulOrbitRadius*sin(user_ang1*orbitFactor+circularAngleY))
						,
						orbitsideoffset //+ (LostSouls[i].soulOrbitRadius*sin(user_ang1*orbitFactor+circularAngleX)) //+ (LostSouls[i].soulOrbitRadius * ( cos(user_ang1*orbitFactor+circularAngleY) * sin(user_ang1*orbitFactor+circularAngleY) * 1.0 ) )//+ LostSouls[i].soulOrbitRadius*atan(user_ang1*orbitFactor+circularAngleY) //
						,
						orbitheightoffset + (LostSouls[i].soulOrbitRadius*cos(user_ang1*orbitFactor+circularAngleY))
						,
						0,WARPF_MOVEPTR|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
				}
				if(i%3 == 2){
					Warp(LostSouls[i],
						orbitforwardoffset + (LostSouls[i].soulOrbitRadius*sin(user_ang1*orbitFactor+circularAngleZ))
						,
						orbitsideoffset + (LostSouls[i].soulOrbitRadius*cos(user_ang1*orbitFactor+circularAngleZ))
						,
						orbitheightoffset //+ (LostSouls[i].soulOrbitRadius*sin(user_ang1*orbitFactor+circularAngleX)) //+ (LostSouls[i].soulOrbitRadius * ( cos(user_ang1*orbitFactor+circularAngleZ) * sin(user_ang1*orbitFactor+circularAngleZ) * 1.0 ) )//+ (LostSouls[i].soulOrbitRadius*atan(user_ang1*orbitFactor+circularAngleZ)) //
						,
						0,WARPF_MOVEPTR|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
				}
				
			}
			user_ang1 += orbitSpeed;
			//if(user_ang1%360 == 0){user_ang1 = 0;}
		}
	}
}
//===========================================================================
//
// Pain Elemental Explosive Lost Souls
//
//===========================================================================

Class LaunchedLostSoul : Actor{
	int user_ang1;
	int user_effectang1;
	int user_radius1;
	Default{
	//Game Doom
	//SpawnID 127;
	Radius 13;
	Height 10;
	Speed 30;
	Damage 10;
	Health 20;
	scale 1.0;
	Projectile;
	+RANDOMIZE
	+DEHEXPLOSION
	+ROCKETTRAIL
	+ROLLSPRITE
	+ROLLCENTER
	+SEEKERMISSILE
	//RenderStyle "Add";
	RenderStyle "Normal";
	//SeeSound "weapons/rocklf";
	DeathSound "skull/death";
	Obituary "$OB_MPROCKET";
	SeeSound "skull/melee";
	AttackSound "skull/melee";
	PainSound "skull/pain";
	DeathSound "LSOD";
	ActiveSound "skull/active";
	Obituary "$OB_SKULL";
	}
	override bool CanCollideWith(Actor other, bool passive){
		let otherActor = PB_LSoul(other);
		if( otherActor ){
			if(otherActor.isOrbiting()) return false;
		}
		return super.CanCollideWith(other, passive);
	}
	States{
	Spawn:
		LSOL B 1 BRIGHT {
			user_radius1 = 26;
			A_SpawnItem("RedFlareMedium", 0, 24);
			A_SetRoll(user_ang1*7.5);
			user_ang1 = user_ang1 + 3;
			//A_SetUserVar("user_effectang1",user_effectang1-3);
			A_SeekerMissile(10,10);
			for(int i = 0; i<2; i++){
				A_SpawnProjectile("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
				A_SpawnItemEx("SoulTrails",0,(user_radius1*sin(-user_ang1*(7.5)+30)),(user_radius1*cos(-user_ang1*(7.5)+30))+height/2,0,0,0,0,0,0);
				A_SpawnItemEx("SoulTrails",0,(user_radius1*sin(-user_ang1*(7.5)+150)),(user_radius1*cos(-user_ang1*(7.5)+150))+height/2,0,0,0,0,0,0);
				A_SpawnItemEx("SoulTrails",0,(user_radius1*sin(-user_ang1*(7.5)+270)),(user_radius1*cos(-user_ang1*(7.5)+270))+height/2,0,0,0,0,0,0);
			}
		}
		Loop;
	Death:
		EXPL AAAAA 0 A_SpawnProjectile("FireBallExplosionFlamesMedium", 32, 0, random (0, 360), 2, random (0, 360));
		TNT1 AAAA 0 {
			A_SpawnProjectile("SmallLSPart1", 0, 0, random (0, 360), 2, random (0, 360));
			A_SpawnProjectile("SmallLSPart3", 0, 0, random (0, 360), 2, random (0, 360));
			A_SpawnProjectile("PlasmaSmoke", 32, 0, random (0, 360), 2, random (0, 360));
		}
		TNT1 AAA 0 {
			A_SpawnProjectile("CoolAndNewFlameTrailsLong", 12, 0, random (0, 360), 2, random (0, 160));
			A_SpawnProjectile("LSpart1", 42, 0, random (0, 360), 2, random (0, 160));
			A_SpawnProjectile ("ExplosionSmoke", 0, 0, random (0, 360), 2, random (0, 360));
		}
		EXPL AA 0 {
			A_SpawnItem("ExplosionParticleSpawner");
			A_SpawnProjectile("LSpart2", 42, 0, random (0, 360), 2, random (0, 160));
		}
		TNT1 A 0 {
			A_Scream;
			A_SpawnItemEx("ExplosionFlareSpawner",0,0,32,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_SpawnProjectile("LSpart3", 42, 0, random (0, 360), 2, random (0, 160));
			A_StartSound("lesserExplosion",CHAN_AUTO);
			Radius_Quake (2, 54, 0, 15, 0);
			A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_Explode(7, 120, 1);
			A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_SpawnItemEx("NewRocketExploFX_Small", 0, 0, 0, 0, 0, 0, 0, 128);
			bSHOOTABLE = false;
		}
		Stop;
	}
}
Class LaunchedPhantasm : LaunchedLostSoul{
	Default{
		Damagetype "GreenFire";
		SeeSound "phantasm/attack";
		AttackSound "phantasm/attack";
		PainSound "skull/pain";
		DeathSound "LSOD";
		ActiveSound "demon/active";
	}
	States{
	Spawn:
		STLK B 1 BRIGHT {
			user_radius1 = 26;
			A_SpawnItem("GreenFlareSmall", 0, 24);
			A_SetRoll(user_ang1*7.5);
			user_ang1 = user_ang1 + 3;
			A_SeekerMissile(10,10);
			for(int i = 0; i<2; i++){
				A_SpawnProjectile("PhantasmTrails", 24, 0, random (0, 360), 2, random (0, 160));
				A_SpawnItemEx("PhantasmTrails",0,(user_radius1*sin(-user_ang1*(7.5)+30)),(user_radius1*cos(-user_ang1*(7.5)+30))+height/2,0,0,0,0,0,0);
				A_SpawnItemEx("PhantasmTrails",0,(user_radius1*sin(-user_ang1*(7.5)+150)),(user_radius1*cos(-user_ang1*(7.5)+150))+height/2,0,0,0,0,0,0);
				A_SpawnItemEx("PhantasmTrails",0,(user_radius1*sin(-user_ang1*(7.5)+270)),(user_radius1*cos(-user_ang1*(7.5)+270))+height/2,0,0,0,0,0,0);
			}
		}
		Loop;
	Death:
		EXPL AAAAA 0 A_SpawnProjectile("SmallGreenFlameTrails", 32, 0, random (0, 360), 2, random (0, 360));
		TNT1 AAAA 0 {
			A_SpawnProjectile("SmallPhantasmPart1", 0, 0, random (0, 360), 2, random (0, 360));
			A_SpawnProjectile("SmallPhantasmPart3", 0, 0, random (0, 360), 2, random (0, 360));
			A_SpawnItem("GreenFlare",0,0);
			A_SpawnProjectile("PlasmaSmoke", 32, 0, random (0, 360), 2, random (0, 360));
		}
		TNT1 AAA 0 {
			A_SpawnProjectile("RealFlameTrailsGreen", 12, 0, random (0, 360), 2, random (0, 160));
			A_SpawnProjectile("Phantasmpart1", 42, 0, random (0, 360), 2, random (0, 160));
			A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 0, 0, 0, 0, 128);
		}
		TNT1 AA 0 {
			A_SpawnProjectile("PhantasmHorn", 42, 0, random (0, 360), 2, random (0, 160));
			A_SpawnProjectile("Phantasmpart2", 42, 0, random (0, 360), 2, random (0, 160));
			A_SpawnItem("ExplosionParticleSpawner");
		}
		TNT1 A 0 {
			A_Scream;
			A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 0, 0, 0, 0, 128);
			A_SpawnProjectile("GreenExplosionFire", 12, 0, random (0, 360), 2, random (0, 160));
			A_SpawnProjectile("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
			A_StartSound("BFGALPP");
			A_SpawnItem("GreenExplosionMushroom",0,6);
			A_Explode(3, 64, XF_HURTSOURCE | XF_NOTMISSILE, false, 32);
			A_SpawnProjectile("Phantasmpart3", 42, 0, random (0, 360), 2, random (0, 160));
			A_SpawnItemEx("BFGAltExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_SpawnItem("BFGAltShockWave",0,0);
			A_StartSound("lesserExplosion",CHAN_AUTO);
			Radius_Quake(2, 54, 0, 15, 0);
			A_SpawnProjectile ("ExplosionSmoke", 0, 0, random (0, 360), 2, random (0, 360));
			A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_Explode(7, 120, 1);
			A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			A_SpawnItemEx("NewRocketExploFX_Small", 0, 0, 0, 0, 0, 0, 0, 128);
			bSHOOTABLE = false;
		}
		stop;
	}
}