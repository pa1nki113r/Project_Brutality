// This file is part of Anti Switch Decals by generic name guy - MIT License

class AntiSwitchDecals_Handler : EventHandler {
    override void WorldLoaded(WorldEvent e)
    {
        foreach(l : Level.lines)
        {
            if(
                l.activation & SPAC_Use ||
                l.activation & SPAC_Impact ||
                l.activation & SPAC_PlayerActivate
            )
            {
                for(int i = 0; i < 2; i++)
                {
                    if(!l.sidedef[i]) continue;

                    l.sidedef[i].Flags |= Side.WALLF_NOAUTODECALS;
                    if(i == Line.back && l.Flags & Line.ML_FIRSTSIDEONLY) break;
                }
            }
        }
    }
}