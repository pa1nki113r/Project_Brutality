version "5.0"

const MAXITERATIONS = 32676;

//PB_CORE
#include "zscript/PBCore.zs"
#include "zscript/MathNMixins.zs"
#include "zscript/PBHandler.zs"
#include "thirdparty/zscript/ZJSON/Include.zs"
#include "zscript/FastMaterialCheck.zs"
#include "zscript/UI/HUD/PB_Hud.zs"
#include "zscript/UI/HUD/PB_Hud_FX.zs"
#include "zscript/UI/HUD/PB_HudMessages.zs"
#include "zscript/UI/PB_StatScreen.zs"
#include "thirdparty/zscript/ZMove/PlayerPawn.zs"
#include "zscript/Player/ZSPlayer.zs"
#include "zscript/PlayerStats/GlobalStats.zs"
#include "zscript/FestiveHats/HatExtravaganza.zs"
#include "thirdparty/zscript/flashlightplusplus/PB_Flashlight.zs"
#include "zscript/MenuStuff.zs"

#include "zscript/Weapons/executionGUI/pb_viewport.zs" 
#include "zscript/Weapons/executionGUI/pb_projector.zs"
#include "zscript/Weapons/executionGUI/pb_uihack.zs" 
#include "zscript/Weapons/executionGUI/pb_execution_handler.zs" 
#include "thirdparty/zscript/ZMove/ZMoveMenu.zs"

////////////////////////////////////////////////////////
//	Gearbox includes
///////////////////////////////////////////////////////
#include "thirdparty/zscript/gearbox/weapon_data.zs"
#include "thirdparty/zscript/gearbox/weapon_data_loader.zs"
#include "thirdparty/zscript/gearbox/printer.zs"

#include "thirdparty/zscript/gearbox/MD5/MD5.zs"
#include "thirdparty/zscript/gearbox/custom_weapon_order_storage.zs"

#include "thirdparty/zscript/gearbox/activity.zs"
#include "thirdparty/zscript/gearbox/input.zs"
#include "thirdparty/zscript/gearbox/input_processor.zs"
#include "thirdparty/zscript/gearbox/event_processor.zs"
#include "thirdparty/zscript/gearbox/sounds.zs"

#include "thirdparty/zscript/gearbox/weapon_menu.zs"
#include "thirdparty/zscript/gearbox/inventory_menu.zs"

//pb things
#include "thirdparty/zscript/gearbox/specials_menu.zs"
#include "thirdparty/zscript/gearbox/EquipmentMenu.zs"
#include "thirdparty/zscript/gearbox/pb/tokens.zs"	//this is were specials and equipments are defined to be used by the handler

#include "thirdparty/zscript/gearbox/inventory_user.zs"

#include "thirdparty/zscript/gearbox/sender.zs"

#include "thirdparty/zscript/gearbox/netevent_processor.zs"
#include "thirdparty/zscript/gearbox/changer.zs"

#include "thirdparty/zscript/gearbox/view_model.zs"

// Displaying data on screen.
#include "thirdparty/zscript/gearbox/display/dim.zs"
#include "thirdparty/zscript/gearbox/display/blur.zs"
#include "thirdparty/zscript/gearbox/display/blocky_view.zs"
#include "thirdparty/zscript/gearbox/display/text_view.zs"
#include "thirdparty/zscript/gearbox/display/fade_in_out.zs"
#include "thirdparty/zscript/gearbox/display/caption.zs"

#include "thirdparty/zscript/gearbox/options.zs"
#include "thirdparty/zscript/gearbox/font_selector.zs"

// Weapon Wheel implementation.
#include "thirdparty/zscript/gearbox/wheel/view.zs"
#include "thirdparty/zscript/gearbox/wheel/controller.zs"
#include "thirdparty/zscript/gearbox/wheel/controller_model.zs"
#include "thirdparty/zscript/gearbox/wheel/inner_indexer.zs"
#include "thirdparty/zscript/gearbox/wheel/indexer.zs"
#include "thirdparty/zscript/gearbox/wheel/multiwheel.zs"
#include "thirdparty/zscript/gearbox/wheel/multiwheel_mode.zs"
#include "thirdparty/zscript/gearbox/wheel/text.zs"
#include "thirdparty/zscript/gearbox/wheel/screen.zs"

// Utility tools.
#include "thirdparty/zscript/gearbox/tools/cvar.zs"
#include "thirdparty/zscript/gearbox/tools/log.zs"
#include "thirdparty/zscript/gearbox/tools/texture_cache.zs"
#include "thirdparty/zscript/gearbox/tools/ammo.zs"

// Helper classes gearbox/that wrap access to game information provided by the engine.
#include "thirdparty/zscript/gearbox/engine/level.zs"
#include "thirdparty/zscript/gearbox/engine/weapon_watcher.zs"
#include "thirdparty/zscript/gearbox/engine/player.zs"

#include "thirdparty/zscript/gearbox/freezer.zs"

#include "thirdparty/zscript/gearbox/event_handler.zs"

#include "thirdparty/zscript/gearbox/service/service.zs"
#include "thirdparty/zscript/gearbox/service/icon_service.zs"
#include "thirdparty/zscript/gearbox/service/hide_service.zs"

// Libraries
#include "thirdparty/zscript/gearbox/m_gizmos/previous_weapon.zs"
#include "thirdparty/zscript/gearbox/zabor/event_handler.zs"
//
//	end of gearbox includes
//

//Spices and Seasoning
#include "thirdparty/zscript/TiltPlus/TiltPlusPlus.zs"
#include "thirdparty/zscript/TiltPlus/TiltPlusPlusMenu.zs"
#include "zscript/Footsteps.zs"
#include "zscript/DeathFader.zs"
#include "thirdparty/zscript/ASD/AntiSwitchDecals.zs"
#include "thirdparty/zscript/NashGore/NashGoreCommon.zs"
#include "thirdparty/zscript/NashGore/NashGoreStatics.zs"
#include "thirdparty/zscript/NashGore/NashGoreHandler.zs"
#include "thirdparty/zscript/NashGore/NashGoreBlood.zs"
#include "thirdparty/zscript/NashGore/NashGoreBloodPlane.zs"
#include "thirdparty/zscript/NashGore/NashGoreGibs.zs"
#include "thirdparty/zscript/NashGore/NashGoreCrushedGibs.zs"
#include "thirdparty/zscript/NashGore/NashGoreSquishyGibs.zs"
#include "thirdparty/zscript/NashGore/NashGoreIceChunk.zs"
#include "thirdparty/zscript/NashGore/NashGoreLiquidBlood.zs"
#include "thirdparty/zscript/NashGore/NashGoreWallBlood.zs"
#include "thirdparty/zscript/NashGore/NashGoreActor.zs"
#include "thirdparty/zscript/NashGore/NashGoreMenu.zs"
#include "zscript/Gore/PBBlood.zs"
#include "zscript/Gore/PBBloodImpacts.zs"
#include "zscript/Gore/PBGore.zs"
#include "zscript/Gore/PBGoreEffects.zs"

