Class PBLSSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSpawner_T1");
			Stop;
	}
}

Class PB_SoulSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_lostsoul_override";
		dropitem "PB_LostSoul",255,1;
	}
}

Class PB_SoulSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_SoulSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_lostsoul_override";
		dropitem "PB_Phantasm",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Phantasm" && pb_lostsoul_filter & DisablePB_Phantasm)
			return false;
		return true;
	}
}

Class PB_SoulSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_SoulSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_lostsoul_override";
		dropitem "PB_Phantasm",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Phantasm" && pb_lostsoul_filter & DisablePB_Phantasm)
			return false;
		return true;
	}
}

Class PB_SoulSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_SoulSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_lostsoul_override";
		dropitem "PB_Phantasm",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Phantasm" && pb_lostsoul_filter & DisablePB_Phantasm)
			return false;
		return true;
	}
}

Class PB_SoulSpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_lostsoul_override";
		dropitem "PB_LostSoul",255,1;
		dropitem "PB_Phantasm",255,3;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Phantasm" && pb_lostsoul_filter & DisablePB_Phantasm)
			return false;
		return true;
	}
}
