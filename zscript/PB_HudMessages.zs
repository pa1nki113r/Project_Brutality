extend class PB_Hud_ZS
{
	array<MsgLine> MainQueue;
    double fractic, curtime, msgalpha;
	int midtic, midtype;
	string midstr;
	transient BrokenLines midl;
	
	const MAXSHOWN = 5;
	const MAXPICKUP = 5;
	const CHATDURATION = 25;
	const MSGDURATION = 5;
	const PICKDURATION = 3;
	
	override void FlushNotify()
	{
		if(level.maptime <= 1) 
		{ 
			MainQueue.Clear(); 
			midstr = "";
			midtic = 0;
			return; 
		}
		
		for(int i = 0; i < MainQueue.Size(); i++)
		{
			if(MainQueue[i].type >= PRINT_CHAT) 
				continue;
				
			MainQueue.Delete(i); 
			i--;
		}
	}
	
	override bool ProcessMidPrint(font fnt,string msg,bool bold)
	{
		string lastmidstr = midstr;
		if(!fnt || (fnt == smallfont))
		{
			midstr = msg;
			midtic = level.totaltime;
			midtype = bold?2:0;
			if(midl) midl.Destroy();
			if((msg == lastmidstr) || (msg == "")) return true;
			Console.PrintfEx(PRINT_HIGH|PRINT_NONOTIFY,msg);
			return true;
		}
		if((fnt == bigfont)||(fnt == originalbigfont))
		{
			midstr = msg;
			midtic = level.totaltime;
			midtype = bold?3:1;
			if(midl) midl.Destroy();
			if((msg == lastmidstr) || (msg == "")) return true;
			Console.PrintfEx(PRINT_HIGH|PRINT_NONOTIFY,msg);
			return true;
		}
		return false;
	}
	
	override bool ProcessNotify(EPrintLevel printlevel, string outline)
	{
		if(gamestate != GS_LEVEL || consoleState == c_down) return false;
		int rprintlevel = printlevel & PRINT_TYPES;
		if((rprintlevel < PRINT_LOW) || (rprintlevel > PRINT_TEAMCHAT)) 
			rprintlevel = PRINT_HIGH;
			
		outline.DeleteLastCharacter();
		
		let m = new("MsgLine");
		m.messagestring = outline; 
		m.type = rprintlevel;
		m.tick = level.totaltime; 
		m.stack = 1;
		
		if(MainQueue.Size() > 0 && MainQueue[MainQueue.Size() - 1].messagestring == m.messagestring) 
		{
			m.stack += MainQueue[MainQueue.Size() - 1].stack;
			MainQueue.Delete(MainQueue.Size() - 1); 
		}
			
		m.UpdateText(); 
		MainQueue.Push(m); 
		return true;
	}
	
	void PBHUD_TickMessages()
	{
		for(int i = 0; i < MainQueue.Size(); i++)
		{
			if((MainQueue[i].type == PRINT_LOW) && (level.totaltime < (MainQueue[i].tick + GameTicRate * PICKDURATION))) 
				continue;
			else if((MainQueue[i].type <= PRINT_HIGH && MainQueue[i].type > PRINT_LOW) && (level.totaltime < (MainQueue[i].tick + GameTicRate * MSGDURATION))) 
				continue;
			else if((MainQueue[i].type>PRINT_HIGH)&&(level.totaltime<(MainQueue[i].tick+GameTicRate*CHATDURATION))) 
				continue;
				
			MainQueue.Delete(i); 
			i--;
		}
		if((midstr != "")&&((midtic+int(GameTicRate*con_midtime)) < level.totaltime))
		{
			midstr = "";
			midtic = 0;
			if(midl) midl.Destroy();
		}
	}
	
	void PBHUD_DrawMessages()
	{
		if(midstr!="")
		{
			int midy = -50;
			int col = (midtype&2)?msgmidcolor2:msgmidcolor;
			double curtime = (midtic+int(GameTicRate*con_midtime))-(level.totaltime+fractic);
			double alph = clamp(curtime/20.,0.,1.);
			if(!midl)
			{
				if(midl) midl.Destroy();
				midl = Font.GetFont("SmallFont").BreakLines(midstr,284);
			}
			int maxlen = 0;
			for(int i=0;i<midl.Count();i++)
			{
				maxlen = max(maxlen,Font.GetFont("SmallFont").StringWidth(midl.StringAt(i)));
				PBHud_DrawString(mBoldFont,midl.StringAt(i),(0,midy),DI_SCREEN_CENTER|DI_TEXT_ALIGN_CENTER,col,alph);
				midy+=10;
			}
		}
		
		if(MainQueue.Size() <= 0) 
			return;
			
		int mstart = max(0, MainQueue.Size() - MAXSHOWN); 
		int yy = 0;
		for(int i = mstart; i < MainQueue.Size(); i++)
		{
			let brokentext = MainQueue[i].brokentext;
			curtime = MainQueue[i].tick - (level.totaltime + fractic);
			
			if(MainQueue[i].type == PRINT_LOW) 
				curtime += GameTicRate * PICKDURATION;
			else if(MainQueue[i].type < PRINT_CHAT) 
				curtime += GameTicRate * MSGDURATION;
			else 
				curtime += GameTicRate * CHATDURATION;
				
			msgalpha = clamp(curtime / 20.0, 0.0, 1.0);
			for(int j = 0; j < brokentext.Count(); j++)
			{
				if(centerNotify)
					PBHud_DrawString(mBoldFont, brokentext.StringAt(j), (0,17 + yy * messageSize), DI_SCREEN_CENTER_TOP | DI_ITEM_TOP | DI_TEXT_ALIGN_CENTER, MainQueue[i].fontcolor, msgalpha, scale: (messageSize, messageSize));
				else
					PBHud_DrawString(mBoldFont, brokentext.StringAt(j), (15, 17 + (showLevelStats ? 55 : 0) + yy * messageSize), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP | DI_TEXT_ALIGN_LEFT, MainQueue[i].fontcolor, msgalpha, scale: (messageSize, messageSize));
				yy += 20;
			}
		}
	}
}

class MsgLine
{
	string nstring, messagestring;
	int tick, type, stack, laststack, fontcolor;
	transient BrokenLines brokentext;

	void UpdateText()
	{
		bool mustupdate = (!brokentext || (laststack != stack) || (type == PRINT_LOW));
		
		if(!mustupdate) 
			return;
			
		if(brokentext) 
			brokentext.Destroy();
			
		laststack = stack; 
		nstring = messagestring;
		
		if(type <= 4) fontcolor = CVar.GetCVar("msg"..String.Format("%i", type).."color").GetInt();
		else 
			fontcolor = 0;
		
		if(stack > 1) 
			nstring.AppendFormat("\cj (%dx)",stack);
		
		brokentext = Font.GetFont('SmallFont').BreakLines(nstring, (type == PRINT_LOW) ? 384 : 464);
	}
}
