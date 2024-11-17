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

class pc_EventHandler : EventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////

  override void WorldTick()
  {
    if (!_isInitialized) { initialize(); }
    prepareProjection();
  }

  override void RenderOverlay(RenderEvent event)
  {
    if (!_isInitialized || !_isPrepared) { return; }

    PlayerInfo player = players[consolePlayer];

    if (player == NULL) { return; }

    loadTarget(event.viewAngle, event.viewPitch);
    loadCrosshair(player);
    drawCrosshair(player, event);
  }

// private: ////////////////////////////////////////////////////////////////////

  private
  void initialize()
  {
    PlayerInfo player = players[consolePlayer];

    _glProjection  = new("pc_Le_GlScreen");
    _swProjection  = new("pc_Le_SwScreen");
    _cvarRenderer  = Cvar.GetCvar("vid_rendermode", player);
    _settings      = new("pc_Settings").init(player);

    _yPositionInterpolator = DynamicValueInterpolator.Create(Screen.GetHeight() / 2, 0.5, 1, 1000000);

    _isInitialized = true;
  }

  private
  void prepareProjection ()
  {
    if(_cvarRenderer)
    {
      switch (_cvarRenderer.GetInt())
      {
      default:
        _projection = _glProjection;
        break;

      case 0:
      case 1:
        _projection = _swProjection;
        break;
      }
    }
    else
    {
      console.printf("warning, cannot get render mode");
      _projection = _glProjection;
    }

    _isPrepared = (_projection != NULL);
  }

  private
  void loadTarget(double angle, double pitch) const
  {
    PlayerInfo p = players[consolePlayer];
    PlayerPawn a = p.mo;
    pitch = a.AimTarget() ? a.BulletSlope(NULL, ALF_PORTALRESTRICT) : pitch;

    FLineTraceData data;
    double hitHeight = a.height / 2 + a.AttackZOffset * p.crouchFactor;
    _hasTargetPos    = a.LineTrace(angle, 4000.0, pitch, lFlags, hitHeight, 0, 0, data);
    if (_hasTargetPos) { _targetPos = data.hitlocation; }
  }

