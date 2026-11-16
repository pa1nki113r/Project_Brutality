Class PB_BaseBulletImpact : BulletPuff abstract
{
	Default
	{
		+NOEXTREMEDEATH;
		+THRUACTORS;
		+NOCLIP;
		Decal "ConcreteWithGlow";
		+DONTSPLASH;
		//+NOTIMEFREEZE;
		-EXPLODEONWATER;
		Scale 1.0;
        Alpha 1.0;
		Renderstyle "Translucent";
		PB_BaseBulletImpact.NoDistantImpact false;
		+NOGRAVITY;
		+NOINTERACTION;
		+NOBLOCKMAP;
		//+NOSECTOR;
		+ROLLSPRITE;
		+FORCEDECAL;
		-NODECAL;
		+ALLOWTHRUFLAGS;
		+ALLOWPARTICLES;
		+PUFFONACTORS;
		-RANDOMIZE;
	}

    color matTintColor;

	uint8 hitWhat;
	float wallNormal, reflectAngle;
	// This is deliberately local-view state. Anything conditionally executed from
	// it must use cosmetic RNG (cRNG) and may only create particles/VisualThinkers.
	transient float distfromplayer;
    vector2 hitAngles;

	bool noDistant, smallCal;
	property NoDistantImpact: noDistant;

	const DISTANT_THRESHOLD = 1024 ** 2;

    transient SecPlane refPlane;

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		// ricochet detection formula: AbsAngle(angle, wallnormal)

		distfromplayer = Distance2DSquared(players[consoleplayer].camera);
		
		reflectAngle = (wallNormal * 2) - angle;

		if(!noDistant)
			HitFeedback();

        hitangles = (angle, pitch);

        if(hitWhat > 1)
        {
            vector3 pNorm;
            if(hitWhat == 2)
                pNorm = floorSector.floorplane.normal;
            else
                pNorm = ceilingSector.ceilingplane.normal;
                
            pitch = asin(-pNorm.Z);
            angle = atan2(pNorm.y, pNorm.x);
		}
        else
        {
            angle = wallNormal;
        }
	}
	
	void HitFeedback()
	{
		FSpawnParticleParams MAINPUF;
		string f = String.Format("%c", int("A") + crandom(0,7));
		MAINPUF.Texture = TexMan.CheckForTexture("IPF2"..f..0);
		MAINPUF.Style = STYLE_ADD;
		MAINPUF.Color1 = "FFFFFF";
		MAINPUF.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		MAINPUF.StartRoll = crandom(0,360);
		MAINPUF.StartAlpha = 1.0;
		MAINPUF.FadeStep = 0;
		MAINPUF.Size = crandom(10,32) * (Distance3D(players[consoleplayer].camera) / 500.f);
		MAINPUF.SizeStep = crandom(2,4);
		MAINPUF.Lifetime = 4; 
		MAINPUF.Pos = pos;
		Level.SpawnParticle(MAINPUF);
	}

    VisualThinker PB_SummonSmokeThinker(class<PB_AnimatedSmokeThinker> smk, double smkRoll = 0, double smkAlpha = 1.0, vector2 smkScale = (1, 1), vector3 smkVel = (0, 0, 0))
    {
        // the PB_AnimatedSmokeThinker in question:
        PB_AnimatedSmokeThinker vt = PB_AnimatedSmokeThinker(level.SpawnVisualThinker(smk));

        if(vt)
        {
            vt.roll = smkRoll;
            vt.pos = pos + (RotateVector((1, 0), angle), 0);
            vt.alpha = smkAlpha;
            // 97 is the character index for UPPERCASE A
            /*vt.startFrame = startFrame - 97;
            vt.endFrame = endFrame - 97;
            vt.frameStep = frameStep;
            vt.sprName = sprName;*/
            vt.vel = smkVel;
        }

        return vt;
    }
}

class PB_WallDebris : PB_AnimatedSmokeThinker
{
	override void PB_SetupSprites() 
    {
        SetRenderStyle(STYLE_Shaded);
        scale *= 0.25;
        alpha = cfrandom(0.5, 0.75);
        roll = cfrandom(0, 359);
        rollVel = cfrandom(-3, 3);
        
        sprName.Push("XS12");
        frameStep.Push(2);
        startFrame.Push(crandom(0, 12));
        endFrame.Push(25);

        sprName.Push("XS22");
        frameStep.Push(2);
        startFrame.Push(0);
        endFrame.Push(25);

        sprName.Push("XS32");
        frameStep.Push(2);
        startFrame.Push(0);
        endFrame.Push(11);
    }

