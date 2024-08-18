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

class gb_NeteventProcessor play
{

  static
  gb_NeteventProcessor from(gb_Changer changer)
  {
    let result = new("gb_NeteventProcessor");
    result.mChanger = changer;
    return result;
  }

  int process(ConsoleEvent event)
  {
    if (event.name.left(3) != "gb_") return InputNothing;

    Array<string> args;
    event.name.split(args, ":");

    PlayerInfo player = players[event.player];

    if      (args[0] == "gb_select_weapon") mChanger.selectWeapon(player, args[1]);
    else if (args[0] == "gb_use_item"     ) mChanger.useItem     (player, args[1]);
    else if (args[0] == "gb_set_angles"   ) mChanger.setAngles   (player, args[1].toDouble()
                                                                        , args[2].toDouble()
                                                                 );
    else if (args[0] == "gb_freeze_player") mChanger.freezePlayer(player, args[1].toInt()
                                                                        , args[2].toInt()
                                                                        , args[3].toDouble()
                                                                        , args[4].toDouble()
                                                                        , args[5].toDouble()
                                                                 );
    else if (args[0] == "gb_reset_custom_order") return InputResetCustomOrder;
	else if (args[0] == "gb_give_item")	mChanger.giveItem(player,args[1]);

    return InputNothing;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private gb_Changer mChanger;

} // class gb_NeteventProcessor
