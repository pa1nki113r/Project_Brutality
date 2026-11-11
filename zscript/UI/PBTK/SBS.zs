// [gng] this code is part of StatusBarScreen by Lewisk3, MIT License.
// see more at: https://github.com/Lewisk3/StatusBarScreen

const PBTK_SCREEN_CENTER		= 1 << 0;
const PBTK_SCREEN_TOP_CENTER	= 1 << 1;
const PBTK_SCREEN_BOTTOM_CENTER	= 1 << 2;
const PBTK_SCREEN_TOP_LEFT		= 1 << 3;
const PBTK_SCREEN_BOTTOM_LEFT	= 1 << 4;
const PBTK_SCREEN_TOP_RIGHT		= 1 << 5;
const PBTK_SCREEN_BOTTOM_RIGHT	= 1 << 6;
const PBTK_COORDS_TEXGRID		= 1 << 7;
const PBTK_NOASPECTCORRECTION   = 1 << 8;
const PBTK_TEXT_CENTER 			= 1 << 9;
const PBTK_TEXT_RIGHT			= 1 << 10;

const statscr_base_width = 960.0;
const statscr_base_height = 540.0;

class PBTK_StatusColor Abstract 
{
	static clearscope double hue2rgb(double p, double q, double t)
	{
		if(t < 0) t += 1;
		if(t > 1) t -= 1;
		if(t < 1./6.) return p + (q - p) * 6 * t;
		if(t < 1./2.) return q;
		if(t < 2./3.) return p + (q - p) * (2./3. - t) * 6;
		return p;
	}
	static clearscope Color hslToRgb(double h,double s,double l, double alpha=1.0)
	{
		double r, g, b;
		if(s == 0)
		{
			r = g = b = l;
		} 
		else
		{
			double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
			double p = 2 * l - q;
			r = hue2rgb(p, q, h + 1./3.);
			g = hue2rgb(p, q, h);
			b = hue2rgb(p, q, h - 1./3.);
		}
		return Color(int(255*alpha), int(r * 255), int(g * 255), int(b * 255));
	}
}

class PBTK_StatusBarScreen Abstract ui
{
	enum AlignFlags
	{
		SS_SCREEN_CENTER		= 1 << 0,
		SS_SCREEN_TOP_CENTER	= 1 << 1,
		SS_SCREEN_BOTTOM_CENTER	= 1 << 2,
		SS_SCREEN_TOP_LEFT		= 1 << 3,
		SS_SCREEN_BOTTOM_LEFT	= 1 << 4,
		SS_SCREEN_TOP_RIGHT		= 1 << 5,
		SS_SCREEN_BOTTOM_RIGHT	= 1 << 6,
		SS_COORDS_TEXGRID		= 1 << 7,
		SS_NOASPECTCORRECTION   = 1 << 8,
		SS_TEXT_CENTER 			= 1 << 9,
		SS_TEXT_RIGHT			= 1 << 10
	};

	static double GetBaseHeight()
	{
		return statscr_base_height;
	}
	
	static double GetBaseWidth()
	{
		return statscr_base_width;
	}
	
	// Determines the true bottom of viewspace, 
	// gets its ratio to the desired resolution.
	static double GetStatusBarHeightRatio()
	{	
		int widthOfs, heightOfs, width, height;
		[widthOfs, heightOfs, width, height] = Screen.GetViewWindow();

		int bottom = heightOfs + height;
		return double(bottom) / Screen.getHeight();
	}

