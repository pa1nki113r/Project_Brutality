Class PBHKSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_KnightSpawner_DW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_KnightSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_KnightSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_KnightSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_KnightSpawner_T1");
			Stop;
	}
}

Class PB_KnightSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_hellknight_override";
		dropitem "PB_Knight",255,1;
	}
}

Class PB_KnightSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_KnightSpawner_T1";
		PBRandomSpawner.SpawnOverride "pb_hellknight_override";
		dropitem "PB_CyberKnight",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_CyberKnight" && pb_hellknight_filter & DisablePB_CyberKnight)
			return false;
		return true;
	}
}

Class PB_KnightSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_KnightSpawner_T2";
		PBRandomSpawner.SpawnOverride "pb_hellknight_override";
		dropitem "PB_CyberPaladin",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_CyberPaladin" && pb_hellknight_filter & DisablePB_CyberPaladin)
			return false;
		return true;
	}
}

Class PB_KnightSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_KnightSpawner_T3";
		PBRandomSpawner.SpawnOverride "pb_hellknight_override";
		dropitem "PB_CyberPaladin",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_CyberPaladin" && pb_hellknight_filter & DisablePB_CyberPaladin)
			return false;
		return true;
	}
}

Class PB_KnightSpawner_DW : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.SpawnOverride "pb_hellknight_override";
		dropitem "PB_Knight",255,49;
		dropitem "PB_CyberPaladin",255,15;
		dropitem "PB_CyberKnight",255,36;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_CyberKnight" && pb_hellknight_filter & DisablePB_CyberKnight)
			return false;
		if(toSpawn == "PB_CyberPaladin" && pb_hellknight_filter & DisablePB_CyberPaladin)
			return false;
		return true;
	}
}
