//===========================================================================
//
//
//
//===========================================================================

class PB_SawBlood : NashGoreBlood replaces AxeBlood
{
	Default
	{
		+NOGRAVITY
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
        TNT1 A 0 { chanceMod = 0;		return ResolveState("Spawn2"); }
		TNT1 A 0 { chanceMod = 100;		return ResolveState("Spawn2"); }
		TNT1 A 0 { chanceMod = 220;		return ResolveState("Spawn2"); }
		
	Spawn2:
		TNT1 A 0 {
			let[amt, cmul] = NashGoreStatics.GetAmountMult(nashgore_bloodmult, chanceMod);
			for (int i = 0; i < amt; i++)
			{
				A_SpawnItemEx("PB_BloodMist",
					0, 0, 4,
					frandom[rnd_SpawnBloodParticle2](-5.5, 5.5), frandom[rnd_SpawnBloodParticle2](-5.5, 5.5), frandom[rnd_SpawnBloodParticle2](0, 10),
					frandom[rnd_SpawnBloodParticle2](0, 360), BLOOD_FLAGS);
			}
		}
        Stop;
	}
}

class PB_GunshotBlood : NashGoreBlood replaces BloodSplatter
{
	Default
	{
		+NOGRAVITY
        +ADDLIGHTLEVEL;
    }

    bool sourceIsProjectile, smallCal, isBloodExplosionGenerator;
    int projectileDamage, targetRadius;
    float dmgScalar;
    double angToTarget;

	//===========================================================================
	//
	//
	//
	//===========================================================================

    static const Class<Actor> PuffImpactActors[] = {
        "PB_BloodCloud2",
        "PB_BloodCloud3",
        "PB_BloodCloud4"
    };

    action Actor PB_SpawnBloodActor(class<Actor> bloodActor, bool translate = false, double rotAngle = 0, vector3 squibVel = (0, 0, 0), bool scaleWithDmg = false, vector3 squibOfs = (0, 0, 0))
    {
		vector3 ofr = squibOfs;
        Actor mo = Spawn(bloodActor, Vec3Offset(ofr.x, ofr.y, ofr.z), ALLOW_REPLACE);

        if(!mo) return null;

        mo.angle = self.angle;
        mo.target = self.target;

        if(target && target == players[consoleplayer].camera) 
            mo.A_SetRenderStyle(mo.alpha, STYLE_None);

        mo.master = self;
        mo.vel = (RotateVector(squibVel.xy, rotAngle), squibVel.z);
        if(translate) mo.translation = self.translation;

        if(scaleWithDmg) 
        {
            if(invoker.dmgScalar < 1)
                mo.alpha *= invoker.dmgScalar;
            else
                mo.scale *= invoker.dmgScalar;
        }

        mo.LightLevel = self.LightLevel;
        mo.bADDLIGHTLEVEL = self.bADDLIGHTLEVEL;

        return mo;
    }