#include "zscript/TestDummy.zs"

//PB_ITEM_CORE
#include "zscript/Items/PowerupsBase.zs"
#include "zscript/Items/AmmoBase.zs"
#include "zscript/Items/HPAPBase.zs"

//PB Items
#include "zscript/Items/PowerUps/Powerups.zs"
#include "zscript/Items/Ammo/AmmoBullet.zs"
#include "zscript/Items/Ammo/AmmoShell.zs"
#include "zscript/Items/Ammo/AmmoExplosive.zs"
#include "zscript/Items/Ammo/AmmoCell.zs"
#include "zscript/Items/Ammo/AmmoFuel.zs"
#include "zscript/Items/Ammo/AmmoDemon.zs"
#include "zscript/Items/Ammo/AmmoPacks.zs"
#include "zscript/Items/HealthArmor/HP.zs"
#include "zscript/Items/HealthArmor/AP.zs"

//PB_CORE_DECORATION
#include "zscript/Decorations/Barrels.zs"
#include "zscript/Decorations/PBKeys.zs"

//Monsters
#include "zscript/Decorations/PBDeadGeneric.zs"

#include "zscript/Monsters/PBMonster.zs"
#include "zscript/Monsters/PB_Projectile.zs"
#include "zscript/Monsters/PBMonsterArmor.zs"
#include "zscript/Monsters/PBMonsterAmmo.zs"
#include "zscript/Monsters/PBMonsterDrops.zs"
#include "zscript/Monsters/Dead.zs"

#include "zscript/Monsters/Special/BossBrain.zs"
#include "zscript/Monsters/CyberDemons/CyberDemon.zs"
#include "zscript/Monsters/Knights/BaronOfHell.zs"
#include "zscript/Monsters/Mancubi/Mancubus.zs"
#include "zscript/Monsters/Arachnotrons/Arachnotron.zs"

#include "zscript/Monsters/ZombieMen/DecoZombie.zs"
#include "zscript/Monsters/ZombieMen/ZombieMan.zs"
#include "zscript/Monsters/ZombieMen/ZombieManDeath.zs"
#include "zscript/Monsters/ZombieMen/ZombieManHelmet.zs"
#include "zscript/Monsters/ZombieMen/ZombieManPistol.zs"
#include "zscript/Monsters/ZombieMen/ZombieManHelmetPistol.zs"
#include "zscript/Monsters/ZombieMen/ZombieManCarbine.zs"
#include "zscript/Monsters/ZombieMen/ZombieManPlasma.zs"

#include "zscript/Monsters/ZombieMen/ZombieScientist.zs"
#include "zscript/Monsters/ZombieMen/ZombieScientistChainsaw.zs"

#include "zscript/Monsters/Sergeants/ZombieSergeant.zs"
#include "zscript/Monsters/Sergeants/ZombieSergeantHelmet.zs"
#include "zscript/Monsters/Sergeants/ZombieSergeantShield.zs"

#include "zscript/Monsters/Chaingunner/Commando.zs"
#include "zscript/Monsters/Chaingunner/HelmetCommando.zs"

#include "zscript/Monsters/Imps/Imp.zs"

#include "zscript/Monsters/Cacodemons/Cacodemon.zs"
#include "zscript/Monsters/Elementals/PB_Elemental.zs"

#include "zscript/Monsters/LostSouls/PB_LSoul.zs"
#include "zscript/Monsters/PB_ElectricChargeHandler.zs"
#include "zscript/Monsters/PB_SlowEventHandler.zs"
#include "zscript/Monsters/PB_FlameEventHandler.zs"

#include "zscript/Monsters/ArchViles/PB_Vile.zs"
#include "zscript/Monsters/Revenants/PB_Rev.zs"

//Effects
#include "zscript/Effects/Casings.zs"
#include "zscript/Effects/EmptyMag.zs"
#include "zscript/Effects/IceShards.zs"
#include "zscript/Effects/BulletPuffs.zs"
#include "zscript/Effects/Smoke.zs"
#include "zscript/Effects/FxBase.zs"
#include "zscript/Effects/MonsterBeam.zs"
#include "zscript/Effects/Fireworks.zs"
#include "zscript/Effects/MuzzleSparks.zs"

//Weapons
#include "zscript/Weapons/BaseWeapon.zs"
#include "zscript/Weapons/BaseWeapon_Functions.zs"
#include "zscript/Weapons/BaseWeapon_Equipment.zs"
#include "zscript/Weapons/BaseWeapon_Melee.zs"
#include "zscript/Weapons/BaseWeapon_Executions.zs"
#include "zscript/Weapons/BaseWeapon_Barrels.zs"
#include "zscript/Weapons/Taunting.zs"
#include "zscript/Weapons/FlamerStuff.zs"
#include "zscript/Weapons/Projectiles/BulletProjectile.zs"
#include "zscript/Weapons/Projectiles/BulletDef.SmallCal.zs"
#include "zscript/Weapons/Projectiles/BulletDef.Shell.zs"
#include "zscript/Weapons/Projectiles/BulletDef.HighCal.zs"
#include "thirdparty/zscript/painslayer/BulletDef.Nails.zs"
#include "zscript/Weapons/Projectiles/BulletDef.Explosives.zs"
#include "zscript/Weapons/Projectiles/BulletDef.Energy.zs"
#include "zscript/Weapons/Projectiles/BulletDef.EnemyProjectiles.zs"
#include "zscript/Weapons/Projectiles/RailGunPj.zs"
#include "zscript/Weapons/Projectiles/DragonsBreath.zs"
#include "zscript/Weapons/Projectiles/Leech.zs"
#include "zscript/Weapons/Projectiles/Shrapnel.zs"
#include "zscript/Weapons/Projectiles/BlackHole.zs"
#include "zscript/Weapons/Projectiles/SuperBFGBall.zs"
#include "zscript/Weapons/ProxMine.zs"
#include "zscript/Weapons/ThrownGrenades.zs"
#include "zscript/Weapons/Keepweapmanager.zs"

