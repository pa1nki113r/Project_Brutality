class PB_StunGrenadeToken : PB_Equipment {
	Default {
		Inventory.Icon "ALISTSTN";
		PB_Equipment.FontColor "Cyan";
		PB_Equipment.AmmoType "PB_StunGrenadeAmmo";
		PB_Equipment.SelectString "$PB_STUNGRENADE_WHEEL";
		PB_Equipment.SelectSound "StunGrenadePickup";
		PB_Equipment.FailString "$PB_STUNGRENADE_OUT";
	}
	
	States {
	UseEquipment:
		STNG BCDEF 1;
		STNG F 1 Offset(-2,34);
		TNT1 A 0 A_StartSound("StunGrenadeArm", 2);
		STNG GIJJJIHGKLMNOP 1;
		HND1 I 1 A_StartSound("THRGRN", 1);
		TNT1 A 0 A_TakeInventory("PB_StunGrenadeAmmo", 1, TIF_NOTAKEINFINITE);
		HND1 J 1 A_FireProjectile("PB_ThrownStunGrenade",0,0,0,0,0,0);
		HND1 KLMNOPQ 1;
		TNT1 A 0 {
			A_TakeInventory("UseEquipment", 1);
			A_TakeInventory("ToggleEquipment", 1);
		}
		TNT1 A 0 PB_ReThrow();
		Stop;
	}
}

class PB_StunGrenadeAmmo : PB_Ammo
{
	Default
	{
		//$Title Stun Grenade
		//$Category Project Brutality/Weapons/Equipment
		//$Sprite STNGA0
		Scale 0.6;
		Tag "$PB_STUNGRENADE_TAG";
		Inventory.Amount 1;
		Inventory.MaxAmount 6;
		Inventory.PickupSound "StunGrenadePickup";
		Inventory.Icon "STNGA0";
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 12;
		PB_Ammo.ammotype "nadestun";
	}
	
	override void AttachToOwner(actor other)
	{
		other.GiveInventory("PB_StunGrenadeToken",1);
		Super.AttachToOwner(other);
	}
}
