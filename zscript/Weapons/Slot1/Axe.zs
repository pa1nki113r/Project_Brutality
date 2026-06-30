class PB_Axe : PB_WeaponBase
{
    Default
    {
        //$Title Fire Axe
        //$Category Project Brutality - Weapons
        //$Sprite AXE0A0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        damagetype "Saw";
        PB_WeaponBase.LeftHandMelee 1;
        Inventory.AltHUDIcon "AXE0A0";
        Inventory.MaxAmount 4;
        Scale 0.7;
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        AttackSound "None";
        Inventory.PickupSound "AXEDRAW";
        Inventory.Pickupmessage "$PB_AXE_PICKUP";
        Obituary "%o was chopped down by %k's axe.";
        Tag "$PB_AXE_TAG";
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +WEAPON.MELEEWEAPON;
        +WEAPON.AXEBLOOD;
        +WEAPON.NOALERT;
        +DONTGIB;
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    int attackSequence;

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    action int Axe_GetSequence()
    {
        return invoker.attackSequence;
    }

    action void Axe_SetSequence(int set)
    {
        invoker.attackSequence = set;
    }

    action void Axe_SwingWeapon(int swing, int tic)
    {
        switch(swing)
        {
            default:
            // Swing 1
            case 1:
            switch(tic)
            {
                case 0:
                A_PlaySound("AXSWING");
                PB_SetRoll(0);
                Axe_SetSequence(1);
                break;

                case 1: case 2:
                Axe_ChangeModeSprite("AX13","AX12","AX11","AX10");
                PB_SetRoll(roll-1.0);
                A_SetAngle(angle+0.5, SPF_INTERPOLATE);
                break;

                case 3: case 4:
                PB_SetRoll(roll+1.0);
                A_SetAngle(angle-0.5, SPF_INTERPOLATE);
                break;
            }
            break;

            // Swing 2
            case 2: 
            switch(tic)
            {
                case 0:
                A_PlaySound("AXSWING");
                PB_SetRoll(0);
                if(Axe_GetSequence() == 2) {
                    A_OverlayFlags(PSP_WEAPON, PSPF_FLIP|PSPF_MIRROR, true);
                    Axe_SetSequence(1);
                } else {
                    A_OverlayFlags(PSP_WEAPON, PSPF_FLIP|PSPF_MIRROR, false);
                    Axe_SetSequence(2);
                }
                break;

                case 1: case 2:
                Axe_ChangeModeSprite("AX23","AX22","AX21","AX20");
                PB_SetRoll(roll - 1.0);
                A_SetAngle(angle + (tic == 1 ? 1.0 : 0.5), SPF_INTERPOLATE);
                break;

                case 3: case 4:
                PB_SetRoll(roll + 1.0);
                A_SetAngle(angle - 0.5, SPF_INTERPOLATE);
                break;
            }
            break;

            // Throw Axe (Altfire)
            case 3:
            switch(tic)
            {
                // Start Altfire
                case 0:
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(90);
                A_SetInventory("PB_LockScreenTilt",1);
                A_PlaySound("AXTHROW");
                break;

                case 1:
                PB_SetRoll(roll+0.5);
                break;
                
                // Hold ALtfire
                case 2:
                A_PlaySound("AXSWING", 1);
                A_PlaySound("weapons/axe/throw", 3);
                break;

                case 3:
                PB_SetRoll(roll-5.0);
                break;
                
                // Throw Axe
                case 4:
                Axe_Throw();
                A_SetInventory("HasCutingWeapon",0);
                break;

                case 5:
                PB_SetRoll(roll+4.25);
                break;

                case 6:
                PB_SetRoll(0);
                A_SetInventory("PB_LockScreenTilt",0);
                break;
            }
            break;
        }
    }

    action void Axe_SwingAttack()
    {
        if(invoker.OwnerHasBerserk()) {
            A_Saw("", "", 123, "AxePuffs", SF_NORANDOM, 120, 0,16);
            A_FireCustomMissile("SuperAxeAttack", 0, 0, 0, 0);
        }
        else {
            A_Saw("", "", 70, "AxePuffs", SF_NORANDOM, 120, 0,16);
            A_FireCustomMissile("AxeAttack", 0, 0, 0, 0);
        }
    }

    action void Axe_Throw()
    {
        let axe = PB_ThrownAxe(A_FireProjectile("PB_ThrownAxe"));
		if(axe) {
			if(PB_IsVisorBlood()) {
				switch(PB_GetVisorBlood()) {
				case REDBLOODVISOR:
					axe.bloodstain = 1;
					break;
				case BLUEBLOODVISOR:
					axe.bloodstain = 2;
					break;
				case GREENBLOODVISOR:
					axe.bloodstain = 3;
					break;
				}
			}
			axe.berserked = FindInventory("PB_PowerStrength");
		}
    }

    action void Axe_ChangeModeSprite(
        name greenblood, 
        name blueblood, 
        name redblood, 
        name defaultsprite, 
        int layer = PSP_WEAPON)
    {
		let psp = player.findpsprite(layer);
		if(!psp) return;

        name sprite;

        if(PB_IsVisorBlood())
        {
            switch(PB_GetVisorBlood())
            {
                case REDBLOODVISOR:     sprite = redblood;     break;
                case GREENBLOODVISOR:   sprite = greenblood;   break;
                case BLUEBLOODVISOR:    sprite = blueblood;    break;
            }
        }
        else
            sprite = defaultsprite;

        psp.sprite = GetspriteIndex(sprite);
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            VAX0 A 0 NoDelay;
			AXE0 A 10 A_PbvpFramework("VAX0");
			"####" A 0 A_PbvpInterpolate();
			loop;

        Deselect:
           TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(90);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			TNT1 A 0 A_SetInventory("HasCutingWeapon",0);
			
			AX00 FGHI 1 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
			TNT1 A 1 A_Lower();
			Wait;
            
		Select:
			TNT1 A 0 {
                PB_WeapTokenSwitch("HasCutingWeapon");
				PB_HandleCrosshair(90);
			    PB_ResetVisorBloodTokens();
                PB_WeaponRaise("AXEDRAW");
			    return PB_RespectIfNeeded();
            }
        // No Weapon Special
		SelectAnimation:
			AX00 ABCD 1 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
        WeaponSpecial:
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
            // Fallthrough to ready
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
            // Cache Sprites
            AX00 ABCDEFGHI 0;
            AX01 ABCDEFGHI 0;
            AX02 ABCDEFGHI 0;
            AX03 ABCDEFGHI 0;
            // Actual Ready
			TNT1 A 0 {
				PB_SetRoll(0);
				PB_HandleCrosshair(90);
				A_SetInventory("PB_LockScreenTilt",0);
				Axe_SetSequence(0);
			}
		ReadyToFire:
			AX00 E 1 {
                Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
                return A_DoPBWeaponAction();
			}
			Loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(90);
			}
			TNT1 A 0 A_SetInventory("PB_LockScreenTilt",1);
			TNT1 A 0 A_JumpIf(Axe_GetSequence() == 1,"Swing2");
		Swing1:
            // Cache Sprites
			AX10 ABCDEF 0;
			AX11 ABCDEF 0;
			AX12 ABCDEF 0;
			AX13 ABCDEF 0;
            // Actual Swing
			TNT1 A 0 Axe_SwingWeapon(1,0);
			AX10 ABC 1 Axe_SwingWeapon(1,1);
			TNT1 A 0 Axe_SwingAttack(); // Deals Damage
			AX10 DEF 1 Axe_SwingWeapon(1,2);
			TNT1 AAA 1 Axe_SwingWeapon(1,3);
			TNT1 AAA 1 {
				Axe_SwingWeapon(1,4);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 PB_ReFire("Fire");
			AX00 ABCD 1 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
			Goto Ready3;

		Swing2:
            // Cache Sprites
			AX20 ABCDEF 0;
			AX21 ABCDEF 0;
			AX22 ABCDEF 0;
			AX23 ABCDEF 0;
            // Actual Swing
			TNT1 A 0 Axe_SwingWeapon(2,0);
			AX20 ABC 1 Axe_SwingWeapon(2,1);
			TNT1 A 0 Axe_SwingAttack(); // Deals Damage
			AX20 DEF 1 Axe_SwingWeapon(2,2);
			TNT1 AAA 1 Axe_SwingWeapon(2,3);
			TNT1 AAA 1 {
				Axe_SwingWeapon(2,4);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 PB_ReFire("Swing2");
			TNT1 A 0 A_OverlayFlags(PSP_WEAPON,PSPF_FLIP|PSPF_MIRROR,false);
			AX00 ABCD 1 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
			Goto Ready3;

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
        Altfire:
            // Cache Sprites
            AX30 ABCDEFGHIJKLMNOPQ 0;
            AX31 ABCDEFGHIJKLMNOPQ 0;
			AX32 ABCDEFGHIJKLMNOPQ 0;
			AX33 ABCDEFGHIJKLMNOPQ 0;
            // Actual Throw
			TNT1 A 0 Axe_SwingWeapon(3,0);
			AX30 ABCDEFGHIJKLM 1 {
                Axe_ChangeModeSprite("AX33","AX32","AX31","AX30");
                Axe_SwingWeapon(3,1);
			}
		AltHold:
			AX30 N 1 Axe_ChangeModeSprite("AX33","AX32","AX31","AX30");
			TNT1 A 0 PB_ReFire();
			TNT1 A 0 Axe_SwingWeapon(3,2);
			AX30 OPQ 1 {
                Axe_ChangeModeSprite("AX33","AX32","AX31","AX30");
				Axe_SwingWeapon(3,3);
			}
			TNT1 A 0 Axe_SwingWeapon(3,4); // Throw
			TNT1 A 0 A_JumpIf(CountInv("PB_Axe") < 1, "OutOfAxe");
			TNT1 A 0 A_TakeInventory("PB_Axe", 1);
			THRF EF 1 Axe_SwingWeapon(3,5);
			TNT1 A 0 Axe_SwingWeapon(3,6);
			TNT1 A 10;
			Goto Select;

        OutOfAxe:
            TNT1 A 0 {
				PB_SetRoll(0);
				A_SelectWeapon("PB_Fists");
				A_TakeInventory("PB_Axe", 1);
			}
			Stop;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        FlashPunching:
			TNT1 A 0 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
            "####" DCBA 1;
            "####" Z 6;
            "####" ABCD 1;
            Goto Ready3;

        FlashKicking:
        FlashAirKicking:
			TNT1 A 0 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
            "####" DCBA 1;
            "####" Z 7;
            "####" ABCD 1;
            Goto Ready3;
            
        FlashSlideKicking:
			TNT1 A 0 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
            "####" DCBAZZZZZZZZZZZZZZZZZABCD 1;
            Goto Ready3;
        
        FlashSlideKickingStop:
			TNT1 A 0 Axe_ChangeModeSprite("AX03","AX02","AX01","AX00");
            "####" ZZABCD 1;
            Goto Ready3;
    }
}

//////////////////////////// PROJECTILES/OTHERS ////////////////////////////////////////////////////////////////////////////////////
class AxeAttack : PB_ProjectileAlt
{
    Default
    {
        Radius 8;
        Height 1;
        DamageType "Saw";
        +MISSILE;
        +FORCEXYBILLBOARD;
        +BLOODSPLATTER;
        +NOGRAVITY;
        -NOEXTREMEDEATH;
        -NODAMAGETHRUST;
        -RIPPER;
        RenderStyle "Add";
        Alpha 0.6;
        PB_Projectile.BaseDamage 52;
        PB_Projectile.HeadSizeMultiplier 1.25;
        Speed 30;
        SeeSound "none";
        DeathSound "none";
        Decal "SawDecalNew1";
        Scale 0.01;
    }

    States
    {
        Spawn:
		TNT1 A 0;
		TNT1 A 1 BRIGHT;
		Stop;
	    Death:
            TNT1 A 0;
            TNT1 A 0;
            TNT1 AB 1 bright;
            TNT1 A 0 A_SpawnItem ("Sparks", 0);
            TNT1 A 0 A_PlaySound("AXECLN", 6);
            TNT1 A 0 A_ALertMonsters(400);
            TNT1 AAAAAAAA 0 A_CustomMissile ("SparkX", 2, 0, random (0, 360), 2, random (30, 170));
            TNT1 AAA 0 A_CustomMissile ("HitSpark", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
            TNT1 AAA 0 A_CustomMissile ("HitSpark22", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
            TNT1 AAA 0 A_CustomMissile ("HitSpark23", 2, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
            TNT1 A 0 Radius_Quake (2, 6, 0, 5, 0); //(intensity, duration, damrad, tremrad, tid)
            BPUF C 1 BRIGHT;
            BPUF D 1 bright;
            TNT1 A 10;
            Stop;
        XDeath:
        Melee:
        Crash:
            TNT1 A 0;
            PUFF A 0 A_PlaySound("player/cyborg/fist", 3);
            PUFF A 0 A_PlaySound("AXEHIT", 3);
            TNT1 A 0 A_PlaySound("Machete/Yum", 6);
            TNT1 A 0 A_SpawnItemEx ("PLOFT2",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            TNT1 A 0 Radius_Quake (2, 6, 0, 5, 0); //(intensity, duration, damrad, tremrad, tid)
            TNT1 A 10;
            Stop;
    }
}

class SuperAxeAttack : AxeAttack {
	Default {
		PB_Projectile.BaseDamage 91;
		PainType "ExtremePunches";
	}
}

class PB_ThrownAxe : PB_ProjectileAlt {
	Default {
		Radius 6;
		Height 8;
		Speed 24;
		PB_Projectile.BaseDamage 270;
		PB_Projectile.RipperCount 2;
		Scale 0.7;
		Gravity 0.25;
		DamageType "Cut";
		Decal "None";
		+PB_Projectile.OMNIDIRECTIONAL
		-NOGRAVITY
	}
	
	int bloodstain;
	bool berserked;
	
	override void PostBeginPlay() {
		super.PostBeginPlay();
		if(berserked) {
			vel *= 1.5;
			bRIPPER = true;
			truedamage = 472;
		}
	}
	
	States
	{
	Spawn:
		AXE0 A 0 NoDelay {
			sprite = GetSpriteIndex("AXE"..bloodstain);
			if(V5_MODELS) sprite = GetSpriteIndex("VAX"..bloodstain);
			if(berserked) return resolvestate("FlyBerserked");
			return resolvestate(null);
		}
	Fly:
		#### BCDEFGHIJKLMNOPQ 2;
		Loop;
	FlyBerserked:
		#### BCDEFGHIJKLMNOPQ 1;
		Loop;
	Death:
		TNT1 A 0 {
			A_SpawnItem("Sparks", 0);
			A_StartSound("AXEWALL", 6);
			A_AlertMonsters(400);
			for(int i = 0; i < 4; i++) {
				A_CustomMissile ("SparkX", 2, 0, random (0, 360), 2, random (30, 170));
				A_CustomMissile ("SparkX", 2, 0, random (0, 360), 2, random (30, 170));
				A_CustomMissile ("HitSpark", 2, 0, frandom(0, 1) * frandom (0, 360), 2, frandom(0, 1) * frandom (30, 360));
				A_CustomMissile ("HitSpark22", 2, 0, frandom(0, 1) * frandom (0, 360), 2, frandom(0, 1) * frandom (30, 360));
				A_CustomMissile ("HitSpark23", 2, 0, frandom(0, 1) * frandom (0, 360), 2, frandom(0, 1) * frandom (30, 360));
			}
			A_SpawnItemEx("PB_Axe");
		}
		Stop;
	XDeath:
		TNT1 A 0 {
			A_StartSound("AXEHIT", 3);
			A_StartSound("Machete/Yum", 6);
			A_SpawnItemEx("PLOFT2");
			A_SpawnItemEx("PB_Axe");
		}
		Stop;
	CacheSprites:
		VAX0 A 0;
		VAX1 A 0;
		VAX2 A 0;
		VAX3 A 0;
		AXE1 A 0;
		AXE2 A 0;
		AXE3 A 0;
	}
}