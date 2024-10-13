Class PB_BaseBulletImpact : BulletPuff abstract
{
	Default
	{
		+NOEXTREMEDEATH;
		+THRUACTORS;
		+NOCLIP;
		Decal "ConcreteWithGlow";
		+DONTSPLASH;
		-EXPLODEONWATER;
		Scale 1.0;
        Gravity 0.3;
        Alpha 0.3;
		Renderstyle "Translucent";
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

	uint8 hitWhat;
	float wallNormal;
	float distfromplayer;

	int smokeflags;

	flagdef NODISTANT: smokeflags, 0;

	/*void SpawnRicochet()
	{
		FSpawnParticleParams MAINPUF;
		string f = String.Format("%c", int("A") + random[justtobesafe](0,7));
		MAINPUF.Texture = TexMan.CheckForTexture("IPF2"..f..0);
		MAINPUF.Style = STYLE_ADD;
		MAINPUF.Color1 = "FFFFFF";
		MAINPUF.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		MAINPUF.StartRoll = random[justtobesafe](0,360);
		MAINPUF.StartAlpha = 1.0;
		MAINPUF.FadeStep = 0;
		MAINPUF.Size = random[justtobesafe](25,28);
		MAINPUF.SizeStep = random[justtobesafe](2,4);
		MAINPUF.Lifetime = 4; 
		MAINPUF.Pos = pos;
		Level.SpawnParticle(MAINPUF);
	}*/

	const DISTANT_THRESHOLD = 1024 ** 2;

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		/*if(AbsAngle(angle, wallnormal) > 76)
		{ 
			A_StartSound("ricochet/hit");
			SpawnRicochet();
		}*/

		distfromplayer = Distance2DSquared(players[consoleplayer].mo);

		if(!bNODISTANT && distfromplayer > DISTANT_THRESHOLD)
		{
			DistantHit();
		}
	}

	// extra feedback for far away hits
	void DistantHit()
	{
		FSpawnParticleParams MAINPUF;
		string f = String.Format("%c", int("A") + random[justtobesafe](0,7));
		MAINPUF.Texture = TexMan.CheckForTexture("IPF2"..f..0);
		MAINPUF.Style = STYLE_ADD;
		MAINPUF.Color1 = "FFFFFF";
		MAINPUF.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		MAINPUF.StartRoll = random[justtobesafe](0,360);
		MAINPUF.StartAlpha = 1.0;
		MAINPUF.FadeStep = 0;
		MAINPUF.Size = random[justtobesafe](25,28);
		MAINPUF.SizeStep = random[justtobesafe](2,4);
		MAINPUF.Lifetime = 4; 
		MAINPUF.Pos = pos;
		Level.SpawnParticle(MAINPUF);
	}
}

