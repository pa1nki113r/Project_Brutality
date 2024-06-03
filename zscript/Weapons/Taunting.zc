Class PB_TauntWeapon : PB_WeaponBase//weapon
{
	Weapon PrevWeapon;
	
	states
	{
		//this is just for precaution, so you can drop it in case of some error
		Spawn:
			TNT1 A 1;
			stop;
		
		Fire:
		Deselect:
		Select:
		Ready:
			TNT1 A 0 A_weaponoffset(0,32);
			TNT1 A 0{
				if(invoker.PrevWeapon)
					player.pendingweapon = invoker.PrevWeapon;
					
				//this was in the taunt state of the pb weapons, just added the A_zoomfactor
				A_ClearOverlays(10,11);
				A_ClearOverlays(3,4);
				A_TakeInventory("Zoomed", 1);
				A_Gunflash("Null");
				A_zoomfactor(1.0);
			}
			TNT1 A 0 A_jump(256,"FlipOffLeft","FlipOffRight","FlipOffBoth");
			
		FlipOffLeft:
			FUCK A 1;
			FUCK B 1
			{
				A_StartSound("FUCK",90);
				A_SpawnItem("PB_TauntAlertDummy", 0, 100, 0);
			}
			FUCK C 1;
			FUCK D 15;
			FUCK CBA 1;
			TNT1 A 0 A_weaponoffset(0,32);
			TNT1 A 0 A_lower(120);
			wait;
			
		FlipOffRight:
			FUCK F 1;
			FUCK G 1
			{
				A_StartSound("FUCK",90);
				A_SpawnItem("PB_TauntAlertDummy", 0, 100, 0);
			}
			FUCK HI 1;
			FUCK J 15;
			FUCK IHGF 1;
			TNT1 A 0 A_weaponoffset(0,32);
			TNT1 A 0 A_lower(120);
			wait;
			
		FlipOffBoth:
			FUCK K 1;
			FUCK L 1
			{
				A_StartSound("FUCK",90);
				A_SpawnItem("PB_TauntAlertDummy", 0, 100, 0);
			}
			FUCK MN 1;
			FUCK O 15;
			FUCK NMLK 1;
			TNT1 A 0 A_weaponoffset(0,32);
			TNT1 A 0 A_lower(120);
			wait;	
	}
}

Class PB_TauntAlertDummy : PB_Monster
{
	Default
	{
		+LOOKALLAROUND
		+FRIENDLY
		+SHOOTABLE;
		-SOLID;
		Radius 1;
		Height 1;
	}
	
	States
	{
		Spawn:
			TNT1 A 0 NODELAY;
			TNT1 A 5;
			TNT1 A 0 A_AlertMonsters(0, AMF_TARGETEMITTER);
		SpawnLoop:
			TNT1 A 10 A_Look();
			Loop;
		See:
			TNT1 A 0;
			TNT1 A 10;
			Stop;
		Death:
		XDeath:
			TNT1 A 0;
			TNT1 A -1;
			Stop;
	}
}