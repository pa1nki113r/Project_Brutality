/* Flashlight++, an extended version of Flashlight+ with extra customizability.
Copyright (C) 2024  generic name guy

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>. */

// Modified version of Flashlight++, available at https://forum.zdoom.org/viewtopic.php?t=75585
// Adapted for Project Brutality by generic name guy


// Light
class PB_FPP_Light : Spotlight
{
	Default 
	{
		+NOINTERACTION;
		// +DYNAMICLIGHT.ATTENUATE;
	}
	
	PlayerPawn toFollow;
	PlayerInfo toInfo;
	
	Vector3 offset;
	color baseColor, fCol;
	bool thisIsLight2;
	
	const spIntensity = sp2Intensity;
	const spInnerAngle = 0.0;
	const spOuterAngle = 60.0;
	const beamSpillColor = 0x8086A3;
	
	const sp2Intensity = 584.0;
	const sp2InnerAngle = 10.0;
	const sp2OuterAngle = 30.0;
	const beamColor = 0xEBEBEB;
	
	
	//This is run whenever the flashlight is turned on.
	PB_FPP_Light Init(PlayerPawn p, bool second)
	{
		toFollow = p;
		toInfo = p.player;
		thisIsLight2 = second; //ignore monster alerting on the second light for optimization purposes
		
		if(second)
			baseColor = beamColor;
		else
			baseColor = beamSpillColor;
		
		args[0] = baseColor.r;
		args[1] = baseColor.g;
		args[2] = baseColor.b;
		args[3] = second ? sp2Intensity : spIntensity;
		
		SpotInnerAngle = second ? sp2InnerAngle : spInnerAngle;
		SpotOuterAngle = second ? sp2OuterAngle : spOuterAngle;
        
		offset = (-5, toFollow.radius -2, (toFollow.height / 10) - 5);
		
		return self;
	}
	
