//Cacodemon
Class PBDeadCacodemonSpawner : PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadCacoSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadCacoSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadCacoSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadCacoSpawner_T1");
			Stop;
	}
}

Class PB_DeadCacoSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		dropitem "PB_CacodemonCorpseSpawner",255,1;
	}
}

class PB_CacodemonCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "PB_DeadCacodemon1",255,1;
		dropitem "PB_DeadCacodemon2",255,1;
		dropitem "PB_DeadCacodemon3",255,1;
		dropitem "PB_DeadCacodemon5",255,1;
		dropitem "PB_DeadCacodemon6",255,1;
		dropitem "PB_DeadCacodemon7",255,1;
		dropitem "PB_DeadCacodemon9",255,1;
		dropitem "PB_DeadCacodemon11",255,1;
		dropitem "PB_DeadCacodemon12",255,1;
		dropitem "PB_DeadCacodemon13",255,1;
		dropitem "PB_DeadCacodemon14",255,1;
		dropitem "PB_DeadCacodemon15",255,1;
		dropitem "PB_DeadCacodemon16",255,1;
	}
}

Class PB_DeadCacoSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadCacoSpawner_T2";
		dropitem "PB_WatcherCorpseSpawner",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_WatcherCorpseSpawner" && pb_cacodemon_filter & DisablePB_InfernalCaco)
			return false;
		return true;
	}
}

class PB_WatcherCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "PB_DeadWatcher",255,1;
		dropitem "PB_DeadWatcher2",255,1;
		dropitem "PB_DeadWatcher3",255,1;
	}
}

Class PB_DeadCacoSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadCacoSpawner_T2";
		dropitem "DeadAfrit",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "DeadAfrit" && pb_cacodemon_filter & DisablePB_Afrit)
			return false;
		return true;
	}
}

Class PB_DeadCacoSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadCacoSpawner_T3";
		dropitem "DeadAfrit",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "DeadAfrit" && pb_cacodemon_filter & DisablePB_Afrit)
			return false;
		return true;
	}
}