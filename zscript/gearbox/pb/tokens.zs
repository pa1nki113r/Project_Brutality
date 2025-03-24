//
//	PB_SpecialWheel_Mode contains info used by the event handler to know what to display in screen
//	and what to give to the player based on what they choose;
//	
//

Class PB_SpecialWheel_Mode
{		
	string img;					// icon, as string, can be a full path
	string Alias;				// name of the mode
	string tokentogive;			// token class to give
	double scalex;				// x scale of the icon
	double scaley;				// y scale of the icon 
}

//
//	these hold the info about the weapon wheel icons for their respective weapon
//	

class WheelInfoContainer
{
	virtual void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)	//receives an array and fills it with PB_SpecialWheel_Mode instances, also receives a pointer to the actual player, so it can check for tokens
	{
		if(!spw || !requester)
			return;
	}
	
	virtual int GetSPCount(actor requester)	//this was the simplest and fastest thing i could think, returns the ammount of specials this class has
	{
		return 0;
	}
}

Class PB_CarbineWeaponWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		bool dualling = requester.FindInventory("DualWieldingCarbines");
		
		vector2 iconScale = (0.65, 0.65);
		
		PB_SpecialWheel_Mode carbine_fullauto = new ("PB_SpecialWheel_Mode");
		carbine_fullauto.img = "graphics/pywheel/Carbine_Auto.png";
		carbine_fullauto.Alias = "Toggle Full-Auto Fire";
		carbine_fullauto.tokentogive = "SelectCarbine_FullAutoFire";
		carbine_fullauto.scalex = iconscale.x;
		carbine_fullauto.scaley = iconscale.y;
		
		
		
		PB_SpecialWheel_Mode carbine_burst = new ("PB_SpecialWheel_Mode");
		carbine_burst.img = "graphics/pywheel/Carbine_Semi.png";
		carbine_burst.Alias = "Toggle Semi-Auto Fire";
		carbine_burst.tokentogive = "SelectCarbine_SemiFire";
		carbine_burst.scalex = iconscale.x;
		carbine_burst.scaley = iconscale.y;
			
		
		PB_SpecialWheel_Mode carbine_semi = new ("PB_SpecialWheel_Mode");
		carbine_semi.img = "graphics/pywheel/Carbine_Burst.png";
		carbine_semi.Alias = "Toggle Burst Fire";
		carbine_semi.tokentogive = "SelectCarbine_BurstFire";
		carbine_semi.scalex = iconscale.x;
		carbine_semi.scaley = iconscale.y;
		
		
		spw.Push(carbine_fullauto);
		spw.Push(carbine_burst);
		spw.Push(carbine_semi);
		
		
		if(!dualling)
		{
			PB_SpecialWheel_Mode carbine_dualwield = new ("PB_SpecialWheel_Mode");
			carbine_dualwield.img = "graphics/pywheel/Carbine_Dual.png";
			carbine_dualwield.Alias = "Akimbo Carbines";
			carbine_dualwield.tokentogive = "SelectCarbine_DualWield";
			carbine_dualwield.scalex = iconscale.x;
			carbine_dualwield.scaley = iconscale.y;
			
			spw.Push(carbine_dualwield);
			
		}
		else
		{
			PB_SpecialWheel_Mode carbine_dualwield = new ("PB_SpecialWheel_Mode");
			carbine_dualwield.img = "sprites/weapons/Slot 4/Carbine/CB00Z0.png";
			carbine_dualwield.Alias = "Single Carbine";
			carbine_dualwield.tokentogive = "SelectCarbine_DualWield";
			carbine_dualwield.scalex = iconscale.x;
			carbine_dualwield.scaley = iconscale.y;
			
			spw.Push(carbine_dualwield);
		}
		
	}
}

