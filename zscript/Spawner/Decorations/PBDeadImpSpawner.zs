//Imp
Class PBDeadImpSpawner : PB_SpawnerBase
{
	States
	{
		Death:
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadImpSpawner_T4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadImpSpawner_T3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadImpSpawner_T2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_DeadImpSpawner_T1");
			Stop;
	}
}

Class PB_DeadImpSpawner_T1 : PB_MonsterSpawner
{
	default
	{
		dropitem "PB_ImpCorpseSpawner",255,1;
	}
}

class PB_ImpCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadImp1",255,1;
		dropitem "DeadImp_NoArm",255,1;
		dropitem "DeadImp_NoArmNoHead",255,1;
		dropitem "DeadImp_NoArm2",255,1;
		dropitem "DeadImp_NoArmNoHead2",255,1;
		dropitem "DeadImp_NoLeg",255,1;
		dropitem "DeadImp_NoHead",255,1;
		dropitem "DeadImp_MinorHeadDeadFront",255,1;
		dropitem "DeadImpMinorHeadShot",255,1;
		dropitem "DeadImp_Half",255,1;
		dropitem "DeadImp_NoStomach",255,1;
		dropitem "DeadImp_NoStomach2",255,1;
		dropitem "DeadImp_NoStomachNoHead",255,1;
		dropitem "DeadImp_NoStomachNoHead2",255,1;
		dropitem "DeadImpBloodLoss",255,1;
		dropitem "DeadImpJustLegsAreLeft",255,1;
		dropitem "DeadImp_Slumped",255,1;
		dropitem "DeadImp1MeleeDeath",255,1;
		dropitem "DeadImp_NoHead_Fatalized",255,1;
		dropitem "DeadImpTR06K",255,1;
		dropitem "DeadImpTR06V",255,1;
		dropitem "DeadImpIZD1H",255,1;
		dropitem "DeadImpID17G",255,1;
		dropitem "DeadImpID17O",255,1;
		dropitem "DeadImpIZD3D",255,1;
		dropitem "DeadImpTROOY",255,1;
		dropitem "DeadImpTRO4M",255,1;
		dropitem "DeadImpT6SWG",255,1;
		dropitem "DeadImpT6SWN",255,1;
		dropitem "DeadImpT5SWG",255,1;
		dropitem "DeadImpT55WG",255,1;
		dropitem "DeadImpT55WN",255,1;
		dropitem "DeadImpTR0HE",255,1;
		dropitem "DeadImpIXD1H",255,1;
		dropitem "DeadImpIXD4L",255,1;
		dropitem "DeadImpTR03E",255,1;
		dropitem "DeadImpTR04E",255,1;
		dropitem "DeadImpTR04J",255,1;
		dropitem "DeadImpTROGE",255,1;
		dropitem "DeadImpSRODF",255,1;
		dropitem "DeadImpZL4Ee",255,1;
		dropitem "DeadImp_ZL5EE",255,1;
	}
}

Class PB_DeadImpSpawner_T2 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadImpSpawner_T1";
		dropitem "PB_InfectedImpCorpseSpawner",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_InfectedImpCorpseSpawner" && pb_imp_filter & DisablePB_InfectedImp)
			return false;
		return true;
	}
}

class PB_InfectedImpCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadSavageImp1",255,1;
		dropitem "DeadSavageImp2",255,1;
		dropitem "DeadSavageImp_NoArm",255,1;
		dropitem "ThisSavageImpGotDestroyed",255,1;
		dropitem "DeadSavageImp_NoArmNoHead",255,1;
		dropitem "DeadSavageImp_NoLeg",255,1;
		dropitem "DeadSavageImp_NoHead",255,1;
		dropitem "DeadSavageImp_MinorHeadDeadFront",255,1;
		dropitem "DeadSavageImp_Half",255,1;
		dropitem "DeadSavageImp_NoStomach",255,1;
		dropitem "DeadSavageImp_NoStomachNoHead",255,1;
		dropitem "DeadSavageImpBloodLoss",255,1;
		dropitem "DeadSavageImpJustLegsAreLeft",255,1;
		dropitem "DeadSavageImp_Slumped",255,1;
		dropitem "DeadSavageImp_2R06K",255,1;
		dropitem "DeadSavageImp_2R06V",255,1;
		dropitem "DeadSavageImp_2ROOM",255,1;
		dropitem "DeadSavageImp_2ROHO",255,1;
		dropitem "DeadSavageImp_2RO3E",255,1;
		dropitem "DeadSavageImp_2RO4E",255,1;
	}
}

Class PB_DeadImpSpawner_T3 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadImpSpawner_T2";
		dropitem "PB_DarkImpCorpseSpawner",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_DarkImpCorpseSpawner" && pb_imp_filter & DisablePB_DarkImps)
			return false;
		return true;
	}
}

class PB_DarkImpCorpseSpawner : RandomSpawner
{
	default
	{
		dropitem "DeadDarkImp1",255,1;
		dropitem "DeadDarkImpST_NoStomach",255,1;
		dropitem "DeadDarkImp_NoArm",255,1;
		dropitem "DeadDarkImp_NoArmNoHead",255,1;
		dropitem "DeadDarkImpBloodLoss",255,1;
		dropitem "DeadDarkImp_NoLeg",255,1;
		dropitem "DeadDarkImp_Half",255,1;
		dropitem "DeadDarkImp_NoHead1",255,1;
		dropitem "DeadDarkImp_NoHead2",255,1;
		dropitem "ThisDarkImpGotScrewedUp",255,1;
		dropitem "ThisDarkImpGotScrewedUp2",255,1;
		dropitem "AbsolutelyDestroyedDarkImp",255,1;
		dropitem "DeadDarkImpD1S9O",255,1;
		dropitem "DeadDarkImpD1S9V",255,1;
		dropitem "DeadDarkImpD3S3E",255,1;
		dropitem "DeadDarkImpDRKVP",255,1;
		dropitem "DeadDarkImpD2S2H",255,1;
		dropitem "DeadDarkImpD3S2K",255,1;
		dropitem "DeadDarkImpDRKSM",255,1;
	}
}

Class PB_DeadImpSpawner_T4 : PB_MonsterSpawner
{
	default
	{
		PBRandomSpawner.Fallback "PB_DeadImpSpawner_T3";
		dropitem "PB_DarkImpCorpseSpawner",255,1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_DarkImpCorpseSpawner" && pb_imp_filter & DisablePB_DarkImps)
			return false;
		return true;
	}
}