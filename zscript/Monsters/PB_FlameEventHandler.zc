class PB_FlameEventHandler : EventHandler
{
    Array<Actor> burnTargets;   // Tracks affected actors
    Array<int> burnAmounts;     // Total accumulated burn intensity per actor
    Array<int> burnDurations;   // Remaining tics before flame effect expires

    override void WorldThingDamaged(WorldEvent e)
    {
        if (!e.Thing || !e.Inflictor)
            return;

        if (!(e.Inflictor is "Mancubus_GroundFireSpawner"))
            return;

        Actor target = e.Thing;
        if (!target || !target.bShootable || target.health <= 0)
            return;

        int burnPerHit = 2;   // Small burn increase per flame hit
        int maxBurn = 35;     // Max TOTAL burn intensity an actor can ever take
        int baseDuration = 20; // Burn lasts at least this long per hit
        int maxDuration = 90; // Burn duration cap

        for (int i = 0; i < burnTargets.Size(); i++)
        {
            if (burnTargets[i] == target)
            {
                // 🔥 Prevent going past maxBurn
                if (burnAmounts[i] < maxBurn)
                    burnAmounts[i] = min(burnAmounts[i] + burnPerHit, maxBurn);
                
                // ⏳ Extend duration instead of stacking burn
                burnDurations[i] = min(burnDurations[i] + baseDuration, maxDuration);

      //          Console.Printf("\ciFlame stacking on %s: %d intensity, %d tics remaining",target.GetClassName(), burnAmounts[i], burnDurations[i]);
                return;
            }
        }

        // First-time burn
        burnTargets.Push(target);
        burnAmounts.Push(min(burnPerHit, maxBurn)); // Start burning but respect maxBurn
        burnDurations.Push(baseDuration);

   //     Console.Printf("\cgIgnited %s: %d intensity over %d tics!", target.GetClassName(), burnPerHit, baseDuration);
    }

	override void WorldTick()
	{
		for (int i = burnTargets.Size() - 1; i >= 0; i--)
		{
			if (!burnTargets[i] || burnTargets[i].health <= 0)
			{
				RemoveBurn(i);
				continue;
			}

			if (burnDurations[i] > 0 && (level.time % 9 == 0)) // Apply damage every 14 tics
			{
				int tickDamage = max(1, burnAmounts[i] / (90 / 9)); // 35 / 10 = 3.5 per tick
				burnTargets[i].DamageMobj(null, null, tickDamage, "Fire", DMG_NO_PAIN);
				
				if (burnTargets[i] && tickDamage > 1 && burnTargets[i].GetClassName() == "PB_PlayerPawn")
					burnTargets[i].A_SetBlend("245 245 0", 0.3, 24);

		//		Console.Printf("\cfBurning %s for %d damage! (%d tics left)", burnTargets[i].GetClassName(), tickDamage, burnDurations[i]);
			}

			burnDurations[i]--;
			if (burnDurations[i] <= 0)
				RemoveBurn(i);
		}
	}


    void RemoveBurn(int index)
    {
        if (burnTargets[index])
        {
          //  Console.Printf("\cj%s is no longer burning!", burnTargets[index].GetClassName());
        }
        burnTargets.Delete(index);
        burnAmounts.Delete(index);
        burnDurations.Delete(index);
    }
}