class PB_pistolWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
		
		vector2 iconScale = (0.75, 0.75);
		
		//check suppresor
		if(requester.FindInventory("SilencerEquipped"))
		{
			PB_SpecialWheel_Mode pistol_unsilenced = new ("PB_SpecialWheel_Mode");
			pistol_unsilenced.img = "graphics/pywheel/PISTOL_5.png";
			pistol_unsilenced.Alias = "Detach Suppressor";
			pistol_unsilenced.tokentogive = "SelectPistolSuppressor";
			pistol_unsilenced.scalex = iconscale.x;
			pistol_unsilenced.scaley = iconscale.y;
			
			spw.Push(pistol_unsilenced);
		}
		else
		{
			PB_SpecialWheel_Mode pistol_silencer = new ("PB_SpecialWheel_Mode");
			pistol_silencer.img = "graphics/pywheel/PISTOL_1.png";
			pistol_silencer.Alias = "Attach Suppressor";
			pistol_silencer.tokentogive = "SelectPistolSuppressor";
			pistol_silencer.scalex = iconscale.x;
			pistol_silencer.scaley = iconscale.y;
			
			spw.Push(pistol_silencer);
		}
		
		//check dw
		if(requester.FindInventory("DualWieldingPistols"))
		{
			PB_SpecialWheel_Mode pistol_single = new ("PB_SpecialWheel_Mode");
			pistol_single.img = "graphics/pywheel/PISTOL_0.png";
			pistol_single.Alias = "Single Pistol";
			pistol_single.tokentogive = "SelectDualWieldPistols";
			pistol_single.scalex = iconscale.x;
			pistol_single.scaley = iconscale.y;
			
			spw.Push(pistol_single);
		}
		else
		{
			PB_SpecialWheel_Mode pistol_dual = new ("PB_SpecialWheel_Mode");
			pistol_dual.img = "graphics/pywheel/PISTOL_4.png";
			pistol_dual.Alias = "Akimbo Pistols";
			pistol_dual.tokentogive = "SelectDualWieldPistols";
			pistol_dual.scalex = iconscale.x;
			pistol_dual.scaley = iconscale.y;
			
			spw.Push(pistol_dual);
		}
		
		//check burst
		if(requester.FindInventory("ToggledPistolBurstFire"))
		{
			PB_SpecialWheel_Mode pistol_semi = new ("PB_SpecialWheel_Mode");
			pistol_semi.img = "graphics/pywheel/PISTOL_3.png";
			pistol_semi.Alias = "Semi Fire";
			pistol_semi.tokentogive = "SelectPistolBurstFire";
			pistol_semi.scalex = iconscale.x;
			pistol_semi.scaley = iconscale.y;
			
			spw.Push(pistol_semi);
		}
		else
		{
			PB_SpecialWheel_Mode pistol_burst = new ("PB_SpecialWheel_Mode");
			pistol_burst.img = "graphics/pywheel/PISTOL_2.png";
			pistol_burst.Alias = "Burst Fire";
			pistol_burst.tokentogive = "SelectPistolBurstFire";
			pistol_burst.scalex = iconscale.x;
			pistol_burst.scaley = iconscale.y;
			
			spw.Push(pistol_burst);
		}
	
	}
}

Class PB_SGLWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 5;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.5, 0.5);
		
		PB_SpecialWheel_Mode grenade_impact = new ("PB_SpecialWheel_Mode");
		grenade_impact.img = "graphics/pywheel/grenade_impact.png";
		grenade_impact.Alias = "Frag Grenade";
		grenade_impact.tokentogive = "GrenadeTypeImpact";
		grenade_impact.scalex = iconscale.x;
		grenade_impact.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_sticky = new ("PB_SpecialWheel_Mode");
		grenade_sticky.img = "graphics/pywheel/grenade_sticky.png";
		grenade_sticky.Alias = "Sticky Bomb";
		grenade_sticky.tokentogive = "GrenadeTypeSticky";
		grenade_sticky.scalex = iconscale.x;
		grenade_sticky.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_incendiary = new ("PB_SpecialWheel_Mode");
		grenade_incendiary.img = "graphics/pywheel/grenade_incendiary.png";
		grenade_incendiary.Alias = "Incendiary Grenade";
		grenade_incendiary.tokentogive = "GrenadeTypeIncendiary";
		grenade_incendiary.scalex = iconscale.x;
		grenade_incendiary.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_cryo = new ("PB_SpecialWheel_Mode");
		grenade_cryo.img = "graphics/pywheel/grenade_cryo.png";
		grenade_cryo.Alias = "Cryogenic Grenade";
		grenade_cryo.tokentogive = "GrenadeTypeCryo";
		grenade_cryo.scalex = iconscale.x;
		grenade_cryo.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_acid = new ("PB_SpecialWheel_Mode");
		grenade_acid.img = "graphics/pywheel/grenade_acid.png";
		grenade_acid.Alias = "Acid Grenade";
		grenade_acid.tokentogive = "GrenadeTypeAcid";
		grenade_acid.scalex = iconscale.x;
		grenade_acid.scaley = iconscale.y;

		spw.Push(grenade_impact);
		spw.Push(grenade_sticky);
		spw.Push(grenade_incendiary);
		spw.Push(grenade_cryo);
		spw.Push(grenade_acid);
	}
}


