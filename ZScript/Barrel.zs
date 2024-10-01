//Mostly based on the Smooth Doom barrels
class MO_ExplosiveBarrel : ExplosiveBarrel replaces ExplosiveBarrel
{
	bool notSunlust;
	int age;
	Default
	{
		DeathSound "world/barrelexpl";
		Obituary "$OB_BARREL";
		+Windthrust
	}

	override void PostBeginPlay()
	{
		notSunlust = false;
	}

	override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		if (mod == "Kick" || mod == "LowKick" || mod == "ExtremePunches" || mod == "Melee")
		{
			ThrustThingZ(0,10,0,1);
			ThrustThing(angle*256/360, 10, 0, 0);
			return 0;
		}
		return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}

	override void Tick()
	{
		super.Tick();
		age++;
		if(age >= 35)
		{
			self.notSunlust = true;
		}
	}
		

	States
	{
	Spawn:
		BARL abcdefghijklm 3;
		Loop;
	Death:
		B3XP A 8 BRIGHT;
		B3XP B 6 BRIGHT;
		B3XP C 4 BRIGHT;
		B3XP D 2 BRIGHT;
		BEXP E 0 A_JumpIf(invoker.notSunlust == true, "PerformanceDeath");
		bexp E 0 Bright 
		{
				A_SpawnItemEx ("BarrelShrapnelA",0,0,5,random (5, -5),random (5, -5),random (5, 8),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelB",0,0,5,random (5, -5),random (5, -5),random (5, 8),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelC",0,0,5,random (5, -5),random (5, -5),random (5, 8),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelB",0,0,5,random (5, -5),random (5, -5),random (5, 8),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx("BarrelExplosionFX",0,0,12,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx("MO_ShockWave",flags:SXF_NOCHECKPOSITION);
				A_Scream();
				A_Explode();
				A_SpawnItemEx("MO_BarrelBottomRemains", flags: SXF_NOCHECKPOSITION);
		}
		TNT1 A 1050 BRIGHT A_BarrelDestroy;
		TNT1 A 5 A_Respawn;
		Wait;
	PerformanceDeath:
		TNT1 A 0
		{
			A_Scream();
			A_Explode();
		}
		b3xp EFGHIJKLMNO 2 Bright;
		TNT1 A 1050 Bright A_BarrelDestroy;
		TNT1 A 5 A_Respawn;
		Wait;
	}
}

//Effects
class MO_BarrelBottomRemains : actor
{
	Default
	{
		Scale 0.9;
		Radius 2;
		Height 5;
	}
	States
	{
		Spawn:
			BARP DE 0;
			BARP D -1 {frame = random(3,4);}
			Stop;
	}
}

Class BarrelShrapnelBase : actor
{
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		frame = shrapFrame;
	}

	int ShrapFrame;
	Property ShrapnelFrame : shrapFrame;
	Default
	{
		Radius 2;
		Height 2;
		Speed 8;
		Mass 1;
		Gravity 0.9;
		Mass 15;
		Scale 0.5;
		BounceFactor 0.4;
		BounceCount 4;
		+MISSILE
		+NOBLOCKMAP
		+NOTELEPORT
		+MOVEWITHSECTOR
		+ROLLSPRITE
		//+CLIENTSIDEONLY
		+THRUACTORS
		+DontSplash
		+FLOORCLIP
		BounceType "Doom";
		BarrelShrapnelBase.ShrapnelFrame 0;
	}
		States {
			Spawn:
				BARP # 0;
				#### # 1;
				Goto Spinning;
			Spinning:
				"####" "#" 1 A_Setroll(roll+22.5);
				Loop;
			Death:
				"####" "#" 0 A_SetRoll(0);
				"####" "#" 1;
				"####" "#" 300;
				"####" "###############" 2 A_FadeOut(0.1);
				Stop;
			CacheTextures:
				BARP ABC 0;
				Stop;
	}
}

Class BarrelShrapnelA : BarrelShrapnelBase
{
	Default
	{
		BarrelShrapnelBase.ShrapnelFrame 0;
	}
}

Class BarrelShrapnelB : BarrelShrapnelBase
{
	Default
	{
		BarrelShrapnelBase.ShrapnelFrame 1;
	}
}

Class BarrelShrapnelC : BarrelShrapnelBase
{
	Default
	{
		BarrelShrapnelBase.ShrapnelFrame 2;
	}
}