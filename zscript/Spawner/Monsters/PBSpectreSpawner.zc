Class PBSpectreSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_SpectreSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_SpectreSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_SpectreSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_SpectreSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_SpectreSpawner_T1");
			Stop;
	}
}

Class PB_SpectreSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_spectre_override";
		dropitem "PB_Spectre",255,1;
	}
}

Class PB_SpectreSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_SpectreSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_spectre_override";
		dropitem "PB_VoidSpectre",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_VoidSpectre" && pb_spectre_filter & DisablePB_VoidSpectre)
			return false;
		return true;
	}
}

Class PB_SpectreSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_SpectreSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_spectre_override";
		dropitem "PB_VoidSpectre",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_VoidSpectre" && pb_spectre_filter & DisablePB_VoidSpectre)
			return false;
		return true;
	}
}

Class PB_SpectreSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_SpectreSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_spectre_override";
		dropitem "PB_VoidSpectre",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_VoidSpectre" && pb_spectre_filter & DisablePB_VoidSpectre)
			return false;
		return true;
	}
}

Class PB_SpectreSpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_spectre_override";
		dropitem "PB_Spectre",255,62;
		dropitem "PB_VoidSpectre",255,38;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_VoidSpectre" && pb_spectre_filter & DisablePB_VoidSpectre)
			return false;
		return true;
	}
}
