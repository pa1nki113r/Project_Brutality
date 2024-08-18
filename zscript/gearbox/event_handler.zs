/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2020-2022
 * Carrascado 2022
 *
 * This file is part of Gearbox.
 *
 * Gearbox is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Gearbox is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Gearbox.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * This class is the core of Gearbox.
 *
 * It delegates as much work to other classes while minimizing the relationships
 * between those classes.
 *
 * To ensure multiplayer compatibility, Gearbox does the following:
 *
 * 1. All visuals and input processing happens on client side and is invisible
 * to the network.
 *
 * 2. Actual game changing things, like switching weapons, are done through
 * network - even for the current player, even for the single-player game.
 */
class gb_EventHandler : EventHandler
{

  override
  void worldTick()
  {
    switch (gb_Level.getState())
    {
		case gb_Level.NotInGame:  return;
		case gb_Level.Loading:    return;
		case gb_Level.JustLoaded: initialize(); // fall through
		case gb_Level.Loaded:     break;
    }

    bool isClosed = mActivity.isNone();

    // Thaw regardless of the option to prevent player being locked frozen after
    // changing options.
    if (isClosed) mFreezer.thaw();
    else          mFreezer.freeze();

    if (!isClosed && (gb_Player.isDead() || isDisabledOnAutomap()))
    {
      close();
    }

    if (isClosed)
    {
      // Watch for the current weapon, because player can change it without
      // Gearbox. Also handles the case when Gearbox hasn't been opened yet,
      // initializing weapon menu.
      mWeaponMenu.setSelectedWeapon(gb_WeaponWatcher.current());
    }
    else if (mOptions.getViewType() == VIEW_TYPE_WHEEL || mActivity.isSpecials() || mActivity.isequipment())
    {
      mWheelController.process();
    }

    mInventoryUser.use();
  }

  /**
   * This function processes key bindings specific for Gearbox.
   */
  override
  void consoleProcess(ConsoleEvent event)
  {
    if (players[consolePlayer].mo == NULL) return;

    if (!mIsInitialized || isDisabledOnAutomap()) return;
    if (isPlayerFrozen() && mActivity.isNone()) return;

    switch (gb_EventProcessor.process(event, mOptions.isSelectOnKeyUp()))
    {
		case InputToggleWeaponMenu: 	toggleWeapons(); 				break;
		case InputConfirmSelection: 	confirmSelection(); close(); 	break;
		case InputToggleInventoryMenu: 	toggleInventory(); 				break;
		case InputRotateWeaponPriority: rotateWeaponPriority(); 		break;
		case InputRotateWeaponSlot:     rotateWeaponSlot(); 			break;
		case InputToggleSpecialMenu:	toggleSpecials();				break;
		case InputToggleEquipMenu:		toggleEquipments();				break;
    }

    if (!mActivity.isNone()) mWheelController.reset();
  }