Class PB_SMGWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 2;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.5, 0.5);
			
		if(!requester.FindInventory("DualWieldingSMGs")) 
		{
			PB_SpecialWheel_Mode smg_dualwield = new ("PB_SpecialWheel_Mode");
			smg_dualwield.img = "graphics/pywheel/SMG/SMG_DUAL.png";
			smg_dualwield.Alias = "Akimbo SMGs";
			smg_dualwield.tokentogive = "SelectDualWieldSMG";
			smg_dualwield.scalex = iconscale.x;
			smg_dualwield.scaley = iconscale.y;
			
			spw.Push(smg_dualwield);
		}
		else 
		{
			PB_SpecialWheel_Mode smg_dualwield = new ("PB_SpecialWheel_Mode");
			smg_dualwield.img = "sprites/weapons/Slot 2/UACSMG/Pickup/ATFLA0.png";
			smg_dualwield.Alias = "Single SMG";
			smg_dualwield.tokentogive = "SelectDualWieldSMG";
			smg_dualwield.scalex = iconscale.x;
			smg_dualwield.scaley = iconscale.y;
			
			spw.Push(smg_dualwield);
		}
		if(!requester.FindInventory("LaserSightActivated")) 
		{
			PB_SpecialWheel_Mode smg_laser = new ("PB_SpecialWheel_Mode");
			smg_laser.img = "graphics/pywheel/SMG/SMG_LASER.png";
			smg_laser.Alias = "Activate Laser Sight";
			smg_laser.tokentogive = "SelectLaserSight";
			smg_laser.scalex = iconscale.x;
			smg_laser.scaley = iconscale.y;
			
			spw.Push(smg_laser);
		}
		else 
		{
			PB_SpecialWheel_Mode smg_laser = new ("PB_SpecialWheel_Mode");
			smg_laser.img = "sprites/weapons/Slot 2/UACSMG/Pickup/ATFLA0.png";
			smg_laser.Alias = "Deactivate Laser Sight";
			smg_laser.tokentogive = "SelectLaserSight";
			smg_laser.scalex = iconscale.x;
			smg_laser.scaley = iconscale.y;
			
			spw.Push(smg_laser);
		}
		if(!requester.FindInventory("SilencedSMG")) 
		{
			PB_SpecialWheel_Mode smg_silencer = new ("PB_SpecialWheel_Mode");
			smg_silencer.img = "sprites/weapons/Slot 2/UACSMG/silencer_icon.png";
			smg_silencer.Alias = "Screw On Silencer";
			smg_silencer.tokentogive = "SelectSilencedSMG";
			smg_silencer.scalex = iconscale.x;
			smg_silencer.scaley = iconscale.y;
			
			spw.Push(smg_silencer);
		}
		else 
		{
			PB_SpecialWheel_Mode smg_silencer = new ("PB_SpecialWheel_Mode");
			smg_silencer.img = "sprites/weapons/Slot 2/UACSMG/Pickup/ATFLA0.png";
			smg_silencer.Alias = "Screw Off Silencer";
			smg_silencer.tokentogive = "SelectSilencedSMG";
			smg_silencer.scalex = iconscale.x;
			smg_silencer.scaley = iconscale.y;
			
			spw.Push(smg_silencer);
		}
	}
}

