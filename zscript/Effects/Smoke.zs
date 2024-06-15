// [gng] partially based on beautiful doom's smoke
// https://github.com/jekyllgrim/Beautiful-Doom/blob/96fcd0cec039eca762a8b206e522e8111a62ad95/Z_BDoom/bd_main.zc#L932
class PB_GunFireSmoke: Actor
{
    Default {
        Alpha 0.5;
        //Scale 0.2;
        Renderstyle "Add";
        Speed 1;
        BounceFactor 0;
        Radius 0;
        Height 0;
        Mass 0;
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
    }

    double dissipateRotation;
    vector3 posOfs;
    int m_sprite;

    override void PostBeginPlay()
    {
        dissipateRotation = frandom(0.7, 1.4) * randompick(-1, 1);
        bXFLIP = randompick(0, 1);
        bYFLIP = randompick(0, 1);
        m_sprite = random(0, 17);
    }

    States 
    {
        Spawn:
            SMOK A 1 {
                invoker.frame = invoker.m_sprite;
                if(GetAge() < 18) 
                {
                    A_Fadeout(0.015, FTF_CLAMP|FTF_REMOVE);
                    scale *= 1.02;
                    vel *= 0.85;
                    roll += dissipateRotation;
                    dissipateRotation *= 0.96;
                    
                    if(CeilingPic == SkyFlatNum) {
                        vel.y += 0.02; // wind
                        vel.z += 0.01;
                        vel.x -= 0.01;
                    }
                }
                else
                {
                    A_Fadeout(0.01 , FTF_CLAMP|FTF_REMOVE);
                    scale *= 1.01;
                    vel *= 0.7;
                    roll += dissipateRotation;
                    dissipateRotation *= 0.95;
                    
                    if(CeilingPic == SkyFlatNum) {
                        vel.y += 0.03; // wind
                        vel.z += 0.015;
                        vel.x -= 0.015;
                    }

                    if (alpha < 0.1)
                        A_FadeOut(0.005, FTF_CLAMP|FTF_REMOVE);
                }
            }
            Loop;
    }
}
