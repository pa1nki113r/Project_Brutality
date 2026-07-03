// For the black hole remote det
class BlackHoleDetonator : inventory {default{inventory.maxamount 1;}}

class PB_BFG9000 : PB_WeaponBase
{
    Default
    {
        //$Category Project Brutality - Weapons
        //$Sprite 097GA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        // SpawnID 9800;
        Weapon.AmmoGive1 40;
        PB_WeaponBase.OffsetRecoilX 1.9;
        PB_WeaponBase.OffsetRecoilY 1.6;
        DamageType "Disintegrate";
        Height 20;
        Weapon.SelectionOrder 2800;
        Weapon.AmmoType "PB_Cell";
        Scale .45;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.PickupSound "8FGPICK";
        Inventory.PickupMessage "$PB_BFG_PICKUP";
        Tag "$PB_BFG_TAG";
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
    	+WEAPON.BFG
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    bool blackholeMode;
    // How many cells should it take for each mode
    const AMMO_TAKE_GREEN      = 40;   // Fire Normal BFG
    const AMMO_TAKE_PURPLE     = 80;   // Fire Black Hole
    const AMMO_TAKE_GREEN_ALT  = 1;    // Fire Laser (takes per tic) 
    const AMMO_TAKE_PURPLE_ALT = 30;   // Fire Gravity Bomb
    
	//temporal thing for the bfg alt fire, move this to the bfg when/if it gets rewritten in zscript
	// beef: done
    const bfgpartstep       = 30;

//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    // This handles the black hole remote detonation
    Override void DoEffect()
    {
		if (!owner || !owner.player)
        return;

        let bfg = PB_BFG9000(owner.player.ReadyWeapon);
        if(!bfg) return;
		
		if( self.GetClass() is bfg.GetClass() ){
            //only have the remote det when youre using the blackhole mode
            if(!bfg.blackholeMode) return; 
			if( (owner.player.cmd.buttons & BT_RELOAD) && !owner.FindInventory("BlackHoleDetonator") ){
				owner.A_SetInventory("BlackHoleDetonator",1);owner.A_Startsound("weapons/pbarm",36,CHANF_NOSTOP);
			}
			if( !(owner.player.cmd.buttons & BT_RELOAD) && owner.FindInventory("BlackHoleDetonator") ){
				owner.A_SetInventory("BlackHoleDetonator",0);
			}
		}
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    action bool getBlackholeMode()
    {
        return invoker.blackholeMode;
    }

    action void setBlackholeMode(bool set)
    {
        invoker.blackholeMode = set;
    }

    action void BFG_Primary(int weaponMode, int tic)
    {
        switch(weaponMode)
        {
            // Fire Green
            case 1:
            switch(tic)
            {  
                case 0:
                A_StopSound(CHAN_WEAPON);
                A_StartSound("weapons/bfg_chargestart2", CHAN_6);
                A_Overlay(-3,"MuzzleFlash");
                A_OverlayFlags(-3,PSPF_RENDERSTYLE,true);
                A_OverlayRenderStyle(-3,STYLE_Add);
                A_AlertMonsters();
                break;

                case 1:
                PB_FireOffset();
                A_GunFlash();
                break;

                case 2:
                A_SetBlend("GREEN",0.5,18);
                A_StopSound(CHAN_WEAPON);
                A_StopSound(CHAN_6);
                A_StartSound("bfg/fire_primary", CHAN_WEAPON);
                break;

                case 3:
                // PB_FireBullets("PB_SuperBFGBall",1,0,0,0,0);
                A_FireProjectile("PB_SuperBFGBall", spawnheight:-12);
                A_TakeInventory(invoker.ammo1.getClassName(), AMMO_TAKE_GREEN, TIF_NOTAKEINFINITE);
                A_ZoomFactor(0.98, ZOOM_INSTANT);
                A_GunFlash();
                A_AlertMonsters();
                break;

                case 4:
                A_ZoomFactor(1.0);
                break;
            }
            break;

            // Fire Black Hole
            case 2:
            switch(tic)
            {
                case 0:
                A_StopSound(CHAN_WEAPON);
                A_StartSound("bh_Charge", CHAN_WEAPON,1.0, ATTN_NORM, false); //CHAN_WEAPON
                A_AlertMonsters();
                break;

                case 1:
                A_StopSound(CHAN_6);
                A_StopSound(CHAN_7);
                // PB_FireBullets("Blackhole_Ball",1,0,0,0,0);
                A_FireCustomMissile("Blackhole_Ball",0,1,0,0);
                A_TakeInventory(invoker.ammo1.getClassName(), AMMO_TAKE_PURPLE, TIF_NOTAKEINFINITE);
                A_AlertMonsters();
                break;
            }
            break;
        }
    }

    action void BFG_AltFire(int weaponMode, int tic)
    {
        switch(weaponMode)
        {
            // Altfire Green
            case 1:
            switch(tic)
            {  
                // Altfire Start
                case 0:
                PB_FireOffset();
                A_GunFlash();
                break;

                case 1:
                A_SetBlend("GREEN",0.2,7);
                A_StartSound("SUPERBFG", CHAN_AUTO);
                A_StartSound("Weapons/BFSG/Fire", CHAN_AUTO);
                A_ZoomFactor(0.94, ZOOM_INSTANT);
                break;

                case 2:
                A_ZoomFactor(1.0);
                PB_FireOffset();
                A_GunFlash();
                break;

                // Altfire Hold
                case 3:
                //A_FireCustomMissile ("BFG_BeamProjectile", 0, 0, 0, -8, 0,0);
                PB_FireAltBFGRail();  //function defined in BaseWeapon_Function.zsc to replace the rail and the projectilew
                //A_RailAttack(0, 0, 0,"None", "Green", RGF_SILENT || RGF_NOPIERCING || RGF_FULLBRIGHT, 2.0, "NullPuff", 0, 0, 0, 0, 10.0, 1.0, "BFGLightningTrial_Small", -7,0,0);
                A_TakeInventory(invoker.ammo1.getClassName(), AMMO_TAKE_GREEN_ALT, TIF_NOTAKEINFINITE);
                A_GunFlash();
                break;

                // Altfire Stop
                case 4:
                A_StopSound(CHAN_WEAPON);
                A_StartSound("Weapons/BFGG/Explode", CHAN_AUTO);
                break;
            }
            break;

            // Altfire Black Hole
            case 2:
            switch(tic)
            {
                case 0: case 1:
                PB_FireOffset();
                A_GunFlash();
                break;

                case 2:
                A_StopSound(CHAN_BODY);
				A_StartSound("weapons/bh_secondary", CHAN_WEAPON);
                // PB_FireBullets("BlackHole_GravityBomb",1,0,0,0,0);
				A_FireProjectile("BlackHole_GravityBomb", spawnheight:-8);
				A_TakeInventory(invoker.ammo1.getClassName(), AMMO_TAKE_PURPLE_ALT, TIF_NOTAKEINFINITE);
				A_GunFlash();
                break;
            }
            break;
        }
    }

    action state BFG_SwitchMode()
    {
        A_WeaponOffset(0,32);
        PB_SetRoll(0);
        PB_HandleCrosshair(72);
        A_SetInventory("PB_LockScreenTilt",0);
        A_SetInventory("GoWeaponSpecialAbility",0);

        if(invoker.ammo1.amount < 1)    return ResolveState("FailedToFireEmpty");
        else if(getBlackholeMode())     return ResolveState("SwitchToGreen");
        return ResolveState(null);
    }

    action state BFG_Ready()
    {
		PB_HandleCrosshair(72);

        string snd;
		if(getBlackholeMode() && invoker.ammo1.amount > 0)  snd = "weapons/bfg_idle";
        else if(invoker.ammo1.amount > 0)                   snd = "weapons/bhg_idle";

        A_StartSound(snd, CHAN_WEAPON, CHANF_LOOPING|CHANF_OVERLAP);

        if(invoker.ammo1.amount >= 1)   return ResolveState("ReadyToFire");
        else                            return ResolveState("ReadyToFire2");
        return ResolveState(null);
    }

    action state BFG_AltfireCheck()
    {
        A_WeaponOffset(0,32);
        PB_SetRoll(0);
        PB_HandleCrosshair(72);
        A_SetInventory("PB_LockScreenTilt",0);

        if(getBlackholeMode())              return ResolveState("AltFire_Blackhole");
        else if(invoker.ammo1.amount < 5)   return ResolveState("FailedToFire");
        return ResolveState(null);
    }

    action void BFG_ChangeSprite(
        name blackHole, 
        name empty = '', 
        name defaultsprite = '',
        int layer = PSP_WEAPON,
        bool checkPurpleOnly = false)
    {
		let psp = player.findpsprite(layer);
		if(!psp) return;

        name sprite;

        if(getBlackholeMode())                                  sprite = blackHole;
        else if(invoker.ammo1.amount <= 0 && !checkPurpleOnly)  sprite = empty;
        else                                                    sprite = defaultsprite;

        psp.sprite = GetspriteIndex(sprite);
    }

    //////////////////////////////////////////////////////////
	//BFG
	//////////////////////////////////////////////////////////
	
	//temporal thing for the bfg alt fire, move this to the bfg when/if it gets rewritten in zscript
    // beef: done
	action void PB_FireAltBFGRail()
	{
		//the first option is a lineattack cuz linetrace acts weird in some tipes of geometry (try one with the kinsie test map, in the elevator or the pool)
		//Actor p = LineAttack(angle,8000,pitch,20,'Disintegrate',"BFGBeamPuff",LAF_NOIMPACTDECAL|LAF_NORANDOMPUFFZ);
		//nvm just needed to substract hitdir to hitlocation, so it doesnt spawn in the wall
		vector3 destpos;
		FLineTraceData t;
		bool hit = linetrace(angle,8000,pitch,0,height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor,data:t);
		
		destpos = t.hitlocation;
		destpos -= (t.hitdir * 2);
		
		vector3 dif = levellocals.vec3diff((pos.XY,pos.z + height * 0.5),destpos);
		vector3 dir = dif.unit();
		double dis = dif.length();
		
		int q = int(dis / bfgpartstep) + 1; //bfgpartstep is an arbitrary value representing the distance between particles, basically get the divide the total distance / steps between particles to get the number of particles
			
		vector3 actpos = (pos.XY,pos.z + height * 0.5);
		double alf = clamp(0.5 + sin(level.time * 15),0.25,1.0);
		for(int i = 1; i <= q; i++)
		{
			actpos += (dir * bfgpartstep);
			PB_DrawBFGrailparticle(actpos,alf,i,min(i,20));
		}
		
		//damage victim (if any)
		if(t.hitactor)
		{
			actor v = t.hitactor;
			int dmg = 40 * random(1,2); //so this is why it feels weaker, the original projectile deals 20 * random(1,8) damage, and damagemobj doesnt add randomization, so a little randomization may help here
			if(v && v.bismonster && v.health > 0 && !isfriend(v))
				v.damagemobj(self,self,dmg,'Disintegrate');
		}
		
		//spawn puff if hit anything
		if(hit)
		{
			actor p = Spawn("BFGBeamPuff",destpos);
			if(p)
				p.target = self;
			
		}

	}
	
	action void PB_DrawBFGrailparticle(vector3 where, double alfa = 1.0,int it = 0, int spac = 30)
	{
		FSpawnParticleParams bfgrail;
		int fm = random(1,5);
		bfgrail.Texture = TexMan.CheckForTexture("DLI"..fm.."G0R0"); //("DLI1F0q0"); //
		bfgrail.Color1 = "FFFFFF";
		bfgrail.Style = STYLE_Add;
		bfgrail.Flags = SPF_ROLL|SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		bfgrail.Vel = (0,0,0);//(random(-5,5),random(-5,5),random(-5,5)); 
		bfgrail.Startroll = random(0,360);
		bfgrail.RollVel = randompick(-15,15,30,-30);
		bfgrail.StartAlpha = 1.0;
		bfgrail.FadeStep = 0.1;
		bfgrail.Size = random(20,32);
		bfgrail.SizeStep = -12;
		bfgrail.Lifetime = random (2,3); 
		bfgrail.Pos = where + (random(-spac,spac),random(-spac,spac),random(-spac,spac)); 
		Level.SpawnParticle(bfgrail);
		
		//flare
		
		FSpawnParticleParams BFGFLAR;
		string flart = "LENGA0";
		switch(random(1,4))
		{
			case 1:	break;
			case 2: flart = "L2NGA0";	break;
			case 3: flart = "DB59L0";	break;
			case 4: flart = "SRKGN0";	break;
			//case 3: flart = "DB46S0";	break;
		}
		BFGFLAR.Texture = TexMan.CheckForTexture(flart); 
		BFGFLAR.Color1 = "FFFFFF";
		BFGFLAR.Style = STYLE_Add;
		BFGFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		BFGFLAR.Vel = (0,0,0); 
		BFGFLAR.Startroll =random(0,360); 
		BFGFLAR.RollVel = 0;
		BFGFLAR.StartAlpha = alfa;
		BFGFLAR.FadeStep = alfa > 0.1 ? 0.1 : 0.0;
		BFGFLAR.Size = random(25,30);
		BFGFLAR.SizeStep = -5;
		BFGFLAR.Lifetime = 2; 
		BFGFLAR.Pos = where;
		Level.SpawnParticle(BFGFLAR);
		
		//if(performancecvar)	return;
		
		/////////////////////////////////
		//fancy ring
		////////////////////////////////
		
		FSpawnParticleParams ciclepx;
		ciclepx.Texture = TexMan.CheckForTexture("YAE6A0");//("YAE6A0");//("LEYSB0");//("YAE6A0");//("SRKGN0");//("DLI1F0q0");
		ciclepx.Color1 = "FFFFFF";
		ciclepx.Style = STYLE_Add;
		ciclepx.Flags = SPF_ROLL|SPF_FULLBRIGHT;//|SPF_NOTIMEFREEZE;
		ciclepx.Vel = (0,0,0); 
		ciclepx.Startroll = it * 2; 
		ciclepx.RollVel = 0;
		ciclepx.StartAlpha = 0.90;
		ciclepx.FadeStep = 0.1;
		ciclepx.Size = 30;
		ciclepx.SizeStep = 0;
		ciclepx.Lifetime = 1; 
		
		ciclepx.pos = where; 
		
		
		double ps = -it * spac; 
		ps += (level.time * 20) % 360;
		
		quat fr = quat.fromangles(angle,pitch,ps);
		
		vector3 ofss = fr * (0,0,spac);
		ciclepx.pos += ofss;
		
		level.spawnparticle(ciclepx);
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            097G A -1;
			Stop;
        
        WeaponRespect:
            TNT1 A 0 {
                    A_SetCrosshair(-1);
                    A_SetInventory("PB_LockScreenTilt",1);
                    A_StartSound("Ironsights", CHAN_AUTO);
                    A_StartSound("IronSights", CHAN_AUTO);
                    A_StartSound("weapons/railgun/inspect1", CHAN_AUTO);
                }
			000G ABCDEFGHIJKLMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_raise", CHAN_AUTO);
			000G QRSTUVWXYZ 1 {
				PB_SetRoll(roll-2.0);
				return A_DoPBWeaponAction();
			}
			001G ABCDEFGHIJKLMNO 1 {
				PB_SetRoll(roll+3.0);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 {
				A_StartSound("GENREADY", CHAN_AUTO);
				PB_SetRoll(0);
			}
			001G PQRSTUVWXYZ 1 {
				PB_SetRoll(roll+1.0);
				return A_DoPBWeaponAction();
			}
			002G ABCDEFGHIJKLMNOPQRSTUVW 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_beep", CHAN_AUTO);
			002G XYZ 1 A_DoPBWeaponAction();
			003G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			004G ABCDE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_boop", CHAN_AUTO);
			TNT1 A 0 A_StartSound("weapons/bfg_windup", CHAN_AUTO);
			004G FGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			005G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			006G ABCDEFGHIJKLMNO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/railgun/powerdownred", CHAN_AUTO);
			006G PQRSTUVWXYZ 1 A_DoPBWeaponAction();
			007G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			008G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bfg_brap", CHAN_AUTO);
			009G ABCD 1 A_DoPBWeaponAction();
			009G EFGHIJKLMNOPQRST 1 A_DoPBWeaponAction();
			TNT1 A 0 A_JumpIf(invoker.ammo1.amount >= 1, "Ready3"); // Jump to ready if have cells
		RespectButEmpty:
			TNT1 A 0 A_StartSound("weapons/railgun/deselectblue", CHAN_AUTO);
			017G ABCDEFGHIJKLMNOP 1;
			Goto Ready3;

        Deselect:
            // Cache Sprites
            013G ABCD 0;
            044G ABCD 0;
			045G ABCD 0;
            // Actual Deselect
            TNT1 A 0 {
				A_StopSound(CHAN_BODY);
				A_ClearOverlays(-52,-52);
			}
			013G ABCD 1 BFG_ChangeSprite("044G", "045G","013G");
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				PB_HandleCrosshair(72);
                PB_WeapTokenSwitch("BFGSelected");
                PB_WeaponRaise("weapons/bfg_raise");
			    return PB_RespectIfNeeded();
            }
        SelectAnimation:
            // Cache Sprites
			042G ABCD 0;
			043G ABCD 0;
			010G ABCD 0;
            // Actual Select
            010G ABCD 1 BFG_ChangeSprite("042G", "043G","010G");
        // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
            // Cache Sprites
			011G ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			021G ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			022G ABCD 0;
            // Actual Ready
			TNT1 A 0 BFG_Ready();
        ReadyToFire:
			011G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 {
                BFG_ChangeSprite("021G", defaultsprite:"011G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
			}
			012G ABCD 1 {
                BFG_ChangeSprite("022G", defaultsprite:"012G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
			}
			Loop;

        // This is basically Ready Empty
        ReadyToFire2:
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount >= 1, "PowerOn");
			046G A 1 A_DoPBWeaponAction();
			Loop;

        PowerOn:
            // Cache Sprites
            019G QRSTUVWXYZ 0;
			020G ABCD 0;
            // Actual PowerOn
			TNT1 A 0 A_StartSound("weapons/bfg_switch", CHAN_WEAPON, CHANF_OVERLAP );
			017G QRSTUVWXYZ 1 {
                BFG_ChangeSprite("019G", defaultsprite:"017G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
			}
			018G ABCD 1 {
                BFG_ChangeSprite("020G", defaultsprite:"018G", checkPurpleOnly: true);
				return A_DoPBWeaponAction();
            }
			Goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
			TNT1 A 0 BFG_SwitchMode();
		SwitchToBlackhole:
			TNT1 A 0 {
				A_Print("$PB_BFG_BLACKHOLE");
				setBlackholeMode(true);
				A_StopSound(CHAN_WEAPON);
				A_StartSound("weapons/bfg_switch2", CHAN_AUTO);
			}
			017G ABCDEFGHIJKLMNO 1;
			017G PP 1;
			TNT1 A 0 A_StartSound("weapons/bfg_switch", CHAN_AUTO);
			019G QRSTUVWXYZ 1;
			020G ABCD 1;
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			Goto Ready3;

        SwitchToGreen:
			TNT1 A 0 {
				A_Print("$PB_BFG_PLASMA");
				setBlackholeMode(false);
				A_StopSound(CHAN_WEAPON);
				A_StartSound("weapons/bfg_switch2", CHAN_AUTO);
			}
			019G ABCDEFGHIJKLMNO 1;
			019G PP 1;
			TNT1 A 0 A_StartSound("weapons/bfg_switch", CHAN_AUTO);
			017G QRSTUVWXYZ 1;
			018G ABCD 1;
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			Goto Ready3;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(72);
				A_SetInventory("PB_LockScreenTilt",0);
			}
            TNT1 A 0 A_JumpIf(getBlackholeMode(), "Fire_Blackhole");
            TNT1 A 0 PB_jumpIfNoAmmo("FailedToFire",AMMO_TAKE_GREEN,false,false);
        Fire_Green:
			TNT1 A 0 BFG_Primary(1,0);
			014G ABCD 1 LIGHT("BARONBALL_X2");
			TNT1 A 0 A_StartSound("weapons/bfg_chargeloop", CHAN_BODY);
			014G EFGHI 1 LIGHT("BARONBALL_X2");
			TNT1 A 0 A_StartSound("weapons/bfg_chargestart", CHAN_5);
			014G JKLMNOPQRSTUVWXYZ 1 LIGHT("BARONBALL_X2") A_GunFlash();
			015G ABCDEFGH 1 LIGHT("BARONBALL_X3") BFG_Primary(1,1);
			TNT1 A 0 BFG_Primary(1,2);
			015G I 1 BFG_Primary(1,3);
			015G JKLMNOPQRST 1 BFG_Primary(1,4);
			TNT1 A 0 PB_Refire();
			Goto Ready3;

        Fire_Blackhole:
            TNT1 A 0 PB_jumpIfNoAmmo("FailedToFire",AMMO_TAKE_PURPLE,false,false);
			TNT1 A 0 BFG_Primary(2,0);
			023G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			024G ABCDEFGH 1;
			024G IJKLMNOPQRSTUVWXYZ 1;
			025G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 PB_FireOffset();
			026G ABC 1 PB_FireOffset();
			TNT1 A 0 BFG_Primary(2,1);
			026G DEFGHIJKLMNOPQRSTUVW 1;
			TNT1 A 0 PB_Refire();
			Goto Ready3;

        FailedToFire:
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount == 0, "FailedToFireEmpty");
			TNT1 A 0 A_StartSound("weapons/railgun/deselectblue", CHAN_AUTO);
			017G ABCDEFGHIJKLMNO 1 BFG_ChangeSprite("019G", defaultsprite:"017G", checkPurpleOnly: true);
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			017G PPPPPPP 1 BFG_ChangeSprite("019G", defaultsprite:"017G", checkPurpleOnly: true);
			017G PP 1 BFG_ChangeSprite("019G", defaultsprite:"017G", checkPurpleOnly: true);
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			017G PPPPPPP 1 BFG_ChangeSprite("019G", defaultsprite:"017G", checkPurpleOnly: true);
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount == 0, "Ready3");
			017G QRSTUVWXYZ 1 BFG_ChangeSprite("019G", defaultsprite:"017G", checkPurpleOnly: true);
			018G ABCD 1 BFG_ChangeSprite("020G", defaultsprite:"018G", checkPurpleOnly: true);
			Goto Ready3;

        FailedToFireEmpty:
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			046G AAAAAAA 1;
			046G AA 1 ;
			TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
			046G AAAAAAA 1;
			Goto Ready3;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
			TNT1 A 0 BFG_AltfireCheck();
        AltFireGreen:
			TNT1 A 0 A_StartSound("weapons/bfg_beamstart", CHAN_5);
			016G ABCDE 1;
			016G FGHIJKLFGHIJK 1 BFG_AltFire(1,0);
			TNT1 A 0 BFG_AltFire(1,1);
			016G L 1 BFG_AltFire(1,2);
		BeamLoop:
			016G GHIJKL 1 {
				BFG_AltFire(1,3);
                if(invoker.ammo1.amount < 1)
                    return ResolveState("AltHoldStop");
                return ResolveState(null);
			}
			TNT1 A 0 A_StartSound("Leech/Fire", CHAN_WEAPON, CHANF_LOOPING);
			TNT1 A 0 PB_ReFire("BeamLoop");
		AltHoldStop:
			TNT1 A 0 BFG_AltFire(1,4);
			016G MNOPQR 1;
			Goto Ready3;
			
		AltFire_Blackhole:
            TNT1 A 0 PB_jumpIfNoAmmo("FailedToFire",AMMO_TAKE_PURPLE,false,false);
			TNT1 A 0 A_StartSound("weapons/bh_sec_charge1", CHAN_AUTO);
			027G ABCDEFGH 1 PB_FireOffset();
			TNT1 A 0 A_StartSound("weapons/bh_sec_charge2", CHAN_BODY);
			027G IJKLMNOPQRSTUVWXYZ 1 BFG_AltFire(2,0);
			028G ABCD 1 BFG_AltFire(2,1);
			028G E 1 BFG_AltFire(2,2);
			028G FGHI 1 A_GunFlash();
			TNT1 A 0 PB_Refire();
			Goto Ready3;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        FlashKicking:
		FlashAirKicking:
            // Cache Sprites
			034G ABCDEFGGGHIJKLMNO 0;
			035G ABCDEFGGGHIJKLMNO 0;
            // Actual Kick
			033G ABCDEFGGGHIJKLMNO 1 BFG_ChangeSprite("034G","035G","033G");
			Goto Ready3;
			
		FlashSlideKicking:
            // Cache Sprites
			037G ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			038G ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
            // Actual Slide
			036G ABCDEFGHIJKLMNOPQRSTUVWX 1 BFG_ChangeSprite("037G","038G","036G");
			Goto Ready3;

		FlashSlideKickingStop:
			036G RSTUVWX 1 BFG_ChangeSprite("037G","038G","036G");
			Goto Ready3;

		FlashPunching:
            // Cache Sprites
			040G ABCDEFGHIJKLMNO 0;
			041G ABCDEFGHIJKLMNO 0;
            // Actual Punch
			039G ABCDEFGHIJKLMNO 1 BFG_ChangeSprite("040G","041G","039G");
			Goto Ready3;

        MuzzleFlash:
			014M ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			015M ABCDEFGHIJKLMNOPQRST 1;
			Stop;

    }
}

//////////////////////////// PROJECTILES/OTHERS ////////////////////////////////////////////////////////////////////////////////////
class BlackHole_GravityBomb : actor //PB_ProjectileAlt //actor
{
    Default
    {
        // PB_Projectile.BaseDamage 150;
        // +PB_PROJECTILE.NOCRITICALS;
        // -RIPPER;
        // Gravity 0;
        DamageFunction 675;
        Projectile;
        Radius 12;
        Height 20;
        Speed 40;
        RenderStyle "Normal";
        Scale 0.12;
        DamageType "Normal";
        Decal "Scorch";
        +NOGRAVITY;
        +BLOODLESSIMPACT;
        -BLOODSPLATTER;
        +THRUSPECIES;
        +MTHRUSPECIES;
        +FRIENDLY;
        +RollSprite;
        +SQUAREPIXELS;
        +NODAMAGETHRUST;
        +EXTREMEDEATH;
		+FORCEXYBILLBOARD
		+ROLLCENTER
        Species "Marines";
    }

