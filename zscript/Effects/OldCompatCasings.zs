// i cannot be bothered to fix the formatting on this piece of shit

Class RifleCaseSpawn : Actor
{
		override void BeginPlay(void)
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings(self);
		Super.BeginPlay();
	}
	Default
  {Speed 20;
	PROJECTILE;
	+NOCLIP;
	//+CLIENTSIDEONLY;
  }
	States
	{
	Spawn:
        TNT1 A 0;
		TNT1 A 1 A_SpawnProjectile("PB_EmptyBrass",-5,0,random(-80,-100),CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH,random(45,80));
		Stop;
	}
}

Class Mp40CaseSpawn : Actor
{
	override void BeginPlay(void)
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings(self);
		Super.BeginPlay();
	}

	Default
  {
  Speed 20;
	PROJECTILE;
	+NOCLIP;
	//+CLIENTSIDEONLY;
  }
	States
	{
	Spawn:
        TNT1 A 0;
		TNT1 A 1 A_SpawnProjectile("EmptyBrassMP40",-5,0,random(80, 100),CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH,random(45,80));
		Stop;
	}
}

Class ShotCaseSpawn : RifleCaseSpawn
{
	States
	{
	Spawn:
	    TNT1 A 0 ;
		//TNT1 A 1 A_SpawnProjectile("ShotgunCasing",0,0,random(-80,-100),CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH,random(40,60));
		TNT1 A 1 A_SpawnItemEX("ShotgunCasing",0,0,-7,frandom(3,5),frandom(3,4),frandom(8,11));
		Stop;
	}
} 

Class MastermindCaseSpawn : Actor
{
		override void BeginPlay(void)
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings(self);
		Super.BeginPlay();
	}
  Default
  {Speed 20;
	PROJECTILE;
	+NOCLIP;
	//+CLIENTSIDEONLY;
  }
	States
	{
	Spawn:
        TNT1 A 0;
		TNT1 A 1 A_SpawnProjectile("PB_GiantEmptyBrass",-5,0,random(-80,-100),CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH,random(45,80));
		Stop;
	}
}
