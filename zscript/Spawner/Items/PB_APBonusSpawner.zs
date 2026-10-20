Class PBAPBonusSpawner : PB_SpawnerBase
{
	default
	{
		Species "APBonspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_APBonusSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_APBonusSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_APBonusSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_APBonusSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_APBonusSpawnerT1 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_ArmorBonus', 255, 1;
	}
}

class PB_APBonusSpawnerT2 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_ArmorBonus', 255, 1;
	}
}

class PB_APBonusSpawnerT3 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_ArmorBonus', 255, 1;
	}
}

class PB_APBonusSpawnerT4 : PB_ArmorSpawner
{
	Default
	{
		DropItem 'PB_ArmorBonus', 255, 1;
	}
}