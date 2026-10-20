class PB_GlobalStats : Thinker
{
	enum CounterIndices
	{
		Counter_LevelsCompleted
		
	}

	static PB_GlobalStats Get()
	{
		ThinkerIterator it = ThinkerIterator.Create('PB_GlobalStats', STAT_STATIC);
		PB_GlobalStats t = null;
		while (t = PB_GlobalStats(it.Next()))
		{
			return t;
		}

		t = new('PB_GlobalStats');
		t.ChangeStatNum(STAT_STATIC);
		return t;
	}

	int Flags;
	int Counters[4];
	Array<string> ProgressedMaps;
}