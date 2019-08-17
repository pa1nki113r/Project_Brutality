// Copyright 2006-2019 Nash Muhandes
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//===========================================================================
//
//
//
//===========================================================================

class NashGoreLiquidBlood : Actor
{
	Default
	{
		Radius 3;
		Height 7;
		MaxStepHeight 0;
		MaxDropOffHeight 0;
		FloatBobPhase 0;
		+NOGRAVITY
		+DONTSPLASH
		+FLATSPRITE
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	static void SpawnLiquidBlood(Actor self)
	{
		if (!self) return;
		self.A_SpawnItemEx("NashGoreLiquidBlood", angle: NashGoreStatics.RandomAngle4(), flags: NashGoreBloodBase.BLOOD_FLAGS);
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		Super.Tick();
		if (!bNoTimeFreeze && (isFrozen() || Level.isFrozen())) return;

		A_SetScale(Scale.X * 1.01);

		if (waterlevel > 0)
		{
			//bFlatSprite = false;
			Destroy();
			return;
		}

		if (waterlevel >= 3)
		{
			Vel.X = Vel.X + cos(Angle) * 0.06;
			Vel.Y = Vel.Y + sin(Angle) * 0.06;
			Vel.Z = -0.3;
		}
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	States
	{
	Spawn:
		NLIQ A 1 A_FadeOut(0.01);
		Loop;
	}
}
