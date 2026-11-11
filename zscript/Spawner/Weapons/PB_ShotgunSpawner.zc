Class PBShotgunSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_ShotSpawnerSpawn("PB_ShotSpawnerDW","PB_SSGSpawnerDW");
			Stop;
		Tier4:
			TNT1 A 0 PB_ShotSpawnerSpawn("PB_ShotSpawnerT4","PB_SSGSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_ShotSpawnerSpawn("PB_ShotSpawnerT3","PB_SSGSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_ShotSpawnerSpawn("PB_ShotSpawnerT2","PB_SSGSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_ShotSpawnerSpawn("PB_ShotSpawnerT1","PB_SSGSpawnerT1");
			Stop;
	}
	
	void PB_ShotSpawnerSpawn(name spawner, name ssgspawner)
	{
		if(pb_SSGRandomSpawn && random(0,3) == 3)
			PB_SpawnerSpawn(ssgspawner);
		else
			PB_SpawnerSpawn(spawner);
	}
}

class PB_ShotSpawnerT1 : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_Shotgun', 255, 1;
	}
}

class PB_ShotSpawnerT2 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_ShotSpawnerT1';
		DropItem 'PB_Autoshotgun', 255, 1;
		DropItem 'PB_Revolver', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Autoshotgun" && pb_shotgun_filter & DisablePB_Autoshotgun)
			return false;
		if(toSpawn == "PB_Revolver" && pb_pistol_filter & DisablePB_Revolver)
			return false;
		return true;
	}
}

class PB_ShotSpawnerT3 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_ShotSpawnerT2';
		DropItem 'PB_SGMagazine', 255, 1;
		DropItem 'PB_SMG', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_SGMagazine" && pb_shotgun_filter & DisablePB_SGMagazine)
			return false;
		if(toSpawn == "PB_SMG" && pb_pistol_filter & DisablePB_SMG)
			return false;
		return true;
	}
}

class PB_ShotSpawnerT4 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_ShotSpawnerT3';
		DropItem 'PB_AutoshotgunUpgrade', 255, 1; 
		DropItem 'PB_Deagle', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_AutoshotgunUpgrade" && pb_shotgun_filter & DisablePB_AutoshotgunUpgrade)
			return false;
		if(toSpawn == "PB_Deagle" && pb_pistol_filter & DisablePB_Deagle)
			return false;
		return true;
	}
}

class PB_ShotSpawnerDW : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_Shotgun', 255, 27;
		DropItem 'PB_Autoshotgun', 255, 13;
		DropItem 'PB_Revolver', 255, 6;
		DropItem 'PB_SGMagazine', 255, 40;
		DropItem 'PB_SMG', 255, 5;
		DropItem 'PB_AutoshotgunUpgrade', 255, 5; 
		DropItem 'PB_Deagle', 255, 4;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_Autoshotgun" && pb_shotgun_filter & DisablePB_Autoshotgun)
			return false;
		if(toSpawn == "PB_Revolver" && pb_pistol_filter & DisablePB_Revolver)
			return false;
		if(toSpawn == "PB_SGMagazine" && pb_shotgun_filter & DisablePB_SGMagazine)
			return false;
		if(toSpawn == "PB_SMG" && pb_pistol_filter & DisablePB_SMG)
			return false;
		if(toSpawn == "PB_AutoshotgunUpgrade" && pb_shotgun_filter & DisablePB_AutoshotgunUpgrade)
			return false;
		if(toSpawn == "PB_Deagle" && pb_pistol_filter & DisablePB_Deagle)
			return false;
		return true;
	}
}