    override void PB_AnimateSelf()
    {
        vel.xy *= 0.95;
        vel.z -= 0.1;
        alpha *= 0.94;
        roll += rollVel;
        scale *= 1.02;
    }
}

Class PB_BulletImpact : PB_BaseBulletImpact
{
	color color1, color2, color3;
	// puff, debris and big smoke
	property PuffColors: color1, color2, color3;
	
	Default
	{
		PB_BulletImpact.PuffColors "E3E3E3", "FFFFFF", "C9C9C9";
		+FLATSPRITE;
        +SQUAREPIXELS;
		Scale 0.6;
		Alpha 0.6;
		RenderStyle "Shaded";
	}

    override void PostBeginPlay() {
        Super.PostBeginPlay();
        color1 = PB_Math.PB_MultiplyColors(color1, matTintColor);
        color2 = PB_Math.PB_MultiplyColors(color2, matTintColor);
        color3 = PB_Math.PB_MultiplyColors(color3, matTintColor);
    }
	
	states
	{
		Spawn:
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact", pitch: cfrandom(0.9, 1.1));

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    let smk = PB_SummonSmokeThinker("PB_WallDebris", smkVel: PB_Math.VecFromAngles(angle, pitch, cfrandom(2, 4)));
                    if(smk) smk.scolor = color1;

                    if(!smallCal)
                    {
						SpawnMainPuff2();
						// SpawnPuffSmoke();
                        int spallCount = crandompick(0, 0, 0, crandom(0, 4));

                        for(int i = 0; i < spallCount; i++)
                    	    BulletSpall(hitWhat);
                    }

                    SpawnDust();

                    if(crandompick(0, 0, 1))
					{
                    	A_StartSound("ricochet/hit");
					}
					SpawnMainPuff3();
					SpawnMainPuff3();

					/*int cloudCount = crandompick(0, 0, 0, 0, 0, 0, 1, 2, 3);
					for(int i = 0; i < cloudCount; i++)
						SpawnMainPuffSecondary();*/
                }
				SpawnMainPuff();
                SpawnPuffSmoke();
				
				if(smallCal) 
					scale *= 0.5;
				
				SetShade(color3);
				A_Stop();
				if(hitWhat == 1)
					angle = wallNormal;

				Pitch += 90;
				
				roll = crandom(0, 360);
			}
        FlatPuff:
            TNT1 A 0 A_Jump(256, random(0, 5));
			XS19 ABCDEFGHIJKLMNOP 1 {
                if(GetAge() > 5)
                    A_FadeOut(0.1);
            }
        	Stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, crandom (0, 360), 2, crandom (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");
		PUFSPRK.Color1 = color1;
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL | SPF_REPLACE;
		vector3 vls = (0.7, cfrandom(-0.5,0.5), cfrandom(-0.5,0.5));
		if(hitWhat == 1)
		{
			vls = (RotateVector((vls.x, vls.y), wallNormal), vls.z);
		}
		else
		{
			vls = (vls.z, vls.y, vls.x);
		}
		PUFSPRK.Vel = (0, 0, 0);
		PUFSPRK.Startroll = crandom(0, 359);
		PUFSPRK.RollVel = cfrandom(-3, 3);
		PUFSPRK.StartAlpha = smallCal ? 0.6 : 0.4;
		PUFSPRK.Size = crandom(25, 35);
		PUFSPRK.SizeStep = smallCal ? 2 : 1;
		PUFSPRK.Lifetime = crandom(35,105);
		PUFSPRK.RollAcc = -PUFSPRK.RollVel / double(PUFSPRK.Lifetime);
		PUFSPRK.accel = (-vls / double(PUFSPRK.Lifetime)) + (0, 0, smallCal ? cfrandom(0, -0.05) : cfrandom(-0.05, -0.1));
			
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Pos = pos + vls * (PUFSPRK.Size * 0.3);
		Level.SpawnParticle(PUFSPRK);
	}

	void SpawnMainPuff3()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("XS13"..String.Format("%c", 97 + crandom(0, 25)).."0");
		PUFSPRK.Color1 = color3;
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL | SPF_REPLACE;
		PUFSPRK.Size = smallCal ? crandom(15,30) : crandom(40, 50);
		vector3 vls = (cfrandom(1, PUFSPRK.Size * 0.2), cfrandom(-24,24), cfrandom(-24,24));
		if(hitWhat == 1)
		{
			vls = (RotateVector((vls.x, vls.y), wallNormal), vls.z);
		}
		else
		{
			vls = (vls.z, vls.y, vls.x);
		}
		PUFSPRK.Vel = (0, cfrandom(-1, 1), 0);
		PUFSPRK.Startroll = crandom(0, 359);
		PUFSPRK.RollVel = cfrandom(-3, 3);
		PUFSPRK.StartAlpha = smallCal ? 0.25 : 0.4;
		PUFSPRK.SizeStep = smallCal ? 2 : 1;
		PUFSPRK.Lifetime = crandom(15,55);
		PUFSPRK.RollAcc = -PUFSPRK.RollVel / double(PUFSPRK.Lifetime);
		PUFSPRK.accel = (0, 0, cfrandom(0, -0.2));
			
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Pos = pos + vls;
		Level.SpawnParticle(PUFSPRK);
	}

	void SpawnMainPuff2()
	{
		FSpawnParticleParams PUFSPRK;
		double angOfs = cfrandom(0, 359);
		for(int i = 0; i < 3; i++)
		{
			PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");
			PUFSPRK.Color1 = color2;
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL | SPF_REPLACE;
			PUFSPRK.Size = 16;
			vector3 vls = (PUFSPRK.Size * 0.3, RotateVector((8, 8), angOfs + 120 * (1 + i)));
			if(hitWhat == 1)
			{
				vls = (RotateVector((vls.x, vls.y), wallNormal), vls.z);
			}
			else
			{
				vls = (vls.z, vls.y, vls.x);
			}
			PUFSPRK.Vel = (0, 0, 0);
			PUFSPRK.Startroll = crandom(0, 359);
			PUFSPRK.StartAlpha = default.Alpha;
			PUFSPRK.SizeStep = 2;
			PUFSPRK.Lifetime = crandom(15,70);
			PUFSPRK.accel = (0, 0,-0.05);
				
			PUFSPRK.FadeStep = -1;
			PUFSPRK.Pos = pos + vls;
			Level.SpawnParticle(PUFSPRK);
		}
	}
	
	void SpawnMainPuffSecondary()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");
		PUFSPRK.Color1 = crandompick(0, 1) ? color3 : color2;
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL | SPF_REPLACE;
		
		PUFSPRK.Startroll = crandom(0, 359);
		PUFSPRK.RollVel = cfrandom(-2, 2);
		PUFSPRK.StartAlpha = cfrandom(0.2, 0.45);
		PUFSPRK.Size = crandom(26, 100);
		PUFSPRK.SizeStep = 2;
		PUFSPRK.Lifetime = crandom(250, 450);
		PUFSPRK.RollAcc = -PUFSPRK.RollVel / double(PUFSPRK.Lifetime);

		vector3 vls = (PUFSPRK.Size * 0.35, cfrandom(-30, 30), cfrandom(-30, 30));

		if(hitWhat == 1)
		{
			vls = (RotateVector((vls.x, vls.y), wallNormal), vls.z);
		}
		else
		{
			vls = (vls.z, vls.y, vls.x);
		}
		
		if(hitWhat == 3)
			vls.z *= -1;
		
		PUFSPRK.Vel = vls.Unit() * 0.2;
		
		PUFSPRK.accel = (-PUFSPRK.Vel / double(PUFSPRK.Lifetime)) + (0, 0, -0.01);
		//if(CeilingPic == SkyFlatNum)
		//	PUFSPRK.accel += (-0.01, 0.02, 0.01);
			
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Pos = pos + vls;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnDust()
	{
		int sparkcount = crandom(6,20);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + crandom(0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("DUST"..f..0);
			PUFSPRK.Color1 = color2;
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
				vls = (RotateVector(((cfrandom(1, 6)), cfrandom(-5,5)), wallNormal), cfrandom(-5,5));
			else
				vls = (crandom(-5,5),crandom(-5,5),crandom(-1,9));

			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,cfrandom(-1.75,-0.75));
			PUFSPRK.Startroll = crandompick(0,90,180,270,360);
			PUFSPRK.RollVel = 0;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = crandom(4,6);
			PUFSPRK.SizeStep = 0;
			PUFSPRK.Lifetime = crandom(12,18);
			if(hitWhat == 1)
				PUFSPRK.Pos = pos + (RotateVector((cfrandom(0, 6), cfrandom(-5,5)), wallNormal), cfrandom(-5,5));
			else
				PUFSPRK.Pos = pos + (cfrandom(-5,5), cfrandom(-5,5), cfrandom(0,6));
				
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke()
	{
		double mag = !smallCal ? cfrandom(3, 4) : 2;
		vector2 vvels = (cfrandom(-1, 1), cfrandom(-1, 1));
		int count = !smallCal ? 4 : 2;

		for(int i = 0; i < count; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = color2;
			vector3 vls, accl, posOfs;
			vls = (mag * (i * 0.5), vvels);
			
			int ofsimpact = !smallCal ? 10 : 2;
			PUFSMK.Size = 20 * (1+((count - i) * 0.3));
			if(hitWhat == 1)
			{
				vls = (RotateVector(vls.xy, wallNormal), vls.z);
			
				accl = -(vls.xy * 0.07, 0.1);
				posofs = (RotateVector((ofsimpact+(pufsmk.size * (i / float(count))), vvels.x * (i / 3.0)), wallNormal), vvels.y * (i / 3.0));
			} 
			else if(hitWhat > 1)
			{
                vls = (vls.y, vls.z, vls.x);
                
                accl = -(0, 0, (0.3 * i));
                posOfs = (vvels * (i * 0.3), ofsimpact+(i*2));

				if(hitWhat == 3)
                {
					vls.z *= -1;
					posOfs.z *= -1;
                    accl.z *= -1;
                }
			}
			else
			{
				vls = (cfrandom(-1,1), cfrandom(-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls * (i / double(count));
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (-0.05, 0.1, 0.05);
				
			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = crandom(0,360);
			PUFSMK.RollVel = crandom(-4,4);
			PUFSMK.StartAlpha = default.Alpha;
			PUFSMK.FadeStep = -1;
			PUFSMK.SizeStep = crandom(1,5);
			PUFSMK.Lifetime = 13; 
			PUFSMK.Pos = pos + posOfs;
			Level.SpawnParticle(PUFSMK);
		}
	}

	void BulletSpall(int dq = 1)
	{
		FLineTraceData lt;
		vector2 ofs = RotateVector((5, 0), wallNormal);
		
		if(dq == 1)
			LineTrace(wallNormal + 90, 60, crandom(0, 360), TRF_ABSOFFSET, offsetforward: ofs.x, ofs.y, lt);
		else if(dq == 2)
			LineTrace(crandom(0, 360), 60, -3, TRF_ABSOFFSET, offsetforward: ofs.x, ofs.y, lt);
		else if(dq == 2)
			LineTrace(crandom(0, 360), 60, 3, TRF_ABSOFFSET, offsetforward: ofs.x, ofs.y, lt);

		if(lt.HitType == TRACE_HitNone)
			return;
		
		FSpawnParticleParams PUFSMK;
		PUFSMK.Texture = TexMan.CheckForTexture(String.Format("X103%c0", 97 + crandom(0, 25)));//("SMK2A0"); //SMk3G0
		PUFSMK.Style = STYLE_TRANSLUCENT;
		PUFSMK.Color1 = color1;
		PUFSMK.Flags = SPF_ROLL;
		PUFSMK.Vel = (0, 0, cfrandom(-1, 1));
		PUFSMK.accel = (0, 0, -0.1);
		if(CeilingPic == SkyFlatNum)
			PUFSMK.accel += (-0.05, 0.1, 0.05);
		PUFSMK.Startroll = crandom(0, 359);
		PUFSMK.RollVel = cfrandom(1, 2);
		PUFSMK.StartAlpha = cfrandom(0.4, 0.6);
		PUFSMK.FadeStep = -1;
		PUFSMK.Size = crandom(20,50);
		PUFSMK.SizeStep = 4;
		PUFSMK.Lifetime = crandom(2,5) * 35;
		PUFSMK.Pos = lt.HitLocation;
		Level.SpawnParticle(PUFSMK);
	}
}

Class PB_BulletImpactWood : PB_BaseBulletImpact
{
	Default
	{
		Decal "WoodBullethole";
	}
	
	states
	{
		Spawn:
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact/wood", pitch: cfrandom(0.9, 1.1));
                if(crandom(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnSplinters();
                    SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
            //TNT1 A 2 Light("BulletPuffLight");
            Stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, crandom (0, 360), 2, crandom (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");
		PUFSPRK.Color1 = "40291a";
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL;
		vector3 vls;
		if(hitWhat == 1)
		{
			vls = (RotateVector((1, 0), wallNormal), 0);
		}
		else
		{
			vls = (0,0,0.5);
		}
		PUFSPRK.Vel = vls;
		PUFSPRK.accel = (0,0,cfrandom(-0.1, 0.1));
		if(CeilingPic == SkyFlatNum)
			PUFSPRK.accel += (-0.05, 0.1, 0.05);

		PUFSPRK.Startroll = crandom(0, 359);
		PUFSPRK.RollVel = cfrandom(1, 2);
		PUFSPRK.StartAlpha = 0.7;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = crandom(40,45);
		PUFSPRK.SizeStep = 0.5;
		PUFSPRK.Lifetime = crandom(24,35);
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnSplinters()
	{
		int sparkcount = crandom(8,10);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + crandom(0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("WOOD"..f..0);
			PUFSPRK.Color1 = "FFFFFF";
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((cfrandom(1, 3) * (i * 0.5)), cfrandom(-2,2)), wallNormal), cfrandom(-2,2));
			}
			else
			{
				vls = (crandom(-5,5),crandom(-5,5),crandom(-2,9));
			}
			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,-0.5);
			PUFSPRK.Startroll = crandom(0, 359);
			PUFSPRK.RollVel = 2;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = crandom(4,6);
			PUFSPRK.SizeStep = 0;
			PUFSPRK.Lifetime = crandom(12,18);
			PUFSPRK.Pos = pos;
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 3; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = "40291a";
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((cfrandom(0, 6) * (i * 0.5)), cfrandom(-1,1)), wallNormal), cfrandom(-3,2));
				accl = -(vls.xy * 0.07, (0.1 * i));
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (cfrandom(-2,2), cfrandom(-2,2));
				vls.z = 4 * (i * 0.5);
                accl = -(0, 0, (0.3 * i));

				if(hitWhat == 3)
                {
					vls.z *= -1;
                    accl.z *= -1;
                }
			}
			else
			{
				vls = (cfrandom(-1,1), cfrandom(-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (-0.05, 0.1, 0.05);

			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = crandom(0,360);
			PUFSMK.RollVel = crandom(-4,4);
			PUFSMK.StartAlpha = 1.0;
			PUFSMK.FadeStep = 0.1;
			PUFSMK.Size = crandom(28,32);
			PUFSMK.SizeStep = crandom(1,3);
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((5, 0), wallNormal);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}
}

Class PB_BulletImpactMetal : PB_BaseBulletImpact
{
	Default {
		Decal "MetalWithGlow";
		PB_BaseBulletImpact.NoDistantImpact true;
	}
	states
	{
		Spawn:
			TNT1 A 0 NoDelay {
				Angle = wallNormal;
				
				for(int i = 0; i < 4; i++)
					A_SpawnProjectile("SparkX", 0, 0, random[impacts] (-25, 25), CMF_AIMDIRECTION  , pitch+random[impacts] (-25, 25));
					
				A_SpawnProjectile("HitSpark", 0, 0, random[impacts] (-25, 25), CMF_AIMDIRECTION  , pitch+random[impacts] (-25, 25));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom[impacts] (-45, 45), CMF_AIMDIRECTION  , pitch+frandom[impacts](-45, 45));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom[impacts] (-180, 180), CMF_AIMDIRECTION  , pitch+frandom[impacts](-180, 180));
			}
		Puff:
			TNT1 A 0 {
                A_StartSound("bulletimpact/metal/a", pitch: cfrandom(0.9, 1.1));
                if(crandom(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnPuffSpark();
                    SpawnPuffShrapnel();
					
					//for(int i = 0; i < 3; i++)
						SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
			TNT1 A 2 Light("BulletPuffLight");
			stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, crandom (0, 360), 2, crandom (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams MAINPUF;
		string f = String.Format("%c", int("A") + crandom(0,7));
		MAINPUF.Texture = TexMan.CheckForTexture("IPF2"..f..0);
		MAINPUF.Style = STYLE_ADD;
		MAINPUF.Color1 = "FFFFFF";
		MAINPUF.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		MAINPUF.StartRoll = crandom(0,360);
		MAINPUF.StartAlpha = 1.0;
		MAINPUF.FadeStep = 0;
		MAINPUF.Size = crandom(25,28);
		MAINPUF.SizeStep = crandom(2,4);
		MAINPUF.Lifetime = 4; 
		MAINPUF.Pos = pos;
		Level.SpawnParticle(MAINPUF);
	}

    void SpawnPuffSpark()
	{
        int sparkcount = crandom(3,5);
        for(int i = 0; i < sparkcount; i++)
        {
            FSpawnParticleParams PUFSPRK;
            PUFSPRK.Texture = TexMan.CheckForTexture("SPKOA0");
            PUFSPRK.Color1 = "FFFFFF";
            PUFSPRK.Style = STYLE_Add;
            PUFSPRK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
            vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((cfrandom(2, 7) * (i * 0.5)), cfrandom(-6,6)), wallNormal), cfrandom(-2,2));
			}
			else
			{
				vls = (crandom(-5,5),crandom(-5,5),crandom(-2,9));
			}
            PUFSPRK.Vel = vls;
            PUFSPRK.accel = (-(vls.xy * 0.075),-0.2) + (cfrandom(-0.25, 0.25), cfrandom(-0.25,0.25), cfrandom(-0.2,0.1));
            PUFSPRK.Startroll = crandom(0,359);
            PUFSPRK.RollVel = 0;
            PUFSPRK.StartAlpha = 1.0;
            PUFSPRK.FadeStep = 0.075;
            PUFSPRK.Size = crandom(6,8);
            PUFSPRK.SizeStep = -0.5;
            PUFSPRK.Lifetime = crandom(12,18);
            PUFSPRK.Pos = pos;
            Level.SpawnParticle(PUFSPRK);
        }
	}

    void SpawnPuffShrapnel()
	{
        if(crandompick(0, 0, 0, 0, 1))
            return;

        FSpawnParticleParams PUFSHRP;
        string f = String.Format("%c", int("A") + crandom(0,7));
        PUFSHRP.Texture = TexMan.CheckForTexture("JNK3"..f..0);
        PUFSHRP.Color1 = "FFFFFF";
        PUFSHRP.Style = STYLE_TRANSLUCENT;
        PUFSHRP.Flags = SPF_ROLL;
        vector3 vls;
        if(hitWhat == 1)
        {
            vls = (RotateVector(((cfrandom(5, 7)), cfrandom(-4,4)), wallNormal), cfrandom(-4,4));
        }
        else
        {
            vls = (crandom(-5,5),crandom(-5,5),crandom(-2,9));
        }
        PUFSHRP.Vel = vls;
        PUFSHRP.accel = (-(vls.xy * 0.05),-1);
        PUFSHRP.Startroll = crandom(0, 359);
        PUFSHRP.RollVel = 1.5;
        PUFSHRP.StartAlpha = 1.0;
        PUFSHRP.FadeStep = -1;
        PUFSHRP.Size = crandom(4,8);
        PUFSHRP.SizeStep = 0;
        PUFSHRP.Lifetime = 24; 
        PUFSHRP.Pos = pos;
        Level.SpawnParticle(PUFSHRP);
	}
	
	void SpawnPuffSmoke()
	{
		double mag = cfrandom(4, 5);
		vector2 vvels = (cfrandom(-1, 1), cfrandom(-1, 1));
		int count = !smallCal ? 4 : 2;

		for(int i = 0; i < count; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = "6e6e6e";
			vector3 vls, accl, posOfs;
			vls = (mag * (i * 0.5), vvels);
			
			int ofsimpact = !smallCal ? 10 : 2;
			if(hitWhat == 1)
			{
				vls = (RotateVector(vls.xy, wallNormal), vls.z);
			
				accl = -(vls.xy * 0.07, 0.1);
				posofs = (RotateVector((ofsimpact+(i*2), vvels.x * (i / 3.0)), wallNormal), vvels.y * (i / 3.0));
			} 
			else if(hitWhat > 1)
			{
				vls = (vls.y, vls.z, vls.x);
				
				accl = -(0, 0, (0.3 * i));
				posOfs = (vvels * (i * 0.3), ofsimpact+(i*2));

				if(hitWhat == 3)
				{
					vls.z *= -1;
					posOfs.z *= -1;
					accl.z *= -1;
				}
			}
			else
			{
				vls = (cfrandom(-1,1), cfrandom(-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls * (i / double(count));
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (-0.05, 0.1, 0.05);
				
			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = crandom(0,360);
			PUFSMK.RollVel = crandom(-4,4);
			PUFSMK.StartAlpha = 0.6;
			PUFSMK.FadeStep = -1;
			PUFSMK.Size = 12 * ((1 + i * 0.3) * 2);
			PUFSMK.SizeStep = crandom(1,3);
			PUFSMK.Lifetime = 13; 
			PUFSMK.Pos = pos + posOfs;
			Level.SpawnParticle(PUFSMK);
		}
	}
}

Class PB_BulletImpactSheetMetal : PB_BulletImpactMetal
{
	states
	{
        // for barrel blood
        Spawn:
		Puff:
			TNT1 A 0 NoDelay {
                A_StartSound("bulletimpact/metal/b", pitch: cfrandom(0.9, 1.1));
                if(crandom(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnPuffSpark();
                    SpawnPuffShrapnel();
					
                    //for(int i = 0; i < 3; i++)
						SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
			TNT1 A 2 Light("BulletPuffLight");
			stop;
	}
}

Class PB_BulletImpactDirt : PB_BaseBulletImpact
{
	Default
	{
		Renderstyle "Shaded";
		StencilColor "865627";
		Alpha 1.0;
	}
	
	states
	{
		Spawn:
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact/wood", pitch: cfrandom(0.9, 1.1));
                if(crandom(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnSplinters();
                    SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
            //DCHR ABCDEFGHIJKMNOP 1;
            Stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, crandom (0, 360), 2, crandom (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("DIRPC0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL;
		vector3 vls;
		if(hitWhat == 1)
		{
			vls = (RotateVector((4, 0), wallNormal), 0);
		}
		else
		{
			vls = (0,0,2);
		}
		PUFSPRK.Vel = vls;
		PUFSPRK.accel = (0,0,cfrandom(-0.1, 0.1));
		if(CeilingPic == SkyFlatNum)
			PUFSPRK.accel += (-0.05, 0.1, 0.05);

		PUFSPRK.Startroll = crandom(0, 359);
		PUFSPRK.RollVel = 5;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = crandom(30,75);
		PUFSPRK.SizeStep = 6;
		PUFSPRK.Lifetime = crandom(4,7);
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnSplinters()
	{
		int sparkcount = crandom(8,10);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + crandom(0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("DUST"..f..0);
			PUFSPRK.Color1 = "865627";
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((cfrandom(1, 3) * (i * 0.5)), cfrandom(-2,2)), wallNormal), cfrandom(-2,2));
			}
			else
			{
				vls = (crandom(-5,5),crandom(-5,5),crandom(-2,9));
			}
			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,-2);
			PUFSPRK.Startroll = crandom(0, 359);
			PUFSPRK.RollVel = 2;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = crandom(4,6);
			PUFSPRK.SizeStep = 0;
			PUFSPRK.Lifetime = crandom(12,18);
			PUFSPRK.Pos = pos;
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 3; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = "865627";
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((cfrandom(5, 7) * (i * 0.5)), cfrandom(-1,1)), wallNormal), cfrandom(-3,2));
				accl = -(vls.xy * 0.07, 0);
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (cfrandom(-2,2), cfrandom(-2,2));
				vls.z = 7 * (i * 0.5);
                accl = -(0, 0, (0.3 * i));

				if(hitWhat == 3)
                {
					vls.z *= -1;
                    accl.z *= -1;
                }
			}
			else
			{
				vls = (cfrandom(-1,1), cfrandom(-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (-0.05, 0.1, 0.05);
			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = crandom(0,360);
			PUFSMK.RollVel = crandom(-4,4);
			PUFSMK.StartAlpha = 1.0;
			PUFSMK.FadeStep = -1;
			PUFSMK.Size = crandom(28,32);
			PUFSMK.SizeStep = 3;
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((5, 0), angle);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}
}

Class PB_BulletImpactBrownRock : PB_BulletImpact
{
	Default
	{
		PB_BulletImpact.PuffColors "533f2f", "6b4727", "7b634f";
	}
}

Class PB_BulletImpactWater : PB_BaseBulletImpact
{
    Default
    {
        PB_BaseBulletImpact.NoDistantImpact true;
    }

    states
	{
		Spawn:
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact/water", pitch: cfrandom(0.9, 1.1));
                if(crandom(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnDust();
                    SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
            Stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, crandom (0, 360), 2, crandom (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");
		PUFSPRK.Color1 = matTintColor;
		PUFSPRK.Style = STYLE_ADD;
		PUFSPRK.Flags = SPF_ROLL;
		vector3 vls;
		if(hitWhat == 1)
		{
			vls = (RotateVector((2, 0), wallNormal), 0);
		}
		else
		{
			vls = (0,0,4);
		}
		PUFSPRK.Vel = vls;
		PUFSPRK.accel = (0,0,cfrandom(-0.1, 0.1));
		PUFSPRK.Startroll = crandom(0, 359);
		PUFSPRK.RollVel = cfrandom(1, 2);
		PUFSPRK.StartAlpha = 0.7;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = crandom(10,30);
		PUFSPRK.SizeStep = 6;
		PUFSPRK.Lifetime = crandom(6,8);
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnDust()
	{
		int sparkcount = crandom(7,9);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + crandom(0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("LIQU"..f..0);
			PUFSPRK.Color1 = matTintColor;
			PUFSPRK.Style = STYLE_ADD;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((cfrandom(3, 4) * (i * 0.5)), cfrandom(-5,5)), wallNormal), cfrandom(-2,3));
			}
			else
			{
				vls = (crandom(-5,5),crandom(-5,5),crandom(2,9));
			}
			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,cfrandom(-1.75,-0.75));
			PUFSPRK.Startroll = crandompick(0,90,180,270,360);
			PUFSPRK.RollVel = 0;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = crandom(4,6);
			PUFSPRK.SizeStep = 3;
			PUFSPRK.Lifetime = crandom(12,18);
			PUFSPRK.Pos = pos + (RotateVector((cfrandom(-5, 5), cfrandom(-5, 5)), wallNormal), cfrandom(-3,3));
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 4; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_ADD;
			PUFSMK.Color1 = matTintColor;
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector((0, cfrandom(-5,5)), wallNormal), cfrandom(-5,5));
				accl = -(vls.xy * 0.07, (0.1 * i));
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (cfrandom(-2,2), cfrandom(-2,2));
				vls.z = 4 * (i * 0.5);
                accl = -(0, 0, (0.3 * i));

				if(hitWhat == 3)
                {
					vls.z *= -1;
                    accl.z *= -1;
                }
			}
			else
			{
				vls = (cfrandom(-5,5), cfrandom(-5,5), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = crandom(0,360);
			PUFSMK.RollVel = crandom(-4,4);
			PUFSMK.StartAlpha = 0.8;
			PUFSMK.FadeStep = -1;
			PUFSMK.Size = crandom(28,32);
			PUFSMK.SizeStep = 5;
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((cfrandom(-10, 10), cfrandom(-10, 10)), angle);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}
}

Class PB_NoBloodPuff : PB_BaseBulletImpact
{
	states
	{
		Spawn:
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact", pitch: cfrandom(0.9, 1.1));

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                	SpawnMainPuff();
                    SpawnMainPuff();
            	}
            	
				SpawnMainPuff();
			}
        	Stop;
		Melee:
			TNT1 A 0;
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + crandom(0, 25)).."0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL | SPF_REPLACE;
		vector3 vls = (cfrandom(-1.0, 1.0), cfrandom(-1.0, 1.0), cfrandom(-1.0, 1.0));
		PUFSPRK.Vel = vls;
		PUFSPRK.Startroll = crandom(0, 359);
		PUFSPRK.RollVel = cfrandom(-10, 10);
		PUFSPRK.StartAlpha = 0.6;
		PUFSPRK.Size = crandom(20,30);
		PUFSPRK.SizeStep = 1;
		PUFSPRK.Lifetime = crandom(25,35);
		PUFSPRK.RollAcc = 0;
		
		PUFSPRK.accel = (0, 0,-0.05) - (vls * (1.0 / double(PUFSPRK.Lifetime)));
		if(CeilingPic == SkyFlatNum)
			PUFSPRK.accel += (-0.05, 0.1, 0.05);
			
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
}
