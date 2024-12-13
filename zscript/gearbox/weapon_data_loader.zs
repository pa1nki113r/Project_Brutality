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

class gb_WeaponDataLoader play
{

  /**
   * Code is adapted from
   * GZDoom::src/src/gzdoom/wadsrc/static/zscript/actors/player/player_cheat.zs::CheatGive.
   */
  static
  void load(out gb_WeaponData data)
  {
    int nClasses = AllActorClasses.Size();

    gb_WeaponInfo info;
    PlayerInfo player = players[consolePlayer];

    for (int i = 0; i < nClasses; ++i)
    {
      let type = (class<Weapon>)(AllActorClasses[i]);

      if (type == NULL || type == "Weapon") continue;

      // This check from CheatGive doesn't work here.
      // Why does it allow giving weapons for Treasure Tech there?
      // Anyway, adding some replaced weapons to the data list won't harm, they
      // won't show up unless the player has them.
      //let replacement = Actor.getReplacement(type);
      //if (replacement != type && !(replacement is "DehackedPickup")) continue;

      bool located;
      int  slot;
      int  priority;
      [located, slot, priority] = player.weapons.LocateWeapon(type);

      if (!located) continue;

      readonly<Weapon> def = GetDefaultByType(type);
      if (!def.CanPickup(player.mo)) continue;

      info.push(type, slot, priority);
    }

    sortWeapons(info);

    data.weapons.move(info.classes);
    data.slots.move(info.slots);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  void sortWeapons(gb_WeaponInfo info)
  {
    int nWeapons = info.classes.size();

    quickSortWeapons(info, 0, nWeapons - 1);
  }

  private static
  void quickSortWeapons(gb_WeaponInfo info, int lo, int hi)
  {
    if (lo < hi)
    {
      int p = quickSortWeaponsPartition(info, lo, hi);
      quickSortWeapons(info, lo,    p - 1);
      quickSortWeapons(info, p + 1, hi   );
    }
  }

  private static
  int quickSortWeaponsPartition(gb_WeaponInfo info, int lo, int hi)
  {
    int pivot = measure(info, hi);
    int i     = lo - 1;

    for (int j = lo; j <= hi - 1; ++j)
    {
      if (measure(info, j) <= pivot)
      {
        ++i;
        info.swap(i, j);
      }
    }
    info.swap(i + 1, hi);

    return i + 1;
  }

  private static
  int measure(gb_WeaponInfo info, int index)
  {
    int slot = info.slots[index];
    if (slot == 0) slot = 99;

    int result = slot * 100 + info.priorities[index];
    return result;
  }

} // class gb_WeaponDataLoader

struct gb_WeaponInfo
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  void push(class<Weapon> aClass, int slot, int priority)
  {
    classes   .push(aClass);
    slots     .push(slot);
    priorities.push(priority);
  }

  void swap(int i, int j)
  {
    {
      let tmp = classes[i];
      classes[i] = classes[j];
      classes[j] = tmp;
    }
    {
      int tmp  = slots[i];
      slots[i] = slots[j];
      slots[j] = tmp;
    }
    {
      int tmp = priorities[i];
      priorities[i] = priorities[j];
      priorities[j] = tmp;
    }
  }

// public: /////////////////////////////////////////////////////////////////////////////////////////

  Array< class<Weapon> > classes;
  Array<int>             slots;
  Array<int>             priorities;

} // struct gb_WeaponInfo
