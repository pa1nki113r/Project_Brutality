class PB_Backpack : Backpack
{ 
	Mixin PB_BetterPickupSound;
	
	Default 
	{ 
		//$Title Backpack
		//$Category Project Brutality/Ammunition
		//$Sprite BP4KA0
		Tag "$PB_BACKPACK_TAG";
		Inventory.PickupMessage "$PB_BACKPACK_PICKUP";
		Inventory.PickupSound "BACKPCK";
		//Scale .10;
	}
	States
	{
	Spawn:
		BP4K A -1;
		Stop;
	}
}