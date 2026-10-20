Class PBPinkySpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_PinkySpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_PinkySpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_PinkySpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_PinkySpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_PinkySpawner_T1");
			Stop;
	}
}

Class PB_PinkySpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_pinky_override";
		dropitem "PB_Demon",255,1;
	}
}

Class PB_PinkySpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_PinkySpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_pinky_override";
		dropitem "PB_MeanDemon",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_MeanDemon" && pb_pinky_filter & DisablePB_MeanDemon)
			return false;
		return true;
	}
}

Class PB_PinkySpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_PinkySpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_pinky_override";
		dropitem "PB_MechDemon",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_MechDemon" && pb_pinky_filter & DisablePB_MechDemon)
			return false;
		return true;
	}
}

Class PB_PinkySpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_PinkySpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_pinky_override";
		dropitem "PB_MechDemon",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_MechDemon" && pb_pinky_filter & DisablePB_MechDemon)
			return false;
		return true;
	}
}

Class PB_PinkySpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_pinky_override";
		dropitem "PB_Demon",255,42;
		dropitem "PB_MeanDemon",255,23;
		dropitem "PB_MechDemon",255,35;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_MeanDemon" && pb_pinky_filter & DisablePB_MeanDemon)
			return false;
		if(toSpawn == "PB_MechDemon" && pb_pinky_filter & DisablePB_MechDemon)
			return false;
		return true;
	}
}
