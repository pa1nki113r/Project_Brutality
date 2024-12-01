extend class PB_Hud_ZS
{
	array<PB_BloodFXStorage> bloodDrops;
	
	void CreateBloodDrop(int enemybloodcolor)
	{		
		if(!showBloodDrops)
			return;

		if(bloodDrops.Size() > 60)
			bloodDrops.Delete(0);
		
		PB_BloodFXStorage bdrp = PB_BloodFXStorage.CreateBloodFX(enemybloodcolor);
		cplayer.mo.A_StartSound("visor/blooddrop", CHAN_AUTO, CHANF_OVERLAP | CHANF_LOCAL | CHANF_UI);
		bloodDrops.Push(bdrp);
	}
	
	void DrawBloodDrops()
	{
		if(!showBloodDrops)
			return;
			
		for(int i = 0; i < bloodDrops.size(); i++)
		{
			PB_BloodFXStorage bld = bloodDrops[i];
			vector2 posbuffer = bld.pos;
			vector2 hudscale = GetHUDScale();
			posbuffer.x /= hudscale.x;
			posbuffer.y /= hudscale.y;
			SetSway(posbuffer.x, posbuffer.y, 0, 0.6, 0.15, false, false);
			
			Screen.DrawTexture(bld.graphic, false, posbuffer.x * hudscale.x, posbuffer.y * hudscale.y, DTA_Alpha, clamp(0.4 * bld.alpha, 0, 1.0) * bloodDropsAlpha, DTA_CenterOffset, true, DTA_ScaleX, bld.scale.x * hudscale.x, DTA_ScaleY, bld.scale.y * hudscale.y, DTA_Color, bld.bloodcolor, DTA_LegacyRenderStyle, STYLE_Shaded, DTA_FlipX, bld.mirror);
		}
	}
	
	void TickBloodDrops()
	{
		for(int i = 0; i < bloodDrops.size(); i++)
		{
			PB_BloodFXStorage bld = bloodDrops[i];
			bld.TickBloodFX();
			if(bld.alpha <= 0.05)
			{
				bld.Destroy();
				bloodDrops.Delete(i);
			}
		}
	}
	
	array<PB_CrackFXStorage> glassCracks;
	
	void CreateCrack()
	{
		if(!showGlassCracks)
			return;
		
		if(glassCracks.Size() > 8)
			glassCracks.Delete(0);

		PB_CrackFXStorage crack = PB_CrackFXStorage.CreateCrackFX();
		cplayer.mo.A_StartSound("visor/glasscrack", CHAN_AUTO, CHANF_OVERLAP | CHANF_LOCAL | CHANF_UI, 0.7, pitch: frandom(0.96, 1.04));
		glassCracks.Push(crack);
	}
	
	void DrawGlassCracks()
	{
		if(!showGlassCracks)
			return;
			
		for(int i = 0; i < glassCracks.size(); i++)
		{
			PB_CrackFXStorage crck = glassCracks[i];
			vector2 posbuffer = crck.pos;
			vector2 hudscale = GetHUDScale();
			posbuffer.x /= hudscale.x;
			posbuffer.y /= hudscale.y;
			SetSway(posbuffer.x, posbuffer.y, 0, 0.6, 0.15, false, false);
			
			Screen.DrawTexture(crck.graphic, false, posbuffer.x * hudscale.x, posbuffer.y * hudscale.y, DTA_Alpha, crck.alpha * glassCracksAlpha, DTA_CenterOffset, true, DTA_ScaleX, crck.scale.x * hudscale.x, DTA_ScaleY, crck.scale.y * hudscale.y, DTA_FlipX, crck.mirror);
		}
	}
	
	void TickGlassCracks()
	{
		for(int i = 0; i < glassCracks.size(); i++)
		{
			PB_CrackFXStorage crck = glassCracks[i];
			crck.TickCrackFX();
			if(crck.alpha <= 0.05)
			{
				crck.Destroy();
				glassCracks.Delete(i);
			}
		}
	}
}

class PB_GenericHudEffect ui
{
	TextureID graphic;
	vector2 scale;
	vector2 scalenomod;
	vector2 pos;
	float alpha;
	int lifetime;
	bool mirror;
	
	// screen percentages 
	const SP_X = 0.25;
	const SP_Y = 0.1;
	
	static vector2 FX_PickPosition() {
		vector2 res = (Screen.GetWidth(), Screen.GetHeight());
		vector2 pos;
		switch(random[hud](0, 3))
		{
			default:
			case 0: // top
				pos.x = frandom[hud](0, res.x);
				pos.y = frandom[hud](0, res.y * SP_Y);
				break;
			case 1: // left
				pos.x = frandom[hud](0, res.x * SP_X);
				pos.y = frandom[hud](0, res.y);
				break;
			case 2: // bottom
				pos.x = frandom[hud](0, res.x);
				pos.y = random[hud](res.y * (1 - SP_Y), res.y);
				break;
			case 3: // right
				pos.x = frandom[hud](res.x * (1 - SP_X), res.x);
				pos.y = frandom[hud](0, res.y);
				break;
		}
		
		return pos;
	}
}

