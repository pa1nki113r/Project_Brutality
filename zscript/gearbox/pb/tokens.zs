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
			
		let weap = PB_WeaponBase(requester.player.readyweapon);
		bool scope = requester.FindInventory("CarbineScope");
		
		vector2 iconScale = (0.65, 0.65);
		
		if(!weap.akimboMode)
		{
			PB_SpecialWheel_Mode carbine_dualwield = new ("PB_SpecialWheel_Mode");
			carbine_dualwield.img = "graphics/pywheel/Carbine_Dual.png";
			carbine_dualwield.Alias = "$PB_CARBINE_WHEEL_AKIMBO";
			carbine_dualwield.tokentogive = "SelectCarbine_DualWield";
			carbine_dualwield.scalex = iconscale.x;
			carbine_dualwield.scaley = iconscale.y;
			
			spw.Push(carbine_dualwield);
			
		}
		else
		{
			PB_SpecialWheel_Mode carbine_dualwield = new ("PB_SpecialWheel_Mode");
			carbine_dualwield.img = "sprites/weapons/Slot 4/Carbine/CB00Z0.png";
			carbine_dualwield.Alias = "$PB_CARBINE_WHEEL_SINGLE";
			carbine_dualwield.tokentogive = "SelectCarbine_DualWield";
			carbine_dualwield.scalex = iconscale.x;
			carbine_dualwield.scaley = iconscale.y;
			
			spw.Push(carbine_dualwield);
		}
		
		PB_SpecialWheel_Mode carbine_fullauto = new ("PB_SpecialWheel_Mode");
		carbine_fullauto.img = "graphics/pywheel/Carbine_Auto.png";
		carbine_fullauto.Alias = "$PB_WHEEL_FULL";
		carbine_fullauto.tokentogive = "SelectCarbine_FullAutoFire";
		carbine_fullauto.scalex = iconscale.x;
		carbine_fullauto.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode carbine_burst = new ("PB_SpecialWheel_Mode");
		carbine_burst.img = "graphics/pywheel/Carbine_Burst.png";
		carbine_burst.Alias = "$PB_WHEEL_BURST";
		carbine_burst.tokentogive = "SelectCarbine_BurstFire";
		carbine_burst.scalex = iconscale.x;
		carbine_burst.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode carbine_semi = new ("PB_SpecialWheel_Mode");
		carbine_semi.img = "graphics/pywheel/Carbine_Semi.png";
		carbine_semi.Alias = "$PB_WHEEL_SEMI";
		carbine_semi.tokentogive = "SelectCarbine_SemiFire";
		carbine_semi.scalex = iconscale.x;
		carbine_semi.scaley = iconscale.y;
		
		spw.Push(carbine_fullauto);
		spw.Push(carbine_burst);
		spw.Push(carbine_semi);
		
		if(!scope)
		{
			PB_SpecialWheel_Mode carbine_sights = new ("PB_SpecialWheel_Mode");
			carbine_sights.img = "graphics/pywheel/Carbine_Scope.png";
			carbine_sights.Alias = "$PB_CARBINE_WHEEL_SCOPE";
			carbine_sights.tokentogive = "SelectCarbine_Sights";
			carbine_sights.scalex = iconscale.x;
			carbine_sights.scaley = iconscale.y;
			
			spw.Push(carbine_sights);
			
		}
		else
		{
			PB_SpecialWheel_Mode carbine_sights = new ("PB_SpecialWheel_Mode");
			carbine_sights.img = "graphics/pywheel/Carbine_Reflex.png";
			carbine_sights.Alias = "$PB_CARBINE_WHEEL_REFLEX";
			carbine_sights.tokentogive = "SelectCarbine_Sights";
			carbine_sights.scalex = iconscale.x;
			carbine_sights.scaley = iconscale.y;
			
			spw.Push(carbine_sights);
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
		
		let pistol = PB_Pistol(requester.player.readyweapon);
		vector2 iconScale = (0.75, 0.75);
		
		//check dual wield
		if(pistol.akimboMode)
		{
			PB_SpecialWheel_Mode pistol_single = new ("PB_SpecialWheel_Mode");
			if(pistol.hasSilencer)
				pistol_single.img = "graphics/pywheel/PISTOL_1.png";
			else
				pistol_single.img = "graphics/pywheel/PISTOL_0.png";
			pistol_single.Alias = "$PB_PISTOL_WHEEL_SINGLE";
			pistol_single.tokentogive = "SelectDualWieldPistols";
			pistol_single.scalex = iconscale.x;
			pistol_single.scaley = iconscale.y;
			
			spw.Push(pistol_single);
		}
		else
		{
			PB_SpecialWheel_Mode pistol_dual = new ("PB_SpecialWheel_Mode");
			if(pistol.hasSilencer)
				pistol_dual.img = "graphics/pywheel/PISTOL_7.png";
			else
				pistol_dual.img = "graphics/pywheel/PISTOL_4.png";
			pistol_dual.Alias = "$PB_PISTOL_WHEEL_AKIMBO";
			pistol_dual.tokentogive = "SelectDualWieldPistols";
			pistol_dual.scalex = iconscale.x;
			pistol_dual.scaley = iconscale.y;
			
			spw.Push(pistol_dual);
		}
		
		//check burst
		if(pistol.burstFire)
		{
			PB_SpecialWheel_Mode pistol_semi = new ("PB_SpecialWheel_Mode");
			if(pistol.hasSilencer)
				pistol_semi.img = "graphics/pywheel/PISTOL_6.png";
			else
				pistol_semi.img = "graphics/pywheel/PISTOL_3.png";
			pistol_semi.Alias = "$PB_WHEEL_SEMI";
			pistol_semi.tokentogive = "SelectPistolBurstFire";
			pistol_semi.scalex = iconscale.x;
			pistol_semi.scaley = iconscale.y;
			
			spw.Push(pistol_semi);
		}
		else
		{
			PB_SpecialWheel_Mode pistol_burst = new ("PB_SpecialWheel_Mode");
			if(pistol.hasSilencer)
				pistol_burst.img = "graphics/pywheel/PISTOL_5.png";
			else
				pistol_burst.img = "graphics/pywheel/PISTOL_2.png";
			pistol_burst.Alias = "$PB_WHEEL_BURST";
			pistol_burst.tokentogive = "SelectPistolBurstFire";
			pistol_burst.scalex = iconscale.x;
			pistol_burst.scaley = iconscale.y;
			
			spw.Push(pistol_burst);
		}
		
		//check suppresor
		if(pistol.hasSilencer)
		{
			PB_SpecialWheel_Mode pistol_unsilenced = new ("PB_SpecialWheel_Mode");
			pistol_unsilenced.img = "graphics/pywheel/PISTOL_0.png";
			pistol_unsilenced.Alias = "$PB_PISTOL_WHEEL_SUPPRESSOFF";
			pistol_unsilenced.tokentogive = "SelectPistolSuppressor";
			pistol_unsilenced.scalex = iconscale.x;
			pistol_unsilenced.scaley = iconscale.y;
			
			spw.Push(pistol_unsilenced);
		}
		else
		{
			PB_SpecialWheel_Mode pistol_silencer = new ("PB_SpecialWheel_Mode");
			pistol_silencer.img = "graphics/pywheel/PISTOL_1.png";
			pistol_silencer.Alias = "$PB_PISTOL_WHEEL_SUPPRESSON";
			pistol_silencer.tokentogive = "SelectPistolSuppressor";
			pistol_silencer.scalex = iconscale.x;
			pistol_silencer.scaley = iconscale.y;
			
			spw.Push(pistol_silencer);
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
		grenade_impact.Alias = "$PB_SGL_WHEEL_IMPACT";
		grenade_impact.tokentogive = "GrenadeTypeImpact";
		grenade_impact.scalex = iconscale.x;
		grenade_impact.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_sticky = new ("PB_SpecialWheel_Mode");
		grenade_sticky.img = "graphics/pywheel/grenade_sticky.png";
		grenade_sticky.Alias = "$PB_SGL_WHEEL_STICKY";
		grenade_sticky.tokentogive = "GrenadeTypeSticky";
		grenade_sticky.scalex = iconscale.x;
		grenade_sticky.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_incendiary = new ("PB_SpecialWheel_Mode");
		grenade_incendiary.img = "graphics/pywheel/grenade_incendiary.png";
		grenade_incendiary.Alias = "$PB_SGL_WHEEL_INCENDIARY";
		grenade_incendiary.tokentogive = "GrenadeTypeIncendiary";
		grenade_incendiary.scalex = iconscale.x;
		grenade_incendiary.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_cryo = new ("PB_SpecialWheel_Mode");
		grenade_cryo.img = "graphics/pywheel/grenade_cryo.png";
		grenade_cryo.Alias = "$PB_SGL_WHEEL_CRYO";
		grenade_cryo.tokentogive = "GrenadeTypeCryo";
		grenade_cryo.scalex = iconscale.x;
		grenade_cryo.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode grenade_acid = new ("PB_SpecialWheel_Mode");
		grenade_acid.img = "graphics/pywheel/grenade_acid.png";
		grenade_acid.Alias = "$PB_SGL_WHEEL_ACID";
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
			
		let smg = PB_SMG(requester.player.readyweapon);
		vector2 iconScale = (0.6, 0.6);
			
		if(!smg.akimboMode) 
		{
			PB_SpecialWheel_Mode smg_dualwield = new ("PB_SpecialWheel_Mode");
			if(smg.hasSilencer)
				smg_dualwield.img = "graphics/pywheel/SMG/SMG_DUAL_SUPPRESSED.png";
			else
				smg_dualwield.img = "graphics/pywheel/SMG/SMG_DUAL.png";
			smg_dualwield.Alias = "$PB_SMG_WHEEL_AKIMBO";
			smg_dualwield.tokentogive = "SelectDualWieldSMG";
			smg_dualwield.scalex = iconscale.x;
			smg_dualwield.scaley = iconscale.y;
			
			spw.Push(smg_dualwield);
		}
		else 
		{
			PB_SpecialWheel_Mode smg_dualwield = new ("PB_SpecialWheel_Mode");
			if(smg.hasSilencer)
				smg_dualwield.img = "sprites/weapons/Slot 2/UACSMG/Pickup/ATFLA0.png";
			else
				smg_dualwield.img = "sprites/weapons/Slot 2/UACSMG/Pickup/ATFLB0.png";
			smg_dualwield.Alias = "$PB_SMG_WHEEL_SINGLE";
			smg_dualwield.tokentogive = "SelectDualWieldSMG";
			smg_dualwield.scalex = iconscale.x;
			smg_dualwield.scaley = iconscale.y;
			
			spw.Push(smg_dualwield);
		}
		if(!smg.burstFire) 
		{
			PB_SpecialWheel_Mode smg_burst = new ("PB_SpecialWheel_Mode");
			if(smg.hasSilencer)
				smg_burst.img = "graphics/pywheel/SMG/SMG_BURST_SUPPRESSED.png";
			else
				smg_burst.img = "graphics/pywheel/SMG/SMG_BURST.png";
			smg_burst.Alias = "$PB_WHEEL_BURST";
			smg_burst.tokentogive = "SelectBurstFireSMG";
			smg_burst.scalex = iconscale.x;
			smg_burst.scaley = iconscale.y;
			
			spw.Push(smg_burst);
		}
		else 
		{
			PB_SpecialWheel_Mode smg_auto = new ("PB_SpecialWheel_Mode");
			if(smg.hasSilencer)
				smg_auto.img = "graphics/pywheel/SMG/SMG_FULLAUTO_SUPPRESSED.png";
			else
				smg_auto.img = "graphics/pywheel/SMG/SMG_FULLAUTO.png";
			smg_auto.Alias = "$PB_WHEEL_FULL";
			smg_auto.tokentogive = "SelectBurstFireSMG";
			smg_auto.scalex = iconscale.x;
			smg_auto.scaley = iconscale.y;
			
			spw.Push(smg_auto);
		}
		if(!smg.hasSilencer) 
		{
			PB_SpecialWheel_Mode smg_silencer = new ("PB_SpecialWheel_Mode");
			smg_silencer.img = "sprites/weapons/Slot 2/UACSMG/Pickup/ATFLA0.png";
			smg_silencer.Alias = "$PB_PISTOL_WHEEL_SUPPRESSON";
			smg_silencer.tokentogive = "SelectSilencedSMG";
			smg_silencer.scalex = iconscale.x;
			smg_silencer.scaley = iconscale.y;
			
			spw.Push(smg_silencer);
		}
		else 
		{
			PB_SpecialWheel_Mode smg_silencer = new ("PB_SpecialWheel_Mode");
			smg_silencer.img = "sprites/weapons/Slot 2/UACSMG/Pickup/ATFLB0.png";
			smg_silencer.Alias = "$PB_PISTOL_WHEEL_SUPPRESSOFF";
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
			
		let weap = PB_WeaponBase(requester.player.readyweapon);
		vector2 iconScale = (0.55, 0.55);
		
		// Check Dual Wield Icons
		if(weap.akimboMode)
		{
			PB_SpecialWheel_Mode rifle_single = new ("PB_SpecialWheel_Mode");
			rifle_single.img = "graphics/pywheel/hdmr_single.png";
			rifle_single.Alias = "$PB_HDMR_WHEEL_SINGLE";
			rifle_single.tokentogive = "SelectDualWieldDMRs";
			rifle_single.scalex = iconscale.x;
			rifle_single.scaley = iconscale.y;
			
			spw.Push(rifle_single);
		}
		else 
		{
			PB_SpecialWheel_Mode rifle_dual = new ("PB_SpecialWheel_Mode");
			rifle_dual.img = "graphics/pywheel/hdmr_dual.png";
			rifle_dual.Alias = "$PB_HDMR_WHEEL_AKIMBO";
			rifle_dual.tokentogive = "SelectDualWieldDMRs";
			rifle_dual.scalex = iconscale.x;
			rifle_dual.scaley = iconscale.y;
			
			spw.Push(rifle_dual);
		}

		if(requester.FindInventory("HDMRGrenadeMode"))
		{
			PB_SpecialWheel_Mode rifle_grenade_off = new ("PB_SpecialWheel_Mode");
			rifle_grenade_off.img = "graphics/pywheel/hdmr_grenade_off.png";
			rifle_grenade_off.Alias = "$PB_HDMR_WHEEL_AIM";
			rifle_grenade_off.tokentogive = "SelectHDMRGrenade";
			rifle_grenade_off.scalex = iconscale.x;
			rifle_grenade_off.scaley = iconscale.y;
			
			spw.Push(rifle_grenade_off);
		}
		else 
		{
			PB_SpecialWheel_Mode rifle_grenade_on = new ("PB_SpecialWheel_Mode");
			rifle_grenade_on.img = "graphics/pywheel/hdmr_grenade_on.png";
			rifle_grenade_on.Alias = "$PB_HDMR_WHEEL_GRENADE";
			rifle_grenade_on.tokentogive = "SelectHDMRGrenade";
			rifle_grenade_on.scalex = iconscale.x;
			rifle_grenade_on.scaley = iconscale.y;
			
			spw.Push(rifle_grenade_on);
		}


		if(requester.FindInventory("HDMRSniperMode"))
		{
			PB_SpecialWheel_Mode rifle_normal = new ("PB_SpecialWheel_Mode");
			rifle_normal.img = "graphics/pywheel/hdmr_normal.png";
			rifle_normal.Alias = "$PB_HDMR_WHEEL_DMR";
			rifle_normal.tokentogive = "SelectHDMRMode";
			rifle_normal.scalex = iconscale.x;
			rifle_normal.scaley = iconscale.y;
			
			spw.Push(rifle_normal);
		}
		else 
		{
			PB_SpecialWheel_Mode rifle_sniper = new ("PB_SpecialWheel_Mode");
			rifle_sniper.img = "graphics/pywheel/hdmr_sniper.png";
			rifle_sniper.Alias = "$PB_HDMR_WHEEL_SNIPER";
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
			
		let weap = PB_WeaponBase(requester.player.readyweapon);
		vector2 iconScale = (0.55, 0.55);
			
		if(weap.akimboMode) 
		{
			PB_SpecialWheel_Mode qsg_undual = new ("PB_SpecialWheel_Mode");
			qsg_undual.img = "graphics/pywheel/Quad_Single.png";
			qsg_undual.Alias = "$PB_QSG_WHEEL_SINGLE";
			qsg_undual.tokentogive = "SelectDualWieldQuads";
			qsg_undual.scalex = iconscale.x;
			qsg_undual.scaley = iconscale.y;
			
			spw.Push(qsg_undual);
		}
		else 
		{
			PB_SpecialWheel_Mode qsg_dual = new ("PB_SpecialWheel_Mode");
			qsg_dual.img = "graphics/pywheel/Quad_Dual.png";
			qsg_dual.Alias = "$PB_QSG_WHEEL_AKIMBO";
			qsg_dual.tokentogive = "SelectDualWieldQuads";
			qsg_dual.scalex = iconscale.x;
			qsg_dual.scaley = iconscale.y;
			
			spw.Push(qsg_dual);
		}
					
		if(requester.FindInventory("FullBlastMode")) 
		{
			PB_SpecialWheel_Mode qsg_halfnormal = new ("PB_SpecialWheel_Mode");
			qsg_halfnormal.img = "graphics/pywheel/Quad_Half.png";
			qsg_halfnormal.Alias = "$PB_QSG_WHEEL_HALF";
			qsg_halfnormal.tokentogive = "BlastToggle";
			qsg_halfnormal.scalex = iconscale.x;
			qsg_halfnormal.scaley = iconscale.y;
			
			spw.Push(qsg_halfnormal);
		}
		else 
		{
			PB_SpecialWheel_Mode qsg_fullnormal = new ("PB_SpecialWheel_Mode");
			qsg_fullnormal.img = "graphics/pywheel/Quad_Full.png";
			qsg_fullnormal.Alias = "$PB_QSG_WHEEL_FULL";
			qsg_fullnormal.tokentogive = "BlastToggle";
			qsg_fullnormal.scalex = iconscale.x;
			qsg_fullnormal.scaley = iconscale.y;
			
			spw.Push(qsg_fullnormal);
		}

		if(requester.FindInventory("BreathMode")) 
		{
			PB_SpecialWheel_Mode qsg_shell = new ("PB_SpecialWheel_Mode");
			qsg_shell.img = "graphics/pywheel/Quad_Shells.png";
			qsg_shell.Alias = "$PB_QSG_WHEEL_SHELLS";
			qsg_shell.tokentogive = "BreathToggle";
			qsg_shell.scalex = iconscale.x;
			qsg_shell.scaley = iconscale.y;
			
			spw.Push(qsg_shell);
		}
		else 
		{
			PB_SpecialWheel_Mode qsg_demon = new ("PB_SpecialWheel_Mode");
			qsg_demon.img = "graphics/pywheel/Quad_Demonic.png";
			qsg_demon.Alias = "$PB_QSG_WHEEL_DBREATH";
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
		cryorifle_missile.Alias = "$PB_CRYO_WHEEL_MISSILE";
		cryorifle_missile.tokentogive = "FireModeCryoRifleMissile_WW";
		cryorifle_missile.scalex = iconscale.x;
		cryorifle_missile.scaley = iconscale.y;
		
		spw.Push(cryorifle_missile);

		PB_SpecialWheel_Mode cryorifle_beam = new ("PB_SpecialWheel_Mode");
		cryorifle_beam.img = "graphics/pywheel/cryorifle_beam.png";
		cryorifle_beam.Alias = "$PB_CRYO_WHEEL_BEAM";
		cryorifle_beam.tokentogive = "FireModeCryoRifleBeam_WW";
		cryorifle_beam.scalex = iconscale.x;
		cryorifle_beam.scaley = iconscale.y;
		
		spw.Push(cryorifle_beam);

		PB_SpecialWheel_Mode cryorifle_spear = new ("PB_SpecialWheel_Mode");
		cryorifle_spear.img = "graphics/pywheel/CryoRifle_Spear.png";
		cryorifle_spear.Alias = "$PB_CRYO_WHEEL_SPEAR";
		cryorifle_spear.tokentogive = "FireModeCryoRifleSpear_WW";
		cryorifle_spear.scalex = iconscale.x;
		cryorifle_spear.scaley = iconscale.y;
		
		spw.Push(cryorifle_spear);

		PB_SpecialWheel_Mode cryorifle_flak = new ("PB_SpecialWheel_Mode");
		cryorifle_flak.img = "graphics/pywheel/CryoRifle_Flak.png";
		cryorifle_flak.Alias = "$PB_CRYO_WHEEL_FLAK";
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
			
		vector2 iconScale = (0.65, 0.65);
			
		PB_SpecialWheel_Mode minigun_chaingun = new ("PB_SpecialWheel_Mode");
		minigun_chaingun.img = "graphics/pywheel/Minigun_1.png";
		minigun_chaingun.Alias = "$PB_MINIGUN_WHEEL_CHAINGUN";
		minigun_chaingun.tokentogive = "SelectMinigun_Chaingun";
		minigun_chaingun.scalex = iconscale.x;
		minigun_chaingun.scaley = iconscale.y;
		
		spw.Push(minigun_chaingun);

		PB_SpecialWheel_Mode minigun_gatling = new ("PB_SpecialWheel_Mode");
		minigun_gatling.img = "graphics/pywheel/Minigun_2.png";
		minigun_gatling.Alias = "$PB_MINIGUN_WHEEL_GATLING";
		minigun_gatling.tokentogive = "SelectMinigun_Gatling";
		minigun_gatling.scalex = iconscale.x;
		minigun_gatling.scaley = iconscale.y;
		
		spw.Push(minigun_gatling);


		if(requester.FindInventory("MinigunUpgraded")) 
		{
			PB_SpecialWheel_Mode minigun_triple = new ("PB_SpecialWheel_Mode");
			minigun_triple.img = "graphics/pywheel/Minigun_3.png";
			minigun_triple.Alias = "$PB_MINIGUN_WHEEL_TRIPLE";
			minigun_triple.tokentogive = "SelectMinigun_Triple";
			minigun_triple.scalex = iconscale.x;
			minigun_triple.scaley = iconscale.y;
			
			spw.Push(minigun_triple);
		}
		else
		{
			PB_SpecialWheel_Mode minigun_triple = new ("PB_SpecialWheel_Mode");
			minigun_triple.img = "graphics/pywheel/Minigun_N.png";
			minigun_triple.Alias = "$PB_NOTAVAILABLE";
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
		
		PB_SpecialWheel_Mode shotgun_buckshot = new ("PB_SpecialWheel_Mode");
		shotgun_buckshot.img = "graphics/pywheel/SG_Buck.png";
		shotgun_buckshot.Alias = "$PB_SG_WHEEL_BUCKSHOT";
		shotgun_buckshot.tokentogive = "SelectShotgun_Buckshot";
		shotgun_buckshot.scalex = iconscale.x;
		shotgun_buckshot.scaley = iconscale.y;
		
		
		PB_SpecialWheel_Mode shotgun_slugshot = new ("PB_SpecialWheel_Mode");
		shotgun_slugshot.img = "graphics/pywheel/SG_Slug.png";
		shotgun_slugshot.Alias = "$PB_SG_WHEEL_SLUG";
		shotgun_slugshot.tokentogive = "SelectShotgun_Slugshot";
		shotgun_slugshot.scalex = iconscale.x;
		shotgun_slugshot.scaley = iconscale.y;
		
		spw.Push(shotgun_buckshot);
		spw.Push(shotgun_slugshot);
		
		if(requester.FindInventory("DragonBreathUpgrade")) 
		{
			PB_SpecialWheel_Mode shotgun_dragonbreath = new ("PB_SpecialWheel_Mode");
			shotgun_dragonbreath.img = "graphics/pywheel/SG_DB.png";
			shotgun_dragonbreath.Alias = "$PB_SG_WHEEL_DBREATH";
			shotgun_dragonbreath.tokentogive = "SelectShotgun_Dragonsbreath";
			shotgun_dragonbreath.scalex = iconscale.x;
			shotgun_dragonbreath.scaley = iconscale.y;
			
			spw.Push(shotgun_dragonbreath);
		}
		else 
		{
			PB_SpecialWheel_Mode shotgun_No = new ("PB_SpecialWheel_Mode");
			shotgun_No.img = "graphics/pywheel/SG_NO.png";
			shotgun_No.Alias = "$PB_NOTAVAILABLE";
			shotgun_No.tokentogive = "SelectShotgun_No";
			shotgun_No.scalex = iconscale.x;
			shotgun_No.scaley = iconscale.y;
			
			spw.Push(shotgun_No);
		}
		
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
		rocket_standard.Alias = "$PB_RL_WHEEL_NORMAL";
		rocket_standard.tokentogive = "RocketLauncher_Standard";
		rocket_standard.scalex = iconscale.x;
		rocket_standard.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode rocket_homing = new ("PB_SpecialWheel_Mode");
		rocket_homing.img = "graphics/pywheel/rocket_homing.png";
		rocket_homing.Alias = "$PB_RL_WHEEL_LOCKON";
		rocket_homing.tokentogive = "RocketLauncher_Homing";
		rocket_homing.scalex = iconscale.x;
		rocket_homing.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode rocket_laser = new ("PB_SpecialWheel_Mode");
		rocket_laser.img = "graphics/pywheel/rocket_laser.png";
		rocket_laser.Alias = "$PB_RL_WHEEL_GUIDED";
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
	virtual void InfoFiller(out array<string> tags,out array<string> tokens,out array<string> ownedtokens,out array<string> ammotypes,out array<string>img,out array<double>sx,out array<double>sy)
	{
		return;
	}
}

class FragGrenCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string> ownedtokens,out array<string> ammotypes,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Frag Grenade");
		tokens.push("WW_FragGrenadeSelected");
		ownedtokens.push("PB_GrenadeToken");
		ammotypes.push("PB_GrenadeAmmo");
		img.push("graphics/pywheel/Equip_Frag.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

class ShouldCanCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string> ownedtokens,out array<string> ammotypes,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Quick Launcher");
		tokens.push("WW_RevGunSelected");
		ownedtokens.push("PB_QuickLauncherToken");
		ammotypes.push("PB_QuickLauncherAmmo");
		img.push("graphics/pywheel/Equip_RevGun.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

class ProxMinCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string> ownedtokens,out array<string> ammotypes,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Proximity Mine");
		tokens.push("WW_ProximityMineSelected");
		ownedtokens.push("PB_ProxMineToken");
		ammotypes.push("PB_ProxMineAmmo");
		img.push("graphics/pywheel/Equip_Mine.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

Class StunGrenCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string> ownedtokens,out array<string> ammotypes,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Stun Grenade");
		tokens.push("WW_StunGrenadeSelected");
		ownedtokens.push("PB_StunGrenadeToken");
		ammotypes.push("PB_StunGrenadeAmmo");
		img.push("graphics/pywheel/Equip_Stun.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}

Class LeechCard : equipmentCard
{
	override void InfoFiller(out array<string> tags,out array<string> tokens,out array<string> ownedtokens,out array<string> ammotypes,out array<string>img,out array<double>sx,out array<double>sy)
	{
		tags.push("Leech");
		tokens.push("WW_LeechSelected");
		ownedtokens.push("PB_LeechToken");
		ammotypes.push("PB_DTech");
		img.push("graphics/pywheel/Equip_Leech.png");
		sx.push(1.3);
		sy.push(1.3);
	}
}