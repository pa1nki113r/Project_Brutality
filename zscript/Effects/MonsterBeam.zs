//Temporary inventory trick to draw a texpx beam from a monster
//this can be removed when pb_beamrev & pb_cyberdemon are already in zscript, so this can be in the monster class itself

Class MonsterBeamAim : Inventory
{
	int maxbeamduration;
	property maxbeamduration:maxbeamduration;
	bool TargetAim;
	property TargetAim:TargetAim;
	default
	{
		inventory.maxamount 1;
		MonsterBeamAim.maxbeamduration 1;
		MonsterBeamAim.TargetAim true;
	}
	int beamduration;
	override void DoEffect()
	{
		super.doeffect();
		
		if(isfrozen())
			return;
		if(!owner || owner.health < 1)
			destroy();
			
		if(beamduration >= maxbeamduration)
			destroy();
		else
			beamduration++;
		
		PB_DoRailThings();
		
	}
	
	//this represents the distance between the particles
	const distpx = 12;
	
	virtual void PB_DoRailThings()
	{
		PB_DoVisualRail();
	}
	
	Void PB_DoVisualRail(int ofsfw = 0,int ofssd = 0,int ofsud = 0,int maxdist = 4000, bool AimAtTarget = true, string railpuff = "Laser_Red_CyberDemon")
	{
		if(!owner || owner.health < 1)
			return;
			
		FLineTraceData t;
		double ofsz = (owner.height * 0.5) + ofsud;
		
		double tempangle = owner.angle;
		double temppitch = owner.pitch;
		
		//if its set to aim at the target, and there is a target, aim at it
		//otherwise aim in the direction the monster is looking
		if(AimAtTarget && owner && owner.target)
		{
			tempangle = owner.AngleTo(owner.target);
			temppitch = owner.pitchTo(owner.target,owner.target.height * 0.5); //aim at the center of the victim
		}
		
		bool hit = owner.linetrace(tempangle,maxdist,temppitch,0,ofsz,ofsfw,ofssd,data:t);
		
		vector3 fw = (cos(owner.angle),sin(owner.angle),0); //forward offset
		vector3 sd = (cos(owner.angle - 90),sin(owner.angle - 90),0); //side offset
		
		//get a vector3 with the total offsets
		vector3 offs = (fw * ofsfw) + (sd * ofssd);
		
		//add the offsets to the current position
		vector3 spos = owner.vec3offset(offs.x,offs.y,ofsz);
		vector3 fpos = t.HitLocation;
		fpos -= t.hitdir;
		
		vector3 dif = levellocals.Vec3diff(spos,fpos);
		vector3 dir = dif.unit();
		double dis = dif.length();
		
		//limit the distance
		if(dis > maxdist)
			dis = maxdist;
			
		//if the linetrace hits a wall or another monster, stop at that place
		if(dis > t.Distance)
			dis = t.Distance;
		
		int steps = int(dis / distpx) + 1;
		
		for(int i = 0; i < steps; i++)
		{
			spos += (dir * distpx);
			PB_DrawRailFx(spos);
		}
		
		//if theres any puff type
		if(railpuff != "")
		{
			//so the puff doesnt spawn inside the target (if any)
			double sep = owner.target ? owner.target.radius : 1;
			fpos -= (t.hitdir * sep);
			owner.spawn(railpuff,fpos);
		}
	}
	
	//this function draws the particles
	Void PB_DrawRailFx(vector3 where)
	{
		FSpawnParticleParams MonsterRail;
		MonsterRail.Texture = TexMan.CheckForTexture("TTRRA0");
		MonsterRail.Color1 = "FFFFFF";
		MonsterRail.Style = STYLE_Add;
		MonsterRail.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		MonsterRail.Vel = (0,0,0); 
		MonsterRail.Startroll = randompick(0,360);
		MonsterRail.RollVel = 0;
		MonsterRail.StartAlpha = 0.28;
		MonsterRail.FadeStep = 0;
		MonsterRail.Size = 20;
		MonsterRail.SizeStep = 0;
		MonsterRail.Lifetime = 1;  
		MonsterRail.Pos = where;
		Level.SpawnParticle(MonsterRail);
	}
}

//the beam handler for the beam revenant
Class BeamRevRailFx : MonsterBeamAim
{
	override void PB_DoRailThings()
	{
		PB_DoVisualRail(0,15,25,4000,TargetAim);
	}
}

//the beam handler for the draug revenant
Class DraugRailFx : MonsterBeamAim
{
	override void PB_DoRailThings()
	{
		PB_DoVisualRail(0,-15,25,4000,TargetAim);
	}
}

//the beam handler for the cyberdemon
Class CybRailFx : MonsterBeamAim
{
	override void PB_DoRailThings()
	{
		PB_DoVisualRail(0,-20,18,3000,TargetAim);
	}
}