Class PB_BulletImpact : PB_BaseBulletImpact
{
	states
	{
		Spawn:
			/*TNT1 A 0 {
				A_SpawnProjectile("SparkX", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile("HitSpark", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
			}*/
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact", pitch: frandom(0.9, 1.1));

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnDust();
                    SpawnPuffSmoke();

					if(hitWhat == 1 && random[justtobesafe](0, 100) > 25)
						LinetracerSmoke();
                }
				SpawnMainPuff();

				/*scale.y *= 0.5;
				bXFLIP = randompick(0, 1);
				//bYFLIP = randompick(0, 1);
				scale *= frandom(0.3, 1.1);
				vel.z = frandom(2, 16);

				switch(hitWhat)
				{
					case 1:
						roll = 90;
						SpawnMainPuff();
						break;
					case 2: 
						roll = 0;
						break;
					case 3:
						roll = 180;
						break;
				}
				scalingpower = 1.0;
				roll *= frandom(0.9, 1.1);*/
			}
			/*TNT1 A 0 A_JumpIf(hitWhat == 1, 15);
            SMK8 ABCDEFGHIJKMNOP 1 {
				vel *= 0.5;
				
				if(scale.Length() > 2)
					scalingpower *= 0.8;

				scale.x += 0.03 * scalingpower;
				scale.y += 0.033 * scalingpower;
				roll += 1;
			}*/
            Stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, random (0, 360), 2, random (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL | SPF_REPLACE;
		vector3 vls;
		if(hitWhat == 1)
		{
			vls = (RotateVector((1, 0), wallNormal), 0);
		}
		else
		{
			vls = (0,0,1);
		}
		PUFSPRK.Vel = vls;
		PUFSPRK.accel = (0,0,frandom[justtobesafe](-0.1, 0.1));
		if(CeilingPic == SkyFlatNum)
			PUFSPRK.accel += (0.1, 0.05, 0.05);

		PUFSPRK.Startroll = random[justtobesafe](0, 359);
		PUFSPRK.RollVel = frandom[justtobesafe](1, 2);
		PUFSPRK.StartAlpha = 0.7;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = random[justtobesafe](20,50);
		PUFSPRK.SizeStep = 4;
		PUFSPRK.Lifetime = random[justtobesafe](6,35); 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnDust()
	{
		int sparkcount = random[justtobesafe](3,5);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + random[justtobesafe](0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("DUST"..f..0);
			PUFSPRK.Color1 = "FFFFFF";
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
				vls = (RotateVector(((frandom[justtobesafe](4, 6) * (i * 0.5)), frandom[justtobesafe](-2,2)), wallNormal), frandom[justtobesafe](-2,3));
			else
				vls = (random[justtobesafe](-5,5),random[justtobesafe](-5,5),random[justtobesafe](-2,9));

			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,frandom[justtobesafe](-1.75,-0.75));
			PUFSPRK.Startroll = randompick[justtobesafe](0,90,180,270,360);
			PUFSPRK.RollVel = 0;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = random[justtobesafe](4,6);
			PUFSPRK.SizeStep = 0;
			PUFSPRK.Lifetime = random[justtobesafe](12,18); 
			if(hitWhat == 1)
				PUFSPRK.Pos = pos + (RotateVector((i, 0), wallNormal), 0);
			else
				PUFSPRK.Pos = pos + (0, 0, i);
				
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 4; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = "c9c9c9";
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](3, 6) * (i * 0.5)), frandom[justtobesafe](-1,1)), wallNormal), frandom[justtobesafe](-3,2));
				accl = -(vls.xy * 0.07, (0.1 * i));
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (frandom[justtobesafe](-2,2), frandom[justtobesafe](-2,2));
				vls.z = 4 * (i * 0.5);
                accl = -(0, 0, (0.3 * i));

				if(hitWhat == 3);
                {
					vls.z *= -1;
                    accl.z *= -1;
                }
			}
			else
			{
				vls = (frandom[justtobesafe](-1,1), frandom[justtobesafe](-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (0.1, 0.05, 0.05);;
			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = random[justtobesafe](0,360);
			PUFSMK.RollVel = random[justtobesafe](-4,4);
			PUFSMK.StartAlpha = 0.8;
			PUFSMK.FadeStep = -1;
			PUFSMK.Size = random[justtobesafe](28,32);
			PUFSMK.SizeStep = random[justtobesafe](1,3);
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((5, 0), angle);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}

	// "rubble"
	void LinetracerSmoke(int dq = 1)
	{
		FLineTraceData lt;
		vector2 ofs = RotateVector((10, 0), wallNormal);
		LineTrace(wallNormal + 90, 100, random(25, 155), TRF_ABSOFFSET, offsetforward: ofs.x, ofs.y, lt);

		if(lt.HitType == TRACE_HitNone)
			return;
		
		FSpawnParticleParams PUFSMK;
		PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");//("SMK2A0"); //SMk3G0
		PUFSMK.Style = STYLE_TRANSLUCENT;
		PUFSMK.Color1 = "c9c9c9";
		PUFSMK.Flags = SPF_ROLL;
		PUFSMK.Vel = (frandom(-1, 1), frandom(-1, 1), frandom(-1, 1));
		PUFSMK.accel = (0, 0, 0);
		if(CeilingPic == SkyFlatNum)
			PUFSMK.accel += (0.1, 0.05, 0.05);;
		PUFSMK.Startroll = random[justtobesafe](0, 359);
		PUFSMK.RollVel = frandom[justtobesafe](1, 2);
		PUFSMK.StartAlpha = 0.6;
		PUFSMK.FadeStep = -1;
		PUFSMK.Size = random[justtobesafe](60,80);
		PUFSMK.SizeStep = 4;
		PUFSMK.Lifetime = random[justtobesafe](6,15); 
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
			/*TNT1 A 0 {
				A_SpawnProjectile("SparkX", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile("HitSpark", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
			}*/
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact/wood", pitch: frandom(0.9, 1.1));
                if(random(0, 100) < 25) A_StartSound("ricochet/hit");

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
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, random (0, 360), 2, random (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");
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
		PUFSPRK.accel = (0,0,frandom[justtobesafe](-0.1, 0.1));
		if(CeilingPic == SkyFlatNum)
			PUFSPRK.accel += (0.1, 0.05, 0.05);;

		PUFSPRK.Startroll = random[justtobesafe](0, 359);
		PUFSPRK.RollVel = frandom[justtobesafe](1, 2);
		PUFSPRK.StartAlpha = 0.7;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = random[justtobesafe](40,45);
		PUFSPRK.SizeStep = 0.5;
		PUFSPRK.Lifetime = random[justtobesafe](24,35); 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnSplinters()
	{
		int sparkcount = random[justtobesafe](8,10);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + random[justtobesafe](0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("WOOD"..f..0);
			PUFSPRK.Color1 = "FFFFFF";
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](1, 3) * (i * 0.5)), frandom[justtobesafe](-2,2)), wallNormal), frandom[justtobesafe](-2,2));
			}
			else
			{
				vls = (random[justtobesafe](-5,5),random[justtobesafe](-5,5),random[justtobesafe](-2,9));
			}
			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,-0.5);
			PUFSPRK.Startroll = random[justtobesafe](0, 359);
			PUFSPRK.RollVel = 2;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = random[justtobesafe](4,6);
			PUFSPRK.SizeStep = 0;
			PUFSPRK.Lifetime = random[justtobesafe](12,18); 
			PUFSPRK.Pos = pos;
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 3; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = "40291a";
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](0, 6) * (i * 0.5)), frandom[justtobesafe](-1,1)), wallNormal), frandom[justtobesafe](-3,2));
				accl = -(vls.xy * 0.07, (0.1 * i));
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (frandom[justtobesafe](-2,2), frandom[justtobesafe](-2,2));
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
				vls = (frandom[justtobesafe](-1,1), frandom[justtobesafe](-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (0.1, 0.05, 0.05);;

			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = random[justtobesafe](0,360);
			PUFSMK.RollVel = random[justtobesafe](-4,4);
			PUFSMK.StartAlpha = 1.0;
			PUFSMK.FadeStep = 0.1;
			PUFSMK.Size = random[justtobesafe](28,32);
			PUFSMK.SizeStep = random[justtobesafe](1,3);
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((5, 0), angle);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}
}

