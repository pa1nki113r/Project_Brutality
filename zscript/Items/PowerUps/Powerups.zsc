//Invuln
class PB_Invul : PB_Inventory //replaces invulnerabilitysphere
{
	Default
	{
		//$Title Invulnerability Sphere
		//$Category Project Brutality/Powerups
		//$Sprite P1NVA0
		Tag "$PB_INVULN_TAG";
		Inventory.PickupMessage "$PB_INVULN_PICKUP";
		Inventory.PickupSound "INVUL";
		+FLOATBOB
		floatbobstrength .4;
		//Scale .22;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("DarkGreen",0.75,16);
		owner.A_GiveInventory("PB_InvulGiver");
		if(pb_newmugshot) owner.A_SetMugshotState("Grin");
		return true;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		scale.x *= 1.2;
	}
	States
	{
	Spawn:
		P1NV ABCDEFGHIJ 3;
		loop;
	}
}

class PB_InvulGiver : PB_PowerupGiver { Default { Powerup.Type "PB_PowerInvul"; } }

class PB_PowerInvul : PowerInvulnerable
{
	mixin PB_PowerupTimer;
	
	override void InitEffect()
	{
		Super.InitEffect();
		if(!Owner) return;
		owner.bNOBLOOD = true;
	}
	
	override void DoEffect()
	{
		Super.DoEffect();
		if(CVar.GetCVar("pb_powerup_shaders",Owner.Player).GetBool())
		{
			Shader.SetEnabled(Owner.Player,"Invulnerability",true);
			PPShader.SetUniform1f("Invulnerability","intensity",1.0);
		}
		else
		{
			Shader.SetEnabled(Owner.Player,"Invulnerability",false);
		}
		PowerupTimer("DarkGreen");
	}

	override void EndEffect()
	{
		Super.EndEffect();
		if(!Owner) return;
		Shader.SetEnabled(Owner.Player,"Invulnerability",false);
		EndBlend("DarkGreen");
		owner.bNOBLOOD = false;
	}
}

class PB_NoEffectInvul : PowerInvulnerable {}

//Rad suit
class PB_RadSuit : PB_Inventory //replaces radsuit
{
	Default
	{
		//$Title Hazmat Suit
		//$Category Project Brutality/Powerups
		//$Sprite SU1TA0
		Height 46;
		Tag "$PB_RADSUIT_TAG";
		Inventory.PickupMessage "$PB_RADSUIT_PICKUP";
		Inventory.PickupSound "misc/radsuit_PickUp";
		-BRIGHT
		-COUNTITEM
		//Scale .2;
	}

	override bool Use(bool pickup)
	{
		if(!PB_HelpNotificationsHandler.CheckTipEvent(1 << 7, CVar.GetCvar("pb_helpflags", owner.Player)))
		{
			Array<String> pbTipsBuf;
			pbTipsBuf.Push("$PB_RADSUIT_TIP");
			PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 7);
		}
		owner.A_SetBlend("Green",0.75,16);
		owner.A_GiveInventory("PB_SuitGiver");
		return true;
	}

	States
	{
	Spawn:
		SU1T A -1;
		stop;
	}
}

class PB_SuitGiver : PB_PowerupGiver { Default { Powerup.Type "PB_PowerIronFeet"; } }

class PB_PowerIronFeet : PowerIronFeet
{
	mixin PB_PowerupTimer;
	Default { Powerup.Color "000000",0; }

	//fuck you leaky suit, go away
	override void AbsorbDamage(int damage,name damageType,out int newdamage)
	{if((damagetype == 'Slime')||(damagetype == 'Drowning')) newdamage = 0; }
	
	Override Void ModifyDamage (Int Damage, Name DamageType, Out Int NewDamage, Bool Passive, Actor Inflictor, Actor Source, Int Flags)
	{
		If (Passive)
		{
			If (DamageType == 'Electric')
			{
				NewDamage = Damage * 0.75;
				//console.printf ("PB_Radsuit: Took %d %s damage from %s, reduced it to %d damage",damage,damageType,inflictor.getclassname(),newdamage);
				Return;
			}
			If (DamageType == 'Ice' || DamageType == 'Fire' || DamageType == 'Flames' || DamageType == 'Flame' || DamageType == 'Burn' || DamageType == 'PoisonCloud' || DamageType == 'Poison' ||
			DamageType == 'Disintegrate') //The Daedabus uses fucking disintegrating damage for some stupid reason.
			{
				NewDamage = Damage * 0;
				owner.player.poisoncount = 0;
				//console.printf ("PB_Radsuit: Took %d %s damage, reduced it to %d damage",damage,damageType,newdamage);
				Return;
			}
		}
	}
	
