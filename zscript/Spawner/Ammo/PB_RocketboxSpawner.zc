Class PBRocketBoxSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_RocketBoxSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_RocketBoxSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_RocketBoxSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_RocketBoxSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_RocketBoxSpawnerT1 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketBox', 255, 1;
	}
}

class PB_RocketBoxSpawnerT2 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketBox', 255, 1;
	}
}

class PB_RocketBoxSpawnerT3 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketBox', 255, 1;
	}
}

class PB_RocketBoxSpawnerT4 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketBox', 255, 1;
	}
}