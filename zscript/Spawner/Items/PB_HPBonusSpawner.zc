Class PBHPBonusSpawner : PB_SpawnerBase
{
	default
	{
		Species "HPBonspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_HPBonusSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_HPBonusSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_HPBonusSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_HPBonusSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_HPBonusSpawnerT1 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_HealthBonus', 255, 1;
	}
}

class PB_HPBonusSpawnerT2 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_HealthBonus', 255, 1;
	}
}

class PB_HPBonusSpawnerT3 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_HealthBonus', 255, 1;
	}
}

class PB_HPBonusSpawnerT4 : PB_HealthSpawner
{
	Default
	{
		DropItem 'PB_HealthBonus', 255, 1;
	}
}