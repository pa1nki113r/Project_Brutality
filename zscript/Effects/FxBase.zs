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