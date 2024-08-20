// i cannot be bothered to fix the formatting on this piece of shit

Class SSGCaseSpawner : RifleCaseSpawn
{
		States
		{
		Spawn:
			TNT1 A 0;
			TNT1 A 0 Thing_ChangeTID(0,390);
			TNT1 A 1 A_SpawnProjectile("ShotgunCasingSSG",0,0,random(80,100),CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH,random(50,70));
			Stop;
        /*Goto Death
		Death:
				TNT1 A 0 A_SpawnProjectile("ShotgunCasingSSG",0,0,random(80,100),CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH,random(50,70));
				Stop;*/
		}
}

Class SMGCasingSpawner : Actor
{
		override void BeginPlay(void)
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings();
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
		TNT1 A 1 A_SpawnProjectile("EmptyBrassSMG",-5,0,random(-70, -100),CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH,random(25,50));
		Stop;
	}
}

Class RifleCaseSpawn : Actor
{
		override void BeginPlay(void)
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings();
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
		NashGoreStatics.QueueCasings();
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
		NashGoreStatics.QueueCasings();
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
