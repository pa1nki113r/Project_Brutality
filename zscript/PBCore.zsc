class PBCore play
{
	static int GetWeightedResult(out Array<int> weights, int defRet = 0)
	{
		int sum = 0;
		for (int i = 0; i < weights.Size(); ++i)
		{
			sum += weights[i];
		}

		int rng = random[weightrand](0, sum);
		for (int i = 0; i < weights.Size(); ++i)
		{
			if (rng < weights[i])
			{
				return i;
			}
			rng -= weights[i];
		}
		return defRet;
	}
	
	// [Ace] This and CheckIfExists run a full range thinker so do not call them in ticking methods as it may get expensive.
	// Caution is advised.
	static clearscope bool CheckIfUnique(Actor other)
	{
		ThinkerIterator it = ThinkerIterator.Create(other.GetClass());
		Thinker t = null;
		while (t = it.Next())
		{
			if (t != other)
			{
				return false;
			}
		}
		return true;
	}
	
	static clearscope bool CheckIfExists(class<Actor> cls)
	{
		ThinkerIterator it = ThinkerIterator.Create(cls);
		if (it.Next() != null)
		{
			return true;
		}
		return false;
	}
}

//[j1h0] not sure were this sould be, was going to put it in the mixins zs, but this is actually not a mixin
Class PB_ActorPosInfo play
{
	
	static const string PB_Liquids[] = {
		"WATER","BLOOD","LAVA","SLIME","NUKAGE"
	};
	
	static bool Mobj_isOnLiquid(actor who)
	{
		//if theres nobody to check, nobody cant be standing on liquids, right?
		if(!who)
			return false;
			
		if(who.waterlevel > 0)
			return true;
			
		let terr = who.GetFloorTerrain();
		if(terr.isliquid)
			return true;
		//get the name of the floorpic
		let tx = texman.GetName(who.floorpic);
		for(int i = 0; i < PB_ActorPosInfo.PB_Liquids.size(); i++)
		{
			//iterate through the liquids array and return true if the floorpic name matches with any of the names in the array
			if(tx.indexof(PB_ActorPosInfo.PB_Liquids[i]) != -1)
				return true;
		}
		
		//if everything else fails, just return false
		return false;
	}
}