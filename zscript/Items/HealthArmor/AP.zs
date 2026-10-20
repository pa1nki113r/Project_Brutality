class PB_ArmorBonus : PB_Armor2
{
	mixin PB_BetterPickupSound;
	
	Default
	{
		//$Title Armor Bonus
		//$Category Project Brutality/Health and Armor
		//$Sprite B0N2A0
		Tag "$PB_ARMORBONUS_TAG";
		Armor.SaveAmount 2;
		Armor.MaxSaveAmount 500;
		Inventory.Icon "B0N2A0";
		Inventory.PickUpSound "misc/abonus_PickUp";
		Inventory.PickupMessage "$PB_ARMORBONUS_PICKUP";
		//Scale .34;
		+COUNTITEM;
	}
	States
	{
		Spawn:
			B0N2 AAAAAAA 2;
			B0N2 BCDEFGH 2; 
			loop;
	}
}

class PB_ArmorBonusDropped : PB_ArmorBonus
{
	Default
	{
		//Dropped version that doesnt count towards item total
		-COUNTITEM;
		-INVENTORY.ALWAYSPICKUP;
	}
}

class PB_DemonAPBonus : PB_ArmorBonusDropped {}

class PB_GreenArmor : PB_Armor
{
	Default
	{
		//$Title Light Recon Armor
		//$Category Project Brutality/Health and Armor
		//$Sprite 4RM1A0
		Tag "$PB_GREENARMOR_TAG";
		Radius 20;
		Height 16;
		Armor.SavePercent 40;
		Armor.SaveAmount 100;
		Inventory.Icon "4RM1A0";
		Inventory.PickupMessage "$PB_GREENARMOR_PICKUP";
		Inventory.PickupSound "ARMOR";
		//Scale .28;
	}

	States
	{
		Spawn:
			4RM1 A -1;
			stop;
	}
}

class PB_BlueArmor : PB_Armor
{
	Default
	{
		//$Title Heavy Assault Armor
		//$Category Project Brutality/Health and Armor
		//$Sprite 4RM2A0
		Tag "$PB_BLUEARMOR_TAG";
		Radius 20;
		Height 16;
		Armor.SavePercent 70;
		Armor.SaveAmount 200;
		Inventory.Icon "4RM2A0";
		Inventory.PickupMessage "$PB_BLUEARMOR_PICKUP";
		Inventory.PickupSound "ARMOR";
		//Scale .28;
	}

	States
	{
		Spawn:
			4RM2 A -1;
			stop;
	}
}