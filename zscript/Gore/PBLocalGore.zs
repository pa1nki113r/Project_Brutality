// Client-local blood visuals. These thinkers never enter the playsim actor
// list, cannot collide or deal damage, and exclusively use client RNG.

const PB_LG_CLOUD = 0;
const PB_LG_CLOUD2 = 1;
const PB_LG_CLOUD3 = 2;
const PB_LG_CLOUD4 = 3;
const PB_LG_EXPLOSION = 4;
const PB_LG_SQUIB = 5;

class PB_LocalBloodVisual : VisualThinker
{
	int effectType;
	int age;
	int frame;
	int frameTics;
	int frameDuration;
	int maxFrame;
	String spriteName;
	double gravity;
	double scaleGrowth;
	double alphaDecay;
	bool sideSquib;

	static PB_LocalBloodVisual SpawnBloodVisual(
		int type,
		Vector3 spawnPos,
		Vector3 spawnVel,
		TranslationID translation = 0,
		Color shade = 0xFFFF0000,
		double alphaScale = 1.0,
		double sizeScale = 1.0,
		bool side = false,
		bool flip = false)
	{
		if (!level) return null;

		PB_LocalBloodVisual visual = PB_LocalBloodVisual(level.SpawnVisualThinker("PB_LocalBloodVisual"));
		if (!visual) return null;

		visual.effectType = type;
		visual.Pos = spawnPos;
		visual.Prev = spawnPos;
		visual.Vel = spawnVel;
		visual.Translation = translation;
		visual.scolor = shade;
		visual.sideSquib = side;
		if (flip) visual.VisualThinkerFlags |= 4;
		visual.Flags |= SPF_ROLL;
		visual.Configure(alphaScale, sizeScale);
		visual.UpdateSector();
		visual.UpdateSpriteInfo();
		return visual;
	}

	void Configure(double alphaScale, double sizeScale)
	{
		switch (effectType)
		{
		default:
		case PB_LG_CLOUD:
			spriteName = "XS11";
			maxFrame = 31;
			Scale = (0.16, 0.16) * sizeScale * cfrandom(0.83, 1.0);
			Alpha = 0.70 * alphaScale * cfrandom(0.7, 1.0);
			Roll = cfrandom(-20, 20);
			Offset = (cfrandom(-10, 10), cfrandom(-2, 2));
			gravity = 0.02;
			scaleGrowth = 1.01;
			SetRenderStyle(STYLE_Stencil);
			break;

		case PB_LG_CLOUD2:
			spriteName = "XS16";
			maxFrame = 14;
			Scale = (0.05, 0.05) * sizeScale * cfrandom(1.2, 1.5);
			Alpha = 0.67 * alphaScale;
			Roll = cfrandom(-125, 125);
			gravity = 0.016;
			scaleGrowth = 1.02;
			SetRenderStyle(STYLE_Stencil);
			break;

		case PB_LG_CLOUD3:
			spriteName = "XS19";
			maxFrame = 15;
			Scale = (0.064, 0.064) * sizeScale;
			Alpha = 0.67 * alphaScale;
			Roll = cfrandom(-125, 125);
			gravity = 0.016;
			scaleGrowth = 1.02;
			SetRenderStyle(STYLE_Stencil);
			break;

		case PB_LG_CLOUD4:
			spriteName = "XS15";
			maxFrame = 6;
			Scale = (0.012, 0.015) * sizeScale;
			Alpha = 0.67 * alphaScale;
			Roll = cfrandom(-125, 125);
			gravity = 0.016;
			scaleGrowth = 1.02;
			SetRenderStyle(STYLE_Stencil);
			break;

		case PB_LG_EXPLOSION:
			spriteName = "XS19";
			maxFrame = 15;
			Scale = (0.10, 0.10) * sizeScale;
			Alpha = 2.0 * alphaScale;
			Roll = cfrandom(-125, 125);
			gravity = 0.016;
			scaleGrowth = 1.02;
			SetRenderStyle(STYLE_Stencil);
			break;

		case PB_LG_SQUIB:
			spriteName = String.Format("NGB%d", sideSquib ? crandompick(3, 4) : crandompick(1, 2));
			maxFrame = 12;
			Scale = (0.4, 0.4) * sizeScale;
			Alpha = alphaScale;
			Roll = (90 + cfrandom(-60, 30)) * ((VisualThinkerFlags & 4) ? -1 : 1);
			gravity = 0.2;
			SetRenderStyle(STYLE_Normal);
			break;
		}

		frameDuration = 1;
		SetVisualFrame();
	}

	override void Tick()
	{
		if (IsFrozen()) return;

		age++;
		frameTics++;

		if (effectType == PB_LG_CLOUD && age < 4)
		{
			Scale.X *= 1.397;
			Scale.Y *= 1.287;
			Alpha = max(0.0, Alpha - 0.105);
		}
		else if (effectType >= PB_LG_CLOUD2 && effectType <= PB_LG_EXPLOSION && age < 3)
		{
			Scale *= 1.8;
		}
		else if (effectType == PB_LG_SQUIB && age < 4)
		{
			Scale += (0.1, 0.1);
		}
		else
		{
			Scale *= scaleGrowth;
			Vel.Z -= gravity;
			Alpha = max(0.0, Alpha - alphaDecay);
		}

		if (frameTics >= GetFrameDuration())
		{
			frameTics = 0;
			frame++;
			if (frame > maxFrame)
			{
				Destroy();
				return;
			}
			SetVisualFrame();
		}

		Super.Tick();
	}

	int GetFrameDuration()
	{
		if (effectType == PB_LG_CLOUD2 || effectType == PB_LG_CLOUD3 || effectType == PB_LG_EXPLOSION)
			return frame < 6 ? 1 : 2;
		return frameDuration;
	}

	void SetVisualFrame()
	{
		if (effectType == PB_LG_CLOUD && frame > 25)
			Texture = TexMan.CheckForTexture(String.Format("XS21%c0", 97 + frame - 26));
		else
			Texture = TexMan.CheckForTexture(String.Format("%s%c0", spriteName, 97 + frame));
		UpdateSpriteInfo();
	}
}