class PB_CrackFXStorage : PB_GenericHudEffect
{
	const CRACKS_RANGE = 2;
	const CRACK_GRAPHIC_PREFIX = "HUGLBRK";
	
	static PB_CrackFXStorage CreateCrackFX()
	{
		PB_CrackFXStorage cls = PB_CrackFXStorage(new("PB_CrackFXStorage"));
		
		if(!cls)
			return cls;
			
		cls.mirror = randompick[hud](0, 1);
		
		string gfxname = string.Format("%s%i", CRACK_GRAPHIC_PREFIX, random[hud](1, CRACKS_RANGE));
		
		cls.graphic = TexMan.CheckForTexture(gfxname);
		
		float randscale = frandom[hud](0.5, 0.8);
		cls.scale.x = randscale;
		cls.scale.y = randscale;
		cls.scalenomod = cls.scale;
		
		cls.pos = FX_PickPosition();
		
		cls.alpha = 1.0;
		
		return cls;
	}
	
	void TickCrackFX()
	{
		lifetime++;
		
		if(lifetime < 1)
			scale *= 0.75;
		else if(lifetime < 6)
			scale *= 1.05;
		
		if(lifetime > 35 * 10)
			alpha -= 0.02;
	}
}

class PB_BloodFXStorage : PB_GenericHudEffect 
{
	int bloodcolor;
	
	const BLOOD_DROPS_RANGE = 5;
	const BLOOD_GRAPHICS_PREFIX = "HUBLDRP";
	
	static PB_BloodFXStorage CreateBloodFX(int enemybloodcolor)
	{
		PB_BloodFXStorage cls = PB_BloodFXStorage(new("PB_BloodFXStorage"));
		
		if(!cls) 
			return cls;
		
		cls.mirror = randompick[hud](0, 1);

		string gfxname = string.Format("%s%i", BLOOD_GRAPHICS_PREFIX, random[hud](1, BLOOD_DROPS_RANGE));
		
		cls.graphic = TexMan.CheckForTexture(gfxname);
		
		float randscale = frandom[hud](0.5, 1.5);
		cls.scale.x = randscale;
		cls.scale.y = randscale + frandom[hud](0, 0.1 * cls.scale.x);
		cls.scalenomod = cls.scale;
		
		cls.pos = FX_PickPosition();
		
		cls.alpha = clamp((1.0 / cls.scale.Length()) * frandom[hud](1, 3), 0, 2.5);
		
		if(enemybloodcolor == 0)
			cls.bloodcolor = 0xfff60000;
		else
			cls.bloodcolor = enemybloodcolor;
		
		
		return cls;
	}
	
	void TickBloodFX()
	{
		lifetime++;
		alpha -= 0.01;
		
		if(lifetime > 3)
		{
			pos.y += 0.1;
			scale.y += 0.002 * scalenomod.y;
			scale *= 0.996;
		}
		
		// splashing effect
		if(lifetime < 3)
			scale *= 1.05;
		else if(lifetime < 7)
			scale *= 0.95;
	}
}

class PB_HUDFXHandler : EventHandler
{
	override void WorldThingSpawned(worldEvent e)
	{
	    if(!e.thing || !(e.thing is 'Blood'))
	        return;
	        
	    PB_PlayerPawn pmo = PB_PlayerPawn(players[consoleplayer].mo);
	    if(pmo && e.thing && e.thing.target && e.thing.target.bISMONSTER && e.thing.Distance3D(pmo) <= 80 && randompick[hud](0, 0, 1))
	    {
	        EventHandler.SendInterfaceEvent(pmo.PlayerNumber(), "PB_HUDBloodDroplet", e.thing.target.bloodcolor);
	    }
	}
	
	override void InterfaceProcess(consoleEvent e)
	{
		let sb = PB_Hud_ZS(statusbar);
		
		if(!sb)
			return;
		
		if(sb.CheckInventory("sae_extcam"))
			return;

		if(e.name == "PB_HUDBloodDroplet")
			sb.CreateBloodDrop(e.args[0]);
		else if(e.name == "PB_HUDGlassBreak")
			sb.CreateCrack();
	}
	
	override void WorldThingDamaged(worldEvent e)
	{
		if(!e.Thing)
			return;
		
		PB_PlayerPawn pmo = PB_PlayerPawn(players[consoleplayer].mo);
		if(e.Thing == pmo && e.DamageType == 'Head')
		{
			EventHandler.SendInterfaceEvent(pmo.PlayerNumber(), "PB_HUDGlassBreak");
		}
	}
}