	States
	{
	Spawn:
        TNT1 A 0 NoDelay { chanceMod = 0;		return ResolveState("Spawn2"); }
		TNT1 A 0 { chanceMod = 100;		return ResolveState("Spawn2"); }
		TNT1 A 0 { chanceMod = 220;		return ResolveState("Spawn2"); }
	Spawn2:
        TNT1 A 0 { 
			if(target) {
				angToTarget = AngleTo(target); 
				targetRadius = target.Radius;
			}
		} // save this before everything for if the target gets destroyed
        TNT1 A 2;
		TNT1 A 0
		{
            double normalizedDAng, angleDelta;
            if(sourceIsProjectile)
            {
                normalizedDAng = Normalize180(angToTarget - players[consoleplayer].camera.angle);
				angleDelta = abs(Normalize180(angleTo(players[consoleplayer].camera)));
                LightLevel = 32;
            }
            else 
                normalizedDAng = angToTarget;

            A_Stop();
            
            //console.printf("ste: %p %s %i %i", self, self.GetClassName(), self.sourceIsProjectile, self.projectileDamage);

            PB_BloodSquib spawnedImpact;
            Actor spawnedImpact2;
            
            spawnedImpact = PB_BloodSquib(PB_SpawnBloodActor("PB_BloodSquib", true, angToTarget, (frandom(1, 2), frandom(-0.5, 0.5), 0), false, (RotateVector((targetRadius * 1.3, 0), angle), 0)));

            if(sourceIsProjectile)
            {
                if(abs(normalizedDAng) < 125) {
                    spawnedImpact.sideSquib = true;
                    if(spawnedImpact) spawnedImpact.bSPRITEFLIP = normalizedDAng < 0;
                }
                else
                    spawnedImpact.sideSquib = false;

                // dmgScalar = 0.5 + (0.5 * PB_Math.LinearMap( -(cos(180 * clamp(projectileDamage / 165.f, 0, 1)) - 1) / 2.f, 0.0, 1.0, 1, 2.0 ));
                dmgScalar = 0.5 + (0.5 * clamp(PB_Math.LinearMap(projectileDamage, 22, 165, 1.0, 2.0), 0.5, 2.0));

                A_StartSound("bulletfleshimpact");

                if(isBloodExplosionGenerator)
                {
                    PB_SpawnBloodActor("PB_BloodExplosion", false);
                    Destroy();
                    return;
                }

                if(!smallCal) PB_SpawnBloodActor("PB_BloodCloud", false, scaleWithDmg: true, squibOfs: (RotateVector((targetRadius * 0.6, 0), angle), 0));
                
                if(smallCal || random[rnd_SpawnBloodCloud](0, 256) >= chanceMod) {
                    spawnedImpact2 = PB_SpawnBloodActor(PuffImpactActors[random[rnd_SpawnBloodCloud](0, 2)], false, scaleWithDmg: true, (RotateVector((targetRadius, 0), angle), 0));
                    if(spawnedImpact && spawnedImpact2) spawnedImpact2.tracer = spawnedImpact;
                }
                if(!smallCal && random[rnd_SpawnBloodCloud](0, 256) >= chanceMod) PB_SpawnBloodActor(PuffImpactActors[random[rnd_SpawnBloodCloud](0, 2)], false, scaleWithDmg: true);                
            }

            let[amt, cmul] = NashGoreStatics.GetAmountMult(nashgore_bloodmult, chanceMod);
			for (int i = 0; i < amt * 2; i++)
			{
                PB_SpawnBloodActor("PB_BloodSquib", true, angToTarget - 180, (frandom(0.5, 3), frandom(-0.5, 0.5), frandom(0, 1)));
            }

            PB_SpawnBloodActor("PB_LocationalBloodSplat", true, angToTarget - 180, (frandom(0, 4), frandom(-2, 2), 0));
		}
        TNT1 A 17;
        TNT1 A 0 A_Jump(chanceMod, "Drips");
        /*TNT1 A 0 {
            let[amt, cmul] = NashGoreStatics.GetAmountMult(nashgore_bloodmult, chanceMod);
			for (int i = 0; i < amt; i++)
			{
				A_SpawnItemEx("PB_BloodSpot", frandom(-30, 30), frandom(-30, 30), flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, failchance: chanceMod);
			}
        }*/
        Stop;
    Drips:
        TNT1 AAAAA 3 {
            let[amt, cmul] = NashGoreStatics.GetAmountMult(nashgore_bloodmult, chanceMod);
			for (int i = 0; i < amt; i++)
			{
				A_SpawnItemEx("PB_BloodSpotTiny", frandom(-30, 30), frandom(-30, 30), flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, failchance: chanceMod);
			}
        }
		Stop;
	}
}

//===========================================================================
//
//
//
//===========================================================================

const PB_BLOODCLOUD_L = float(100.f / 255.f);

class PB_BloodCloud : PB_LightActor
{
	Default
	{
		+NOBLOCKMAP;
        +NOTELEPORT;
        +DONTSPLASH;
        +FORCEXYBILLBOARD;
        +NOINTERACTION;
        +THRUACTORS;
        +ROLLSPRITE;
        // +ROLLCENTER;
        +NOCLIP;
        +NOGRAVITY;
        +SQUAREPIXELS;
        -STRETCHPIXELS;

		Scale 0.16;
		Alpha 0.70;
		RenderStyle "Stencil";
        StencilColor "FF0000";
	}
	
	double dissipateRotation;
    Color bcbuffer;
    double desat;
	
	override void PostBeginPlay()
    {
        if(CVar.GetCVar("pb_hidebloodmist", players[consoleplayer]).GetBool())
            A_SetRenderStyle(alpha, STYLE_None);

		if(!target)
		{
            if(master)
                CopyBloodColor(master);
			else
                bcbuffer = 0xffff0000;
		}
		else
		    CopyBloodColor(target);

        if(bloodcolor == 0) bcbuffer = 0xffff0000;
        else bcbuffer = bloodcolor;
		
        //SetShade(PB_Math.PB_DesaturateColor(bcbuffer, 0.2, 1)); 
        //SetShade(PB_Math.PB_DesaturateColor(bcbuffer, 0.2, 1.2)); 

        SmokeBegin();
		
		dissipateRotation = frandom(0.7, 1.4) * randompick(-1, 1);
        bXFLIP = randompick(0, 1);
    }

