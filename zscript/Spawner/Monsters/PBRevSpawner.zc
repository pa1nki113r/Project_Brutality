Class PBRevSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_RevSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_RevSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_RevSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_RevSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_RevSpawner_T1");
			Stop;
	}
}

Class PB_RevSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_revenant_override";
		dropitem "PB_Revenant",255,1;
	}
}

Class PB_RevSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_RevSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_revenant_override";
		dropitem "PB_BeamRev",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_BeamRev" && pb_revenant_filter & DisablePB_BeamRev)
			return false;
		return true;
	}
}

Class PB_RevSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_RevSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_revenant_override";
		dropitem "PB_Draugr",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Draugr" && pb_revenant_filter & DisablePB_Draugr)
			return false;
		return true;
	}
}

Class PB_RevSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_RevSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_revenant_override";
		dropitem "PB_Draugr",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Draugr" && pb_revenant_filter & DisablePB_Draugr)
			return false;
		return true;
	}
}

Class PB_RevSpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_revenant_override";
		dropitem "PB_Revenant",255,7;
		dropitem "PB_BeamRev",255,7;
		dropitem "PB_Draugr",255,6;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_BeamRev" && pb_revenant_filter & DisablePB_BeamRev)
			return false;
		if(toSpawn == "PB_Draugr" && pb_revenant_filter & DisablePB_Draugr)
			return false;
		return true;
	}
}
