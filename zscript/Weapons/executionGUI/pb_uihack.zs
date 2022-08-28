/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2019-2021
 *
 * This file is part of Target Spy.
 *
 * Target Spy is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Target Spy is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * Hack. The purpose of this class is to access play functions from UI scope.
 */
class pb_uiHack
{

  play
  Actor aimTargetWrapper(Actor a) const
  {
    return a.aimTarget();
  }

  play
  Actor lineAttackTargetWrapper(Actor a, double offsetz) const
  {
    FLineTraceData lineTraceData;
    a.lineTrace(a.angle, 4000.0, a.pitch, 0, offsetz, 0.0, 0.0, lineTraceData);
    return lineTraceData.hitActor;
  }

  play
  Actor aimLineAttackWrapper(Actor a) const
  {
    FTranslatedLineTarget lineTarget;
    a.aimLineAttack(a.angle, 2048.0, lineTarget, 0, ALF_CheckNonShootable | ALF_ForceNoSmart);
    return lineTarget.lineTarget;
  }
  
  play
  double getTargetDistanceWrapper(Actor a) const {
	Actor target = a.aimTarget();
	return a.Distance3D(target);
  }
  
}
