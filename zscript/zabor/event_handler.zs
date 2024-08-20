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

class gb_VmAbortHandler : EventHandler
{

  override
  void playerSpawned(PlayerEvent event)
  {
    if (event.playerNumber != consolePlayer) return;

    mPlayerClassName = players[consolePlayer].mo.getClassName();
    mSkillName       = g_SkillName();
  }

  override
  void uiTick()
  {
    if (level.totalTime % 35 == 0) rememberSystemTime(SystemTime.now());
  }

  override
  void onDestroy()
  {
    if (gameState != GS_FullConsole
        || !Cvar.getCvar("gb_zabor_enabled", players[consolePlayer]).getBool())
    {
      return;
    }


    if (!amIFirst())
    {
      printGearboxCvars();
      return;
    }

    printInfo();
    printAttention();
  }

  override
  void consoleProcess(ConsoleEvent event)
  {
    if (event.name != "zabor") return;

    if (!amIFirst())
    {
      printGearboxCvars();
      return;
    }

    printInfo();
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private clearscope
  void printInfo()
  {
    printZabor(getGameInfo(), getConfiguration(), getRealTime());
    printGearboxCvars();
    printEventHandlers();
  }

  private static clearscope
  void printGearboxCvars()
  {
    Array<string> gearboxConfiguration =
      {
        intCvarToString   ("gb_scale"                   ),
        colorCvarToString ("gb_color"                   ),
        colorCvarToString ("gb_dim_color"               ),
        intCvarToString   ("gb_show_tags"               ),

        intCvarToString   ("gb_view_type"               ),

        intCvarToString   ("gb_enable_dim"              ),
        intCvarToString   ("gb_enable_blur"             ),
        floatCvarToString ("gb_wheel_position"          ),
        floatCvarToString ("gb_wheel_scale"             ),
        intCvarToString   ("gb_wheel_tint"              ),
        intCvarToString   ("gb_multiwheel_limit"        ),

        floatCvarToString ("gb_blocks_position_x"       ),
        floatCvarToString ("gb_blocks_position_y"       ),

        intCvarToString   ("gb_text_scale"              ),
        floatCvarToString ("gb_text_position_x"         ),
        floatCvarToString ("gb_text_position_y"         ),
        floatCvarToString ("gb_text_position_y_max"     ),
        intCvarToString   ("gb_text_usual_color"        ),
        intCvarToString   ("gb_text_selected_color"     ),

        stringCvarToString("gb_font"                    ),

        intCvarToString   ("gb_open_on_scroll"          ),
        intCvarToString   ("gb_open_on_slot"            ),
        intCvarToString   ("gb_reverse_slot_cycle_order"),
        intCvarToString   ("gb_select_first_slot_weapon"),
        intCvarToString   ("gb_mouse_in_wheel"          ),
        intCvarToString   ("gb_select_on_key_up"        ),
        intCvarToString   ("gb_no_menu_if_one"          ),
        intCvarToString   ("gb_on_automap"              ),
        intCvarToString   ("gb_lock_positions"          ),
        intCvarToString   ("gb_enable_sounds"           ),
        intCvarToString   ("gb_frozen_can_open"         ),

        intCvarToString   ("gb_time_freeze"             ),

        floatCvarToString ("gb_mouse_sensitivity_x"     ),
        floatCvarToString ("gb_mouse_sensitivity_y"     )
      };

    // cut prefix:
    uint nCvars = gearboxConfiguration.size();
    for (uint i = 0; i < nCvars; ++i)
    {
      string value = gearboxConfiguration[i];
      if (value.left(3) == "gb_")
      {
        gearboxConfiguration[i] = value.mid(3);
      }
    }

    string report = "\cigb_*\c-: " .. join(gearboxConfiguration, ", ");

    Console.printf("%s", report);
  }

  private static clearscope
  string intCvarToString(string cvarName)
  {
    let aCvar = Cvar.getCvar(cvarName, players[consolePlayer]);
    return aCvar ? string.format("%s:\cu%d\c-", cvarName, aCvar.getInt()) : "";
  }

  private static clearscope
  string floatCvarToString(string cvarName)
  {
    let aCvar = Cvar.getCvar(cvarName, players[consolePlayer]);
    return aCvar ? string.format("%s:\cu%f\c-", cvarName, aCvar.getFloat()) : "";
  }

  private static clearscope
  string colorCvarToString(string cvarName)
  {
    let aCvar = Cvar.getCvar(cvarName, players[consolePlayer]);
    return aCvar ? string.format("%s:\cu0x%x\c-", cvarName, aCvar.getInt()) : "";
  }

  private static clearscope
  string stringCvarToString(string cvarName)
  {
    let aCvar = Cvar.getCvar(cvarName, players[consolePlayer]);
    return aCvar ? string.format("%s:\cu%s\c-", cvarName, aCvar.getString()) : "";
  }

  private static clearscope
  string getConfiguration()
  {
    Array<string> configuration =
      {
        intCvarToString("compatflags"),
        intCvarToString("compatflags2"),
        intCvarToString("dmflags"),
        intCvarToString("dmflags2"),
        floatCvarToString("autoaim")
      };

    return string.format("%s", join(configuration, ", "));
  }

  private clearscope
  void printAttention()
  {
    string userName = players[consolePlayer].getUserName();
    string message1 = string.format( "  # %s\cg, please report this VM abort to mod author."
                                   , userName
                                   );
    string message2 = "  # Attach screenshot to the report.";
    string message3 = "  # Type \"screenshot\" below to take a screenshot.";

    Array<string> tokens;
    userName.split(tokens, "\c");
    int colorCharsCount = (tokens.size() - 1) * 3;
    int length = max(max(message1.length() - colorCharsCount, message2.length()), message3.length());

    message1 = fillBox(message1, length);
    message2 = fillBox(message2, length);
    message3 = fillBox(message3, length);

    string hashes;
    for (int i = 0; i < length; ++i)
    {
      hashes = hashes .. "#";
    }
    Console.printf("\n\cg  %s\n%s\n%s\n%s\n  %s\n", hashes, message1, message2, message3, hashes);
  }

  private static clearscope
  string fillBox(string result, int length)
  {
    for (int i = result.length(); i < length; ++i) result.appendFormat(" ");
    result.appendFormat(" #");
    return result;
  }

  private static clearscope
  void printZabor(string s1 = "", string s2 = "", string s3 = "")
  {
    Console.printf(
      "\ci __  __  __  __  __  __\n"
      "\ci/  \\/  \\/  \\/  \\/  \\/  \\\n"
      "\ci|Za||bo||r ||v1||.1||.0| \c-%s\n"
      "\ci|..||..||..||..||..||..| \c-%s\n"
      "\ci|__||__||__||__||__||__| \c-%s\n"
      , s1, s2, s3
    );
  }

  private clearscope
  bool amIFirst()
  {
    uint nClasses = AllClasses.size();
    for (uint i = 0; i < nClasses; ++i)
    {
      class aClass = AllClasses[i];
      string className = aClass.getClassName();
      bool isVmAbortHandler = (className.indexOf("VmAbortHandler") != -1);
      if (!isVmAbortHandler) continue;

      return aClass.getClassName() == getClassName();
    }
    return false;
  }

  private clearscope
  string getGameInfo()
  {
    return string.format( "map:\cu%s\c-, time:\cu%d\c-, multiplayer:\cu%d\c-, "
                          "class:\cu%s\c-, skill:\cu%s\c-"
                        , level.mapName
                        , level.totalTime
                        , multiplayer
                        , mPlayerClassName
                        , mSkillName
                        );
  }

  private static clearscope
  void printEventHandlers()
  {
    Array<string> eventHandlers;

    uint nClasses = AllClasses.size();
    for (uint i = 0; i < nClasses; ++i)
    {
      class aClass = AllClasses[i];

      if (  aClass is "StaticEventHandler"
         && aClass != "StaticEventHandler"
         && aClass != "EventHandler"
         )
      {
        eventHandlers.push(aClass.getClassName());
      }
    }

    Console.printf("\cievent handlers\c-: %s", join(eventHandlers, ", "));
  }

  private clearscope
  string getRealTime()
  {
    return string.format("system time: \cu%s", SystemTime.format("%F %T %Z", mSystemTime));
  }

  private static clearscope
  string join(Array<string> strings, string delimiter)
  {
    string result;

    uint nStrings = strings.size();
    for (uint i = 0; i < nStrings; ++i)
    {
      if (strings[i].length() == 0) continue;

      if (result.length() == 0)
      {
        result = strings[i];
      }
      else
      {
        result.appendFormat("%s%s", delimiter, strings[i]);
      }
    }

    return result;
  }

  private play
  void rememberSystemTime(int value) const
  {
    mSystemTime = value;
  }

  private string mPlayerClassName;
  private string mSkillName;
  private int mSystemTime;

} // class gb_VmAbortHandler
