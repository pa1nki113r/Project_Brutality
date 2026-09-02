Class PBChainSawSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_SawSpawnerDW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_SawSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_SawSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_SawSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_SawSpawnerT1");
			Stop;
	}
}

class PB_SawSpawnerT1 : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_Chainsaw', 255, 1;
		DropItem 'PB_Axe', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Axe" && pb_chainsaw_filter & DisablePB_Axe)
			return false;
		return true;
	}
}

class PB_SawSpawnerT2 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_SawSpawnerT1';
		DropItem 'PB_Flamethrower', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Flamethrower" && pb_chainsaw_filter & DisablePB_Flamethrower)
			return false;
		return true;
	}
}

class PB_SawSpawnerT3 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_SawSpawnerT2';
		DropItem 'PB_FlamethrowerUpgrade', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_FlamethrowerUpgrade" && pb_chainsaw_filter & DisablePB_FlamethrowerUpgrade)
			return false;
		return true;
	}
}

class PB_SawSpawnerT4 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_SawSpawnerT3';
		DropItem 'PB_FlamethrowerUpgrade', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_FlamethrowerUpgrade" && pb_chainsaw_filter & DisablePB_FlamethrowerUpgrade)
			return false;
		return true;
	}
}

class PB_SawSpawnerDW : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_Chainsaw', 255, 2;
		DropItem 'PB_Axe', 255, 2;
		DropItem 'PB_Flamethrower', 255, 13;
		DropItem 'PB_FlamethrowerUpgrade', 255, 33;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Axe" && pb_chainsaw_filter & DisablePB_Axe)
			return false;
		if(toSpawn == "PB_Flamethrower" && pb_chainsaw_filter & DisablePB_Flamethrower)
			return false;
		if(toSpawn == "PB_FlamethrowerUpgrade" && pb_chainsaw_filter & DisablePB_FlamethrowerUpgrade)
			return false;
		return true;
	}
}
