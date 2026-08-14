class PB_12GAPellet : PB_Projectile //pump shotgun
{
	Default
	{
		PB_Projectile.BaseDamage 15;
		PB_Projectile.RipperCount 2;
		PB_Projectile.PenetrationCount 2;
		PB_Projectile.SpeedFPS 1145;
		+PB_Projectile.OMNIDIRECTIONAL;
		+PB_Projectile.SMALLIMPACT;
		Damagetype "Shotgun";
		Obituary "%o had %p intestines removed and thrown on the ground by %k.";
	}
}

class PB_12GAPellet_ASG : PB_12GAPellet //assault shotgun
{
	Default
	{
		Damagetype "Cutless";
	}
}

class PB_12GASlug : PB_Projectile //pump shotgun
{
	Default
	{
		PB_Projectile.BaseDamage 125;
		PB_Projectile.RipperCount 3;
		PB_Projectile.PenetrationCount 3;
		PB_Projectile.SpeedFPS 1600;
		RipperLevel 1;
		+PB_Projectile.WHIZCRACK;
		Damagetype "Shotgun";
		Obituary "%o had %p guts blown out by %k.";
	}
}

// [gng] LP projectiles have more damage and use a more gory damage type
// used for when you shoot an enemy from close range.

class PB_10GAPellet : PB_Projectile //double-barrel shotgun
{
	Default
	{
		PB_Projectile.BaseDamage 18;
		PB_Projectile.RipperCount 3;
		PB_Projectile.PenetrationCount 2;
		PB_Projectile.SpeedFPS 1100;
		+PB_Projectile.OMNIDIRECTIONAL;
		+PB_Projectile.SMALLIMPACT;
		Damagetype "Shotgun";
		Obituary "%o was turned inside out by %k.";
	}
}

class PB_10GAPellet_LP : PB_10GAPellet //double-barrel shotgun
{
	Default
	{
		PB_Projectile.BaseDamage 35;
		PB_Projectile.RipperCount 2;
		PB_Projectile.PenetrationCount 2;
		PB_Projectile.SpeedFPS 1100;
		RipperLevel 1;
		Damagetype "SSG";
		+PB_Projectile.RANGED;
		+PB_Projectile.NOCRITICALS;
		PB_Projectile.ProjectileRange 220;
	}
}

class PB_8GAPellet : PB_Projectile //quad-barrel shotgun
{
	Default
	{
		PB_Projectile.BaseDamage 18;
		PB_Projectile.RipperCount 4;
		PB_Projectile.PenetrationCount 2;
		//[nV] as far as i can tell there is no mass-produced, modern 8-gauge shotgun or shell, so this number is entirely fictional.
		PB_Projectile.SpeedFPS 1125;
		+PB_Projectile.OMNIDIRECTIONAL;
		+PB_Projectile.SMALLIMPACT;
		Damagetype "Shotgun";
		Obituary "%o was turned into a fine red mist by %k.";
	}
}

class PB_8GAPellet_LP : PB_8GAPellet //quad-barrel shotgun
{
	Default
	{
		PB_Projectile.BaseDamage 50;
		PB_Projectile.RipperCount 2;
		PB_Projectile.PenetrationCount 2;
		PB_Projectile.SpeedFPS 1125;
		RipperLevel 1;
		Damagetype "SSG";
		+PB_Projectile.RANGED;
		+PB_Projectile.NOCRITICALS;
		PB_Projectile.ProjectileRange 220;
	}
}