// private: ////////////////////////////////////////////////////////////////////

  private ui
  void drawCrosshair(PlayerInfo player, RenderEvent event)
  {
    Vector2 drawPos = makeDrawPos(player, event);

    setExternalY(player, drawPos.y);

    if (  !_isCrossExisting
       || gamestate == GS_TITLELEVEL
       || player.mo.health <= 0
       || automapactive
       || !pc_enable
       || disabledOnSlot1(player)
       || disableWhenNotReady(player)
       || disableOnNoWeapon(player)
       )
    {
      return;
    }

    int screenWidth  = Screen.GetWidth();
    int screenHeight = Screen.GetHeight();

    double size = (crosshairscale > 0.0f)
                ? screenHeight * crosshairscale / 200.0
                : 1.0;

    if (crosshairgrow) { size *= StatusBar.CrosshairSize; }

    Vector2 textureSize = TexMan.GetScaledSize(_crosshairTexture);
    int width  = int(textureSize.x * size);
    int height = int(textureSize.y * size);

    bool hasHealth;
    int  health, maxHealth;
    [hasHealth, health, maxHealth] = getHealths(player);
    int crossColor = makeCrosshairColor(hasHealth, health, maxHealth);

    _yPositionInterpolator.Update(int(drawPos.y));

    Screen.DrawTexture( _crosshairTexture
                      , false
                      , screenWidth / 2
                      , _yPositionInterpolator.GetValue()
                      , DTA_DestWidth    , width
                      , DTA_DestHeight   , height
                      , DTA_AlphaChannel , true
                      , DTA_KeepRatio    , true
                      , DTA_FillColor    , crossColor & 0xFFFFFF
                      , DTA_FlipX        , _settings.isFlipX()
                      , DTA_FlipY        , _settings.isFlipY()
                      );
  }

  /**
   * @returns noHealth flag, current health, max health.
   */
  private ui
  bool, int, int getHealths(PlayerInfo player)
  {
    if (_settings.isTargetHealth())
    {
      let aimTarget = getAimTarget(player.mo);
      if (aimTarget)
      {
        return true, aimTarget.health, aimTarget.GetSpawnHealth();
      }
      else
      {
        return false, 0, 0;
      }
    }

    int health     = player.health;
    int maxHealth  = getDefaultHealth(player);

    return true, health, maxHealth;
  }

  private play
  Actor getAimTarget(Actor a) const
  {
    return a.AimTarget();
  }

  private static ui
  int makeCrosshairColor(bool hasHealth, int health, int maxHealth)
  {
    if (!hasHealth)
    {
      return crosshaircolor;
    }

    if (crosshairhealth == 1)
    {
      // "Standard" crosshair health (green-red)
      int health = scale(health, 100, maxHealth);

      if (health >= 85)
      {
        return 0x00ff00;
      }
      else
      {
        int red;
        int green;

        health -= 25;
        if (health <  0) { health = 0; }
        if (health < 30)
        {
          red   = 255;
          green = health * 255 / 30;
        }
        else
        {
          red   = (60 - health) * 255 / 30;
          green = 255;
        }
        return (red<<16) | (green<<8);
      }
    }
    else if (crosshairhealth == 2)
    {
      // "Enhanced" crosshair health (blue-green-yellow-red)
      int health = clamp(scale(health, 100, maxHealth), 0, 200);
      double rr;
      double gg;
      double bb;

      double saturation = health < 150 ? 1.0 : 1.0 - (health - 150) / 100.0;

      HSVtoRGB(rr, gg, bb, health * 1.2f, saturation, 1);
      int red   = int(rr * 255);
      int green = int(gg * 255);
      int blue  = int(bb * 255);

      return (red<<16) | (green<<8) | blue;
    }

    return crosshaircolor;
  }

  private ui
  Vector2 makeDrawPos(PlayerInfo player, RenderEvent event)
  {
    if (!_hasTargetPos)
    {
      int x, y, width, height;
      [x, y, width, height] = Screen.GetViewWindow();
      int screenHeight      = Screen.GetHeight();
      int statusBarHeight   = screenHeight - height - x;
      return (Screen.GetWidth() / 2, (Screen.GetHeight() - statusBarHeight) / 2);
    }

    _projection.CacheResolution();
    _projection.CacheFov(player.fov);
    _projection.OrientForRenderOverlay(event);
    _projection.BeginProjection();

    _projection.ProjectWorldPos(_targetPos);

    pc_Le_Viewport viewport;
    viewport.FromHud();

    Vector2 drawPos = viewport.SceneToWindow(_projection.ProjectToNormal());

    return drawPos;
  }

  private ui
  void loadCrosshair(PlayerInfo player)
  {
    int num = 0;

    if (  !crosshairforce
       && NULL != player.camera
       && NULL != player.camera.player
       && NULL != player.camera.player.readyWeapon
       )
    {
      num = player.camera.player.readyWeapon.crosshair;
    }
    if (num == 0)
    {
      num = crosshair;
    }
    if (_crosshairnum == num && _isCrossExisting)
    {
      return;
    }

    if (num == 0)
    {
      _crosshairNum    = 0;
      _isCrossExisting = false;
      return;
    }
    if (num < 0)
    {
      num = -num;
    }
    string size = (Screen.GetWidth() < 640) ? "S" : "B";

    string texName = String.Format("XHAIR%s%d", size, num);
    TextureID texId = checkTexture(texName);
    if (!texId.isValid())
    {
      texName = String.Format("XHAIR%s1", size);
      texId = checkTexture(texName);
      if (!texId.isValid())
      {
        texId = checkTexture("XHAIRS1");
      }
    }

    _crosshairNum     = num;
    _crosshairTexture = texId;
    _isCrossExisting  = true;
  }

  private ui
  TextureId checkTexture(string name)
  {
    return TexMan.CheckForTexture( name
                                 , TexMan.Type_MiscPatch
                                 , TexMan.TryAny | TexMan.ShortNameOnly
                                 );
  }

  private play
  void setExternalY(PlayerInfo player, double y) const
  {
    if (_externalY == NULL)
    {
      _externalY = Cvar.GetCVar("pc_y", player);
    }

    _externalY.SetFloat(y);
  }

