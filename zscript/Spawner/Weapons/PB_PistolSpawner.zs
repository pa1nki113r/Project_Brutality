Class PBPistolSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_PistolSpawnerDW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_PistolSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_PistolSpawnerT3");
			Stop;
		Tier2:	
			TNT1 A 0 PB_SpawnerSpawn("PB_PistolSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_PistolSpawnerT1");
			Stop;
	}
}

class PB_PistolSpawnerT1 : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_Pistol', 255, 1;
	}
}

class PB_PistolSpawnerT2 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_PistolSpawnerT1';
		DropItem 'PB_Revolver', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Revolver" && pb_pistol_filter & DisablePB_Revolver)
			return false;
		return true;
	}
}

class PB_PistolSpawnerT3 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_PistolSpawnerT2';
		DropItem 'PB_SMG', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SMG" && pb_pistol_filter & DisablePB_SMG)
			return false;
		return true;
	}
}

class PB_PistolSpawnerT4 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_PistolSpawnerT3';
		DropItem 'PB_Deagle', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Deagle" && pb_pistol_filter & DisablePB_Deagle)
			return false;
		return true;
	}
}

class PB_PistolSpawnerDW : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_Pistol', 255, 34;
		DropItem 'PB_Revolver', 255, 20;
		DropItem 'PB_SMG', 255, 33;
		DropItem 'PB_Deagle', 255, 13;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Revolver" && pb_pistol_filter & DisablePB_Revolver)
			return false;
		if(toSpawn == "PB_SMG" && pb_pistol_filter & DisablePB_SMG)
			return false;
		if(toSpawn == "PB_Deagle" && pb_pistol_filter & DisablePB_Deagle)
			return false;
		return true;
	}
}
