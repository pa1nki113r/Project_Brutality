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
		TNT1 A 0 A_Giveinventory("PlayerIsThrowingAGrenade",1);
		HNDF ABCDE 1 A_SetRoll(roll+2.0, SPF_INTERPOLATE);
		HNDF FGHI 1 {
			A_SetRoll(roll+2.0, SPF_INTERPOLATE);
			if(JustPressed(BT_USER1)) {
				A_GiveInventory("UseEquipment",1);
			}
		}
		TNT1 A 0 A_StartSound("OPNGRN",0);
		HNDF JKLMNOPQR 1 {
			A_SetRoll(roll+2.0, SPF_INTERPOLATE);
			if(JustPressed(BT_USER1)) {
				A_GiveInventory("UseEquipment",1);
			}
		}
		TNT1 A 0 A_JumpIfInventory("UseEquipment", 1, "TossGrenade");
		TNT1 A 1 A_SetRoll(roll-18.0);
		HND1 I 1 A_StartSound("THRGRN",0);
		HND1 J 1 {
			A_FireProjectile("PB_ThrownGrenade",0,0,0,0,0,0);
			A_TakeInventory("PB_GrenadeAmmo", 1, TIF_NOTAKEINFINITE);
			A_FireProjectile("Alerter",0,0,0,0,0,0);
		}
		HND1 KLMNOPQ 1 A_SetRoll(roll-5.0);
		TNT1 A 0 {
			A_SetRoll(0, SPF_INTERPOLATE);
			A_TakeInventory("UseEquipment", 1);
			A_TakeInventory("ToggleEquipment", 1);
			A_TakeInventory("PlayerIsThrowingAGrenade", 1);
		}
		TNT1 A 0 PB_ReThrow();
		Stop;
	TossGrenade:
		TNT1 A 1;
		HND1 RSTU 1 A_SetRoll(roll-1.5, SPF_INTERPOLATE);
		TNT1 A 0 {
			A_StartSound("THRGRN", 1);
			A_TakeInventory("PB_GrenadeAmmo", 1, TIF_NOTAKEINFINITE);
			A_FireProjectile("Alerter",0,0,0,0,0,0);
			A_FireProjectile("ThrownGrenade15", 0,0,0,-2,0,3);
		}
		HND1 VWXY 1 A_SetRoll(roll-1.5, SPF_INTERPOLATE);
		TNT1 A 0 {
			A_SetRoll(0);
			A_TakeInventory("UseEquipment", 1);
			A_TakeInventory("ToggleEquipment", 1);
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
