# Project Brutality co-op simulation harness

This harness starts isolated UZDoom processes with separate configs, saves,
screenshots, and logs. The test addon records synchronized world checkpoints and
counts every network event. It compares the full checkpoint stream from every
peer and fails on any difference.

The scenarios add deterministic play-scope stress after the clients join:

- `Idle` checks an untouched co-op level.
- `Movement` moves every pawn in opposing directions.
- `Combat` adds movement, repeated PB monster damage/death, Gearbox give/take
  netevents, and PB projectile whiz probes.
- `DashCombat` adds short high-velocity bursts to the combat workload.
- `GoreImpact` separates peer cameras across the impact-detail threshold, then
  creates repeated blood and impact bursts while fingerprinting `random[impacts]`.

The whiz probe fingerprints both the count and player identities stored on each
projectile, so the historical `players[consoleplayer]` desync is observable.

Build the cached PK3 after changing gameplay source:

```powershell
.\tools\mp\Build-CoopTestPackage.ps1
```

Run a two-player dash/combat simulation:

```powershell
.\tools\mp\Run-CoopSimulation.ps1 -Clients 2 -Scenario DashCombat -DurationSeconds 30 -Map MAP01
```

Run a three-player idle baseline:

```powershell
.\tools\mp\Run-CoopSimulation.ps1 -Clients 3 -Scenario Idle -DurationSeconds 20 -Map MAP02
```

Run the adversarial local-gore test with different visual settings per peer:

```powershell
.\tools\mp\Run-CoopSimulation.ps1 -Clients 3 -Scenario GoreImpact -AsymmetricLocalGore -DurationSeconds 30 -Map MAP01
```

Each run is written below `tools/mp/runs/`. A run is failed when an engine exits
early, no `PBMPCHK` checkpoints are captured, a known synchronization/script
error appears, or any peer's deterministic fingerprints differ.