    States
    {
        Spawn:
			TNT1 A 0 NoDelay A_StartSound("PLSBULB", CHAN_5, CHANF_LOOPING);
		Fly:
			031G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 bright Light("BlackholeBallSmall"){
				A_SpawnItemEx("PurpleTrailSparksSmall", 0, 0, 10, 0, 0, 0, 0, 128);
				A_SetRoll(roll-5);
			}	
			032G ABCD 1 bright Light("BlackholeBallSmall"){
				A_SpawnItemEx("PurpleTrailSparksSmall", 0, 0, 10, 0, 0, 0, 0, 128);
				A_SetRoll(roll-5);
			}  
			Loop;
		Death:
			TNT1 A 0
			{ 
				A_SpawnItemEx("TinyBlackHoleSingularity", zofs:10);
				A_RadiusThrust(-5000,800, RTF_NOIMPACTDAMAGE);
				A_StopSound(CHAN_5);
				A_StartSound("DSPBCN", CHAN_AUTO);
				A_CustomMissile ("PurplePlasmaFire", 10, 0, random (0, 360), 2, random (0, 360));
				A_CustomMissile ("PurpleShockWave", 10, 0, random (0, 360), 2, random (0, 360));
				A_CustomMissile ("PurpleShockWave_Flat", 10, 0, random (0, 360), 2, random (0, 360));
			}
			TNT1 AAAAA 0 A_CustomMissile ("PurplePlasmaParticle", 110, 0, random (0, 360), 2, random (0, 360));
			031G ABCDEFGHIJK 1 BRIGHT Light("BlackholeBallSmall"){
				A_SetScale(Scale.X-0.01, Scale.Y-0.01);
				A_RadiusThrust(-10, 800, RTF_NOIMPACTDAMAGE);
			}
			031G ABCDEFGHIJK 1 BRIGHT Light("BlackholeBallSmall") ;
			TNT1 A 0 {
				A_Explode(220, 120, 0, 0, 120);
				A_RadiusThrust(8000, 800, RTF_NOIMPACTDAMAGE);
				A_CustomMissile ("PurplePlasmaFire", 10, 0, random (0, 360), 2, random (0, 360));
				A_CustomMissile ("PurpleShockWave2", 10, 0, random (0, 360), 2, random (0, 360));
				A_CustomMissile ("PurpleShockWave_Flat2", 10, 0, random (0, 360), 2, random (0, 360));
			}
			Stop;
    }
}

class PurpleShockWave : actor
{
    Default
    {
        Speed 0;
        Height 64;
        Radius 32;
        Scale 1.3;
        RenderStyle "add";
        Alpha 0.25;
        +NOINTERACTION;
        +NOGRAVITY;
    }

