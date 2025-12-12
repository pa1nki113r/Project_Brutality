//base for effect actors that only needs to play an animation,
//so it skips the tick()
Class PB_LightActor : Actor
{		
	
	override void Tick()
	{
		//from gzdoom.pk3
		
		if (isFrozen())
			return;
		
		if (!CheckNoDelay())
			return;
		
		if(alpha < 0)
			destroy();

        SetOrigin(Vec3Offset(vel.x, vel.y, vel.z), true);
			
		// Advance the state
		if (tics != -1)
		{
			if (tics > 0) tics--;
			while (!tics)
			{
				if (!SetState (CurState.NextState))
				{ // mobj was removed
					return;
				}
			}
		}
	}
	
}

class PB_AnimatedSmokeThinker : VisualThinker abstract
{
    Array<string> sprName;
    Array<int> frameStep, startFrame, endFrame;
    int animFrame;
    int sprNameIndex;

    float rollVel;
    
    override void PostBeginPlay()
    {
        PB_SetupSprites();
        animFrame = startFrame[0];
        flags |= SPF_ROLL;
        Super.PostBeginPlay();
    }

    virtual void PB_SetupSprites() { }

    override void Tick() 
    {
        PB_AnimateSelf();
        PB_AnimateSprite();

        Super.Tick();
    }

    virtual void PB_AnimateSprite()
    {
        if(animFrame < endFrame[sprNameIndex] - (frameStep[sprNameIndex] - 1))
            animFrame += frameStep[sprNameIndex];
        else if(sprName.Size() - 1 > sprNameIndex)
        {
            sprNameIndex += 1;
            animFrame = startFrame[sprNameIndex];
        }
        else
        {
            Destroy();
            return;
        }

        Texture = TexMan.CheckForTexture(String.Format("%s%c%s", sprName[sprNameIndex], 97 + animFrame, "0"));
    }

    virtual void PB_AnimateSelf() { }
}

class PB_DustImpact : PB_AnimatedSmokeThinker 
{
    override void PB_SetupSprites() 
    {
        sprName.Push("XS16");
        frameStep.Push(1);
        startFrame.Push(0);
        endFrame.Push(15);

        SetRenderStyle(STYLE_Shaded);
        scale = (0.2, 0.5);
    }
}