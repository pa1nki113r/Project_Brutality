// ZScript footsteps by vsonnier based on code by TheZombieKiller aka Zombie
// Agent_Ash: CVAR caching, fixed volume multiplier, reversed and expanded delay multiplier
class PB_Footsteps : Actor
{
	Default {
		+NOINTERACTION
	}
	
	//the player footsteps are attached to.
	PlayerPawn toFollow;
	PlayerInfo fplayer;
	
	protected int updateTics;
	

	//attach PlayerPawn, load the texture/sound associated tables.
	void Init( PlayerPawn attached_player)
	{
		toFollow = attached_player;
	}
	
	override void Tick()
	{
		if (!toFollow) 
		{
			destroy();
			return;
		}
		
		updateTics--;
		
		//0) do nothing until updateTics is below 0
		if (updateTics > 0)
			return;
		
		//1) Update the Footstep actor to follow Player.
		SetOrigin(toFollow.pos, false);
		floorz = toFollow.floorz;
		   
		double playerVel2D = toFollow.Vel.Length();//sqrt(toFollow.vel.x * toFollow.vel.x + toFollow.vel.y * toFollow.vel.y);
		
		double isCrouched = toFollow.GetCrouchFactor();
		
		//2) Only play footsteps when on ground, and if the player is moving fast enough.
		if ((playerVel2D > 0.1) && (toFollow.pos.z - toFollow.floorz <= 0)) {			
			
			sound stepsound;			
			//current floor texture for the player:
			name floortex = name(Texman.GetName(toFollow.floorpic));
			//no sound if steppin on sky
			if (floorpic == skyflatnum)
				stepsound = "none";
			else
				stepsound = GetFlatSound(Texman.GetName(toFollow.floorpic));
			//sound volume is amplified by speed.
			double soundVolume = isCrouched * (playerVel2D * 0.05); //multiplied by 0.12 because raw value is too high to be used as volume
			
			//play the sound if it's non-null
			if (stepsound != "none")
				toFollow.A_StartSound(stepsound, CHAN_AUTO, CHANF_LOCAL|CHANF_UI, volume:soundVolume);
			
			//delay CVAR value is inverted, where 1.0 is default, higher means more frequent, smaller means less frequent
			double dmul = (2.1 - Clamp(1.8,0.1,2));
			updateTics = (gameinfo.normforwardmove[0] - playerVel2D) * dmul;   
		} else {
			// no need to poll for change too often
			updateTics = 1;
		}
	}
	
	sound GetFlatSound(name texname) {
		name tmpname = PB_Materialsys.GetMaterialFromTexName(texname);

		if(tmpname == 'err_nomaterialfound' || tmpname == 'err_escapedloop') 
			tmpname = "default";

		return "step/"..tmpname;
	}
}
