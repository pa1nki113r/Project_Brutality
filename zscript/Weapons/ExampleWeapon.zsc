class PB_ExampleWeapon : PB_WeaponBase
{
	Defaukt
	{
		Weapon.SlotNumber 10;
		
		Obituary "Player was Shot by Player.";
		Inventory.Pickupmessage "Pickup message for Gun";
		Tag "Gun Lore Name";
		Scale 1.0;
		Inventory.PickupSound "weapon/Gun/Pickup";
		//Inventory.AltHUDIcon "TNT1A0"; [Pop] this isnt exactly required, but a
		//good idea to have
		
		//weapon.ammotype1 ""; Set reserve ammo here
		//weapon.ammogive1 1; How much reserve ammo picking up the gun should give
		//weapon.ammotype2 ""; The actual ammo in the gun itself
		//[pop] never make ammo in mag an int or anything btw, thats just stupid
		//jank and shit, if we wanted to do something extra crazy we should make
		//mag ammo an array and set it up like Deathstrider does, but thats
		//scope creep and uneeded.
		
		//PB_WeaponBase.unloadertoken "MyWeaponUnloaded"; token that indicates if this specific weapon is unloaded, example of the token defined below this class
		//PB_WeaponBase.respectItem "MyWeaponRespect"; token needed for the respect to work, in case your weapon has a respect animation, example of the token defined below this class
		
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE; //[Pop] Use NOAUTOFIRE if you want a semi auto gun.
		//Albeit PB has QOL stuff for holding down left click already, firing it
		//at a slower rate
	}
	
	//[Pop] define any useful bools or ints and stuff here, cause we need to 
	//move away from tokens since tokens are inventory that constantly Tick
	//as well.
	
	//[Pop] do any custom functions right after, like the FireWeapon right below.
	
	//[Pop] Heres the actual function for firing the gun, this can be reused
	//as well for akimbo. Or even modified to support animating the recoil
	//of the gun entirely via Offsets and Overlays using another int and a switch
	//then calling the function multiple times over multiple tics with that int 
	//changed. (Check Deathstrider for reference, every gun there is animated
	//this way.
	action void FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				//[Pop] First do the check to alert monsters or not, then do so
				A_AlertMonsters();
				
				//[Pop] If the weapon has akimbo, use weaponSide to set which side using
				//a switch
				switch (weaponSide)
				{
					//only going to have centered as an example, but use Case 1 for left and Case 2 for Right
					default:
					case 0:
						//[Pop] Lets handle the muzzle flash first. Use a Ternary
						//Conditional Operator to pick between ADS and nonADS 
						//muzzle overlay too if applicable.
						//Example bool isADS used, will need to define your own
						A_Overlay(-3, isADS ? "MuzzleFlashADS" : "MuzzleFlash");
						//Adjust overlayscale if need be here
						//[Pop] render style flags set here for nice blending
						A_OverlayFlags(-3, PSPF_ALPHA, true);
						A_OverlayFlags(-3, PSPF_RENDERSTYLE, true);
						A_OverlayRenderstyle(-3, STYLE_ADD);
						//[Pop] Now to the meat of the gun, play the appropriate sounds here
						//I think they should all really be CHAN_WEAPON, CHANF_OVERLAP
						//should handle everything else
						A_StartSound("Rifle/Fire", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 1.2);
						A_StartSound("Rifle/FireAdd", CHAN_WEAPON, CHANF_OVERLAP, 0.75, pitch: 0.8);
						A_StartSound("Rifle/FireBass", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 0.6);
						//[Pop] Then lets fire the projectile here
						PB_FireBullets("PB_762x51mm", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
						//TakeInventory; //[Pop] DONT FORGET to use ammo as well
						//[Pop] And finally, do any extra effects here
						//GunSmoke;
						//MuzzleSparks;
						//[Pop] NEVER do more or less than 0.98, it looks bad
						//ALWAYS make sure to reset to 1.0 on NEXT TIC
						//A_ZoomFactor(0.98, SPF_INTERPOLATE);
						//CameraRoll;
						//etc etc
						break;
				}
			//Tic 2
			case 2:
				//A_ZoomFactor(1.0, SPF_INTERPOLATE);
				break;
			//Tic 3
			case 3:
				//Nothing this time
				break;
		}
	}
	
	States
	{
		//[Pop] These are the default Deselect and Select states, make sure to 
		//play any animations prior to calling PB_LowerWeapon here.
		Deselect:
			TNT1 A 1 PB_LowerWeapon();
			Wait;
		Select:
			TNT1 A 1 PB_RaiseWeapon();
			Wait;
		
		//[Pop] Here we will check for respect and then either play it or not.
		Ready:
			//[Pop] Also cache any extra frames here so they are in memory
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAA 0;
			TNT1 A 0 PB_RespectIfNeeded();
			TNT1 A 1;
			Goto WeaponReady;
		
		//[Jai]this is for the respect animation, if any.
		WeaponRespect:
			TNT1 A 1 A_DoPBWeaponAction(); dont forget to add A_DoPBWeaponAction() so you can cancel this animation in game
			goto WeaponReady;
		
		//[Pop] here is the Actual ready state, there should be a second for 
		//when the player is in ADS, but extra states beyond that should be
		//instead swapped to via just changing the weapon sprite and running different
		//code. Unless it specifically wont work that way, like with some plasma weapons.
		WeaponReady:
			//Check ADS, goto WeaponReadyADS;
			TNT1 A 1 PB_WeaponReady();
			Loop;
		WeaponReadyADS:
			//Check ADS, goto WeaponReady;
			TNT1 B 1 PB_WeaponReady();
			Loop;
		
		///////////////////////////////////////////////////////////////
		//	The Fire/Altfire states
		//	its up to you how you handle it
		//
		//	if you want to implement alternative fire states, i recommend you to create vars:
		//	like for example, if you want to do a secondary mode
		//	define this var outside of any block(default or states) but inside of the weapon	
		//	/*	Bool SecondaryFire;	*/
		//	and for it to work, you need to check it with the invoker. prefix
		//	something like this
		//
		//		Fire:
		//		TNT1 A 0 A_jumpif(invoker.SecondaryFire,"Someotherattack");
		//		...continue with the normal attack
		//
		//	this way you dont get drowned by inventory tokens
		//
		//	also, this is useful when you want to do more alternative attacks, think of the super grenade launcher
		//	so instead of defining a lot of tokens named USING_FIREMODE, USING_ACIDMODE, USING... etc
		//	you can just use an int var, and with constants or enums (basically, giving fancy names to numbers), you get something more solid and easy to expand
		//	like this
		//
		//		//this int var holds the actual mode youre using
		//		int specialmode; //by default it starts in 0, so take it in account
		//
		//		enum Weapon_Specialmodes {
		//			SP_Mode1 = 1,SP_Mode2 = 2,	...	SP_Mode321 = 321
		//		};
		//	and handle it with a switch state instead of a lot of A_jumpifinventory()
		//	like this:
		//		switch(specialmode)
		//		{
		//			case 1: do this, and this, etc; Break;
		//			case 2: do this other thing, and this, etc; Break;
		//		}
		//
		//
		//	Also, dont forget to check the BaseWeapon_Functions.zsc lump inside of PB
		//	to learn more of the available functions, like the reload ones like the one mentioned in the reload state below, recoil ones like PB_WeaponRecoil() 
		//	the casings spawn one (PB_SpawnCasing()),or the projectile spawn ones like PB_FireBullets()
		//
		///////////////////////////////////////////////////////////////
		
		//[Pop] Firing states
		Fire:
			TNT1 A 1 FireWeapon(0,1);
			TNT1 A 1 FireWeapon(0,2);
			TNT1 A 1 FireWeapon(0,3);
			Goto WeaponReady;
		//[Pop] because different animations too
		FireADS:
			TNT1 A 1 FireWeapon(0,1);
			TNT1 A 1 FireWeapon(0,2);
			TNT1 A 1 FireWeapon(0,3);
			Goto WeaponReadyADS;
		
		//[Pop] Reloads get a bit complicated of course, but hopefully itll look
		//better with ZSAnimator in the future of course. I wont include anything
		//here, the gist is just make sure to use the actual PB_AmmoIntoMag and
		//stuff for actually handling ammo reloading, dont forget state for leaving
		//ADS and then reloading, including the check.
		Reload:
			TNT1 A 35;
			Goto WeaponReady;
		/*
		//[Jai]note: Pb has a function to do the reload, instead of using the
		//Insert_Bullets State you can use
		//PB_AmmoIntoMag(secondary ammo,primary ammo, full ammo quantity, equivalence between primary and secondary ammo);
		Reload:
			//suggestions for ammo checking, id recommend doing an state for when full or no ammo, specially if the idle state is animated
			//so it doesnt just stop when pressing reload, like the railgun
			//TNT1 A 0 A_jumpif(countinv(invoker.ammotype1) < equivalence of ammo,No Ammo state);
			//TNT1 A 0 A_jumpif(countinv(invoker.ammotype2) > Full mag,Full ammo state);
			TNT1 A 1;
			goto WeaponReady;
		*/
		//[Jai]unloading, dont forget to take the unloading token here and in
		//the reload state or you'll be in a infinite loop of going to unload
		//this also has its own function PB_UnloadMag()
		Unload:
			TNT1 A 0 A_Takeinventory("Unloading",1);
			//TNT1 A 0 A_takeinventory(invoker.UnloaderToken,1);
			goto WeaponReady;
		
		//[Jai] weapon special state
		Weaponspecial:
			TNT1 A 0 A_takeinventory("GoWeaponSpecialAbility",1); //you need to take this token to not be trapped in a non ending loop
			goto ready3;
		
		//[Pop] Extra states go down here, kicking animations or similar
		//Of course, this example weapon doesnt show AltFire for detecting ADS
		//and honestly we might want to rethink how we check for ADS button
		//presses to be more or less decoupled from states in a way for cleaner
		//code. Additionally, define MuzzleFlashes in a new BaseWeapon_MuzzleFlashes
		//file, that way addons or other guns can use the muzzleflash overlays 
		//for consistency reasons.
		
		FlashKicking:
			TNT1 AAAAAAAAAAAAAAA 0; //15 frames
			goto ready3;
			
		FlashAirKicking:
			TNT1 AAAAAAAAAAAAAAAA 1; //16 frames
			goto ready3;
			
		FlashSlideKicking:
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAA 1; //27 frames
			goto ready3;
			
		FlashSlideKickingStop:
			TNT1 AAAAAAA 1; //7 frames 
			goto ready3;
	}
}