Class PB_BulletImpactMetal : PB_BaseBulletImpact
{
	Default {
		Decal "MetalWithGlow";
		+PB_BaseBulletImpact.NODISTANT;
	}
	states
	{
		Spawn:
			TNT1 AAAA 0;
			TNT1 A 0 {
				A_SpawnProjectile("SparkX", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile("HitSpark", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
			}
		Puff:
			TNT1 A 0 NoDelay {
                A_StartSound("bulletimpact/metal/a", pitch: frandom(0.9, 1.1));
                if(random(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnPuffSpark();
                    SpawnPuffShrapnel();
                    // SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
			TNT1 A 2 Light("BulletPuffLight");
			stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, random (0, 360), 2, random (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams MAINPUF;
		string f = String.Format("%c", int("A") + random[justtobesafe](0,7));
		MAINPUF.Texture = TexMan.CheckForTexture("IPF2"..f..0);
		MAINPUF.Style = STYLE_ADD;
		MAINPUF.Color1 = "FFFFFF";
		MAINPUF.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		MAINPUF.StartRoll = random[justtobesafe](0,360);
		MAINPUF.StartAlpha = 1.0;
		MAINPUF.FadeStep = 0;
		MAINPUF.Size = random[justtobesafe](25,28);
		MAINPUF.SizeStep = random[justtobesafe](2,4);
		MAINPUF.Lifetime = 4; 
		MAINPUF.Pos = pos;
		Level.SpawnParticle(MAINPUF);
	}

    void SpawnPuffSpark()
	{
        int sparkcount = random[justtobesafe](3,5);
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
				vls = (RotateVector(((frandom[justtobesafe](2, 7) * (i * 0.5)), frandom[justtobesafe](-6,6)), wallNormal), frandom[justtobesafe](-2,2));
			}
			else
			{
				vls = (random[justtobesafe](-5,5),random[justtobesafe](-5,5),random[justtobesafe](-2,9));
			}
            PUFSPRK.Vel = vls;
            PUFSPRK.accel = (-(vls.xy * 0.075),-0.2) + (frandom[justtobesafe](-0.25, 0.25), frandom[justtobesafe](-0.25,0.25), frandom[justtobesafe](-0.2,0.1));
            PUFSPRK.Startroll = random[justtobesafe](0,359);
            PUFSPRK.RollVel = 0;
            PUFSPRK.StartAlpha = 1.0;
            PUFSPRK.FadeStep = 0.075;
            PUFSPRK.Size = random[justtobesafe](6,8);
            PUFSPRK.SizeStep = -0.5;
            PUFSPRK.Lifetime = random[justtobesafe](12,18); 
            PUFSPRK.Pos = pos;
            Level.SpawnParticle(PUFSPRK);
        }
	}

    void SpawnPuffShrapnel()
	{
        if(randompick[justtobesafe](0, 0, 0, 0, 1))
            return;

        FSpawnParticleParams PUFSHRP;
        string f = String.Format("%c", int("A") + random[justtobesafe](0,7));
        PUFSHRP.Texture = TexMan.CheckForTexture("JNK3"..f..0);
        PUFSHRP.Color1 = "FFFFFF";
        PUFSHRP.Style = STYLE_TRANSLUCENT;
        PUFSHRP.Flags = SPF_ROLL;
        vector3 vls;
        if(hitWhat == 1)
        {
            vls = (RotateVector(((frandom[justtobesafe](5, 7)), frandom[justtobesafe](-4,4)), wallNormal), frandom[justtobesafe](-4,4));
        }
        else
        {
            vls = (random[justtobesafe](-5,5),random[justtobesafe](-5,5),random[justtobesafe](-2,9));
        }
        PUFSHRP.Vel = vls;
        PUFSHRP.accel = (-(vls.xy * 0.05),-1);
        PUFSHRP.Startroll = random[justtobesafe](0, 359);
        PUFSHRP.RollVel = 1.5;
        PUFSHRP.StartAlpha = 1.0;
        PUFSHRP.FadeStep = -1;
        PUFSHRP.Size = random[justtobesafe](4,8);
        PUFSHRP.SizeStep = 0;
        PUFSHRP.Lifetime = 24; 
        PUFSHRP.Pos = pos;
        Level.SpawnParticle(PUFSHRP);
	}
	
	void SpawnPuffSmoke(int dq = 1)
	{
		FSpawnParticleParams PUFSMK;
		PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");//("SMK2A0"); //SMk3G0
		PUFSMK.Style = STYLE_TRANSLUCENT;
		PUFSMK.Color1 = "404040";
		vector3 vls = (frandom[justtobesafe](-1,1),frandom[justtobesafe](-1,1),frandom[justtobesafe](1,2));
		PUFSMK.vel = vls;
		PUFSMK.accel = -(vls * 0.07);
		if(CeilingPic == SkyFlatNum)
			PUFSMK.accel += (0.1, 0.05, 0.05);;

		PUFSMK.Flags = SPF_ROLL;
		PUFSMK.StartRoll = random[justtobesafe](0,360);
		PUFSMK.RollVel = random[justtobesafe](-4,4);
		PUFSMK.StartAlpha = 1.0;
		PUFSMK.FadeStep = 0.080;
		PUFSMK.Size = random[justtobesafe](28,32);
		PUFSMK.SizeStep = random[justtobesafe](1,3);
		PUFSMK.Lifetime = 13; 
		vector2 posofs = RotateVector((5, 0), angle);
		PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
		Level.SpawnParticle(PUFSMK);
	}
}

Class PB_BulletImpactSheetMetal : PB_BulletImpactMetal
{
	states
	{
        Spawn:
			TNT1 AAAA 0;
			/*TNT1 A 0 {
				A_SpawnProjectile("SparkX", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile("HitSpark", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
			}*/
		Puff:
			TNT1 A 0 NoDelay {
                A_StartSound("bulletimpact/metal/b", pitch: frandom(0.9, 1.1));
                if(random(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnPuffSpark();
                    SpawnPuffShrapnel();
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
			/*TNT1 A 0 {
				A_SpawnProjectile("SparkX", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile("HitSpark", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
			}*/
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact/wood", pitch: frandom(0.9, 1.1));
                if(random(0, 100) < 25) A_StartSound("ricochet/hit");

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
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, random (0, 360), 2, random (0, 360));
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
		PUFSPRK.accel = (0,0,frandom[justtobesafe](-0.1, 0.1));
		if(CeilingPic == SkyFlatNum)
			PUFSPRK.accel += (0.1, 0.05, 0.05);;

		PUFSPRK.Startroll = random[justtobesafe](0, 359);
		PUFSPRK.RollVel = 5;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = random[justtobesafe](30,75);
		PUFSPRK.SizeStep = 6;
		PUFSPRK.Lifetime = random[justtobesafe](4,7); 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnSplinters()
	{
		int sparkcount = random[justtobesafe](8,10);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + random[justtobesafe](0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("DUST"..f..0);
			PUFSPRK.Color1 = "865627";
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](1, 3) * (i * 0.5)), frandom[justtobesafe](-2,2)), wallNormal), frandom[justtobesafe](-2,2));
			}
			else
			{
				vls = (random[justtobesafe](-5,5),random[justtobesafe](-5,5),random[justtobesafe](-2,9));
			}
			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,-2);
			PUFSPRK.Startroll = random[justtobesafe](0, 359);
			PUFSPRK.RollVel = 2;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = random[justtobesafe](4,6);
			PUFSPRK.SizeStep = 0;
			PUFSPRK.Lifetime = random[justtobesafe](12,18); 
			PUFSPRK.Pos = pos;
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 3; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = "865627";
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](5, 7) * (i * 0.5)), frandom[justtobesafe](-1,1)), wallNormal), frandom[justtobesafe](-3,2));
				accl = -(vls.xy * 0.07, 0);
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (frandom[justtobesafe](-2,2), frandom[justtobesafe](-2,2));
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
				vls = (frandom[justtobesafe](-1,1), frandom[justtobesafe](-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (0.1, 0.05, 0.05);;
			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = random[justtobesafe](0,360);
			PUFSMK.RollVel = random[justtobesafe](-4,4);
			PUFSMK.StartAlpha = 1.0;
			PUFSMK.FadeStep = -1;
			PUFSMK.Size = random[justtobesafe](28,32);
			PUFSMK.SizeStep = 3;
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((5, 0), angle);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}
}