    virtual void SmokeBegin()
    {
        bYFLIP = randompick(0, 1);
        roll = frandom(-20, 20);
        alpha *= frandom(0.7, 1.0);
        spriteOffset = (frandom(-10, 10), frandom(-2, 2));
        scale *= frandom(0.83, 1.0);
    }

    override void Tick()
    {
        Super.Tick();
        
        if(level.IsFrozen()) return;
        desat = 1.0 - (0.74 + clamp(GetAge() / 4.0, 0.0, 1.0) * 0.26);
		//double brighten = 1.0 - (0.75 + clamp(GetAge() / 20.0, 0.0, 1.0) * 0.25);

        SetShade(PB_Math.PB_MixWhiteWithColor(bcbuffer, desat, PB_BLOODCLOUD_L *min(1.0, 1 + (desat - 0.15))));
        BloodCloudTick();
    }

    virtual void BloodCloudTick()
    {
        //if(GetAge() < 8) 
        //{
		int age = GetAge();
		if(age < 4 && age > 1) 
		{
			scale.x *= 1.397;
			scale.y *= 1.287;
			A_Fadeout(0.15 * default.alpha, FTF_CLAMP|FTF_REMOVE);
		}
		else
		{
			vel.z -= 0.02;
			scale *= 1.01;
			//A_Fadeout(0.02 * default.alpha, FTF_CLAMP|FTF_REMOVE);
		}
            
            
            /*if(CeilingPic == SkyFlatNum) {
                vel.y += 0.01; // wind
                vel.z += 0.005;
                vel.x -= 0.005;
            }
            else if(GetAge() >= 3)
            {
                //scale.x += 0.002;
                vel.z -= 0.05;
                //scale.y += 0.004;
            }*/
        //}
        /*else
        {
            A_Fadeout(0.01 * default.alpha, FTF_CLAMP|FTF_REMOVE);
            //scale *= 1.01;
            
            if(CeilingPic == SkyFlatNum) {
                vel.y += 0.005; // wind
                vel.x -= 0.002;
            }
            else
            {
                //scale.x += 0.002;
                vel.z -= 0.1;
                //scale.y += 0.004;
            }
        }*/
    }

    States 
    {
        Spawn:
        BloodLoop:
            TNT1 A 0;
            TNT1 A 0 A_Jump(256, random(0, 4));
            XS11 ABCDFGHIJKLMNOPQRSTUVWXYZ 1;
            XS21 ABCDEF 1;
			//XS11 KLMNOPQRSTUVWXYZ 2;
            //XS21 ABCDEF 2;
            Stop;
    }
}

class PB_BloodCloud2 : PB_BloodCloud
{
	Default 
    {
        Scale 0.025;
        Alpha 0.67;
        -ROLLCENTER;
    }

    override void SmokeBegin() 
    {
        //alpha *= frandom(2.5, 4);
        scale *= frandom(1.2, 1.5) * 2;
    }

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        roll = frandom(-125, 125);
        
        if(tracer)
        {
            roll = tracer.roll;
            bSPRITEFLIP = tracer.bSPRITEFLIP;
            scale.x *= 0.75;
        }
    }

    override void BloodCloudTick()
    {
        if(GetAge() < 3) 
        {
            scale *= 1.8;
        }
        else
        {
            scale *= 1.02;
            //A_Fadeout(0.02, FTF_CLAMP|FTF_REMOVE);
        }
                                    
        //roll += dissipateRotation;
        //dissipateRotation *= 0.96;
        
        /*if(CeilingPic == SkyFlatNum) {
            vel.y += 0.005;
            vel.x -= 0.002;
        }
        else*/
        vel.z -= 0.016;
    }

    States 
    {
        Spawn:
        BloodLoop:
            XS16 ABCDEF 1;
            XS16 GHIJKLMNO 2;
            Stop;
    }
}

class PB_BloodCloud3 : PB_BloodCloud2
{
    Default 
    {
        Scale 0.032;
    }

    States 
    {
        Spawn:
        BloodLoop:
            XS19 ABCDEFG 1;
            XS19 HIJKLMNOP 2;
            Stop;
    }
}

class PB_BloodCloud4 : PB_BloodCloud3
{
    Default 
    {
        XScale 0.006;
        YScale 0.0075;
    }

    States 
    {
        Spawn:
        BloodLoop:
            XS15 ABCDEFG 1;
            Stop;
    }
}

class PB_GibBloodCloud : PB_BloodCloud2
{
	Default
	{
		Scale 0.15;
        Alpha 3.0;
	}

