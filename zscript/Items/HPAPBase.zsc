class PB_Health : Health abstract
{
	mixin PB_BetterPickupSound;
	int cap,ca,res; string msg;
	override bool TryPickup(in out actor toucher)
	{
		int aa = self.amount*G_SkillPropertyFloat(SKILLP_HealthFactor);
		if(toucher && toucher is "PlayerPawn")
		{
			cap = Max(MaxAmount,toucher.GetMaxHealth(true));
			ca = toucher.health;
		}
		res = clamp(cap-ca, 0, aa);
		return Super.TryPickup(toucher);
	}
	override string PickupMessage(){
		msg = Super.PickupMessage();
		if( msg.IndexOf("(+%a HP)") != -1 || msg.IndexOf("(+%a much needed HP)") != -1 ){
			msg.Replace("%a", String.Format("%d", res));
		}else{
			string.format("%s (+%d HP)",msg,res);
		}
		return msg;
	}
}

class PB_Armor : BasicArmorPickup abstract
{
	mixin PB_BetterPickupSound;
	
	Default
	{
		+INVENTORY.AUTOACTIVATE;
		Inventory.MaxAmount 0;
	}

    // compare the "functional percentage" (how much damage the armor can actually take) to the one of the new armor
    // prevents wasting a perfectly good armor pickup
    override bool TryPickup(in out actor toucher)
    {
        if(!toucher || !toucher.Player) return Super.TryPickup(toucher);

        let curArmor = BasicArmor(toucher.FindInventory("BasicArmor"));
        if(curArmor)
        {
            int newDefense = SaveAmount * (self.SavePercent / 100.f);
            int curDefense = toucher.CountInv("BasicArmor") * curArmor.SavePercent;

            int defenseDelta = newDefense - curDefense;
            int amountDelta = SaveAmount - toucher.CountInv("BasicArmor");
            
            if((defenseDelta < 0) || (amountDelta < (SaveAmount * 0.2))) // armor is less defensive or 80% over it's full capacity
            {
                if(!PB_HelpNotificationsHandler.CheckTipEvent(1 << 5, CVar.GetCvar("pb_helpflags", toucher.Player)))
                {
                    Array<String> pbTipsBuf;
                    pbTipsBuf.Push("$PB_ARMOR_TIP_1");
                    pbTipsBuf.Push("$PB_ARMOR_TIP_2");
                    pbTipsBuf.Push("$PB_ARMOR_TIP_3");
                    PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 5);
                }

                if(toucher.Player.cmd.buttons & BT_USE) 
                    return Super.TryPickup(toucher);

                return false;
            }
        }

        return Super.TryPickup(toucher);
    }
}

class PB_Armor2 : BasicArmorBonus abstract
{
	mixin PB_BetterPickupSound;
	
	Default
	{
		+INVENTORY.AUTOACTIVATE;
	}
	int cap,ca,res; string msg;
	override bool TryPickup(in out actor toucher)
	{
		let armor = BasicArmor(toucher.FindInventory("BasicArmor"));
		if(armor){
			int aa = self.SaveAmount*G_SkillPropertyFloat(SKILLP_ArmorFactor);
			if(toucher && toucher is "PlayerPawn")
			{
				cap = self.MaxSaveAmount;
				ca = armor.Amount;
			}
			res = cap-ca;
			if(res>=aa){ res = aa;}
		}
		return Super.TryPickup(toucher);
	}
	override string PickupMessage(){
		msg = Super.PickupMessage();
		if( msg.IndexOf("(+%a AP)") != -1 ){
			msg.Replace("%a", String.Format("%d", res));
		}else{
			string.format("%s (+%d AP)",msg,res);
		}
		return msg;
	}
}