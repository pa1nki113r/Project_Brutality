/*
PB_GibBase - for specific body parts like arms
PB_TinyGibBase - for small gibs like meat chunks
PB_LimbBase - for limbs 
*/

class PB_GibBase : Actor abstract
{
    TranslationID greenTranslation;
    TranslationID blueTranslation;
    property GreenColorTranslation : greenTranslation;
    property BlueColorTranslation : blueTranslation;

	Default 
	{
		Radius 10;
		Height 10;
		Health 100;
		Mass 1000;

		//+CLIENTSIDEONLY;
		+NOTELEPORT;
		+MOVEWITHSECTOR;
		+DONTSPLASH;
		+NOBLOCKMONST;
		-NOBLOCKMAP
		+GHOST;
		+THRUACTORS;
		+FLOORCLIP;
		+SLIDESONWALLS;
		+FORCEXYBILLBOARD;
		+NOTAUTOAIMED;
		-SOLID;
		+SHOOTABLE;
		
		BloodType "NashGoreBlood";
		Decal "BloodSplatSuper";

		DamageFactor "CauseObjectsToSplash", 0.0;
		DamageFactor "GibRemoving", 0.5;
		DamageFactor "Crush", 50.0;
		DamageFactor "Shrapnel", 100.0;
		DamageFactor "Plasma", 20.0;
		DamageFactor "Fire", 0.0;
		DamageFactor "TeleportRemover", 1000.0;
		DamageFactor "Blood", 0.0; 
		DamageFactor "GreenBlood", 0.0; 
		DamageFactor "BlueBlood", 0.0; 
		DamageFactor "Taunt", 0.0; 
		DamageFactor "KillMe", 0.0;
		DamageFactor "Avoid", 0.0; 
		DamageFactor "Taunt", 0.0;
		DamageFactor "Trample", 5000.0;

		PainChance 255;

        PB_GibBase.GreenColorTranslation "168:191=112:127", "16:47=123:127";
        PB_GibBase.BlueColorTranslation "168:191=192:207", "16:47=240:247";
	}

	override void BeginPlay(void)
	{
		ChangeStatNum(STAT_NashGore_Gore);
		NashGoreStatics.QueueGore();
		NashGoreStatics.RandomXFlip(self);
		Super.BeginPlay();

        switch(translation)
        {
            case 524289: // this is blue blood
                translation = blueTranslation;
                break;
            case 524290: // this is green blood
                translation = greenTranslation;
                break;
                
            default:
                break;
        }
	}

	override void PostBeginPlay(void)
	{
		if (random() < (255 - nashgore_gibamount)) { Destroy(); return; }
		Super.PostBeginPlay();
	}

	override void Tick(void)
	{
		Super.Tick();
		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;
		if (NashGoreStatics.CheckSky(self)) { Destroy(); return; }
	}
}

class PB_TinyGibBase : PB_GibBase abstract
{
	Default
	{
		Radius 2;
		Height 8;
		Mass 1;
		Speed 6;

		gravity 0.5;
		Scale 0.8;
		Decal "BloodSplat";

		//+CLIENTSIDEONLY;
		+NOBLOCKMAP;
		+MISSILE;

		SeeSound "nashgore/gibsmall";
		DeathSound "nashgore/gibsmall";
	}
}

class PB_LimbBase : PB_GibBase abstract
{   
	Default
	{
		Radius 6;
		Height 10;
		Health 35;

		DeathSound "misc/xdeath4";

		DamageFactor "Crush", 50.0;
		DamageFactor "Blood", 0.0;
		DamageFactor "GreenBlood", 0.0;
		DamageFactor "BlueBlood", 0.0;
		DamageFactor "Taunt", 0.0;
		DamageFactor "KillMe", 0.0;
		DamageFactor "Avoid", 0.0;
		DamageFactor "Taunt", 0.0;
		DamageFactor "Trample", 2.0;
		DamageFactor "Kick", 9.0;
		DamageFactor "Explosive", 0.1;
		DamageFactor "ExplosiveImpact", 9.1;
		DamageFactor "Shrapnel", 100.0;
		DamageFactor "Melee", 9.0;
		DamageFactor "SuperPunch", 9.0;
		DamageFactor "Plasma", 20.0;
	}
}