    States 
	{ 
		Spawn:
			// SH0K ABCDEFGHIJKLMNOPQR 1 BRIGHT A_FadeOut(0.08)
			SH0K RQPONMLKJIHGFEDCBA 1 BRIGHT A_FadeIn(0.1);
			Stop;
	}
}

class PurpleShockWave_Flat : PurpleShockWave
{
    Default
    {
	    +FLATSPRITE;
    }
}

class PurpleShockWave2 : PurpleShockWave
{
    Default
    {
        Alpha 1.0;
		Scale 5.0;
    }
	
    States 
	{ 
		Spawn:
			SH0K ABCDEFGHIJKLMNOPQR 1 BRIGHT A_FadeOut(0.1);
			Stop;
	}
}

class PurpleShockWave_Flat2 : PurpleShockWave2
{
    Default
    {
	    +FLATSPRITE;
    }
}

class BlackHoleSingularity : BFGExtra
{
    Default
    {
        RenderStyle "add";
        Damage 0;
        Scale 1.8;
        Radius 1;
        Height 1;
        +NoInteraction;
        Alpha 1.0;
    }

    States
	{
		Spawn:
		BH05 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
		stop;
	}
}

class TinyBlackHoleSingularity : BlackHoleSingularity 
{
    Default
    {
        Alpha .9;
        Scale 1.35;
    }
}

class BFG_BeamProjectile : MageWandMissile
{
    Default
    {
        Speed 400;
        Radius 13;
        Height 8;
        //Damage 20
        Decal "none";
        damagetype "Disintegrate";
        RenderStyle "Add";
        Alpha .85;
        Translation "0:255=%[0,0,0]:[0,1,0]";
        -RIPPER;
        -NOBOSSRIP;
        -CANNOTPUSH;
        -NODAMAGETHRUST;
        +BLOODLESSIMPACT;
        +FORCERADIUSDMG
        -BLOODSPLATTER;
        Species "Marine";
    }

