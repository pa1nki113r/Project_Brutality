Class PBBFGSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_BFGSpawnerDW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_BFGSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_BFGSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_BFGSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_BFGSpawnerT1");
			Stop;
	}
}

class PB_BFGSpawnerT1 : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_BFG9000', 255, 1;
	}
}

class PB_BFGSpawnerT2 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_BFGSpawnerT1';
		DropItem 'PB_BFG9000', 255, 1;
	}
}

class PB_BFGSpawnerT3 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_BFGSpawnerT2';
		DropItem 'PB_Railgun', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Railgun" && pb_bfg_filter & DisablePB_Railgun)
			return false;
		return true;
	}
}

class PB_BFGSpawnerT4 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_BFGSpawnerT3';
		DropItem 'PB_Unmaker', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Unmaker" && pb_bfg_filter & DisablePB_Unmaker)
			return false;
		return true;
	}
}

class PB_BFGSpawnerDW : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_BFG9000', 255, 32;
		DropItem 'PB_Railgun', 255, 15;
		DropItem 'PB_Unmaker', 255, 3;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Railgun" && pb_bfg_filter & DisablePB_Railgun)
			return false;
		if(toSpawn == "PB_Unmaker" && pb_bfg_filter & DisablePB_Unmaker)
			return false;
		return true;
	}
}
