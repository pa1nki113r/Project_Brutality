Class EvilNaziSpawner: PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_NaziSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_NaziSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_NaziSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_NaziSpawner_T1");
			Stop;
	}
}

Class PB_NaziSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_nazi_override";
		dropitem "PB_Nazi",255,1;
	}
}

Class PB_NaziSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_NaziSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_nazi_override";
		dropitem "PB_Nazi",255,1;
	}
}

Class PB_NaziSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_NaziSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_nazi_override";
		dropitem "PB_Nazi",255,1;
	}
}

Class PB_NaziSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_NaziSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_nazi_override";
		dropitem "PB_Nazi",255,1;
	}
}