Class PB_RifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.55, 0.55);
		
		// Check Dual Wield Icons
		if(requester.FindInventory("DualWieldingDMRs"))
		{
			PB_SpecialWheel_Mode rifle_single = new ("PB_SpecialWheel_Mode");
			rifle_single.img = "graphics/pywheel/hdmr_single.png";
			rifle_single.Alias = "Single DMR";
			rifle_single.tokentogive = "SelectDualWieldDMRs";
			rifle_single.scalex = iconscale.x;
			rifle_single.scaley = iconscale.y;
			
			spw.Push(rifle_single);
		}
		else 
		{
			PB_SpecialWheel_Mode rifle_dual = new ("PB_SpecialWheel_Mode");
			rifle_dual.img = "graphics/pywheel/hdmr_dual.png";
			rifle_dual.Alias = "Akimbo DMRs";
			rifle_dual.tokentogive = "SelectDualWieldDMRs";
			rifle_dual.scalex = iconscale.x;
			rifle_dual.scaley = iconscale.y;
			
			spw.Push(rifle_dual);
		}

		if(requester.FindInventory("HDMRGrenadeMode"))
		{
			PB_SpecialWheel_Mode rifle_grenade_off = new ("PB_SpecialWheel_Mode");
			rifle_grenade_off.img = "graphics/pywheel/hdmr_grenade_off.png";
			rifle_grenade_off.Alias = "Aiming Secondary Fire";
			rifle_grenade_off.tokentogive = "SelectHDMRGrenade";
			rifle_grenade_off.scalex = iconscale.x;
			rifle_grenade_off.scaley = iconscale.y;
			
			spw.Push(rifle_grenade_off);
		}
		else 
		{
			PB_SpecialWheel_Mode rifle_grenade_on = new ("PB_SpecialWheel_Mode");
			rifle_grenade_on.img = "graphics/pywheel/hdmr_grenade_on.png";
			rifle_grenade_on.Alias = "Grenade Secondary Fire";
			rifle_grenade_on.tokentogive = "SelectHDMRGrenade";
			rifle_grenade_on.scalex = iconscale.x;
			rifle_grenade_on.scaley = iconscale.y;
			
			spw.Push(rifle_grenade_on);
		}


		if(requester.FindInventory("HDMRSniperMode"))
		{
			PB_SpecialWheel_Mode rifle_normal = new ("PB_SpecialWheel_Mode");
			rifle_normal.img = "graphics/pywheel/hdmr_normal.png";
			rifle_normal.Alias = "DMR Mode";
			rifle_normal.tokentogive = "SelectHDMRMode";
			rifle_normal.scalex = iconscale.x;
			rifle_normal.scaley = iconscale.y;
			
			spw.Push(rifle_normal);
		}
		else 
		{
			PB_SpecialWheel_Mode rifle_sniper = new ("PB_SpecialWheel_Mode");
			rifle_sniper.img = "graphics/pywheel/hdmr_sniper.png";
			rifle_sniper.Alias = "Heavy Sniper Mode";
			rifle_sniper.tokentogive = "SelectHDMRMode";
			rifle_sniper.scalex = iconscale.x;
			rifle_sniper.scaley = iconscale.y;
			
			spw.Push(rifle_sniper);
		}
	}
}

