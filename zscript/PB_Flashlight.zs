//Adapted from Flashlight++, available at https://forum.zdoom.org/viewtopic.php?t=75585

//Light

class PB_FPP_Light : Spotlight
{
	Default 
	{
		+NOINTERACTION;
		//+DYNAMICLIGHT.ATTENUATE; //more realistic light dropoff
	}
	
	PlayerPawn toFollow;
	PlayerInfo toInfo;
	
	Vector3 offset;
	
	const spIntensity = 128.0;
	const spInnerAngle = 15.0;
	const spOuterAngle = 45.0;
	
	const sp2Intensity = 750.0;
	const sp2InnerAngle = 0.0;
	const sp2OuterAngle = 25.0;
	
	const beamColor = "f4 f8 ff";
	
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
		
		SpotInnerAngle = second ? sp2InnerAngle : spInnerAngle;
		SpotOuterAngle = second ? sp2OuterAngle : spOuterAngle;
        
		offset = (-5, 0, (toFollow.height / 10) - 5);
		
		return self;
	}
	
	override void Tick() 
	{
		super.Tick();
    	if (toFollow && toFollow.player)
    	{
        	A_SetAngle(toFollow.angle, SPF_INTERPOLATE);
        	A_SetPitch(toFollow.pitch, SPF_INTERPOLATE);
        	A_SetRoll(toFollow.roll, SPF_INTERPOLATE);
        	
        	SetOrigin(toFollow.pos + (RotateVector((offset.x, offset.y), toFollow.angle - 90.0), toFollow.player.viewheight + offset.z), true);
        }
        
        //BD:BE monster alerting stuff, this was a nightmare to implement
        //Credits to Blackmore1014 for this
        if(gametic % 15 == 0 && SpotOuterAngle > 0)
        {
		    double cosBeamAngle = cos(SpotOuterAngle);
			double distanceToWake = args[3] / sqrt(1.0 - cosBeamAngle);
		    
		    // look for monsters around you and alert them depending on beam width.
			vector3 vectorBeamDirection = (cos(self.angle), sin(self.angle), sin(-self.pitch)).unit();
						
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
}

//Holder

class PB_FPP_Holder : Inventory 
{
	PB_FPP_Light light1;
	PB_FPP_Light light2;
	bool on, flOutOfBatteryPenalty;
	
	double flashlightCharge;
	
	const debuggerMode = 0;
	
	const flashlightChargeMax = 100.0;
	//100 / 1.1111 = 90 seconds, not exact but you can't tell
	const flashlightDrainTime = 1.1111 / float(ticrate); 
	//100 / 25.0 = 4 seconds
	const flashlightChargeTime = 25.0 / float(ticrate);
	//100 / 12.5 = 8 seconds
	const flashlightChargeTimeSlow = 12.5 / float(ticrate);
	
	double SimpleSpline(double value)
	{
		double valueSquared = value * value;
		
		// Nice little ease-in, ease-out spline-like curve
		return (3 * valueSquared - 2 * valueSquared * value);
	}
	
	double SimpleSplineRemapVal(double val, double A, double B, double C, double D)
	{
		if(A == B)
			return val >= B ? D : C;
		double cVal = (val - A) / (B - A);
		
		return C + (D - C) * SimpleSpline(cVal);
	}
	
	override void DoEffect()
	{
		Super.DoEffect();
		
		if(on == false && flashlightCharge < flashlightChargeMax && owner.health > 0)
			flashlightCharge += flOutOfBatteryPenalty ? flashlightChargeTimeSlow : flashlightChargeTime;
		else if(on)
			flashlightCharge -= (debuggerMode == 1 && flashlightCharge > 10.0) ? 1.0 : flashlightDrainTime;
		
		if(debuggerMode == 1)
		{
			console.printf("Charge: ".."%f".." percent out of 100.", flashlightCharge);
		}
		
		if(flashlightCharge >= flashlightChargeMax && flOutOfBatteryPenalty)
			flOutOfBatteryPenalty = false;
			
		//adapted from half-life 2, available at https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/game/client/flashlighteffect.cpp#L273

		//Source SDK Copyright(c) Valve Corp.

		bool bFlicker = false;
		
		if(flashlightCharge <= 10.0 && light1 && light2)
		{
			double flScale;
			
			if (flashlightCharge >= 0.0)
			{	
				flScale = (flashlightCharge <= 4.5) ? SimpleSplineRemapVal(flashlightCharge, 4.5, 0, 1.0, 0.0) : 1.0;
			}
			else
			{
				flScale = SimpleSplineRemapVal(flashlightCharge, 10.0, 4.8, 1.0, 0.0);
			}
			
			flScale = clamp(flScale, 0.0, 1.0);
			
			if (flScale < 0.35)
			{
				//float flFlicker = cos(gametic * 6.0) * sin(gametic * 15.0);
				double flFlicker = frandom(-1.0, 1.0);
				
				if(flFlicker > 0.25 && flFlicker < 0.75)
				{
					// On
					light1.args[3] = light1.spIntensity * flScale;
					light2.args[3] = light2.sp2Intensity * flScale;
				}
				else
				{
					// Off
					light1.args[3] = 0.0;
					light2.args[3] = 0.0;
				}
			}
			else
			{
				//float flNoise = cos(gametic * 7.0) * sin(gametic * 25.0);
				double flNoise = frandom(-1.0, 1.0);
				
				light1.args[3] = light1.spIntensity * flScale + 1.5 * flNoise;
				light2.args[3] = light2.sp2Intensity * flScale + 1.5 * flNoise;
			}
			
			light1.SpotInnerAngle = light1.spInnerAngle - (16.0 * (1.0 - flScale));
			light2.SpotInnerAngle = light2.sp2InnerAngle - (16.0 * (1.0 - flScale));
			
			//Don't go negative.
			light1.SpotInnerAngle = clamp(light1.SpotInnerAngle, 0, light1.spInnerAngle);
			light2.SpotInnerAngle = clamp(light2.SpotInnerAngle, 0, light2.sp2InnerAngle);
			
			light1.SpotOuterAngle = light1.spOuterAngle - (16.0 * (1.0 - flScale));
			light2.SpotOuterAngle = light2.sp2OuterAngle - (16.0 * (1.0 - flScale));
			
			light1.SpotOuterAngle = clamp(light1.SpotOuterAngle, 0, light1.spOuterAngle);
			light2.SpotOuterAngle = clamp(light2.SpotOuterAngle, 0, light2.sp2OuterAngle);
			
			bFlicker = true;
		}
		
		if(bFlicker == false && light1 && light2)
		{
			light1.args[3] = light1.spIntensity;
			light2.args[3] = light2.sp2Intensity;
			
			light1.SpotInnerAngle = light1.spInnerAngle;
			light2.SpotInnerAngle = light2.sp2InnerAngle;
			
			light1.SpotOuterAngle = light1.spOuterAngle;
			light2.SpotOuterAngle = light2.sp2OuterAngle;
		}
			
		if(flashlightCharge <= 0)
		{
			Disable();
			flOutOfBatteryPenalty = true;
			owner.A_StartSound("PB/FlashlightOff", CHAN_AUTO);
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
		flashlightCharge = flashlightChargeMax;
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
		if(owner.health > 0)
			if(on) {
				Disable();
				PlayFlashlightToggleSound(false);
			}
			else if(flashlightCharge > 0 && flOutOfBatteryPenalty == false) {
				Enable();
				PlayFlashlightToggleSound(true);
			}
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