	override void DoEffect()
	{
		Super.DoEffect();
		PowerupTimer("Green");
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		EndBlend("Green");
	}
}

//Partial Invis
class PB_BlurSphere : PB_Inventory //replaces blursphere
{
	Default
	{
		//$Title Partial Invisibility
		//$Category Project Brutality/Powerups
		//$Sprite P1N5A0
		RenderStyle "Translucent";
		Tag "$PB_BLURSPHERE_TAG";
		Inventory.PickupMessage "$PB_BLURSPHERE_PICKUP";
		Inventory.PickupSound "INVISIBL";
		+FLOATBOB
		floatbobstrength .4;
		//Scale .22;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		scale.x *= 1.2;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Red",0.75,16,"Blue");
		owner.A_GiveInventory("PB_InvisGiver");
		return true;
	}

	States
	{
	Spawn:
		P1N5 ABCBJBABCJBCDEFGHIBJ 3;
		loop;
	}
}

class PB_InvisGiver : PB_PowerupGiver { Default { Powerup.Type "PB_PowerInvis"; } }

class PB_PowerInvis : PowerInvisibility
{
	mixin PB_PowerupTimer;
	
	override void DoEffect()
	{
		Super.DoEffect();
		Owner.A_SetRenderStyle(.5, STYLE_Subtract);
		PowerupTimer("Red", "Blue");
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		EndBlend("Red", "Blue");
	}
}

//Light amp goggles
class PB_Infrared : PB_Inventory //replaces infrared
{
	Default
	{
		//$Title Night Vision Goggles
		//$Category Project Brutality/Powerups
		//$Sprite PV1SA0
		-BRIGHT
		Tag "$PB_INFRARED_TAG";
		Inventory.PickupMessage "$PB_INFRARED_PICKUP";
		Inventory.PickupSound "RA1IF1";
		//Scale .3;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Black",0.75,16);
		owner.A_GiveInventory("PB_InfraredGiver");
		return true;
	}

	States
	{
	Spawn:
		PV1S A -1;
		stop;
	}
}

class PB_InfraredGiver : PB_PowerupGiver { Default { Powerup.Type "PB_PowerLightAmp"; } }

class PB_PowerLightAmp : PowerTorch
{
	mixin PB_PowerupTimer;
	float exposureadjust;
	Default { +INVENTORY.NOSCREENBLINK }
	
	override void InitEffect()
	{
		Super.InitEffect();
		exposureadjust = (255 - owner.player.mo.cursector.lightlevel) / 16;
	}
	
	override void DoEffect()
	{
		if(CVar.GetCVar("pb_powerup_shaders",Owner.Player).GetBool())
		{
			Super.EndEffect();
			float sectorlightlevel = (255 - owner.player.mo.cursector.lightlevel) / 16;
			
			if(exposureadjust > sectorlightlevel)
				exposureadjust = clamp(exposureadjust * 0.95,sectorlightlevel,255);
			if(exposureadjust < sectorlightlevel)
				exposureadjust = clamp(exposureadjust * 1.05,0.05,sectorlightlevel);
			
			Shader.SetEnabled(Owner.Player,"NightVision",true);
			Shader.SetUniform1f(Owner.Player, "NightVision", "timer", Level.time / 6.0);
			Shader.SetUniform1f(Owner.Player, "NightVision", "exposure", 1 + (exposureadjust * exposureadjust / 8.0) * CVar.GetCVar("pb_nightvision_exposure",Owner.Player).GetFloat());
			Shader.SetUniform1f(Owner.Player, "NightVision", "darken", 1);
			Shader.SetUniform3f(Owner.Player, "NightVision", "hsl", (0.33, 1.0, 0.5));
		}
		else
		{
			Super.DoEffect();
			Shader.SetEnabled(Owner.Player,"NightVision",false);
		}
		PowerupTimer("Black");
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		Shader.SetEnabled(Owner.Player,"NightVision",false);
		EndBlend("Black");
	}
}