Class PB_QSGWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.55, 0.55);
			
		if(requester.FindInventory("QuadAkimboMode")) 
		{
			PB_SpecialWheel_Mode qsg_undual = new ("PB_SpecialWheel_Mode");
			qsg_undual.img = "graphics/pywheel/Quad_Single.png";
			qsg_undual.Alias = "Single Quad Shotgun";
			qsg_undual.tokentogive = "SelectDualWieldQuads";
			qsg_undual.scalex = iconscale.x;
			qsg_undual.scaley = iconscale.y;
			
			spw.Push(qsg_undual);
		}
		else 
		{
			PB_SpecialWheel_Mode qsg_dual = new ("PB_SpecialWheel_Mode");
			qsg_dual.img = "graphics/pywheel/Quad_Dual.png";
			qsg_dual.Alias = "Akimbo Quad Shotguns";
			qsg_dual.tokentogive = "SelectDualWieldQuads";
			qsg_dual.scalex = iconscale.x;
			qsg_dual.scaley = iconscale.y;
			
			spw.Push(qsg_dual);
		}
					
		if(requester.FindInventory("FullBlastMode")) 
		{
			PB_SpecialWheel_Mode qsg_halfnormal = new ("PB_SpecialWheel_Mode");
			qsg_halfnormal.img = "graphics/pywheel/Quad_Half.png";
			qsg_halfnormal.Alias = "Half Blast";
			qsg_halfnormal.tokentogive = "BlastToggle";
			qsg_halfnormal.scalex = iconscale.x;
			qsg_halfnormal.scaley = iconscale.y;
			
			spw.Push(qsg_halfnormal);
		}
		else 
		{
			PB_SpecialWheel_Mode qsg_fullnormal = new ("PB_SpecialWheel_Mode");
			qsg_fullnormal.img = "graphics/pywheel/Quad_Full.png";
			qsg_fullnormal.Alias = "Full Blast";
			qsg_fullnormal.tokentogive = "BlastToggle";
			qsg_fullnormal.scalex = iconscale.x;
			qsg_fullnormal.scaley = iconscale.y;
			
			spw.Push(qsg_fullnormal);
		}

		if(requester.FindInventory("BreathMode")) 
		{
			PB_SpecialWheel_Mode qsg_shell = new ("PB_SpecialWheel_Mode");
			qsg_shell.img = "graphics/pywheel/Quad_Shells.png";
			qsg_shell.Alias = "Shells mode";
			qsg_shell.tokentogive = "BreathToggle";
			qsg_shell.scalex = iconscale.x;
			qsg_shell.scaley = iconscale.y;
			
			spw.Push(qsg_shell);
		}
		else 
		{
			PB_SpecialWheel_Mode qsg_demon = new ("PB_SpecialWheel_Mode");
			qsg_demon.img = "graphics/pywheel/Quad_Demonic.png";
			qsg_demon.Alias = "Demonic Breath mode";
			qsg_demon.tokentogive = "BreathToggle";
			qsg_demon.scalex = iconscale.x;
			qsg_demon.scaley = iconscale.y;
			
			spw.Push(qsg_demon);
		}
	}
}

Class PB_CryoRifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.8, 0.8);
			
		PB_SpecialWheel_Mode cryorifle_missile = new ("PB_SpecialWheel_Mode");
		cryorifle_missile.img = "graphics/pywheel/CryoRifle_Missile.png";
		cryorifle_missile.Alias = "Primary: Ice Missile";
		cryorifle_missile.tokentogive = "FireModeCryoRifleMissile_WW";
		cryorifle_missile.scalex = iconscale.x;
		cryorifle_missile.scaley = iconscale.y;
		
		spw.Push(cryorifle_missile);

		PB_SpecialWheel_Mode cryorifle_beam = new ("PB_SpecialWheel_Mode");
		cryorifle_beam.img = "graphics/pywheel/cryorifle_beam.png";
		cryorifle_beam.Alias = "Primary: Ice Beam";
		cryorifle_beam.tokentogive = "FireModeCryoRifleBeam_WW";
		cryorifle_beam.scalex = iconscale.x;
		cryorifle_beam.scaley = iconscale.y;
		
		spw.Push(cryorifle_beam);

		PB_SpecialWheel_Mode cryorifle_spear = new ("PB_SpecialWheel_Mode");
		cryorifle_spear.img = "graphics/pywheel/CryoRifle_Spear.png";
		cryorifle_spear.Alias = "Secondary: Ice Spear";
		cryorifle_spear.tokentogive = "FireModeCryoRifleSpear_WW";
		cryorifle_spear.scalex = iconscale.x;
		cryorifle_spear.scaley = iconscale.y;
		
		spw.Push(cryorifle_spear);

		PB_SpecialWheel_Mode cryorifle_flak = new ("PB_SpecialWheel_Mode");
		cryorifle_flak.img = "graphics/pywheel/CryoRifle_Flak.png";
		cryorifle_flak.Alias = "Secondary: Ice Flak";
		cryorifle_flak.tokentogive = "FireModeCryoRifleFlak_WW";
		cryorifle_flak.scalex = iconscale.x;
		cryorifle_flak.scaley = iconscale.y;
		
		spw.Push(cryorifle_flak);
	}
}

