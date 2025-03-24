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

class gb_WeaponOrderOperations
{

  static
  gb_WeaponOrderOperations from()
  {
    let result = new("gb_WeaponOrderOperations");
    result.index.clear();
    result.operationType.clear();
    return result;
  }

  Array<int> index;
  Array<int> operationType;

} // class gb_WeaponOrderOperations

class gb_CustomWeaponOrderStorage
{

  enum OperationType
  {
    RotatePriority,
    RotateSlot,
  }

  static
  string calculateHash(gb_WeaponData data)
  {
    string dataString;

    uint nWeapons = data.weapons.size();
    for (uint i = 0; i < nWeapons; ++i)
    {
      dataString.appendFormat("%s%d", data.weapons[i].getClassName(), data.slots[i]);
    }

    return gb_MD5.hash(dataString, false);
  }

  static
  void applyOperations(string weaponSetHash, gb_WeaponMenu menu)
  {
    let operations = gb_WeaponOrderOperations.from();
    string operationsData = loadFromStorage(weaponSetHash);
    deserializeOperations(operationsData, operations);

    uint nOperations = operations.index.size();
    for (uint i = 0; i < nOperations; ++i)
    {
      switch (operations.operationType[i])
      {
      case RotatePriority:
        menu.rotatePriorityForIndex(operations.index[i]);
        break;

      case RotateSlot:
        menu.rotateSlotForIndex(operations.index[i]);
        break;

      default:
        Console.printf("Unknown operation: %d.", operations.operationType[i]);
      }
    }
  }

  static
  void savePriorityRotation(string weaponSetHash, int index)
  {
    saveOperation(weaponSetHash, index, RotatePriority);
  }

  static
  void saveSlotRotation(string weaponSetHash, int index)
  {
    saveOperation(weaponSetHash, index, RotateSlot);
  }

  static
  void reset(string weaponSetHash)
  {
    Dictionary weaponSetOrders = readWeaponSetOrders();
    weaponSetOrders.remove(weaponSetHash);
    getStorageCvar().setString(weaponSetOrders.toString());
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  static
  void saveOperation(string weaponSetHash, int index, int operationType)
  {
    let operations = gb_WeaponOrderOperations.from();
    {
      string operationsData = loadFromStorage(weaponSetHash);
      deserializeOperations(operationsData, operations);
    }

    operations.index        .push(index);
    operations.operationType.push(operationType);

    string operationsData = serializeOperations(operations);
    saveToStorage(weaponSetHash, operationsData);
  }

  private static
  void saveToStorage(string hash, string data)
  {
    Dictionary weaponSetOrders = readWeaponSetOrders();
    weaponSetOrders.insert(hash, data);
    getStorageCvar().setString(weaponSetOrders.toString());
  }

  private static
  string loadFromStorage(string hash)
  {
    return readWeaponSetOrders().at(hash);
  }

  private static
  Dictionary readWeaponSetOrders()
  {
    return Dictionary.fromString(getStorageCvar().getString());
  }

  private static
  Cvar getStorageCvar()
  {
    return Cvar.getCvar(STORAGE_CVAR_NAME);
  }

  private static
  string serializeOperations(gb_WeaponOrderOperations operations)
  {
    string result;
    uint nOperations = operations.index.size();
    for (uint i = 0; i < nOperations; ++i)
    {
      result.appendFormat( "%d" .. DELIMITER .. "%d" .. DELIMITER
                         , operations.index[i]
                         , operations.operationType[i]
                         );
    }
    return result;
  }

  private static
  void deserializeOperations(string data, out gb_WeaponOrderOperations operations)
  {
    Array<string> tokens;
    data.split(tokens, DELIMITER, TOK_SkipEmpty);

    if (tokens.size() % 2 != 0)
    {
      Console.printf("Weapon order data is corrupted!");
      return;
    }

    uint nTokens = tokens.size();
    for (uint i = 0; i < nTokens; i += 2)
    {
      operations.index        .push(tokens[i    ].toInt());
      operations.operationType.push(tokens[i + 1].toInt());
    }
  }

  const STORAGE_CVAR_NAME = "gb_custom_weapon_order";
  const DELIMITER = ";";

} // class gb_CustomWeaponOrderStorage
