Class FireworkSFXType1 : Actor
{
	default
	{
		radius 4;
		height 4;
		Speed 18;
		projectile;
		-nogravity;
		+missile;
		+thruactors;
		gravity 1.0;
	}
	states
	{
		Spawn:
			TNT1 A 0 nodelay SpawnFlareFx();
			TNT1 A 0 SpawnFlameFx(1);
			TNT1 A 0 A_jumpif(waterlevel > 0,"null");
			TNT1 A 1 SpawnFlameFx();
			TNT1 A 0 SpawnSpark();
			loop;
		Death:
			TNT1 A 0 A_Spawnitem("TinyBurningPiece");
			TNT1 A 1;
			stop;
	}
	
	void SpawnFlareFx()
	{
		FSpawnParticleParams FLARFX;
		FLARFX.Texture = TexMan.CheckForTexture("LENRA0");
		FLARFX.Style = STYLE_ADD;
		FLARFX.Color1 = "FFFFFF";
		FLARFX.Flags = SPF_FULLBRIGHT;
		FLARFX.StartRoll = 0;
		FLARFX.StartAlpha = 1.0;
		FLARFX.FadeStep = 0.25;
		FLARFX.Size = random(65,85);
		FLARFX.SizeStep = 1;
		FLARFX.Lifetime = 1; 
		FLARFX.Pos = pos;
		Level.SpawnParticle(FLARFX);
	}
	
	void SpawnFlameFx(bool first = false)
	{
		FSpawnParticleParams FLAMFX;
		string tx = first ? "FRPRB0" : "FRPRC0";
		FLAMFX.Texture = TexMan.CheckForTexture(tx); //
		FLAMFX.Style = STYLE_ADD;
		FLAMFX.Color1 = "FFFFFF";
		FLAMFX.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		FLAMFX.vel = (frandom(-0.3,0.3),frandom(-0.3,0.3),frandom(-0.3,0.3));
		FLAMFX.StartRoll = 180;
		FLAMFX.StartAlpha = 1.0;
		//FLAMFX.FadeStep = 0.25;
		FLAMFX.Size = random(36,40);
		FLAMFX.SizeStep = -4;
		FLAMFX.Lifetime = first ? 1 : 8; 
		FLAMFX.Pos = pos;
		Level.SpawnParticle(FLAMFX);
	}
	
	void SpawnSpark()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("SPRKA0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_Add;
		PUFSPRK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		PUFSPRK.Vel = (random(-3,3),random(-3,3),random(-3,3));
		double accs = frandom(0.15,0.32);
		PUFSPRK.accel = (PUFSPRK.Vel * -accs);
		PUFSPRK.Startroll = randompick(0,90,180,270,360);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = 0.075;
		PUFSPRK.Size = random(8,14);
		PUFSPRK.SizeStep = -0.5;
		PUFSPRK.Lifetime = random(28,40); 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
}

Class FireworkSFXType2 : FireworkSFXType1
{
	default
	{
		Radius 2;
		Height 2;
		+DOOMBOUNCE;
		WallBounceFactor 0.5;
		BounceFactor 0.2;
	}
	states
	{
		Death:
			TNT1 A 1;
			stop;
	}
}

Class FireworkSFXUnmaker : FireworkSFXType1
{
	default
	{
		gravity 1.0;
	}
	states
	{
		Spawn:
			//TNT1 A 0 nodelay SpawnFlareFx();
			TNT1 A 0 SpawnDtechFlameFx(1);
			TNT1 A 0 A_jumpif(waterlevel > 0,"null");
			//TNT1 A 0 A_Spawnitem("ObeliskTrailSpark");
			TNT1 A 1 SpawnDtechFlameFx();
			TNT1 A 0 SpawnObeliskSpark();
			loop;
		Death:
			TNT1 A 0 A_Spawnitem("DtechBurningPiece");
			TNT1 A 1;
			stop;
	}
	
	void SpawnDtechFlameFx(bool first = false)
	{
		FSpawnParticleParams ULAMFX;
		string tex = first ? "FRPRI0":"FRPRJ0";
		ULAMFX.Texture = TexMan.CheckForTexture(tex);
		ULAMFX.Style = STYLE_TRANSLUCENT;
		ULAMFX.Color1 = "FFFFFF";
		ULAMFX.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		ULAMFX.vel = (frandom(-0.3,0.3),frandom(-0.3,0.3),frandom(-0.3,0.3));
		ULAMFX.StartRoll = 180;
		ULAMFX.StartAlpha = 1.0;
		//ULAMFX.FadeStep = 0.1;
		ULAMFX.Size = random(36,40);
		ULAMFX.SizeStep = -5;
		ULAMFX.Lifetime = first ? 1 : 6; 
		ULAMFX.Pos = pos;
		Level.SpawnParticle(ULAMFX);
	}
	
	void SpawnObeliskSpark()
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("YAE4A0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_Add;
		PUFSPRK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		PUFSPRK.Vel = (random(-3,3),random(-3,3),random(-3,3));
		double accs = frandom(0.15,0.32);
		PUFSPRK.accel = (PUFSPRK.Vel * -accs);
		PUFSPRK.Startroll = randompick(0,90,180,270,360);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = 0.075;
		PUFSPRK.Size = random(8,14);
		PUFSPRK.SizeStep = -0.5;
		PUFSPRK.Lifetime = random(28,42); 
		PUFSPRK.Pos = pos;
		Level.SpawnParticle(PUFSPRK);
	}
	
}




//
//	this should be in its own archive, probably Fire.zs or something, rn im just testing
//

Class TinyBurningPiece : Actor
{
	default
	{
		damagetype "Fire";
		alpha 0.9;
		renderstyle "add";
		scale 0.45;
		+noblockmap;
	}
	states
	{
		spawn:
			TNT1 A 0 A_JumpIf(waterlevel > 1, "StopBurning");
			TNT1 A 0 SpawnParticleSlow();
			CFCF ABCD 1 BRIGHT;
			TNT1 A 0 A_Explode(2, 60);
			CFCF EFGH 1 BRIGHT;
			CFCF IJKL 1 BRIGHT;
			TNT1 A 0 A_Jump(24, "StopBurning");
			loop;
		StopBurning:
			CFCF NOP 1 BRIGHT;
			stop;
	}
	
	void SpawnParticleSlow(string tx = "SPRKA0") //idk what is "ExplosionParticleVerySlow"
	{
		FSpawnParticleParams SPRKSL;
		SPRKSL.Texture = TexMan.CheckForTexture(tx);
		SPRKSL.Color1 = "FFFFFF";
		SPRKSL.Style = STYLE_Add;
		SPRKSL.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		SPRKSL.Vel = (frandom(-1.1,1.1),frandom(-1.1,1.1),frandom(0.5,1.25));
		SPRKSL.Startroll = randompick(0,90,180,270,360);
		SPRKSL.RollVel = 0;
		SPRKSL.StartAlpha = 0.9;
		SPRKSL.FadeStep = 0.075;
		SPRKSL.Size = random(7,12);
		SPRKSL.SizeStep = -0.5;
		SPRKSL.Lifetime = random(28,42); 
		SPRKSL.Pos = pos;
		Level.SpawnParticle(SPRKSL);
	}
}

Class TinyBurningPiece2: TinyBurningPiece
{
	default
	{
		Scale 0.25;
	}
	
	States
	{
		Spawn:
			TNT1 A 0 A_JumpIf(waterlevel > 1, "StopBurning");
			TNT1 AAA 0 SpawnParticleSlow();
			CFCF ABCD 1 BRIGHT;
			CFCF EFGH 1 BRIGHT;
			CFCF IJKL 1 BRIGHT;
			TNT1 A 0 A_Jump(24, "StopBurning");
			Loop;
		
		StopBurning:
			CFCF NOP 1 BRIGHT;
			Stop;
    }
}

Class TinyBurningPiece3: TinyBurningPiece2
{
	default
	{
		Scale 0.13;
	}
}


Class DTechBurningPiece : TinyBurningPiece
{
	default
	{
		renderstyle "translucent";
		scale 0.4;
	}
	states
	{
		Spawn:
			TNT1 A 0 A_JumpIf(waterlevel > 1, "StopBurning");
			TNT1 A 0 A_Explode(5, 35);
			TNT1 A 0 SpawnParticleSlow("YAE4A0");
			DFIR ABCDEFGHIJKLMNOP 2 BRIGHT;
			TNT1 A 0 A_Jump(50, "StopBurning");
			Loop;
		StopBurning:
			DFIR A 2 BRIGHT A_SetScale(0.06);
			DFIR B 2 BRIGHT A_SetScale(0.04);
			DFIR C 2 BRIGHT A_SetScale(0.02);
			Stop;
	}
}

Class DTechBurningPiece2: DTechBurningPiece
{
	default
	{
		Scale 0.24;
	}
}

class DTechBurningPiece3 : DTechBurningPiece
{
	default
	{
		Scale 0.68;
	}
	States
	{
		Spawn:
			TNT1 A 0 A_JumpIf(waterlevel > 1, "StopBurning");
			DFIR ABCDEFGH 2 BRIGHT;
			TNT1 A 0 SpawnParticleSlow("YAE4A0");
			DFIR IJKLMNOP 2 BRIGHT;
			TNT1 A 0 SpawnParticleSlow("YAE4A0");
			TNT1 A 0 A_Jump(50, "StopBurning");
			Loop;
		StopBurning:
			DFIR A 2 BRIGHT A_SetScale(0.010);
			DFIR B 2 BRIGHT A_SetScale(0.04);
			DFIR C 2 BRIGHT A_SetScale(0.02);
			Stop;
    }
	override void Beginplay()
	{
		if(!pb_performance_fire)
			A_AttachLightDef("dtechfire","DemontechFire");
		
		super.beginplay();
	}
}


Class DragonsBreathPiece1: TinyBurningPiece2
{
	default
	{
		Scale 0.33;
		-BLOODLESSIMPACT;
		+PAINLESS;
		+THRUSPECIES;
		+MTHRUSPECIES;
		+DONTHARMSPECIES;
		Species "Marines";	//why?
	}
	int distnc;
	States
	{
		Spawn:
			TNT1 A 0 A_JumpIf(waterlevel > 1, "StopBurning");
			TNT1 AAA 0 SpawnParticleSlow();
			CFCF ABC 1 BRIGHT;
			CFCF D 1 BRIGHT A_Explode(3, distnc, 0);
			CFCF EFGH 1 BRIGHT;
			CFCF IJK 1 BRIGHT;
			CFCF L 1 BRIGHT A_Explode(3, distnc, 0);
			TNT1 A 0 A_Jump(24, "StopBurning");
			Loop;
		StopBurning:
			CFCF NOP 1 BRIGHT;
			Stop;
    }
	
	override void beginplay()
	{
		distnc = random(35,40);
		A_setscale(0.33,0.40);
		super.beginplay();
	}
}

//they are the same just with some variations, but if i just delete this the mod will break probably 
Class DragonsBreathPiece2 : DragonsBreathPiece1
{}

Class DragonsBreathPiece3 : DragonsBreathPiece1
{}

//
//	flamethrower
//

Class FT_GroundFireSpawner : TinyBurningPiece2
{
	default
	{
		damagetype "Fire";
		+NODAMAGETHRUST;
		alpha 0.9;
		renderstyle "add";
		scale 1.0;
		speed 10;
	}
	states
	{
		Spawn:
			TNT1 A 0 A_jumpif(waterlevel > 0,"StopBurning");
			TNT1 A 0 A_StartSound("props/torchfire", CHAN_BODY, CHANF_NOSTOP);
			TNT1 A 2;
			TNT1 A 0 A_SpawnItemEx("FT_GroundFire", random(-24,24), random(-8,8), random(1,4));
			TNT1 A 2;
			TNT1 A 0 A_SpawnItemEx("FT_GroundFire2", random(-42,42), random(-28,28), random(0,6));
			TNT1 A 0 A_Explode(12, 36, 0, 0, 36);
			TNT1 A 0 {
				SpawnParticleFast();
				if(!pb_performance_fire && waterlevel < 1 && random(0,1) == 1)
					SpawnSmokeMed();
			
			}
			TNT1 A 0 A_Jump(7, "StopBurning");
			Loop;
		
		StopBurning:
			TNT1 A 0 A_StopSound(CHAN_BODY);
			TNT1 AAAAAAAA 2;
			Stop;
	}
	
	override void beginplay()
	{
		if(!pb_performance_fire)
			A_AttachLightDef('FlamethrowerLight', 'HUEHUESMALL');
			//A_AttachLightDef('FlamethrowerLight', 'FT_GroundFire');
		
		super.beginplay();
	}
	
	void SpawnParticleFast()
	{
		FSpawnParticleParams SPRKSL;
		string tx = "X123G0";
		switch(random(1,3))
		{
			case 1: tx = "X123G0";	break;
			case 2: tx = "FRFXL0";	break;
			case 3: tx = "FIR1C0";	break;
		}
		SPRKSL.Texture = TexMan.CheckForTexture(tx);
		SPRKSL.Color1 = "FFFFFF";
		SPRKSL.Style = STYLE_Add;
		SPRKSL.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		SPRKSL.Vel = (frandom(-1.9,1.9),frandom(-1.9,1.9),frandom(1.75,4.25));
		SPRKSL.Startroll = 180;
		SPRKSL.RollVel = 0;
		SPRKSL.StartAlpha = 1.0;
		SPRKSL.FadeStep = 0.075;
		SPRKSL.Size = random(15,28);//random(7,12);
		SPRKSL.SizeStep = -0.5;
		SPRKSL.Lifetime = random(28,42); 
		SPRKSL.Pos = self.vec3offset(random(-10,10),random(-10,10),random(5,15));
		Level.SpawnParticle(SPRKSL);
	}
	
	void SpawnSmokeMed()
	{
		FSpawnParticleParams SMKBCK;
		SMKBCK.Texture = TexMan.CheckForTexture("SMK1K0");
		SMKBCK.Color1 = "FFFFFF";
		SMKBCK.Style = STYLE_TRANSLUCENT;
		SMKBCK.Flags = SPF_ROLL;
		SMKBCK.Vel = (0,0,frandom(1.25,3.0));
		SMKBCK.Startroll = random(0,360);
		SMKBCK.RollVel = random(-10,10);
		SMKBCK.StartAlpha = 0.5;
		SMKBCK.Lifetime = random(32,42); 
		SMKBCK.FadeStep = SMKBCK.StartAlpha / SMKBCK.Lifetime;
		SMKBCK.Size = random(45,58);
		SMKBCK.SizeStep = 1;
		SMKBCK.Pos = self.vec3offset(random(-7,7),random(-7,7),random(16,30));
		Level.SpawnParticle(SMKBCK);
	}
	
}


Class FT_GroundFireSpawnerPerf : FT_GroundFireSpawner
{
	States
	{
		Spawn:
			TNT1 A 0 A_StartSound("props/torchfire", CHAN_BODY, CHANF_NOSTOP);
			TNT1 A 1;
			TNT1 A 0 A_SpawnItemEx("FT_GroundFire", random(-24,24), random(-7,7), random(1,2));
			TNT1 A 1;
			TNT1 A 0 A_SpawnItemEx("FT_GroundFire2", random(-24,24), random(-7,7), random(1,2));
			TNT1 A 1;
			TNT1 A 0 A_Explode(10, 36, 0, 0, 36);
			TNT1 A 0 A_Jump(7, "StopBurning");
			Loop;
    }
}

Class FT_GroundFire : Actor
{
	default
	{
		+NOINTERACTION;
		-SOLID;
		+FORCEXYBILLBOARD;
		RenderStyle "Add";
		Scale 0.21;
	}
	States
	{
		Spawn:
			TNT1 A 0 nodelay A_jump(256,"Var1","Var2");
		Var1:
			CFCF ABCDEFGHIJKLMABCDEFGHIJKLM 1 BRIGHT;
			CFCF ABC 1 {A_setscale(scale.x * 0.9); A_Fadeout(0.15);}
			Stop;
		Var2:
			TNT1 A 0 A_Setscale(0.12);
		Var2Loop:
			X123 ABCDEFGHIJKLMABCDEFGHIJKLMNOPQ 1 bright;
			X123 ABC 1 {A_setscale(scale.x * 0.9); A_Fadeout(0.15);}
			Stop;
		
    }
	override void beginplay()
	{
		//if(!pb_performance_fire)
		//	A_AttachLightDef('FlamethrowerLight', 'FT_GroundFire');
		bxflip = random(0,1);
		super.beginplay();
	}	
}

Class FT_GroundFire2 : FT_GroundFire
{
	default
	{
		Scale 0.42;
	}
	
	States
	{
		Spawn:
			TNT1 A 0 nodelay A_jump(256,"Var2","Var3");
		Var2:
			TNT1 A 0 A_SetScale(0.28);
		Var2Loop:
			X123 ABCDEFGHIJKLMABCDEFGHIJKLMNOPQ 1 bright;
			X123 ABC 1 {A_setscale(scale.x * 0.9); A_Fadeout(0.15);}
			Stop;
		Var3:
			FLME ABCDEFGHIJKLMNABCDEFGHIJKLMN 1 BRIGHT;
			FLME ABC 1 {A_setscale(scale.x * 0.9); A_Fadeout(0.15);}
			Stop;
    }
}