/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2019-2021
 *
 * This file is part of Target Spy.
 *
 * Target Spy is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Target Spy is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */


/* Modified a very stripped-down barebones version of target spy's event handler
   in order to handle the HUD indicators for executing enemies (and other misc
   things in the future, probably).
   
   This is NOT intended to serve as a replacement to target spy but rather use a
   specific feature (drawFrame) to compliment a new gameplay mechanic in PB

*/
class pb_ExecutionHandler : EventHandler
{
	
  private pb_ProjScreen 	_projection;
  private pb_uiHack 		_translator;
  private transient bool   _isInitialized;

  override
  void playerEntered(PlayerEvent event)
  {
    if (level.mapName == "TITLEMAP")
    {
      destroy();
      return;
    }

    if (event.playerNumber != consolePlayer) return;
	
    _translator     = NULL;

  }

  override
  void renderOverlay(RenderEvent event)
  {
    if (!_isInitialized || automapActive || players[consolePlayer].mo == NULL)
    {
      return;
    }
    drawEverything(event);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private ui
  void drawEverything(RenderEvent event)
  {
  
	
// 	CVar experimental_settings = CVar.FindCVar('pb_experimental');
// 	if(experimental_settings.GetBool()){
  
		Actor target = getTarget();
		
		if(target && target.bCountKill) {
			if(actorCanBeExecuted(target) && getTargetDistance() < 200)
			{
				draw(target, event);
			}
		}
// 	}
  }
  
	private ui
	bool actorCanBeExecuted(Actor monster) {
		
		int targetMaxHealth = monster.spawnHealth();
		int targetCurrentHealth = monster.health;
		
		PlayerPawn player = players[consolePlayer].mo;
		
		if(null != player.FindInventory("PB_PowerStrength") && (targetCurrentHealth <= targetMaxHealth*0.25 || targetCurrentHealth <= 150)) {
			return true;
		}
		
		if(targetCurrentHealth < targetMaxHealth*0.20 || targetCurrentHealth <= 60) {
			return true;
		}
		
		return false;
		
	}


  private ui
  Vector2 makeDrawPos(RenderEvent event, Actor target, double offset)
  {
    PlayerInfo player = players[consolePlayer];

    _projection.cacheResolution();
    _projection.cacheFov(player.fov);
    _projection.orientForRenderOverlay(event);
    _projection.beginProjection();

    _projection.projectWorldPos(target.pos + (0, 0, offset));

    pb_Viewport viewport;
    viewport.fromHud();

    Vector2 drawPos = viewport.sceneToWindow(_projection.projectToNormal());

    return drawPos;
  }

  private ui
  void drawFrame(RenderEvent event, Actor target)
  {
    PlayerInfo player = players[consolePlayer];
    Vector2 centerPos = makeDrawPos(event, target, target.height / 2.0);
    double   distance = player.mo.distance3D(target);
    if (distance == 0) return;
	
	CVar draw_box = CVar.FindCVar('pb_execution_box');
	if (!draw_box.GetBool()) return;

    double  height        = target.height;
    double  radius        = target.radius;
    double  zoomFactor    = abs(sin(player.fov));
    double  visibleRadius = radius * 2000.0 / distance / zoomFactor;
    double  visibleHeight = height * 1000.0 / distance / zoomFactor;


    double  size       = 1.0;
    double  halfWidth  = visibleRadius / 2.0 * size;
    double  halfHeight = visibleHeight / 2.0 * size;

	Vector2 left   = (centerPos.x - halfWidth, centerPos.y);
    Vector2 right  = (centerPos.x + halfWidth, centerPos.y);
    Vector2 top    = (centerPos.x, centerPos.y - halfHeight);
    Vector2 bottom = (centerPos.x, centerPos.y + halfHeight);

	Vector2 centerTop   = (centerPos.x,  top.y);

    Vector2 topLeft     = (left.x,  top.y);
    Vector2 topRight    = (right.x, top.y);
    Vector2 bottomLeft  = (left.x,  bottom.y);
    Vector2 bottomRight = (right.x, bottom.y);
	
	let  frameName      = "ts_framr";
	let  topLeftTex     = TexMan.checkForTexture(frameName                  , TexMan.TryAny);
	let  topRightTex    = TexMan.checkForTexture(frameName.."_top_right"    , TexMan.TryAny);
	let  bottomLeftTex  = TexMan.checkForTexture(frameName.."_bottom_left"  , TexMan.TryAny);
	let  bottomRightTex = TexMan.checkForTexture(frameName.."_bottom_right" , TexMan.TryAny);
	bool animate        = false;

	Screen.setClipRect( int(topLeft.x)
					, int(topLeft.y)
					, int(round(bottomRight.x - topLeft.x + 1))
					, int(round(bottomRight.y - topLeft.y + 1))
					);

	Screen.drawTexture(topLeftTex,     animate, topLeft.x,     topLeft.y    );
	Screen.drawTexture(topRightTex,    animate, topRight.x,    topRight.y   );
	Screen.drawTexture(bottomLeftTex,  animate, bottomLeft.x,  bottomLeft.y );
	Screen.drawTexture(bottomRightTex, animate, bottomRight.x, bottomRight.y);
	
	Screen.clearClipRect();
      
  }

  private ui
  void draw(Actor target, RenderEvent event)
  {
	drawFrame(event, target);
  }

  private ui
  Actor getTarget()
  {
    PlayerInfo player = players[consolePlayer];
    if (player.mo == NULL) return NULL;

    // try an easy way to get a target (also works with autoaim)
//     return player.mo.aimTarget();


    Actor target   = _translator.aimTargetWrapper(player.mo);
	
	
	return target;

  }
  
  private ui
  double getTargetDistance() {
  
    PlayerInfo player = players[consolePlayer];
    if (player.mo == NULL) return 0;
	
    double targDist  = _translator.getTargetDistanceWrapper(player.mo);
	return targDist;
	
  }


  override
  void worldTick()
  {
    if (!_isInitialized) { initialize(); }
  }
  
  
  private
  void initialize()
  {
    _projection  = new("pb_ProjScreen");
    _isInitialized = true;
  }

}
