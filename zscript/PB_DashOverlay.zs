class PB_DashHandler : EventHandler
{
	double dashAlpha;
	int tick;
	bool dasheffect;
	
	override void WorldTick()
	{
		tick++;
		
		let plr = players[consoleplayer];
        if (!plr)
            return;
		
		if(tick % 35 == 0)
			dashEffect = cvar.GetCvar("pb_dasheffect", plr).GetBool();
		
		if(dashAlpha > 0.0000000)
			dashAlpha -= 0.2;
	}
	
	override void NetworkProcess(ConsoleEvent e)
	{
		if(e.name == "PB_DashWhatchamacallit")
		{
			dashAlpha = 1.0;
		}
	}
	
	override void RenderOverlay(RenderEvent e)
	{
		if(gamestate == GS_TITLELEVEL)
            return;
            
    	let pmo = players[consoleplayer].mo;
        if (!pmo)
            return;
            
        let texture = TexMan.CheckForTexture("Graphics/HUD/FULLSCRN/PB_DashOverlay.png");
        
        if(dashAlpha > 0.00000 && dashEffect)
        	screen.DrawTexture(texture, false, 0, 0, DTA_DestWidthF, Screen.GetWidth(), DTA_DestHeightF, Screen.GetHeight(), DTA_Alpha, dashAlpha);
	}
}