#include "zscript/Weapons/Slot9/UnmakerCharge.zs"
#include "zscript/Weapons/Slot1/Axe.zs"
#include "zscript/Weapons/Slot2/Pistol.zs"
#include "zscript/Weapons/Slot2/Revolver.zs"
#include "zscript/Weapons/Slot2/Deagle.zs"
#include "zscript/Weapons/Slot2/SMG.zs"
#include "zscript/Weapons/Slot2/MP40.zs"
#include "zscript/Weapons/Slot3/Shotgun.zs"
#include "zscript/Weapons/Slot3/SSG.zs"
#include "zscript/Weapons/Slot5/MG42.zs"
#include "zscript/Weapons/Slot5/Minigun.zs"
#include "zscript/Weapons/Slot6/SuperGL.zs"
#include "zscript/Weapons/Slot7/PlasmaM1.zs"
#include "zscript/Weapons/Slot7/DTechRifle.zs"
#include "zscript/Weapons/Slot8/CryoRifle.zs"
#include "zscript/Weapons/Slot9/BFG.zs"
#include "zscript/Weapons/Slot8/FlamethrowerUpgrade.zs"

//Spawners
#include "zscript/Spawner/PB_SpawnerBase.zs"
#include "zscript/Spawner/PB_SpawnerTypes.zs"

#include "zscript/Spawner/Weapons/PB_PistolSpawner.zs"
#include "zscript/Spawner/Weapons/PB_ChainsawSpawner.zs"
#include "zscript/Spawner/Weapons/PB_ShotgunSpawner.zs"
#include "zscript/Spawner/Weapons/PB_SSGSpawner.zs"
#include "zscript/Spawner/Weapons/PB_ChaingunSpawner.zs"
#include "zscript/Spawner/Weapons/PB_RLSpawner.zs"
#include "zscript/Spawner/Weapons/PB_PlasmaRifleSpawner.zs"
#include "zscript/Spawner/Weapons/PB_BFGSpawner.zs"

#include "zscript/Spawner/Items/PB_HPBonusSpawner.zs"
#include "zscript/Spawner/Items/PB_StimSpawner.zs"
#include "zscript/Spawner/Items/PB_MedkitSpawner.zs"
#include "zscript/Spawner/Items/PB_APBonusSpawner.zs"
#include "zscript/Spawner/Items/PB_GreenSpawner.zs"
#include "zscript/Spawner/Items/PB_BlueSpawner.zs"
#include "zscript/Spawner/Items/PB_PowerUpsSpawner.zs"

#include "zscript/Spawner/Monsters/PBZombiemanSpawner.zs"
#include "zscript/Spawner/Monsters/PBShotgunGuySpawner.zs"
#include "zscript/Spawner/Monsters/PBCommandoSpawner.zs"
#include "zscript/Spawner/Monsters/PBImpSpawner.zs"
#include "zscript/Spawner/Monsters/PBPinkySpawner.zs"
#include "zscript/Spawner/Monsters/PBSpectreSpawner.zs"
#include "zscript/Spawner/Monsters/PBCacoDemonSpawner.zs"
#include "zscript/Spawner/Monsters/PBPESpawner.zs"
#include "zscript/Spawner/Monsters/PBLostSoulSpawner.zs"
#include "zscript/Spawner/Monsters/PBRevSpawner.zs"
#include "zscript/Spawner/Monsters/PBArachSpawner.zs"
#include "zscript/Spawner/Monsters/PBHKSpawner.zs"
#include "zscript/Spawner/Monsters/PBBOHSpawner.zs"
#include "zscript/Spawner/Monsters/PBMancubusSpawner.zs"
#include "zscript/Spawner/Monsters/PBAVSpawner.zs"
#include "zscript/Spawner/Monsters/PBMastermindSpawner.zs"
#include "zscript/Spawner/Monsters/PBCyberDemonSpawner.zs"
#include "zscript/Spawner/Monsters/PBNaziSpawner.zs"
#include "zscript/Spawner/Monsters/PBStealthMonsterSpawner.zs"

#include "zscript/Spawner/Ammo/PB_PackSpawner.zs"
#include "zscript/Spawner/Ammo/PB_MagSpawner.zs"
#include "zscript/Spawner/Ammo/PB_MagBoxSpawner.zs"
#include "zscript/Spawner/Ammo/PB_CellSpawner.zs"
#include "zscript/Spawner/Ammo/PB_CellPackSpawner.zs"
#include "zscript/Spawner/Ammo/PB_ShellSpawner.zs"
#include "zscript/Spawner/Ammo/PB_ShellBoxSpawner.zs"
#include "zscript/Spawner/Ammo/PB_RocketSpawner.zs"
#include "zscript/Spawner/Ammo/PB_RocketBoxSpawner.zs"

#include "zscript/Spawner/Decorations/PBDeadCacoDemonSpawner.zs"
#include "zscript/Spawner/Decorations/PBDeadDemonSpawner.zs"
#include "zscript/Spawner/Decorations/PBDeadImpSpawner.zs"
#include "zscript/Spawner/Decorations/PBDeadShotgunGuySpawner.zs"
#include "zscript/Spawner/Decorations/PBDeadZombiemanSpawner.zs"

//PBVP
#include "zscript/PBVP/PBVP.zs"


class Demonpickup : Inventory {}
class Demonpickup2 : Demonpickup {}

// global constants
const STAT_NashGore_Gore = Thinker.STAT_USER + 1;
const STAT_PB_BULLETS = Thinker.STAT_USER_MAX - 1;

const C_TID	= 1000;	//Default camera tid
const  MAX_R	= 56+32;	//Maximum radius (or distance from the player)
const  ADJUST_R = 8;	//Amount to adjust the camera by
const  VIEW_HEIGHT = 61.0;	//The approximate hight of the player's view

// Spawner code courtesy of Marisa Kirisame.

