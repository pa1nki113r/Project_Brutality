Class PBShellSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_ShellSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_ShellSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_ShellSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_ShellSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_ShellSpawnerT1 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shell', 255, 2;
		DropItem 'PB_LowCalMag', 255, 1;
	}
}

class PB_ShellSpawnerT2 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shell', 255, 2;
		DropItem 'PB_LowCalMag', 255, 1;
	}
}

class PB_ShellSpawnerT3 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shell', 255, 2;
		DropItem 'PB_LowCalMag', 255, 1;
	}
}

class PB_ShellSpawnerT4 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shell', 255, 2;
		DropItem 'PB_LowCalMag', 255, 1;
	}
}