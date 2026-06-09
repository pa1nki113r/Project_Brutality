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
			keystr.replace("\cvLStickRight\cl", "𒀀"); //U+12000
			keystr.replace("\cvLStickLeft\cl", "𒀁"); //U+12001
			keystr.replace("\cvLStickDown\cl", "𒀂"); //U+12002
			keystr.replace("\cvLStickUp\cl", "𒀃"); //U+12003
			
			keystr.replace("\cvRStickRight\cl", "𒀀"); //U+12000
			keystr.replace("\cvRStickLeft\cl", "𒀁"); //U+12001
			keystr.replace("\cvRStickDown\cl", "𒀂"); //U+12002
			keystr.replace("\cvRStickUp\cl", "𒀃"); //U+12003
			
			keystr.replace("\cvDPadUp\cl", "𒀄"); //U+12004
			keystr.replace("\cvDPadDown\cl", "𒀅"); //U+12005
			keystr.replace("\cvDPadLeft\cl", "𒀆"); //U+12006
			keystr.replace("\cvDPadRight\cl", "𒀇"); //U+12007
			keystr.replace("\cvPad_Start\cl", "𒀈"); //U+12008
			keystr.replace("\cvPad_Back\cl", "𒀉"); //U+12009
			keystr.replace("\cvLThumb\cl", "𒀊"); //U+1200A
			keystr.replace("\cvRThumb\cl", "𒀊"); //U+1200A
			keystr.replace("\cvLShoulder\cl", "𒀋"); //U+1200B
			keystr.replace("\cvRShoulder\cl", "𒀌"); //U+1200C
			keystr.replace("\cvLTrigger\cl", "𒀍"); //U+1200D
			keystr.replace("\cvRTrigger\cl", "𒀎"); //U+1200E
			
			keystr.replace("\cvPad_A\cl", "𒀏"); //U+1200F
			keystr.replace("\cvPad_B\cl", "𒀐"); //U+12010
			keystr.replace("\cvPad_X\cl", "𒀑"); //U+12011
			keystr.replace("\cvPad_Y\cl", "𒀒"); //U+12012
			
			keystr.replace("\cvGuide\cl", "𒀯"); //U+1201F
			keystr.replace("\cvPad_Misc\cl", "𒀰"); //U+12030
		case 1:
			keystr.replace("\cvLStickRight\cl", "𒀓"); //U+12013
			keystr.replace("\cvLStickLeft\cl", "𒀔"); //U+12014
			keystr.replace("\cvLStickDown\cl", "𒀕"); //U+12015
			keystr.replace("\cvLStickUp\cl", "𒀖"); //U+12016
			
			keystr.replace("\cvRStickRight\cl", "𒀓"); //U+12013
			keystr.replace("\cvRStickLeft\cl", "𒀔"); //U+12014
			keystr.replace("\cvRStickDown\cl", "𒀕"); //U+12015
			keystr.replace("\cvRStickUp\cl", "𒀖"); //U+12016
			
			keystr.replace("\cvDPadUp\cl", "𒀗"); //U+12017
			keystr.replace("\cvDPadDown\cl", "𒀘"); //U+12018
			keystr.replace("\cvDPadLeft\cl", "𒀙"); //U+12019
			keystr.replace("\cvDPadRight\cl", "𒀚"); //U+1201A
			keystr.replace("\cvPad_Start\cl", "𒀛"); //U+1201B
			keystr.replace("\cvPad_Back\cl", "𒀜"); //U+1201C
			keystr.replace("\cvLThumb\cl", "𒀝"); //U+1201D
			keystr.replace("\cvRThumb\cl", "𒀝"); //U+1201D
			keystr.replace("\cvLShoulder\cl", "𒀞"); //U+1201E
			keystr.replace("\cvRShoulder\cl", "𒀟"); //U+1201F
			keystr.replace("\cvLTrigger\cl", "𒀠"); //U+12020
			keystr.replace("\cvRTrigger\cl", "𒀡"); //U+12021
			
			keystr.replace("\cvPad_A\cl", "𒀢"); //U+12022
			keystr.replace("\cvPad_B\cl", "𒀣"); //U+12023
			keystr.replace("\cvPad_X\cl", "𒀤"); //U+12024
			keystr.replace("\cvPad_Y\cl", "𒀥"); //U+12025
		}
		keystr.replace("\cvMouse1\cl", "𒀦"); //U+12026
		keystr.replace("\cvMouse2\cl", "𒀧"); //U+12027
		keystr.replace("\cvMouse3\cl", "𒀨"); //U+12028
		keystr.replace("\cvMouse4\cl", "𒀩"); //U+12029
		keystr.replace("\cvMouse5\cl", "𒀪"); //U+1202A
		
		keystr.replace("\cvMWheelUp\cl", "𒀫"); //U+1202B
		keystr.replace("\cvMWheelDown\cl", "𒀬"); //U+1202C
		keystr.replace("\cvMWheelRight\cl", "𒀭"); //U+1202D
		keystr.replace("\cvMWheelLeft\cl", "𒀮"); //U+1202E
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