class SpawnerBase : Actor
{
	void SpawnActor(class<Actor> spawnactor, bool HandleSpawnFlags = true)
	{
			Actor a = self;
			Actor r = a.Spawn(spawnactor,a.pos);
			r.spawnangle = a.spawnangle;
			r.angle = a.angle;
			r.pitch = a.pitch;
			r.roll = a.roll;
			r.spawnpoint = a.spawnpoint;
			r.special = a.special;
			r.args[0] = a.args[0];
			r.args[1] = a.args[1];
			r.args[2] = a.args[2];
			r.args[3] = a.args[3];
			r.args[4] = a.args[4];
			r.special1 = a.special1;
			r.special2 = a.special2;
			r.spawnflags = a.spawnflags&~MTF_SECRET;
			if (HandleSpawnFlags) r.HandleSpawnFlags();
			r.spawnflags = a.spawnflags;
			r.bCOUNTSECRET = a.spawnflags&MTF_SECRET;
			r.ChangeTid(a.tid);
			r.Vel = a.vel;
	}
}
extend class Demonpickup
{
	void SpawnActor(class<Actor> spawnactor, bool HandleSpawnFlags = true)
	{
			Actor a = self;
			Actor r = a.Spawn(spawnactor,a.pos);
			r.spawnangle = a.spawnangle;
			r.angle = a.angle;
			r.pitch = a.pitch;
			r.roll = a.roll;
			r.spawnpoint = a.spawnpoint;
			r.special = a.special;
			r.args[0] = a.args[0];
			r.args[1] = a.args[1];
			r.args[2] = a.args[2];
			r.args[3] = a.args[3];
			r.args[4] = a.args[4];
			r.special1 = a.special1;
			r.special2 = a.special2;
			r.spawnflags = a.spawnflags&~MTF_SECRET;
			if (HandleSpawnFlags) r.HandleSpawnFlags();
			r.spawnflags = a.spawnflags;
			r.bCOUNTSECRET = a.spawnflags&MTF_SECRET;
			r.ChangeTid(a.tid);
			r.Vel = a.vel;
	}
}
enum EPBWeaponFlags
{
	PBWEAP_KEEPYOFFSET = 1<<0, //Weapon must not move up/down when looking up/down.
	PBWEAP_ISPISTOLSILENCERSTATE = 1<<3, // Weapon is equipped with a silencer.
	PBWEAP_UNLOADED = 1<<4 // Weapon has been unloaded.
}
class InvisiblePuff : BulletPuff
{
	Default
	{
		-ALLOWPARTICLES
	}
}

class XDeathGibBase : Actor
{
	mixin PB_SpawnGore;
	
	void A_PBGibMissile(class<Actor> missiletype, double spawnheight = 32, double spawnofs_xy = 0, double angle = 0, int flags = 0, double pitch = 0, int ptr = AAPTR_TARGET)
	{
		let [bwaa, a] = A_SpawnGoreProjectile(missiletype, spawnheight, spawnofs_xy, angle, flags | CMF_BADPITCH | CMF_SAVEPITCH, pitch, ptr);
		if (a)
		{
			a.VelFromAngle(vel.xy.Length() / 2, self.angle + frandom(-20, 20));
			a.vel.z += vel.z + 5;
		}
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		if (target)
		{
			vel = target.vel;
			A_FaceMovementDirection();
		}
	}
}

// Optional Motion Blur by Pixel Eater
class MBlurHandler : StaticEventHandler
{
	int			pitch, yaw ;
	double		xtravel, ytravel ;
	
	override void PlayerEntered( PlayerEvent e )
	{
		PlayerInfo plr = players[ consoleplayer ];
		if( plr )
		{	
			xtravel = 0 ;
			ytravel = 0 ;
		}
	}
	
	override void WorldTick()
	{
		PlayerInfo	plr = players[ consoleplayer ];
		if( plr && plr.health > 0 && Cvar.GetCVar( "mblur", plr ).GetBool() && !plr.mo.FindInventory("PlayerWheelOpen"))
		{
			yaw		= plr.mo.GetPlayerInput( ModInput_Yaw );
			pitch	= -plr.mo.GetPlayerInput( ModInput_Pitch );
		}
	}
	
	override void NetworkProcess( ConsoleEvent e )
	{
		PlayerInfo	plr = players[ consoleplayer ];
		if( plr && plr.mo && e.Name == "liveupdate" && !plr.mo.FindInventory("PlayerWheelOpen"))
		{
			double pitchdimin	= 1. - abs( plr.mo.pitch * 1. / 90 );
			double decay		= 1. - Cvar.GetCVar( "mblur_recovery", plr ).GetFloat() * .01 ;
			double amount		= Cvar.GetCVar( "mblur_strength", plr ).GetFloat() * 10. / 32767 * sqrt( pitchdimin );
			if(plr.mo.FindInventory("PlayerWheelOpen")){
				xtravel				= 0 * decay + yaw * amount * .625 ;
				ytravel				= 0 * decay + pitch * amount ;
			}
			else
			{
				xtravel				= xtravel * decay + yaw * amount * .625 ;
				ytravel				= ytravel * decay + pitch * amount ;
			}
			
			if( Cvar.GetCVar( "mblur_autostop", plr ).GetBool() )
			{
				double threshold = Cvar.GetCVar( "mblur_threshold", plr ).GetFloat() * 30 ;
				double recovery2 = 1 - Cvar.GetCVar( "mblur_recovery2", plr ).GetFloat() * .01 ;
				if( abs( yaw )		<= threshold ) xtravel *= recovery2 ;
				if( abs( pitch )	<= threshold ) ytravel *= recovery2 ;
			}
		}
	}
	
	override void UiTick()
	{
		PlayerInfo	plr = players[ consoleplayer ];
		if( plr )
		{
			let player = players[ consoleplayer ].mo;
			
			if(  plr.health > 0 && Cvar.GetCVar( "mblur", plr ).GetBool() && !plr.mo.FindInventory("PlayerWheelOpen"))//&& yaw && pitch )
			{
				EventHandler.SendNetworkEvent( "liveupdate" );
				int copies			= 1 + Cvar.GetCVar( "mblur_samples", plr ).GetInt() ;
				double increment	= 1. / copies ;
				vector2 travel		= ( xtravel, ytravel ) / screen.getheight() ;
				
				if(player && plr)
				{
					PPShader.SetUniform2f( "MBlur", "steps", travel * increment );
					PPShader.SetUniform1f( "MBlur", "samples", copies );
					PPShader.SetUniform1f( "MBlur", "increment", increment );
					PPShader.SetUniform1f( "MBlur", "blendmode", Cvar.GetCVar( "mblur_blendmode", plr ).GetInt() );
						
					PPShader.SetEnabled( "MBlur", true );
				}
				
			}
			else
			{
				if(player && plr)
					PPShader.SetEnabled( "MBlur", false );
			}
		}
	}
}




//Code by Mike Ratzlaff, AKA Sir Robin on ZDoom forums. Use this however you want but please credit me. Thanks!



