Class PB_DoomStatusScreen : DoomStatusScreen
{
	bool fade; double fa;
	font IntFont; int st;
	textureid flash;
	
	override void Start(wbstartstruct wbstartstruct)
	{
		Super.Start(wbstartstruct);
		IntFont = Font.GetFont("PBFont");
		st = sp_state;
		fa = 1; fade = false;
		flash = TexMan.CheckForTexture("Graphics/intnone.png");
	}
	
	override void Ticker()
	{
		bcnt++;
		if(bcnt == 1) { S_ChangeMusic(""); PlaySound("inter_endmap"); }
		if(bcnt == 24) { StartMusic(); fade = true; }
		if(fade&&fa>0) fa-=0.085;
		bg.updateAnimatedBack();
		switch(CurState)
		{
			case StatCount: updateStats(); break;
			case ShowNextLoc: updateShowNextLoc(); break;
			case NoState: updateNoState(); break;
			case LeavingIntermission: break;
		}
	}
	
	override void Drawer()
	{
		widescreenGraphic();
		Super.Drawer();
		screen.DrawTexture(flash,true,0,0,DTA_ScaleX,2000,DTA_ScaleY,2000,DTA_Alpha,fa);
	}	
	
	void widescreenGraphic()
	{
		TextureID interborder = TexMan.CheckForTexture("INTBACK",TexMan.Type_MiscPatch);
		Vector2 borderSize = TexMan.GetScaledSize(interborder);
		Vector2 interpicTL,interpicRS;
		[interpicTL,interpicRS] = Screen.VirtualToRealCoords((0,0),(640,400),(640,400));
		screen.DrawTexture(interborder,true,interPicTL.x-borderSize.x*CleanXFac,-64,DTA_CleanNoMove,true);
		screen.DrawTexture(interborder,true,interPicTL.x+interPicRS.x,-64,DTA_CleanNoMove,true);
	}
	
	bool Perfect()
	{
		if(cnt_kills[0]==wbs.maxkills&&cnt_items[0]==wbs.maxitems&&cnt_secret[0]==wbs.maxsecret) return true;
		else return false;
	}
	
	override void drawEL()
	{
		DrawMiscText(115,pbcv_inter?40:-47,"Next stop");
		DrawName((pbcv_inter?110:20)*scaleFactorY,wbs.LName1,lnametexts[1]);
	}
	
	override bool OnEvent(InputEvent evt)
	{
		if(evt.type == InputEvent.Type_KeyDown )
		{
			String cmd = Bindings.GetBinding(evt.KeyScan);
			if((cmd ~== "+attack")||(cmd ~== "+use")||(evt.KeyScan==InputEvent.KEY_ENTER)) //KEY_ENTER for DTouch users
			{ accelerateStage = 1; return true; }
			return false;
		}
		return false;
	}
	
	override void updateStats()
	{
		int sec = Thinker.Tics2Seconds(Plrs[me].stime);
		int tsec = Thinker.Tics2Seconds(wbs.totaltime);
		int psec = wbs.partime/Thinker.TICRATE;
		if(acceleratestage && st < 20)
		{
			acceleratestage = 0;
			st = 20;
			fade = true;
			PlaySound("inter_stop");
			cnt_kills[0] = Plrs[me].skills;
			cnt_items[0] = Plrs[me].sitems;
			cnt_secret[0] = Plrs[me].ssecret;
			cnt_time = Thinker.Tics2Seconds(Plrs[me].stime);
			cnt_par = Thinker.Tics2Seconds(wbs.partime);
			cnt_total_time = Thinker.Tics2Seconds(wbs.totaltime);
		}
		if(st&1)
		{ if(!--cnt_pause) { st++; cnt_pause = Thinker.TICRATE; } }
		switch(st)
		{
			case 2: case 6: case 10: case 16: PlaySound("inter_next"); st++; break;
			case 4:
				if(intermissioncounter)
				{
					cnt_kills[0] += max((Plrs[me].skills-cnt_kills[0])/10,2);
					if(!(bcnt&2)) PlaySound("inter_count");
				}
				if(!intermissioncounter||(cnt_kills[0]>=Plrs[me].skills))
				{
					cnt_kills[0] = Plrs[me].skills;
					if(Plrs[me].skills >= wbs.maxkills) PlaySound("inter_maxkills");
					else PlaySound("inter_stop");
					st++;
				} break;
			case 8:
				if(intermissioncounter)
				{
					cnt_items[0] += max((Plrs[me].sitems-cnt_items[0])/10,2);
					if(!(bcnt&2)) PlaySound("inter_count");
				}
				if(!intermissioncounter||cnt_items[0]>=Plrs[me].sitems)
				{
					cnt_items[0] = Plrs[me].sitems;
					if(Plrs[me].sitems >= wbs.maxitems) PlaySound("inter_maxitems");
					else PlaySound("inter_stop");
					st++;
				} break;
			case 12:
				if(intermissioncounter)
				{
					cnt_secret[0] += max((Plrs[me].ssecret-cnt_secret[0])/10,2);
					if(!(bcnt&2)) PlaySound("inter_count");
				}
				if(!intermissioncounter||cnt_secret[0]>=Plrs[me].ssecret)
				{
					cnt_secret[0] = Plrs[me].ssecret;
					if(Plrs[me].ssecret >= wbs.maxsecret) PlaySound("inter_maxsecrets");
					else PlaySound("inter_stop");
					st++;
				} break;
			case 14:
				if(Perfect()) { PlaySound("inter_perfect"); st++; }
				else { st = 16; } break;
			case 18:
				if(intermissioncounter)
				{
					if(!(bcnt&2)) PlaySound("inter_count");
					cnt_time += max((sec-cnt_time)/10,2);
					cnt_par += max((psec-cnt_par)/10,2);
					cnt_total_time += max((tsec-cnt_total_time)/10,2);
				}
				if(!intermissioncounter||cnt_time >= sec) cnt_time = sec;
				if(!intermissioncounter||cnt_total_time >= tsec) cnt_total_time = tsec;
				if(!intermissioncounter||cnt_par >= psec)
				{
					cnt_par = psec;
					if(cnt_time >= sec)
					{
						cnt_total_time = tsec;
						PlaySound("inter_stop");
						st++;
					}
				} break;
			case 20:
				if(acceleratestage) { PlaySound("inter_nextlevel"); initShowNextLoc(); } break;
		}
	}
	
	void DrawMiscText(int x,int y, string s)
	{ screen.DrawText(IntFont,Font.CR_UNTRANSLATED,x,y,s,DTA_Clean,true,DTA_Shadow,true); }
	
	void DrawStatCount(int a,int b,int y)
	{
		if(!b) DrawMiscText(290-SP_STATSX,y,"\cfN/A");
		else DrawPercent(IntFont,320-SP_STATSX,y,a,b,true,(a>=b)?Font.CR_GOLD:Font.CR_UNTRANSLATED);
	}
	
	void DrawStatText(int y,string s)
	{ screen.DrawText(IntFont,Font.CR_UNTRANSLATED,SP_STATSX,y,s,DTA_Clean,true,DTA_Shadow,true); }
	
	void DrawStatTime(int a,int y,bool tfc)
	{
		int fc;
		if(tfc) fc = (wbs.partime&&(cnt_time<=(wbs.partime/GameTicRate)))?Font.CR_GOLD:(cnt_time>=3600)?Font.CR_RED:Font.CR_UNTRANSLATED;
		else fc = Font.CR_UNTRANSLATED;
		DrawTimeFont(IntFont,320-SP_STATSX,y,a,fc);
	}

	override void drawStats()
	{
		int lh = IntermissionFont.GetHeight() * 3 / 2;
		DrawMiscText(100,-30,"You survived");
		DrawName((40)*scaleFactorY,wbs.LName0,lnametexts[0]);
		//Kills/Items/Secrets row
		if(st >= 2) DrawStatText(SP_STATSY-3,"Kills");
		if(st >= 4) DrawStatCount(cnt_kills[0],wbs.maxkills,SP_STATSY-3);
		if(st >= 6) DrawStatText(SP_STATSY+lh-3,"Items");
		if(st >= 8) DrawStatCount(cnt_items[0],wbs.maxitems,SP_STATSY+lh-3);
		if(st >= 10) DrawStatText(SP_STATSY+2*lh-3,"Secrets");
		if(st >= 12) DrawStatCount(cnt_secret[0],wbs.maxsecret,SP_STATSY+2*lh-3);
		if(st >= 14 && Perfect()) DrawMiscText(120,SP_STATSY+3*lh,"\cfPERFECT!");
		if(st >= 16) //Time row
		{
			DrawStatText(SP_STATSY+4*lh-3,"Time");
			if(wi_showtotaltime) DrawStatText(SP_STATSY+5*lh-3,"Total");
			if(wbs.partime) DrawStatText(SP_STATSY+6*lh-3,"Par");
		}
		if(st >= 18)
		{	
			DrawStatTime(cnt_time,SP_STATSY+4*lh-3,true);
			if(wi_showtotaltime) DrawStatTime(cnt_total_time,SP_STATSY+5*lh-3,false);
			if(wbs.partime) DrawStatTime(cnt_par,SP_STATSY+6*lh-3,false);
			//Display "Sucks" if map time > 1 hour
			if(cnt_time>=3600) DrawMiscText(50+SP_STATSX,SP_STATSY+4*lh-3,"\cgSucks");
		}
	}
}