Class PB_MinigunWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		if(requester.FindInventory("MinigunUpgraded"))
			return 3;
		return 2;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.8, 0.8);
			
		PB_SpecialWheel_Mode minigun_chaingun = new ("PB_SpecialWheel_Mode");
		minigun_chaingun.img = "graphics/pywheel/Minigun_1.png";
		minigun_chaingun.Alias = "Chaingun Mode";
		minigun_chaingun.tokentogive = "SelectMinigun_Chaingun";
		minigun_chaingun.scalex = iconscale.x;
		minigun_chaingun.scaley = iconscale.y;
		
		spw.Push(minigun_chaingun);

		PB_SpecialWheel_Mode minigun_gatling = new ("PB_SpecialWheel_Mode");
		minigun_gatling.img = "graphics/pywheel/Minigun_2.png";
		minigun_gatling.Alias = "Gatling Mode";
		minigun_gatling.tokentogive = "SelectMinigun_Gatling";
		minigun_gatling.scalex = iconscale.x;
		minigun_gatling.scaley = iconscale.y;
		
		spw.Push(minigun_gatling);


		if(requester.FindInventory("MinigunUpgraded")) 
		{
			PB_SpecialWheel_Mode minigun_triple = new ("PB_SpecialWheel_Mode");
			minigun_triple.img = "graphics/pywheel/Minigun_3.png";
			minigun_triple.Alias = "Triple Rotary Mode";
			minigun_triple.tokentogive = "SelectMinigun_Triple";
			minigun_triple.scalex = iconscale.x;
			minigun_triple.scaley = iconscale.y;
			
			spw.Push(minigun_triple);
		}
	}
}

Class PB_PumpShotgunWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.7, 0.7);
			
		if(requester.FindInventory("DragonBreathUpgrade")) 
		{
			PB_SpecialWheel_Mode shotgun_dragonbreath = new ("PB_SpecialWheel_Mode");
			shotgun_dragonbreath.img = "graphics/pywheel/SG_DB.png";
			shotgun_dragonbreath.Alias = "Dragon's Breath Shells";
			shotgun_dragonbreath.tokentogive = "SelectShotgun_Dragonsbreath";
			shotgun_dragonbreath.scalex = iconscale.x;
			shotgun_dragonbreath.scaley = iconscale.y;
			
			spw.Push(shotgun_dragonbreath);
		}
		else 
		{
			PB_SpecialWheel_Mode shotgun_No = new ("PB_SpecialWheel_Mode");
			shotgun_No.img = "graphics/pywheel/SG_NO.png";
			shotgun_No.Alias = "Not Available";
			shotgun_No.tokentogive = "SelectShotgun_No";
			shotgun_No.scalex = iconscale.x;
			shotgun_No.scaley = iconscale.y;
			
			spw.Push(shotgun_No);
		}

		PB_SpecialWheel_Mode shotgun_buckshot = new ("PB_SpecialWheel_Mode");
		shotgun_buckshot.img = "graphics/pywheel/SG_Buck.png";
		shotgun_buckshot.Alias = "Buckshot Shells";
		shotgun_buckshot.tokentogive = "SelectShotgun_Buckshot";
		shotgun_buckshot.scalex = iconscale.x;
		shotgun_buckshot.scaley = iconscale.y;
		
		
		PB_SpecialWheel_Mode shotgun_slugshot = new ("PB_SpecialWheel_Mode");
		shotgun_slugshot.img = "graphics/pywheel/SG_Slug.png";
		shotgun_slugshot.Alias = "Slug Shells";
		shotgun_slugshot.tokentogive = "SelectShotgun_Slugshot";
		shotgun_slugshot.scalex = iconscale.x;
		shotgun_slugshot.scaley = iconscale.y;
		

		spw.Push(shotgun_buckshot);
		spw.Push(shotgun_slugshot);
	}
}

