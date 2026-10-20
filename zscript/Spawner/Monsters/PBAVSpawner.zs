Class PBArchVileSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_ArchiSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_ArchiSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_ArchiSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_ArchiSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_ArchiSpawner_T1");
			Stop;
	}
}

Class PB_ArchiSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_archvile_override";
		dropitem "PB_Archvile",255,1;
	}
}

Class PB_ArchiSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ArchiSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_archvile_override";
		dropitem "PB_Hellion",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Hellion" && pb_archvile_filter & DisablePB_Hellion)
			return false;
		return true;
	}
}

Class PB_ArchiSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ArchiSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_archvile_override";
		dropitem "PB_Hellion",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Hellion" && pb_archvile_filter & DisablePB_Hellion)
			return false;
		return true;
	}
}

Class PB_ArchiSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ArchiSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_archvile_override";
		dropitem "PB_Hellion",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Hellion" && pb_archvile_filter & DisablePB_Hellion)
			return false;
		return true;
	}
}

Class PB_ArchiSpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_archvile_override";
		dropitem "PB_Archvile",255,1;
		dropitem "PB_Hellion",255,3;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Hellion" && pb_archvile_filter & DisablePB_Hellion)
			return false;
		return true;
	}
}
