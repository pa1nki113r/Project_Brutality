class PBTK_UIController ui
{
    vector2 glbStartPos;
    int glbDTFlags;
    float glbAlpha;
    uint8 transitioning;
    int transitionTicks;

    enum ETRANSITION_TYPES {
        TR_NONE = 0,
        TR_GOFORWARD = 1,
        TR_GOBACK = 2
    };

    static PBTK_UIController Create(int flags)
	{
        PBTK_UIController ctrl = new("PBTK_UIController");

        if(ctrl)
        {
            ctrl.glbAlpha = 1.0;
            ctrl.glbDTFlags = flags;

            return ctrl;
        }

        return NULL;
	}

    void ControllerTick()
    {
        if(transitionTicks > -1)
            transitionTicks--;
        else
            transitioning = TR_NONE;
    }
}