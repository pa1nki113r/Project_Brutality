Class PBRocketSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_RocketSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_RocketSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_RocketSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_RocketSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_RocketSpawnerT1 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketAmmo', 255, 1;
	}
}

class PB_RocketSpawnerT2 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketAmmo', 255, 1;
	}
}

class PB_RocketSpawnerT3 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketAmmo', 255, 1;
	}
}

class PB_RocketSpawnerT4 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_RocketAmmo', 255, 1;
	}
}