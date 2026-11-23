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

	static clearscope string PB_FormatKeybinds(string cmd) {
		array<int> keys;
		Bindings.GetAllKeysForCommand(keys, cmd);
		string keystr = "\cl\cv"..Bindings.NameAllKeys(keys, false).."\cl"; //get buttons and colorize
		keystr.Replace(", ","\cl/\cv"); //clean up the separators
		switch(CVar.GetCVar("pb_button_prompt_type", players[consoleplayer]).GetInt()) {
		default:
		case 0:
			keystr.replace("\cvLStickRight\cl", string.format("%c", 0x12000));
			keystr.replace("\cvLStickLeft\cl", string.format("%c", 0x12001));
			keystr.replace("\cvLStickDown\cl", string.format("%c", 0x12002));
			keystr.replace("\cvLStickUp\cl", string.format("%c", 0x12003));
			
			keystr.replace("\cvRStickRight\cl", string.format("%c", 0x12000));
			keystr.replace("\cvRStickLeft\cl", string.format("%c", 0x12001));
			keystr.replace("\cvRStickDown\cl", string.format("%c", 0x12002));
			keystr.replace("\cvRStickUp\cl", string.format("%c", 0x12003));
			
			keystr.replace("\cvDPadUp\cl", string.format("%c", 0x12004));
			keystr.replace("\cvDPadDown\cl", string.format("%c", 0x12005));
			keystr.replace("\cvDPadLeft\cl", string.format("%c", 0x12006));
			keystr.replace("\cvDPadRight\cl", string.format("%c", 0x12007));
			keystr.replace("\cvPad_Start\cl", string.format("%c", 0x12008));
			keystr.replace("\cvPad_Back\cl", string.format("%c", 0x12009));
			keystr.replace("\cvLThumb\cl", string.format("%c", 0x1200A));
			keystr.replace("\cvRThumb\cl", string.format("%c", 0x1200A));
			keystr.replace("\cvLShoulder\cl", string.format("%c", 0x1200B));
			keystr.replace("\cvRShoulder\cl", string.format("%c", 0x1200C));
			keystr.replace("\cvLTrigger\cl", string.format("%c", 0x1200D));
			keystr.replace("\cvRTrigger\cl", string.format("%c", 0x1200E));
			
			keystr.replace("\cvPad_A\cl", string.format("%c", 0x1200F));
			keystr.replace("\cvPad_B\cl", string.format("%c", 0x12010));
			keystr.replace("\cvPad_X\cl", string.format("%c", 0x12011));
			keystr.replace("\cvPad_Y\cl", string.format("%c", 0x12012));
			
			keystr.replace("\cvGuide\cl", string.format("%c", 0x1201F));
			keystr.replace("\cvPad_Misc\cl", string.format("%c", 0x12030));
		case 1:
			keystr.replace("\cvLStickRight\cl", string.format("%c", 0x12013));
			keystr.replace("\cvLStickLeft\cl", string.format("%c", 0x12014));
			keystr.replace("\cvLStickDown\cl", string.format("%c", 0x12015));
			keystr.replace("\cvLStickUp\cl", string.format("%c", 0x12016));
			
			keystr.replace("\cvRStickRight\cl", string.format("%c", 0x12013));
			keystr.replace("\cvRStickLeft\cl", string.format("%c", 0x12014));
			keystr.replace("\cvRStickDown\cl", string.format("%c", 0x12015));
			keystr.replace("\cvRStickUp\cl", string.format("%c", 0x12016));
			
			keystr.replace("\cvDPadUp\cl", string.format("%c", 0x12017));
			keystr.replace("\cvDPadDown\cl", string.format("%c", 0x12018));
			keystr.replace("\cvDPadLeft\cl", string.format("%c", 0x12019));
			keystr.replace("\cvDPadRight\cl", string.format("%c", 0x1201A));
			keystr.replace("\cvPad_Start\cl", string.format("%c", 0x1201B));
			keystr.replace("\cvPad_Back\cl", string.format("%c", 0x1201C));
			keystr.replace("\cvLThumb\cl", string.format("%c", 0x1201D));
			keystr.replace("\cvRThumb\cl", string.format("%c", 0x1201D));
			keystr.replace("\cvLShoulder\cl", string.format("%c", 0x1201E));
			keystr.replace("\cvRShoulder\cl", string.format("%c", 0x1201F));
			keystr.replace("\cvLTrigger\cl", string.format("%c", 0x12020));
			keystr.replace("\cvRTrigger\cl", string.format("%c", 0x12021));
			
			keystr.replace("\cvPad_A\cl", string.format("%c", 0x12022));
			keystr.replace("\cvPad_B\cl", string.format("%c", 0x12023));
			keystr.replace("\cvPad_X\cl", string.format("%c", 0x12024));
			keystr.replace("\cvPad_Y\cl", string.format("%c", 0x12025));
		}
		keystr.replace("\cvMouse1\cl", string.format("%c", 0x12026));
		keystr.replace("\cvMouse2\cl", string.format("%c", 0x12027));
		keystr.replace("\cvMouse3\cl", string.format("%c", 0x12028));
		keystr.replace("\cvMouse4\cl", string.format("%c", 0x12029));
		keystr.replace("\cvMouse5\cl", string.format("%c", 0x1202A));
		
		keystr.replace("\cvMWheelUp\cl", string.format("%c", 0x1202B));
		keystr.replace("\cvMWheelDown\cl", string.format("%c", 0x1202C));
		keystr.replace("\cvMWheelRight\cl", string.format("%c", 0x1202D));
		keystr.replace("\cvMWheelLeft\cl", string.format("%c", 0x1202E));
		return keystr;
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
        console.printfex(PRINT_NONOTIFY, StringTable.Localize(tipText));
        if(!sb) return;
        sb.UpdateTooltip(StringTable.Localize(tipText));
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