class Marker3d : actor
{
	int TimeToLive,TimeToCycle;
	default
	{
		height 7;
		radius 7;
		+RollSprite
		+NoGravity
		+NoBlockmap
		+NoInteraction
		+FORCEXYBILLBOARD
		//translation "160:167=176:191,224:231=168:175";//RED
	}
	states
	{
		spawn:
			MARK Y -1 bright;
			stop;
	}
	override void BeginPlay()
	{
		roll=45;
	}
	override void tick()
	{
		if (TimeToLive > 0)
		{
			if (TimeToLive < 15) A_SetRenderStyle(TimeToLive/15.,STYLE_Translucent);
			TimeToLive--;
			if (TimeToLive<=0) destroy();
		}
		super.tick();
	}
	static Marker3d SpawnAt(vector3 newPos, int TimeToLive, int TimeToCycle)
	{
		
		marker3d m3d = marker3d(spawn("marker3d",newPos));
		if (m3d)
		{
			m3d.TimeToLive=TimeToLive;
			m3d.TimeToCycle=TimeToCycle;
		}
		return m3d;
	}
	virtual void Orient(vector3 newPos, double yaw, double pitch, double roll)
	{
		setOrigin(newPos,false);
		self.bFlatSprite=true;
		self.angle=yaw;
		self.pitch=pitch;
		self.roll=roll+45;
	}
}

class Line3d : actor
{
	int TimeToLive,TimeToCycle;
	vector3 startVector,deltaVector;
	actor marker;
	
	string AnimMarkerClassName; property AnimMarker:AnimMarkerClassName;
	
	default
	{
		height 1;
		radius 1;
		+NoGravity
		+NoBlockmap
		+NoInteraction
		Line3d.AnimMarker "Marker3d";
	}
	states
	{
		spawn:
			PIXL M -1 bright;
			stop;
	}
	
	override void tick()
	{
		TickTTL();
		TickTTC();
		super.tick();
	}
	override void OnDestroy()
	{
		if (marker) marker.Destroy();
		super.OnDestroy();
	}
	
	virtual void TickTTL()
	{
		if (TimeToLive > 0)
		{
			if (TimeToLive < 15)
			{
				A_SetRenderStyle(TimeToLive/15.,STYLE_Translucent);
				if (marker) marker.A_SetRenderStyle(TimeToLive/15.,STYLE_Translucent);
			}
			TimeToLive--;
			if (TimeToLive == 0) Destroy();
		}
	}
	
	virtual void TickTTC()
	{
		if (TimeToCycle > 1 && marker)
		{
			marker.SetOrigin(startVector + deltaVector * (level.time % TimeToCycle) / (TimeToCycle - 1), false);
		}
	}
	
	//adjust the endpoints of this line
	void SetEndPoints(vector3 StartPos, vector3 EndPos, int TimeToLive = -1, int TimeToCycle = 0)
	{
		startVector = StartPos;
		deltaVector = EndPos - StartPos;
		SetOrigin(StartPos + deltaVector / 2, false);
		scale.y = deltaVector.length();
		scale.x = 0.25;
		pitch = -90 - VectorAngle(deltaVector.xy.length(),deltaVector.z);
		angle = VectorAngle(deltaVector.x, deltaVector.y);
		self.TimeToLive=TimeToLive;
		self.TimeToCycle=TimeToCycle;
		if (TimeToCycle > 1)
		{
			if (marker)//move the existing marker
				marker.SetOrigin(StartPos,false);
			else if (AnimMarkerClassName)//spawn a new marker
			{
				marker=spawn(AnimMarkerClassName,StartPos);
				if (!marker)
				{
					console.printf("[ERROR] "..AnimMarkerClassName.." not spawnable");//ERROR
					AnimMarkerClassName="";//don't try again
				}
			}
		}
		else
		{
			if (marker) marker.destroy();
		}
		A_SetSize(max(abs(deltaVector.x),abs(deltaVector.y)) / 2, abs(deltaVector.z) / 2);
	}
	
	//spawns a new line3d with the given parameters
	static Line3d SpawnTo(vector3 StartPos, vector3 EndPos, int TimeToLive = -1, int TimeToCycle = 0)
	{
		Line3d l3d = Line3d(actor.spawn("line3d",StartPos));
		if (l3d) l3d.SetEndPoints(StartPos,EndPos,TimeToLive,TimeToCycle);
		return l3d;
	}

	//spawns an actor, if it is line3d subclass, will get the given parameters
	static Line3d SpawnLine(string ClassName, vector3 StartPos, vector3 EndPos, int TimeToLive = -1, int TimeToCycle = 0)
	{
		Actor a = actor.spawn(ClassName,StartPos);
		if (!a)
		{
			console.printf("[ERROR]"..level.time..": Line3d.SpawnLine: "..(ClassName?"Couldn't spawn "..ClassName:"No ClassName"));//ERROR
			return null;
		}
		Line3d l3d = Line3d(a);
		if (!l3d)
		{
			console.printf("[ERROR]"..level.time..": Line3d.SpawnLine: "..ClassName.." couldn't cast to line3d");//ERROR
			return null;
		}
		l3d.SetEndPoints(StartPos,EndPos,TimeToLive,TimeToCycle);
		return l3d;
	}

	//can use this in place of actor.linetrace() to visualize the trace path
	static bool LineTraceVisual(actor source, double angle, double distance, double pitch, int flags = 0, double offsetz = 0., double offsetforward = 0., double offsetside = 0., out FLineTraceData data = null, string LineClassName = "line3d", int TimeToLive = -1, int TimeToCycle = 0, string MarkerClassName = "marker3d")
	{
		if (!source) return false;
		
		bool ret=source.LineTrace(angle,distance,pitch,flags,offsetz,offsetforward,offsetside,data);
		
		VisualizeLineTraceData(data, LineClassName, TimeToLive, TimeToCycle, MarkerClassName);
		
		return ret;
	}

	static void VisualizeLineTraceData(FLineTraceData fltd, string LineClassName = "line3d", int TimeToLive = -1, int TimeToCycle = 0, string MarkerClassName = "marker3d")
	{
		if (fltd.NumPortals > 0)//don't have enough information to debug portals here
		{
			console.printf("[WARN]"..level.time..": Line3d: VisualizeLineTraceData can't work with portals");//DEBUG
			return;
		}
		
		vector3 StartPos=fltd.HitLocation - fltd.HitDir * fltd.distance;
		vector3 StopPos=fltd.HitLocation;
		SpawnLine(LineClassName, StartPos, StopPos, TimeToLive, TimeToCycle);
		if (MarkerClassName)
		{
			double y,p,r;//yaw,pitch,roll
			[y,p,r]=LineTraceCalc.GetHitAnglePitchRoll(fltd);
			actor HitMarker = spawn(MarkerClassName, fltd.HitLocation);
			if (HitMarker)
			{
				marker3d hm3d = marker3d(HitMarker);
				if (hm3d)
				{
					if (fltd.HitType == TRACE_HitActor)
					{
						int hitFace1, hitFace2;
						vector3 hitPos1, hitPos2;
						//I bump StopPos with HitDir because once in a great while the StopPos is actually outside the actor
						[hitFace1, hitPos1, hitFace2, hitPos2] = SegHitBox.CheckIfLineSegHitsActor(StartPos, StopPos + fltd.HitDir, fltd.HitActor, true);
						switch (hitFace1)
						{
							case 1: y=  0;p= 90;r=0;break;
							case 2: y= 90;p= 90;r=0;break;
							case 3: y=180;p= 90;r=0;break;
							case 4: y=270;p= 90;r=0;break;
							case 5: y=  0;p=  0;r=0;break;
							case 6: y=  0;p=-90;r=0;break;
						}
					}
					if (fltd.HitType != TRACE_HitNone) hm3d.Orient(fltd.HitLocation,y,p,r);
					hm3d.TimeToLive=TimeToLive;
					hm3d.TimeToCycle=TimeToCycle;
				}
				else
				{
					HitMarker.angle=y;
					HitMarker.pitch=p;
					HitMarker.roll=r;
				}
			}
		}
	}
}