//Soulsphere & Megasphere
class PB_Soulsphere : PB_Health //replaces soulsphere
{
	Default
	{
		//$Title Soulsphere
		//$Category Project Brutality/Powerups
		//$Sprite SOU1A0
		Tag "$PB_SOULSPHERE_TAG";
		Inventory.PickupSound "SSPH";
		Inventory.Amount 100;
		Inventory.MaxAmount 200;
		Inventory.PickupMessage "$PB_SOULSPHERE_PICKUP";
		Health.LowMessage 25, "$PB_SOULSPHERE_PICKUP_LOW";
		+INVENTORY.ALWAYSPICKUP
		+FLOATBOB
		+SQUAREPIXELS
		+COUNTITEM
		floatbobstrength .4;
		Scale 1.2;
		//Scale .22;
	}

	override bool TryPickup (in out Actor other) {
		other.A_SetBlend("Blue",0.75,16);
		if(other.player && CVar.GetCVar("pb_newmugshot", other.player).GetBool())
			other.A_SetMugshotState("SoulsphereGrin");
		return super.TryPickup(other);
	}
	
	States
	{
	Spawn:
		SOU1 ABCDEFGHIJ 3;
		loop;
	}
}

class PB_Megasphere : PB_Inventory //replaces megasphere
{
	int ownHP, ownAP;
	
	Default
	{
		//$Title Megasphere
		//$Category Project Brutality/Powerups
		//$Sprite MEG4A0
		Tag "$PB_MEGASPHERE_TAG";
		Inventory.PickupMessage "$PB_MEGASPHERE_PICKUP";
		Inventory.PickupSound "MEGASPH";
		+FLOATBOB
		+SQUAREPIXELS
		floatbobstrength .4;
		Scale 1.2;
		//Scale .22;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White",0.75,16);
		ownHP = clamp(200 - owner.health, 0, 200);
		ownAP = clamp(200 - owner.CountInv("BasicArmor"), 0, 200);
		owner.GiveBody(200, 200);
		owner.A_GiveInventory("PB_MegasphereBlueArmor");
		if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
		return true;
	}
	
	override string PickupMessage(){
		string msg = string.format(StringTable.Localize(Super.PickupMessage()), ownHP, ownAP);
		return msg;
	}

	States
	{
	Spawn:
		MEG4 ABCDEFGHIJ 3;
		loop;
	}
}

class PB_MegasphereBlueArmor : BasicArmorPickup {
	Default	{
		Tag "$PB_BLUEARMOR_TAG";
		Armor.SavePercent 70;
		Armor.SaveAmount 200;
		Inventory.Icon "4RM2A0";
	}
}

//Berserk and AllMap
class PB_PowerStrength : PowerStrength { Default { Powerup.Color "000000",0; } }

class PB_Berserk : PB_Inventory //replaces Berserk
{
	int ownHP;
	
	Default
	{
		//$Title Berserk
		//$Category Project Brutality/Powerups
		//$Sprite PST1A0
		-BRIGHT
		Tag "$PB_BERSERK_TAG";
		Inventory.PickupSound "BERSPKUP";
		//Scale .3;
	}

