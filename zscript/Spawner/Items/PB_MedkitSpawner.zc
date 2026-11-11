Class PBMedikitSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_MediSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_MediSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_MediSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_MediSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_MediSpawnerT1 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Medikit', 255, 1;
	}
}

class PB_MediSpawnerT2 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Medikit', 255, 1;
	}
}

class PB_MediSpawnerT3 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Medikit', 255, 1;
	}
}

class PB_MediSpawnerT4 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Medikit', 255, 1;
	}
}