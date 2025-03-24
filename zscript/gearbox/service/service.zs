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
 * This is Service interface.
 */
class gb_Service abstract
{

  virtual play
  string get(string request)
  {
    return "";
  }

  virtual ui
  string uiGet(string request)
  {
    return "";
  }

} // class gb_Service

/**
 * Use this class to find and iterate over services.
 *
 * Example usage:
 *
 * @code
 * ServiceIterator i = ServiceIterator.find("MyService");
 *
 * Service s;
 * while (s = i.next())
 * {
 *   string request = ...
 *   string answer  = s.get(request);
 *   ...
 * }
 * @endcode
 *
 * If no services are found, the all calls to next() will return NULL.
 */
class gb_ServiceIterator
{
  /**
   * Creates a Service iterator for a service name. It will iterate over all existing Services
   * with names that match @a serviceName or have it as a part of their names.
   *
   * Matching is case-independent.
   *
   * @param serviceName class name of service to find.
   */
  static
  gb_ServiceIterator find(string serviceName)
  {
    let result = new("gb_ServiceIterator");

    result.mServiceName = serviceName;
    result.mClassIndex = 0;
    result.findNextService();

    return result;
  }

  /**
   * Gets the service and advances the iterator.
   *
   * @returns service instance, or NULL if no more servers found.
   *
   * @note Each ServiceIterator will return new instances of services.
   */
  gb_Service next()
  {
    uint classesNumber = AllClasses.size();
    gb_Service result = (mClassIndex == classesNumber)
      ? NULL
      : gb_Service(new(AllClasses[mClassIndex]));

    ++mClassIndex;
    findNextService();

    return result;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void findNextService()
  {
    uint classesNumber = AllClasses.size();
    while (mClassIndex < classesNumber && !ServiceNameContains(AllClasses[mClassIndex], mServiceName))
    {
      ++mClassIndex;
    }
  }

  private static
  bool serviceNameContains(class aClass, string substring)
  {
    if (!(aClass is "gb_Service")) return false;

    string className = aClass.getClassName();
    string lowerClassName = className.makeLower();
    string lowerSubstring = substring.makeLower();
    bool result = lowerClassName.indexOf(lowerSubstring) != -1;
    return result;
  }

  private string mServiceName;
  private uint   mClassIndex;

} // class gb_ServiceIterator
