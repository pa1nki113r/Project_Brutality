//Invulnerability
Class PB_InvulSpawner : PB_SpawnerBase
{
	default
	{
		Species "InvulSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_InvulSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_InvulSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_InvulSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_InvulSpawnerT1");
			Stop;
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

//Radiation Suit
Class PB_RadSuitSpawner : PB_SpawnerBase
{
	default
	{
		Species "radsuitSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_RadSuitSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_RadSuitSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_RadSuitSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_RadSuitSpawnerT1");
			Stop;
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

//Partial Invisibility
Class PB_BlurSpawner : PB_SpawnerBase
{
	default
	{
		Species "MotionBlur";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_BlurSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_BlurSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_BlurSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_BlurSpawnerT1");
			Stop;
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

//Light Amp Visor
Class PB_InfraRedSpawner : PB_SpawnerBase
{
	default
	{
		Species "GoogleSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_InfraRedSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_InfraRedSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_InfraRedSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_InfraRedSpawnerT1");
			Stop;
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

//Supercharge
Class PB_SoulSphereSpawner : PB_SpawnerBase
{
	default
	{
		Species "SSSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSphereSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSphereSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSphereSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_SoulSphereSpawnerT1");
			Stop;
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

//Megasphere
Class PB_MegaSpawner : PB_SpawnerBase
{
	default
	{
		Species "MegaSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_MegaSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_MegaSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_MegaSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_MegaSpawnerT1");
			Stop;
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

// Berserk
Class PB_BerserkSpawner : PB_SpawnerBase
{
	default
	{
		Species "BerserkSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_BerserkSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_BerserkSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_BerserkSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_BerserkSpawnerT1");
			Stop;
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

//Computer Area Map
Class PB_AllMapSpawner : PB_SpawnerBase
{
	default
	{
		Species "AllMapSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_AllMapSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_AllMapSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_AllMapSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_AllMapSpawnerT1");
			Stop;
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

//Quad Damage
Class PB_DoomSpawner : PB_SpawnerBase
{
	default
	{
		Species "DoomSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_DoomSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_DoomSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_DoomSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_DoomSpawnerT1");
			Stop;
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

//Haste
Class PB_HasteSpawner : PB_SpawnerBase
{
	default
	{
		Species "HasteSpawner";
	}
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_HasteSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_HasteSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_HasteSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_HasteSpawnerT1");
			Stop;
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