Class PB_BulletImpactBrownRock : PB_BaseBulletImpact
{
	states
	{
		Spawn:
			/*TNT1 A 0 {
				A_SpawnProjectile("SparkX", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile("HitSpark", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
			}*/
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact", pitch: frandom(0.9, 1.1));
                if(random(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnDust();
                    SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
            //TNT1 A 2 Light("BulletPuffLight");
            Stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, random (0, 360), 2, random (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");
		PUFSPRK.Color1 = "533f2f";
		PUFSPRK.Style = STYLE_TRANSLUCENT;
		PUFSPRK.Flags = SPF_ROLL;
		vector3 vls;
		if(hitWhat == 1)
		{
			vls = (RotateVector((2, 0), wallNormal), 0);
		}
		else
		{
			vls = (0,0,2);
		}
		PUFSPRK.Vel = vls;
		PUFSPRK.accel = (0,0,frandom[justtobesafe](-0.1, 0.1));
		if(CeilingPic == SkyFlatNum)
			PUFSPRK.accel += (0.1, 0.05, 0.05);;
			
		PUFSPRK.Startroll = random[justtobesafe](0, 359);
		PUFSPRK.RollVel = frandom[justtobesafe](1, 2);
		PUFSPRK.StartAlpha = 0.7;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = random[justtobesafe](20,50);
		PUFSPRK.SizeStep = 4;
		PUFSPRK.Lifetime = random[justtobesafe](6,35); 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnDust()
	{
		int sparkcount = random[justtobesafe](7,9);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + random[justtobesafe](0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("DUST"..f..0);
			PUFSPRK.Color1 = randompick[justtobesafe](0x6f5743, 0x875733, 0x6b4727);
			PUFSPRK.Style = STYLE_TRANSLUCENT;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](3, 4) * (i * 0.5)), frandom[justtobesafe](-5,5)), wallNormal), frandom[justtobesafe](-2,3));
			}
			else
			{
				vls = (random[justtobesafe](-5,5),random[justtobesafe](-5,5),random[justtobesafe](2,5));
			}
			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,frandom[justtobesafe](-1.75,-0.75));
			PUFSPRK.Startroll = randompick[justtobesafe](0,90,180,270,360);
			PUFSPRK.RollVel = 0;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = random[justtobesafe](4,6);
			PUFSPRK.SizeStep = 0;
			PUFSPRK.Lifetime = random[justtobesafe](12,18); 
			PUFSPRK.Pos = pos + (RotateVector(((frandom[justtobesafe](-5, 5)), 0), wallNormal), frandom[justtobesafe](-3,3));
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 2; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_TRANSLUCENT;
			PUFSMK.Color1 = "7b634f";
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](0, 6) * (i * 0.5)), frandom[justtobesafe](-1,1)), wallNormal), frandom[justtobesafe](-3,2));
				accl = -(vls.xy * 0.07, (0.1 * i));
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (frandom[justtobesafe](-2,2), frandom[justtobesafe](-2,2));
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
				vls = (frandom[justtobesafe](-1,1), frandom[justtobesafe](-1,1), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			if(CeilingPic == SkyFlatNum)
				PUFSMK.accel += (0.1, 0.05, 0.05);;

			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = random[justtobesafe](0,360);
			PUFSMK.RollVel = random[justtobesafe](-4,4);
			PUFSMK.StartAlpha = 0.8;
			PUFSMK.FadeStep = -1;
			PUFSMK.Size = random[justtobesafe](28,32);
			PUFSMK.SizeStep = random[justtobesafe](1,3);
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((5, 0), angle);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}
}

