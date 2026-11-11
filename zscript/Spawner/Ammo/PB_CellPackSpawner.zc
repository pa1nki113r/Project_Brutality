Class PBCellPackSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_CellPackSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_CellPackSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_CellPackSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_CellPackSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_CellPackSpawnerT1 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_CellPack', 255, 1;
	}
}

class PB_CellPackSpawnerT2 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_CellPack', 255, 1;
	}
}

class PB_CellPackSpawnerT3 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_CellPack', 255, 1;
	}
}

class PB_CellPackSpawnerT4 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_CellPack', 255, 1;
	}
}