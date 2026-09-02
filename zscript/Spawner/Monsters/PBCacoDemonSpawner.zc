Class PBCacoDemonSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_CacoSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_CacoSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_CacoSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_CacoSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_CacoSpawner_T1");
			Stop;
	}
}

Class PB_CacoSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_cacodemon_override";
		dropitem "PB_Cacodemon",255,1;
	}
}

Class PB_CacoSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_CacoSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_cacodemon_override";
		dropitem "PB_InfernalCaco",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_InfernalCaco" && pb_cacodemon_filter & DisablePB_InfernalCaco)
			return false;
		return true;
	}
}

Class PB_CacoSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_CacoSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_cacodemon_override";
		dropitem "PB_Afrit",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Afrit" && pb_cacodemon_filter & DisablePB_Afrit)
			return false;
		return true;
	}
}

Class PB_CacoSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_CacoSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_cacodemon_override";
		dropitem "PB_Afrit",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Afrit" && pb_cacodemon_filter & DisablePB_Afrit)
			return false;
		return true;
	}
}

Class PB_CacoSpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_cacodemon_override";
		dropitem "PB_Cacodemon",255,49;
		dropitem "PB_InfernalCaco",255,35;
		dropitem "PB_Afrit",255,16;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_InfernalCaco" && pb_cacodemon_filter & DisablePB_InfernalCaco)
			return false;
		if(toSpawn == "PB_Afrit" && pb_cacodemon_filter & DisablePB_Afrit)
			return false;
		return true;
	}
}