/*
	
	[Pop] These should be integrated into PB at some point to help with cleaner code
	
	[Jai]I did this two custom functions to not copypaste every time the 
	A_Jumpifinventory(SomeBarrel,1,thestatethatthrowsthebarrel) spam
	you can use these, just put the first in the beggining of the fire state
	and the second on the beggining of the altfire state
	
	Action State PB_CheckBarrelThrow1()
	{
		//if owner doesnt have berserk wont throw it, so do the barrel place check instead
		if(countinv("PB_powerstrength")<1)
			return PB_CheckBarrelPlace1();
		
		//got nukage barrel
		if(countinv("GrabbedBarrel")>0)
			return resolvestate("ThrowBarrel");
		//got flame barrel
		if(countinv("GrabbedFlameBarrel")>0)
			return resolvestate("ThrowFlameBarrel");
		//got ice barrel
		if(countinv("GrabbedIceBarrel")>0)
			return resolvestate("ThrowIceBarrel");
		//no barrel
		return resolvestate(null);
	}
	
	Action State PB_CheckBarrelPlace1()
	{
		//got nukage barrel
		if(countinv("GrabbedBarrel")>0)
			return resolvestate("PlaceBarrel");
		//got flame barrel
		if(countinv("GrabbedFlameBarrel")>0)
			return resolvestate("PlaceFlameBarrel");
		//got ice barrel
		if(countinv("GrabbedIceBarrel")>0)
			return resolvestate("PlaceIceBarrel");
		//no barrel
		return resolvestate(null);
	}
*/