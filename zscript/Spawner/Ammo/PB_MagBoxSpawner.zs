Class PBClipBoxSpawner : PB_SpawnerBase
{
	default
	{
		Species "medspawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 A_SpawnItemEx("PB_ClipBoxSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0 A_SpawnItemEx("PB_ClipBoxSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0 A_SpawnItemEx("PB_ClipBoxSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0 A_SpawnItemEx("PB_ClipBoxSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
	}
}

class PB_ClipBoxSpawnerT1 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_HighCalBox', 255, 1;
	}
}

class PB_ClipBoxSpawnerT2 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_HighCalBox', 255, 1;
	}
}

class PB_ClipBoxSpawnerT3 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_HighCalBox', 255, 1;
	}
}

class PB_ClipBoxSpawnerT4 : PB_AmmoSpawner
{
	Default
	{
		DropItem 'PB_HighCalBox', 255, 1;
	}
}