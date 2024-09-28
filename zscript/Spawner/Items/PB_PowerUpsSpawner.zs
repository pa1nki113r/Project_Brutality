Class PB_InvulSpawner : PB_SpawnerBase replaces invulnerabilitysphere
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "InvulSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InvulSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InvulSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InvulSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InvulSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_InvulSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Invul', 255, 1;
	}
}

class PB_InvulSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Invul', 255, 1;
	}
}

class PB_InvulSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Invul', 255, 1;
	}
}

class PB_InvulSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Invul', 255, 1;
	}
}



///
///	radsuit
/// 
//

Class PB_RadSuitSpawner : PB_SpawnerBase replaces radsuit
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "radsuitSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_RadSuitSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_RadSuitSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_RadSuitSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_RadSuitSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_RadSuitSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_RadSuit', 255, 1;
	}
}

class PB_RadSuitSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_RadSuit', 255, 1;
	}
}

class PB_RadSuitSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_RadSuit', 255, 1;
	}
}

class PB_RadSuitSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_RadSuit', 255, 1;
	}
}


//
//
//
//PB_BlurSphere


Class PB_BlurSpawner : PB_SpawnerBase replaces blursphere
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "MotionBlur";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BlurSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BlurSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BlurSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BlurSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_BlurSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_BlurSphere', 255, 1;
	}
}

class PB_BlurSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_BlurSphere', 255, 1;
	}
}

class PB_BlurSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_BlurSphere', 255, 1;
	}
}

class PB_BlurSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_BlurSphere', 255, 1;
	}
}

//
//	
// infrared
//

Class PB_InfraRedSpawner : PB_SpawnerBase replaces infrared
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "GoogleSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InfraRedSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InfraRedSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InfraRedSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_InfraRedSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_InfraRedSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Infrared', 255, 1;
	}
}

class PB_InfraRedSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Infrared', 255, 1;
	}
}

class PB_InfraRedSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Infrared', 255, 1;
	}
}

class PB_InfraRedSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Infrared', 255, 1;
	}
}


//
//	soulsphere
//
//

Class PB_SoulSphereSpawner : PB_SpawnerBase replaces soulsphere
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "SSSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_SoulSphereSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_SoulSphereSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_SoulSphereSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_SoulSphereSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_SoulSphereSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Soulsphere', 255, 1;
	}
}

class PB_SoulSphereSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Soulsphere', 255, 1;
	}
}

class PB_SoulSphereSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Soulsphere', 255, 1;
	}
}

class PB_SoulSphereSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Soulsphere', 255, 1;
	}
}

//
//
//
// 

Class PB_MegaSpawner : PB_SpawnerBase replaces megasphere
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "MegaSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_MegaSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_MegaSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_MegaSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_MegaSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_MegaSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Megasphere', 255, 1;
	}
}

class PB_MegaSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Megasphere', 255, 1;
	}
}

class PB_MegaSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Megasphere', 255, 1;
	}
}

class PB_MegaSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Megasphere', 255, 1;
	}
}

//
//	PB_Berserk
// Berserk
//

Class PB_BerserkSpawner : PB_SpawnerBase replaces Berserk
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "BerserkSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BerserkSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BerserkSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BerserkSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_BerserkSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_BerserkSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Berserk', 255, 1;
	}
}

class PB_BerserkSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Berserk', 255, 1;
	}
}

class PB_BerserkSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Berserk', 255, 1;
	}
}

class PB_BerserkSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Berserk', 255, 1;
	}
}

//
//
//	allmap
//

Class PB_AllMapSpawner : PB_SpawnerBase replaces AllMap
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "AllMapSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_AllMapSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_AllMapSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_AllMapSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_AllMapSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_AllMapSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_AllMap', 255, 1;
	}
}

class PB_AllMapSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_AllMap', 255, 1;
	}
}

class PB_AllMapSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_AllMap', 255, 1;
	}
}

class PB_AllMapSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_AllMap', 255, 1;
	}
}

//
//	PB_Doomsphere
//
//

Class PB_DoomSpawner : PB_SpawnerBase
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "DoomSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_DoomSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_DoomSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_DoomSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_DoomSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_DoomSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Doomsphere', 255, 1;
	}
}

class PB_DoomSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Doomsphere', 255, 1;
	}
}

class PB_DoomSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Doomsphere', 255, 1;
	}
}

class PB_DoomSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Doomsphere', 255, 1;
	}
}


//
///	hastesphere
// PB_Haste

Class PB_HasteSpawner : PB_SpawnerBase
{
	default
	{
		-COUNTKILL; 
		+NOTIMEFREEZE;
		-ISMONSTER;
		Species "HasteSpawner";
	}
	States
	{
		Tier4:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_HasteSpawnerT4",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier3:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_HasteSpawnerT3",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier2:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_HasteSpawnerT2",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Tier1:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("PB_HasteSpawnerT1",flags:SXF_TRANSFERSPECIAL|SXF_TRANSFERAMBUSHFLAG|SXF_TRANSFERPOINTERS|288,tid:tid);
			Stop;
		Death:
		    TNT1 A 0;
			Goto Spawn;
	}
}

class PB_HasteSpawnerT1 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Haste', 255, 1;
	}
}

class PB_HasteSpawnerT2 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Haste', 255, 1;
	}
}

class PB_HasteSpawnerT3 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Haste', 255, 1;
	}
}

class PB_HasteSpawnerT4 : PB_PowerUpSpawner
{
	Default
	{
		DropItem 'PB_Haste', 255, 1;
	}
}