  /**
   * This function provides latching to existing key bindings, and processing mouse input.
   */
  override
  bool inputProcess(InputEvent event)
  {
    if (players[consolePlayer].mo == NULL) return false;
    if (!mIsInitialized || isDisabledOnAutomap() || gameState != GS_LEVEL) return false;
    if (isPlayerFrozen() && mActivity.isNone()) return false;

    int input = gb_InputProcessor.process(event);

    if (mActivity.isWeapons())
    {
      switch (input)
      {
		  case InputSelectNextWeapon: tickIf(mWeaponMenu.selectNextWeapon()); mWheelController.reset(); break;
		  case InputSelectPrevWeapon: tickIf(mWeaponMenu.selectPrevWeapon()); mWheelController.reset(); break;
		  case InputConfirmSelection: confirmSelection(); close(); break;
		  case InputClose:            close(); break;

		  default:
			if (!gb_Input.isSlot(input)) return false;
			mWheelController.reset();
			tickIf(mWeaponMenu.selectSlot(gb_Input.getSlot(input)));
			break;
      }

      return true;
    }
    else if (mActivity.isInventory())
    {
		  switch (input)
		  {
			  case InputSelectNextWeapon: tickIf(mInventoryMenu.selectNext()); mWheelController.reset(); break;
			  case InputSelectPrevWeapon: tickIf(mInventoryMenu.selectPrev()); mWheelController.reset(); break;
			  case InputConfirmSelection: confirmSelection(); close(); break;
			  case InputClose:            close(); break;

			  default:
			  {
				if (!gb_Input.isSlot(input)) return false;
				mWheelController.reset();
				int slot = gb_Input.getSlot(input);
				int index = (slot == 0) ? 9 : slot - 1;
				tickIf(mInventoryMenu.setSelectedIndex(index));
				break;
			  }
		  }
      return true;
    }
	else if(mActivity.isSpecials())
	{
		switch (input)
		{
			case InputSelectNextWeapon: tickIf(mspecialsmenu.selectNext()); mWheelController.reset(); break;
			case InputSelectPrevWeapon: tickIf(mspecialsmenu.selectPrev()); mWheelController.reset(); break;
			case InputConfirmSelection: confirmSelection(); close(); break;
			case InputClose:            close(); break;
		
			default:
			{
				if (!gb_Input.isSlot(input)) return false;
				mWheelController.reset();
				int slot = gb_Input.getSlot(input);
				int index = (slot == 0) ? 9 : slot - 1;
				tickIf(mspecialsmenu.setSelectedIndex(index));
				break;
			}
		}
		return true;
	}
	else if (mactivity.isEquipment())
	{
		//gb_Activity.Equipments
		switch (input)
		{
			case InputSelectNextWeapon: tickIf(mEquipmenu.selectNext()); mWheelController.reset(); break;
			case InputSelectPrevWeapon: tickIf(mEquipmenu.selectPrev()); mWheelController.reset(); break;
			case InputConfirmSelection: confirmSelection(); close(); break;
			case InputClose:            close(); break;
		
			default:
			{
				if (!gb_Input.isSlot(input)) return false;
				mWheelController.reset();
				int slot = gb_Input.getSlot(input);
				int index = (slot == 0) ? 9 : slot - 1;
				tickIf(mEquipmenu.setSelectedIndex(index));
				break;
			}
		}
		return true;
	}
    else if (mActivity.isNone())
    {
      mWheelController.reset();

      if (gb_Input.isSlot(input) && mOptions.isOpenOnSlot())
      {
        int slot = gb_Input.getSlot(input);

        if (mOptions.isNoMenuIfOne() && mWeaponMenu.isOneWeaponInSlot(slot))
        {
          tickIf(mWeaponMenu.selectSlot(slot));
          gb_Sender.sendSelectEvent(mWeaponMenu.confirmSelection());
        }
        else if (mWeaponMenu.selectSlot(slot, mOptions.isSelectFirstSlotWeapon()))
        {
          mSounds.playOpen();
          mActivity.openWeapons();
        }
        else
        {
          mSounds.playNope();
          return false;
        }

        return true;
      }

      if (!mOptions.isOpenOnScroll()) return false;

      switch (input)
      {
		case InputSelectNextWeapon: toggleWeapons(); mWeaponMenu.selectNextWeapon(); return true;
		case InputSelectPrevWeapon: toggleWeapons(); mWeaponMenu.selectPrevWeapon(); return true;
      }
    }

    return false;
  }

  override
  void networkProcess(ConsoleEvent event)
  {
    if (players[consolePlayer].mo == NULL) return;

    int input = mNeteventProcessor.process(event);

    switch (input)
    {
		case InputResetCustomOrder: resetCustomOrder(); break;
    }
  }

