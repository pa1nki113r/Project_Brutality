Class PB_Shotgun : PB_WeaponBase
{
	default
	{
		//$Title Pump Action Shotgun
		//$Category Project Brutality - Weapons
		//$Sprite SHTCA0
		//SpawnID 9300;
		Weapon.SelectionOrder 1300;
		weapon.slotnumber 3;							
		weapon.ammotype1 "PB_Shell";
		weapon.ammogive1 8;		
		weapon.ammotype2 "PB_ShotgunMag";
		weapon.slotpriority 0.5;
		inventory.pickupsound "SHOTPICK";
		inventory.pickupmessage "$PB_SG_PICKUP";
		Tag "$PB_SG_TAG";
		Scale 0.45;
		FloatBobStrength 0.5;
		Inventory.AltHUDIcon "SHTCA0";
		PB_WeaponBase.UsesWheel true;					
		PB_WeaponBase.WheelInfo "PB_PumpShotgunWheel";
		PB_WeaponBase.TailPitch 1.5;
	}
	
	int ShellsMode;
	int LastMode; //need this so the upgrade kicks out the right shells when switching
	const Shell_Buck = 1;
	const Shell_Slug = 2;
	const Shell_Drag = 3;
	
	states
	{
		loadsprites:
			SHTS ABCDJKLMNOP 0; // Virtualize Sprites in gzdoom's memory
			SHTD ABCDJKLMNOP 0;
			SHMS BCDEFGSTUVWX 0;
			SHMD BCDEFGSTUVWX 0;
			SHZA DEFGHIJKLMNO 0;
			SHZB DEFGHIJKLMNO 0;
			SHT4 DFGHIJKLMN 0;
			SHT6 DFGHIJKLMN 0;
			stop;
			
		Spawn:
			VHTC A 0 NoDelay;
			SHTC A 10 A_PbvpFramework("VHTC");
			"####" A 0 A_PbvpInterpolate();
			loop;
		
		WeaponRespect:
			TNT1 A 0 {
				A_SetCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",1);
				A_StartSound("weapons/shotgun/equip", 10,CHANF_OVERLAP);
			}
			SH00 ABCDEFGHI 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTZ ABC 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTZ DEFGHIJ 1 {
				PB_SetShellSprite("SHTZ","SHZA","SHZB");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			TNT1 A 0 A_StartSound("weapons/shotgun/attach", 10,CHANF_OVERLAP);
			SHTZ KL 1 {
				PB_SetShellSprite("SHTZ","SHZA","SHZB");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			SHTZ M 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTZ NOP 1 {
				PB_SetShellSprite("SHTZ","SHZA","SHZB");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			SH0G A 1 {
				PB_SetShellSprite("SH0G","SHTS","SHTD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			SH0G BCDEFGHIJ 1 A_DoPBWeaponAction(WRF_NOBOB);
			SSHR H 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 A_StartSound("weapons/sgmvpump",10,CHANF_OVERLAP);
			SH0G L 5 A_DoPBWeaponAction(WRF_NOBOB);
			SSHR I 1 A_DoPBWeaponAction(WRF_NOBOB);
			SSHR JK 1 {
				PB_SetShellSprite("SSHR","SHTS","SHTD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			SSHR L 1 {
				PB_SetShellSprite("SSHR","SHTS","SHTD");
				A_StartSound("insertshell", 10,CHANF_OVERLAP); 
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			SSHR MNOPP 1 {
				PB_SetShellSprite("SSHR","SHTS","SHTD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			TNT1 A 0 A_StartSound("weapons/sgpump",10,CHANF_OVERLAP);
			TNT1 A 0 A_JumpIfInventory("PumpShotgunMagazine", 1, "InsertMagBegin"); //Activates when the magazine upgrade is already collected before going to the next level.
			SSHR A 1 A_DoPBWeaponAction(WRF_NOBOB);
			SSHR BCD 1 {
				PB_SetShellSprite("SSHR","SHTS","SHTD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			TNT1 A 0 A_StartSound("insertshell", 10,CHANF_OVERLAP);
			SSHR EFG 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagNotInserted", 1, "InsertMagBegin");
			SH0G JIHGFEDCB 1 A_DoPBWeaponAction(WRF_NOBOB);
			Goto Ready3;
		
		InsertMagBegin: // Straight Into Inserting The Mag After Chambering a shell. 
			TNT1 A 0 {
				A_SetInventory("PumpshotgunMagNotInserted",0);
				A_GiveInventory("PB_ShotgunMag",11);
				A_SetInventory("PumpShotgunMagazine",1);
				A_SetCrosshair(-1);
			}
			SHTM A 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTM BCDEFG 1 {
				PB_SetShellSprite("SHTM","SHMS","SHMD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
		BeginInsertion:	
			SHTM H 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 A_StartSound("weapons/shotgunmag/magin", 3);
			SHTM I 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTM JKLMNOPQR 1 A_DoPBWeaponAction(WRF_NOBOB);
			SH0G EDCB 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 A_JumpIfInventory("PumpShotgunMagazine", 2, "Ready3");
			Goto Ready3;
		InsertMagShotgunRespectAlreadyRespected:
			TNT1 A 0 {
				A_SetInventory("PumpshotgunMagNotInserted",0);
				A_GiveInventory("PB_ShotgunMag",11);
				A_SetInventory("PumpShotgunMagazine",1);
				A_ZoomFactor(1.0);
				A_SetInventory("Zoomed",0);
				A_SetInventory("ADSmode",0);
			}
			SH0G BCDEFGH 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTM A 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTM BCDEFG 1 {
				PB_SetShellSprite("SHTM","SHMS","SHMD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			Goto BeginInsertion;
		
		Select:
			TNT1 A 0 PB_WeaponRaise();
			TNT1 A 0 PB_HandleSGCrosshair();
			TNT1 A 0 PB_WeapTokenSwitch("ShotgunSelected");
			TNT1 A 0 A_SetInventory( "RandomHeadExploder", 1);
		Ready:
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_StartSound("weapons/shotgun/equip", 10,CHANF_OVERLAP);
			SH0D ABCD 1;
			goto ready3;
		
		Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory( "RandomHeadExploder", 0 );
			}
			TNT1 A 0
			{
				 A_SetInventory("Unloading",0);
				 A_SetInventory("Zoomed",0);
				 A_SetInventory("ADSmode",0);
				 A_ZoomFactor(1.0);
			}
			SH00 HGED 1;
			TNT1 A 0 A_lower(120);
			wait;
		
		
		Ready3:
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleSGCrosshair();
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("CantWeaponSpecial",0);
				A_SetInventory("CantDoAction",0);
				}
			TNT1 A 0 
			{
				if(CountInv("SG_IsSwapping")>=1)
				{
					A_SetInventory("SelectShotgun_Buckshot", 0);
					A_SetInventory("SelectShotgun_Slugshot", 0);
					A_SetInventory("SelectShotgun_Dragonsbreath", 0);
					A_SetInventory("SG_IsSwapping", 0);
					A_SetInventory("SelectShotgun_No", 0);
					A_Setinventory("CantWeaponSpecial",0);
				}
			}
			TNT1 A 0 A_JumpIfInventory("Zoomed",1,"Ready2");
		ReadyToFire:
			SH0G A 1
			{
				PB_CoolDownBarrel(0,0,-4);
				PB_SetShellSprite("SH0G","SHTS","SHTD");
				// This token is given upon picking up the magazine upgrade.
				if (CountInv("PumpshotgunMagNotInserted") >= 1 ) 
					return resolvestate("InsertMagShotgunRespectAlreadyRespected");  // Insert magazine upon picking it up
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);	 
			}
			Loop;
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleSGCrosshair();
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 PB_jumpIfNoAmmo();
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"Fire2");
			SH0F A 0;
			SH1F A 0;
			SH2F A 0;
			SH0F A 1 BRIGHT 
			{
				PB_IncrementHeat(3);
				PB_SetShellSprite("SH0F","SH1F","SH2F");
				A_SetInventory("CantDoAction",1);
				PB_LowAmmoSoundWarning("shotgun");
				if(CountInv("PumpshotgunMagazine") == 1) PB_TakeAmmo("PB_ShotgunMag", 1);
				else PB_TakeAmmo("PB_ShotgunMag", 1,0);
				PB_SetChamberEmpty(true);
				A_AlertMonsters();
				A_fireprojectile("YellowFlareSpawn", 0, 0, 0, 0);
				_SpawnMuzzleSparksSG(0,0,-4);
				PB_GunSmoke_Sniper(1,0,-4);
                PB_MuzzleFlashEffects(0,0,-4);
				A_Overlay(-6, "ShotFlash",true);
				A_OverlayFlags(-6,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-6,STYLE_Add);
				//A_GunFlash();
				PB_DynamicTail("shotgun", "shotgun");
				switch(getshellsmode())
				{
					case Shell_Buck:	
						A_StartSound("weapons/sg", CHAN_WEAPON, pitch:frandom(0.95, 1.05));
						PB_FireBullets("PB_12GAPellet",9,1.5,0,0,1.5);
						break;
					case Shell_Slug:
						A_StartSound("SlugShot", CHAN_WEAPON, pitch:frandom(0.95, 1.05));
						A_FireProjectile("PB_12GASlug", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
						break;
					case Shell_Drag:
						A_StartSound("DRBTFIRE", CHAN_WEAPON, pitch:frandom(0.95, 1.05));
						PB_FireBullets("PB_DragonsBreathTracer",8,4.5,0,-14,4.5);
						break;
				}
				A_ZoomFactor(0.98);
			}
			SH0F B 1 PB_SetShellSprite("SH0F","SH1F","SH2F");
			SH0F C 1 {
				A_FireProjectile("ShotgunWad",random(-2,2),0,random(-2,2),-4,FPF_NOAUTOAIM,random(-2,2));
				PB_WeaponRecoil(-1.24,+0.44);
				A_ZoomFactor(1.0);
			}
			SH0F G 1 PB_WeaponRecoil(-1.24,+0.44);
			SH0F FED 1;
			
		Pump:
		Pump1:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				PB_HandleSGCrosshair();
				PB_SetReloading(true);
			}
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagPump");
			TNT1 A 0 A_JumpIfInventory("PB_PowerStrength",1,"PumpFromHip");
			SH0G BCDEFGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
		P1Begin:
			SHTA K 0;
			SH0F K 0;
			SH0G K 1
			{
				PB_SetShellSprite("SH0G","SHTA","SH0F");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgmvpump",30,CHANF_OVERLAP); 
			}
		//P1B:
			TNT1 A 0
			{
				switch(getshellsmode())
				{
					case 1:	PB_SpawnCasing("ShotgunCasing",15,-5,26,0,3,3);		break;
					case 2:	PB_SpawnCasing("ShotgunCasing2",15,-5,26,0,3,3);	break;
					case 3:	PB_SpawnCasing("ShotgunCasing3",15,-5,26,0,3,3);	break;
				}
				if(!PB_GetMagEmpty()) {PB_SetChamberEmpty(false);}
			}
		//P1C:
			SH0G L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SH0G M 2;
			SH0G L 1
			{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 {
                A_StartSound("weapons/sgpump",11,CHANF_OVERLAP); 
            }
			SH0G K 1 
			{
				if(CountInv("PB_ShotgunMag") < 1)
					A_SetWeaponFrame(25);
				else
					PB_SetShellSprite("SH0G","SHTA","SH0F");
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				//A_StartSound("weapons/sgpump", 10,CHANF_OVERLAP);
			// return resolvestate(null);
			}
			SH0G JIHGFEDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
		PumpEnd: // Pump End for mag & regular.
			TNT1 A 0
			{
				A_SetRoll(0,SPF_INTERPOLATE);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			SH0G A 1
			{
				PB_SetShellSprite("SH0G","SHTS","SHTD");
				A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				A_Refire();
				A_SetInventory("CantDoAction",0);
				PB_SetReloading(false);
				//return resolvestate(null);
			}
			Goto Ready3;
		MagPumpFromReady:
			TNT1 A 0 PB_HandleSGCrosshair();
			Goto PumpFromHipFromReady;
		MagPump:
			Goto PumpFromHip;
			TNT1 A 0 A_WeaponOffset(0,32);
			SH0G BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			SHMG FGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			SHMA K 0;
			SHMF K 0;
			SHMG K 1 
			{
				PB_SetShellSprite("SHMG","SHMA","SHMF");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgmvpump",31,CHANF_OVERLAP); 
			}
		MagP1B:	
			TNT1 A 0
			{
				switch(getshellsmode())
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasing",25,-5,19,0,3,3);	break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasing2",25,-5,19,0,3,3);	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasing3",25,-5,19,0,3,3);	break;
				}
				if(!PB_GetMagEmpty()) {PB_SetChamberEmpty(false);}
			}
		MagP1C:	
			SHMG L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SH0G M 2;
			SHMG L 1 
			{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			SHMG N 0;
			SHMG K 1 
			{
				if(CountInv("PB_ShotgunMag") < 1)
					A_SetWeaponFrame(13);
				else
					PB_SetShellSprite("SHMG","SHMA","SHMF");
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgpump", 11,CHANF_OVERLAP);
			}	
			SHMG JIHGF 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SH0G EDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			Goto PumpEnd;
		PumpFromHipFromReady:
			SH0F CDEF 1;
		PumpFromHip:
			TNT1 A 0 A_StartSound("weapons/sgmvpump",11,CHANF_OVERLAP);
			SHSP ABC 1;
			TNT1 A 0
			{
				switch(getshellsmode())
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasing",21,3,24,0,3,3);	break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasing2",21,3,24,0,3,3);	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasing3",21,3,24,0,3,3);	break;
				}
				if(CountInv("PB_ShotgunMag") > 0 && !PB_GetMagUnloaded()) {PB_SetChamberEmpty(false);}
			}
			SHSP CBA 1;
			TNT1 A 0 A_StartSound("weapons/sgpump",11,CHANF_OVERLAP);
			SH0F GFEDC 1;
			TNT1 A 0 A_Refire();
			goto Ready3;
		
		
		AltFire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleSGCrosshair();
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"zoomout");
			TNT1 A 0 {
				 A_WeaponOffset(0,32);
				 A_StartSound("IronSights", 10,CHANF_OVERLAP);
				 A_SetInventory("Zoomed",1);
				 A_ZoomFactor(1.25);
				 A_SetCrosshair(-1);
			}
			SHT8 EEDK 1 PB_SetShellSprite("SHT8","SHT6","SHT4");
			Goto Ready2;
		Zoomout:	
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_ZoomFactor(1.0);
			}
			SHT8 KDEE 1 PB_SetShellSprite("SHT8","SHT6","SHT4");
			TNT1 A 0 PB_HandleSGCrosshair();
			Goto Ready3;
		
		ReloadWithNoAmmoLeft:
		Reload:
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine",1,"MagReload");
			TNT1 A 0 PB_CheckReload(null,null,"Pump","Ready3","Ready3",9);
			TNT1 A 0 A_WeaponOffset(0,32);
			SH0G BCDEFGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
		ShellChecker:
			TNT1 A 0 A_JumpIf(CountInv("PB_Shell") < 1 || countinv("PB_ShotgunMag") >= 9,"ReloadFinished");
			SSHR A 1 {
				A_DoPBWeaponAction(WRF_NOSECONDARY);
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "ChamberInsertShell");
			SSHR BC 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 {
				A_StartSound("insertshell", 10,CHANF_OVERLAP);
				A_Giveinventory("PB_ShotgunMag",1);
				A_Takeinventory("PB_Shell",1);
			}
			SSHR D 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			SSHR E 1 A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
			SSHR FG 1 {
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOSECONDARY);
			}
			TNT1 A 0 A_DoPBWeaponAction(WRF_NOBOB);
			loop;
		ChamberInsertShell:
			SSHR A 1 A_DoPBWeaponAction(WRF_NOSECONDARY);
			SSHR H 2 A_StartSound("weapons/sgmvpump",10,CHANF_OVERLAP);
			SSHR I 3 A_StartSound("insertshell",10,CHANF_OVERLAP);
			SSHR JKLMNOPP 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 
			{
				A_StartSound("weapons/sgpump",10,CHANF_OVERLAP);
				A_Giveinventory("PB_ShotgunMag",1);
				A_Takeinventory("PB_Shell",1);
				PB_SetChamberEmpty(false);
				PB_SetMagEmpty(false);
			}
			Goto ShellChecker;
		
		ReloadFinished:
			SSHR A 1;
			SH0G JIHGFEDCBA 1
			{
				A_DoPBWeaponAction(WRF_NOBOB);
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			}	
			TNT1 A 0
			{
				A_SetInventory("Reloading",0);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetRoll(0,SPF_INTERPOLATE);
				PB_SetReloading(false);
			}
			Goto Ready3;
		
		MagReload:
			TNT1 A 0 PB_CheckReload(null,null,"MagPumpFromReady","Ready3","Ready3",11);
			SH0G BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"toinsert");
			SHMG FGHI 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			Goto ActuallyBeginMagReload;
		toinsert:
			SH0G GH 1;
			Goto InsertMag;
		ActuallyBeginMagReload:
			SHTN ABCDEFG 1;
			TNT1 A 0 A_StartSound("weapons/shotgunmag/magout", 10,CHANF_OVERLAP);
			TNT1 A 0 PB_SetMagUnloaded(true);
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(),"EmptyMagReload");
			SHTM GFEDCB 1 PB_SetShellSprite("SHTM","SHMS","SHMD");
			goto InsertMag;
			
		EmptyMagReload:
			SHTN GHIJKL 1;
			TNT1 A 0 PB_SpawnCasing("EmptyClipMP40", 45.6, 9, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
			//TNT1 A 0 A_FireCustomMissile("EmptyClipMP40",-5,0,8,-4);
		InsertMag:
			SHTM A 4;
			SHTM BCDEFG 1 PB_SetShellSprite("SHTM","SHMS","SHMD");
			TNT1 A 0 {
				if(PB_GetChamberEmpty())
					PB_AmmoIntoMag("PB_ShotgunMag","PB_Shell",10,1);
				else
					PB_AmmoIntoMag("PB_ShotgunMag","PB_Shell",11,1);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				return ResolveState(null);
			}
			SHTM H 1 A_StartSound("weapons/shotgunmag/magin", 10,CHANF_OVERLAP);
			SHTM I 1;
			SHTM JKLM 1;
			SHTM N 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIf(!PB_GetChamberEmpty(),"ReloadMagFinished");
		LoadChamberMag:
			SHMA K 0;
			SHMF K 0;
			SHMG N 1 
			{
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgmvpump",10,CHANF_OVERLAP); 
			}
			SHMG L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SH0G M 2;
			SHMG L 1 
			{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			SHMG K 1 
			{
				PB_SetChamberEmpty(false);
				PB_SetShellSprite("SHMG","SHMA","SHMF");
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgpump", 10,CHANF_OVERLAP);
			}	
			SHMG J 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIf(PressingReload() && CountInv("PB_Shell"), "ActuallyBeginMagReload");
		ReloadMagFinished:
			SHTM OPQR 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SH0G EDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0
			{
				A_SetInventory("Reloading",0);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetRoll(0,SPF_INTERPOLATE);
				PB_SetReloading(false);
			}
			TNT1 A 0 A_Refire();
			Goto Ready3;
		
		
		Weaponspecial:
			TNT1 A 0 A_takeinventory("GoWeaponSpecialAbility",1);	//avoid infinite loops
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			TNT1 A 0 A_zoomfactor(1.0);
			//TNT1 A 0 A_JumpIfInventory("Zoomed",1,"Ready2");
			SHZA ABCDEFGHIJKLMNOP 0;
			SHZB ABCDEFGHIJKLMNOP 0;
			goto HandleUpgradeSpecial;
		HandleUpgradeSpecial:
			TNT1 A 0 pb_handlewheel();
			Goto AltTubeAmmoSwap;
			SHTZ PON 1 PB_SetShellSprite("SHTZ","SHZA","SHZB");
			SHTZ M 1;
			TNT1 A 0 A_StartSound("weapons/shotgun/detach", 10,CHANF_OVERLAP);
			SHTZ LKJIHGFED 1 PB_SetShellSprite("SHTZ","SHZA","SHZB");
			SHTZ CBAABC 1;
			TNT1 A 0 {
				if(CountInv("SelectShotgun_Buckshot") >= 1)
					setShellsMode(Shell_Buck);
				if(CountInv("SelectShotgun_Slugshot") >= 1) 
					setShellsMode(Shell_Slug);
				if(CountInv("SelectShotgun_Dragonsbreath") >= 1) 
					setShellsMode(Shell_Drag);
			}
			SHTZ DEFGHIJKL 1 PB_SetShellSprite("SHTZ","SHZA","SHZB");
			SHTZ M 1;
			TNT1 A 0 A_StartSound("weapons/shotgun/attach", 10,CHANF_OVERLAP);
			SHTZ NOP 1 PB_SetShellSprite("SHTZ","SHZA","SHZB");
			SH0G A 1 PB_SetShellSprite("SH0G","SHTS","SHTD");
			TNT1 A 0 pb_postwheel();
			goto ready3;
		
		CancelWheel:
			//TNT1 A 1;
			TNT1 A 0 pb_postwheel();
			goto ready3;
		
		Unload:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIf(CountInv("PumpshotgunMagazine") == 0 && PB_GetMagEmpty(),"Ready3");
			SH0G BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIf(CountInv("PumpshotgunMagazine") == 1 && !PB_GetMagUnloaded(),"MagUnload");
			SH0G FGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			
		ActuallyUnload:
			TNT1 A 0 A_JumpIf(CountInv("PB_ShotgunMag") <= 0,"FinishUnload");
			TNT1 A 0 A_StartSound("weapons/sgmvpump");
			SH0G K 1 
			{
				PB_SetShellSprite("SH0G","SHTA","SH0F");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SH0G L 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SH0G M 1;
			SH0G L 1 {
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			//TNT1 A 0 A_JumpIfInventory("PB_Shell", 1,3);
			SSHR H 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);// So the chamber shows as being empty
			TNT1 A 0; //{ return resolvestate (2); } 			 // Skip This Frame if the shotgun isn't loaded.
			SH0G K 1 {
				if(CountInv("PB_ShotgunMag") < 1)
					A_SetWeaponFrame(25);
				else
					PB_SetShellSprite("SH0G","SHTA","SH0F");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SH0G J 1 {
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgpump", 19,CHANF_OVERLAP);
				switch(getshellsmode())
				{
					case Shell_Buck:	
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,CountInv("PB_ShotgunMag") - 1,"PB_SingleShell");
						break;
					case Shell_Slug:
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,CountInv("PB_ShotgunMag") - 1,"PB_SingleShellSlug");
						break;
					case Shell_Drag:
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,CountInv("PB_ShotgunMag") - 1,"PB_SingleShellDragonsBreath");
						break;
				}
				if(CountInv("PB_ShotgunMag") < 1) {PB_SetChamberEmpty(true); PB_SetMagEmpty(true);}
			}
			goto ActuallyUnload;
		
		FinishUnload:
			SH0G IHGFEDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0 {
				A_SetRoll(0,SPF_INTERPOLATE);
				PB_SetReloading(false);
			}
			Goto Ready3;
		
		MagUnload:
			SHMG FGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			SHTN ABCDEFG 1;
			TNT1 A 0 {
				switch(getshellsmode())
				{
					case Shell_Buck:	
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,1,"PB_SingleShell");
						break;
					case Shell_Slug:
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,1,"PB_SingleShellSlug");
						break;
					case Shell_Drag:
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,1,"PB_SingleShellDragonsBreath");
						break;
				}
				A_StartSound("weapons/shotgunmag/magout", 10,CHANF_OVERLAP);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			SHTN HIJKL 1;
			Goto ActuallyUnload;
			
		
		
		//
		//
		//	ADS stuff
		//
		//
		
		Ready2:
			TNT1 A 0 {
				A_SetRoll(0);
				A_SetCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:
			SHT8 A 1
			{		
				PB_CoolDownBarrel(0,-2,6);
				PB_SetShellSprite("SHT8","SHT6","SHT4");
				if (CountInv("PumpshotgunMagNotInserted") >= 1 ) 
					return resolvestate("InsertMagShotgunRespectAlreadyRespected"); 
							
				//Updated code for far superior smooth gameplay
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					
					if (PressingFire() && PressingAltfire() && CountInv("PB_ShotgunMag") > 0)
							return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				}
				else 
				{
					if (PressingFire() && CountInv("PB_ShotgunMag") > 0 )
						return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
			}
			Loop;
		
		Fire2:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetCrosshair(-1);
				}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			TNT1 A 0 
			{
				PB_IncrementHeat();
				 A_AlertMonsters();
				 A_Fireprojectile("YellowFlareSpawn", 0, 0, 0, 0);
				 PB_LowAmmoSoundWarning("shotgun");
				if(CountInv("PumpshotgunMagazine") == 1) PB_TakeAmmo("PB_ShotgunMag", 1);
				else PB_TakeAmmo("PB_ShotgunMag", 1,0);
				 _SpawnMuzzleSparksSG(0,0,-4);
				 _SpawnMuzzleSparksSG(0,0,-4);
				 PB_GunSmoke_Sniper(1,0,0);
                 PB_MuzzleFlashEffects(0,0,0);
				 PB_DynamicTail("shotgun", "shotgun");
				 A_SetInventory("CantDoAction",1);
				 
				switch(getshellsmode())
				{
					case Shell_Buck:	
						A_StartSound("weapons/sg", CHAN_WEAPON, pitch:frandom(0.95, 1.05));
						PB_FireBullets("PB_12GAPellet",9,1.5,0,0,1.5);
						break;
					case Shell_Slug:
						A_StartSound("SlugShot", CHAN_WEAPON, pitch:frandom(0.95, 1.05));
						A_FireProjectile("PB_12GASlug", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
						break;
					case Shell_Drag:
						A_StartSound("DRBTFIRE", CHAN_WEAPON, pitch:frandom(0.95, 1.05));
						PB_FireBullets("PB_DragonsBreathTracer",8,4.5,0,-14,4.5);
						break;
				}
				  
			}
			
		AltFireAnimBegin:	
			SHT8 F 1 BRIGHT
			{
				PB_SetShellSprite("SHT8","SHT6","SHT4");
				A_Fireprojectile("ShotgunWad",random(-2,2),0,random(-2,2),-3,FPF_NOAUTOAIM,random(-2,2)); //Keeping the shotgun wad projectile
				PB_WeaponRecoil(-0.3,-0.25);
			}
			TNT1 A 0 A_JumpIf((CountInv("PB_PowerStrength") || CountInv("PumpshotgunMagazine")), "BerserkAltPump1");
			SHT8 GHI 1
			{
				PB_SetShellSprite("SHT8","SHT6","SHT4");
				PB_WeaponRecoil(-1,0);
			}
			TNT1 A 0 {
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint()) 
				{
					if (!PressingAltfire() && CountInv("PB_ShotgunMag") > 1)
					{
						A_SetInventory("Zoomed",0);
						A_ZoomFactor(1.0);
						PB_HandleSGCrosshair();
						return resolvestate("Pump1");
					}
				}
				return resolvestate(null);
			}
			//Goto AltPump1;
		AltPump1:
			TNT1 A 0 A_Startsound("weapons/sgmvpump",23,CHANF_OVERLAP);
			SHT8 IHGJKLMN 1 PB_SetShellSprite("SHT8","SHT6","SHT4");				
		AltPump1B:	 
			SHT8 OPQR 1;
			TNT1 A 0 {
				switch(getshellsmode())
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasing",18,3,30,0,3,3);	break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasing2",18,3,30,0,3,3);	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasing3",18,3,30,0,3,3);	break;
				}
			}
		AFP1E:	 
			TNT1 A 0 A_Startsound("weapons/sgpump",32,CHANF_OVERLAP);
			SHT8 STQO 1;
			SHT8 NMLKJ 1 PB_SetShellSprite("SHT8","SHT6","SHT4");
			SHT8 A 1
			{
				A_SetInventory("CantDoAction",0);
				PB_SetShellSprite("SHT8","SHT6","SHT4");
				 
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint()) 
				{
					if(JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					if (JustPressed(BT_ATTACK) && PressingAltfire())
							return resolvestate("Fire2");
				}
				else 
				{
					if(PressingAltfire())
						return resolvestate("Zoomout");
					if (JustPressed(BT_ATTACK))
							return resolvestate("Fire2");
					A_Refire("Fire2");
				}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			Goto Ready2;
		
		
		BerserkAltPump1:
			TNT1 A 0 A_Startsound("weapons/sgmvpump",11,CHANF_OVERLAP);
			SHT8 KLMN 1 PB_SetShellSprite("SHT8","SHT6","SHT4");
			Goto AltPump1B;
		
		
		//
		//	flashes
		//
		ShotFlash:
			TNT1 A 0 A_Jump(256, "Flash1", "Flash2", "Flash3");
		Flash1:
			SH10 AB 1 BRIGHT A_GunFlash();
			Stop;
		Flash2:
			SH10 CD 1 BRIGHT A_GunFlash();
			Stop;
		Flash3:
			SH10 EF 1 BRIGHT A_GunFlash();
			Stop;
		
		
		FlashKicking:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashKick");
			SH0G CDFGHI 1;
			SH0G J 2;
			SH0G IHGEDB 1;
			Goto Ready3;
		
		MagFlashKick:
			SH0G CD 1;
			SHMG FGH 1;
			SHMG I 1;
			SHMG J 2;
			SHMG IHG 1;
			SH0G EDB 1;
			Goto Ready3;
			
		FlashAirKicking:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashAirKick");
			SH0G CDFGHI 1;
			SH0G J 4;
			SH0G IHGEDBB 1;
			Goto Ready3;
		
		MagFlashAirKick:
			SH0G CD 1;
			SHMG FGHI 1;
			SHMG I 4;
			SHMG IHG 1;
			SH0G EDBB 1;
			Goto Ready3;
			
		FlashSlideKicking:
			TNT1 A 0 A_WeaponOffset(0,32);
			SH0G CD 1;
			SH0G FGHIJJJJJJJJJJJJJIHGE 1 {if(CountInv("PumpshotgunMagazine") == 1) A_SetWeaponSprite("SHMG");}
			SH0G DB 1;
			Goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashSlideKickingStop");
			SH0G JIHGEDB 1;
			Goto Ready3;
		
		MagFlashSlideKickingStop:
			SHMG JIHGE 1;
			SH0G DB 1;
			Goto Ready3;
			
		FlashPunching:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashPunch");
			SH0G CDFGHI 1;
			SH0G J 2;
			SH0G IHGEDB 1;
			Goto Ready3;
		MagFlashPunch:
			SH0G CD 1;
			SHMG FGH 1;
			SHMG I 1;
			SHMG J 2;
			SHMG IHG 1;
			SH0G EDB 1;
			Goto Ready3;
		
		//alternative ammo swap thing
		//Start of transplant
		AltTubeAmmoSwap:
			TNT1 A 0 {
				PB_SetReloading(true);
				A_Setinventory("CantWeaponSpecial", 1);
				A_SetCrosshair(-1);
			}
			TNT1 A 0 A_JumpIfInventory("DragonBreathUpgrade",1,"AltMagAmmoSwap");
			TNT1 A 0 {
			 If((CountInv("PB_Shell") < 1) && (CountInv("PB_ShotgunMag") <=2)) 
				{
					A_Setinventory("SelectShotgun_Buckshot", 0); 
					A_Setinventory("SelectShotgun_Slugshot", 0); 
					A_Setinventory("SelectShotgun_Dragonsbreath", 0);
					A_Setinventory("SelectShotgun_No", 0);
					A_Setinventory("CantWeaponSpecial",0);
					return resolvestate("Ready3");
				}
				return resolvestate(null);
			}
			TNT1 A 0 A_SetInventory("SG_IsSwapping",1);
			SH0G BCDEFGHI 1;
			TNT1 A 0 A_JumpIf(CountInv("PB_ShotgunMag") >= 1,"EmptyTube");
			SH0G I 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SH0G Z 1;
			SH0G L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			goto ClearedChamber;
		EmptyTube:
			//need to add token so if you shoot during this reload it cleans things up
			//also a park token for excess ammo
			TNT1 A 0 A_JumpIf(CountInv("PB_ShotgunMag") == 1,"ClearChamberForTubeSwap");
			TNT1 A 0 A_Startsound("weapons/sgmvpump");
			SH0G K 1{
				PB_SetShellSprite("SH0G","SHTA","SH0F");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SH0G L 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SH0G M 1;
			SH0G L 1 {
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_JumpIfInventory("PB_Shell", 1,3);	//not sure how this is suppossed to work
			SSHR H 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE); // So the chamber shows as being empty
			//TNT1 A 0 { return resolvestate (2); } // Skip This Frame if the shotgun isn't loaded.
			SH0G K 1 {
				PB_SetShellSprite("SH0G","SHTA","SH0F");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SH0G J 1 {
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgpump", 19,CHANF_OVERLAP);
				switch(getshellsmode())
				{
					case Shell_Buck:	
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,CountInv("PB_ShotgunMag") - 1,"PB_SingleShell");
						break;
					case Shell_Slug:
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,CountInv("PB_ShotgunMag") - 1,"PB_SingleShellSlug");
						break;
					case Shell_Drag:
						PB_UnloadMag("PB_ShotgunMag","PB_Shell",1,1,1,CountInv("PB_ShotgunMag") - 1,"PB_SingleShellDragonsBreath");
						break;
				}
			}
			SSHR A 0; //A_Refire
			TNT1 A 0; //A_DoPBWeaponAction(WRF_NOBOB)
			goto EmptyTube;
		ClearChamberForTubeSwap:
			SH0G I 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_WeaponOffset(0,32);
			SH0G J 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			//TNT1 A 0 A_TakeInventory("PB_ShotgunMag",1)
			SH0G K 1 
			{
				PB_SetShellSprite("SH0G","SHTA","SH0F");
				switch(getshellsmode())
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasingRedLive",15,-5,26,0,3,3);	break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasingGreenLive",15,-5,26,0,3,3);	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasingOrangeLive",15,-5,26,0,3,3);	break;
				}
				A_TakeInventory("PB_ShotgunMag",1);
				PB_SetChamberEmpty(true);
				PB_SetMagUnloaded(true);
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgmvpump",19,CHANF_OVERLAP); 
			}		
		ClearedChamber:
			SHTS KLMNOPP 0;
			SHTD KLMNOPP 0;
			SH0G L 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 {
				if (CountInv("SelectShotgun_Buckshot") >= 1)
				{
					setShellsMode(Shell_Buck);
					//A_Print("$PB_SGBUCKLD");
				}
				if (CountInv("SelectShotgun_Slugshot") >= 1)
				{
					setShellsMode(Shell_Slug);
					//A_Print("$PB_SGSLUGLD");
				}
				if (CountInv("SelectShotgun_Dragonsbreath") >= 1)
				{
					setShellsMode(Shell_Drag);
					//A_Print("$PB_SGDBLD");
				}	
				pb_postwheel();
			}
			SSHR I 3 A_Startsound("insertshell",19,CHANF_OVERLAP) ;
			SSHR JKLMNOPP 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 {
				A_Startsound("weapons/sgpump",19,CHANF_OVERLAP);
				A_Giveinventory("PB_ShotgunMag",1);
				A_Takeinventory("PB_Shell",1);
				PB_SetChamberEmpty(false);
				PB_SetMagUnloaded(false);
				A_SetInventory("SG_IsSwapping",0);
			}
		LoadTube:
			TNT1 A 0 A_jumpif(countinv("PB_Shell") < 1 || countinv("PB_ShotgunMag") >= 9,"TubeSwapFinal");
			SSHR BCD 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 A_Startsound("insertshell", 19,CHANF_OVERLAP);
			SSHR E 1 A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
			SSHR FG 1 {
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB);
			}
			TNT1 A 0 {
				A_Giveinventory("PB_ShotgunMag",1);
				A_Takeinventory("PB_Shell",1);
			}
			SSHR A 0 A_Refire();
			TNT1 A 0 A_DoPBWeaponAction(WRF_NOBOB);
			goto LoadTube;
		TubeSwapFinal:
			SH0G IHGFEDCB 1;
			TNT1 A 0 PB_SetReloading(false);
			goto Ready3;
		
		AltMagAmmoSwap:
			TNT1 A 0
			{
				if(CountInv("PB_Shell") < 1)
				{
					A_Setinventory("SelectShotgun_Slugshot", 0); 
					A_Setinventory("SelectShotgun_Buckshot", 0); 
					A_Setinventory("SelectShotgun_Dragonsbreath", 0); 
					A_Setinventory("SelectShotgun_No", 0); 
					A_Setinventory("CantWeaponSpecial",0);
					return resolvestate("Ready3");
				}
				return resolvestate(null);
			}
			SH0G BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ToInsermagSwap");	//i hate offset jumps
			SHMG FGHI 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			Goto BeginMagAmmoSwap;
		ToInsermagSwap:
			SH0G GH 1;
			Goto InsertMagAmmoSwap;
		BeginMagAmmoSwap:	
			SHTN ABCDEFG 1;
			TNT1 A 0 A_Startsound("weapons/shotgunmag/magout", 19,CHANF_OVERLAP);
			TNT1 A 0 PB_SetMagUnloaded(true);
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(),"EmptyMagReloadSwap");
			SHTM GFEDCB 1 PB_SetShellSprite("SHTM","SHMS","SHMD");
			goto InsertMagAmmoSwap;
		EmptyMagReloadSwap:
			SHTN GHIJKL 1;
			TNT1 A 0 A_FireProjectile("EmptyClipMP40",-5,0,8,-4);
		InsertMagAmmoSwap:
			SHMS BCDEFG 0;
			SHMD BCDEFG 0;
			SHTM A 4;
			SHTM BCDEFG 1
			{
				if (CountInv("SelectShotgun_Buckshot") >= 1) //i hate this
				{
					PB_SetShellSprite("SHTM","SHTM","SHTM");
				}
				if (CountInv("SelectShotgun_Slugshot") >= 1)
				{
					PB_SetShellSprite("SHMS","SHMS","SHMS");
				}
				if (CountInv("SelectShotgun_Dragonsbreath") >= 1)
				{
					PB_SetShellSprite("SHMD","SHMD","SHMD");
				}
			}
			TNT1 A 0
			{
				invoker.lastMode = invoker.shellsMode;
				if (CountInv("SelectShotgun_Buckshot") >= 1)
				{
					setShellsMode(Shell_Buck);
				}
				if (CountInv("SelectShotgun_Slugshot") >= 1)
				{
					setShellsMode(Shell_Slug);
				}
				if (CountInv("SelectShotgun_Dragonsbreath") >= 1)
				{
					setShellsMode(Shell_Drag);
				}
				PB_AmmoIntoMag("PB_ShotgunMag","PB_Shell",10,1);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
			}
			SHTM H 1 A_Startsound("weapons/shotgunmag/magin", 19,CHANF_OVERLAP);
			SHTM IJK 1;
			SHTM LMN 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"EmptyChamberSwap");
			SHMA K 0;
			SHMF K 0;
			SHMG K 1
			{
				switch(invoker.lastMode)
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasingRedLive",28,-5,30,3,3,3); PB_SetShellSprite("SHMG","SHMG","SHMG");	break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasingGreenLive",28,-5,30,3,3,3); PB_SetShellSprite("SHMA","SHMA","SHMA");	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasingOrangeLive",28,-5,30,3,3,3); PB_SetShellSprite("SHMF","SHMF","SHMF");	break;
				}
				A_TakeInventory("PB_ShotgunMag",1);
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgmvpump",19,CHANF_OVERLAP); 
			
			}
		EmptyChamberSwap:
			SHMG L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SH0G M 2;
			SHMG L 1
			{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			SHMG K 1 
			{
				PB_SetShellSprite("SHMG","SHMA","SHMF");
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgpump", 19,CHANF_OVERLAP);
			}	
			SHMG JI 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
		ReloadMagSwapFinished:
			TNT1 A 0 pb_postwheel();
			SHTM OPQR 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SH0G EDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0
			{
				A_SetInventory("Reloading",0);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetRoll(0,SPF_INTERPOLATE);
			}
			TNT1 A 0 pb_postwheel();
			TNT1 A 0 A_Refire();
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;
		
	//End of transplant	
	}
	
	action state pb_handlewheel()
	{
		A_Setinventory("CantWeaponSpecial", 1);
		
		bool docancel = false;
		if(countinv("SelectShotgun_No") > 0)
		{
			A_Print("$PB_NOTAVAILABLE");
			docancel = true;
		}
		int actmode = getshellsmode();
		if((actmode == Shell_Slug 	&& CountInv("SelectShotgun_Slugshot") >= 1) 		||
		(actmode == Shell_Drag		&& CountInv("SelectShotgun_Dragonsbreath") >= 1) 	||
		(actmode == Shell_Buck		&& CountInv("SelectShotgun_Buckshot") >= 1))
		{
			A_Print("$PB_ALREADYSELECTED");
			docancel = true;
		}
		
		if(docancel)
		{
			pb_postwheel();
			return resolvestate("Ready3");
		}
		else
		{
			if(CountInv("SelectShotgun_Slugshot")>=1)
				A_Print("$PB_SG_SLUG");
			if(CountInv("SelectShotgun_Dragonsbreath")>=1)
				A_Print("$PB_SG_DBREATH");
			if(CountInv("SelectShotgun_Buckshot")>=1)
				A_Print("$PB_SG_BUCKSHOT");
		}
		return resolvestate(null);
		
	}
	
	action void pb_postwheel()
	{
		A_SetInventory("SelectShotgun_Buckshot", 0);
		A_SetInventory("SelectShotgun_Slugshot", 0);
		A_SetInventory("SelectShotgun_Dragonsbreath", 0);
		A_SetInventory("SelectShotgun_No", 0);
		A_Setinventory("GoWeaponSpecialAbility", 0);
		A_Setinventory("CantWeaponSpecial" , 0);
		A_SetInventory("Zoomed",0);
	}
	
	action int getShellsMode()
	{
		return invoker.ShellsMode;
	}
	
	action void setShellsMode(int mode)
	{
		invoker.ShellsMode = mode;
	}
	
	action void PB_SetShellSprite(string buck, string slug, string drag)
	{
		int mode = clamp(getShellsMode(),1,3);	//just in case
		switch(mode)
		{
			case Shell_Buck:	A_SetWeaponSprite(buck);		break;
			case Shell_Slug:	A_SetWeaponSprite(slug);		break;
			case Shell_Drag:	A_SetWeaponSprite(drag);		break;
		}
	}
	
	override void beginplay()
	{
		ShellsMode = 1;
		super.beginplay();
	}
	
	action void PB_HandleSGCrosshair()
	{
		int mode = clamp(getShellsMode(),1,3);	//just in case
		switch(mode)
		{
			case Shell_Buck:	PB_HandleCrosshair(69);		break;
			case Shell_Slug:	PB_HandleCrosshair(68);		break;
			case Shell_Drag:	PB_HandleCrosshair(73);		break;
		}
	}
}