	// Coord processing
	static vector2 _ProcessCoords(vector2 pos, uint flags)
	{
		double centery = (GetBaseHeight()*GetStatusBarHeightRatio())/2.;
		vector2 center			= (GetBaseWidth()/2., centery);
		vector2 top_center		= (GetBaseWidth()/2., 0);
		vector2 bottom_center	= (GetBaseWidth()/2., GetBaseHeight());
		vector2 top_right		= (GetBaseWidth(), 0);
		vector2 bottom_right	= (GetBaseWidth(), GetBaseHeight());
		vector2 bottom_left		= (0, GetBaseHeight());
		
		if(flags & SS_SCREEN_CENTER       ) return center		+pos;
		if(flags & SS_SCREEN_TOP_CENTER   ) return top_center	+pos;
		if(flags & SS_SCREEN_BOTTOM_CENTER) return bottom_center+pos;
		if(flags & SS_SCREEN_BOTTOM_LEFT  ) return bottom_left  +pos;
		if(flags & SS_SCREEN_TOP_RIGHT    ) return top_right	+pos;
		if(flags & SS_SCREEN_BOTTOM_RIGHT ) return bottom_right +pos;
		return pos;
	}
	
	static vector2 _ProcessScale(vector2 scale, uint flags)
	{
		if(!(flags & SS_NOASPECTCORRECTION)) 
		{
			double aspectdef = GetBaseWidth() / GetBaseHeight();
			double aspectmod = Screen.GetAspectRatio() / aspectdef;
			scale.x /= aspectmod;
		}
		return scale;
	}

	static vector2 _ProcessTextureCoords(vector2 pos, vector2 texoffs, uint flags, TextureID texture, vector2 scale=(1,1))
	{
		vector2 texsize;
		[texsize.x, texsize.y] = TexMan.GetSize(texture);
		
		// Ugh, why can't i just multiply 2 vec2's together?
		texsize.x *= scale.x;
		texsize.y *= scale.y;
		
		if(flags & SS_COORDS_TEXGRID)
		{
			pos.x = pos.x*texsize.x;
			pos.y = pos.y*texsize.y;
		}
		
		texoffs.x -= 1.0;
		texoffs.y -= 1.0;
		pos.x -= (texsize.x*texoffs.x)/2.;
		pos.y -= (texsize.y*texoffs.y*GetStatusBarHeightRatio())/2.;
		
		return _ProcessCoords(pos, flags);
	}
	
	static void DrawTexture(TextureID texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 scale = (1, 1), double rotation = 0, Color tint=Color(0,0,0,0), vector2 texoffs = (1,1), vector2 rotoffs = (1,1), bool absolute=false)
	{
		vector2 texsize;
		[texsize.x, texsize.y] = TexMan.GetSize(texture);
		rotoffs.x *= texsize.x / 2.;
		rotoffs.y *= texsize.y / 2.;
		scale = _ProcessScale(scale, flags);

		if(!absolute)
		{
			vector2 npos = _ProcessTextureCoords(pos, texoffs, flags, texture, scale);
			Screen.DrawTexture(texture, false, npos.x, npos.y,
				DTA_VirtualWidthF, GetBaseWidth(),
				DTA_VirtualHeightF, GetBaseHeight(),
				DTA_KeepRatio, true,
				DTA_Alpha, alpha,
				DTA_DestWidth, int(texsize.x*abs(scale.x)),
				DTA_DestHeight, int(texsize.y*abs(scale.y)),
				DTA_FlipX, !!(scale.x < 0),
				DTA_ColorOverlay, tint,
				DTA_Rotate, rotation,
				DTA_CenterOffsetRel, true,
				DTA_TopOffset, int(rotoffs.y),
				DTA_LeftOffset, int(rotoffs.x)
			);
		}
		else
		{
			vector2 resolution = (Screen.GetWidth(), Screen.GetHeight());
			vector2 scaleratio = (resolution.x/GetBaseWidth(), resolution.y/GetBaseHeight());
			vector2 nscale = (scale.x*scaleratio.x, scale.y*scaleratio.y);
			pos.y *= GetStatusBarHeightRatio();
			vector2 npos = _ProcessTextureCoords(pos, texoffs, flags, texture, nscale);
			
			Screen.DrawTexture(texture, false, npos.x, npos.y,
				DTA_KeepRatio, true,
				DTA_Alpha, alpha,
				DTA_DestWidth, int(texsize.x*abs(scale.x)*scaleratio.x),
				DTA_DestHeight, int(texsize.y*abs(scale.y)*scaleratio.y),
				DTA_FlipX, !!(scale.x < 0),
				DTA_ColorOverlay, tint,
				DTA_Rotate, rotation,
				DTA_CenterOffsetRel, true,
				DTA_TopOffset, int(rotoffs.y),
				DTA_LeftOffset, int(rotoffs.x)
			);
		}
	}

