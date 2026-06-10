class PB_Ammo : Ammo
{
	int cap,ca,res; name ammotype,s; string p;
	property ammotype : ammotype;
	
	string lowerBG, upperBG, dualBG, emptyBG, currentBar, ammoIcon, fontTranslation;
	property HUDGraphics : lowerBG, upperBG, dualBG, emptyBG, currentBar, ammoIcon, fontTranslation;
	mixin PB_BetterPickupSound;
	
	Default
	{
		+FLOORCLIP
		+DONTGIB
		+INVENTORY.IGNORESKILL
		PB_Ammo.HUDGraphics "BARBACC1", "BARBACC2", "BARBACC3", "BARBACC4", "ABAR8", "AMMOIC8", "None";
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		PB_SetAmmoSprite();
	}

	override class<Ammo> GetParentAmmo()
	{
		class<Object> type = GetClass();
		while(type.GetParentClass()!= "PB_Ammo"&&type.GetParentClass()!=null) type = type.GetParentClass();
		return(class<Ammo>)(type);
	}

	override bool TryPickup(in out actor toucher)
	{
		class<Ammo> type = GetParentAmmo();
		double factor = G_SkillPropertyFloat(SKILLP_AmmoFactor)*(bDROPPED?-G_SkillPropertyFloat(SKILLP_DropAmmoFactor):1);
		int aa = self.amount*factor;
		if(toucher && toucher is "PlayerPawn")
		{
			if (!toucher.FindInventory(self.GetParentAmmo(),true)){
				cap = toucher.FindInventory("Backpack",true)?self.BackpackMaxAmount:self.MaxAmount;
			}
			else{
				cap = toucher.FindInventory(self.GetParentAmmo(),true).MaxAmount;
			}
			ca = toucher.CountInv(type);
		}
		res = cap-ca;
		if(res<aa) AmmoCheck();
		else { res = aa; AmmoCheck(); }
		return Super.TryPickup(toucher);
	}

	virtual void AmmoCheck() { if(res==1 || ammotype == "fuel" || ammotype == "mancfuel" || ammotype == "dtech" || ammotype == "permadtech" ) p = "+%d %s"; else p = "+%d %ss"; }
	
	override string PickupMessage() { return string.format(p,res,GetTag()); }
	
	virtual void PB_SetAmmoSprite()
	{
		switch(ammotype)
		{
			case 'lowcal': s = "MBLK"; break;
			case 'lowcalbox': s = "AMOK"; break;
			case 'lowcalround': s = "1BLK"; break;
			case 'magnumround': s = "2BLK"; break;
			case 'deagleround': s = "3BLK"; break;
			case 'highcal': s = "CL1P"; break;
			case 'highcalbox': s = "AMM0"; break;
			case 'highcalround': s = "1CLP"; break;
			case 'highercalround': s = "1CL2"; break;
			case 'missileround': s = "1CL3"; break;
			case 'shell': s = "SHE1"; break;
			case 'shellbox': s = "SB0X"; break;
			case '1shell': s = "1SHL"; break;
			case '1shell2': s = "1SH2"; break;
			case '1shell3': s = "1SH3"; break;
			case 'exp': s = "R0CK"; break;
			case 'expbox': s = "BR0K"; break;
			case 'impactnade': s = "G0CK"; break;
			case 'acidnade': s = "G0C2"; break;
			case 'cryonade': s = "G0C3"; break;
			case 'firenade': s = "G0C4"; break;
			case 'stickynade': s = "G0C5"; break;
			case 'cell' : s = "CEL1"; SetStateLabel("SpawnCell"); break;
			case 'cellpack' : s = "YELP"; SetStateLabel("SpawnCellPack"); break;
			case 'fuel': s = "GSLN"; break;
			case 'mancfuel': s = "MANA"; frame = 7; break;
			case 'dtech': s = "DB61"; SetStateLabel("SpawnDTech"); break;
			case 'permadtech': s = "DB61"; SetStateLabel("SpawnPermaDTech"); break;
			case 'leechnade': s = "FLSP"; SetStateLabel("SpawnLeechNade"); break;
			case 'nade': s = "PGRN"; frame = 3; break;
			case 'nadestun': s = "STNG"; break;
			case 'proxmine': s = "XPFP"; break;
			case 'ql': s = "FATB"; frame = 3; break;
		}
		sprite = GetSpriteIndex(s);
	}

	States
	{
	Spawn:
		TNT1 A -1;
		stop;
	SpawnCell:
		CEL1 ABCDEFGH 2;
		loop;
	SpawnCellPack:
		YELP ABCDEFGHIJ 2;
		loop;
	SpawnDTech:
		DB61 ABCDEFGH 2 bright A_FadeOut(.01 * (0.085 / Scale.X), FTF_REMOVE | FTF_CLAMP );
		loop;
	SpawnPermaDTech:
		DB61 ABCDEFGH 2 bright;
		loop;
	SpawnLeechNade:
		FLSP BAFEFA 6;
		Loop;
	LoadSprites:
		MBLK A 0; AMOK A 0; 1BLK A 0; 2BLK A 0; 3BLK A 0; CL1P A 0; AMM0 A 0; 1CLP A 0; 1CL2 A 0;
		1CL3 A 0; SHE1 A 0; SB0X A 0; 1SHL A 0; 1SH2 A 0; 1SH3 A 0; R0CK A 0; BR0K A 0; G0CK A 0;
		G0C2 A 0; G0C3 A 0; G0C4 A 0; G0C5 A 0; GSLN A 0; MANA H 0; STNG A 0; XPFP A 0; PGRN D 0;
		FATB D 0;
	}
}