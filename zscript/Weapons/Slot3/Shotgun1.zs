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
		weapon.ammogive1 4;		
		weapon.ammotype2 "ShotgunAmmo";
		PB_WeaponBase.unloadertoken "PBPumpShotgunHasUnloaded";
		PB_WeaponBase.respectItem "RespectShotgun";
		inventory.pickupsound "SHOTPICK";
		inventory.pickupmessage "UAC GS-10 Pump Shotgun (Slot 3)";
		Tag "UAC GS-10 Shotgun";
		Scale 0.45;
		FloatBobStrength 0.5;
		Inventory.AltHUDIcon "SHTCA0";					
		+WEAPON.NOALERT
		+WEAPON.NOAUTOAIM
		+WEAPON.NOAUTOFIRE
		PB_WeaponBase.UsesWheel true;					
		PB_WeaponBase.WheelInfo "PB_PumpShotgunWheel";
		PB_WeaponBase.TailPitch 1.5;
		
	}
	
	int ShellsMode;
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
				A_SetCrosshair(5);
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
			SHTG A 1 {
				PB_SetShellSprite("SHTG","SHTS","SHTD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			SHTG BCDEFGHIJ 1 A_DoPBWeaponAction(WRF_NOBOB);
			SSHR H 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 A_StartSound("weapons/sgmvpump",10,CHANF_OVERLAP);
			SHTG L 5 A_DoPBWeaponAction(WRF_NOBOB);
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
			SHTG JIHGFEDCB 1 A_DoPBWeaponAction(WRF_NOBOB);
			Goto Ready3;
		
		InsertMagBegin: // Straight Into Inserting The Mag After Chambering a shell. 
			TNT1 A 0 A_SetInventory("PumpshotgunMagNotInserted",0);
			TNT1 A 0 A_GiveInventory("ShotgunAmmo",11);
			TNT1 A 0 A_SetInventory("PumpShotgunMagazine",1);
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
			SHTG EDCB 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 A_JumpIfInventory("PumpShotgunMagazine", 2, "Ready3");
			Goto Ready3;
		InsertMagShotgunRespectAlreadyRespected:
			TNT1 A 0 {
				A_SetInventory("PumpshotgunMagNotInserted",0);
				A_GiveInventory("ShotgunAmmo",11);
				A_SetInventory("PumpShotgunMagazine",1);
			}
			SHTG BCDEFGH 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTM A 1 A_DoPBWeaponAction(WRF_NOBOB);
			SHTM BCDEFG 1 {
				PB_SetShellSprite("SHTM","SHMS","SHMD");
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			Goto BeginInsertion;
		
		Select:
			TNT1 A 0 PB_WeaponRaise();
			TNT1 A 0 PB_WeapTokenSwitch("ShotgunSelected");
			TNT1 A 0 A_SetInventory( "RandomHeadExploder", 1);
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_StartSound("weapons/shotgun/equip", 10,CHANF_OVERLAP);
			SH00 JKGHI 1;
			goto ready3;
		
		Deselect:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(69);
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
			SH00 HGEDB 1;
			TNT1 A 0 A_lower(120);
			wait;
		
		Ready:
		Ready3:
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(69);
				A_SetInventory("PB_LockScreenTilt",0);
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
		ReadyToFire:
			SHTG A 1
			{
				PB_SetShellSprite("SHTG","SHTS","SHTD");
				// This token is given upon picking up the magazine upgrade.
				if (CountInv("PumpshotgunMagNotInserted") >= 1 ) 
					return resolvestate("InsertMagShotgunRespectAlreadyRespected");  // Insert magazine upon picking it up
				
				if (PressingFire() && PressingAltfire() && CountInv("ShotgunAmmo") > 0)
						return resolvestate("Fire");
				
				if (PressingFire() && CountInv("ShotgunAmmo") > 0)
						return resolvestate("Fire");
				
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("PBPumpShotgunHasUnloaded"));	 
			}
			Loop;
		
		NoAmmo:
			TNT1 A 0 {
				A_StartSound("weapons/empty", CHAN_WEAPON);
				A_SetInventory("Zoomed",0);
				A_SetInventory("ADSmode", 0);
				A_SetInventory("Reloading", 0);
				A_ZoomFactor(1.0);
			}
			Goto Ready3;
		
		Fire:
			TNT1 A 0 PB_jumpIfHasBarrel("ThrowBarrel","ThrowFlameBarrel","ThrowIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(69);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"Fire2");
			SHTF A 0;
			SH1F A 0;
			SH2F A 0;
			SHTF A 1 BRIGHT 
			{
				PB_QuakeCamera(7, 2);
				PB_SetShellSprite("SHTF","SH1F","SH2F");
				A_SetInventory("CantDoAction",1);
				PB_LowAmmoSoundWarning("shotgun");
				A_TakeInventory("ShotgunAmmo", 1);
				A_AlertMonsters();
				A_fireprojectile("YellowFlareSpawn", 0, 0, 0, 0);
				A_fireprojectile("ShakeYourAssDouble", 0, 0, 0, 0);
				A_fireprojectile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				A_fireprojectile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				A_fireprojectile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				PB_GunSmoke(-1,0,-4);
				PB_GunSmoke(1,0,-4);
				A_Overlay(-6, "ShotFlash",true);
				//A_GunFlash();
				PB_DynamicTail("shotgun", "shotgun");
				A_ZoomFactor(0.97);
				switch(getshellsmode())
				{
					case Shell_Buck:	
						A_StartSound("weapons/sg", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
						PB_FireBullets("PB_12GAPellet",9,3.5,0,0,3.5);
						break;
					case Shell_Slug:
						A_StartSound("SlugShot", CHAN_WEAPON);
						A_FireProjectile("PB_12GASlug", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
						break;
					case Shell_Drag:
						A_StartSound("DRBTFIRE", CHAN_WEAPON);
						PB_FireBullets("PB_DragonsBreathTracer",8,4.5,0,-14,4.5);
						break;
				}
			}
			SHTF B 1 {
				PB_SetShellSprite("SHTF","SH1F","SH2F");
				A_ZoomFactor(0.975);
				//A_SetViewPitch(-3);
				//A_SetViewAngle(3);
			}
			SHTF C 1 {
				A_FireProjectile("ShotgunWad",random(-2,2),0,random(-2,2),-4,FPF_NOAUTOAIM,random(-2,2));
				PB_WeaponRecoil(-1.24,+0.44);
				A_ZoomFactor(0.98);
			}
			SHTF D 1 {
				PB_WeaponRecoil(-1.24,+0.44);
				A_ZoomFactor(0.985);
			}
			SHTF E 1 A_ZoomFactor(0.99);	
			SHTF F 1 A_ZoomFactor(0.995);	
			SHTF G 1 A_ZoomFactor(1.0);			
		Pump:
		Pump1:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
			}
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagPump");
			TNT1 A 0 A_JumpIf(CountInv("PB_PowerStrength") && Cvar.GetCvar("pb_SGPumpFromHip",player).getint() >= 1, "PumpFromHip");
			SHTG BCDEFGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
		P1Begin:
			SHTA K 0;
			SHTF K 0;
			SHTG K 1
			{
				PB_SetShellSprite("SHTG","SHTA","SHTF");
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
			}
		//P1C:
			SHTG L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SHTG M 2;
			SHTG L 1
			{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_StartSound("weapons/sgpump",11,CHANF_OVERLAP); 
			TNT1 A 0 A_JumpIfInventory("PB_Shell", 1,"noChamberEmpty"); //Skip this frame if the chamber isn't empty
			SSHR H 1 
			{
				 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				// A_StartSound("weapons/sgpump",11,CHANF_OVERLAP); 
			// return resolvestate (2); // Skip the frame with shell showing
			}
			SHTG K 1 
			{
				PB_SetShellSprite("SHTG","SHTA","SHTF");
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				//A_StartSound("weapons/sgpump", 10,CHANF_OVERLAP);
			// return resolvestate(null);
			}
		noChamberEmpty:
			SHTG JIHGFEDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
		PumpEnd: // Pump End for mag & regular.
			TNT1 A 0
			{
				A_SetRoll(0,SPF_INTERPOLATE);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			SHTG A 1
			{
				PB_SetShellSprite("SHTG","SHTS","SHTD");
				A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				PB_ReFire();
				A_SetInventory("CantDoAction",0);
				//return resolvestate(null);
			}
			Goto Ready3;
		
		MagPump:
			TNT1 A 0 {
			if(Cvar.GetCvar("pb_SGPumpFromHip",player).getint() >=1)
				Return resolveState("PumpFromHip");
			Return resolveState(null);
			}
			TNT1 A 0 A_WeaponOffset(0,32);
			SHTG BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
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
			}
		MagP1C:	
			SHMG L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SHTG M 2;
			SHMG L 1 
			{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_JumpIfInventory("PB_Shell", 1,2); //Skip this frame if the chamber isn't empty
			SHMG N 1 
			{
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgmvpump",32,CHANF_OVERLAP); 
				//return resolvestate (2);
			}
			SHMG K 1 
			{
				PB_SetShellSprite("SHMG","SHMA","SHMF");
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgpump", 11,CHANF_OVERLAP);
			}	
			SHMG JIHGF 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SHTG EDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			Goto PumpEnd;
		
		PumpFromHip:
			TNT1 A 0 A_StartSound("weapons/sgmvpump",11,CHANF_OVERLAP);
			SHSP ABCCBA 1;
			TNT1 A 0
			{
				switch(getshellsmode())
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasing",21,3,24,0,3,3);	break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasing2",21,3,24,0,3,3);	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasing3",21,3,24,0,3,3);	break;
				}
			}
			TNT1 A 0 A_StartSound("weapons/sgpump",11,CHANF_OVERLAP);
			SHTF GFEDC 1;
			TNT1 A 0 PB_ReFire();
			goto Ready3;
		
		
		AltFire:
			TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(69);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"zoomout");
			TNT1 A 0 {
				 A_WeaponOffset(0,32);
				 A_StartSound("IronSights", 10,CHANF_OVERLAP);
				 A_SetInventory("Zoomed",1);
				 A_ZoomFactor(1.2);
				 A_SetCrosshair(5);
			}
			SHT8 EEDK 1 PB_SetShellSprite("SHT8","SHT6","SHT4");
			Goto Ready2;
		Zoomout:	
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_ZoomFactor(1.0);
				PB_HandleCrosshair(69);
			}
			SHT8 KDEE 1 PB_SetShellSprite("SHT8","SHT6","SHT4");
			Goto Ready3;
		
		ReloadWithNoAmmoLeft:
		Reload:
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 {
				A_SetInventory("Reloading", 0);
				A_SetInventory("Zoomed",0);
				A_WeaponOffset(0,32);
				A_ZoomFactor(1.0);
				A_SetInventory("PB_LockScreenTilt",1);
			}
			SHTG A 1 {
				PB_SetShellSprite("SHTG","SHTS","SHTD");
				PB_HandleCrosshair(69);
				A_DoPBWeaponAction();
			}
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine",1,"MagReload");
			
		ReloadActuallyBegin:
			TNT1 A 0 PB_checkReload("DoEmptyReload","Ready3","NoAmmo",9,1);
		ReloadNormally:	
			SHTG BCDEFGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_SetInventory("PBPumpShotgunHasUnloaded", 0);
		ShellChecker:
			TNT1 A 0 A_JumpIf(CountInv("PB_Shell") < 1 || countinv("shotgunAmmo") >= 9,"ReloadFinished");
			SSHR A 1 {
				A_DoPBWeaponAction(WRF_NOBOB);
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_JumpIfInventory("PBPumpShotgunWasEmpty", 1, "ChamberInsertShell");
			SSHR BCD 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 A_StartSound("insertshell", 10,CHANF_OVERLAP);
			SSHR E 1 A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
			SSHR FG 1 {
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB);
			}
			TNT1 A 0 {
				A_Giveinventory("ShotgunAmmo",1);
				A_Takeinventory("PB_Shell",1);
			}
			TNT1 A 0 A_DoPBWeaponAction(WRF_NOBOB);
			loop;
		
		DoEmptyReload:
			TNT1 A 0 A_SetInventory("PBPumpShotgunWasEmpty", 1);	
			goto ReloadNormally;
		
		ChamberInsertShell:
			TNT1 A 0 A_SetInventory("PBPumpShotgunWasEmpty",0);
			SSHR A 1 A_DoPBWeaponAction(WRF_NOBOB);
			SSHR H 2 A_StartSound("weapons/sgmvpump",10,CHANF_OVERLAP);
			SSHR I 3 A_StartSound("insertshell",10,CHANF_OVERLAP);
			SSHR J 1;
			SSHR KLMNOPP 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 
			{
				A_StartSound("weapons/sgpump",10,CHANF_OVERLAP);
				A_Giveinventory("ShotgunAmmo",1);
				A_Takeinventory("PB_Shell",1);
			}
			Goto ShellChecker;
		
		ReloadFinished:
			SSHR A 1;
			SHTG JIHGFEDCBA 1
			{
				A_DoPBWeaponAction(WRF_NOBOB);
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			}	
			TNT1 A 0
			{
				A_SetInventory("Reloading",0);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetRoll(0,SPF_INTERPOLATE);
			}
			Goto Ready3;
		
		MagReload:
		BeginMagReload:
			TNT1 A 0 PB_checkReload(null,"Ready3","NoAmmo",11,1);
			SHTG BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIfInventory("PBPumpShotgunHasUnloaded",1,"toinsert");
			SHMG FGHI 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			Goto ActuallyBeginMagReload;
		toinsert:
			SHTG GH 1;
			Goto InsertMag;
		ActuallyBeginMagReload:	
			TNT1 A 0 A_JumpIfInventory("ShotgunAmmo",11,"Ready3");
			SHTN ABCDEFG 1;
			TNT1 A 0 A_StartSound("weapons/shotgunmag/magout", 10,CHANF_OVERLAP);
			TNT1 A 0 A_JumpIf(CountInv("ShotgunAmmo") <= 1,"EmptyMagReload");
			SHTM GFEDCB 1 PB_SetShellSprite("SHTM","SHMS","SHMD");
			goto InsertMag;
			
		EmptyMagReload:
			SHTN GHIJKL 1;
			TNT1 A 0 A_JumpIf(countinv("ShotgunAmmo") > 0,"InsertMag");
			TNT1 A 0 PB_SpawnCasing("EmptyClipMP40", 45.6, 9, 18.75,frandom(-1,1),frandom(-1.2, -0.6), frandom(1,-1));
			//TNT1 A 0 A_FireCustomMissile("EmptyClipMP40",-5,0,8,-4);
		InsertMag:
			SHTM A 4;
			SHTM BCDEFG 1 PB_SetShellSprite("SHTM","SHMS","SHMD");
			SHTM H 1 A_StartSound("weapons/shotgunmag/magin", 10,CHANF_OVERLAP);
			SHTM I 1;
			SHTM JKLMN 1;
			TNT1 A 0 {
				if(CountInv("ShotgunAmmo") == 0)
				
					PB_AmmoIntoMag("ShotgunAmmo","PB_Shell",10,1);
				else
					PB_AmmoIntoMag("ShotgunAmmo","PB_Shell",11,1);
				
			}
		LoadChamberMag:
			SHMG J 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
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
			SHTG M 2;
			SHMG L 1 
			{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			SHMG K 1 
			{
				PB_SetShellSprite("SHMG","SHMA","SHMF");
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgpump", 10,CHANF_OVERLAP);
			}	
			SHMG J 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
		ReloadMagFinished:
			SHTM OPQR 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SHTG EDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0
			{
				A_SetInventory("Reloading",0);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("PBPumpShotgunHasUnloaded",0);
				A_SetRoll(0,SPF_INTERPOLATE);
			}
			TNT1 A 0 PB_ReFire();
			Goto Ready3;
		
		
		Weaponspecial:
			TNT1 A 0 A_takeinventory("GoWeaponSpecialAbility",1);	//avoid infinite loops
			TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			TNT1 A 0 A_zoomfactor(1.0);
			//TNT1 A 0 A_JumpIfInventory("Zoomed",1,"Ready2");
			SHZA ABCDEFGHIJKLMNOP 0;
			SHZB ABCDEFGHIJKLMNOP 0;
			goto HandleUpgradeSpecial;
		HandleUpgradeSpecial:
			TNT1 A 0 pb_handlewheel();
			TNT1 A 0 A_jumpif(Cvar.GetCvar("pb_SGAltAmmoSwap",player).getint() >= 1,"AltTubeAmmoSwap");
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
			SHTG A 1 PB_SetShellSprite("SHTG","SHTS","SHTD");
			TNT1 A 0 pb_postwheel();
			goto ready3;
		
		CancelWheel:
			//TNT1 A 1;
			TNT1 A 0 pb_postwheel();
			goto ready;
		
		Unload:
			SHTG A 1 {
				A_ZoomFactor(1.0);
				A_WeaponOffset(0,32);
				A_SetInventory("Unloading",0);
				A_SetInventory("ADSmode",0);
				A_SetInventory("Zoomed",0);
				A_SetInventory("PBPumpShotgunWasEmpty",1);
				A_SetInventory("PB_LockScreenTilt",1);
				}
			TNT1 A 0 A_Jumpif(countinv(invoker.UnloaderToken) > 0 || countinv(invoker.ammotype2) < 1,"Ready3");
			 //TNT1 A 0 A_JumpIfInventory("ShotgunAmmo",1,1)
			//Goto Ready3
			SHTG BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine",1,"MagUnload");
			SHTG FGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			
		ActuallyUnload:
			TNT1 A 0 A_JumpIf(CountInv("ShotgunAmmo") <= 0,"FinishUnload");
			TNT1 A 0 A_StartSound("weapons/sgmvpump");
			SHTG K 1 
			{
				PB_SetShellSprite("SHTG","SHTA","SHTF");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SHTG L 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SHTG M 1;
			SHTG L 1 {
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			//TNT1 A 0 A_JumpIfInventory("PB_Shell", 1,3);
			SSHR H 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);// So the chamber shows as being empty
			TNT1 A 0; //{ return resolvestate (2); } 			 // Skip This Frame if the shotgun isn't loaded.
			SHTG K 1 {
				PB_SetShellSprite("SHTG","SHTA","SHTF");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SHTG J 1 {
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_StartSound("weapons/sgmvpump", 10,CHANF_OVERLAP);
				A_Takeinventory("ShotgunAmmo",1);
				A_Giveinventory("PB_Shell",1);
			}
			goto ActuallyUnload;
		
		FinishUnload:
			SHTG IHGFEDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0 {
				A_SetRoll(0,SPF_INTERPOLATE);
				A_SetInventory("PBPumpShotgunHasUnloaded", 1);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("Unloading",0);
			}
			Goto Ready3;
		
		MagUnload:	
			SHMG FGHIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			SHTN ABCDEFG 1;
			TNT1 A 0 A_StartSound("weapons/shotgunmag/magout", 10,CHANF_OVERLAP);
			SHTN HIJKL 1;
			TNT1 A 0 PB_UnloadMag("ShotgunAmmo","PB_Shell",1);
			Goto FinishUnload;
			
		
		
		//
		//
		//	ADS stuff
		//
		//
		
		Ready2:
			TNT1 A 0 {
				A_SetRoll(0);
				A_SetCrosshair(5);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:
			SHT8 A 1
			{		
				PB_SetShellSprite("SHT8","SHT6","SHT4");
				if (CountInv("PumpshotgunMagNotInserted") >= 1 ) 
					return resolvestate("InsertMagShotgunRespectAlreadyRespected"); 
							
				//Updated code for far superior smooth gameplay
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					
					if (PressingFire() && PressingAltfire() && CountInv("ShotgunAmmo") > 0)
							return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY, CheckUnloaded("PBPumpShotgunHasUnloaded"));
				}
				else 
				{
					if (PressingFire() && CountInv("ShotgunAmmo") > 0 )
						return resolvestate("Fire2");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("PBPumpShotgunHasUnloaded"));
				}
				return resolvestate(null);
			}
			Loop;
		
		Fire2:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetCrosshair(5);
				}
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			TNT1 A 0 
			{
				PB_QuakeCamera(7, 3);
				A_AlertMonsters();
				A_Fireprojectile("YellowFlareSpawn", 0, 0, 0, 0);
				PB_LowAmmoSoundWarning("shotgun");
				A_TakeInventory("ShotgunAmmo", 1);
				A_Fireprojectile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				A_Fireprojectile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				A_Fireprojectile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				A_Fireprojectile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				PB_GunSmoke(-1,0,0);
				PB_GunSmoke(1,0,0);
				PB_DynamicTail("shotgun", "shotgun");    
				A_SetInventory("CantDoAction",1);
				
				switch(getshellsmode())
				{
					case Shell_Buck:	
						A_StartSound("weapons/sg", CHAN_Weapon, CHANF_DEFAULT, 1.0, ATTN_NORM, frandom(0.95, 1.05));
						PB_FireBullets("PB_12GAPellet",9,3,0,0,3);
						break;
					case Shell_Slug:
						A_StartSound("SlugShot", CHAN_WEAPON);
						A_FireProjectile("PB_12GASlug", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
						break;
					case Shell_Drag:
						A_StartSound("DRBTFIRE", CHAN_WEAPON);
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
			TNT1 A 0 A_jumpif(CountInv("PB_PowerStrength") >=1,"BerserkAltPump1");
			SHT8 GHI 1
			{
				PB_SetShellSprite("SHT8","SHT6","SHT4");
				PB_WeaponRecoil(-1,0);
			}
			TNT1 A 0 {
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint()) 
				{
					if (!PressingAltfire() && CountInv("ShotgunAmmo") > 1)
					{
						A_SetInventory("Zoomed",0);
						A_ZoomFactor(1.0);
						PB_HandleCrosshair(69);
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
					PB_ReFire("Fire2");
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
			SH10 AB 1 BRIGHT;
			Stop;
		Flash2:
			SH10 CD 1 BRIGHT;
			Stop;
		Flash3:
			SH10 EF 1 BRIGHT;
			Stop;
		
		
		FlashKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelKicking","FlashBarrelKicking","FlashBarrelKicking");
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashKick");
			SHTG CDFGHI 1;
			SHTG J 2;
			SHTG IHGEDB 1;
			Goto Ready3;
		
		MagFlashKick:
			SHTG CD 1;
			SHMG FGH 1;
			SHMG I 1;
			SHMG J 2;
			SHMG IHG 1;
			SHTG EDB 1;
			Goto Ready3;
			
		FlashAirKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelAirKicking","FlashBarrelAirKicking","FlashBarrelAirKicking");	
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashAirKick");
			SHTG CDFGHI 1;
			SHTG J 4;
			SHTG IHGEDBB 1;
			Goto Ready3;
		
		MagFlashAirKick:
			SHTG CD 1;
			SHMG FGHI 1;
			SHMG I 4;
			SHMG IHG 1;
			SHTG EDBB 1;
			Goto Ready3;
			
		FlashSlideKicking:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKicking","FlashBarrelSlideKicking","FlashBarrelSlideKicking");
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashSlideKicking");
			SHTG CDFGHIJJJJJJJJJJJJJIHGEDB 1;
			Goto Ready3;
		
		MagFlashSlideKicking:
			SHTG CD 1;
			SHMG FGHIJJJJJJJJJJJJJIHGE 1;
			SHTG DC 1;
			Goto Ready3;

		FlashSlideKickingStop:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelSlideKickingStop","FlashBarrelSlideKickingStop","FlashBarrelSlideKickingStop");
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashSlideKickingStop");
			SHTG JIHGEDB 1;
			Goto Ready3;
		
		MagFlashSlideKickingStop:
			SHMG JIHGF 1;
			SHTG DC 1;
			Goto Ready3;
			
		FlashPunching:
			TNT1 A 0 PB_jumpIfHasBarrel("FlashBarrelPunching","FlashBarrelPunching","FlashBarrelPunching");
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_JumpIfInventory("PumpshotgunMagazine", 1, "MagFlashPunch");
			SHTG CDFGHI 1;
			SHTG J 2;
			SHTG IHGEDB 1;
			Stop;
		MagFlashPunch:
			SHTG CD 1;
			SHMG FGH 1;
			SHMG I 1;
			SHMG J 2;
			SHMG IHG 1;
			SHTG EDB 1;
			Stop;
		
		//alternative ammo swap thing
		//Start of transplant
		AltTubeAmmoSwap:
			TNT1 A 0 A_Setinventory("CantWeaponSpecial", 1);
			TNT1 A 0 A_JumpIfInventory("DragonBreathUpgrade",1,"AltMagAmmoSwap");
			TNT1 A 0 {
			 If((CountInv("PB_Shell") <=2) && (CountInv("ShotgunAmmo") <=2)) 
				{
					A_Log("You Need At Least 2 Rounds of Ammo for Swap"); 
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
			SHTG BCDEFGHI 1;
			TNT1 A 0 A_JumpIf(CountInv("ShotgunAmmo") >= 1,"EmptyTube");
			SHTG I 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SHTG Z 1;
			SHTG L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			goto ClearedChamber;
		EmptyTube:
			//need to add token so if you shoot during this reload it cleans things up
			//also a park token for excess ammo
			TNT1 A 0 A_JumpIf(CountInv("ShotgunAmmo") == 1,"ClearChamberForTubeSwap");
			TNT1 A 0 A_Startsound("weapons/sgmvpump");
			SHTG K 1{
				PB_SetShellSprite("SHTG","SHTA","SHTF");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SHTG L 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SHTG M 1;
			SHTG L 1 {
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch-0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_JumpIfInventory("PB_Shell", 1,3);	//not sure how this is suppossed to work
			SSHR H 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE); // So the chamber shows as being empty
			//TNT1 A 0 { return resolvestate (2); } // Skip This Frame if the shotgun isn't loaded.
			SHTG K 1 {
				PB_SetShellSprite("SHTG","SHTA","SHTF");
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			}
			SHTG J 1 {
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgpump", 19,CHANF_OVERLAP);
				A_Takeinventory("ShotgunAmmo",1);
				A_Giveinventory("PB_Shell",1);
			}
			SSHR A 0; //PB_ReFire
			TNT1 A 0; //A_DoPBWeaponAction(WRF_NOBOB)
			goto EmptyTube;
		ClearChamberForTubeSwap:
			SHTG I 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_WeaponOffset(0,32);
			SHTG J 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			//TNT1 A 0 A_TakeInventory("ShotgunAmmo",1)
			SHTG K 1 
			{
				PB_SetShellSprite("SHTG","SHTA","SHTF");
				switch(getshellsmode())
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasingRedLive",15,-5,26,0,3,3);	break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasingGreenLive",15,-5,26,0,3,3);	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasingOrangeLive",15,-5,26,0,3,3);	break;
				}
				A_TakeInventory("ShotgunAmmo",1);
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgmvpump",19,CHANF_OVERLAP); 
			}		
		ClearedChamber:
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
			SHTS KLMNOPP 0;
			SHTD KLMNOPP 0;
			SHTG L 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_JumpIfInventory("PB_Shell", 1, 1);
			SSHR I 3 A_Startsound("insertshell",19,CHANF_OVERLAP) ;
			SSHR JKLMNOPP 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 {
				A_Startsound("weapons/sgpump",19,CHANF_OVERLAP);
				A_Giveinventory("ShotgunAmmo",1);
				A_Takeinventory("PB_Shell",1);
				A_SetInventory("SG_IsSwapping",0);
			}
		LoadTube:
			TNT1 A 0 A_jumpif(countinv("PB_Shell") < 1 || countinv("ShotgunAmmo") >= 9,"TubeSwapFinal");
			SSHR BCD 1 PB_SetShellSprite("SSHR","SHTS","SHTD");
			TNT1 A 0 A_Startsound("insertshell", 19,CHANF_OVERLAP);
			SSHR E 1 A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
			SSHR FG 1 {
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB);
			}
			TNT1 A 0 {
				A_Giveinventory("ShotgunAmmo",1);
				A_Takeinventory("PB_Shell",1);
			}
			TNT1 A 0 pb_postwheel();
			SSHR A 0 PB_ReFire();
			TNT1 A 0 A_DoPBWeaponAction(WRF_NOBOB);
			goto LoadTube;
		TubeSwapFinal:
			SHTG IHGFEDCB 1;
			TNT1 A 0 pb_postwheel();
			goto Ready3;
		
		AltMagAmmoSwap:
			TNT1 A 0
			{
				if(CountInv("PB_Shell")<=10)
				{
					A_Setinventory("SelectShotgun_Slugshot", 0); 
					A_Setinventory("SelectShotgun_Buckshot", 0); 
					A_Setinventory("SelectShotgun_Dragonsbreath", 0); 
					A_Setinventory("SelectShotgun_No", 0); 
					A_Setinventory("CantWeaponSpecial",0); 
					A_Log("You need at least 10 rounds for ammo type swap");
					return resolvestate("Ready3");
				}
				return resolvestate(null);
			}
			SHTG BCDE 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIfInventory("PBPumpShotgunHasUnloaded",1,"ToInsermagSwap");	//i hate offset jumps
			SHMG FGHI 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			Goto BeginMagAmmoSwap;
		ToInsermagSwap:
			SHTG GH 1;
			Goto InsertMagAmmoSwap;
		BeginMagAmmoSwap:	
			SHTN ABCDEFG 1;
			TNT1 A 0 A_Startsound("weapons/shotgunmag/magout", 19,CHANF_OVERLAP);
			TNT1 A 0 A_JumpIf(CountInv("ShotgunAmmo") <= 1,"EmptyMagReloadSwap");
			SHTM GFEDCB 1 PB_SetShellSprite("SHTM","SHMS","SHMD");
			goto InsertMagAmmoSwap;
		EmptyMagReloadSwap:
			SHTN GHIJKL 1;
			TNT1 A 0 A_JumpIfInventory("ShotgunAmmo",1,2);
			TNT1 A 0 A_FireCustomMissile("EmptyClipMP40",-5,0,8,-4);
		InsertMagAmmoSwap:
			SHMS BCDEFG 0;
			SHMD BCDEFG 0;
			SHTM A 4;
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
			}
			SHTM BCDEFG 1 PB_SetShellSprite("SHTM","SHMS","SHMD");
			SHTM H 1 A_Startsound("weapons/shotgunmag/magin", 19,CHANF_OVERLAP);
			SHTM I 1 A_Startsound("insertshell", 19,CHANF_OVERLAP);
			SHTM JKLMN 1;
			TNT1 A 0 A_JumpIf(CountInv("ShotgunAmmo")==0,"EmptyChamberSwap");
			SHMG HIJ 1 A_SetRoll(roll-0.1,SPF_INTERPOLATE);
			SHMA K 0;
			SHMF K 0;
			SHMG K 1
			{
				PB_SetShellSprite("SHMG","SHMA","SHMF");
				switch(getshellsmode())
				{
					case Shell_Buck: PB_SpawnCasing("ShotgunCasingRedLive",28,-5,30,3,3,3);		break;
					case Shell_Slug: PB_SpawnCasing("ShotgunCasingGreenLive",28,-5,30,3,3,3);	break;
					case Shell_Drag: PB_SpawnCasing("ShotgunCasingOrangeLive",28,-5,30,3,3,3);	break;
				}
				A_TakeInventory("ShotgunAmmo",1);
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_Startsound("weapons/sgmvpump",19,CHANF_OVERLAP); 
			
			}
		EmptyChamberSwap:
			SHMG L 1
			{
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
			}
			SHTG M 2;
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
			TNT1 A 0 PB_AmmoIntoMag("ShotgunAmmo","PB_Shell",10,1);
		ReloadMagSwapFinished:
			TNT1 A 0 pb_postwheel();
			SHTM OPQR 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			SHTG EDCB 1 A_SetRoll(roll+0.1,SPF_INTERPOLATE);
			TNT1 A 0
			{
				A_SetInventory("Reloading",0);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("PBPumpShotgunHasUnloaded",0);
				A_SetRoll(0,SPF_INTERPOLATE);
			}
			TNT1 A 0 pb_postwheel();
			TNT1 A 0 PB_ReFire();
			Goto Ready3;
		
	//End of transplant	
	}
	
	action state pb_handlewheel()
	{
		A_Setinventory("CantWeaponSpecial", 1);
		
		bool docancel = false;
		if(countinv("SelectShotgun_No") > 0)
		{
			A_Log("Ammo type not available");
			docancel = true;
		}
		int actmode = getshellsmode();
		if((actmode == Shell_Slug 	&& CountInv("SelectShotgun_Slugshot") >= 1) 		||
		(actmode == Shell_Drag		&& CountInv("SelectShotgun_Dragonsbreath") >= 1) 	||
		(actmode == Shell_Buck		&& CountInv("SelectShotgun_Buckshot") >= 1))
		{
			A_Log("Ammo type already selected");
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
				A_Print("$PB_SGSLUGLD");
			if(CountInv("SelectShotgun_Dragonsbreath")>=1)
				A_Print("$PB_SGDBLD");
			if(CountInv("SelectShotgun_Buckshot")>=1)
				A_Print("$PB_SGBUCKLD");
			//if(Cvar.GetCvar("pb_SGAltAmmoSwap",player).getint() >= 1)
			//			Return resolvestate("AltTubeAmmoSwap");
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
	
	
}


Class ShotgunAmmo : PB_WeaponAmmo
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

Class Pumping : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class HasSlugs : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

class HasDragonBreath : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class HasBuckShot : Inventory
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

Class IsCocking : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class ShotgunWasEmpty : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class PBPumpShotgunWasEmpty : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class PBPumpShotgunHasUnloaded: Inventory
{
	default
	{
		Inventory.MaxAmount 1;
	}
}

Class RespectShotgun : Inventory
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
		+INVENTORY.ALWAYSPICKUP
		+COUNTITEM
		Inventory.Pickupsound "SHOTPICK";
		Inventory.PickupMessage "Pump Shotgun Upgrade! (Mag + Dragon's Breath shells)";
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
			//TNT1 A 0 ACS_NamedExecuteAlways("PumpShotgunMag", 0);
			TNT1 A 0;
			TNT1 A 0
			{
				A_GiveInventory("PB_Shotgun", 1);
				A_GiveInventory("DragonBreathUpgrade", 1);
				A_giveinventory("ShotgunAmmo",1);
				
				let sgam = Ammo(findinventory("ShotgunAmmo"));	//no more acs for this
				if(sgam)
				{
					sgam.maxamount = 11;
					sgam.backpackmaxamount = 11;
				}
				A_GiveInventory("PB_Shell", 20);
				A_GiveInventory("ShotgunAmmo", 10);
				if(CountInv("PumpShotgunMagazine") == 0) {A_GiveInventory("PumpshotgunMagNotInserted", 1);}
				A_GiveInventory("PumpshotgunMagazine", 1);
			}
			Stop;
	}
}