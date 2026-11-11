#include "./SBS.zs"

#include "./PBTK_Collider.zs"
#include "./PBTK_Controller.zs"

class PBTK_Button ui
{
    vector2 pos;
    vector2 scale;
    vector2 animOffsets;
    vector2 animScale;
    vector2 goalPos;
    vector2 goalScale;
    float goalAlpha;
    BTN_STATES btnState;
    int menuDTFlags;
    string btnText;
    bool clicked;

    TextureID btnTextures[4];

    PBTK_UIController controller;
    PBTK_UICollider collider;

    float btnAlpha;

    Menu parentMenu;

    MenuItemBase myItem;

    enum BTN_STATES
    {
        STATE_INACTIVE,
        STATE_NEUTRAL,
        STATE_HOVERED,
        STATE_CLICKED
    };

    virtual void UpdateAnimations()
    {
        pos = (PB_Math.Lerp(pos.x, goalPos.x, 0.5), PB_Math.Lerp(pos.y, goalPos.y, 0.5));
        scale = (PB_Math.Lerp(scale.x, goalScale.x, 0.5), PB_Math.Lerp(scale.y, goalScale.y, 0.5));
        btnAlpha = PB_Math.Lerp(btnAlpha, goalAlpha, 0.5);

        switch(controller.transitioning)
        {
            case PBTK_UIController.TR_GOFORWARD:
                if(clicked && controller.transitionTicks <= 0)
                {
                    myItem.Activate();
                    clicked = 0;
                }
                break;
        }
    }

	static PBTK_Button InitButton(vector2 pos, TextureID inactiveTex, TextureID activeTex, TextureID hoveredTex, TextureID clickedTex, PBTK_UIController controller, string text, int index, ListMenuDescriptor desc)
	{
        PBTK_Button btn = new("PBTK_Button");

        if(btn)
        {
            btn.pos = pos;
            btn.btnTextures[0] = inactiveTex;
            btn.btnTextures[1] = activeTex;
            btn.btnTextures[2] = hoveredTex;
            btn.btnTextures[3] = clickedTex;
            btn.controller = controller;
            btn.scale = (1, 1);
            btn.animScale = (1, 1);
            btn.btnAlpha = 1;
            btn.btnText = text;
            btn.myItem = desc.mItems[index];

            btn.goalPos = pos;
            btn.goalScale = (1, 1);
            btn.goalAlpha = 1;

            return btn;
        }

        return NULL;
	}

	virtual void Draw(bool selected, ListMenuDescriptor desc, int buttonPosition)
	{
        if(selected) {            
            if(clicked)
            {
                goalPos.x = 200;
                goalScale = (2, 2);
                goalAlpha = 0;
                btnstate = STATE_CLICKED;
            } 
            else if(controller.transitioning)
            {
                btnstate = STATE_HOVERED;
                goalScale = (1.0, 1.0);
                goalAlpha = 0;
                goalPos = (-240, 0);
            }
            else
            {
                goalPos.x = 20;
                goalScale = (1.1, 1.1);
                goalAlpha = 1;
                btnstate = STATE_HOVERED;
            } 
        }
        else
        {
            if(controller.transitioning)
            {
                btnstate = STATE_INACTIVE;
                goalScale = (1.0, 1.0);
                goalAlpha = 0;
                goalPos = (-240, 0);
            }
            else
            {
                btnstate = STATE_NEUTRAL;
                goalScale = (1.0, 1.0);
                goalAlpha = 1;
                goalPos = (0, 0);
            }
        }
                

		//PBTK_StatusBarScreen.DrawTexture(btnTextures[btnState], controller.glbStartPos + pos + animOffsets + (0, buttonPosition * -47), controller.glbDTFlags, btnAlpha * controller.glbAlpha, (scale.x * animScale.x, scale.y * animScale.y));
        if(btnText)
            PBTK_StatusBarScreen.DrawString(desc.mFont, btnText, controller.glbStartPos + pos + animOffsets + (-112 * scale.x, -23 * scale.y) + (0, buttonPosition * -47), controller.glbDTFlags, alpha: btnAlpha * controller.glbAlpha, (scale.x * animScale.x, scale.y * animScale.y));
	}
}
