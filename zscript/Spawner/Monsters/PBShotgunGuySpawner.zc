Class PBShotgunGuySpawner : PB_SpawnerBase
{
	States
	{
		Death:
		ChaoticRandom:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_ShotGuySpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_ShotGuySpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_ShotGuySpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_ShotGuySpawner_T1");
			Stop;
	}
}

Class PB_ShotGuySpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_sergeant_override";
		dropitem "PB_ShotgunGuy",255,1;
		dropitem "PB_ShotgunGuyHelmet",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_ShotgunGuyHelmet" && pb_sergeant_filter & DisablePB_ShotgunGuyHelmet)
			return false;
		return true;
	}
}

Class PB_ShotGuySpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ShotGuySpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_sergeant_override";
		dropitem "PB_ShotgunGuy",255,1;
		dropitem "PB_ShotgunGuyHelmet",255,1;
		dropitem "PB_RiotShieldGuy",255,1;
		dropitem "PB_ASGGuy",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_ShotgunGuyHelmet" && pb_sergeant_filter & DisablePB_ShotgunGuyHelmet)
			return false;
		if(toSpawn == "PB_RiotShieldGuy" && pb_sergeant_filter & DisablePB_RiotShieldGuy)
			return false;
		if(toSpawn == "PB_ASGGuy" && pb_sergeant_filter & DisablePB_ASGGuy)
			return false;
		return true;
	}
}

Class PB_ShotGuySpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ShotGuySpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_sergeant_override";
		dropitem "PB_ShotgunGuy",255,1;
		dropitem "PB_ShotgunGuyHelmet",255,1;
		dropitem "PB_RiotShieldGuy",255,1;
		dropitem "PB_ASGGuy",255,1;
		dropitem "PB_PyroSergeant",255,1;
		dropitem "PB_QSGZombie",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_ShotgunGuyHelmet" && pb_sergeant_filter & DisablePB_ShotgunGuyHelmet)
			return false;
		if(toSpawn == "PB_RiotShieldGuy" && pb_sergeant_filter & DisablePB_RiotShieldGuy)
			return false;
		if(toSpawn == "PB_ASGGuy" && pb_sergeant_filter & DisablePB_ASGGuy)
			return false;
		if(toSpawn == "PB_PyroSergeant" && pb_sergeant_filter & DisablePB_PyroSergeant)
			return false;
		if(toSpawn == "PB_QSGZombie" && pb_sergeant_filter & DisablePB_QSGZombie)
			return false;
		return true;
	}
}

Class PB_ShotGuySpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ShotGuySpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_sergeant_override";
		dropitem "PB_ShotgunGuy",255,1;
		dropitem "PB_ShotgunGuyHelmet",255,1;
		dropitem "PB_RiotShieldGuy",255,1;
		dropitem "PB_ASGGuy",255,1;
		dropitem "PB_PyroSergeant",255,1;
		dropitem "PB_QSGZombie",255,1;
		dropitem "PB_RocketZombie",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_ShotgunGuyHelmet" && pb_sergeant_filter & DisablePB_ShotgunGuyHelmet)
			return false;
		if(toSpawn == "PB_RiotShieldGuy" && pb_sergeant_filter & DisablePB_RiotShieldGuy)
			return false;
		if(toSpawn == "PB_ASGGuy" && pb_sergeant_filter & DisablePB_ASGGuy)
			return false;
		if(toSpawn == "PB_PyroSergeant" && pb_sergeant_filter & DisablePB_PyroSergeant)
			return false;
		if(toSpawn == "PB_QSGZombie" && pb_sergeant_filter & DisablePB_QSGZombie)
			return false;
		if(toSpawn == "PB_RocketZombie" && pb_sergeant_filter & DisablePB_RocketZombie)
			return false;
		return true;
	}
}