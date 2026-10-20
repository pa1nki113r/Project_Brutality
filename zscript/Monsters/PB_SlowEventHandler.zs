class PB_SlowEventHandler : EventHandler
{
    Array<Actor> slowTargets;    // Stores affected actors
    Array<double> slowAmounts;   // Stores slow percentages
    Array<int> slowDurations;    // Stores remaining tics
    Array<double> originalSpeeds; // Stores original speeds
    Array<int> hitCounts;        // Tracks how many times the target has been hit



    override void WorldThingDamaged(WorldEvent e)
    {
        if (!e.Thing || !e.Inflictor)
            return;

        if (!(e.Inflictor is "ArachnoArtyPlasmaBall"))
            return;

        Actor target = e.Thing;
        if (!target || !target.bShootable || target.health <= 0)
            return;

        double slowAmount = 0.15;  //  slow per hit
        double maxSlow = 0.6;     // Maximum slow
        int baseDuration = 52;    // Initial duration
        int halfDuration = 26;    // Half duration for third hit
        int minExtraDuration = 20; // Additional duration after third hit
		int maxDuration = 350;    // Maximum duration cap

        for (int i = 0; i < slowTargets.Size(); i++)
        {
            if (slowTargets[i] == target)
            {

                slowAmounts[i] = min(slowAmounts[i] + slowAmount, maxSlow);
                hitCounts[i]++;

                if (hitCounts[i] == 1)
                    slowDurations[i] = min(baseDuration * 2, maxDuration);  
                else if (hitCounts[i] == 2)
                    slowDurations[i] = min(baseDuration * 2 + halfDuration, maxDuration);
                else
					
                    slowDurations[i] = min( baseDuration * 2 + halfDuration + ((hitCounts[i] - 2) * minExtraDuration),maxDuration); // Fourth+ hits

                target.Speed = originalSpeeds[i] * (1 - slowAmounts[i]);

        //        Console.Printf("\cvStacking slow on %s: %.0f%% for %d tics (Hit %d)", target.GetClassName(), slowAmounts[i] * 100, slowDurations[i], hitCounts[i] + 1);

                return;
            }
        }

        slowTargets.Push(target);
        slowAmounts.Push(slowAmount);
        slowDurations.Push(min(baseDuration, maxDuration));
        originalSpeeds.Push(target.Speed);
        hitCounts.Push(0); // First hit

        target.Speed *= (1 - slowAmount);


     //   Console.Printf("\ciSlowed %s by %.0f%% for %d tics! (First hit)", target.GetClassName(), slowAmount * 100, baseDuration);
    }

    override void WorldTick()
    {
        for (int i = slowTargets.Size() - 1; i >= 0; i--)
        {
            if (!slowTargets[i] || slowTargets[i].health <= 0)
            {
                RestoreSpeed(i);
                continue;
            }

            slowDurations[i]--;
            if (slowDurations[i] <= 0)
                RestoreSpeed(i);
        }
    }

    void RestoreSpeed(int index)
    {
        if (slowTargets[index])
        {
            slowTargets[index].Speed = originalSpeeds[index]; // Restore original speed
        }
        slowTargets.Delete(index);
        slowAmounts.Delete(index);
        slowDurations.Delete(index);
        originalSpeeds.Delete(index);
        hitCounts.Delete(index);
    }
}
