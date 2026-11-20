class PB_ProxMineToken : PB_Equipment {
	Default {
		Inventory.Icon "ALISTMIN";
		PB_Equipment.FontColor "Purple";
		PB_Equipment.AmmoType "PB_ProxMineAmmo";
		PB_Equipment.SelectString "$PB_PROXMINE_WHEEL";
		PB_Equipment.SelectSound "GRNPIN";
		PB_Equipment.FailString "$PB_PROXMINE_OUT";
	}
	
	States {
	UseEquipment:
		XPFF FEDCBA 1;
		XPFS B 4 A_StartSound("weapons/pbarm", 2);
		XHFF A 0 {
			A_StartSound("MINE002", 3);
			A_ThrowGrenade("PB_ThrownProxMine",4,11,1,0);
			A_TakeInventory("PB_ProxMineAmmo", 1, TIF_NOTAKEINFINITE);
		}
		XHFF MNOPQRSTUVWXYZ 1;
		TNT1 A 0 {
			A_TakeInventory("UseEquipment", 1);
			A_TakeInventory("ToggleEquipment", 1);
		}
		TNT1 A 0 PB_ReThrow();
		Stop;
	}
}

class PB_ProxMineAmmo : PB_Ammo
{
	Default
	{
		//$Title Proximity Mine
		//$Category Project Brutality/Weapons/Equipment
		//$Sprite XPFPA0
		Scale 0.35;
		Tag "$PB_PROXMINE_TAG";
		Inventory.Amount 1;
		Inventory.MaxAmount 6;
		Inventory.PickupSound "GRNPIN";
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 12;
		PB_Ammo.ammotype "proxmine";
	}
	
	override void AttachToOwner(actor other)
	{
		other.GiveInventory("PB_ProxMineToken",1);
		Super.AttachToOwner(other);
	}
}
