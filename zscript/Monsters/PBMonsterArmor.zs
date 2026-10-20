class MonsterArmorPickup : BasicArmorPickup{
	//===========================================================================
	//
	// ABasicArmorPickup :: CreateCopy
	//
	//===========================================================================
	int flags;
	FlagDef NATURAL: flags, 0;
	override Inventory CreateCopy (Actor other){
		let copy = BasicArmorPickup(Super.CreateCopy (other));
		copy.SavePercent = SavePercent;
		if(amount){copy.SaveAmount = amount;}
		else{copy.SaveAmount = SaveAmount;}
		copy.MaxAbsorb = MaxAbsorb;
		copy.MaxFullAbsorb = MaxFullAbsorb;
		return copy;
	}
	
	//===========================================================================
	//
	// ABasicArmorPickup :: Use
	//
	// Either gives you new armor or replaces the armor you already have (if
	// the SaveAmount is greater than the amount of armor you own). When the
	// item is auto-activated, it will only be activated if its max amount is 0
	// or if you have no armor active already.
	//
	//===========================================================================

	override bool Use (bool pickup){
		int SaveAmount;
		if(amount){SaveAmount = amount;}
		else{SaveAmount = GetSaveAmount();}
		let armor = BasicArmor(Owner.FindInventory("BasicArmor"));

		// This should really never happen but let's be prepared for a broken inventory.
		if (armor == null){
			if(bNATURAL){armor = MonsterNaturalArmor(Spawn("MonsterNaturalArmor"));}
			else{armor = MonsterArmor(Spawn("MonsterArmor"));}
			armor.BecomeItem ();
			Owner.AddInventory (armor);
		}else{
			// If you already have more armor than this item gives you, you can't
			// use it.
			if (armor.Amount >= SaveAmount + armor.BonusCount){return false;}
			// Don't use it if you're picking it up and already have some.
			if (pickup && armor.Amount > 0 && MaxAmount > 0){return false;}
		}
		armor.SavePercent = clamp(SavePercent, 0, 100) / 100;
		armor.Amount = SaveAmount + armor.BonusCount;
		armor.MaxAmount = SaveAmount;
		armor.Icon = Icon;
		armor.MaxAbsorb = MaxAbsorb;
		armor.MaxFullAbsorb = MaxFullAbsorb;
		armor.ArmorType = GetClassName();
		armor.ActualSaveAmount = SaveAmount;
		MonsterArmorTracker armorTracker;
		if(bNATURAL){
			let armorTracker = MonsterArmorTracker(Spawn("MonsterNaturalArmorTracker"));
			if(armorTracker){
				armorTracker.BecomeItem();
				Owner.AddInventory(armorTracker);
			}
		}else{
			let armorTracker = MonsterArmorTracker(Spawn("MonsterArmorTracker"));
			if(armorTracker){
				armorTracker.BecomeItem();
				Owner.AddInventory(armorTracker);
			}
		}
		//armorTracker.ArmorTracked = armor;
		return true;
	}
}
Class ArmorPercentSetter : Inventory{
	Override Void AttachToOwner(Actor other){
		if(other.FindInventory("BasicArmor",true)){BasicArmor(other.FindInventory("BasicArmor",true)).SavePercent = (clamp(amount, 0, 100) / 100) + 0.01;}
		self.Destroy();
	}
}
Class MonsterArmorTracker : Inventory{
	int flags;
	FlagDef NATURAL: flags, 0;
	Default{
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNCLEARABLE
	}
	//Doesn't work as planned unfortunately
	BasicArmor ArmorTracked;
	Override Void AttachToOwner(Actor other){
		if(!ArmorTracked && other.FindInventory("BasicArmor",true)){
			//A_Log("AttachToOwner");
			//players[0].mo.A_Log("AttachToOwner Setting ArmorTracked");
			ArmorTracked = BasicArmor(other.FindInventory("BasicArmor",true));
		}
		Super.AttachToOwner(other);
	}
	Override Void DoEffect(){
		/*
		if(!ArmorTracked && owner.FindInventory("BasicArmor",true)){
			A_Log("AttachToOwner");
			players[0].mo.A_Log("DoEffect Setting ArmorTracked");
			ArmorTracked = BasicArmor(owner.FindInventory("BasicArmor",true));
		}
		if(!ArmorTracked || (ArmorTracked && ArmorTracked.amount < 1)){
			if(owner){
				A_Log(string.format("The %s's armor has been destroyed!",owner.GetTag()));
				A_ArmorShatter();
			}
			self.Destroy();
		}
		*/
		if(!(owner && owner.FindInventory("BasicArmor",true) && owner.FindInventory("BasicArmor",true).amount > 0)){
			if(owner){
				if(bNATURAL){
					A_Log(string.format("The %s's natural armor has been compromised!",owner.GetTag()));
				}else{
					A_Log(string.format("The %s's armor has been destroyed!",owner.GetTag()));
				}
				//if(owner && bNATURAL){A_ArmorShatter();}
			}
			self.Destroy();
		}
		Super.DoEffect();
	}
	
	virtual void A_ArmorShatter(){
		//if (owner.Vel != (0,0,0) && !bShattering){tics = 3*TICRATE;return;}
		if(!owner)return;
		owner.Vel = (0,0,0);
		owner.A_StartSound("misc/icebreak", CHAN_BODY);
		double oRadius = owner.radius;
		double oHeight = owner.height;
		// [RH] In Hexen, this creates a random number of shards (range [24,56])
		// with no relation to the size of the self shattering. I think it should
		// base the number of shards on the size of the dead thing, so bigger
		// things break up into more shards than smaller things.
		// An actor with radius 20 and height 64 creates ~40 chunks.
		//if(oRadius * oHeight > 100){}
		//oRadius > 48
		//if(oHeight > 56 && oRadius > 24){}
		if(oHeight > 56 && oRadius > 36){
			int numPieces = random(2,6);
			for (int i = 0; i < numPieces; i++){
				double xo = owner.pos.x + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
				double yo = owner.pos.y + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
				double zo = owner.pos.z + (random[FreezeDeathChunks]() * oHeight / 255);
				Actor mo = owner.Spawn("ArmorChunkLarge", Vec3Offset(xo, yo, zo), ALLOW_REPLACE);
				if (mo){
					mo.SetState (mo.SpawnState + random[FreezeDeathChunks](0, 2));
					mo.Vel.X = random2[FreezeDeathChunks]() / 128.;
					mo.Vel.Y = random2[FreezeDeathChunks]() / 128.;
					mo.Vel.Z = (mo.pos.Z - owner.pos.Z) / oHeight * 4;
				}
			}
		}
		///4
		int minChunks = 24/4;
		int numChunks = (max(4, int(oRadius * oHeight)/32))/4;
		int i = Random[FreezeDeathChunks](0, numChunks/4 - 1);
		for (i = max(minChunks, numChunks + i); i >= 0; i--){
			double xo = owner.pos.x + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
			double yo = owner.pos.y + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
			double zo = owner.pos.z + (random[FreezeDeathChunks]() * oHeight / 255);
			Actor mo = owner.Spawn("ArmorChunk", Vec3Offset(xo, yo, zo), ALLOW_REPLACE);
			if (mo){
				mo.SetState (mo.SpawnState + random[FreezeDeathChunks](0, 2));
				mo.Vel.X = random2[FreezeDeathChunks]() / 128.;
				mo.Vel.Y = random2[FreezeDeathChunks]() / 128.;
				//mo.Vel.Z = (mo.pos.Z - owner.pos.Z) / oHeight * 4;
			}
		}
	}
}
Class MonsterNaturalArmorTracker : MonsterArmorTracker{Default{+MonsterArmorTracker.NATURAL}}