class LaserBlast : Line3d
{
	default
	{
		translation "0:255=175:175";//make everything RED
	}
	override void TickTTL()
	{
		if (TimeToLive > 0)
		{
			//animate the start point moving to the end
			SetEndPoints(startVector + deltaVector / TimeToLive, startVector + deltaVector, TimeToLive - 1, TimeToCycle);
			if (TimeToLive == 0) Destroy();
		}
	}
}


//A place to park some math functions
//Developed by Mike Ratzlaff (AKA Sir Robin on Zdoom forums) with a tremendous amount of help From Player701
Struct LineTraceCalc
{
	//get the appropriate angle, pitch, and roll from a line trace hit
	//Note these returns are designed to work with flatsprites only, because flatsprites use some wonky math. Models will need different math.
	static double, double, double GetHitAnglePitchRoll(FLineTraceData t){
		double ang, pt, roll;

		switch (t.HitType)
		{		
			case TRACE_HitFloor:
			case TRACE_HitCeiling:
				[ang, pt, roll] = GetHitAnglePitchRollFromPlane(t);
				break;
			case TRACE_HitWall:
				[ang, pt, roll] = GetHitAnglePitchRollFromLine(t);
				break;
			default:
				return 180+VectorAngle(t.HitDir.x,t.HitDir.y), 270+VectorAngle(t.HitDir.xy.length(),t.HitDir.z), 0;
		}

		return ang, pt, roll;
	}

	static double, double, double GetHitAnglePitchRollFromPlane(FLineTraceData t){
		bool is3dfloor = t.Hit3DFloor != null;
		SecPlane p;

		if (is3dfloor)
		{
			p = t.HitType == TRACE_HitFloor ? t.Hit3DFloor.top : t.Hit3DFloor.bottom;
		}
		else if (t.HitType == TRACE_HitFloor)
		{
			p = t.HitSector.floorplane;
		}
		else // if (t.HitType == TRACE_HitCeiling)
		{
			p = t.HitSector.ceilingplane;
		}

		let n = p.Normal;
		if (is3dfloor){n=-1*n;}
		
		double ang = 0, pt = -asin(n.Z);

		if (n.XY.Length() > 0)
		{
			ang = atan2(n.Y, n.X);
		}

		double roll = VectorAngle(t.HitDir.x,t.HitDir.y) + 180 - ang;
		return ang, pt - 90, pt > 0 ? roll : -roll;
	}

	static double, double, double GetHitAnglePitchRollFromLine(FLineTraceData t)
	{
		let delta = t.HitLine.delta;
		double ang = atan2(delta.Y, delta.X);
		return ang + (t.LineSide == Line.front ? -90 : 90), -90, 0;
	}
}

struct SegHitBox //functions to check if a line segment crosses a hitbox
{
	//Returned ints tell which face(s) got hit: 0=no hit, 1=+x, 2=+y, 3=-x, 4=-y, 5=+z, 6=-z
	//If CalcHits is false then the first int is valid and the rest of the returns are undefinted
	static
	int, vector3, int, vector3 CheckIfLineSegHitsActor(vector3 LineStart, vector3 LineStop, actor CheckTarget, bool calcHits = false)
	{
		int hitFace1, hitFace2; vector3 hitPos1, hitPos2;
		[hitFace1, hitPos1, hitFace2, hitPos2] = CheckIfLineSegHitsBox
		(
			LineStart, LineStop,
			(CheckTarget.pos.x - CheckTarget.radius, CheckTarget.pos.y - CheckTarget.radius, CheckTarget.pos.z),
			(CheckTarget.pos.x + CheckTarget.radius, CheckTarget.pos.y + CheckTarget.radius, CheckTarget.pos.z + CheckTarget.height),
			calcHits
		);
		return hitFace1, hitPos1, hitFace2, hitPos2;
	}
	
