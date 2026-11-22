class PB_FragGrenadeToken : PB_Equipment {
	Default {
		Inventory.Icon "ALISTGRN";
		PB_Equipment.FontColor "Green";
		PB_Equipment.AmmoType "PB_GrenadeAmmo";
		PB_Equipment.SelectString "$PB_FRAGGRENADE_WHEEL";
		PB_Equipment.SelectSound "GRNPIN";
		PB_Equipment.FailString "$PB_FRAGGRENADE_OUT";
	}
	
	States {
	UseEquipment:
		TNT1 A 0 A_GiveInventory("PlayerIsThrowingAGrenade",1);
		HNDF ABCDE 1 PB_SetRoll(roll+2.0);
		TNT1 A 0 A_DoubleTapFlag();
		HNDF FGHI 1 PB_SetRoll(roll+2.0);
		TNT1 A 0 A_StartSound("OPNGRN",0);
		HNDF JKLMNOPQR 1;
		TNT1 A 0 A_JumpIf(HasDoubleTapped(), "TossGrenade");
		TNT1 A 1 PB_SetRoll(roll-18.0);
		HND1 I 1 A_StartSound("THRGRN",0);
		HND1 J 1 {
			A_FireProjectile("PB_ThrownGrenade");
			A_TakeInventory("PB_GrenadeAmmo", 1, TIF_NOTAKEINFINITE);
			A_FireProjectile("Alerter");
		}
		HND1 KLMNOPQ 1 PB_SetRoll(roll-5.0);
		TNT1 A 0 {
			PB_SetRoll(0);
			A_TakeInventory("PlayerIsThrowingAGrenade", 1);
		}
		TNT1 A 0 PB_ReThrow();
		Stop;
	TossGrenade:
		TNT1 A 1;
		HND1 RSTU 1 PB_SetRoll(roll-1.5);
		TNT1 A 0 {
			A_StartSound("THRGRN", 1);
			A_TakeInventory("PB_GrenadeAmmo", 1, TIF_NOTAKEINFINITE);
			A_FireProjectile("Alerter");
			A_FireProjectile("ThrownGrenade15", spawnheight:-2, pitch:3);
		}
		HND1 VWXY 1 PB_SetRoll(roll-1.5);
		TNT1 A 0 {
			PB_SetRoll(0);
			A_TakeInventory("PlayerIsThrowingAGrenade", 1);
		}
		TNT1 A 0 PB_ReThrow();
		Stop;
	}
}

class PB_GrenadeAmmo : PB_Ammo
{
	Default
	{
		//$Title Frag Grenade
		//$Category Project Brutality/Weapons/Equipment
		//$Sprite PGRNA0
		Scale 0.45;
		Tag "$PB_FRAGGRENADE_TAG";
		Inventory.Amount 1;
		Inventory.MaxAmount 6;
		Inventory.PickupSound "GRNPIN";
		Inventory.Icon "PGRND0";
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 12;
		PB_Ammo.AmmoType "nade";
	}
	
	override void AttachToOwner(actor other) //we have to do this here so that cheats will give the tokens
	{
		other.GiveInventory("PB_FragGrenadeToken",1);
		Super.AttachToOwner(other);
	}
}