Class PB_ShotgunMag : PB_WeaponAmmo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 9;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 9;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "SHTCA0";
	}
}


//respective tokens for the shotgun
Class SelectShotgun_Buckshot : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class SelectShotgun_Slugshot : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class SelectShotgun_Dragonsbreath : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class SelectShotgun_NO : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class SG_IsSwapping : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class DragonBreathUpgrade : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class PumpshotgunMagazine: Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class PumpshotgunMagNotInserted: Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class PB_SGMagazine: PB_UpgradeItem
{
	default
	{
		//$Title Shotgun Magazine Upgrade
		//$Category Project Brutality - Weapon Upgrades
		//$Sprite 9SMUA0
		//SpawnID 9310
		//Game "Doom";
		Height 24;
		-INVENTORY.ALWAYSPICKUP
		-COUNTITEM
		Inventory.Pickupsound "SHOTPICK";
		Inventory.PickupMessage "$PB_SG_UPGRADE_PICKUP";
		Tag "Pump Shotgun Magazine";
		Scale 0.45;
		FloatBobStrength 0.5;
	}
	States
	{

		Spawn:
			VSMU A 0 NoDelay;
			9SMU A 10 A_PbvpFramework("VSMU");
			"####" A 0 A_PbvpInterpolate();
			LOOP;
		
		Pickup:
			TNT1 A 0 A_JumpIf(!FindInventory("DragonBreathUpgrade") || !FindInventory("PB_Shotgun") || CountInv("PB_Shell") < GetAmmoCapacity("PB_Shell"),1) ;
			fail;
			TNT1 A 0
			{
				A_GiveInventory("PB_Shotgun", 1);
				A_GiveInventory("DragonBreathUpgrade", 1);
				A_giveinventory("PB_ShotgunMag",1);
				
				let sgam = Ammo(findinventory("PB_ShotgunMag"));	//no more acs for this
				if(sgam)
				{
					sgam.maxamount = 11;
					sgam.backpackmaxamount = 11;
				}
				A_GiveInventory("PB_ShotgunMag", 10);
				if(CountInv("PumpShotgunMagazine") == 0) {A_GiveInventory("PumpshotgunMagNotInserted", 1);}
				A_GiveInventory("PumpshotgunMagazine", 1);
			}
			Stop;
	}
}
