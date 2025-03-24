Class gb_equipmentmenu
{
	static gb_equipmentmenu from()
	{
		let nc = new("gb_equipmentmenu");
		nc.mSelectedIndex = 0;
		nc.Load();	//load its definitions
		return nc;
	}
	
	//this shouldnt be needed, but anyways
	bool noequipments()
	{
		return getEquipmentNumber() == 0;
	}
	
	int getEquipmentNumber()
	{	
		return tags.size();
	}
	
	ui bool selectNext()
	{
		int nItems = getEquipmentNumber();
		if (nItems == 0) return false;

		mSelectedIndex = (mSelectedIndex + 1) % nItems;

		return true;
	}
	
	ui bool selectPrev()
	{
		int nItems = getEquipmentNumber();
		if (nItems == 0) return false;

		mSelectedIndex = (mSelectedIndex - 1 + nItems) % nItems;

		return true;
	}

	ui bool setSelectedIndex(int index)
	{
		if (index == -1 || mSelectedIndex == index) return false;
		
		int nItems = getEquipmentNumber();
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
	
	
	//just in case anything is added in the future, is automatically handled here
	//this will only be called once, when the handler is initialized
	//not sure if this may be too heavy
	private void Load()
	{
		for(int i = 0; i < AllClasses.size(); i++)
		{
			if(AllClasses[i] is "equipmentCard")
			{
				let eq = equipmentCard(new(AllClasses[i]));
				if(eq)
					eq.InfoFiller(tags,token,img,scalex,scaley);
			}
		}
	}
	
	ui void fill(out gb_ViewModel viewModel)
	{
		for(int i = 0; i < tags.size(); i++)
		{
			viewModel.tags        .push(tags[i]);
			viewModel.slots       .push(i + 1);
			viewModel.indices     .push(i);
			viewModel.icons       .push(texman.checkfortexture(img[i]));
			viewModel.iconScaleXs .push(scalex[i]);
			viewModel.iconScaleYs .push(scaley[i]);
			viewModel.quantity1   .push(-1);		//no ammount for you >:(
			viewModel.maxQuantity1.push(-1);		//
			viewModel.quantity2   .push(-1);		//
			viewModel.maxQuantity2.push(-1);		//
		}
		
		viewModel.selectedIndex = clamp(mSelectedIndex,0,tags.size()-1);	//without this, blocks/text wont work
	}
	
	array <string> tags;
	array <string> token;
	array <string> img;
	array <double> scalex;
	array <double> scaley;
	private int mSelectedIndex;
}
