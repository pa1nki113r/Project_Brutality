Class PBZombieManSpawner : PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_ZombieSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_ZombieSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_ZombieSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_ZombieSpawner_T1");
			Stop;
	}
}

Class PB_ZombieSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_zombieman_override";
		dropitem "PB_PistolZombieman1",255,1;
		dropitem "PB_HelmetZombieman",255,1;
		dropitem "PB_PistolZombieman2",255,1;
		dropitem "PB_ZombieScientist",255,1;
		dropitem "PB_ZombieScientistChainsaw",255,1;
		dropitem "PB_ZombieMan",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetZombieman" && pb_zombieman_filter & DisablePB_HelmetZombieman)
			return false;
		if(toSpawn == "PB_PistolZombieman1" && pb_zombieman_filter & DisablePB_PistolZombieman1)
			return false;
		if(toSpawn == "PB_PistolZombieman2" && pb_zombieman_filter & DisablePB_PistolZombieman2)
			return false;
		if(toSpawn == "PB_ZombieScientist" && pb_zombieman_filter & DisablePB_ZombieScientist)
			return false;
		if(toSpawn == "PB_ZombieScientistChainsaw" && pb_zombieman_filter & DisablePB_ZombieScientistChainsaw)
			return false;
		return true;
	}
}


Class PB_ZombieSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ZombieSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_zombieman_override";
		dropitem "PB_PistolZombieman1",255,1;
		dropitem "PB_HelmetZombieman",255,1;
		dropitem "PB_PistolZombieman2",255,1;
		dropitem "PB_ZombieScientist",255,1;
		dropitem "PB_ZombieScientistChainsaw",255,1;
		dropitem "PB_ZombieMan",255,1;
		dropitem "PB_CarbineZombieman",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetZombieman" && pb_zombieman_filter & DisablePB_HelmetZombieman)
			return false;
		if(toSpawn == "PB_PistolZombieman1" && pb_zombieman_filter & DisablePB_PistolZombieman1)
			return false;
		if(toSpawn == "PB_PistolZombieman2" && pb_zombieman_filter & DisablePB_PistolZombieman2)
			return false;
		if(toSpawn == "PB_ZombieScientist" && pb_zombieman_filter & DisablePB_ZombieScientist)
			return false;
		if(toSpawn == "PB_ZombieScientistChainsaw" && pb_zombieman_filter & DisablePB_ZombieScientistChainsaw)
			return false;
		if(toSpawn == "PB_CarbineZombieman" && pb_zombieman_filter & DisablePB_CarbineZombieman)
			return false;
		return true;
	}
}


Class PB_ZombieSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ZombieSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_zombieman_override";
		dropitem "PB_PistolZombieman1",255,1;
		dropitem "PB_HelmetZombieman",255,1;
		dropitem "PB_PistolZombieman2",255,1;
		dropitem "PB_ZombieScientist",255,1;
		dropitem "PB_ZombieScientistChainsaw",255,1;
		dropitem "PB_ZombieMan",255,1;
		dropitem "PB_CarbineZombieman",255,1;
		dropitem "PB_ZSpecOps",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetZombieman" && pb_zombieman_filter & DisablePB_HelmetZombieman)
			return false;
		if(toSpawn == "PB_PistolZombieman1" && pb_zombieman_filter & DisablePB_PistolZombieman1)
			return false;
		if(toSpawn == "PB_PistolZombieman2" && pb_zombieman_filter & DisablePB_PistolZombieman2)
			return false;
		if(toSpawn == "PB_ZombieScientist" && pb_zombieman_filter & DisablePB_ZombieScientist)
			return false;
		if(toSpawn == "PB_ZombieScientistChainsaw" && pb_zombieman_filter & DisablePB_ZombieScientistChainsaw)
			return false;
		if(toSpawn == "PB_CarbineZombieman" && pb_zombieman_filter & DisablePB_CarbineZombieman)
			return false;
		if(toSpawn == "PB_ZSpecOps" && pb_zombieman_filter & DisablePB_ZSpecOps)
			return false;
		return true;
	}
}


Class PB_ZombieSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ZombieSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_zombieman_override";
		dropitem "PB_PistolZombieman1",255,1;
		dropitem "PB_HelmetZombieman",255,1;
		dropitem "PB_PistolZombieman2",255,1;
		dropitem "PB_ZombieScientist",255,1;
		dropitem "PB_ZombieScientistChainsaw",255,1;
		dropitem "PB_ZombieMan",255,1;
		dropitem "PB_CarbineZombieman",255,1;
		dropitem "PB_ZSpecOps",255,1;
		dropitem "PB_PlasmaZombie",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetZombieman" && pb_zombieman_filter & DisablePB_HelmetZombieman)
			return false;
		if(toSpawn == "PB_PistolZombieman1" && pb_zombieman_filter & DisablePB_PistolZombieman1)
			return false;
		if(toSpawn == "PB_PistolZombieman2" && pb_zombieman_filter & DisablePB_PistolZombieman2)
			return false;
		if(toSpawn == "PB_ZombieScientist" && pb_zombieman_filter & DisablePB_ZombieScientist)
			return false;
		if(toSpawn == "PB_ZombieScientistChainsaw" && pb_zombieman_filter & DisablePB_ZombieScientistChainsaw)
			return false;
		if(toSpawn == "PB_CarbineZombieman" && pb_zombieman_filter & DisablePB_CarbineZombieman)
			return false;
		if(toSpawn == "PB_ZSpecOps" && pb_zombieman_filter & DisablePB_ZSpecOps)
			return false;
		if(toSpawn == "PB_PlasmaZombie" && pb_zombieman_filter & DisablePB_PlasmaZombie)
			return false;
		return true;
	}
}