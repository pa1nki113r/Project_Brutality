class PB_9x19mm : PB_Projectile //mp 40
{
	Default
	{
		PB_Projectile.BaseDamage 17;
		PB_Projectile.RipperCount 2;
		PB_Projectile.PenetrationCount 2;
		PB_Projectile.SpeedFPS 1312;
		+PB_Projectile.SMALLIMPACT;
		Obituary "%o met %k's Schmeisser.";
	}
}

class PB_9x19mmSubsonic : PB_Projectile //submachine gun
{
	Default
	{
		PB_Projectile.BaseDamage 19;
		PB_Projectile.RipperCount 1;
		PB_Projectile.PenetrationCount 1;
		PB_Projectile.SpeedFPS 1116;
		+PB_Projectile.SMALLIMPACT;
		Obituary "%o was out-tacticaled by %k's SMG.";
	}
}

class PB_45ACPHP : PB_Projectile //pistol
{
	Default
	{
		PB_Projectile.BaseDamage 15;
		PB_Projectile.RipperCount 1;
		PB_Projectile.PenetrationCount 1;
		PB_Projectile.SpeedFPS 835;
		+PB_Projectile.WHIZCRACK;
		+PB_Projectile.SMALLIMPACT;
		Obituary "%o was filled with bullets by %k.";
	}
}

class PB_500SW : PB_Projectile //magnum revolver
{
	Default
	{
		PB_Projectile.BaseDamage 100;
		PB_Projectile.RipperCount 3;
		PB_Projectile.PenetrationCount 3;
		//[nV] this is on the extreme low end of the spectrum for this caliber; the s&w m500 apparently reaches ~2075 ft/s, but balance demands it be lower than the deagle.
		PB_Projectile.SpeedFPS 1250;
		+PB_Projectile.WHIZCRACK;
		Obituary "%o was shot at high noon by %k.";
	}
}

class PB_50AE : PB_Projectile //martian raptor
{
	Default
	{
		PB_Projectile.BaseDamage 105;
		PB_Projectile.RipperCount 4;
		PB_Projectile.PenetrationCount 3;
		PB_Projectile.SpeedFPS 1542;
		+PB_Projectile.WHIZCRACK;
		Obituary "%o was styled on by %k.";
	}
}

class PB_45ACP : PB_Projectile //unused
{
	Default
	{
		PB_Projectile.BaseDamage 20;
		PB_Projectile.RipperCount 3;
		PB_Projectile.PenetrationCount 2;
		//[nV] same as the other one, probably not realistic but this isn't used anywhere.
		PB_Projectile.SpeedFPS 835;
		+PB_Projectile.SMALLIMPACT;
		Obituary "%o met muh gods caliber at %k's hands.";
	}
}
