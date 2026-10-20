Class PB_LSoul : PB_Monster{
	Default{
		-COUNTKILL;
	}
	float soulOrbitRadius;
	bool isOrbiting(){
		if(master && master.health > 0 && master is "PB_Elemental"){
			let painptr = PB_Elemental(master);
			if(painptr && painptr.LostSouls.Find(self) != painptr.LostSouls.Size()){
				return true;
			}
		}
		return false;
	}
	Override void Tick(){
		if( isOrbiting() && health > 0 && 
			(!InStateSequence(self.curstate, ResolveState("Idle")) || !InStateSequence(self.curstate, ResolveState("Pain")))
			){
			SetState(ResolveState("Idle"));
		}
		if(!bSOLID && !bSHOOTABLE && health < 1){
			A_Die();
		}
		if(health > 0 && !InStateSequence(self.curstate, ResolveState("Pain"))){
			A_SetRoll(0, SPF_INTERPOLATE);
		}
		Super.Tick();
	}
	Override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath){
		if(isOrbiting() && master && master is "PB_Elemental"){
			let painMaster = PB_Elemental(master);
			if(painMaster){painMaster.ReleaseSoul(self);}
		}
		super.Die(source, inflictor, dmgflags, MeansOfDeath);
	}
	override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle){
		if(isOrbiting()){damage *= 1/2;}
		return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}
	override bool CanCollideWith(Actor other, bool passive){
		let otherActor = PB_LSoul(other);
		if( otherActor && 
			(bSKULLFLY && otherActor.isOrbiting() || 
			isOrbiting() && otherActor.bSKULLFLY) && 
			otherActor.master && master && otherActor.master == master ){
			return false;
		}
		return super.CanCollideWith(other, passive);
	}
	void PB_SkullAttack(double skullspeed = DEFSKULLSPEED){
		if (target == null) return;
		if (skullspeed <= 0) skullspeed = DEFSKULLSPEED;
		bSkullfly = true;
		A_StartSound(AttackSound, CHAN_VOICE);
		A_FaceTarget();
		VelFromAngle(skullspeed);
		Vel.Z = (target.pos.Z + target.Height/2 - pos.Z) / DistanceBySpeed(target, skullspeed);
	}
}
