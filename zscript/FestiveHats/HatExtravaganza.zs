Class FunnyHat : Actor
{
    Default
    {
        -NOGRAVITY;
        -SOLID;
        +FLOORCLIP;
        Gravity 0.1;
        Mass 1;
    }
    
    int ActorSpriteHeight;
    int ActorSpriteWidth;
    
    override void Tick()
    {
        Super.Tick();
        if(master && master.health >= 1)
        {
            [ActorSpriteWidth, ActorSpriteHeight] = TexMan.GetSize(master.CurState.GetSpriteTexture(master.SpriteRotation));
            A_Warp(AAPTR_MASTER,0,0,(ActorSpriteHeight - 4),0,WARPF_INTERPOLATE|WARPF_NOCHECKPOSITION|WARPF_USECALLERANGLE|WARPF_BOB|WARPF_COPYVELOCITY);
        }
    }
	
	action void A_TimeCheck()
	{
		let event = PB_EventHandler(EventHandler.Find("PB_EventHandler"));
		int Month = event.HatMonth;
		//Console.Printf("\c[Sapphire]Is Thursday?: %d", IsThursday);
		switch (Month)
		{
			case 1:
				SetStateLabel("January");
				break;
			case 2:
				SetStateLabel("February");
				break;
			case 3:
				SetStateLabel("March");
				break;
			case 4:
				SetStateLabel("April");
				break;
			case 5:
				SetStateLabel("May");
				break;
			case 6:
				SetStateLabel("June");
				break;
			case 7:
				SetStateLabel("July");
				break;
			case 8:
				SetStateLabel("August");
				break;
			case 9:
				SetStateLabel("September");
				break;
			case 10:
				SetStateLabel("October");
				break;
			case 11:
				SetStateLabel("November");
				break;
			case 12:
				SetStateLabel("December");
				break;
			default:
				break;
		}
	}
    
    States
    {
        Spawn:
			TNT1 A 0;
			TNT1 A 35 A_TimeCheck();
			loop;
		January:
			KRHT T -1;
            stop;
		February:
			TNT1 A 1;
            stop;
		March:
			TNT1 A 1;
            stop;
		April:
			KRHT U -1;
            stop;
		May:
			KRHT V -1;
            stop;
		June:
			TNT1 A 1;
            stop;
		July:
			KRHT Y -1;
            stop;
		August:
			TNT1 A 1;
            stop;
		September:
			TNT1 A 1;
            stop;
		October:
			KRHT W -1;
            stop;
		November:
			KRHT X -1;
            stop;
		December:
            KRHT Z -1;
            stop;
    }
}