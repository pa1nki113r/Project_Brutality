Class PBBlueSpawner : PB_SpawnerBase
{
	default
	{
		Species "Bluespawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_BlueSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_BlueSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_BlueSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_BlueSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_BlueSpawnerT1 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_BlueArmor', 255, 1;
	}
}

class PB_BlueSpawnerT2 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_BlueArmor', 255, 1;
	}
}

class PB_BlueSpawnerT3 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_BlueArmor', 255, 1;
	}
}

class PB_BlueSpawnerT4 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_BlueArmor', 255, 1;
	}
}