	static void DrawImage(String graphic, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 scale = (1, 1), double rotation = 0, Color tint=Color(0,0,0,0), vector2 texoffs = (1,1), vector2 rotoffs = (1,1), bool absolute=false)
	{
		TextureID texture = TexMan.CheckForTexture(graphic, TexMan.Type_Any);
		DrawTexture(texture, pos, flags, alpha, scale, rotation, tint, texoffs, rotoffs, absolute);
	}
	
	static void DrawMugshot( int accuracy, vector2 pos, int drawflags = 0, int mugshotflags = 0, 
							 double alpha = 1.0, vector2 scale=(5.0,5.0), double rotation = 0, string default_face="STF",
							 Color tint=Color(0,0,0,0), bool absolute=false)
	{
		TextureID mugtex = statusbar.GetMugshot(accuracy, mugshotflags, default_face);
		DrawTexture(mugtex, pos, drawflags, alpha, scale, rotation, tint, (1,1), (1,1), absolute);
	}
	
	static vector2 GetImageSize(String graphic)
	{
		vector2 texsize;
		TextureID texture = TexMan.CheckForTexture(graphic, TexMan.Type_Any);
		
		[texsize.x, texsize.y] = TexMan.GetSize(texture);
		return texsize;
	}
	
	static void DrawString( Font fnt, String str, Vector2 pos, int flags = 0, int translation = Font.CR_UNTRANSLATED, 
							double Alpha = 1., Vector2 scale = (1, 1), Color tint = Color(0,0,0,0), int charspacing = 0, int linespacing = 20 )
	{
		Array<String> lines;
		str.Split(lines, "\n");
		
		if(flags & SS_TEXT_CENTER)
		{
			pos.x -= (fnt.StringWidth(str) * scale.x);
		}
		else if(flags & SS_TEXT_RIGHT)
		{
			pos.x -= (fnt.StringWidth(str) * scale.x) * 2.0;
		}
		
		vector2 npos = _ProcessCoords(pos, flags);
		scale = _ProcessScale(scale, flags);
		npos.x *= (1./scale.x*0.5);
		npos.y *= (1./scale.y*0.5);
		
		for(int i = 0; i < lines.Size(); i++)
		{
			 double lineoffs = (linespacing*i);
			 Screen.DrawText(fnt, translation, npos.x, npos.y+lineoffs, 
				lines[i],
				DTA_VirtualWidthF,  int(GetBaseWidth()*(1./scale.x*0.5)),
				DTA_VirtualHeightF, int(GetBaseHeight()*(1./scale.y*0.5)),
				DTA_KeepRatio, true,
				DTA_Alpha, alpha,
				DTA_ColorOverlay, tint,
				DTA_Spacing, charspacing
			);
		}		
	}
	
	static void Fill(Color col, double x, double y, double w, double h, double alpha = 1.0, int flags = 0, bool absolute = false)
	{
		vector2 pos = (x, y);
		double sc_xres = Screen.getWidth()/GetBaseWidth();
		double sc_yres = Screen.getHeight()/GetBaseHeight();		
		vector2 npos = absolute ? pos : _ProcessCoords(pos, flags);
		if(!absolute)
		{
			npos.x *= sc_xres;
			npos.y *= sc_yres;
		}
		w *= sc_xres;
		h *= sc_yres;
		
		Screen.Dim(col, alpha, npos.x, npos.y, w, h);
	}
	
