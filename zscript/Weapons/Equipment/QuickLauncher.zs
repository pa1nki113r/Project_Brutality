class PB_QuickLauncherToken : PB_Equipment {
	Default {
		Inventory.Icon "ALISTREV";
		PB_Equipment.FontColor "LightBlue";
		PB_Equipment.AmmoType "PB_QuickLauncherAmmo";
		PB_Equipment.SelectString "$PB_QUICKLAUNCHER_WHEEL";
		PB_Equipment.SelectSound "REVUP";
		PB_Equipment.FailString "$PB_QUICKLAUNCHER_OUT";
		PB_Equipment.Handless true;
	}
	
	States {
	UseEquipment:
		TNT1 A 0 {A_StartSound("revup", CHAN_AUTO, CHANF_OVERLAP);}
		RVCA ABCDEFGHIJK 1;
		RVCF AB 1;
	FiringRevGun:
		TNT1 A 0 A_DoubleTapFlag();
		RVCF C 1 BRIGHT {
			A_AlertMonsters();
			A_TakeInventory("PB_QuickLauncherAmmo", 1, TIF_NOTAKEINFINITE);
			A_FireProjectile("Alerter",0,0,-1,0);
			A_FireProjectile("DoomerRevenantSeeker3", random(4, -4), 0, -16, 8);
			A_StartSound("hellishmissle/fire",CHAN_AUTO, CHANF_OVERLAP, 0.5, pitch:frandom(0.95, 1.05));
		}
		RVCF D 1 BRIGHT {
			A_StartSound("hellishmissle/fire", CHAN_AUTO, CHANF_OVERLAP, 0.5, pitch:frandom(0.95, 1.05));
			A_FireProjectile("DoomerRevenantSeeker2", random(4, -4), 0, 16, 8);
		}
		RVCF EFG 1 BRIGHT {
			if(HasDoubleTapped() && CVar.GetCVar("pb_toggle_launchers", player).GetBool()) {
				return ResolveState("FireRevGunFinish");
			}
			return ResolveState(null);
		}
		RVCF HI 1 {
			if(HasDoubleTapped() && CVar.GetCVar("pb_toggle_launchers", player).GetBool()) {
				return ResolveState("FireRevGunFinish");
			}
			return ResolveState(null);
		}
		TNT1 A 0 A_JumpIf(CountInv("PB_QuickLauncherAmmo") > 0 && (PressingUser1() || CVar.GetCVar("pb_toggle_launchers", player).GetBool()), "FiringRevGun");
		goto FireRevGunFinish;
	FireRevGunFinish:
		TNT1 A 0 {
			if(CountInv("PB_QuickLauncherAmmo") < 1 && (PressingUser1() || CVar.GetCVar("pb_toggle_launchers", player).GetBool() && !FindInventory("UseEquipment"))) {
				A_Print("$PB_QUICKLAUNCHER_OUT");
			}
		}
		RVCF BA 1;
		RVCA K 1 A_StartSound("revcyc", CHAN_AUTO, CHANF_OVERLAP);
		RVCA JIHGFEDCBA 1;
		stop;
	}
}

class PB_QuickLauncherAmmo : PB_Ammo
{
	Default
	{
		//$Title Quick Launcher
		//$Category Project Brutality/Weapons/Equipment
		//$Sprite FATBD0
		Tag "$PB_QUICKLAUNCHER_MISSILE_TAG";
		Inventory.Amount 4;
		Inventory.MaxAmount 60;
		Inventory.PickupSound "REVUP";
		Inventory.Icon "HREVCY";
		Ammo.BackpackAmount 4;
		Ammo.BackpackMaxAmount 120;
		PB_Ammo.ammotype "ql";
	}
	
	override void AttachToOwner(actor other)
	{
		other.GiveInventory("PB_QuickLauncherToken",1);
		Super.AttachToOwner(other);
	}
}
