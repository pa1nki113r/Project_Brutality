extend class PB_WeaponBase //Barrels. Pope, why's your code so jank? It looks fucking wretched. -AD
{
	string b;

	action void PB_RaiseBarrel() {
		A_SetInventory("CantWeaponSpecial", 1);
		A_ClearOverlays(-10, 65);
		A_StopSound(1);
		A_StopSounds(4, 6);
		A_TakeInventory("Zoomed", 1);
		A_ZoomFactor(1.0);
		A_SetCrosshair(-1);
		PB_SetReloading(false);
		A_StartSound("barrel/pain");
	}
	
	action void PB_BarrelThrow()
	{
		let token = PB_BarrelToken(FindInventory("PB_BarrelToken"));
		let barrel = PB_ThrownBarrel(A_FireProjectile("PB_ThrownBarrel", flags:FPF_NOAUTOAIM));
		if(barrel && token) {
			barrel.barrelType = token.barrelType;
			barrel.bloodstained = token.bloodstained;
			barrel.holes = token.holes;
			barrel.cut = token.cut;
			barrel.dented = token.dented;
			barrel.drained = token.drained;
		}
		SetInventory("PB_BarrelToken", 0);
		invoker.hasBarrel = false;
	}
	
	action void PB_SetBarrelSprites(string explosive, string burning, string frozen) {
		let token = PB_BarrelToken(FindInventory("PB_BarrelToken"));
		if(token) {
			switch(token.barrelType) {
			case PB_BarrelToken.TYPE_EXPLOSIVE:
				A_SetWeaponSprite(explosive);
				break;
			case PB_BarrelToken.TYPE_BURNING:
				A_SetWeaponSprite(burning);
				break;
			case PB_BarrelToken.TYPE_FROZEN:
				A_SetWeaponSprite(frozen);
				break;
			}
		}
	}
	
	action state PB_BarrelJump(statelabel explosive, statelabel burning, statelabel frozen) {
		let token = PB_BarrelToken(FindInventory("PB_BarrelToken"));
		switch(token.barrelType) {
		case PB_BarrelToken.TYPE_EXPLOSIVE:
			return resolvestate(explosive);
			break;
		case PB_BarrelToken.TYPE_BURNING:
			return resolvestate(burning);
			break;
		case PB_BarrelToken.TYPE_FROZEN:
			return resolvestate(frozen);
			break;
		}
		return resolvestate(null);
	}
	
	States
	{
	CacheSprites:
		BANE A 0;
		BAFE A 0;
		BAIE A 0;
	RaiseBarrel:
		TNT1 A 0 PB_RaiseBarrel();
		BANE ABCDEFG 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
	ReadyBarrel:
		TNT1 A 0 PB_BarrelJump("ReadyExplosiveBarrel", "ReadyBurningBarrel", "ReadyFrozenBarrel");
	//Idle
	ReadyExplosiveBarrel:
		THRG LKJIHHIJKL 2 A_DoPBWeaponAction(0, PB_NOUNLOAD);
		Loop;
	ReadyBurningBarrel:
		THRG DEFGFED 2 A_DoPBWeaponAction(0, PB_NOUNLOAD);
		Loop;
	ReadyFrozenBarrel:
		THRG M 1 A_DoPBWeaponAction(0, PB_NOUNLOAD);
		Loop;
	//Throw
	ThrowBarrel:
		TNT1 A 0 A_JumpIf(!FindInventory("PB_PowerStrength"), "PlaceBarrel");
		BANE HIJKLMN 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		TNT1 A 0 A_StartSound("weapons/fistwhoosh");
		BANE ONLJH 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		TNT1 A 0 PB_BarrelThrow();
		THRF ABCDEF 2 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		TNT1 A 0 A_SetInventory("CantWeaponSpecial", 0);
		Goto GoingToReady2;
	//Place
	PlaceBarrel:
		BANE GFEDCBA 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		TNT1 A 0 {
			let token = PB_BarrelToken(FindInventory("PB_BarrelToken"));
			string barrelType;
			switch(token.barrelType) {
			case PB_BarrelToken.TYPE_EXPLOSIVE:
				barreltype = "PB_ExplosiveBarrel";
				break;
			case PB_BarrelToken.TYPE_BURNING:
				barreltype = "PB_BurningBarrel";
				break;
			case PB_BarrelToken.TYPE_FROZEN:
				barreltype = "PB_FrozenBarrel";
				break;
			}
			bool success;
			Actor spawnedbarrel;
			[success, spawnedbarrel] = A_SpawnItemEx(barrelType, 17, xvel:12);
			let barrel = PB_BarrelBase(spawnedbarrel);
			if(barrel && token) {
				barrel.bloodstained = token.bloodstained;
				barrel.holes = token.holes;
				barrel.cut = token.cut;
				barrel.dented = token.dented;
				barrel.drained = token.drained;
			}
			SetInventory("PB_BarrelToken", 0);
			invoker.hasBarrel = false;
			A_StartSound("barrel/pain");
		}
		PKPB HGFEDCBA 1;
		TNT1 A 2;
		TNT1 A 0 A_SetInventory("CantWeaponSpecial",0);
		TNT1 A 0 A_JumpIf(player.PendingWeapon != WP_NOCHANGE,1);
		Goto GoingToReady2;
		TNT1 A 0 A_Lower();
		Wait;
	//Flashes
	FlashBarrelKicking:
		BANE IJKLMNOONMLKJI 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		Goto ReadyBarrel;
	FlashBarrelPunching:
		BANE IJKL 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		BANE M 6 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		BANE LKJI 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		Goto ReadyBarrel;
	FlashBarrelAirKicking:
		BANE IJKLMNOOOOONMLKJI 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		Goto ReadyBarrel;
	FlashBarrelSlideKicking:
		BANE IJKLMNOOOOOOOOOOOOOOOOOOOO 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		Goto ReadyBarrel;
	FlashBarrelSlideKickingStop:
		BANE ONMLKJI 1 PB_SetBarrelSprites("BANE", "BAFE", "BAIE");
		Goto ReadyBarrel;
	}
}