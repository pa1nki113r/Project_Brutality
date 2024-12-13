/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2020-2021
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

class gb_Freezer play
{

  static
  gb_Freezer from(gb_Options options)
  {
    let result = new("gb_Freezer");
    result.mWasFrozen = false;
    result.mOptions   = options;
    result.mWasLevelFrozen = false;
    return result;
  }

  void freeze()
  {
    if (mWasFrozen) return;
    mWasFrozen = true;

    int freezeMode = mOptions.getTimeFreezeMode();
    if (isLevelFreezeEnabled (freezeMode)) freezeLevel();
    if (isPlayerFreezeEnabled(freezeMode)) freezePlayer();
  }

  void thaw()
  {
    if (!mWasFrozen) return;
    mWasFrozen = false;

    if (isLevelThawEnabled()) thawLevel();
    thawPlayer();
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  /**
   * Corresponds to gb_FreezeValues in menudef.
   */
  private static
  bool isLevelFreezeEnabled(int freezeMode)
  {
    return !multiplayer && (freezeMode == 1);
  }

  /**
   * Corresponds to gb_FreezeValues in menudef.
   *
   * Freezing level without player causes weird behavior, like weapon bobbing
   * while Gearbox is open. So, freeze player when level is frozen too.
   */
  private static
  bool isPlayerFreezeEnabled(int freezeMode)
  {
     return freezeMode != 0;
  }

  /**
   * Thaw regardless of freeze mode.
   */
  private static
  bool isLevelThawEnabled()
  {
    return !multiplayer;
  }

  private
  void freezeLevel()
  {
    mWasLevelFrozen = level.isFrozen();
    level.setFrozen(true);
  }

  private
  void freezePlayer()
  {
    mWasPlayerFrozen = true;

    PlayerInfo player = players[consolePlayer];

    mCheats   = player.cheats;
    mVelocity = player.mo.vel;
    mGravity  = player.mo.gravity;

    gb_Sender.sendFreezePlayerEvent(player.cheats | FROZEN_CHEATS_FLAGS, (0, 0, 0), 0);

    PlayerPawnBase pbPlayer = PlayerPawnBase(players[consolePlayer].mo);
    if(pbPlayer && pbPlayer.oldPTics.Size() == 0)
    {
      let pspr = player.psprites;

      while (pspr)
      {
        pbPlayer.oldPTics.Push(pspr.Tics);
        pspr.Tics = -1;
        pspr = pspr.Next;
      }
    }
  }

  private
  void thawLevel() const
  {
    level.setFrozen(0);
  }

  private
  void thawPlayer()
  {
    if (mWasPlayerFrozen) gb_Sender.sendFreezePlayerEvent(mCheats, mVelocity, mGravity);
    mWasPlayerFrozen = false;

    PlayerPawnBase pbPlayer = PlayerPawnBase(players[consolePlayer].mo);
    if(pbPlayer && pbPlayer.oldPTics.Size() > 0)
    {
      let pspr = players[consoleplayer].psprites;
      while(pspr && pbPlayer.oldPTics.Size() > 0)
      {
        pspr.Tics = pbPlayer.oldPTics[0];
        pbPlayer.oldPTics.Delete(0);
        pspr = pspr.Next;
      }
    }
  }

  const FROZEN_CHEATS_FLAGS  = CF_TotallyFrozen | CF_Frozen;

  private bool    mWasFrozen;

  private bool    mWasLevelFrozen;
  private bool    mWasPlayerFrozen;

  private int     mCheats;
  private vector3 mVelocity; // to reset weapon bobbing.
  private double  mGravity;

  private gb_Options mOptions;
} // class gb_Freezer
