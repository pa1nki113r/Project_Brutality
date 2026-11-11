class PB_ListMenu : ListMenu 
{
    PBTK_UIController controller;
    array<PBTK_Button> buttons;
    int btnSelection;

    TextureID pblogo, dtlogo;

    override void Init(Menu parent, ListMenuDescriptor desc)
	{
		//Super.Init(parent);

        mParentMenu = parent;
		mMouseCapture = false;
		mBackbuttonSelected = false;
		DontDim = true;
		DontBlur = false;
		AnimatedTransition = false;
		Animated = true;

        int yy;
        mDesc = desc;
        controller = PBTK_UIController.Create(PBTK_SCREEN_BOTTOM_LEFT);
        controller.glbStartPos = (115, -23);
        PBTK_Button leButton;

        S_StartSound("menu/whoosh", 0, CHANF_UI, pitch: cfrandom(0.8, 0.9));

		for(int i = 0; i < mDesc.mItems.Size(); i++)
        {
            ListMenuItem item = mDesc.mItems[i];
            if(!item) continue;

            if(item is 'ListMenuItemTextItem')
            {
                let textitem = ListMenuItemTextItem(item);
                leButton = PBTK_Button.InitButton(
                    (-240, 0), 
                    cft("graphics/menu/button_inactive.png"), 
                    cft("graphics/menu/button_active.png"), 
                    cft("graphics/menu/button_hovered.png"), 
                    cft("graphics/menu/button_clicked.png"),
                    controller,
                    textitem.mText,
                    i,
                    mDesc
                );
                leButton.btnAlpha = 0;
                leButton.goalPos = (0, 0);
                leButton.myItem = item;
                buttons.Push(leButton);

                if(CheckFocus(item))
                    btnSelection = buttons.Size() - 1;
            }
        }
	}
    
    override void Ticker()
    {
        controller.ControllerTick();

        switch(controller.transitioning)
        {
            case PBTK_UIController.TR_GOBACK:
                if(controller.transitionTicks <= 0)
                {
                    Close();
                    return;
                }
                break;
        }

        for(int i = 0; i < buttons.Size(); i++)
        {
            buttons[i].UpdateAnimations();
        }
    }

    override void Drawer()
    {
        for(int i = 0; i < buttons.Size(); i++)
        {
            bool selected = (i == btnSelection);
            buttons[i].Draw(selected, mDesc, (buttons.Size() - 1) - i);
        }
    }

    TextureID cft(string tex)
    {
        return TexMan.CheckForTexture(tex);
    }

    override bool OnInputEvent(InputEvent ev)
	{
		return false;
	}

    override bool MenuEvent(int mkey, bool fromcontroller)
	{
		//OnMenuThink();
		//if(!mMouse) return false;
		
        //if(transitioning) return true;

        if(controller.transitioning != PBTK_UIController.TR_NONE) {
            if(mkey == MKEY_Back && controller.transitioning == PBTK_UIController.TR_GOFORWARD) {
                controller.transitioning = PBTK_UIController.TR_NONE;
                controller.transitionTicks = 0;
            }
            return true;
        }
        
		switch (mkey)
		{
            case MKEY_Up:
                btnSelection--;
                if(btnSelection < 0) btnSelection = buttons.Size() - 1;
                MenuSound("menu/cursor");
                //mMouse.SetPos(buttons[btnSelection].btnrect.pos);
                return true;
            case MKEY_Down:
                btnSelection++;
                if(btnSelection > buttons.Size() - 1) btnSelection = 0;
                MenuSound("menu/cursor");
                //mMouse.SetPos(buttons[btnSelection].btnrect.pos);
                return true;
            case MKEY_Enter:
                if(btnSelection >= 0 && btnSelection <= buttons.Size()-1 /*&& mDesc.mItems[buttons[btnSelection].descriptorIndex].Activate()*/) 
                {
                    controller.transitioning = PBTK_UIController.TR_GOFORWARD;
                    buttons[btnSelection].clicked = 1;
                    controller.transitionTicks = 8;
                    MenuSound("menu/activate");
                    S_StartSound("RAIL_ZM", 0, CHANF_UI, pitch: 0.8);
                    //S_StartSound("menu/whoosh", 0, CHANF_UI, pitch: cfrandom(0.9, 1.0));
                }
                return true;
            case MKEY_Back:
                if(btnSelection >= 0 && btnSelection <= buttons.Size()-1 /*&& mDesc.mItems[buttons[btnSelection].descriptorIndex].Activate()*/) 
                {
                    controller.transitioning = PBTK_UIController.TR_GOBACK;
                    buttons[btnSelection].clicked = 0;
                    controller.transitionTicks = 8;
                    MenuSound(mParentMenu ? "menu/backup" : "menu/clear");
                    S_StartSound("RAIL_UZ", 0, CHANF_UI, pitch: 0.8);
                    //if (!m) menuDelegate.MenuDismissed();
                    //S_StartSound("menu/whoosh", 0, CHANF_UI, pitch: cfrandom(0.9, 1.0));
                }
                return true;
            default:
                return Super.MenuEvent(mkey, fromcontroller);
		}
		return false;
	}
}

class PB_TitleLogoHandler : EventHandler
{
    TextureID pblogo, dtlogo;

    override void WorldLoaded(WorldEvent e)
    {
        pblogo = TexMan.CheckForTexture("HIRES/M_DOOMPB.png");
        dtlogo = TexMan.CheckForTexture("graphics/menu/pb_devteam_logo.png");
    }

    override void RenderOverlay(RenderEvent e)
    {
        if(gamestate != GS_TITLELEVEL) return;

        PBTK_StatusBarScreen.DrawTexture(pblogo, (0, -100), PBTK_SCREEN_CENTER, scale: (0.25, 0.25));
        PBTK_StatusBarScreen.DrawTexture(dtlogo, (-50, -50), PBTK_SCREEN_BOTTOM_RIGHT, scale: (0.25, 0.25));
        //PBTK_StatusBarScreen.DrawString(newsmallfont, "[ PRESS ANY KEY ]", (0, -50), PBTK_TEXT_CENTER | PBTK_SCREEN_CENTER);
    }
}