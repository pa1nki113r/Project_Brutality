class PB_HealthBonus : PB_Health
{
	Default
	{
		//$Title Health Bonus
		//$Category Project Brutality/Health and Armor
		//$Sprite B0N1A0
		Tag "$PB_HEALTHBONUS_TAG";
		+COUNTITEM;
		+INVENTORY.ALWAYSPICKUP;
		Inventory.Amount 2;
		Inventory.MaxAmount 500;
		Inventory.PickupSound "misc/hbonus_PickUp";
		Inventory.PickupMessage "$PB_HEALTHBONUS_PICKUP";
		Health.LowMessage 25, "$PB_HEALTHBONUS_PICKUP_LOW";
		//Scale .19;
	}

	States
	{
		Spawn:
			B0N1 ABCDEFGHIJ 3;
			loop;
	}
}

class PB_HealthBonusDropped : PB_HealthBonus
{
	Default
	{
		//Dropped version that doesnt count towards item total
		-COUNTITEM;
		-INVENTORY.ALWAYSPICKUP;
	}
}

class PB_DemonHPBonus : PB_HealthBonusDropped {}

class PB_Stimpack : PB_Health
{
	Default 
	{
		//$Title Stimpack
		//$Category Project Brutality/Health and Armor
		//$Sprite ST1MA0
		Tag "$PB_STIMPACK_TAG";
		Inventory.Amount 10;
		Inventory.PickupSound "misc/N_HP_pickup";
		Inventory.PickupMessage "$PB_STIMPACK_PICKUP";
		Health.LowMessage 25, "$PB_STIMPACK_PICKUP_LOW";
		//Scale .28;
	}

	States
	{
		Spawn:
			ST1M A -1;
			stop;
	}
}

class PB_Medikit : PB_Health
{
	Default
	{
		//$Title Medikit
		//$Category Project Brutality/Health and Armor
		//$Sprite MED1A0
		Tag "$PB_MEDIKIT_TAG";
		Inventory.Amount 25;
		Inventory.PickupSound "misc/L_HP_pickup";
		Inventory.PickupMessage "$PB_MEDIKIT_PICKUP";
		Health.LowMessage 25, "$PB_MEDIKIT_PICKUP_LOW";
		//Scale .30;
	}

	States
	{
		Spawn:
			MED1 A -1;
			stop;
	}
}