#include "zscript/Effects/BulletImpacts.zs"

// [gng] partially based on beautiful doom's smoke
// https://github.com/jekyllgrim/Beautiful-Doom/blob/96fcd0cec039eca762a8b206e522e8111a62ad95/Z_BDoom/bd_main.zc#L932
class PB_GunFireSmoke: PB_LightActor
{
    Default {
        Alpha 0.3;
        //Scale 0.2;
       	//Renderstyle "Add";
        Speed 1;
        BounceFactor 0;
        Radius 0;
        Height 0;
        Mass 0;
        YScale 0.22;
        XScale 0.264;
        +NOBLOCKMAP;
        +NOTELEPORT;
        +DONTSPLASH;
        +MISSILE;
        +FORCEXYBILLBOARD;
        //+CLIENTSIDEONLY;
        +NOINTERACTION;
        +NOGRAVITY;
        +THRUACTORS;
        +ROLLSPRITE;
        +ROLLCENTER;
        +NOCLIP;
        +NOTIMEFREEZE;
    }

    double dissipateRotation;
    vector3 posOfs;
    int m_sprite;

    double blowSpeed, fadeSpeed;

    override void BeginPlay()
    {
        ChangeStatNum(STAT_PB_SMOKE);
        Super.BeginPlay();

        blowSpeed = 1.02;
        fadeSpeed = 1.0;
    }

    override void PostBeginPlay()
    {
        dissipateRotation = frandom(0.7, 1.4) * randompick(-1, 1);
        bXFLIP = randompick(0, 1);
        bYFLIP = randompick(0, 1);
        m_sprite = random(0, 25);
    }
    
    virtual void SmokeTick()
    {    	
        int age = GetAge();
        if(age < 5 && age > 1) 
        {
            A_Fadeout(0.05 * fadeSpeed, FTF_CLAMP|FTF_REMOVE);
            scale *= blowSpeed;
            vel *= 0.85;
            roll += dissipateRotation;
            dissipateRotation *= 0.96;
            
            if(CeilingPic == SkyFlatNum) {
                vel.y += 0.02; // wind
                vel.x -= 0.01;
            }
        }
        else
        {
            scale *= 1.01;
            vel *= 0.7;
            roll += dissipateRotation;
            dissipateRotation *= 0.95;
            
            if(CeilingPic == SkyFlatNum) {
                vel.y += 0.03;
                vel.x -= 0.015;
            }
            
            vel.z += 0.04;

            if (alpha < 0.1)
                A_FadeOut(alpha * (0.02 * fadeSpeed), FTF_CLAMP|FTF_REMOVE);
            else
                A_Fadeout(alpha * (0.04 * fadeSpeed), FTF_CLAMP|FTF_REMOVE);
        }
    }

	override void Tick()
	{
		SetOrigin(Vec3Offset(vel.x, vel.y, vel.z), true);
		Super.Tick();
		SmokeTick();
	}

    States 
    {
        Spawn:
        
        Type1:
            X103 A 1 { frame = m_Sprite; }
            Loop;
    }
}

class PB_CasingEjectionSmoke : PB_GunFireSmoke
{    
    Default
    {
        Scale 1.0;
        XScale 2.5;
        YScale 1.0;

        -ROLLCENTER;
    }
    override void PostBeginPlay()
    {
        m_sprite = random(0, 24);

        if(!master) Destroy();

        A_FaceMovementDirection();
        roll = -pitch * (deltaangle(angle, master.angle) / 180);
    }

    States 
    {
        Spawn:
            X103 A 1 {
                scale *= blowspeed;
                invoker.frame = invoker.m_sprite;

                if(GetAge() < 5) 
                {
                    scale.x *= 1.02;
                    A_Fadeout(0.12, FTF_CLAMP|FTF_REMOVE);
                    vel *= 0.85;
                }
            }
            Loop;
    }
}

class PB_BarrelHeatSmoke: PB_GunFireSmoke
{   
    override void SmokeTick()
    {    	
		vel.xy *= 0.9;
        int age = GetAge();
        if(age < 5 && age > 1) 
        {
            A_Fadeout(0.05 * fadeSpeed, FTF_CLAMP|FTF_REMOVE);
            scale *= blowSpeed;
            roll += dissipateRotation;
            dissipateRotation *= 0.96;
            
            if(CeilingPic == SkyFlatNum) {
                vel.y += 0.2; // wind
                vel.z += 0.1;
                vel.x -= 0.1;
            }
        }
        else
        {
            scale *= 1.01;
            roll += dissipateRotation;
            dissipateRotation *= 0.95;
            
            if(CeilingPic == SkyFlatNum) {
                vel.y += 0.1; // wind
                vel.z += 0.05;
                vel.x -= 0.05;
            }

            if (alpha < 0.1)
                A_FadeOut(0.02 * fadeSpeed, FTF_CLAMP|FTF_REMOVE);
            else
                A_Fadeout(0.04 * fadeSpeed, FTF_CLAMP|FTF_REMOVE);
        }
    }
}