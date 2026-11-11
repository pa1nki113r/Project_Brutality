//Imp
Class PBDeadShotgunGuySpawner : PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadShotgunGuySpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadShotgunGuySpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadShotgunGuySpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadShotgunGuySpawner_T1");
			Stop;
	}
}

Class PB_DeadShotgunGuySpawner_T1 : PB_MonsterSpawner
{
	default
	{
		dropitem "PB_ImpCorpseSpawner",255,1;
	}
}

class PB_ShotgunGuyCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadShotgunGuy1",255,1;
	}
}

Class PB_DeadShotgunGuySpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadShotgunGuySpawner_T1";
		dropitem "PB_ShotgunGuyCorpseSpawner",255,1;
	}
}

Class PB_DeadShotgunGuySpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadShotgunGuySpawner_T2";
		dropitem "PB_ShotgunGuyCorpseSpawner",255,1;
	}
}

Class PB_DeadShotgunGuySpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadShotgunGuySpawner_T3";
		dropitem "PB_ShotgunGuyCorpseSpawner",255,1;
	}
}