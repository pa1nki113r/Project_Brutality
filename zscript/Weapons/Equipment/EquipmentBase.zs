class PB_Equipment : CustomInventory abstract {
	Default {
		Inventory.MaxAmount 1;
		self.AmmoUse 1;
		self.SelectString "YOU NEED TO SET THIS TO SOMETHING";
		self.FailString "YOU NEED TO SET THIS TO SOMETHING";
	}
	
	name fontColor;
	property FontColor : fontColor;
	
	class<PB_Ammo> ammoType;
	property AmmoType : ammoType;
	
	int ammoUse;
	property AmmoUse : ammoUse;
	
	string selectString;
	property SelectString : selectString;
	
	sound selectSound;
	property SelectSound : selectSound;
	
	string failString;
	property FailString : FailString;
	
	bool handless;
	property Handless : handless;
	
	virtual bool UseEquipment() {
		if(owner.CountInv(ammoType) >= ammoUse) {
			Use(false);
			return true;
		}
		else {
			owner.A_Print(failString);
			return false;
		}
	}
	
	action void PB_ReThrow() {
		if(!PressingUser1() || !invoker.UseEquipment()) {
			player.SetPSprite(1, player.readyweapon.ResolveState("GoingToReady2"));
		}
	}
	
	//functions from pb_weaponbase
	action bool JustPressed(int which) // "which" being any BT_* value, mentioned above or not
	{
		return player.cmd.buttons & which && !(player.oldbuttons & which);
	}
	
	action bool JustReleased(int which)
	{
		return !(player.cmd.buttons & which) && player.oldbuttons & which;
	}
	
	action bool PressingFire(){return player.cmd.buttons & BT_ATTACK;}
	action bool PressingAltfire(){return player.cmd.buttons & BT_ALTATTACK;}
	action bool PressingReload(){return player.cmd.buttons & BT_RELOAD;}
	action bool PressingUser1(){return player.cmd.buttons & BT_USER1;}
	action bool PressingUser4(){return player.cmd.buttons & BT_USER4;}
	
	States {
	Use:
		TNT1 A 0 {
			A_Overlay(-90, "UseEquipment");
			A_OverlayOffset(-90); //no args resets it to default position.
		}
		Stop;
	}
}
