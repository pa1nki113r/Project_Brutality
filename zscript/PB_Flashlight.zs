//Adapted from Flashlight++, available at https://forum.zdoom.org/viewtopic.php?t=75585

//Light

class PB_FPP_Light : Spotlight
{
	Default 
	{
		+NOINTERACTION;
		+DYNAMICLIGHT.ATTENUATE; //more realistic light dropoff
	}
	
	PlayerPawn toFollow;
	PlayerInfo toInfo;
	
	Vector3 offset;
	
	const spOuterAngle = 45.0;
	const spInnerAngle = 0.0;
	const spIntensity = 165.0;
	
	const sp2OuterAngle = 15.0;
	const sp2InnerAngle = 0.0;
	const sp2Intensity = 400.0;
	
	const beamColor = "ff ff ff";
	
	int currentTickCount;
	
	//This is run whenever the flashlight is turned on.
	PB_FPP_Light Init(PlayerPawn p, bool second)
	{
		toFollow = p;
		toInfo = p.player;
		
		Color c = beamColor;
		
		args[0] = c.r;
		args[1] = c.g;
		args[2] = c.b;
		args[3] = second ? sp2Intensity : spIntensity;
		
		SpotInnerAngle = second ? ScaleToFOV(sp2InnerAngle) : ScaleToFOV(spInnerAngle);
		SpotOuterAngle = second ? ScaleToFOV(sp2OuterAngle) : ScaleToFOV(spOuterAngle);
        
		offset = (-5, 0, (toFollow.height / 10) - 5);
		
		return self;
	}
	
	override void Tick() 
	{
		currentTickCount++;
		
		super.Tick();
    	if (toFollow && toFollow.player) //same here.
    	{
        	A_SetAngle(toFollow.angle, SPF_INTERPOLATE);
        	A_SetPitch(toFollow.pitch, SPF_INTERPOLATE);
        	A_SetRoll(toFollow.roll, SPF_INTERPOLATE);
        	
        	SetOrigin(toFollow.pos + (RotateVector((offset.x, offset.y), toFollow.angle - 90.0), toFollow.player.viewheight + offset.z), true);
        }
        
        //BD:BE monster alerting stuff, this was a nightmare to implement
        //Credits to Blackmore1014 for this
        if (currentTickCount % 15 == 0)
        {
		    double cosBeamAngle = cos(SpotOuterAngle);
			double distanceToWake = args[3] / sqrt(1.0 - cosBeamAngle);
		    
		    // look for monsters around you and alert them depending on beam width.
			vector3 vectorBeamDirection = (cos(self.angle), sin(self.angle), sin( -self.pitch )).unit();
						
			BlockThingsIterator it = BlockThingsIterator.Create(self, distanceToWake);
			
			while (it.Next())
			{
					Actor mo = it.thing;
					
					//only consider monsters, not yet alerted:
					if (mo.bIsMonster)
					{
						Vector3 vectorToMonster = self.Vec3To(mo).unit();
						
					//dot product is cos of angle between the vectors.
					double cosAngleMonsterBeam = vectorToMonster dot vectorBeamDirection;
						
					//also check real sight
					if ((cosAngleMonsterBeam >= cosBeamAngle) && (self.distance3DSquared(mo) <= distanceToWake **2) && self.CheckSight(mo))
					{
						//mark as last heard to ping them
						//no need to do: self.toFollow.SoundAlert(mo, false,1.0);
						mo.lastheard = self.toFollow;
					}
				}
			}
		}
	}
	
	double ScaleToFOV(double anglein)
	{
		return anglein * (toInfo.DesiredFOV / 90.0);
	}
}

//Holder

class PB_FPP_Holder : Inventory 
{
	PB_FPP_Light light1;
	PB_FPP_Light light2;
	bool on;
	
	int flashlightCharge;
	const flashlightChargeMax = 1400; //40 seconds
	
	override void DoEffect()
	{
		Super.DoEffect();
		
		//console.printf("%i", flashlightcharge);
		
		if(on == false && flashlightCharge < flashlightChargeMax)
			flashlightCharge += 5;
		else if(on)
			flashlightCharge--;
			
		if(flashlightCharge <= 0)
		{
			Disable();
			owner.A_StartSound("Sparks/Spawn", CHAN_AUTO, CHANF_LOCAL, 0.20);
		}
	}
	
	void Enable()
	{
		PlayerPawn pp = PlayerPawn(owner);
		if(pp)
		{
			if(light1)
				light1.destroy();
			
			light1 = PB_FPP_Light(owner.Spawn("PB_FPP_Light")).Init(pp, false);
			
			if(light2)
				light2.destroy();
			
			light2 = PB_FPP_Light(owner.Spawn("PB_FPP_Light")).Init(pp, true);
		}
		on = true;
	}
	
	void Disable()
	{
		if(light1) {
			light1.destroy();
			light1 = null;
		}
		
		if(light2) {
			light2.destroy();
			light2 = null;
		}
		
		on = false;
	}
	
	PB_FPP_Holder Init()
	{
		light1 = null;
		light2 = null;
		on = false;
		flashlightCharge = 1400;
		return self;
	}
	
	//ProydohaRupert code
    void PlayFlashlightToggleSound(bool toggleOn)
	{
		if(toggleOn) 
			owner.A_StartSound("PB/FlashlightOn", CHAN_AUTO);
		else 
			owner.A_StartSound("PB/FlashlightOff", CHAN_AUTO);
	}
	
	void ToggleFlashlight()
	{
		if(on) {
			Disable();
			PlayFlashlightToggleSound(false);
		}
		else if(flashlightCharge > 0) {
			Enable();
			PlayFlashlightToggleSound(true);
		}
	}
	
	void FixState()
	{
		if(!owner)
			destroy();
		
		else
		{
			if(on)
				Enable();
			else
				Disable();
		}
	}
}

//Handler

extend class PB_EventHandler
{
	
	PB_FPP_Holder setupFlashlightHolder(PlayerPawn p)
	{
		PB_FPP_Holder holder = PB_FPP_Holder(p.GiveInventoryType("PB_FPP_Holder"));
		holder.Init();
		return holder;
	}
}