    States
    {
        Death:
            TNT1 B 0 A_Explode(10,80,0, 1, 80);
            tnt1 a 0 A_SpawnItem("GreenFlare",0,0);
            TNT1 A 0 A_SpawnItemEx("SmallGreenFlameTrails", 0, 0, 0, 0, 0, 0, 0, 128);
            TNT1 A 0 A_SpawnItem("BFGAltShockWave",0,0);
            TNT1 A 0 A_SpawnItemEx("BFGLightningTrial", 0, random(-1,1), random(4,6));
            TNT1 A 0 A_SpawnItemEx("NewBFGTrailGreen", 0, random(8,-8), random(8,-8), 0, 0, 0, 0, 128, 0);
            TNT1 A 0 A_SpawnItemEx("BFGFOG", 0, 0);
            HSPL ABCDEFGHIJ 1 bright Light("BFGALT") A_SetScale(Scale.X -0.1, Scale.Y -0.1);
            stop;
    }
}

//this puff is to replace the projectile above
class BFGBeamPuff : actor
{
    Default
    {
        Radius 13;
        Height 8;
        Damage 20;
        Decal "none";
        damagetype "Disintegrate";
        RenderStyle "Add";
        Alpha .85;
        Translation "0:255=%[0,0,0]:[0,1,0]";
        -RIPPER;
        -NOBOSSRIP;
        -CANNOTPUSH;
        -NODAMAGETHRUST;
        +BLOODLESSIMPACT;
        +FORCERADIUSDMG;
        -BLOODSPLATTER;
        +SQUAREPIXELS;
        +FORCEXYBILLBOARD;
        Species "Marine";
    }

    States
	{
		Spawn:
			TNT1 B 0 nodelay A_Explode(10,80,0, 1, 80);
			TNT1 A 0 {
				A_SpawnItem("GreenFlare",0,0);
				A_SpawnItemEx("SmallGreenFlameTrails", 0, 0, 0, 0, 0, 0, 0, 128);
				A_SpawnItem("BFGAltShockWave",0,0);
				A_SpawnItemEx("BFGLightningTrial", 0, random(-1,1), random(4,6));
				A_SpawnItemEx("NewBFGTrailGreen", 0, random(8,-8), random(8,-8), 0, 0, 0, 0, 128, 0);
				A_SpawnItemEx("BFGFOG", 0, 0);
			}
			HSPL ABCDEFGHIJ 1 bright Light("BFGALT") A_SetScale(Scale.X - 0.1, Scale.Y - 0.1);
			stop;
	}
}

class Blackhole_Ball : actor //PB_ProjectileAlt //actor
{
    Default
    {
        // PB_Projectile.BaseDamage 30;
        // PB_Projectile.RipperCount 15;
        // Gravity 0;
        // +PB_PROJECTILE.NOCRITICALS;
        Damage 30;
        Radius 13;
        Height 8;
        Speed 17;
        Projectile;
        +FORCEXYBILLBOARD;
        +SQUAREPIXELS;
        +NODAMAGETHRUST;
        +NOBOSSRIP;
        +Friendly;
        //+FORCERADIUSDMG;
        -THRUGHOST;
        +Ripper;
        Renderstyle "Normal";
        Damagetype "BlackHole";
        Scale 0.26;
        DeathSound "weapons/bh_blast";
        seeSound "bh/Fire";
    }

