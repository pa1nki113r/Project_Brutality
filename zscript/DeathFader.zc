class DeathFader : Inventory {
	int counttoblack;
	
	Mixin PB_CheckFunctions;
	override void AttachToOwner(actor User)
	{
		super.AttachToOwner(user);
		counttoblack = (owner.health + random(5, 20)) * 35;
		counttoblack = max(counttoblack, 10);
		owner.A_SetBlend("black", 0.0, counttoblack, "black", 1.0);
	}

	override void DoEffect()
	{
		Bool Deadass = IsDead (Owner);
		If (!Deadass)
		{
			Owner.A_SetBlend("Black",0,0);
			//[inkoalawetrust] BUG: STOP FUCKING FADING TO BLACK AFTER RESPAWNING OH MY GOD
			If (Owner.Player)
				Owner.Player.BlendA = Owner.Player.BlendR = Owner.Player.BlendG = Owner.Player.BlendB = 0.0; 
			GoAwayAndDie();
			Return;
		}
		
		if (counttoblack <= 2 && Deadass)
			owner.A_SetBlend("black", 1.0, 5, "black", 1.0);
		counttoblack--;
	}
}

class BloodFader : DeathFader {}