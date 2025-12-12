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
  private textureID			ExecutionIcon, AxeIcon;
  private transient	cvar	_Enabled,_IndicatorType;
  
  const maxTexTypes 	=	7;
  private textureID			IndicatorTex[maxTexTypes];
  
  private
  void initialize()
  {
    _projection  	= 	new("pb_ProjScreen");
    _isInitialized 	= 	true;
	ExecutionIcon 	=	texman.checkfortexture("GRAPHICS/HUD/Icons/1KILLS.png");
	AxeIcon			=	texman.checkfortexture("GRAPHICS/HUD/Icons/AxeCount.png");
	_Enabled		=	Cvar.getcvar("pb_execution_box",players[consolePlayer]);
	_IndicatorType	=	Cvar.getcvar("pb_execution_indicatorType",players[consolePlayer]);
	for(int i = 0; i < maxTexTypes; i++)
	{
		//ExInd0-5 credits: Kenney Vleugels 
		string tx = "graphics/execution_frame/ExInd"..i..".png";
		IndicatorTex[i] = texman.checkfortexture(tx);
	}
  }

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
      return;
	drawEverything(event);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

	private ui
	void drawEverything(RenderEvent event)
	{
		Actor target = getTarget();
		if(target && target.bCountKill) 
		{
			if(actorCanBeExecuted(target) && getTargetDistance() < 200)
			{
                if(!PB_HelpNotificationsHandler.CheckTipEvent(1 << 3, CVar.GetCvar("pb_helpflags", players[consoleplayer])))
                {
                    Array<String> pbTipsBuf;
                    pbTipsBuf.Push("If you see a red frame around an enemy, that means they can be executed.");
                    pbTipsBuf.Push("You can execute an enemy by pressing the Quick Melee button or punching them while the red frame is being displayed.");
                    pbTipsBuf.Push("Executing enemies will grant you a bit of health, depending on the amount you currently have.");
                    pbTipsBuf.Push("The Berserk powerup will also lower the health threshold required to execute an enemy.");
                    PB_HelpNotificationsHandler.PB_SendTipArray(pbTipsBuf, "pb_helpflags", 1 << 3);
                }
				draw(target, event);
			}
		}
	}
  
	private ui
	bool actorCanBeExecuted(Actor monster) 
	{
		int targetMaxHealth = monster.spawnHealth();
		int targetCurrentHealth = monster.health;
		
		PlayerPawn player = players[consolePlayer].mo;
		
		if(null != player.FindInventory("PB_PowerStrength") && (targetCurrentHealth <= targetMaxHealth*0.25 || targetCurrentHealth <= 150)) 
			return true;
		
		if(targetCurrentHealth < targetMaxHealth*0.20 || targetCurrentHealth <= 60) 
			return true;
		
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
	
	if(!_Enabled.getbool())
		return;
	
	Vector2 centerPos = makeDrawPos(event, target, target.height / 2.0);
    double   distance = player.mo.distance3D(target);
    if (distance == 0) return;
	
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
	
	bool animate        = false;

	Screen.setClipRect( int(topLeft.x)
					, int(topLeft.y)
					, int(round(bottomRight.x - topLeft.x + 1))
					, int(round(bottomRight.y - topLeft.y + 1))
					);
	
	int indtype = _IndicatorType.getint();
	textureID	toDraw = IndicatorTex[clamp(indtype,0,IndicatorTex.size()-1)];
	textureID	KillIcon = ExecutionIcon;
	bool axe = false;
	
	if(distance > 200)
	{
		//KillIcon = AxeIcon;
		//axe = true;
	}
	
	int col = 0xFFFF0000;
	int style = STYLE_ADD;
	
	adjustindicator(target,style,col);
	
	double rot = gametic*2 % 360;	//rotation thing
	double ez = 0;	//growing
	if(indtype != 5)
		ez = sin(gametic * 4)**2;
	
	vector2 TexDim = texman.getscaledsize(KillIcon);
	texDim = (min(texDim.x,38),min(texDim.y,40));
	switch(indtype)
	{
		case -2:
			string ky = string.format("%s[%s]",(axe ? "\cvAxe Kill" : "\cgExecute"),getbind());
			int wd = smallfont.StringWidth(ky), hg = smallfont.getheight();
			screen.dim(0x050505,0.30,centerPos.x - int(wd/2),top.y+hg,wd,hg);
			screen.drawtext(smallfont,font.CR_UNTRANSLATED,centerPos.x - int(wd/2),top.y+hg,ky);
			break;
		
		//full indicator
		default:
			Screen.drawTexture(toDraw,animate, centerPos.x, centerPos.y,DTA_LegacyRenderStyle,style,DTA_Color,col,
			DTA_DestWidthF,halfWidth + ez * (halfWidth * 0.4),DTA_DestHeightF,halfHeight + ez * (halfHeight * 0.4),DTA_Rotate, rot);
		
		//only the little icon
		case -1:
			if(axe)	//axe icon looks weird when recolored
			{
				Screen.drawTexture(KillIcon, animate,centerPos.x - int(TexDim.x/2),top.y + TexDim.y,DTA_LegacyRenderStyle,STYLE_ADD,
				DTA_DestWidthF,TexDim.x,DTA_DestHeightF,TexDim.y);
			}
			else
			{
				Screen.drawTexture(KillIcon, animate,centerPos.x - int(TexDim.x/2),top.y + TexDim.y,DTA_LegacyRenderStyle,STYLE_ADD,DTA_Color,0xFFFF0000,
				DTA_DestWidthF,TexDim.x,DTA_DestHeightF,TexDim.y);
			}
			break;
	}
	
	Screen.clearClipRect();
      
  }
  
  clearscope string getbind()
  {
	Array<int> keys;
    bindings.getAllKeysForCommand(keys, "+user2");
	return bindings.nameallkeys(keys);
  }
  
  clearscope void adjustindicator(actor victim,in out int style, in out int basecolor)
  {
	//we can use some flag or property to check and edit the renderstyle and color of the indicator from here
	//will be useful when more pb monsters with different blood colors gets added
	if(!victim)
		return;
		
	//blood color based coloring
	if(victim.bloodcolor != "000000")
		basecolor = 0xFF000000 | victim.bloodcolor;
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
  double getTargetDistance() 
  {
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

}