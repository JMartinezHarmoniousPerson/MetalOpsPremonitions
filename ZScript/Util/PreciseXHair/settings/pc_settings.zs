/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2019
 *
 * This file is a part of Precise Crosshair.
 *
 * Precise Crosshair is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
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

class pc_Settings : pc_SettingsPack
{

  pc_Settings init(PlayerInfo player)
  {
    _player = player;
    return self;
  }

  // public: ///////////////////////////////////////////////////////////////////

  bool isFlipX() { checkInit(); return _flipX.value(); }
  bool isFlipY() { checkInit(); return _flipY.value(); }

  bool isDisabledOnSlot1   () { checkInit(); return _disableOnSlot1   .value(); }
  bool isDisabledOnNotReady() { checkInit(); return _disableOnNotReady.value(); }
  bool isDisabledOnNoWeapon() { checkInit(); return _disableNoWeapon  .value(); }

  bool isTargetHealth() { checkInit(); return _targetHealth.value(); }

  // private: //////////////////////////////////////////////////////////////////

  private
  void checkInit()
  {
    if (_isInitialized) { return; }

    clear();

    push(_flipX             = newBoolSetting("pc_flip_x"           ));
    push(_flipY             = newBoolSetting("pc_flip_y"           ));
    push(_disableOnSlot1    = newBoolSetting("pc_disable_slot_1"   ));
    push(_disableOnNotReady = newBoolSetting("pc_disable_not_ready"));
    push(_disableNoWeapon   = newBoolSetting("pc_disable_no_weapon"));
    push(_targetHealth      = newBoolSetting("pc_target_health"    ));

    _isInitialized = true;
  }

  // private: //////////////////////////////////////////////////////////////////

  private
  pc_BoolSetting newBoolSetting(String name)
  {
    return new("pc_BoolSetting").init(name, _player);
  }

  private pc_BoolSetting _flipX;
  private pc_BoolSetting _flipY;
  private pc_BoolSetting _disableOnSlot1;
  private pc_BoolSetting _disableOnNotReady;
  private pc_BoolSetting _disableNoWeapon;
  private pc_BoolSetting _targetHealth;

  private PlayerInfo     _player;
  private transient bool _isInitialized;

} // class pc_Settings : pc_SettingsPack
