Class PBChainGunGuySpawner : PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_ChainGuySpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_ChainGuySpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_ChainGuySpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_ChainGuySpawner_T1");
			Stop;
	}
}

Class PB_ChainGuySpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_chaingunner_override";
		dropitem "PB_HelmetCommando",255,1;
		dropitem "PB_Commando",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetCommando" && pb_chaingunner_filter & DisablePB_HelmetCommando)
			return false;
		return true;
	}
}

Class PB_ChainGuySpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ChainGuySpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_chaingunner_override";
		dropitem "PB_HelmetCommando",255,1;
		dropitem "PB_Commando",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetCommando" && pb_chaingunner_filter & DisablePB_HelmetCommando)
			return false;
		return true;
	}
}

Class PB_ChainGuySpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ChainGuySpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_chaingunner_override";
		dropitem "PB_HelmetCommando",255,1;
		dropitem "PB_Commando",255,1;
		dropitem "PB_NailgunMajor",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetCommando" && pb_chaingunner_filter & DisablePB_HelmetCommando)
			return false;
		if(toSpawn == "PB_NailgunMajor" && pb_chaingunner_filter & DisablePB_NailgunMajor)
			return false;
		return true;
	}
}

Class PB_ChainGuySpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_ChainGuySpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_chaingunner_override";
		dropitem "PB_HelmetCommando",255,1;
		dropitem "PB_Commando",255,1;
		dropitem "PB_NailgunMajor",255,1;
		dropitem "PB_DemonTechZombie",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_HelmetCommando" && pb_chaingunner_filter & DisablePB_HelmetCommando)
			return false;
		if(toSpawn == "PB_NailgunMajor" && pb_chaingunner_filter & DisablePB_NailgunMajor)
			return false;
		if(toSpawn == "PB_DemonTechZombie" && pb_chaingunner_filter & DisablePB_DemonTechZombie)
			return false;
		return true;
	}
}