class PB_LeechToken : PB_Equipment {
	Default {
		Inventory.Icon "ALISTLCH";
		PB_Equipment.FontColor "PB_DTech";
		PB_Equipment.AmmoType "PB_DTech";
		PB_Equipment.SelectString "$PB_LEECH_WHEEL";
		PB_Equipment.SelectSound "SiphonGrowl";
		PB_Equipment.FailString "$PB_LEECH_OUT";
	}
	
	States {
	LeechBeam:
		SYNP WXYZWXYZWXYZ 1 BRIGHT;
		Loop;
	UseEquipment:
		TNT1 A 1 A_StartSound("SiphonActive", 3);
		SYNP KLMNO 1 A_WeaponOffset(0,32);
		TNT1 A 0 {
			A_StopSound(3);
			A_Overlay(-91, "LeechBeam");
			A_OverlayOffset(-91);
		}
	HoldLeech:
		SYNP ABCDEF 2 {
			A_StartSound("SiphonHold",3,CHANF_LOOPING);
			A_FireBullets(0, 0, -1, 3, "SiphonPuff", FBF_NORANDOM|FBF_NOFLASH);
			A_TakeInventory("PB_Dtech", 4, TIF_NOTAKEINFINITE);
		}
		TNT1 A 0 A_JumpIf(CountInv("PB_Dtech") > 4 && PressingUser1(), "HoldLeech");
		TNT1 A 0 {
			A_StopSound(3);
			A_ClearOverlays(-91,-91);
			if(CountInv("PB_Dtech") < 4 && PressingUser1()) {
				A_Print("$PB_LEECH_OUT");
			}
		}
		SYNP ONMLK 1;
		TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_TakeInventory("UseEquipment", 1);
			A_TakeInventory("ToggleEquipment", 1);
		}
		TNT1 A 0 PB_ReThrow();
		Stop;
	}
}

// Leech Grenade
Class PB_LeechPickup : PB_Ammo 
{
	Default
	{
		//$Title Leech
		//$Category Project Brutality/Weapons/Equipment
		//$Sprite FLSPA0
		Scale 0.35;
		Tag "$PB_LEECH_TAG";
		Inventory.PickupSound "SiphonGrowl";
		PB_Ammo.AmmoType "leechnade";
		Inventory.Amount 1;
		Ammo.BackpackAmount 0;
	}
	
	override string PickupMessage()
	{
		return "$PB_LEECH_PICKUP";
	}
	
	override void AttachToOwner(actor other)
	{
		if(amount > 0)
		{
			other.GiveInventory("PB_LeechToken",1);
			other.GiveInventory("PB_DTech",20);
			Super.AttachToOwner(other);
		}
		else
		{
			Destroy();
		}
	}
}
