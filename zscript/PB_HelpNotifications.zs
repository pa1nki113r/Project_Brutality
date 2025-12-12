// [gng] little help tip library i made for dox778's Vanilla Reloaded, but adapted for PB

class PB_HelpNotificationsHandler : EventHandler
{
    string lastTooltipString;
    bool lastTooltipIsArray;
    array<String> lastTooltipArray;
    uint lastTooltipArrayStartTime;
    int posInArray;

    static clearscope void PB_SendTip(string tipText, string tipCvar = "", int tipFlag = 0)
    {
        NetworkBuffer tipbuf = new("NetworkBuffer");
        tipbuf.AddString(tipCvar);
        tipbuf.AddInt(tipFlag);
        tipbuf.AddString(tiptext);
        
        SendNetworkBuffer('PB_RegisterTipBuffer', tipbuf);
    }

    static clearscope void PB_SendTipArray(Array<String> tipText, string tipCvar = "", int tipFlag = 0)
    {
        NetworkBuffer tipbuf = new("NetworkBuffer");
        tipbuf.AddString(tipCvar);
        tipbuf.AddInt(tipFlag);
        tipbuf.AddStringArray(tiptext);
        
        SendNetworkBuffer('PB_RegisterTipBufferArray', tipbuf);
    }

    override void NetworkCommandProcess(NetworkCommand cmd)
	{
        if (cmd.Command == 'PB_RegisterTipBuffer')
		{
			string lastTooltipCvar = cmd.ReadString();
			int lastTooltipFlag = cmd.ReadInt();

            if(lastTooltipFlag != 0 && lastTooltipCvar != "")
            {    
                if(CheckTipEvent(lastTooltipFlag, CVar.FindCVar(lastTooltipCvar)))
                    return;
                else
                    SetTipEvent(lastTooltipFlag, CVar.FindCVar(lastTooltipCvar));
            }

            lastTooltipArray.Push(cmd.ReadString());

            if(!lastTooltipIsArray)
            {
                lastTooltipIsArray = true;
                lastTooltipArrayStartTime = gametic;
                posInArray = 0;
            }
		}

        else if (cmd.Command == 'PB_RegisterTipBufferArray')
		{
            string lastTooltipCvar = cmd.ReadString();
			int lastTooltipFlag = cmd.ReadInt();

            if(lastTooltipFlag != 0 && lastTooltipCvar != "")
            {    
                if(CheckTipEvent(lastTooltipFlag, CVar.FindCVar(lastTooltipCvar)))
                    return;
                else
                    SetTipEvent(lastTooltipFlag, CVar.FindCVar(lastTooltipCvar));
            }

            cmd.ReadStringArray(lastTooltipArray);

            if(!lastTooltipIsArray)
            {
                lastTooltipIsArray = true;
                lastTooltipArrayStartTime = gametic;
                posInArray = 0;
            }
		}
	}

    override void InterfaceProcess(ConsoleEvent e)
    {
        if(e.name == 'PB_RegisterTip') RegisterTip(lastTooltipString);
    }

    clearscope void SetTipEvent(int tipFlag, cvar check)
    {
        check.SetInt(check.GetInt() | tipFlag);
    }

    static clearscope bool CheckTipEvent(int tipflag, cvar check)
    {
        return (check.GetInt() & tipflag) == tipflag;
    }

    ui void RegisterTip(string tipText = "")
    {
        let sb = PB_Hud_ZS(statusBar);
        console.printfex(PRINT_NONOTIFY, tipText);
        if(!sb) return;
        sb.UpdateTooltip(tipText);
    }

    override void WorldTick()
    {
        if(!lastTooltipIsArray) return;

        if((gametic - lastTooltipArrayStartTime) % PB_HELPNOTIF_DURATION == 0)
        {
            if(posInArray == lastTooltipArray.Size())
            {
                lastTooltipArray.Clear();
                lastTooltipIsArray = false;
                posInArray = 0;
                return;
            }
            lastTooltipString = lastTooltipArray[posInArray];
            SendInterfaceEvent(consoleplayer, 'PB_RegisterTip');
            posInArray++;
        }
    }

    /*override void PlayerSpawned(PlayerEvent e)
    {
        array<string> pbTipsBuf;
        pbTipsBuf.Push("Welcome to Project Brutality!");
        pbTipsBuf.Push("Please keep in mind that the mod is W.I.P., so it does not have the best of stability.");
        pbTipsBuf.Push("Any bugs you may find should be posted in the Discord server linked on the ModDB page.");
        pbTipsBuf.Push("If you have a weak processor, remember to turn down the gore settings.");
        pbTipsBuf.Push("If using custom WADs, remember to load PB AFTER it.");
        pbTipsBuf.Push("Want to disable these tutorials? Navigate to the HUD options menu or type pb_showtutorials 0 into the console.");
        pbTipsBuf.Push("Remember to check the settings menu to tweak the game to your liking.");
        pbTipsBuf.Push("That is all. Happy hunting!");
        PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 30);
    }*/
}

const PB_HELPNOTIF_DURATION = (4 * thinker.TICRATE);

extend class PB_Hud_ZS 
{
    brokenlines brokenTooltip;
    int tooltipUntilTic;
    vector2 tooltipBoxSize, tooltipBoxPos;

    void UpdateTooltip(string tipText)
    {
        if(!showtutorials) return;
        
        brokenTooltip = mBoldFont.mFont.BreakLines(tipText, 400);
        tooltipUntilTic = gametic + PB_HELPNOTIF_DURATION;

        int biggestLength;
        for(int i = 0; i < brokenTooltip.Count(); i++)
        {
            if(brokenTooltip.StringWidth(i) > biggestLength)
                biggestLength = brokenTooltip.StringWidth(i);
        }

        tooltipBoxPos = (14, 14);
        tooltipBoxSize = (biggestLength, mBoldFont.mFont.GetHeight() * brokenTooltip.Count()) + (20, 20); // 10px padding

        S_StartSound("visor/helpnotification", CHAN_AUTO);
    }

    const TOOLTIP_SCALE = 0.75;

    void DrawTooltip()
    {
        if(gametic > tooltipUntilTic || !brokenTooltip) 
            return;
			
		vector2 hudScale = GetHUDScale() * TOOLTIP_SCALE;

        Screen.Dim(
            0x000000, 0.75,
            tooltipBoxPos.x, tooltipBoxPos.y, 
            tooltipBoxSize.x * hudScale.x, tooltipBoxSize.y * hudScale.y
        );

        for(int i = 0; i < brokenTooltip.Count(); i++)
        {
            Screen.DrawText(
                mBoldFont.mFont,
                Font.CR_WHITE,
                tooltipBoxPos.x + 10 * hudScale.x, tooltipBoxPos.y + (10 + (mBoldFont.mFont.GetHeight() * i)) * hudScale.y,
                brokenTooltip.StringAt(i),
				DTA_ScaleX, hudScale.x, DTA_ScaleY, hudScale.y
            );
        }
    }
}