Class PB_RocketLauncherWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.5, 0.5);
			
		PB_SpecialWheel_Mode rocket_standard = new ("PB_SpecialWheel_Mode");
		rocket_standard.img = "graphics/pywheel/rocket_standard.png";
		rocket_standard.Alias = "Standard Rocket Mode";
		rocket_standard.tokentogive = "RocketLauncher_Standard";
		rocket_standard.scalex = iconscale.x;
		rocket_standard.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode rocket_homing = new ("PB_SpecialWheel_Mode");
		rocket_homing.img = "graphics/pywheel/rocket_homing.png";
		rocket_homing.Alias = "Lock-On Rocket Mode";
		rocket_homing.tokentogive = "RocketLauncher_Homing";
		rocket_homing.scalex = iconscale.x;
		rocket_homing.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode rocket_laser = new ("PB_SpecialWheel_Mode");
		rocket_laser.img = "graphics/pywheel/rocket_laser.png";
		rocket_laser.Alias = "Laser Rocket Mode";
		rocket_laser.tokentogive = "RocketLauncher_Laser";
		rocket_laser.scalex = iconscale.x;
		rocket_laser.scaley = iconscale.y;

		/*if(requester.FindInventory("RL_ScopeMode")) {
			PB_SpecialWheel_Mode rocket_multi = new ("PB_SpecialWheel_Mode");
			rocket_multi.img = "graphics/pywheel/multirocket.png";
			rocket_multi.Alias = "Multi Rocket Mode";
			rocket_multi.tokentogive = "RocketLauncher_Multi";
			rocket_multi.scalex = iconscale.x;
			rocket_multi.scaley = iconscale.y;
			
			spw.Push(rocket_multi);
		}
		else 
		{
			PB_SpecialWheel_Mode rocket_scope = new ("PB_SpecialWheel_Mode");
			rocket_scope.img = "graphics/pywheel/rocketscope.png";
			rocket_scope.Alias = "Scope Mode";
			rocket_scope.tokentogive = "RocketLauncher_Scope";
			rocket_scope.scalex = iconscale.x;
			rocket_scope.scaley = iconscale.y;
			
			spw.Push(rocket_scope);
		}*/

		spw.Push(rocket_standard);
		spw.Push(rocket_homing);
		spw.Push(rocket_laser);
	}
}


/////////////////////
//
//	equipments 
//
/////////////////////

class equipmentCard
{
	//this function fills the respective arrays to correctly display the equipments in the wheel
 	//if any new equipment is added, create a new class inheriting from this class for the handler to catch it
	virtual void InfoFiller(out array<string> tags,out array<string> tokens,out array<string>img,out array<double>sx,out array<double>sy)
	{
		return;
	}
}

class ProxMinCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Proximity Mine");
		tokens.push("WW_ProximityMineSelected");
		img.push("graphics/pywheel/Equip_Mine.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

Class StunGrenCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Stun Grenade");
		tokens.push("WW_StunGrenadeSelected");
		img.push("graphics/pywheel/Equip_Stun.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

Class LeechCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Leech");
		tokens.push("WW_LeechSelected");
		img.push("graphics/pywheel/Equip_Leech.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

class FragGrenCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Frag Grenade");
		tokens.push("WW_FragGrenadeSelected");
		img.push("graphics/pywheel/Equip_Frag.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

class ShouldCanCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Shoulder Cannon");
		tokens.push("WW_RevGunSelected");
		img.push("graphics/pywheel/Equip_RevGun.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}