Class PB_BulletImpactWater : PB_BaseBulletImpact
{
	color waterColor;
    property WaterColor: waterColor;

    Default
    {
        PB_BulletImpactWater.WaterColor "FFFFFF";
    }

    states
	{
		Spawn:
			/*TNT1 A 0 {
				A_SpawnProjectile("SparkX", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile("HitSpark", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark22", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
				A_SpawnProjectile("HitSpark23", 0, 0, frandom(0,1)*frandom (0, 360), 2, frandom(0,1)*frandom (30, 360));
			}*/
		Puff:
			TNT1 A 0 NoDelay {
				A_StartSound("bulletimpact/water", pitch: frandom(0.9, 1.1));
                if(random(0, 100) < 25) A_StartSound("ricochet/hit");

                if(distfromplayer < DISTANT_THRESHOLD)
                {
                    SpawnDust();
                    SpawnPuffSmoke();
                }
				SpawnMainPuff();
			}
            Stop;
		Melee:
			TNT1 AAA 0 SpawnPuffSmoke();//A_SpawnProjectile ("OldschoolRocketSmokeTrail2", 0, 0, random (0, 360), 2, random (0, 360));
			stop;
	}
	
	//anything that doesnt need to be an actor, is now not an actor
	void SpawnMainPuff()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");
		PUFSPRK.Color1 = waterColor;
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
		PUFSPRK.accel = (0,0,frandom[justtobesafe](-0.1, 0.1));
		PUFSPRK.Startroll = random[justtobesafe](0, 359);
		PUFSPRK.RollVel = frandom[justtobesafe](1, 2);
		PUFSPRK.StartAlpha = 0.7;
		PUFSPRK.FadeStep = -1;
		PUFSPRK.Size = random[justtobesafe](10,30);
		PUFSPRK.SizeStep = 6;
		PUFSPRK.Lifetime = random[justtobesafe](6,8); 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
	void SpawnDust()
	{
		int sparkcount = random[justtobesafe](7,9);
		for(int i = 0; i < sparkcount; i++)
		{
			FSpawnParticleParams PUFSPRK;
			string f = String.Format("%c", int("A") + random[justtobesafe](0,3));
			PUFSPRK.Texture = TexMan.CheckForTexture("LIQU"..f..0);
			PUFSPRK.Color1 = waterColor;
			PUFSPRK.Style = STYLE_ADD;
			PUFSPRK.Flags = SPF_ROLL;
			vector3 vls;
			if(hitWhat == 1)
			{
				vls = (RotateVector(((frandom[justtobesafe](3, 4) * (i * 0.5)), frandom[justtobesafe](-5,5)), wallNormal), frandom[justtobesafe](-2,3));
			}
			else
			{
				vls = (random[justtobesafe](-5,5),random[justtobesafe](-5,5),random[justtobesafe](2,9));
			}
			PUFSPRK.Vel = vls;
			PUFSPRK.accel = (0,0,frandom[justtobesafe](-1.75,-0.75));
			PUFSPRK.Startroll = randompick[justtobesafe](0,90,180,270,360);
			PUFSPRK.RollVel = 0;
			PUFSPRK.StartAlpha = 1.0;
			PUFSPRK.FadeStep = 0.075;
			PUFSPRK.Size = random[justtobesafe](4,6);
			PUFSPRK.SizeStep = 3;
			PUFSPRK.Lifetime = random[justtobesafe](12,18); 
			PUFSPRK.Pos = pos + (RotateVector((frandom[justtobesafe](-5, 5), frandom[justtobesafe](-5, 5)), wallNormal), frandom[justtobesafe](-3,3));
			Level.SpawnParticle(PUFSPRK);
		}
	}

	void SpawnPuffSmoke(int dq = 1)
	{
		for(int i = 0; i < 4; i++) {
			FSpawnParticleParams PUFSMK;
			PUFSMK.Texture = TexMan.CheckForTexture("X103"..String.Format("%c", 97 + random[justtobesafe](0, 25)).."0");//("SMK2A0"); //SMk3G0
			PUFSMK.Style = STYLE_ADD;
			PUFSMK.Color1 = waterColor;
			vector3 vls, accl;
			if(hitWhat == 1)
			{
				vls = (RotateVector((0, frandom[justtobesafe](-5,5)), wallNormal), frandom[justtobesafe](-5,5));
				accl = -(vls.xy * 0.07, (0.1 * i));
			} 
			else if(hitWhat >= 2)
			{
				vls.xy = (frandom[justtobesafe](-2,2), frandom[justtobesafe](-2,2));
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
				vls = (frandom[justtobesafe](-5,5), frandom[justtobesafe](-5,5), 0);
				accl = -(vls.xy * 0.07, (0.1 * i));
			}
			PUFSMK.vel = vls;
			PUFSMK.accel = accl;
			PUFSMK.Flags = SPF_ROLL;
			PUFSMK.StartRoll = random[justtobesafe](0,360);
			PUFSMK.RollVel = random[justtobesafe](-4,4);
			PUFSMK.StartAlpha = 0.8;
			PUFSMK.FadeStep = -1;
			PUFSMK.Size = random[justtobesafe](28,32);
			PUFSMK.SizeStep = 5;
			PUFSMK.Lifetime = 10; 
			vector2 posofs = RotateVector((frandom[justtobesafe](-10, 10), frandom[justtobesafe](-10, 10)), angle);
			PUFSMK.Pos = vec3Offset(posofs.x, posofs.y, 0);
			Level.SpawnParticle(PUFSMK);
		}
	}
}

class PB_BulletImpactBlood : PB_BulletImpactWater
{
    Default {
        PB_BulletImpactWater.WaterColor "FF0000";
    }
}

class PB_BulletImpactSlime : PB_BulletImpactWater
{
    Default {
        PB_BulletImpactWater.WaterColor "533f1f";
    }
}

class PB_BulletImpactNukage : PB_BulletImpactWater
{
    Default {
        PB_BulletImpactWater.WaterColor "3f832f";
    }
}