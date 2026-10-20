Class PBStimSpawner : PB_SpawnerBase //replaces Stimpack
{
	default
	{
		Species "stimspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_StimSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_StimSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_StimSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_StimSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_StimSpawnerT1 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Stimpack', 255, 1;
	}
}

class PB_StimSpawnerT2 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Stimpack', 255, 1;
	}
}

class PB_StimSpawnerT3 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Stimpack', 255, 1;
	}
}

class PB_StimSpawnerT4 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_Stimpack', 255, 1;
	}
}