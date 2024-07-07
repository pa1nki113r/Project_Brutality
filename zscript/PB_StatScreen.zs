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
		if(cnt_kills[0]>=wbs.maxkills&&cnt_items[0]>=wbs.maxitems&&cnt_secret[0]>=wbs.maxsecret) return true;
		else return false;
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

	private int GetPercent(int a,int b)
	{
		if(a<0) return 0; if(b<=0) return 100;
		return (a*100)/b;
	}
	
	private string CountStats(int a,int b)
	{
		if(!b) return "\cfN/A";
		return max(a,0).."\cj/\c-"..b.." \cj(\c-"..GetPercent(a,b).."%\cj)";
	}
	
	private string TimeString(int t)
	{
		t= max(t,0); int h = t/3600; int m = (t/60)%60; int s = t%60;
		if(h) return String.Format("%02d:%02d:%02d",h,m,s);
		return String.Format("%02d:%02d",m,s);
	}
	
	private bool AllStats(int a,int b) { return a>=b; }

	private void PB_DrawText(int x,int y, string s,int f = Font.CR_UNTRANSLATED)
	{
		screen.DrawText(IntFont,f,x,y,s,DTA_VirtualWidth,1280,DTA_VirtualHeight,1024,
		DTA_FullScreenScale,FSMode_ScaleToFit43,DTA_ScaleX,3.4,DTA_ScaleY,3.4);
	}
	
	private void PB_DrawName(int y,textureID tex,string levelname)
	{
		if(tex.IsValid())
		{
			let size = TexMan.GetScaledSize(tex);
			double x = 160-(size.x*0.5);
			screen.DrawTexture(tex,false,x,y,DTA_VirtualWidth,320,DTA_VirtualHeight,200,
			DTA_FullScreenScale,FSMode_ScaleToFit43,DTA_ScaleX,1,DTA_ScaleY,0.8);
			if(size.y>50) size.y = TexMan.CheckRealHeight(tex);
		}
		else if(levelname.Length()>0)
		{
			int h = 0; int lumph = mapname.mFont.GetHeight()*scaleFactorY;
			BrokenLines lines = mapname.mFont.BreakLines(levelname,wrapwidth/scaleFactorX);
			for(int i=0;i<lines.Count();i++)
			{
				double x = 160-(lines.StringWidth(i)*0.5);
				screen.DrawText(mapname.mFont,mapname.mColor,x,y+h,lines.StringAt(i),
				DTA_VirtualWidth,320,DTA_VirtualHeight,200,DTA_FullScreenScale,FSMode_ScaleToFit43,
				DTA_ScaleX,1,DTA_ScaleY,0.8); h+=lumph;
			}
		}
	}

	override void drawEL()
	{
		PB_DrawText(502,pbcv_inter?300:0,"Next stop",Font.CR_CYAN);
		PB_DrawName(pbcv_inter?70:13,wbs.LName1,lnametexts[1]);
	}

	override void drawStats()
	{
		int lh = IntFont.GetHeight()*3/2;
		double xx = 50; double yy = xx*6+30;
		double x1 = xx*6+13; double x2 = xx*13;
		int ck = cnt_kills[0]; int tk = wbs.maxkills;
		int ci = cnt_items[0]; int ti = wbs.maxitems;
		int cs = cnt_secret[0]; int ts = wbs.maxsecret;
		PB_DrawText(xx*9+1,pbcv_inter?70:0,"You survived",Font.CR_CYAN);
		PB_DrawName(pbcv_inter?27:13,wbs.LName0,lnametexts[0]);
		//Kills/Items/Secrets row
		if(st>=2) PB_DrawText(x1,yy,"Kills",Font.CR_CYAN);
		if(st>=4) PB_DrawText(x2,yy,CountStats(ck,tk),AllStats(ck,tk)?Font.CR_GOLD:Font.CR_UNTRANSLATED); yy+=2*lh;
		if(st>=6) PB_DrawText(x1,yy,"Items",Font.CR_CYAN);
		if(st>=8) PB_DrawText(x2,yy,CountStats(ci,ti),AllStats(ci,ti)?Font.CR_GOLD:Font.CR_UNTRANSLATED); yy+=2*lh;
		if(st>=10) PB_DrawText(x1,yy,"Secrets",Font.CR_CYAN);
		if(st>=12) PB_DrawText(x2,yy,CountStats(cs,ts),AllStats(cs,ts)?Font.CR_GOLD:Font.CR_UNTRANSLATED); yy+=3*lh;
		if(st>=14&&Perfect()) PB_DrawText(xx*10,yy,"\cfPERFECT!"); yy+=3*lh;
		if(st>=16) //Time row
		{
			PB_DrawText(x1,yy,"Time",Font.CR_CYAN); yy+=2*lh;
			PB_DrawText(x1,yy,"Total",Font.CR_CYAN); yy+=2*lh;
			if(wbs.partime) PB_DrawText(x1,yy,"Par",Font.CR_CYAN); yy-=4*lh;
		}
		if(st>=18)
		{
			int fc = (wbs.partime&&(cnt_time<=(wbs.partime/GameTicRate)))?Font.CR_GOLD:(cnt_time>=3600)?Font.CR_RED:Font.CR_UNTRANSLATED;
			PB_DrawText(x2,yy,TimeString(max(cnt_time,0)),fc); yy+=2*lh;
			PB_DrawText(x2,yy,TimeString(max(cnt_total_time,0))); yy+=2*lh;
			if(wbs.partime) PB_DrawText(x2,yy,TimeString(max(cnt_par,0)));
		}
	}
}