class PB_Shell : PB_Ammo
{
	Default
	{
		//$Title Shotgun Shells
		//$Category Project Brutality/Ammunition
		//$Sprite SHE1A0
		//Scale 0.14;
		Tag "$PB_SHELL_TAG";
		Inventory.Amount 4;
		Inventory.MaxAmount 50;
		Inventory.PickupSound "misc/shell_PickUp";
		Ammo.BackpackAmount 4;
		Ammo.BackpackMaxAmount 100;
		PB_Ammo.ammotype "shell";
		PB_Ammo.HUDGraphics "BARBACO1", "BARBACO2", "BARBACO3", "BARBACO4", "ABAR3", "AMMOIC3", "Orange";
	}
}

class PB_ShellBox : PB_Shell
{
	Default
	{
		//$Title Box of Shotgun Shells
		//$Category Project Brutality/Ammunition
		//$Sprite SB0XA0
		//Scale 0.25;
		Inventory.Amount 12;
		Inventory.PickupSound "misc/shellbox_PickUp";
		PB_Ammo.ammotype "shellbox";
	}
}

class PB_SingleShell : PB_Shell
{
	Default
	{
		Inventory.Amount 1;
		PB_Ammo.ammotype "1shell";
	}
}

class PB_SingleShellSlug : PB_Shell
{
	Default
	{
		Inventory.Amount 1;
		PB_Ammo.ammotype "1shell2";
	}
}

class PB_SingleShellDragonsBreath : PB_Shell
{
	Default
	{
		Inventory.Amount 1;
		PB_Ammo.ammotype "1shell3";
	}
}