    States
	{
		Spawn:
			TNT1 A 0;
		Fly:
			//TNT1 A 0 NoDelay A_StartSound("bh/Fire ", 3, 1.0, ATTN_NORM, false)
			029G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright Light("BlackholeBall") {
				if(CountInv("BlackHoleDetonator", AAPTR_TARGET) >=1) 
				{return resolvestate("GoExplode");}
				A_Explode(20,90,0);
				A_SpawnItemEx("PurpleTrailSparks", 0, 0, 8, 0, 0, 0, 0, 128);
				A_RadiusThrust(-100,100, RTF_NOIMPACTDAMAGE);
				return resolvestate(null);
			}
			030G ABCD 1 Bright Light("BlackholeBall")  {
				if(CountInv("BlackHoleDetonator", AAPTR_TARGET) >=1) 
				{return resolvestate("GoExplode");}
				A_Explode(20,90,0);
				A_SpawnItemEx("PurpleTrailSparks", 0, 0, 8, 0, 0, 0, 0, 128);
				A_RadiusThrust(-100,100, RTF_NOIMPACTDAMAGE);
				return resolvestate(null);
			}
			loop;
			
		Death:
		GoExplode:
			TNT1 A 0 A_SpawnItem("BlackHoleSingularity",0,0,0);
			TNT1 A 0 A_CustomMissile ("PurpleShockWave", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 A 0 A_CustomMissile ("PurpleShockWave_Flat", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 A 0 A_StopSound(CHAN_5);
			TNT1 A 0 A_StartSound("weapons/bh_app", CHAN_5);
			029G ABCDEFGHIJKLM 1 Bright Light("BlackholeBall")
			{
				A_SetScale(Scale.X-0.02, Scale.Y-0.02);
				Radius_Quake (8, 16, 0, 200, 0);//(intensity, duration, damrad, tremrad, tid)
			}
			TNT1 A 0 A_SpawnItemEx ("PB_BlackHole",0,0,0,0,0,0,0,SXF_SETTARGET); //Set the projectiles target AKA shooter as the black holes' source, for proper kill credit.
			Stop;
    }
}

class BlackHOL : actor
{
    Default
    {
        //+CLIENTSIDEONLY
        +NOINTERACTION;
        +NOBLOCKMAP;
        +NOGRAVITY;
        +NOTELEPORT;
        //+FORCEXYBILLBOARD;
        +DONTSPLASH;
        Radius 13;
        Height 8;
        Speed 0;
        Damage 50;
        Projectile;
        //+FORCERADIUSDMG;
        -THRUGHOST;
        Damagetype "BlackHole";
    }

    States
	{
		Spawn:
		TNT1 A 0;
		TNT1 A 1 A_StartSound("bh_Charge", CHAN_5, 1.0, ATTN_NORM, false);
		TNT1 A 150 A_StartSound("bh/Fire", 3, 1.0, ATTN_NORM, false);
		
		TNT1 A 300 A_StartSound("bh_EXPLONG", CHAN_6, 1.0, ATTN_NORM, false);
		TNT1 A 300 A_StartSound("bh_Sound", CHAN_7, 1.0, ATTN_NORM, false);
		
		VHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
		WHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
		ZHOL ABCDEFGHIJKLMNOPQR 1 Bright;
		
		VHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
		WHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
		ZHOL ABCDEFGHIJKLMNOPQR 1 Bright;
		
		VHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
		WHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
		ZHOL ABCDEFGHIJKLMNOPQR 1 Bright;
//		TNT1 A 0 A_StopSound(CHAN_5)
//		TNT1 A 0 A_StopSound(CHAN_6)
//		TNT1 A 0 A_StopSound(CHAN_7)
		Stop;
	}
}

class BlackHole : actor
{
    Default
    {
        Radius 20;
        Height 20;
        Speed 0;
        // SpawnID 176;
        Projectile;
        //+NOCLIP;
        +NOBLOCKMAP;
        +DONTHARMSPECIES;
        +NODAMAGETHRUST;
        -THRUGHOST;
        +Ripper;
        +NOBOSSRIP;
        +ForcePain;
        +FORCEYBILLBOARD ;
        +FORCERADIUSDMG;
        +NOEXTREMEDEATH;
        +Friendly;
        +DONTSPLASH;
        +RollSprite;
        RenderStyle "Normal";
    //	RenderStyle Add;
        Damagetype "BlackHole";
        Scale 0.05;
        ReactionTime 360;
        Obituary "%o got absorbed by the darkness.";
    }

    States
	{
		Spawn:
		//	TNT1 A 0 A_StartSound("weapons/bh_sucksound", CHAN_7, CHANF_LOOPING)
			TNT1 A 0;
			TNT1 A 0 A_StartSound("bh_EXPLONG", CHAN_6, 1.0, ATTN_NORM, false);
			TNT1 A 0 A_StartSound("bh_Sound", CHAN_7, 1.0, ATTN_NORM, false);
			TNT1 A 0 A_SetScale(3.0);
			QHOL ABCDEFGHIJKLMNOP 1 BRIGHT Light("BlackholeVoid") {
				A_Explode(20,200);
				A_RadiusThrust(-700,1200, RTF_NOIMPACTDAMAGE);
			}
			
			TNT1 A 0 A_SetRoll(0);
		Exist:
			VHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright Light("BlackholeVoid") {
				//A_SetRoll(roll-10);
				A_Explode(20,200);
				A_RadiusThrust(-700,1200, RTF_NOIMPACTDAMAGE);
				A_CountDown();
			}
			WHOL ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright Light("BlackholeVoid") {
				//A_SetRoll(roll-10);
				A_Explode(20,200);
				A_RadiusThrust(-700,1200, RTF_NOIMPACTDAMAGE);
				A_CountDown();
			}
			ZHOL ABCDEFGHIJKLMNOPQR 1 Bright Light("BlackholeVoid") {
				//A_SetRoll(roll-10);
				A_Explode(20,200);
				A_RadiusThrust(-700,1200, RTF_NOIMPACTDAMAGE);
				A_CountDown();
			}
			
			TNT1 A 0 A_Jump(249, 2);
			TNT1 A 0 {
				//A_StartSound("DMBall/Impact", CHAN_AUTO, CHANF_OVERLAP);
				A_SpawnItemEx("BlackHoleLightning", random(-120, 120), random(-120, 120), random(-5, 120));
				A_Quake(8,4,0,400, "None");
			}
			TNT1 A 0 ;
			Loop;
		
	Death:
		TNT1 A 0 A_StopSound(CHAN_7);
		TNT1 A 0 A_StopSound(CHAN_6);
		TNT1 A 0 A_StartSound("BHole/Explosion", CHAN_AUTO);
		TNT1 A 0 Bright A_SpawnItem("PurpleShockWave",0,0,0); //PurpleTrailSparks
		BHOL AAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("PurpleTrailSparks", 0, 0, 0, 0, 0, 0, 0, 128);
		EHOL ABCDEFGHIJKLMNO 1 Bright Light("BlackholeVoid"){
			A_FadeOut(0.06);
		}
		Stop;
	
	}
}

class BFGDeathParticle : Actor
{
    Default
    {
        Height 0;
        Radius 0;
        Mass 0;
        +MISSILE;
        +NOBLOCKMAP;
        Gravity 0.125;
        +DONTSPLASH;
        // +DOOMBOUNCETYPE;
        +SQUAREPIXELS;
        +FORCEXYBILLBOARD;
        BounceFactor 0.5;
        RenderStyle "Add";
        Scale 0.04;
    }
    States
    {
        Spawn:
        Death:
            SPKG A 2 Bright A_FadeOut(0.02);
            Loop;
    }
}

class BFGDeathParticleFast : BFGDeathParticle
{
    Default
    {
        Speed 10;
        Scale 0.1;
    }
    States
    {
        Spawn:
        Death:
            SPKG A 11 Bright;
            SPKG AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 2 Bright A_SetScale(Scale.X * 0.94, Scale.Y * 0.94);
            Stop;
    }
}

class BFGDeathParticleSuperFast : BFGDeathParticleFast
{
    Default
    {
        Speed 20;
    }
}

class BFGLightningTrial : Actor
{
    Default
    {
        RenderStyle "Add";
        Damage 0;
        Scale 0.80;
        +NOGRAVITY;
        +THRUACTORS;
        +BLOODLESSIMPACT;
        Species "Marines";
        +FRIENDLY;
        +THRUSPECIES;
        +MTHRUSPECIES;
        +DONTHARMSPECIES;
        +SQUAREPIXELS;
        +FORCEXYBILLBOARD;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_Jump(256, "Spawn2", "Spawn3", "Spawn4", "Spawn5", "Spawn6", "Spawn7", "Spawn8", "Spawn9", "Spawn10");
            DLI1 ABCDEFGHIJK 1 Bright;
            Stop;
        Spawn2:
            TNT1 A 0;
            DLI2 ABCDEFGHIJK 1 Bright;
            Stop;
        Spawn3:
            TNT1 A 0;
            DLI3 ABCDEFGHIJK 1 Bright;
            Stop;
        Spawn4:
            TNT1 A 0;
            DLI4 ABCDEFGHIJK 1 Bright;
            Stop;
        Spawn5:
            TNT1 A 0;
            DLI5 ABCDEFGHIJK 1 Bright;
            Stop;
        Spawn6:
            TNT1 A 0;
            DLI2 LMNOPQRSTUV 1 Bright;
            Stop;
        Spawn7:
            TNT1 A 0;
            DLI3 LMNOPQRSTUV 1 Bright;
            Stop;
        Spawn8:
            TNT1 A 0;
            DLI3 LMNOPQRSTUV 1 Bright;
            Stop;
        Spawn9:
            TNT1 A 0;
            DLI4 LMNOPQRSTUV 1 Bright;
            Stop;
        Spawn10:
            TNT1 A 0;
            DLI5 LMNOPQRSTUV 1 Bright;
            Stop;
    }
}

class BlackHoleLightning : BFGLightningTrial
{
    Default
    {
        Scale 1.20;
        Translation "112:127=%[0,0,0]:[1,0,1]";
        Alpha 0.2;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_Jump(256, "Spawn2", "Spawn3", "Spawn4", "Spawn5", "Spawn6", "Spawn7", "Spawn8", "Spawn9", "Spawn10");
            DLI1 ABCDEFGHIJK 1 Bright;
            Stop;
    }
}

class BFGLightningTrial_Small : BFGLightningTrial
{
    Default
    {
        YScale 0.05;
        XScale 0.25;
        Speed 4;
    }
}

class BFGLightningTrial_Small_Faster : BFGLightningTrial
{
    Default
    {
        Scale 0.2;
        Speed 14;
    }
}

class BFGLooker : Actor
{
    Default
    {
        // +MONSTER;
        Scale 0.5;
        RenderStyle "None";
        Obituary "%o was dealt green hot death by %k's BFG9000!";
        Species "Marines";
        +NEVERTARGET;
        -SOLID;
        -SHOOTABLE;
        +STANDSTILL;
        +BLOODLESSIMPACT;
        +FRIENDLY;
        +THRUSPECIES;
        +MTHRUSPECIES;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 1
            {
                bNOHATEPLAYERS = true;
                A_LookEx(LOF_NOSOUNDCHECK | LOF_NOSEESOUND, 0, 1024, 0, 60);
            }
            TNT1 A 0;
            Stop;
        See:
            TNT1 A 0 A_CustomRailgun(6, 0, "", "Green", RGF_SILENT | RGF_FULLBRIGHT | RGF_NOPIERCING, 2, 0, "GreenShockWave", 0, 0, 1024, 1, 60, 0, "BFGLightningTrial_Small", 0, 0, 1);
            TNT1 A 1;
            Stop;
    }
}

class BFGBeam : Actor
{
    Default
    {
        +NOINTERACTION;
        +NONETID;
        +FORCEXYBILLBOARD;
        RenderStyle "Add";
        Translation "0:255=%[0,0,0]:[0.0,1.8,0.0]";
        Alpha 0.7;
        Scale 0.8;
    }
    States
    {
        Spawn:
            LGWR Y 3 Bright;
            TNT1 A 0 A_SpawnItemEx("BFGLightningTrial_Small", 0, random(-1, 1), random(-1, 1));
            Stop;
    }
}

class SuperBFGBall : Actor
{
    Default
    {
        // +PROJECTILE;
        Speed 24;
        RenderStyle "Normal";
        Scale 0.9;
        Radius 4;
        Height 8;
        Damage 500;
        Decal "BFGLightning";
        DeathSound "BFGEXPLO";
        DamageType "Disintegrate";
        Species "Marines";
        +SEEKERMISSILE;
        +FRIENDLY;
        +THRUSPECIES;
        +MTHRUSPECIES;
        +DONTHARMSPECIES;
        +FORCEXYBILLBOARD;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_StartSound("Bfgfly1", CHAN_BODY, CHANF_OVERLAP | CHANF_LOOPING);
        Flying:
            098G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright Light("BFGBALL")
            {
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0,  60, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 120, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 180, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 240, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 300, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0,  60, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 120, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 180, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 240, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 300, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGTrailParticle", Random(-13, 13), Random(-13, 13), Random(7, 22), Random(-8, 8), Random(-3, 3), (0.1) * Random(-10, 10), Random(-20, 20), 128);
                A_SpawnItemEx("BFGLightningTrial", 15, random(-1, 1), random(-6, -4), 20);
            }
            099G ABCD 1 Bright Light("BFGBALL")
            {
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0,  60, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 120, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 180, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 240, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 300, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0,  60, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 120, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 180, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 240, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGLooker", 0, 0, 0, 3, 0, 0, 300, SXF_NOCHECKPOSITION);
                A_SpawnItemEx("BFGTrailParticle", Random(-13, 13), Random(-13, 13), Random(7, 22), Random(-8, 8), Random(-3, 3), (0.1) * Random(-10, 10), Random(-20, 20), 128);
                A_SpawnItemEx("BFGLightningTrial", 15, random(-1, 1), random(-6, -4), 20);
            }
            Loop;

        Death:
            TNT1 A 0;
            TNT1 A 0 A_StopSound(6);
            TNT1 A 0 Bright A_SpawnItem("GreenShockWave", 0, 0, 0);
            EXPL A 0 Radius_Quake(5, 16, 0, 20, 0);
            EXPL AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_CustomMissile("BFGBIGFOG", 0, 0, random(0, 360), 2, random(0, 360));
            EXPL AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_CustomMissile("BFGDeathParticleFast", 0, 0, random(0, 360), 2, random(0, 360));
            EXPL AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_CustomMissile("BFGDeathParticleSuperFast", 0, 0, random(0, 360), 2, random(0, 360));
            EXPL AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_CustomMissile("BFGDeathParticleFast", 0, 0, random(0, 360), 2, random(0, 360));
            EXPL AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_CustomMissile("BFGDeathParticleFast", 0, 0, random(0, 360), 2, random(0, 360));
            TNT1 A 0 A_SpawnItem("MegaGibRemoving");
            TNT1 A 0 A_PlaySound("BFGAR", 3);
            TNT1 A 0 A_Explode(400, 500, 0, 0, true);
            BFGB ABCDE 1 Bright Light("BFGBALL") A_SpawnItem("GreenFlare", 0, 0);
            BFE1 F 1 Bright Light("BFGBALL") A_BFGSpray("SuperBFGExtra", 40, 35);
            TNT1 A 0 A_SpawnItem("SuperBFGExtraGiant");
            BFE1 GGHHIIJJKK 1 Bright Light("BFGBALL") A_SpawnItem("GreenFlare", 0, 0);
            Stop;
    }
}

class BFGTrailParticle : Actor
{
    Default
    {
        Height 0;
        Radius 0;
        Mass 0;
        Speed 8;
        +MISSILE;
        +NOBLOCKMAP;
        +NOGRAVITY;
        +DONTSPLASH;
        RenderStyle "Add";
        Scale 0.02;
    }
    States
    {
        Spawn:
            SPKG A 1 Bright A_FadeOut(0.02);
            Loop;
    }
}

class SuperBFGExtra : BFGExtra replaces BFGExtra
{
    Default
    {
        +NOBLOCKMAP;
        +NOGRAVITY;
        RenderStyle "Add";
        +FORCERADIUSDMG;
        +THRUGHOST;
        Damage 0;
        Scale 0.5;
        Radius 1;
        Height 1;
        DamageType "Disintegrate";
        Species "Marines";
        +THRUSPECIES;
        +MTHRUSPECIES;
        +SQUAREPIXELS;
        +FORCEXYBILLBOARD;
    }
    States
    {
        Spawn:
            BFE2 A 0;
            TNT1 A 0 A_PlaySound("BFGEXTRA");
            TNT1 AAAAAA 0 A_SpawnItemEx("BFGExtraParticle", 0, 0, 14, (0.1) * Random(10, 40), 0, (0.1) * Random(-40, 40), Random(0, 360), 128);
            TNT1 AAAAAA 0 A_SpawnItemEx("BFGAltTrail", random(8, -8), random(8, -8), random(8, -8), 0, 0, 0, 0, 128, 0);
            TNT1 AAAAAA 0 A_SpawnItemEx("BFGExtraParticle", 0, 0, 14, (0.1) * Random(10, 40), 0, (0.1) * Random(-40, 40), Random(0, 360), 128);
            DB45 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright A_SpawnItem("GreenFlareMedium", 0, 0);
            Stop;
    }
}

class SuperBFGExtraGiant : SuperBFGExtra
{
    Default
    {
        Scale 0.85;
    }
    States
    {
        Spawn:
            BFE2 A 0;
            TNT1 A 0 A_PlaySound("BFGEXTRA");
            DB45 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright A_SpawnItem("GreenFlareMedium", 0, 0);
            Stop;
    }
}

class BFGExtraParticle : Actor
{
    Default
    {
        Height 0;
        Radius 0;
        Mass 0;
        +MISSILE;
        +NOBLOCKMAP;
        +DONTSPLASH;
        +NOINTERACTION;
        RenderStyle "Add";
        Scale 0.035;
    }
    States
    {
        Spawn:
        Death:
            SPKG A 2 Bright A_FadeOut(0.1);
            Loop;
    }
}

class GreenShockWave : Actor
{
    Default
    {
        Speed 0;
        Height 64;
        Radius 32;
        Scale 2.25;
        RenderStyle "Add";
        Alpha 0.99;
        +DROPOFF;
        +NOBLOCKMAP;
        +NOGRAVITY;
        +BLOODLESSIMPACT;
        DamageType "Disintegrate";
        Species "Marines";
        +FRIENDLY;
        +THRUSPECIES;
        +MTHRUSPECIES;
        +DONTHARMSPECIES;
        +SQUAREPIXELS;
        +FORCEXYBILLBOARD;
    }
    States
    {
        Spawn:
            SHOK A 1 Bright;
            Goto Death;
        Death:
            SHOK BCDEFGHIJJKKLLMMNNOPQR 1 Bright A_FadeOut(0.03);
            Stop;
    }
}

class BFGFOG : Actor
{
    Default
    {
        Radius 1;
        Height 1;
        Alpha 0.2;
        RenderStyle "Add";
        Scale 0.75;
        Speed 8;
        Gravity 0;
        +NOBLOCKMAP;
        +NOTELEPORT;
        +DONTSPLASH;
        +FORCEXYBILLBOARD;
    }
    States
    {
        Spawn:
            DB48 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright
            {
                A_SpawnItem("GreenFlareMedium", 0, 0);
                A_SetScale(Scale.X - 0.04, Scale.Y - 0.05);
                A_FadeOut(0.05);
            }
            Loop;
        Death:
            DB48 ABCDEFGHIJKLM 1 Bright A_FadeOut(0.1);
            Loop;
    }
}

class BFGBIGFOG : BFGFOG
{
    Default
    {
        Scale 0.8;
    }
}

class SmallGreenFog : BFGFOG
{
    Default
    {
        Speed 3;
        Scale 0.45;
    }
}

class BFGDeathParticleSpawner : Actor
{
    Default
    {
        +NOCLIP;
        +NOBLOCKMAP;
        +NOGRAVITY;
        +MISSILE;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 AAAAA 0 A_SpawnItemEx("BFGDeathParticle", 0, 0, 0, (0.1) * Random(20, 45), 0, (0.1) * Random(-40, 40), Random(0, 360), 128);
            TNT1 AAAAA 0 A_SpawnItemEx("BFGDeathParticle", 0, 0, 0, (0.1) * Random(20, 45), 0, (0.1) * Random(-40, 40), Random(0, 360), 128);
            TNT1 AAAAA 0 A_SpawnItemEx("BFGDeathParticle", 0, 0, 0, (0.1) * Random(20, 45), 0, (0.1) * Random(-40, 40), Random(0, 360), 128);
            TNT1 AAAAA 0 A_SpawnItemEx("BFGDeathParticle", 0, 0, 0, (0.1) * Random(20, 45), 0, (0.1) * Random(-40, 40), Random(0, 360), 128);
            TNT1 A 1;
            Stop;
    }
}

class BFGSuperParticleSpawner : Actor
{
    Default
    {
        +NOCLIP;
        +NOBLOCKMAP;
        +NOGRAVITY;
        +MISSILE;
        +FORCEXYBILLBOARD;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 AAAAAAAAAAA 0 A_SpawnItemEx("BFGSuperParticle", 0, 0, 0, (0.1) * Random(10, 35), 0, (0.1) * Random(-20, 20), Random(0, 360), 128);
            TNT1 AAAAAAAAAAA 0 A_SpawnItemEx("BFGSuperParticle", 0, 0, 0, (0.1) * Random(10, 35), 0, (0.1) * Random(-20, 20), Random(0, 360), 128);
            TNT1 AAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGSuperParticle", 0, 0, 0, (0.1) * Random(10, 35), 0, (0.1) * Random(-20, 20), Random(0, 360), 128);
            TNT1 A 1;
            Stop;
    }
}

class BFGSuperParticle : Actor
{
    Default
    {
        Height 0;
        Radius 0;
        Mass 0;
        +MISSILE;
        +NOBLOCKMAP;
        +NOGRAVITY;
        +DONTSPLASH;
        +FORCEXYBILLBOARD;
        RenderStyle "Add";
        Scale 0.04;
        Speed 24;
    }
    States
    {
        Spawn:
        Death:
            SPKG A 2 Bright A_FadeOut(0.02);
            Loop;
    }
}

class BFGSmallSphere : Actor
{
    Default
    {
        Radius 10;
        Height 8;
        Speed 40;
        FastSpeed 50;
        // +PROJECTILE;
        +FORCEXYBILLBOARD;
        -THRUGHOST;
        Damage 30;
        RenderStyle "Add";
        Alpha 1;
        Scale 0.45;
        DeathSound "BFGALPP";
        SeeSound "None";
        Decal "Scorch";
        Species "Marines";
        +THRUSPECIES;
        +MTHRUSPECIES;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_StartSound("BGFLMBL", CHAN_BODY, CHANF_LOOPING);
        Fly:
            DB57 ABC 1 Bright
            {
                A_SpawnItemEx("BFGLightningTrial_Small", 20, 0, 0, 0, 0, 0, 0, 128);
                A_SpawnItemEx("SmallGreenFlameTrails", 0, 0, 0, 0, 0, 0, 0, 128);
                A_SpawnItemEx("BFGAltTrail", Random(-13, 13), Random(-13, 13), Random(0, 18), Random(1, 3), 0, (0.1) * Random(-10, 10), Random(-20, 20), 128);
            }
            Loop;
        Death:
            TNT1 A 0
            {
                A_StopSound(CHAN_BODY);
                A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 6, 6, 6, 0, 128);
                A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 6, 6, 6, 0, 128);
                A_SpawnItemEx("BFGAltExplosion", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
                A_SpawnItem("BFGAltShockWave", 0, 0);
            }
            EXPG ABCDEFG 2 Bright A_SpawnItem("GreenFlare", 0, 0);
            TNT1 AAAAA 19 A_CustomMissile("PlasmaSmoke", 1, 0, random(0, 360), 2, random(0, 160));
            Stop;
        XDeath:
            TNT1 A 0
            {
                A_StopSound(CHAN_BODY);
                A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 6, 6, 6, 0, 128);
                A_SpawnItemEx("PlasmaParticleSpawner", 0, 0, 0, 6, 6, 6, 0, 128);
                A_SpawnItemEx("BFGAltExplosion", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
                A_SpawnItem("BFGAltShockWave", 0, 0);
                A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
                A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            }
            EXPG ABCDEFG 2 A_SpawnItem("GreenFlare", 0, 0);
            Stop;
    }
}

class MastermindBFGSmallSphere : BFGSmallSphere
{
    Default
    {
        Radius 12;
        Height 12;
        Speed 50;
        Damage 9;
        FastSpeed 55;
        SeeSound "mbfgsh";
        Species "MasterMind";
    }
}

class BFGAltShockWave : GreenShockWave
{
    Default
    {
        Height 1;
        Radius 1;
        +FORCEXYBILLBOARD;
        Scale 1.0;
        Species "Marines";
        +THRUSPECIES;
        +MTHRUSPECIES;
        DamageType "Disintegrate";
    }
    States
    {
        Spawn:
            SHOK A 1 Bright;
            Goto Death;
        Death:
            SHOK CEGIKMOQS 1 Bright A_FadeOut(0.11);
            Stop;
    }
}

class BFGAltTrail : BFGTrailParticle
{
    Default
    {
        Height 0;
        Radius 0;
        Mass 0;
        Speed 3;
        +MISSILE;
        +NOBLOCKMAP;
        +NOGRAVITY;
        +DONTSPLASH;
        RenderStyle "Add";
        Scale 0.025;
    }
    States
    {
        Spawn:
            SPKG A 1 Bright A_FadeOut(0.04);
            Loop;
    }
}

class BFGAltExplosion : Actor
{
    Default
    {
        +NOBLOCKMAP;
        +MISSILE;
        Species "Marines";
        +THRUSPECIES;
        +MTHRUSPECIES;
        DamageType "ExplosiveImpact";
    }
    States
    {
        Spawn:
            TNT1 A 1;
            Stop;
    }
}

class GreenExplosionFire : Actor
{
    Default
    {
        Radius 1;
        Height 1;
        Speed 3;
        Damage 0;
        +NOBLOCKMAP;
        +NOTELEPORT;
        +DONTSPLASH;
        +MISSILE;
        +FORCEXYBILLBOARD;
        +NOINTERACTION;
        +NOCLIP;
        RenderStyle "Add";
        DamageType "Flames";
        SeeSound "9KEXPL";
        Scale 2.0;
        Alpha 1;
        Gravity 0;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            EXPG ABCDEFG 3 Bright;
            Stop;
    }
}

class WhiteShockWave : GreenShockWave
{
    Default
    {
        Scale 2.0;
        Alpha 0.12;
    }
    States
    {
        Spawn:
            SHWK A 1;
            SHWK CEGIKMOQ 1 A_FadeOut(0.01);
            Stop;
    }
}

class WhiteShockWaveBig : WhiteShockWave
{
    Default
    {
        Scale 3.0;
    }
}

class WhiteShockWaveSmall : WhiteShockWave
{
    Default
    {
        Scale 1.0;
    }
}

class ObeliskProjectile : FastProjectile
{
    Default
    {
        Speed 200;
        Radius 12;
        Height 8;
        Damage 40;
        RenderStyle "Add";
        -CANNOTPUSH;
        +NODAMAGETHRUST;
        +EXTREMEDEATH;
        +FORCERADIUSDMG;
        DamageType "ExplosiveImpact";
        DeathSound "weapons/StachanovHit";
        MissileType "ObeliskTrail";
        MissileHeight 10;
        Decal "BFGLightning";
        Decal "BigScorch";
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 1 A_PlaySound("Weapons/StachanovFly", 5, 1.0, true);
            Loop;
        Death:
            TNT1 A 0 A_PlaySound("Weapons/YamatoExp", 5);
            TNT1 AAAAAAAAAA 0 A_SpawnItemEx("ObeliskTrailSpark", random(19, -19), random(19, -19), random(19, -19), 0, 0, 0, 0, 128, 0);
            TNT1 A 0 A_SpawnItemEx("ObeliskExplode", 0, 0, 0, 0, 0, 0, 0, 128, 0);
            TNT1 A 0 A_Explode(60, 80, 0, true);
            TNT1 BCD 4;
            Stop;
    }
}

class ObeliskSeeker : FastProjectile
{
    Default
    {
        Speed 100;
        Radius 12;
        Height 8;
        Damage 45;
        RenderStyle "Add";
        -CANNOTPUSH;
        +NODAMAGETHRUST;
        +EXTREMEDEATH;
        +FRIENDLY;
        +FORCERADIUSDMG;
        +SEEKERMISSILE;
        DamageType "ExplosiveImpact";
        DeathSound "weapons/StachanovHit";
        MissileType "ObeliskTrail";
        MissileHeight 10;
        Decal "BFGLightning";
        Decal "BigScorch";
        Scale 0.55;
    }
    States
    {
        Spawn:
            TNT1 A 0 A_SeekerMissile(0, 90, SMF_LOOK | SMF_PRECISE);
            TNT1 A 1 A_PlaySound("Weapons/StachanovFly", 5, 1.0, true);
            Loop;
        Death:
            TNT1 A 0 A_PlaySound("Weapons/YamatoExp", 5);
            TNT1 AAAAAAAAAA 0 A_SpawnItemEx("ObeliskTrailSpark", random(19, -19), random(19, -19), random(19, -19), 0, 0, 0, 0, 128, 0);
            TNT1 A 0 A_SpawnItemEx("ObeliskExplode", 0, 0, 0, 0, 0, 0, 0, 128, 0);
            TNT1 A 0 A_Explode(50, 40, 0, true);
            TNT1 BCD 4;
            Stop;
    }
}

class ObeliskExplode : Actor
{
    Default
    {
        Radius 12;
        Height 8;
        RenderStyle "Add";
        Scale 0.5;
        +NOINTERACTION;
        +NOGRAVITY;
    }
    States
    {
        Spawn:
            YAE3 ABCDEFGHIJKLMNOPQRS 1 Bright A_FadeOut(0.05);
            Stop;
    }
}

class ObeliskTrail : Actor
{
    Default
    {
        RenderStyle "Add";
        Scale 0.175;
        Alpha 1;
        +NOINTERACTION;
        +NOGRAVITY;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_SetScale(Scale.X, Scale.Y - 0.0875);
            YAE4 A 2 Bright A_SpawnItemEx("ObeliskTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 128, 0);
            YAE4 A 2 Bright;
        Trolololo:
            YAE4 A 0 A_JumpIf(Scale.Y <= 0, "NULL");
            YAE4 A 0 A_SetScale(Scale.X - 0.01, Scale.Y - 0.01);
            YAE4 A 1 Bright A_FadeOut(0.295);
            Loop;
    }
}

class NewBFGTrailGreen : ObeliskTrail
{
    Default
    {
        Scale 0.28;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0;
            YAE6 A 2 Bright A_SpawnItemEx("GreenTrailSparks", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 128, 0);
            YAE6 A 2 Bright;
        Trolololo:
            YAE6 A 0 A_JumpIf(Scale.Y <= 0, "NULL");
            YAE6 A 0;
            YAE6 A 1 Bright A_FadeOut(0.295);
            Loop;
    }
}

class NewBFGBeamTrailGreen : ObeliskTrail
{
    Default
    {
        Scale 0.085;
        Alpha 0.65;
    }
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0;
            YAE6 A 2 Bright;
            YAE6 A 2 Bright;
        Trolololo:
            YAE6 A 0 A_JumpIf(Scale.Y <= 0, "NULL");
            YAE6 A 0;
            YAE6 A 1 Bright A_FadeOut(0.295);
            Loop;
    }
}

class ObeliskTrailSpark : Actor
{
    Default
    {
        RenderStyle "Add";
        Scale 0.0125;
        Alpha 0.95;
        +NOINTERACTION;
        +NOGRAVITY;
    }
    States
    {
        Spawn:
            YAE4 A 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
            YAE4 A 0 A_SetScale(Scale.X - 0.00075);
            YAE4 A 3 Bright A_ChangeVelocity(frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
            YAE4 A 1 Bright A_FadeOut(0.05);
            Loop;
    }
}

class GreenTrailSparks : Actor
{
    Default
    {
        RenderStyle "Add";
        Scale 0.0125;
        Alpha 0.95;
        +NOINTERACTION;
        +NOGRAVITY;
    }
    States
    {
        Spawn:
            YAE6 A 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
            YAE6 A 0 A_SetScale(Scale.X - 0.00075);
            YAE6 A 3 Bright A_ChangeVelocity(frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
            YAE6 A 1 Bright A_FadeOut(0.05);
            Loop;
    }
}

class PurpleTrailSparks : Actor
{
    Default
    {
        RenderStyle "Add";
        Scale 0.022;
        Alpha 0.95;
        +NOINTERACTION;
        +NOGRAVITY;
        +SQUAREPIXELS;
        +FORCEXYBILLBOARD;
    }
    States
    {
        Spawn:
            YA36 A 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
            YA36 A 0 A_SetScale(Scale.X - 0.00075);
            YA36 A 4 Bright A_ChangeVelocity(frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
            Loop;
    }
}

class PurpleTrailSparksSmall : Actor
{
    Default
    {
        RenderStyle "Add";
        Scale 0.01;
        Alpha 0.95;
        +NOINTERACTION;
        +NOGRAVITY;
    }
    States
    {
        Spawn:
            YA36 A 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
            YA36 A 0 A_SetScale(Scale.X - 0.00075);
            YA36 A 3 Bright A_ChangeVelocity(frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
            YA36 A 1 Bright A_FadeOut(0.05);
            Loop;
    }
}

class CryoRifleTrailSparksSmall : Actor
{
    Default
    {
        RenderStyle "Add";
        Scale 0.008;
        Alpha 0.95;
        +NOINTERACTION;
        +NOGRAVITY;
    }
    States
    {
        Spawn:
            YA36 B 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
            YA36 B 0 A_SetScale(Scale.X - 0.00075);
            YA36 B 3 Bright A_ChangeVelocity(frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
            YA36 B 1 Bright A_FadeOut(0.05);
            Loop;
    }
}

class ObeliskProjectile1 : ObeliskProjectile
{
    Default
    {
        Damage 100;
        Scale 1.1;
        DamageType "Blast";
        -RIPPER;
        MissileType "ObeliskTrail";
    }
}

class ObeliskProjectile2 : ObeliskProjectile
{
    Default
    {
        Scale 1.2;
        Damage 250;
        DamageType "Cut";
        -RIPPER;
        MissileType "ObeliskTrail2";
    }
}

class ObeliskProjectile3 : ObeliskProjectile
{
    Default
    {
        Scale 1.3;
        Damage 500;
        DamageType "Incinerate";
        +RIPPER;
        +NOBOSSRIP;
        MissileType "ObeliskTrail3";
    }
}

class ObeliskTrail2 : ObeliskTrail
{
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_SetScale(Scale.X, Scale.Y - 0.0875);
            YAE4 AA 2 Bright A_SpawnItemEx("ObeliskTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
        Trolololo:
            YAE4 A 0 A_JumpIf(Scale.Y <= 0, "NULL");
            YAE4 A 0 A_SetScale(Scale.X - 0.01, Scale.Y - 0.01);
            YAE4 A 1 Bright A_FadeOut(0.095);
            Loop;
    }
}

class ObeliskTrail3 : ObeliskTrail
{
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_SetScale(Scale.X, Scale.Y - 0.0875);
            YAE4 A 1;
            YAE4 AAA 1 Bright A_SpawnItemEx("ObeliskTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
        Trolololo:
            YAE4 A 0 A_JumpIf(Scale.Y <= 0, "NULL");
            YAE4 A 0 A_SetScale(Scale.X - 0.01, Scale.Y - 0.01);
            YAE4 A 1 Bright A_FadeOut(0.04);
            Loop;
    }
}

class LightningTrailSpark : Actor
{
    Default
    {
        RenderStyle "Add";
        Scale 0.0135;
        Alpha 0.95;
        +NOINTERACTION;
        +NOGRAVITY;
    }
    States
    {
        Spawn:
            YAE5 A 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
            YAE5 A 0 A_SetScale(Scale.X - 0.00075);
            YAE5 A 3 Bright A_ChangeVelocity(frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
            YAE5 A 1 Bright A_FadeOut(0.05);
            Loop;
    }
}

class LightningBall : FastProjectile
{
    Default
    {
        Speed 80;
        Height 8;
        Radius 8;
        Damage 1;
        Scale 0.55;
        RenderStyle "Add";
        Alpha 0.95;
        DeathSound "LightningHit";
        // +PROJECTILE;
        Decal "Scorch";
        +NOBLOCKMAP;
        +DROPOFF;
        +NOGRAVITY;
        +NOEXTREMEDEATH;
        +MTHRUSPECIES;
        +FRIENDLY;
        +SEEKERMISSILE;
        DamageType "Plasma";
    }

