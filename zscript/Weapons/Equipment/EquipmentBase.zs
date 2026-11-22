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
	
    //[Pop] This is a wrapper for A_SetRoll, to allow for CVar control of 
	//player camera tilting. SPF_INTERPOLATE will always be on, and pointer
	//should always be the player anyways, so dont need to worry about those.
	action void PB_SetRoll(double rollangle)
	{
		//Do CVar Check
		if(pb_camerarolltoggle)
		{
			A_SetRoll(rollangle, SPF_INTERPOLATE);
		}
	}
	
	//[nV] convenient wrapper for executions, respects, and other animations to control the camera.
	action void PB_RotateCamera(double addAngle = 0.0, double addPitch = 0.0, double addRoll = 0.0) {
		angle += addAngle;
		pitch += addPitch;
		roll += addRoll;
	}
	
	//Set weapon recoil, factoring in the recoil multiplier cvar
	//Normally you want to use PB_WeaponRecoil instead, because it accounts for the berserk powerup
	action void PB_WeaponRecoilBasic(float pitchDelta, float angleDelta = 0)
	{
		double fac = 1.0;
		if (invoker.GunBraced)
		{
			fac *= 0.33;
		}
		
		pitch += (pitchDelta * pb_weapon_recoil_mod_vertical * fac);
		pitch = clamp(pitch,-90,90);
		angle += (angleDelta * pb_weapon_recoil_mod_horizontal * fac);
	}
	
	//Adds weapon recoil, modifying it if the owner has a berserk powerup
	action void PB_WeaponRecoil(float pitchDelta, float angleDelta, float powerMod = 0.5)
	{
		if (invoker.OwnerHasBerserk())
			PB_WeaponRecoilBasic(pitchDelta * powerMod, angleDelta * powerMod);
		else
			PB_WeaponRecoilBasic(pitchDelta, angleDelta);
	}
	
	action void PB_SpawnCasing(class<Actor> casing, double xOfs = 0, double horOfs = 0, double vertOfs = 0, double xSpeed = 0, double horSpeed = 0, double vertSpeed = 0, bool ejectionSmoke = true, bool sparks = false)
	{
		vertOfs -= (self.player.viewz - self.pos.z) / self.player.CrouchFactor;
        horOfs *= invoker.WeaponScaleX;
		double fovOfs = (120 - self.player.desiredfov) / 3.f; // good enough
		
		PlayerPawnBase plr = PlayerPawnBase(self);
		
		if(plr)
		{
			horOfs -= plr.FinalBob.x * 0.3;
			vertOfs -= plr.FinalBob.y * 0.3;
		}
	
		Vector3 spos = PB_Math.RelativeToGlobalCoords((self.pos.xy, self.player.viewz), (self.angle, self.pitch, self.roll), (xOfs - (5.0 * abs(sin(self.pitch))) + fovOfs, horOfs, vertOfs), true);
		Vector3 svel = PB_Math.RelativeToGlobalCoords((self.vel.xy, 0), (self.angle, self.pitch, self.roll), (xSpeed, horSpeed, vertSpeed));
	
		let pCase = Spawn(casing, spos);
		if(pCase)
		{
			pCase.vel = svel;
			pCase.angle = self.angle;
			pCase.target = self;	//so the casings dont collide with the shooter

			let pPBCase = PB_CasingBase(pCase);

            if(!pPBCase)
                return;

            if(!pPBCase.bNEVERSMOKE && ejectionSmoke) 
            {
                let pSmoke = PB_GunFireSmoke(Spawn('PB_CasingEjectionSmoke', spos));

                if(pSmoke) {
                    //svel = PB_Math.RelativeToGlobalCoords((self.vel.xy, 0), (self.angle, self.pitch, self.roll), (xSpeed, horSpeed, vertSpeed));
                    vector3 unitVel = (xSpeed, horSpeed, vertSpeed).Unit();
                    pSmoke.master = self;
                    // svel = PB_Math.RelativeToGlobalCoords((self.vel.xy, 0), (self.angle, self.pitch, self.roll), (xSpeed * 0.2, horSpeed * 0.2, vertSpeed * 0.2));
                    pSmoke.vel = svel;
                    pSmoke.pitch = -(90 - asin(unitVel.z)) * (unitVel.y);
                    //pSmoke.alpha = 0.25;
                    pSmoke.blowSpeed = 1.1;
                    pSmoke.fadeSpeed = 1.1;
                }
            }

            if(sparks)
            {
                vector3 randvel;
                int sparkcount = randompick(0, random(2, 4));
                for(int i = 0; i < sparkcount; i++)
                {
                    randvel = (frandom(-1, 1), frandom(-1, 1), frandom(-1, 1));
                    spos = PB_Math.RelativeToGlobalCoords((self.pos.xy, self.player.viewz), (self.angle, self.pitch, self.roll), (xOfs - (5.0 * abs(sin(self.pitch))) + fovOfs, horOfs, vertOfs) + randvel, true);
                    svel = PB_Math.RelativeToGlobalCoords((self.vel.xy, 0), (self.angle, self.pitch, self.roll), (xSpeed, horSpeed, vertSpeed) + randvel);

                    let act = Spawn('PB_MuzzleSpark', spos);
                    act.vel = svel;
                    act.scale *= 0.35;
                    act.SetShade("FF9D2E");
                }
            }
		}
	}
	
	//- L, 0 C, + R
	// [gng] credits to Agent_Ash for the position calculation, modified by me to fix the pitch bug
	Action PB_GunFireSmoke PB_GunSmokeSpawn(vector3 ofs, vector3 vofs, string SActor = "PB_GunFireSmoke", double scalemul = 1.0, double alphamul = 1.0, double blowspeed = 1.02, double fadeSpeed = 1.0, bool rollSprite = true, double slowBlowSpeed = 1.0)
	{
		ofs.z -= 10.5;
		ofs.y += 15;
		double fovOfs = (120 - self.player.desiredfov) / 3.f; // good enough
		
		PlayerPawnBase plr = PlayerPawnBase(self);
		
		if(plr)
		{
			ofs.x -= plr.FinalBob.x * 0.3;
			ofs.z -= plr.FinalBob.y * 0.3;
		}
		
		Vector3 spos = PB_Math.RelativeToGlobalCoords((self.pos.xy, self.player.viewz), (self.angle, self.pitch, self.roll), (self.radius + ofs.y - (5.0 * abs(sin(self.pitch))) + fovOfs, -ofs.x, ofs.z), true);
		Vector3 svel = PB_Math.RelativeToGlobalCoords((self.vel.xy, 0), (self.angle, self.pitch, self.roll), vofs);
		
		PB_GunFireSmoke Smoke = PB_GunFireSmoke(Spawn(SActor, spos));
		
		If(Smoke)
		{
			Smoke.master = invoker.owner;
			Smoke.vel += svel;
			if(rollSprite) 
            {
                Smoke.A_SetRoll(random(0, 359));
                Smoke.bXFLIP = randompick(0, 1);
                Smoke.bYFLIP = randompick(0, 1);
            }
			Smoke.scale *= scalemul;
			Smoke.alpha *= alphamul;
			Smoke.blowSpeed = blowspeed;
			Smoke.fadeSpeed = fadeSpeed;
            Smoke.angle = angle;
            Smoke.pitch = pitch;
            Smoke.slowBlowSpeed = slowBlowSpeed;
			
			if(invoker.smokeColor != "FFFFFF")
			{
				Smoke.A_SetRenderStyle(Smoke.alpha, STYLE_STENCIL);
				Smoke.SetShade(invoker.smokeColor);
			}
		}

		return Smoke;
	}
	
	States {
	Use:
		TNT1 A 0 {
			A_Overlay(-90, "UseEquipment");
			A_OverlayOffset(-90); //no args resets it to default position.
		}
		Stop;
	}
}