    override void PostBeginPlay()
    {
		if(!target)
		{
			self.Destroy();
			return;
		}
		
		CopyBloodColor(target);

        Color bcbuffer;
        if(bloodcolor == 0) bcbuffer = 0xff680000;
        else bcbuffer = bloodcolor;
		
        SetShade(PB_Math.PB_DesaturateColor(bcbuffer, 0.2, 1));
		
		dissipateRotation = frandom(1, 3) * randompick(-1, 1);
        bXFLIP = randompick(0, 1);
        bYFLIP = randompick(0, 1);
		scale *= frandom(1.0, 1.1);
		alpha *= frandom(1.0, 1.2);
    }

    States 
    {
        Spawn:
        BloodLoop:
            BLER A 1 NoDelay {
                if(GetAge() < 3) 
                    scale *= 1.7;
                else
                {
                    A_Fadeout(0.03, FTF_CLAMP|FTF_REMOVE);
                }
                                            
                roll += dissipateRotation;
                dissipateRotation *= 0.96;
                scale *= 1.005;
                
                if(CeilingPic == SkyFlatNum) {
                    vel.y += 0.01; // wind
                    vel.x -= 0.005;
                }
            }
            Loop;
    }
}

class PB_BloodExplosion : PB_BloodCloud3 
{
    Default
    {
        Scale 0.05;
        Alpha 2;
    }

    override void Tick() 
    {
        Super.Tick();
        desat = 1.0 - (0.5 + clamp(GetAge() / 6.0, 0.0, 1.0) * 0.5);
        SetShade(PB_Math.PB_MixWhiteWithColor(bcbuffer, desat, PB_BLOODCLOUD_L));
    }
	
	States 
    {
        Spawn:
        BloodLoop:
            XS19 ABCDEFG 1;
            XS19 HIJKLMNOP 2;
            Stop;
    }
}

//===========================================================================
//
//
//
//===========================================================================

class PB_BloodSquib : PB_LightActor
{
    Default 
    {
        +ROLLSPRITE;
        -ROLLCENTER;
        +SQUAREPIXELS;

        // [gng] this is to ensure this actor will not affect the global seed
        // so it will not cause desyncs if spawned clientside
        -RANDOMIZE;
        FloatBobPhase 0;

        +FORCEXYBILLBOARD;
        +INTERPOLATEANGLES;
        Scale 0.4;
    }

    color bcbuffer;
    bool sideSquib;

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();
        roll = (90 + cfrandom(-60, 30)) * (bSPRITEFLIP ? -1 : 1);
        ClearInterpolation();
    }

    States {
        Spawn:
            TNT1 A 0;
            NGB3 A 0 {
                sprite = GetSpriteIndex(String.Format("NGB%i", sideSquib ? crandompick(3, 4) : crandompick(1, 2)));
            }
        BloodLoop:
            "####" ABC 1 {
                scale += (0.1, 0.1);
            }
            "####" DEFGH 1 {
                vel.z -= 0.2;
            }
            "####" IJKLM 1 {
                vel.z -= 0.2;
            }
            "####" M 1 {
                vel.z -= 0.2;
                A_FadeOut(0.125);
            }
            Wait;

        CacheSprites:
            NGB1 ABCDEFGHIJKMNOP 0;
            NGB2 ABCDEFGHIJKMNOP 0;
            NGB3 ABCDEFGHIJKMNOP 0;
            NGB4 ABCDEFGHIJKMNOP 0;
    }
}

class PB_LocationalBloodSplat : NashGoreBloodBase
{
    Default
    {
        +ROLLSPRITE;
        +FORCEXYBILLBOARD;
        +SQUAREPIXELS;
        Scale 0.2;
        Gravity 0.2;
        Alpha 0.2;
        RenderStyle "Translucent";

		+NOCLIP
		+CORPSE
		Speed 7;
		Radius 8;
		Height 1;
		+MISSILE;
		-NOGRAVITY;
		Decal "BloodSplat";
    }

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();
        roll = frandom(0, 360);
    }

    override void Tick()
    {
        Super.Tick();

        if(level.IsFrozen())
            return;

        if(GetAge() < 6)
        scale += (0.05, 0.05);
    }

    States {
        Spawn:
            XS55 DCBA 1 NoDelay {
                alpha += 0.2;
            }
            XS55 ABCD 2;
            XS55 EFG 1;
            XS55 G 1;
            Wait;
        Crash:
            TNT1 A 1 {
                A_StartSound("blooddrop2");
                A_SpawnItemEx("PB_BloodSpot", flags: (BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION);
            }
            Stop;
    }
}