	//Returned ints tell which face(s) got hit: 0=no hit, 1=+x, 2=+y, 3=-x, 4=-y, 5=+z, 6=-z
	//If CalcHits is false then the first int is valid and the rest of the returns are undefinted
	static
	int, vector3, int, vector3 CheckIfLineSegHitsBox(vector3 LineStart, vector3 LineStop, vector3 corner1, vector3 corner2, bool calcHits = false)
	{
		//note the orientation: front,left,back,right are the planes at 270,180,90,0 degrees
		double aLeft   = min(corner1.x, corner2.x);
		double aRight  = max(corner1.x, corner2.x);
		double aFront  = min(corner1.y, corner2.y);
		double aBack   = max(corner1.y, corner2.y);
		double aBottom = min(corner1.z, corner2.z);
		double aTop    = max(corner1.z, corner2.z);

		//check for easy misses
		if (LineStart.x < aLeft && LineStop.x < aLeft) return 0, (0,0,0), 0, (0,0,0);
		if (LineStart.x > aRight && LineStop.x > aRight) return 0, (0,0,0), 0, (0,0,0);
		if (LineStart.y < aFront && LineStop.y < aFront) return 0, (0,0,0), 0, (0,0,0);
		if (LineStart.y > aBack && LineStop.y > aBack) return 0, (0,0,0), 0, (0,0,0);
		if (LineStart.z < aBottom && LineStop.z < aBottom) return 0, (0,0,0), 0, (0,0,0);
		if (LineStart.z > aTop && LineStop.z > aTop) return 0, (0,0,0), 0, (0,0,0);
		
		vector3 LineDirection = LineStop - LineStart;
		
		int hitFace1, hitFace2;//0=none, 1=+x, 2=+y, 3=-x, 4=-y, 5=+z, 6=-z
		vector3 hitPos1, hitPos2;

		double t;
		if (LineDirection.x != 0)
		{
			//check left
			t = (aLeft - LineStart.x) / LineDirection.x;
			if (0 <= t && t <= 1)
			{
				double y = LineStart.y + LineDirection.y * t;
				double z = LineStart.z + LineDirection.z * t;
				if (aFront <= y && y <= aBack && aBottom <= z && z <= aTop)
				{
					if (!calcHits) return 3, (0, 0, 0), 0, (0, 0, 0) ;
					if (!hitFace1)
					{
						hitPos1=(aLeft, y, z);
						hitFace1=3;
					}
					else
					{
						hitPos2=(aLeft, y, z);
						hitFace2=3;
					}
				}
			}

			//check right
			t = (aRight - LineStart.x) / LineDirection.x;
			if (0 <= t && t <= 1)
			{
				double y = LineStart.y + LineDirection.y * t;
				double z = LineStart.z + LineDirection.z * t;
				if (aFront <= y && y <= aBack && aBottom <= z && z <= aTop)
				{
					if (!calcHits) return 1, (0, 0, 0), 0, (0, 0, 0) ;
					if (!hitFace1)
					{
						hitPos1=(aRight, y, z);
						hitFace1=1;
					}
					else
					{
						hitPos2=(aRight, y, z);
						hitFace2=1;
					}
				}
			}
		}
		
		if (LineDirection.y != 0)
		{
			//check front
			t = (aFront - LineStart.y) / LineDirection.y;
			if (0 <= t && t <= 1)
			{
				double x = LineStart.x + LineDirection.x * t;
				double z = LineStart.z + LineDirection.z * t;
				if (aLeft <= x && x <= aRight && aBottom <= z && z <= aTop)
				{
					if (!calcHits) return 4, (0, 0, 0), 0, (0, 0, 0) ;
					if (!hitFace1)
					{
						hitPos1=(x, aFront, z);
						hitFace1=4;
					}
					else
					{
						hitPos2=(x, aFront, z);
						hitFace2=4;
					}
				}
			}

			//check back
			t = (aBack - LineStart.y) / LineDirection.y;
			if (0 <= t && t <= 1)
			{
				double x = LineStart.x + LineDirection.x * t;
				double z = LineStart.z + LineDirection.z * t;
				if (aLeft <= x && x <= aRight && aBottom <= z && z <= aTop)
				{
					if (!calcHits) return 2, (0, 0, 0), 0, (0, 0, 0) ;
					if (!hitFace1)
					{
						hitPos1=(x, aBack, z);
						hitFace1=2;
					}
					else
					{
						hitPos2=(x, aBack, z);
						hitFace2=2;
					}
				}
			}
		}

		if (LineDirection.z != 0)
		{
			//check bottom
			t = (aBottom - LineStart.z) / LineDirection.z;
			if (0 <= t && t <= 1)
			{
				double x = LineStart.x + LineDirection.x * t;
				double y = LineStart.y + LineDirection.y * t;
				if (aLeft <= x && x <= aRight && aFront <= y && y <= aBack)
				{
					if (!calcHits) return 6, (0, 0, 0), 0, (0, 0, 0) ;
					if (!hitFace1)
					{
						hitPos1=(x, y, aBottom);
						hitFace1=6;
					}
					else
					{
						hitPos2=(x, y, aBottom);
						hitFace2=6;
					}
				}
			}

			//check top
			t = (aTop - LineStart.z) / LineDirection.z;
			if (0 <= t && t <= 1)
			{
				double x = LineStart.x + LineDirection.x * t;
				double y = LineStart.y + LineDirection.y * t;
				if (aLeft <= x && x <= aRight && aFront <= y && y <= aBack)
				{
					if (!calcHits) return 5, (0, 0, 0), 0, (0, 0, 0) ;
					if (!hitFace1)
					{
						hitPos1=(x, y, aTop);
						hitFace1=5;
					}
					else
					{
						hitPos2=(x, y, aTop);
						hitFace2=5;
					}
				}
			}
		}
		
		return hitFace1, hitPos1, hitFace2, hitPos2;
	}
	
	static 
	bool CheckIfPlayerIsAimingAtHitbox(actor Observer, actor CheckTarget, double range)
	{
		if (!Observer || !Observer.player) return false;

		vector3 aimOffset = //calculate vector from angles
		(
			range * cos(Observer.angle) * cos(Observer.pitch),
			range * sin(Observer.angle) * cos(Observer.pitch),
			range * -sin(Observer.pitch)
		);

		vector3 linestop = Observer.vec3Offset(aimOffset.x, aimOffset.y, aimOffset.z + Observer.player.viewheight); //portal-aware
		vector3 linestart = linestop - aimOffset; //get a line seg that does NOT cross a portal
		
		return CheckIfLineSegHitsActor(linestart,linestop,CheckTarget);
	}
	
	static
	bool CheckIfPlayerIsUsingAtHitbox(actor Observer, actor CheckTarget)
	{
		if (!Observer || !Observer.player || !Observer.player.mo) return false;
		return CheckIfPlayerIsAimingAtHitbox(Observer, CheckTarget, Observer.player.mo.userange);
	}
}

class Marker3d_M : Marker3d //Marker Magenta
{
	states
	{
		spawn:
			MARK M -1 bright;
			stop;
	}
}

class Marker3d_R : Marker3d //Marker Red
{
	states
	{
		spawn:
			MARK R -1 bright;
			stop;
	}
}

//Put this in inventory and then use it on floors, walls, ceilings, actors, or even open space
//To stop the flow, drop it and pick it up again
class LineDrawer : Inventory
{
	vector3 lastPos, nextPos;
	line3d ActiveLine;
	FLineTraceData curFltd;
	
