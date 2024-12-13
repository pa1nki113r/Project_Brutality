class gb_specialsmenu
{
	static gb_specialsmenu from()
	{
		let nc = new("gb_specialsmenu");
		nc.mSelectedIndex = 0;
		return nc;
	}
	
	ui void getspecials(weapon act)
	{
		ClearSpecials();				//empty the arrays, so everything displays correctly
		let pl = players[consoleplayer];
		let toRead = PB_WeaponBase(act);
		if(toRead)
		{
			if(!toRead.wheelinfo)
				return;
			let wif = wheelinfocontainer(new(toRead.wheelinfo));
			if(!wif || !toRead.hasWheelSpecial)
				return;
			specialsinfo.clear();	
			wif.GetSpecials(specialsinfo,pl.mo);
			for(int i = 0; i < specialsinfo.size(); i++)
			{
				stag.push(specialsinfo[i].Alias);
				imgs.push(specialsinfo[i].img);
				Xscales.push(specialsinfo[i].scalex);
				Yscales.push(specialsinfo[i].scaley);
				token.push(specialsinfo[i].tokentogive);
			}
			
		}
	}
	
	static bool thereAreNoSpecials()
	{
		return getSpecialsNumber() == 0;
	}
	
	private static int getSpecialsNumber()
	{	
		let pl = players[consoleplayer];
		let toRead = PB_WeaponBase(pl.readyweapon);
		if(toRead)
		{
			if(!toRead.wheelinfo)
				return 0;
			let wif = wheelinfocontainer(new(toRead.wheelinfo));
			if(!wif || !toRead.hasWheelSpecial)
				return 0;
			return wif.GetSPCount(pl.mo);
			
		}
		return 0;
	}
	
	ui bool selectNext()
	{
		int nItems = getSpecialsNumber();
		if (nItems == 0) return false;

		mSelectedIndex = (mSelectedIndex + 1) % nItems;

		return true;
	}
	
	ui bool selectPrev()
	{
		int nItems = getSpecialsNumber();
		if (nItems == 0) return false;

		mSelectedIndex = (mSelectedIndex - 1 + nItems) % nItems;

		return true;
	}

	ui bool setSelectedIndex(int index)
	{
		if (index == -1 || mSelectedIndex == index) return false;
		
		int nItems = getSpecialsNumber();
		if(nItems == 0)
			return false;
		index = clamp(index,0,nItems);
		
		mSelectedIndex = index;

		return true;
	}
	
	ui int getSelectedIndex() const
	{
		return mSelectedIndex;
	}
	
	string ConfirmSelection() const
	{
		if(token.size() > 0)
			return token[clamp(mSelectedIndex,0,token.size() - 1)];
		return "";
	}
	
	ui void Fill(out gb_ViewModel viewModel)
	{
		for(int i = 0; i < stag.size(); i++)
		{
			viewModel.tags        .push(stag[i]);
			viewModel.slots       .push(i + 1);
			viewModel.indices     .push(i);
			viewModel.icons       .push(texman.checkfortexture(imgs[i]));
			viewModel.iconScaleXs .push(Xscales[i]);
			viewModel.iconScaleYs .push(Yscales[i]);
			viewModel.quantity1   .push(-1);		//no ammount for you >:(
			viewModel.maxQuantity1.push(-1);		//
			viewModel.quantity2   .push(-1);		//
			viewModel.maxQuantity2.push(-1);		//
		}
		viewModel.selectedIndex = clamp(mSelectedIndex,0,stag.size()-1);
	}
	
	private ui void ClearSpecials()
	{
		stag.clear();
		token.clear();
		mSelectedIndex = 0;
		imgs.clear();
		Xscales.clear();
		Yscales.clear();
		specialsinfo.clear();
	}
	
	array<string> stag;
	array<double>Xscales;
	array<double>Yscales;
	private int mSelectedIndex;
	array<string> token;
	array<string> imgs;
	Array<PB_SpecialWheel_Mode> specialsinfo;
}
