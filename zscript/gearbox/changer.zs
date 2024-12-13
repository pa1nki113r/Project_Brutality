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

class gb_Changer play
{

  static
  gb_Changer from(gb_Caption caption, gb_Options options, gb_InventoryUser inventoryUser)
  {
    let result = new("gb_Changer");
    result.mCaption       = caption;
    result.mOptions       = options;
    result.mInventoryUser = inventoryUser;
    return result;
  }

  void selectWeapon(PlayerInfo player, string weapon)
  {
    Weapon targetWeapon = Weapon(player.mo.findInventory(weapon));
    if (targetWeapon && gb_WeaponWatcher.currentFor(player) != targetWeapon.getClass())
    {
      player.pendingWeapon = targetWeapon;
      if (mOptions.isShowingWeaponTagsOnChange()) mCaption.setActor(targetWeapon);
    }
  }

  void useItem(PlayerInfo player, string item)
  {
    mInventoryUser.addToQueue(player, item);
  }
  
  void giveItem(PlayerInfo player, string item)	//added to, well, give items to the player
  {
	player.mo.A_giveinventory(item,1);
  }

  static
  void setAngles(PlayerInfo player, double pitch, double angle)
  {
    if (player.mo == NULL) return;

    player.cheats |= CF_InterpView;
    player.mo.pitch = pitch;
    player.mo.angle = angle;

    // To prevent mods that add weapon sway from swaying while moving mouse in wheel.
    player.cmd.yaw   = 0;
    player.cmd.pitch = 0;
  }

  static
  void freezePlayer( PlayerInfo player
                   , int        cheats
                   , double     velocityX
                   , double     velocityY
                   , double     velocityZ
                   , double     gravity
                   )
  {
    if (player.mo == NULL) return;

    vector3 velocity  = (velocityX, velocityY, velocityZ);
    player.cheats     = cheats;
    player.vel        = velocity.xy;
    player.mo.vel     = velocity;
    player.mo.gravity = gravity;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private gb_Caption       mCaption;
  private gb_Options       mOptions;
  private gb_InventoryUser mInventoryUser;

} // class gb_Changer
