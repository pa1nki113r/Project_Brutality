class PB_DecoZombie : PB_Monster { //PLACEHOLDER, DELETE WHEN ZSCRIPTIFIED
	override void PostBeginPlay() {
		Super.PostBeginPlay();
		PickRandomName(RANK_MILITARY);
	}
}

class PB_CultistSergeant : PB_ShotgunGuy {
	override void PostBeginPlay() {
		Super.PostBeginPlay();
		PickRandomName(RANK_CULTIST);
	}
}