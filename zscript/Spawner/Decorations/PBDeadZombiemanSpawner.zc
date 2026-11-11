//Imp
Class PBDeadZombiemanSpawner : PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadZombiemanSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadZombiemanSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadZombiemanSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadZombiemanSpawner_T1");
			Stop;
	}
}

Class PB_DeadZombiemanSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		dropitem "PB_ZombiemanCorpseSpawner",255,1;
	}
}

class PB_ZombiemanCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadZombieman1",255,1;
		dropitem "DeadZombieman1F",255,1;
		dropitem "Zombieman_DeathPNDT",255,1;
		dropitem "DeadZombieMan_NoArm",255,1;
		dropitem "DeadZombieman1FG",255,1;
		dropitem "DeadZombieMan_NoArm3",255,1;
		dropitem "DeadZombieMan_NoLeg",255,1;
		dropitem "DeadZombieMan_NoHeadNoLeg",255,1;
		dropitem "DeadZombieMan_NoLegBoth",255,1;
		dropitem "DeadZombieMan_NoHead",255,1;
		dropitem "DeadZombieMan_NoHeadFront",255,1;
		dropitem "DeadZombieMan_Half",255,1;
	}
}

Class PB_DeadZombiemanSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadZombiemanSpawner_T1";
		dropitem "PB_ZombiemanCorpseSpawner",255,1;
	}
}

Class PB_DeadZombiemanSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadZombiemanSpawner_T2";
		dropitem "PB_ZombiemanCorpseSpawner",255,1;
	}
}

Class PB_DeadZombiemanSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadZombiemanSpawner_T3";
		dropitem "PB_ZombiemanCorpseSpawner",255,1;
	}
}