// private: ////////////////////////////////////////////////////////////////////

  private ui static
  int scale(int value, int scaleMax, int valueMax)
  {
    return value * scaleMax / valueMax;
  }

  private ui static
  int getDefaultHealth(PlayerInfo player)
  {
    class<PlayerPawn> type = player.mo.GetClassName();
    let default = GetDefaultByType(type);
    return default.health;
  }

  private play
  bool disabledOnSlot1(PlayerInfo player) const
  {
    return _settings.isDisabledOnSlot1() && isSlot1(player);
  }

  private play
  bool disableWhenNotReady(PlayerInfo player) const
  {
    return _settings.isDisabledOnNotReady() && !isWeaponReady(player);
  }

  private play
  bool disableOnNoWeapon(PlayerInfo player) const
  {
    return _settings.isDisabledOnNoWeapon() && isNoWeapon(player);
  }

  private static
  bool isSlot1(PlayerInfo player)
  {
    Weapon w = player.readyWeapon;
    if (w == NULL) { return false; }

    int located;
    int slot;
    [located, slot] = player.weapons.LocateWeapon(w.GetClassName());

    bool slot1 = (slot == 1);
    return slot1;
  }

  private static
  bool isWeaponReady(PlayerInfo player)
  {
    bool isReady
       = player.WeaponState & WF_WEAPONREADY
      || player.WeaponState & WF_WEAPONREADYALT
      || player.WeaponState & WF_WEAPONZOOMOK
      || player.cmd.buttons & BT_ATTACK
      || player.cmd.buttons & BT_ALTATTACK
       ;

    return isReady;
  }

  private static
  bool isNoWeapon(PlayerInfo player)
  {
    Weapon w    = player.readyWeapon;
    bool   isNo = (w == NULL) || (w.GetClassName() == "m8f_wm_Holstered");

    return isNo;
  }

  private static ui
  void HSVtoRGB (out double r, out double g, out double b, double h, double s, double v)
  {
    int i;
    double f, p, q, t;

    if (s == 0)
    { // achromatic (grey)
      r = g = b = v;
      return;
    }

    h /= 60;                                    // sector 0 to 5
    i = int(floor(h));
    f = h - i;                                  // factorial part of h
    p = v * (1 - s);
    q = v * (1 - s * f);
    t = v * (1 - s * (1 - f));

    switch (i)
    {
    case 0:     r = v; g = t; b = p; break;
    case 1:     r = q; g = v; b = p; break;
    case 2:     r = p; g = v; b = t; break;
    case 3:     r = p; g = q; b = v; break;
    case 4:     r = t; g = p; b = v; break;
    default:    r = v; g = p; b = q; break;
    }
  }

// private: ////////////////////////////////////////////////////////////////////

  private Vector3          _targetPos;
  private bool             _hasTargetPos;

  private ui int           _crosshairNum;
  private ui bool          _isCrossExisting;
  private ui TextureID     _crosshairTexture;

  private transient bool   _isInitialized;
  private transient bool   _isPrepared;
  private transient Cvar   _cvarRenderer;
  private transient Cvar   _externalY;

  private pc_Le_ProjScreen _projection;
  private pc_Le_GlScreen   _glProjection;
  private pc_Le_SwScreen   _swProjection;

  private pc_Settings      _settings;

  private DynamicValueInterpolator _yPositionInterpolator;

// private: ////////////////////////////////////////////////////////////////////

  const lFlags = LAF_NOIMPACTDECAL | LAF_NORANDOMPUFFZ;

} // class pc_EventHandler : EventHandler
