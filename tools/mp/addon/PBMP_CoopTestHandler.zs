class PBMP_WhizBullet : PB_Projectile
{
	Default
	{
		Speed 32;
		Gravity 0;
		-Ripper;
		+NoGravity;
		+NoClip;
		+NoBlockmap;
	}
}

class PBMP_CoopTestHandler : EventHandler
{
	int networkEventCount;
	int netgameTrueCount;
	int gearboxEventCount;
	ui int probeStage;

	override void WorldLoaded(WorldEvent e)
	{
		Console.Printf("PBMPSTART map=%s netgame=%d multiplayer=%d", level.MapName, netgame, multiplayer);
	}

	override void UiTick()
	{
		if (gamestate != GS_LEVEL || !netgame)
		{
			return;
		}

		// Every peer contributes Gearbox events for its own player. These exercise
		// the production inventory-event path and leave a fingerprintable token.
		if (level.maptime >= 105 && probeStage == 0)
		{
			SendNetworkEvent("gb_give_item:PlayerWheelOpen");
			probeStage = 1;
		}
		else if (level.maptime >= 210 && probeStage == 1)
		{
			SendNetworkEvent("gb_take_item:PlayerWheelOpen");
			probeStage = 2;
		}
		else if (level.maptime >= 350 && probeStage == 2)
		{
			SendNetworkEvent("gb_give_item:PlayerWheelOpen");
			probeStage = 3;
		}
	}

	override void NetworkProcess(ConsoleEvent e)
	{
		networkEventCount++;
		if (e.Name ~== "netgametrue")
		{
			netgameTrueCount++;
		}
		if (e.Name.Left(3) ~== "gb_")
		{
			gearboxEventCount++;
		}
	}

