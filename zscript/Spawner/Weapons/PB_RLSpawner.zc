Class PBRocketLauncherSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_RLSpawnerDW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_RLSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_RLSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_RLSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_RLSpawnerT1");
			Stop;
	}
}

class PB_RLSpawnerT1 : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_RocketLauncher', 255, 1;
	}
}

class PB_RLSpawnerT2 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_RLSpawnerT1';
		DropItem 'PB_RocketLauncher', 255, 1;
	}
}

class PB_RLSpawnerT3 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_RLSpawnerT2';
		DropItem 'PB_SuperGL', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SuperGL" && pb_rocketlauncher_filter & DisablePB_SuperGL)
			return false;
		return true;
	}
}

class PB_RLSpawnerT4 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_RLSpawnerT3';
		DropItem 'PB_SuperGL', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SuperGL" && pb_rocketlauncher_filter & DisablePB_SuperGL)
			return false;
		return true;
	}
}

class PB_RLSpawnerDW : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_RocketLauncher', 255, 57;
		DropItem 'PB_SuperGL', 255, 43;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SuperGL" && pb_rocketlauncher_filter & DisablePB_SuperGL)
			return false;
		return true;
	}
}