  override
  void renderOverlay(RenderEvent event)
  {
    if (!mIsInitialized) return;

    if (!mTextureCache.isLoaded) mTextureCache.load();

    mCaption.show();
    mFadeInOut.fadeInOut((mActivity.isNone()) ? -0.1 : 0.2);
    gb_Blur.setEnabled(mOptions.isBlurEnabled() && !mActivity.isNone());

    double alpha = mFadeInOut.getAlpha();

    if (mActivity.isNone() && alpha == 0.0) return;

    gb_ViewModel viewModel;
    if      (mActivity.isWeapons())   mWeaponMenu.fill(viewModel);
    else if (mActivity.isInventory()) mInventoryMenu.fill(viewModel);
	else if (mActivity.isSpecials())  mspecialsmenu.fill(viewModel);
	else if (mActivity.isEquipment()) mEquipmenu.fill(viewModel);

    verifyViewModel(viewModel);

    gb_Dim.dim(alpha, mOptions);
	int viewtype = mOptions.getViewType();
	switch(mActivity.getActivity())
	{
		case mActivity.Weapons:
		case mActivity.Inventory: 											break;
		case mActivity.Specials:	viewtype = VIEW_TYPE_WHEEL;				break;
		case mActivity.Equipments:	viewtype = VIEW_TYPE_WHEEL;				break;
	}

    switch (viewtype)
    {
    case VIEW_TYPE_BLOCKY:
      mBlockyView.setAlpha(alpha);
      mBlockyView.setScale(mOptions.getScale());
      mBlockyView.setBaseColor(mOptions.getColor());
      mBlockyView.display(viewModel);
      break;

    case VIEW_TYPE_WHEEL:
    {
      gb_WheelControllerModel controllerModel;
      mWheelController.fill(controllerModel);
      mWheelIndexer.update(viewModel, controllerModel);
      int selectedViewIndex = mWheelIndexer.getSelectedIndex();

      if (mActivity.isWeapons()) 		tickIf(mWeaponMenu.setSelectedIndexFromView(viewModel, selectedViewIndex));
      else if (mActivity.isInventory()) tickIf(mInventoryMenu.setSelectedIndex(selectedViewIndex));
	  else if (mActivity.isSpecials())	tickIf(mspecialsmenu.setSelectedIndex(selectedViewIndex));
	  else if (mactivity.isequipment())	tickIf(mEquipmenu.setSelectedIndex(selectedViewIndex));
      if (selectedViewIndex != -1) 		viewModel.selectedIndex = selectedViewIndex;

      int selectedIndex;
	  switch(mActivity.getActivity())
	  {
		case mActivity.Weapons:		selectedIndex = mWeaponMenu.getSelectedIndex();		break;
		case mActivity.Inventory: 	selectedIndex = mInventoryMenu.getSelectedIndex();	break;
		case mActivity.Specials:	selectedIndex = mspecialsmenu.getSelectedIndex();	break;
		case mActivity.Equipments:	selectedIndex = mEquipmenu.getSelectedIndex();		break;
	  }

      mWheelView.setAlpha(alpha);
      mWheelView.setBaseColor(mOptions.getColor());
      mWheelView.setRotating(mActivity.isWeapons());

      int innerIndex = mWheelIndexer.getInnerIndex(selectedIndex, viewModel);
      int outerIndex = mWheelIndexer.getOuterIndex(selectedIndex, viewModel);
      mWheelView.display( viewModel
                        , controllerModel
                        , mOptions.isMouseInWheel()
                        , innerIndex
                        , outerIndex
                        );
      break;
    }

    case VIEW_TYPE_TEXT:
      mTextView.setAlpha(alpha);
      mTextView.setScale(mOptions.getTextScale());
      mTextView.display(viewModel);
      break;

    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private play
  bool isDisabledOnAutomap() const
  {
    return automapActive && !mOptions.isOnAutomap();
  }

  private play
  bool isPlayerFrozen() const
  {
    return players[consolePlayer].isTotallyFrozen() && !mOptions.isFrozenCanOpen();
  }

  private ui void tickIf(bool mustTick)
  {
    if (mustTick) mSounds.playTick();
  }

  private ui void toggleWeapons()
  {
    if (mActivity.isWeapons()) close();
    else openWeapons();
  }

  private ui void toggleInventory()
  {
    if (mActivity.isInventory()) close();
    else openInventory();
  }

  private ui void toggleSpecials()
  {
	if(mActivity.isSpecials())	close();
	else openSpecials();
  }
  
  private ui void toggleEquipments()
  {
	if(mActivity.isEquipment()) close();
	else openEquipment();
  }
  
  private ui
  void openWeapons()
  {
    if (gb_Player.isDead() || mWeaponMenu.isThereNoWeapons())
    {
      mSounds.playNope();
      return;
    }

    mWeaponMenu.setSelectedWeapon(gb_WeaponWatcher.current());
    mSounds.playOpen();
    mActivity.openWeapons();
  }

  private ui
  void openInventory()
  {
    if (gb_Player.isDead() || gb_InventoryMenu.thereAreNoItems())
    {
      mSounds.playNope();
      return;
    }

    mSounds.playOpen();
    mActivity.openInventory();
  }
  
  private ui void openSpecials()
  {
	if (gb_Player.isDead() || playercantspecial())
	{
		mSounds.playNope();
		return;
	}
	
	mspecialsmenu.getspecials(players[consolePlayer].readyweapon);//(gb_WeaponWatcher.current());
	if(mspecialsmenu.thereAreNoSpecials())
	{
		
		//mSounds.playNope();
		gb_Sender.sendGiveItemEvent("GoWeaponSpecialAbility");	//no wheel, instead go normal
		return;
	}
	
	mSounds.playOpen();
	mActivity.openSpecials();
  }
  
  private ui void openEquipment()
  {
	if (gb_Player.isDead() || mEquipmenu.noequipments())
	{
		mSounds.playNope();
		return;
	}
	
	mSounds.playOpen();
	mActivity.openEquipment();
  }

	private clearscope void close()
	{
		mSounds.playClose();
		mActivity.close();
	}
  
	private ui bool playercantspecial()
	{
		return (players[consoleplayer].mo.findinventory("CantWeaponSpecial"));
	}

	private ui void confirmSelection()
	{
		switch(mActivity.getactivity())
		{
			case gb_activity.Weapons:
				gb_Sender.sendSelectEvent(mWeaponMenu.confirmSelection());		break;
			case gb_activity.Inventory:
				gb_Sender.sendUseItemEvent(mInventoryMenu.confirmSelection());	break;
			case gb_activity.Specials:
				gb_Sender.sendGiveItemEvent("GoWeaponSpecialAbility");	//AAAA i forgot this, and was wondering why this wasnt working
				gb_Sender.sendGiveItemEvent(mspecialsmenu.ConfirmSelection());	break;
			case gb_activity.Equipments:
				gb_Sender.sendGiveItemEvent("ToggleEquipment");	
				gb_Sender.sendGiveItemEvent(mEquipmenu.ConfirmSelection());		break;
		}
	}

  private ui
  void rotateWeaponPriority()
  {
    if (mActivity.isWeapons())
    {
      gb_CustomWeaponOrderStorage.savePriorityRotation(mWeaponSetHash, mWeaponMenu.getSelectedIndex());
      mWeaponMenu.rotatePriority();
    }
  }

  private ui
  void rotateWeaponSlot()
  {
    if (mActivity.isWeapons())
    {
      gb_CustomWeaponOrderStorage.saveSlotRotation(mWeaponSetHash, mWeaponMenu.getSelectedIndex());
      mWeaponMenu.rotateSlot();
    }
  }

  private
  void resetCustomOrder()
  {
    gb_CustomWeaponOrderStorage.reset(mWeaponSetHash);
    gb_WeaponData weaponData;
    gb_WeaponDataLoader.load(weaponData);
    mWeaponMenu = gb_WeaponMenu.from(weaponData, mOptions);
  }

  private ui
  void verifyViewModel(gb_ViewModel model)
  {
    uint nTags           = model.tags        .size();
    uint nSlots          = model.slots       .size();
    uint nIndices        = model.indices     .size();
    uint nIcons          = model.icons       .size();
    uint nIconScaleXs    = model.iconScaleXs .size();
    uint nIconScaleYs    = model.iconScaleYs .size();
    uint nQuantities1    = model.quantity1   .size();
    uint nQuantitiesMax1 = model.maxQuantity1.size();
    uint nQuantities2    = model.quantity2   .size();
    uint nQuantitiesMax2 = model.maxQuantity2.size();

    if (nTags > 0
        && (model.selectedIndex >= nTags
            || nTags != nSlots
            || nTags != nIndices
            || nTags != nIcons
            || nTags != nIconScaleXs
            || nTags != nIconScaleYs
            || nTags != nQuantities1
            || nTags != nQuantitiesMax1
            || nTags != nQuantities2
            || nTags != nQuantitiesMax2))
    {
      Console.printf("Bad view model:\n"
                     "selected index: %d,\n"
                     "tags: %d,\n"
                     "slots: %d,\n"
                     "indices: %d,\n"
                     "icons: %d,\n"
                     "icon scale X: %d,\n"
                     "icon scale Y: %d,\n"
                     "quantities 1: %d,\n"
                     "max quantities 1: %d,\n"
                     "quantities 2: %d,\n"
                     "max quantities 2: %d,\n"
                    , model.selectedIndex
                    , nTags
                    , nSlots
                    , nIndices
                    , nIcons
                    , nIconScaleXs
                    , nIconScaleYs
                    , nQuantities1
                    , nQuantitiesMax1
                    , nQuantities2
                    , nQuantitiesMax2
                    );
    }
  }
  
  bool isOpened()		//ig this could work to indicate when the wheel is opened, just need a pointer to the handler
  {
	if(!mIsInitialized)	//it cant be opened if its not initialized
		return false;
	return !mActivity.isNone();
  }

  enum ViewTypes
  {
    VIEW_TYPE_BLOCKY = 0,
    VIEW_TYPE_WHEEL  = 1,
    VIEW_TYPE_TEXT   = 2,
  }

  private
  void initialize()
  {
    mOptions         = gb_Options.from();
    mFontSelector    = gb_FontSelector.from();
    mSounds          = gb_Sounds.from(mOptions);

    gb_WeaponData weaponData;
    gb_WeaponDataLoader.load(weaponData);
    mWeaponSetHash   = gb_CustomWeaponOrderStorage.calculateHash(weaponData);
    mWeaponMenu      = gb_WeaponMenu.from(weaponData, mOptions);
    gb_CustomWeaponOrderStorage.applyOperations(mWeaponSetHash, mWeaponMenu);
    mInventoryMenu   = gb_InventoryMenu.from();
	mSpecialsmenu = gb_specialsmenu.from();
	mEquipmenu = gb_equipmentmenu.from();

    mActivity        = gb_Activity.from();
    mFadeInOut       = gb_FadeInOut.from();
    mFreezer         = gb_Freezer.from(mOptions);

    mTextureCache    = gb_TextureCache.from();
    mCaption         = gb_Caption.from();
    mInventoryUser   = gb_InventoryUser.from();
    mChanger         = gb_Changer.from(mCaption, mOptions, mInventoryUser);
    mNeteventProcessor = gb_NeteventProcessor.from(mChanger);

    mBlockyView      = gb_BlockyView.from(mTextureCache, mOptions, mFontSelector);
    mTextView        = gb_TextView.from(mOptions, mFontSelector);

    mMultiWheelMode  = gb_MultiWheelMode.from(mOptions);
    let screen       = gb_Screen.from(mOptions);
    mWheelView       = gb_WheelView.from( mOptions
                                        , mMultiWheelMode
                                        , mTextureCache
                                        , screen
                                        , mFontSelector
                                        );
    mWheelController = gb_WheelController.from(mOptions, screen);
    mWheelIndexer    = gb_WheelIndexer.from(mMultiWheelMode, screen);

    mIsInitialized = true;
  }

  private gb_Options       mOptions;
  private gb_FontSelector  mFontSelector;
  private gb_Sounds        mSounds;

  private string           mWeaponSetHash;
  private gb_WeaponMenu    mWeaponMenu;
  private gb_InventoryMenu mInventoryMenu; 
  private gb_specialsmenu  mspecialsmenu;	//pb specials thing
  private gb_equipmentmenu mEquipmenu;		//pb equipments thing
  private gb_Activity      mActivity;
  private gb_FadeInOut     mFadeInOut;
  private gb_Freezer       mFreezer;

  private gb_TextureCache  mTextureCache;
  private gb_Caption       mCaption;
  private gb_InventoryUser mInventoryUser;
  private gb_Changer       mChanger;
  private gb_NeteventProcessor mNeteventProcessor;

  private gb_BlockyView mBlockyView;
  private gb_TextView   mTextView;

  private gb_MultiWheelMode  mMultiWheelMode;
  private gb_WheelView       mWheelView;
  private gb_WheelController mWheelController;
  private gb_WheelIndexer    mWheelIndexer;

  private bool mIsInitialized;

} // class gb_EventHandler
