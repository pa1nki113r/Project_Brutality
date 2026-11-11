Class PBSpiderMasterMindSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_MasterSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_MasterSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_MasterSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_MasterSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_MasterSpawner_T1");
			Stop;
	}
}

Class PB_MasterSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_mastermind_override";
		dropitem "PB_Mastermind",255,1;
	}
}

Class PB_MasterSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_MasterSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_mastermind_override";
		dropitem "PB_Demolisher",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Demolisher" && pb_mastermind_filter & DisablePB_Demolisher)
			return false;
		return true;
	}
}

Class PB_MasterSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_MasterSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_mastermind_override";
		dropitem "PB_Juggernaut",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Juggernaut" && pb_mastermind_filter & DisablePB_Juggernaut)
			return false;
		return true;
	}
}

Class PB_MasterSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_MasterSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_mastermind_override";
		dropitem "PB_Juggernaut",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Juggernaut" && pb_mastermind_filter & DisablePB_Juggernaut)
			return false;
		return true;
	}
}

Class PB_MasterSpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_mastermind_override";
		dropitem "PB_Mastermind",255,48;
		dropitem "PB_Demolisher",255,27;
		dropitem "PB_Juggernaut",255,25;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Demolisher" && pb_mastermind_filter & DisablePB_Demolisher)
			return false;
		if(toSpawn == "PB_Juggernaut" && pb_mastermind_filter & DisablePB_Juggernaut)
			return false;
		return true;
	}
}
