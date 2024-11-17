/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2019
 *
 * This file is a part of Precise Crosshair.
 *
 * Precise Crosshair is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Precise Crosshair is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Precise Crosshair.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * This class represents a single boolean setting.
 */
class pc_BoolSetting : pc_CvarSetting
{

  // public: ///////////////////////////////////////////////////////////////////

  bool value() { return variable().GetInt(); }

  pc_BoolSetting init(string cvarName, PlayerInfo p)
  {
    super.init(cvarName, p);
    return self;
  }

} // class pc_BoolSetting
