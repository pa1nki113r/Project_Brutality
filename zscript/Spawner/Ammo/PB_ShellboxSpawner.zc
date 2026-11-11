Class PBShellboxSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_ShellboxSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_ShellboxSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_ShellboxSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_ShellboxSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_ShellboxSpawnerT1 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shellbox', 255, 2;
		DropItem 'PB_LowCalBox', 255, 1;
	}
}

class PB_ShellboxSpawnerT2 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shellbox', 255, 2;
		DropItem 'PB_LowCalBox', 255, 1;
	}
}

class PB_ShellboxSpawnerT3 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shellbox', 255, 2;
		DropItem 'PB_LowCalBox', 255, 1;
	}
}

class PB_ShellboxSpawnerT4 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_Shellbox', 255, 2;
		DropItem 'PB_LowCalBox', 255, 1;
	}
}