    States
    {
        Spawn:
            TNT1 A 0 A_SpawnItem("PlasmaFlare", 0, 0);
            DPLS A 1 Bright A_SpawnItemEx("LightningTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
            TNT1 A 0 Bright A_SpawnItem("PlasmaFlare", 0, 0);
            DPLS B 1 Bright A_SpawnItemEx("LightningTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
            TNT1 A 0 A_SpawnItem("PlasmaFlare", 0, 0);
            DPLS C 1 Bright A_SpawnItemEx("LightningTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
            TNT1 A 0 Bright A_SpawnItem("PlasmaFlare", 0, 0);
            DPLS D 1 Bright A_SpawnItemEx("LightningTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
            TNT1 A 0 Bright A_SpawnItem("PlasmaFlare", 0, 0);
            DPLS E 1 Bright A_SpawnItemEx("LightningTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
            TNT1 A 0 Bright A_SpawnItem("PlasmaFlare", 0, 0);
            DPLS F 1 Bright A_SpawnItemEx("LightningTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
            TNT1 A 0 A_SpawnItem("PlasmaFlare", 0, 0);
            TNT1 A 0 Bright A_SpawnItem("PlasmaFlare", 0, 0);
            DPLS G 1 Bright A_SpawnItemEx("LightningTrailSpark", random(4, -4), random(4, -4), random(4, -4), 0, 0, 0, 0, 0, 0);
            Goto Death;
        Death:
            TNT1 A 0 A_CustomMissile("BluePlasmaFire", 0, 0, random(0, 360), 2, random(0, 360));
            TNT1 AAAAA 0 A_CustomMissile("BluePlasmaParticle", 0, 0, random(0, 360), 2, random(0, 360));
            TNT2 AAA 0 A_CustomMissile("PlasmaSmoke", 1, 0, random(0, 360), 2, random(0, 160));
            Stop;
    }
}