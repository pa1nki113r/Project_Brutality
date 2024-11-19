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
    
    printAttention();
  }

// private: ///////////////////////////////////////////////////////////////////////////////////////

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
    console.printf("%s", getGameInfo());
  }

  private static clearscope
  string fillBox(string result, int length)
  {
    for (int i = result.length(); i < length; ++i) result.appendFormat(" ");
    result.appendFormat(" #");
    return result;
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
