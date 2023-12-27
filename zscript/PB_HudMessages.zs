extend class PB_HUD_ZS
{
	array<MsgLine> MainQueue;
    double fractic,curtime,alph;
	
	const MAXSHOWN = 5;
	const MAXPICKUP = 5;
	const CHATDURATION = 25;
	const MSGDURATION = 5;
	const PICKDURATION = 3;
	
	override void FlushNotify()
	{
		if(level.maptime<=1) { MainQueue.Clear(); return; }
		for(int i=0;i<MainQueue.Size();i++)
		{
			if(MainQueue[i].type >= PRINT_CHAT) continue;
			MainQueue.Delete(i); i--;
		}
	}
	
	override bool ProcessNotify(EPrintLevel printlevel,string outline)
	{
		if(gamestate != GS_LEVEL || consoleState == c_down) return false;
		int rprintlevel = printlevel&PRINT_TYPES;
		if((rprintlevel < PRINT_LOW)||(rprintlevel > PRINT_TEAMCHAT)) rprintlevel = PRINT_HIGH;
		outline.DeleteLastCharacter(); let m = new("MsgLine");
		m.str = outline; m.type = rprintlevel;
		m.tic = level.totaltime; m.rep = 1;
		for(int i=0;i<MainQueue.Size();i++)
		{
			if(MainQueue[i].str != m.str) continue;
			m.rep += MainQueue[i].rep;
			MainQueue.Delete(i); break;
		}
		m.UpdateText(); MainQueue.Push(m); return true;
	}
	
	void PBHUD_TickMessages()
	{
		for(int i=0;i<MainQueue.Size();i++)
		{
			if((MainQueue[i].type==PRINT_LOW)&&(level.totaltime<(MainQueue[i].tic+GameTicRate*PICKDURATION))) continue;
			else if((MainQueue[i].type<=PRINT_HIGH&&MainQueue[i].type>PRINT_LOW)&&(level.totaltime<(MainQueue[i].tic+GameTicRate*MSGDURATION))) continue;
			else if((MainQueue[i].type>PRINT_HIGH)&&(level.totaltime<(MainQueue[i].tic+GameTicRate*CHATDURATION))) continue;
			MainQueue.Delete(i); i--;
		}
	}
	
	void PBHUD_DrawMessages()
	{
		if(MainQueue.Size()<=0) return;
		int mstart = max(0,MainQueue.Size()-MAXSHOWN); int yy = 0;
		for(int i=mstart;i<MainQueue.Size();i++)
		{
			let l = MainQueue[i].l;
			curtime = MainQueue[i].tic-(level.totaltime+fractic);
			if(MainQueue[i].type == PRINT_LOW) curtime += GameTicRate*PICKDURATION;
			else if(MainQueue[i].type < PRINT_CHAT) curtime += GameTicRate*MSGDURATION;
			else curtime += GameTicRate*CHATDURATION;
			alph = clamp(curtime/20.,0.,1.);
			for(int j=0;j<l.Count();j++)
			{
				if(centerNotify)
					PBHud_DrawString(mBoldFont,l.StringAt(j), (0,17 + yy * messageSize), DI_SCREEN_CENTER_TOP | DI_ITEM_TOP | DI_TEXT_ALIGN_CENTER,MainQueue[i].fcol,alph,scale: (messageSize, messageSize));
				else
					PBHud_DrawString(mBoldFont,l.StringAt(j), (15,17 + (showLevelStats ? 55 : 0) + yy * messageSize), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP | DI_TEXT_ALIGN_LEFT,MainQueue[i].fcol,alph,scale: (messageSize, messageSize));
				yy+=20;
			}
		}
	}
}

class MsgLine
{
	string nstr,str;
	int tic,type,rep,lastrep,fcol;
	transient BrokenLines l;

	void UpdateText()
	{
		bool mustupdate = (!l||(lastrep!=rep)||(type==PRINT_LOW));
		if(!mustupdate) return;
		if(l) l.Destroy();
		lastrep = rep; nstr = str;
		if(type<=4) fcol = CVar.GetCVar("msg"..String.Format("%i",type).."color").GetInt();
		else fcol = 0;
		if(rep>1) nstr.AppendFormat("\cj (x%d)",rep);
		l =  Font.GetFont('SmallFont').BreakLines(nstr,(type==PRINT_LOW)?384:464);
	}
}