	override void Tick() 
	{
		super.Tick();
    	if (toFollow && toFollow.player)
    	{
    		//console.printf("\cax: %f\cj, \cdy: %f", (90 + -abs(toFollow.pitch)) / 90.0, -toFollow.Pitch / 90.0);
        	A_SetAngle(toFollow.angle - 1.5, SPF_INTERPOLATE);
        	A_SetPitch(toFollow.pitch, SPF_INTERPOLATE);
        	A_SetRoll(toFollow.roll, SPF_INTERPOLATE);
        	
        	SetOrigin(toFollow.pos + (RotateVector((offset.x, offset.y * cos(toFollow.Pitch)), toFollow.angle - 90.0), toFollow.player.viewheight + offset.z + (offset.y * -sin(toFollow.Pitch))), true);
        }
        
        //BD:BE monster alerting stuff, this was a nightmare to implement
        //Credits to Blackmore1014 for this
        if(!thisIsLight2 && level.time >= 5 * TICRATE && gametic % 15 == 0 && SpotOuterAngle > 0)
        {
		    double cosBeamAngle = cos(SpotOuterAngle);
			double distanceToWake = args[3] / sqrt(1.0 - cosBeamAngle);
		    
		    // look for monsters around you and alert them depending on beam width.
			vector3 vectorBeamDirection = (cos(self.angle), sin(self.angle), sin(-self.pitch)).unit();
						
			BlockThingsIterator it = BlockThingsIterator.Create(self, distanceToWake);
			
			while(it.Next())
			{
					Actor mo = it.thing;
					
					//only consider monsters, not yet alerted:
					if(mo && mo.bIsMonster)
					{
						Vector3 vectorToMonster = self.Vec3To(mo).unit();
						
					//dot product is cos of angle between the vectors.
					double cosAngleMonsterBeam = vectorToMonster dot vectorBeamDirection;
						
					//also check real sight
					if((cosAngleMonsterBeam >= cosBeamAngle) && (self.distance3DSquared(mo) <= distanceToWake **2) && self.CheckSight(mo))
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

// Holder
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
		double valueSquared = value ** 2;
		
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
		
		if(on == false && flashlightCharge < flashlightChargeMax && owner.health > 0) {
			if(debuggerMode == 0)
				flashlightCharge += flOutOfBatteryPenalty ? flashlightChargeTimeSlow : flashlightChargeTime;
			else if(debuggerMode == 1)
				flashlightCharge = flashlightChargeMax;
		}
				
		else if(on)
			flashlightCharge -= (debuggerMode == 1 && flashlightCharge > 10.0) ? 1.0 : flashlightDrainTime;
		
		if(debuggerMode == 1 && light1 && light2)
		{
			console.printf("Charge: %f", flashlightCharge);
			console.printf("light1: \ca%03i \cd%03i \cn%03i", light1.args[0], light1.args[1], light1.args[2]);
			console.printf("light2: \ca%03i \cd%03i \cn%03i", light2.args[0], light2.args[1], light2.args[2]);
			console.printf("oang, iang: l1 %f %f, l2 %f %f", light1.SpotOuterAngle, light1.SpotInnerAngle, light2.SpotOuterAngle, light2.SpotInnerAngle);
		}
		
		if(flashlightCharge >= flashlightChargeMax && flOutOfBatteryPenalty)
			flOutOfBatteryPenalty = false;
			
		//adapted from half-life 2, available at https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/client/flashlighteffect.cpp#L273

		//Source SDK Copyright(c) Valve Corp.

		bool bFlicker = false;

		if(flashlightCharge <= 10.0 && light1 && light2)
		{
			double flScale;
			
			if(flashlightCharge >= 0.0)
			{	
				flScale = (flashlightCharge <= 4.5) ? SimpleSplineRemapVal(flashlightCharge, 4.5, 0, 1.0, 0.0) : 1.0;
			}
			else
			{
				flScale = SimpleSplineRemapVal(flashlightCharge, 10.0, 4.8, 1.0, 0.0);
			}
			
			flScale = clamp(flScale, 0.0, 1.0);
			
			if(flScale < 0.35)
			{
				double flFlicker = cos(gametic * 343.775) * sin(gametic * 859.437);
				
				if(flFlicker > 0.25 && flFlicker < 0.75)
				{
					// On
					light1.args[0] = light1.baseColor.r * flScale;
					light1.args[1] = light1.baseColor.g * flScale;
					light1.args[2] = light1.baseColor.b * flScale;

					light2.args[0] = light2.baseColor.r * flScale;
					light2.args[1] = light2.baseColor.g * flScale;
					light2.args[2] = light2.baseColor.b * flScale;
				}
				else
				{
					// Off
					light1.args[0] = 0;
					light1.args[1] = 0;
					light1.args[2] = 0;
					
					light2.args[0] = 0;
					light2.args[1] = 0;
					light2.args[2] = 0;
				}
			}
			else
			{
				double flNoise = frandom(-1.0, 1.0);
				
				light1.args[0] = light1.baseColor.r * flScale + 1.5 * flNoise;
				light1.args[1] = light1.baseColor.g * flScale + 1.5 * flNoise;
				light1.args[2] = light1.baseColor.b * flScale + 1.5 * flNoise;

				light2.args[0] = light2.baseColor.r * flScale + 1.5 * flNoise;
				light2.args[1] = light2.baseColor.g * flScale + 1.5 * flNoise;
				light2.args[2] = light2.baseColor.b * flScale + 1.5 * flNoise;
			}
			
			light1.SpotInnerAngle = light1.spInnerAngle - (10.0 * (1.0 - flScale));
			light2.SpotInnerAngle = light2.sp2InnerAngle - (10.0 * (1.0 - flScale));
			
			//Don't go negative.
			light1.SpotInnerAngle = clamp(light1.SpotInnerAngle, 0, light1.spInnerAngle);
			light2.SpotInnerAngle = clamp(light2.SpotInnerAngle, 0, light2.sp2InnerAngle);
			
			light1.SpotOuterAngle = light1.spOuterAngle - (10.0 * (1.0 - flScale));
			light2.SpotOuterAngle = light2.sp2OuterAngle - (10.0 * (1.0 - flScale));
			
			light1.SpotOuterAngle = clamp(light1.SpotOuterAngle, 0, light1.spOuterAngle);
			light2.SpotOuterAngle = clamp(light2.SpotOuterAngle, 0, light2.sp2OuterAngle);
			
			bFlicker = true;
		}
		
		if(bFlicker == false && light1 && light2)
		{
			light1.args[0] = light1.baseColor.r;
			light1.args[1] = light1.baseColor.g;
			light1.args[2] = light1.baseColor.b;

			light2.args[0] = light2.baseColor.r;
			light2.args[1] = light2.baseColor.g;
			light2.args[2] = light2.baseColor.b;
			
			light1.SpotInnerAngle = light1.spInnerAngle;
			light2.SpotInnerAngle = light2.sp2InnerAngle;
			
			light1.SpotOuterAngle = light1.spOuterAngle;
			light2.SpotOuterAngle = light2.sp2OuterAngle;
		}

		if(flashlightCharge <= 0)
		{
			Disable();
			flOutOfBatteryPenalty = true;
			
			owner.A_StartSound("PLSOFF", CHAN_AUTO);
			owner.A_StartSound("BEPBEP", CHAN_AUTO);
			owner.A_StartSound("weapons/plasma/fancybutton", CHAN_AUTO);
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
		{
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

// Handler
extend class PB_EventHandler
{
	PB_FPP_Holder setupFlashlightHolder(PlayerPawn p)
	{
		PB_FPP_Holder holder = PB_FPP_Holder(p.GiveInventoryType("PB_FPP_Holder"));
		holder.Init();
		return holder;
	}
}
