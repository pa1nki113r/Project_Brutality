Class PBPESpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_Pa1nSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_Pa1nSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_Pa1nSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_Pa1nSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_Pa1nSpawner_T1");
			Stop;
	}
}

Class PB_Pa1nSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_painelemental_override";
		dropitem "PB_PainElemental",255,1;
	}
}

Class PB_Pa1nSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_Pa1nSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_painelemental_override";
		dropitem "PB_SufferingElemental",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SufferingElemental" && pb_painelemental_filter & DisablePB_SufferingElemental)
			return false;
		return true;
	}
}

Class PB_Pa1nSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_Pa1nSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_painelemental_override";
		dropitem "PB_SufferingElemental",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SufferingElemental" && pb_painelemental_filter & DisablePB_SufferingElemental)
			return false;
		return true;
	}
}

Class PB_Pa1nSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_Pa1nSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_painelemental_override";
		dropitem "PB_SufferingElemental",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SufferingElemental" && pb_painelemental_filter & DisablePB_SufferingElemental)
			return false;
		return true;
	}
}

Class PB_Pa1nSpawner_DW: PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_painelemental_override";
		dropitem "PB_PainElemental",255,1;
		dropitem "PB_SufferingElemental",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SufferingElemental" && pb_painelemental_filter & DisablePB_SufferingElemental)
			return false;
		return true;
	}
}