	static void DrawBar(String ongfx, String offgfx, double curval, double maxval, Vector2 position, int border, int vertical,
						double Alpha = 1., Vector2 scale = (1, 1), Color tint=Color(0,0,0,0) )
	{
		let ontex = TexMan.CheckForTexture(ongfx, TexMan.TYPE_MiscPatch);
		if (!ontex.IsValid()) return;
		let offtex = TexMan.CheckForTexture(offgfx, TexMan.TYPE_MiscPatch);
		
		double value = (maxval != 0) ? clamp(curval / maxval, 0, 1) : 0;
		if(border != 0) value = 1. - value; //invert since the new drawing method requires drawing the bg on the fg.
		
		// {cx, cb, cr, cy}
		double Clip[4];
		Clip[0] = Clip[1] = Clip[2] = Clip[3] = 0;
		
		vector2 on_texsize;
		vector2 off_texsize;
		[on_texsize.x, on_texsize.y] = TexMan.GetSize(ontex);
		[off_texsize.x, off_texsize.y] = TexMan.GetSize(offtex);
		on_texsize.x *= scale.x;
		on_texsize.y *= scale.y;
		off_texsize.x *= scale.x;
		off_texsize.y *= scale.y;
		
		bool horizontal = !(vertical & BaseStatusBar.SHADER_VERT);
		bool reverse = !!(vertical & BaseStatusBar.SHADER_REVERSE);
		double sizeOfImage = (horizontal ? on_texsize.X - border*2 : on_texsize.Y - border*2);
		Clip[(!horizontal) | ((!reverse)<<1)] = sizeOfImage - sizeOfImage *value;
		
		// preserve the active clipping rectangle
		int cx, cy, cw, ch;
		[cx, cy, cw, ch] = screen.GetClipRect();

		if(border != 0)
		{
			for(int i = 0; i < 4; i++) Clip[i] += border;

			//Draw the whole foreground
			DrawTexture(ontex, position, 0, alpha, scale, 0, tint, (0,0) );
			SetClipRect(position.X + Clip[0], position.Y + Clip[1], on_texsize.X - Clip[0] - Clip[2], on_texsize.Y - Clip[1] - Clip[3]);
		}
		
		if (offtex.IsValid() && off_texsize == on_texsize) DrawTexture(offtex, position, 0, alpha, scale, 0, tint, (0,0) );
		else Fill(color(255,0,0,0), position.X + Clip[0], position.Y + Clip[1], on_texsize.X - Clip[0] - Clip[2], on_texsize.Y - Clip[1] - Clip[3]);
		
		if (border == 0) 
		{
			SetClipRect(position.X + Clip[0], position.Y + Clip[1], on_texsize.X - Clip[0] - Clip[2], on_texsize.Y - Clip[1] - Clip[3]);
			DrawTexture(ontex, position, 0, alpha, scale, 0, tint, (0,0) );
		}
		// restore the previous clipping rectangle
		screen.SetClipRect(cx, cy, cw, ch);
	}
	
	static void SetClipRect(int x, int y, int w, int h)
	{
		double sc_xres = Screen.getWidth()/GetBaseWidth();
		double sc_yres = Screen.getHeight()/GetBaseHeight();		
		x *= sc_xres;
		y *= sc_yres;
		w *= sc_xres;
		h *= sc_yres;
		Screen.SetClipRect(x,y,w,h);
	}
	
	// Shape2D Stuff
	static void DrawShape(TextureID texture, Shape2D surface, bool animate = false, double Alpha = 1., Color tint=Color(0,0,0,0))
	{
		Screen.DrawShape(texture, animate, surface,
			DTA_VirtualWidthF, GetBaseWidth(),
			DTA_VirtualHeightF, GetBaseHeight(),
			DTA_KeepRatio, true,
			DTA_Alpha, alpha,
			DTA_ColorOverlay, tint
		);
	}

	static void ClearClipRect() { Screen.ClearClipRect(); }
}	