Class MonsterArmor : BasicArmor{
	int flags;
	FlagDef NATURAL: flags, 0;
	bool Destroyed;
	override void OnDestroy(){
		if(owner && owner.health > 0){
			A_Log(string.format("The %s's armor has been destroyed!",owner.GetTag()));
		}
	}
	override void DepleteOrDestroy(){
		if(!(owner && owner.FindInventory("BasicArmor",true) && owner.FindInventory("BasicArmor",true).amount > 0)){
			if(owner){
				if(bNATURAL){
					A_Log(string.format("The %s's natural armor has been compromised!",owner.GetTag()));
				}else{
					A_Log(string.format("The %s's armor has been destroyed!",owner.GetTag()));
				}
				if(owner && bNATURAL){A_ArmorShatter();}
			}
			Destroyed = true;
		}
		Super.DepleteOrDestroy();
	}
	override Inventory CreateCopy (Actor other){
		// BasicArmor that is in use is stored in the inventory as BasicArmor.
		// BasicArmor that is in reserve is not.
		let copy = MonsterArmor(Spawn("MonsterArmor"));
		copy.SavePercent = SavePercent != 0 ? SavePercent : 0.33335;	// slightly more than 1/3 to avoid roundoff errors.
		copy.Amount = Amount;
		copy.MaxAmount = MaxAmount;
		copy.Icon = Icon;
		copy.BonusCount = BonusCount;
		copy.ArmorType = ArmorType;
		copy.ActualSaveAmount = ActualSaveAmount;
		GoAwayAndDie();
		return copy;
	}
	override bool HandlePickup (Inventory item)
	{
		if (item.GetClass() == "MonsterArmor")
		{
			// You shouldn't be picking up BasicArmor anyway.
			return true;
		}
		return false;
	}
	virtual void A_ArmorShatter(){
		//if (owner.Vel != (0,0,0) && !bShattering){tics = 3*TICRATE;return;}
		if(!owner)return;
		owner.Vel = (0,0,0);
		owner.A_StartSound("misc/icebreak", CHAN_BODY);
		double oRadius = owner.radius;
		double oHeight = owner.height;
		// [RH] In Hexen, this creates a random number of shards (range [24,56])
		// with no relation to the size of the self shattering. I think it should
		// base the number of shards on the size of the dead thing, so bigger
		// things break up into more shards than smaller things.
		// An actor with radius 20 and height 64 creates ~40 chunks.
		//if(oRadius * oHeight > 100){}
		//oRadius > 48
		//if(oHeight > 56 && oRadius > 24){}
		if(oHeight > 56 && oRadius > 36){
			int numPieces = random(2,6);
			for (int i = 0; i < numPieces; i++){
				double xo = owner.pos.x + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
				double yo = owner.pos.y + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
				double zo = owner.pos.z + (random[FreezeDeathChunks]() * oHeight / 255);
				Actor mo = owner.Spawn("ArmorChunkLarge", Vec3Offset(xo, yo, zo), ALLOW_REPLACE);
				if (mo){
					mo.SetState (mo.SpawnState + random[FreezeDeathChunks](0, 2));
					mo.Vel.X = random2[FreezeDeathChunks]() / 128.;
					mo.Vel.Y = random2[FreezeDeathChunks]() / 128.;
					mo.Vel.Z = (mo.pos.Z - owner.pos.Z) / oHeight * 4;
				}
			}
		}
		///4
		int minChunks = 24/4;
		int numChunks = (max(4, int(oRadius * oHeight)/32))/4;
		int i = Random[FreezeDeathChunks](0, numChunks/4 - 1);
		for (i = max(minChunks, numChunks + i); i >= 0; i--){
			double xo = owner.pos.x + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
			double yo = owner.pos.y + (random[FreezeDeathChunks]() - 128)*oRadius / 128;
			double zo = owner.pos.z + (random[FreezeDeathChunks]() * oHeight / 255);
			Actor mo = owner.Spawn("ArmorChunk", Vec3Offset(xo, yo, zo), ALLOW_REPLACE);
			if (mo){
				mo.SetState (mo.SpawnState + random[FreezeDeathChunks](0, 2));
				mo.Vel.X = random2[FreezeDeathChunks]() / 128.;
				mo.Vel.Y = random2[FreezeDeathChunks]() / 128.;
				//mo.Vel.Z = (mo.pos.Z - owner.pos.Z) / oHeight * 4;
			}
		}
	}
}
Class MonsterNaturalArmor : MonsterArmor{
	Default{+MonsterArmor.NATURAL}
	override Inventory CreateCopy (Actor other){
		// BasicArmor that is in use is stored in the inventory as BasicArmor.
		// BasicArmor that is in reserve is not.
		let copy = MonsterNaturalArmor(Spawn("MonsterNaturalArmor"));
		copy.SavePercent = SavePercent != 0 ? SavePercent : 0.33335;	// slightly more than 1/3 to avoid roundoff errors.
		copy.Amount = Amount;
		copy.MaxAmount = MaxAmount;
		copy.Icon = Icon;
		copy.BonusCount = BonusCount;
		copy.ArmorType = ArmorType;
		copy.ActualSaveAmount = ActualSaveAmount;
		GoAwayAndDie();
		return copy;
	}
}
Class ArmorChunk : Actor{
	Default{
		Radius 3;
		Height 4;
		Mass 5;
		Speed 8;
		Gravity 1.0;
		+BOUNCEONWALLS; +BOUNCEONFLOORS; +ALLOWBOUNCEONACTORS; +BOUNCEAUTOOFF;
		+DROPOFF
		+CANNOTPUSH
		+FLOORCLIP
		+NOTELEPORT
		+NOBLOCKMAP
		+MOVEWITHSECTOR
		+THRUACTORS
	}
	States{
	Spawn:
		TNT1 A 0 NODELAY A_NoBlocking();
		/*
		TNT1 A 0 A_Jump(256,1,2,3,4,5);
		JNK4 A 0 A_Jump(256,"SpawnLoop");
		JNK5 A 0 A_Jump(256,"SpawnLoop");
		JNK6 A 0 A_Jump(256,"SpawnLoop");
		JNK7 A 0 A_Jump(256,"SpawnLoop");
		JNK8 A 0 A_Jump(256,"SpawnLoop");
		*/
		TNT1 A 0 A_Jump(256,1,2,3);
		JNK6 A 0 A_Jump(256,"SpawnLoop");
		JNK7 A 0 A_Jump(256,"SpawnLoop");
		JNK8 A 0 A_Jump(256,"SpawnLoop");
	SpawnLoop:
		#### ABCD 2 A_CheckFloor("Death");
		loop;
	Death:
		#### # 0 A_Die;
		#### # 10 A_SetTics(random(70,133));
		stop;
	}
}
Class ArmorChunkBig : Actor{
	Default{
		Radius 8;
		Height 8;
		Speed 8;
		Mass 1000;
		scale 2.05;
		+BOUNCEONWALLS; +BOUNCEONFLOORS; +ALLOWBOUNCEONACTORS; +BOUNCEAUTOOFF;
		+DROPOFF
		+Missile
	}
	States{
	Spawn:
		TNT1 A 0 NODELAY A_NoBlocking();
	Spawnloop:
		TSHO ABCDEFGH 2;
		loop;
	Death:
		TSHO I 10 A_SetTics(random(70,133));
		stop;
	}
}

Class ArmorChunkLarge : ArmorChunkBig{
	Default{
		Translation "16:47=48:79", "188:191=236:239", "64:79=160:167";
		Scale 1.1;
	}
}