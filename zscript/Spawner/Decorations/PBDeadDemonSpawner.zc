Class PBDeadDemonSpawner : PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadDemonSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadDemonSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadDemonSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadDemonSpawner_T1");
			Stop;
	}
}

Class PB_DeadDemonSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		dropitem "PB_DemonCorpseSpawner",255,1;
	}
}

class PB_DemonCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadDemon1",255,1;
		dropitem "DeadDemonSAARI",255,1;
		dropitem "DeadDemonHalf",255,1;
		dropitem "DeadDemonHalf23",255,1;
		dropitem "DeadDemonXDP5H",255,1;
		dropitem "DeadDemonPXD1G",255,1;
		dropitem "DeadDemon4N1KF",255,1;
		dropitem "DeadDemonNoArm",255,1;
		dropitem "DeadDemonNoHead",255,1;
		dropitem "DeadDemon1Left",255,1;
		dropitem "DeadDemonNoHead2",255,1;
		dropitem "DeadDemonSAARK",255,1;
	}
}

Class PB_DeadDemonSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadDemonSpawner_T1";
		dropitem "PB_DemonCorpseSpawner",255,1;
	}
}

Class PB_DeadDemonSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadDemonSpawner_T2";
		dropitem "PB_BloodDemonCorpseSpawner",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_BloodDemonCorpseSpawner" && pb_pinky_filter & DisablePB_MeanDemon)
			return false;
		return true;
	}
}

class PB_BloodDemonCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadMeanDemonNoHead",255,1;
		dropitem "DeadMeanDemonNoArm",255,1;
		dropitem "DeadMeanDemonHalf23",255,1;
	}
}

Class PB_DeadDemonSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadDemonSpawner_T3";
		dropitem "PB_MechaDemonCorpseSpawner",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_MechaDemonCorpseSpawner" && pb_pinky_filter & DisablePB_MechDemon)
			return false;
		return true;
	}
}

class PB_MechaDemonCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadDemonSRG2N",255,1;
	}
}