/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
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
 * We could use inventory items directly, but player cannot use items when
 * totally frozen. Therefore, we have to wait until player is not frozen.
 */
class gb_InventoryUser play
{

  static
  gb_InventoryUser from()
  {
    return new("gb_InventoryUser");
  }

  void use()
  {
    for (uint i = 0; i < mItemQueue.size();)
    {
      PlayerPawn player = mPlayerQueue[i].mo;
      if (player == NULL)
      {
        deleteFromQueue(i);
        continue;
      }

      Inventory item = player.findInventory(mItemQueue[i]);
      if (item == NULL)
      {
        deleteFromQueue(i);
        continue;
      }

      if (player.player.isTotallyFrozen())
      {
        ++i;
        continue;
      }
      else
      {
        player.useInventory(item);
        deleteFromQueue(i);
      }
    }
  }

  void addToQueue(PlayerInfo player, string item)
  {
    mPlayerQueue.push(player);
    mItemQueue.push(item);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void deleteFromQueue(uint index)
  {
    mPlayerQueue.delete(index);
    mItemQueue.delete(index);
  }

  private Array<PlayerInfo> mPlayerQueue;
  private Array<string>     mItemQueue;

} // class gb_InventoryUser
