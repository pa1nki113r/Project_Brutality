/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2021
 *
 * This file is a part of Gearbox.
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
 * To save data into savegame.
 */
class gb_PreviousWeaponStorage : EventHandler
{

  Weapon mCurrentWeapon;
  Weapon mPreviousWeapon;
  bool   mIsHolstered;

} // class gb_PreviousWeaponEventHandlerStorage

/**
 * Main event handler is static so data is carried over to next level.
 */
class gb_PreviousWeaponEventHandler : StaticEventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////////////////////////

  override
  void playerEntered(PlayerEvent event)
  {
    mStorage = gb_PreviousWeaponStorage(EventHandler.find("gb_PreviousWeaponStorage"));
    if (event.playerNumber == consolePlayer) updatePreviousWeapon();
  }

  override
  void worldLoaded(WorldEvent event)
  {
    if (!event.isSaveGame) return;

    mStorage = gb_PreviousWeaponStorage(EventHandler.find("gb_PreviousWeaponStorage"));

    if (mStorage == NULL) return;

    mCurrentWeapon  = mStorage.mCurrentWeapon;
    mPreviousWeapon = mStorage.mPreviousWeapon;
    mIsHolstered    = mStorage.mIsHolstered;
  }

  override
  void worldTick()
  {
    if (mStorage == NULL) return;

    updatePreviousWeapon();

    mStorage.mCurrentWeapon  = mCurrentWeapon;
    mStorage.mPreviousWeapon = mPreviousWeapon;
    mStorage.mIsHolstered    = mIsHolstered;
  }

  override
  void networkProcess(ConsoleEvent event)
  {
    if (mStorage == NULL) return;

    if (event.name == "gb_prev_weapon"
        && mPreviousWeapon != NULL
        && mPreviousWeapon != players[event.player].ReadyWeapon)
    {
      players[event.player].PendingWeapon = mPreviousWeapon;
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void updatePreviousWeapon()
  {
    Weapon ready = players[consolePlayer].readyWeapon;

    if (ready == NULL || ready.getClassName() == "mg_Holstered")
    {
      if (!mIsHolstered)
      {
        // swap
        let tmp         = mCurrentWeapon;
        mCurrentWeapon  = mPreviousWeapon;
        mPreviousWeapon = tmp;
      }
      mIsHolstered = true;
      return;
    }

    mIsHolstered = false;

    if (mCurrentWeapon != ready)
    {
      mPreviousWeapon = mCurrentWeapon;
    }

    mCurrentWeapon = ready;
  }

  private gb_PreviousWeaponStorage mStorage;
  private Weapon mCurrentWeapon;
  private Weapon mPreviousWeapon;
  private bool   mIsHolstered;

} // class gb_PreviousWeaponEventHandler
