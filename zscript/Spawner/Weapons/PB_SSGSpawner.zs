Class PBSSGSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_SSGSpawnerDW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_SSGSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_SSGSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_SSGSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_SSGSpawnerT1");
			Stop;
	}
}

class PB_SSGSpawnerT1 : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_SSG', 255, 1;
	}
}

class PB_SSGSpawnerT2 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_SSGSpawnerT1';
		DropItem 'PB_SSG', 255, 1;
	}
}

class PB_SSGSpawnerT3 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_SSGSpawnerT2';
		DropItem 'PB_QuadSG', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_QuadSG" && pb_ssg_filter & DisablePB_QuadSG)
			return false;
		return true;
	}
}

class PB_SSGSpawnerT4 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_SSGSpawnerT3';
		DropItem 'PB_QuadSG', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_QuadSG" && pb_ssg_filter & DisablePB_QuadSG)
			return false;
		return true;
	}
}

class PB_SSGSpawnerDW : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_SSG', 255, 7;
		DropItem 'PB_QuadSG', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_QuadSG" && pb_ssg_filter & DisablePB_QuadSG)
			return false;
		return true;
	}
}