	default
	{
		+Inventory.InvBar;
	}
	states
	{
		spawn:
			UNKN A -1;
			stop;
	}
	override void tick()
	{
		super.tick();
		if(!owner || !owner.player || !owner.player.mo)
		{
			if (ActiveLine) ActiveLine.destroy();
			return;
		}

		Owner.LineTrace(
			owner.angle,
			owner.player.mo.userange,
			owner.pitch,
			TRF_SolidActors,
			owner.player.viewheight,
			data: curFltd
		);
		nextPos = curFltd.HitLocation;

		if (ActiveLine) ActiveLine.SetEndPoints(lastPos,nextPos,-1,20);
	}
	override bool use(bool pickup)
	{
		if(!owner || !owner.player || !owner.player.mo) return false;
		
		lastPos=nextPos;
		ActiveLine=line3d.SpawnTo(lastPos,NextPos);
		
		if (curFltd.HitType == TRACE_HitFloor || curFltd.HitType == TRACE_HitWall || curFltd.HitType == TRACE_HitCeiling)
		{
			actor marker = spawn("Marker3d_M",curFltd.HitLocation);
			double y,p,r;
			[y,p,r] = LineTraceCalc.GetHitAnglePitchRoll(curFltd);
			marker.bFlatSprite = true;
			marker.angle = y;
			marker.pitch = p;
			marker.roll = random(0,359);
		}
		
		return false;
	}
	override bool PreTeleport( Vector3 destpos, double destangle, int flags )
	{
		if (ActiveLine) ActiveLine.Destroy();
		return super.PreTeleport(destpos, destangle, flags);
	}
	override void PreTravelled()
	{
		if (ActiveLine) ActiveLine.Destroy();
		super.PreTravelled();
	}
	override void OnDestroy()
	{
		if (ActiveLine) ActiveLine.Destroy();
		super.OnDestroy();
	}
}

//Put this inventory and go frolic, drop it to stop the madness
class LinesComingOutMyButt : Inventory
{
	vector3 lastPos, nextPos;
	line3d ActiveLine;
	const TimeToCycle = 5;
	const TimeToLive = 350;
	
	default
	{
		+Inventory.InvBar;
	}
	states
	{
		spawn:
			UNKN A -1;
			stop;
	}
	override void tick()
	{
		super.tick();
		if(!owner || !owner.player || !owner.player.mo)
		{
			if (ActiveLine) ActiveLine.destroy();
			return;
		}
		
		nextPos = owner.pos + (RotateVector((16,0),owner.angle+180),owner.player.viewheight / 2);

		if (ActiveLine)
		{
			ActiveLine.SetEndPoints(lastPos,nextPos,TimeToLive);
		}
		else
		{
			lastPos=nextPos;
			ActiveLine=line3d.SpawnTo(lastPos,nextPos,TimeToLive);
		}
		if (level.time % TimeToCycle == 0 && lastPos != nextPos)
		{
			ActiveLine.SetEndPoints(lastPos,nextPos,TimeToLive,TimeToCycle);
			lastPos=nextPos;
			ActiveLine=line3d.SpawnTo(lastPos,nextPos,TimeToLive);
		}
	}
	override void OnDestroy()
	{
		if (ActiveLine) ActiveLine.Destroy();
		super.OnDestroy();
	}
}

class LineTraceDebug : inventory //linetrace debugger
{
	default
	{
		+Inventory.InvBar;
	}
	states
	{
		spawn:
			UNKN A -1;
			stop;
	}
	override bool use(bool pickup)
	{
		if (!owner || !owner.player || !owner.player.mo) return false;
		FLineTraceData fltd;
		line3d.LineTraceVisual
		(
			owner, //source actor
			 //----------the usual line trace data here ...
			owner.angle,
			2048,
			owner.pitch,
			0,
			owner.height * 0.5 - owner.floorclip + owner.player.mo.AttackZOffset*owner.player.crouchFactor,
			0,
			0,
			fltd,
			//----------end of the usual line trace data
			"line3d",//which line3d subclass to use for the visual
			175, //time to live in tics
			0, //animation cycle in tics
			"Marker3d" //marker to use at the far end
		);
		switch (fltd.HitType)
		{
			case TRACE_HitNone: console.printf("Hit nothing"); break;
			case TRACE_HitFloor: console.printf("Hit floor "..fltd.HitTexture); break;
			case TRACE_HitWall: console.printf("Hit wall "..fltd.HitTexture); break;
			case TRACE_HitCeiling: console.printf("Hit ceiling "..fltd.HitTexture); break;
			case TRACE_HitActor: console.printf("Hit actor "..fltd.HitActor.GetCharacterName()); break;
		}
		return false;
	}
}

Class ShoulderFire : inventory
{
	default
	{
		+Inventory.InvBar;
	}
	states
	{
		spawn:
			UNKN A -1;
			stop;
	}
	override bool use(bool pickup)
	{
		if (!owner || !owner.player || !owner.player.mo) return false;
		FLineTraceData fltd;
		owner.LineTrace(
			owner.angle,
			2048,
			owner.pitch,
			TRF_ALLACTORS,
			owner.player.viewheight-1,
			0,
			owner.radius * -1/2,
			fltd
		);
		line3d.VisualizeLineTraceData(
			fltd,//the data to visualize
			"line3d",//which line3d subclass to use for the visual
			20, //time to live in tics
			0, //animation cycle in tics
			"Marker3d" //marker to use at the far end
		);
		switch (fltd.HitType)
		{
			case TRACE_HitNone: console.printf("Left hit nothing"); break;
			case TRACE_HitFloor: console.printf("Left hit floor "..fltd.HitTexture); break;
			case TRACE_HitWall: console.printf("Left hit wall "..fltd.HitTexture); break;
			case TRACE_HitCeiling: console.printf("Left hit ceiling "..fltd.HitTexture); break;
			case TRACE_HitActor: console.printf("Left hit actor "..fltd.HitActor.GetCharacterName()); break;
		}
		owner.LineTrace(
			owner.angle,
			2048,
			owner.pitch,
			TRF_ALLACTORS,
			owner.player.viewheight-1,
			0,
			owner.radius * 1/2,
			fltd
		);
		line3d.VisualizeLineTraceData(
			fltd,//the data to visualize
			"line3d",//which line3d subclass to use for the visual
			20, //time to live in tics
			0, //animation cycle in tics
			"Marker3d" //marker to use at the far end
		);
		switch (fltd.HitType)
		{
			case TRACE_HitNone: console.printf("Right hit nothing"); break;
			case TRACE_HitFloor: console.printf("Right hit floor "..fltd.HitTexture); break;
			case TRACE_HitWall: console.printf("Right hit wall "..fltd.HitTexture); break;
			case TRACE_HitCeiling: console.printf("Right hit ceiling "..fltd.HitTexture); break;
			case TRACE_HitActor: console.printf("Right hit actor "..fltd.HitActor.GetCharacterName()); break;
		}
		return false;
	}
}

class PB_BloodTester : Actor
{
    Default {
        BloodType "PB_GunshotBlood", "PB_SawBlood", "PB_SawBlood";
        +SHOOTABLE;
        -NOBLOOD;
        +BUDDHA;
        // bloodcolor "purple";
        Height 56;
        Radius 16;
        Health 1000;
        +NOBLOODDECALS;
    }

    States {
        Spawn:
            PLAY A -1;
            Loop;
    }
}
