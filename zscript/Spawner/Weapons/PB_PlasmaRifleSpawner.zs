Class PBPlasmaRifleSpawner : PB_SpawnerBase
{
	States
	{
		Death:
			TNT1 A 0 PB_SpawnerSpawn("PB_PlasSpawnerDW");
			Stop;
		Tier4:
			TNT1 A 0 PB_SpawnerSpawn("PB_PlasSpawnerT4");
			Stop;
		Tier3:
			TNT1 A 0 PB_SpawnerSpawn("PB_PlasSpawnerT3");
			Stop;
		Tier2:
			TNT1 A 0 PB_SpawnerSpawn("PB_PlasSpawnerT2");
			Stop;
		Tier1:
			TNT1 A 0 PB_SpawnerSpawn("PB_PlasSpawnerT1");
			Stop;
	}
}

class PB_PlasSpawnerT1 : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_M1Plasma', 255, 1;
	}
}

class PB_PlasSpawnerT2 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_PlasSpawnerT1';
		DropItem 'PB_M2Plasma', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_M2Plasma" && pb_plasmarifle_filter & DisablePB_M2Plasma)
			return false;
		return true;
	}
}

class PB_PlasSpawnerT3 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_PlasSpawnerT2';
		DropItem 'PB_CryoRifle', 255, 1;
		//DropItem "PB_PulseCannon", 255, 1; //UNCOMMENT WHEN PULSE CANNON IS ADDED
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_CryoRifle" && pb_plasmarifle_filter & DisablePB_CryoRifle)
			return false;
		if(toSpawn == "PB_PulseCannon" && pb_plasmarifle_filter & DisablePB_PulseCannon)
			return false;
		return true;
	}
}

class PB_PlasSpawnerT4 : PB_WeaponSpawner
{
	Default
	{
		PBRandomSpawner.Fallback 'PB_PlasSpawnerT3';
		DropItem 'PB_M2Upgrade', 255, 1;
		DropItem 'PB_DTechRifle', 255, 1;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_M2Upgrade" && pb_plasmarifle_filter & DisablePB_M2Upgrade)
			return false;
		if(toSpawn == "PB_DTechRifle" && pb_plasmarifle_filter & DisablePB_DTechRifle)
			return false;
		return true;
	}
}

class PB_PlasSpawnerDW : PB_WeaponSpawner
{
	Default
	{
		DropItem 'PB_M1Plasma', 255, 5;
		DropItem 'PB_M2Plasma', 255, 4;
		DropItem 'PB_CryoRifle', 255, 18;
		//DropItem "PB_PulseCannon", 255, 1; //UNCOMMENT WHEN PULSE CANNON IS ADDED
		DropItem 'PB_M2Upgrade', 255, 2;
		DropItem 'PB_DTechRifle', 255, 21;
	}
	
	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PB_M2Plasma" && pb_plasmarifle_filter & DisablePB_M2Plasma)
			return false;
		if(toSpawn == "PB_CryoRifle" && pb_plasmarifle_filter & DisablePB_CryoRifle)
			return false;
		if(toSpawn == "PB_PulseCannon" && pb_plasmarifle_filter & DisablePB_PulseCannon)
			return false;
		if(toSpawn == "PB_CryoRifle" && pb_plasmarifle_filter & DisablePB_CryoRifle)
			return false;
		if(toSpawn == "PB_PulseCannon" && pb_plasmarifle_filter & DisablePB_PulseCannon)
			return false;
		if(toSpawn == "PB_M2Upgrade" && pb_plasmarifle_filter & DisablePB_M2Upgrade)
			return false;
		if(toSpawn == "PB_DTechRifle" && pb_plasmarifle_filter & DisablePB_DTechRifle)
			return false;
		return true;
	}
}
