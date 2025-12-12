class PB_MuzzleSpark : PB_LightActor
{
    Default {
        Scale 0.1;
        Gravity 0.3;
        Renderstyle "AddShaded";
        +NOTELEPORT;
        +NOBLOCKMAP;
        +BLOODLESSIMPACT;
        +FORCEXYBILLBOARD;
        +NOTIMEFREEZE;
        FloatBobPhase 0;
        -RANDOMIZE;
    }

    override void PostBeginPlay()
    {
        scale *= frandom[muzzlesparks](0.8, 1.0);
        Super.PostBeginPlay(); // does this matter? i believe PostBeginPlay is empty by default
    }

    States
    {
        Spawn:
            SPKO SSS 1 BRIGHT NoDelay {
                A_FadeOut(0.1);
                A_FaceMovementDirection();

                vel.z -= gravity;
            }
            Stop;
    }
}