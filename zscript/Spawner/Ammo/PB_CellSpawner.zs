Class PBCellSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_CellSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_CellSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_CellSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_CellSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_CellSpawnerT1 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Cell', 255, 1;
	}
}

class PB_CellSpawnerT2 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Cell', 255, 1;
	}
}

class PB_CellSpawnerT3 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Cell', 255, 1;
	}
}

class PB_CellSpawnerT4 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Cell', 255, 1;
	}
}