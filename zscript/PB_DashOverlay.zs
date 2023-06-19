class PB_DashHandler : EventHandler
{
	double dashAlpha;
	
	override void WorldTick()
	{
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
        
        screen.DrawTexture(texture, false, 0, 0, DTA_DestWidthF, Screen.GetWidth(), DTA_DestHeightF, Screen.GetHeight(), DTA_Alpha, dashAlpha);
	}
}