	override void WorldTick()
	{
		if (gamestate != GS_LEVEL)
		{
			return;
		}

		int scenario = CVar.GetCVar("pbmp_scenario").GetInt();
		if (scenario >= 1 && level.maptime >= 70 && level.maptime < 245)
		{
			for (int playerNum = 0; playerNum < MAXPLAYERS; playerNum++)
			{
				if (!PlayerInGame[playerNum] || !players[playerNum].mo) continue;
				Actor pawn = players[playerNum].mo;
				double direction = playerNum % 2 == 0 ? 1.0 : -1.0;
				pawn.vel.x = 3.0 * direction;
				pawn.vel.y = 1.5 * direction;
				if (scenario >= 3 && level.maptime >= 140 && level.maptime < 150)
				{
					pawn.vel.x = 24.0 * direction;
					pawn.vel.y = 12.0 * direction;
				}
			}
		}

		// Repeatedly damage live monsters to exercise PB pain, death, gore, drop,
		// and event-handler paths under synchronized co-op load.
		if (scenario >= 2 && (level.maptime == 105 || level.maptime == 175 || level.maptime == 350))
		{
			Actor source;
			for (int playerNum = 0; playerNum < MAXPLAYERS; playerNum++)
			{
				if (PlayerInGame[playerNum] && players[playerNum].mo)
				{
					source = players[playerNum].mo;
					break;
				}
			}

			ThinkerIterator damageIt = ThinkerIterator.Create("Actor");
			Actor victim;
			while (victim = Actor(damageIt.Next()))
			{
				if (!victim.bIsMonster || victim.health <= 0) continue;
				victim.DamageMobj(source, source, 45, "Bullet");
				break;
			}

			for (int nearPlayer = 0; nearPlayer < MAXPLAYERS; nearPlayer++)
			{
				if (!PlayerInGame[nearPlayer] || !players[nearPlayer].mo) continue;
				Actor shooter;
				for (int shooterNum = 0; shooterNum < MAXPLAYERS; shooterNum++)
				{
					if (shooterNum != nearPlayer && PlayerInGame[shooterNum] && players[shooterNum].mo)
					{
						shooter = players[shooterNum].mo;
						break;
					}
				}
				if (!shooter) continue;

				Actor nearPawn = players[nearPlayer].mo;
				vector3 spawnPos = (nearPawn.pos.x - 16.0, nearPawn.pos.y, players[nearPlayer].ViewZ);
				PBMP_WhizBullet bullet = PBMP_WhizBullet(Actor.Spawn("PBMP_WhizBullet", spawnPos, NO_REPLACE));
				if (bullet)
				{
					bullet.target = shooter;
					bullet.vel = (32.0, 0.0, 0.0);
					bullet.angle = 0;
					// Advance one controlled segment immediately so the inherited PB
					// whiz routine is exercised before map geometry removes the probe.
					bullet.SetOrigin(spawnPos + (32.0, 0.0, 0.0), false);
					bullet.PB_HandleWhizby();
				}
			}
		}

		if (scenario >= 2 && (level.maptime == 106 || level.maptime == 176 || level.maptime == 351))
		{
			int diagnosticBullets;
			int diagnosticMarks;
			int diagnosticMask;
			ThinkerIterator diagnosticIt = ThinkerIterator.Create("PBMP_WhizBullet");
			PBMP_WhizBullet diagnosticBullet;
			while (diagnosticBullet = PBMP_WhizBullet(diagnosticIt.Next()))
			{
				diagnosticBullets++;
				diagnosticMarks += diagnosticBullet.alreadyWhizzedBy.Size();
				for (int mark = 0; mark < diagnosticBullet.alreadyWhizzedBy.Size(); mark++)
				{
					diagnosticMask |= 1 << diagnosticBullet.alreadyWhizzedBy[mark].PlayerNumber();
				}
			}
			Console.Printf("PBMPWHIZ tic=%d bullets=%d marks=%d mask=%d",
				level.maptime, diagnosticBullets, diagnosticMarks, diagnosticMask);
		}

		if (level.maptime % 35 != 0) return;

		int liveMonsters;
		int monsterHealth;
		int whizBullets;
		int whizMarks;
		int whizMask;
		ThinkerIterator it = ThinkerIterator.Create("Actor");
		Actor mo;
		while (mo = Actor(it.Next()))
		{
			if (mo.bIsMonster && mo.health > 0)
			{
				liveMonsters++;
				monsterHealth += mo.health;
			}
		}
		ThinkerIterator whizIt = ThinkerIterator.Create("PBMP_WhizBullet");
		PBMP_WhizBullet whizBullet;
		while (whizBullet = PBMP_WhizBullet(whizIt.Next()))
		{
			whizBullets++;
			whizMarks += whizBullet.alreadyWhizzedBy.Size();
			for (int mark = 0; mark < whizBullet.alreadyWhizzedBy.Size(); mark++)
			{
				whizMask |= 1 << whizBullet.alreadyWhizzedBy[mark].PlayerNumber();
			}
		}

		Console.Printf("PBMPCHK tic=%d monsters=%d monsterhp=%d whizbullets=%d whizmarks=%d whizmask=%d events=%d netgametrue=%d gearbox=%d",
			level.maptime, liveMonsters, monsterHealth, whizBullets, whizMarks, whizMask,
			networkEventCount, netgameTrueCount, gearboxEventCount);

		for (int i = 0; i < MAXPLAYERS; i++)
		{
			if (!PlayerInGame[i])
			{
				continue;
			}

			Actor pawn = players[i].mo;
			if (!pawn)
			{
				Console.Printf("PBMPPLAYER tic=%d player=%d missing=1", level.maptime, i);
				continue;
			}

			Name readyName = players[i].ReadyWeapon ? players[i].ReadyWeapon.GetClassName() : 'None';
			Name pendingName = players[i].PendingWeapon ? players[i].PendingWeapon.GetClassName() : 'None';
			String wheelToken = "PlayerWheelOpen";
			Console.Printf("PBMPPLAYER tic=%d player=%d health=%d x=%.3f y=%.3f z=%.3f vx=%.3f vy=%.3f vz=%.3f wheel=%d ready=%s pending=%s",
				level.maptime, i, pawn.health, pawn.pos.x, pawn.pos.y, pawn.pos.z,
				pawn.vel.x, pawn.vel.y, pawn.vel.z, pawn.CountInv(wheelToken),
				readyName, pendingName);
		}
	}
}