	override bool Use(bool pickup)
	{
		if(!PB_HelpNotificationsHandler.CheckTipEvent(1 << 6, CVar.GetCvar("pb_helpflags", owner.Player)))
		{
			Array<String> pbTipsBuf;
			pbTipsBuf.Push("$PB_BERSERK_TIP_1");
			pbTipsBuf.Push(string.format(StringTable.Localize("$PB_BERSERK_TIP_2"), PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
			PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 6);
		}
		owner.A_GiveInventory("PB_PowerStrength");
		ownHP = owner.health;
		owner.GiveBody(100,0);
		owner.A_SetBlend("Red",0.75,16);
		if(pb_newmugshot) owner.A_SetMugshotState("BerserkGrin");
		return true;
	}

	override string PickupMessage() {
		string msg = StringTable.Localize("$PB_BERSERK_PICKUP");
		if(ownHP < 25) msg = StringTable.Localize("$PB_BERSERK_PICKUP_LOW");
		return string.format(msg, max(0, 100 - ownHP));
	}
	
	States
	{
	Spawn:
		PST1 A -1;
		stop;
	}
}

class PB_AllMap : AllMap //replaces AllMap
{
	mixin PB_BetterPickupSound;
	Default 
	{ 
		//$Title Computer Area Map
		//$Category Project Brutality/Powerups
		//$Sprite PMA1A0
		Tag "$PB_ALLMAP_TAG";
		Inventory.PickupMessage "$PB_ALLMAP_PICKUP";
		Inventory.PickupSound "misc/map_PickUp"; 
		//Scale .31;
	}
	States
	{
	Spawn:
		PMA1 AFFAAAFFAFAFAFBCDEF 2 BRIGHT;
		loop;
	}
}

//Quad Damage
class PB_Doomsphere : PB_Inventory
{
	Default
	{
		//$Title Quad Damage
		//$Category Project Brutality/Powerups
		//$Sprite QDMGA0
		Tag "$PB_QUAD_TAG";
		Inventory.PickupMessage "$PB_QUAD_PICKUP";
		Inventory.PickupSound "DDMGPU";
		-COUNTITEM
		+FLOATBOB
		floatbobstrength .1;
		xscale 0.30;
		yscale 0.25;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("FF62FF",0.75,16);
		owner.A_GiveInventory("PB_DoomGiver");
		
		for(int i = 0; i < 50; i++)
		{
			A_SpawnParticleEx("FF62FF", TexMan.CheckForTexture("glstuff/glpart.png"), STYLE_Add, SPF_FULLBRIGHT | SPF_RELACCEL, random(35, 140), frandom(2.0, 3.0), frandom(0, 360), zoff: 30, velx: frandom(-4, 4) + owner.vel.x, frandom(-4, 4) + owner.vel.y, frandom(-4, 4) + owner.vel.z, frandom(-1.5, 0), frandom(-1.5, 0), frandom(-1.5, 0.25), startalphaf: frandom(0.75, 1.0), sizestep: -0.01);
		}
		
		return true;
	}

	States
	{
	Spawn:
		QDMG A 1 BRIGHT {
			frame = random(0, 5);
			tics = random(2, 8);
			
			if(tics < 4 && randompick(0, 1))
				A_SetRenderStyle(alpha, STYLE_ADD);
			else
				A_SetRenderStyle(alpha, STYLE_Translucent);
		}
		loop;
	}
}

class PB_DoomGiver : PB_PowerupGiver { Default { Powerup.Type "PB_PowerDoomDamage"; } }

class PB_PowerDoomDamage : PowerDamage
{
	mixin PB_PowerupTimer;
	Default { DamageFactor "normal",4; Powerup.Duration -30; }

	override void InitEffect()
	{
		Super.InitEffect();
		if(!Owner) return;
		owner.A_AttachLightDef("DoomLight","DoomLight");
	}
	
	override void DoEffect()
	{
		Super.DoEffect();
		PowerupTimer("Purple");
	}

	override void EndEffect()
	{
		Super.EndEffect();
		if(!Owner) return;
		EndBlend("Purple");
		owner.A_RemoveLight("DoomLight");
	}
}

//Haste sphere
class PB_Haste : PB_Inventory
{
	Default
	{
		//$Title Haste
		//$Category Project Brutality/Powerups
		//$Sprite HASTA0
		Tag "$PB_HASTE_TAG";
		Inventory.PickupMessage "$PB_HASTE_PICKUP";
		Inventory.PickupSound "DEM";
		renderstyle "add";
		-COUNTITEM
		+FLOATBOB
		floatbobstrength .4;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Yellow",0.75,16);
		owner.A_GiveInventory("PB_HasteGiver");
		return true;
	}

	States
	{
	Spawn:
		HAST ABC 6;
		loop;
	}
}

class PB_HasteGiver : PB_PowerupGiver { Default { Powerup.Type "PB_PowerSpeed"; } }

class PB_PowerSpeed : PowerSpeed
{
	mixin PB_PowerupTimer;
	Default { Powerup.Duration -30; }

	override void InitEffect()
	{
		Super.InitEffect();
		if(!Owner) return;
		owner.A_AttachLightDef("HasteLight","HasteLight");
	}
	
	override void DoEffect()
	{
		Super.DoEffect();
		PowerupTimer("Yellow");
	}

	override void EndEffect()
	{
		Super.EndEffect();
		if(!Owner) return;
		EndBlend("Yellow");
		owner.A_RemoveLight("HasteLight");
	}
}
