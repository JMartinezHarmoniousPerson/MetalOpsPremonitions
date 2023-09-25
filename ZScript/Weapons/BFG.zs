//BFG

class MO_BFG9000 : JMWeapon// replaces BFG9000
{
	Default
	{
		Height 20;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "MO_Cell";
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You got the BFG9K! Hell yeah! (Slot 7)";
		Tag "BFG9K";
		Inventory.PickupSound "weapons/bfg/draw";
	}
	States
	{
	Ready:
	SelectAnimation:
		TNT1 A 0 A_StartSound("weapons/bfg/draw",1);
		B7SS ABCDEF 1;
	ReadyToFire:
		B7GG A 0 A_StartSound("weapons/bfg/idleloop", 6, CHANF_LOOPING);
	ReadyLoop:
		BF7G A 0 JM_WeaponReady;
		B7GG AABBCCDDEE 1 JM_WeaponReady;
		Loop;
	Deselect:
		TNT1 A 0 A_StopSound(6);
		B7SS FEDCBA 1;
		B7GG A 0 A_Lower;
		Wait;
	Select:
		TNT1 A 0;	
		Goto ClearAudioAndResetOverlays;
	ContinueSelect:
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise();
		Goto Ready;
	Fire:
		BFGA A 0 A_JumpIfInventory("MO_Cell",40,1);
		Goto ReadyToFire;
		B7GF A 1 BRIGHT A_StartSound("weapons/bfg/startfire", 1);
		B7GF B 1 BRIGHT;
		B7GF C 1 BRIGHT;
		TNT1 A 0 A_StartSound("weapons/bfg/chargelayer", 0, CHANF_DEFAULT,0.85);
		B7GF D 1 BRIGHT;
        B7GF E 1 BRIGHT;
		B7GF B 1 BRIGHT;
		B7GF C 1 BRIGHT;
		B7GF D 1 BRIGHT;
		B7GF E 1 BRIGHT;
		B7GF B 1 BRIGHT;
		B7GF C 1 BRIGHT;
		B7GF D 1 BRIGHT;
        B7GF EFGH 1 BRIGHT;
        B7GF EFGH 1 BRIGHT;
		B7GF EFGHHIJ 1 BRIGHT;
        B7GF A 0 A_StartSound("weapons/bfg/FIRE", 1);
		B7GF A 0 A_TakeInventory("MO_Cell",40);
        B7GF K 1 A_FireProjectile("MO_BFGBall",0,0,0,0,0);
		TNT1 A 0 JM_CheckForQuadDamage();
		TNT1 A 0
		{
				if(!GetCvar("mo_nogunrecoil"))
				{
                A_SetPitch(pitch-7.0,SPF_Interpolate);
			    A_SetAngle(angle+1.75,SPF_INTERPOLATE);
				}
		}		
        B7GF L 1;
		B7GF M 1
		{
				if(!GetCvar("mo_nogunrecoil"))
				{
                A_SetPitch(pitch-6.0,SPF_Interpolate);
			    A_SetAngle(angle+1.25,SPF_INTERPOLATE);
				}
		}
		B7GF N 1
		{
			if(!GetCvar("mo_nogunrecoil"))
			{
                A_SetPitch(pitch-4.0,SPF_Interpolate);
			    A_SetAngle(angle-1,SPF_INTERPOLATE);
			}
		}
		B7GF O 1
		{
			if(!GetCvar("mo_nogunrecoil"))
			{
                A_SetPitch(pitch-2.0,SPF_Interpolate);
			    A_SetAngle(angle-.75,SPF_INTERPOLATE);
			}
		}
		B7GF PQQQRRRR 1;
        B7GF SSTTU 1;
		TNT1 A 0 A_ReFire("Fire");
		Goto ReadyToFire;
	FlashKick:
		B7GK ABCDEFGGFEDCBA 1;
		Goto ReadyToFire;
		
	FlashAirKick:
		B7GK ABCDEFGGGFFEDCBA 1;
		Goto ReadyToFire;
	Spawn:
		B7UG A -1;
		Stop;
	}
}
//BFG effects, code from Particle Fire Enhancer Mod (v0.8) by Z86
Class MO_BFGBall : BFGBall replaces BFGBall
{
	Default
	{
	  Alpha 1;
	  Scale 1.25;
	  DeathSound "weapons/bfg/explosion";
	  DamageType "Desintegrate";
	  DamageFunction random(600, 800);
	  +NOTELEPORT;
	  +ZDOOMTRANS;
	}
  States
  {
  Spawn:
    NULL A 0;
	NULL A 0 A_StartSound("weapons/bfg/ballfly",6,CHANF_LOOPING,1);
	TNT1 A 0 A_SpawnItemEx("GreenLightningTiny", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 172);
	TNT1 A 0 A_SpawnItemEx("GreenLightningSmall", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 216);
	TNT1 A 0 A_SpawnItemEx("GreenLightningMedium", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 248);
    BFS1 AB 2 bright Light("BFGBallLight") A_SpawnItem("BFGTrail");
    loop;
  Death:
    NULL A 0;
	NULL A 0 A_StopSound(6);
    NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
	NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
	NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
	NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
    NULL A 0;
	NULL A 0 A_Explode(250, 200,0);
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG8", 0, 0, 0, 0, 0, 0, 0, 0, 0);
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG2", 0, 0, 0, 0, 0, 0, 0, 0, 0);
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG3", 0, 0, 0, 0, 0, 0, 0, 0, 0);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 144);
	NULL A 0 A_SpawnItem("BFGExplosion");
	TNT1 A 4 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
    TNT1 A 4 bright;
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG4", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG6", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG7", 0, 0, 0, 0, 0, 0, 0, 0, 0)	
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
	TNT1 A 4 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 A 4 bright;
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG1", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG5", 0, -24, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG5", 0, 24, 0, 0, 0, 0, 0, 0, 0)
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningHuge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
    NULL A 8 bright A_BFGSpray;  // See BFGExtra	
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 10 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
    stop;
  }
}

class BFGExplosion : BaseVisualSFX
{
	Default
	{
	  +NoGravity
	  +NoInteraction
	  +NoBlockmap
	  Scale 1.25;
	  Renderstyle "Translucent";
	  Alpha 0.76;
	}
  States
  {
  Spawn:
    TNT1 A 0;
	TNT1 A 0 A_SpawnItemEx("GreenExplosionFlare", 0, 0, 6, 0, 0, 0, 0, 0, 0);
	//NULL A 0 A_SpawnItem("BoomGreen")
    TNT1 AAAAAAAAAAAAAA 0 A_SpawnItemEx("LLGreenFireLarge", Random(-3, 3), Random(-8, 8), Random(-3, 3), (0.01)*Random(-90, 90), (0.016)*Random(-90, 90), (0.01)*Random(-90, 90), 0, SXF_NOCHECKPOSITION, 8);
    BFGB ABCDEFG 2 Bright A_FadeOut(0.05);
    stop;
  }
}

Class BFGTrail : BaseVisualSFX
{
	Default
	{
	  RenderStyle "Add";
	  Scale 0.15;
	  Alpha 0.9;
	}
  States
  {
  Spawn:
    BFBC A 1 Bright A_FadeOut(0.02);
    loop;
  }
}

Class BFGParticle : Actor
{
	Default
	{
	  +NOGRAVITY;
	  +NOTELEPORT;
	  +ForceXYBillboard;
	  +CLIENTSIDEONLY;
	  +Doombounce;
	  +missile;
	  +THRUACTORS;
	  +dontsplash;
	  Bouncecount 3;
	  Radius 3;
	  Height 6;
	  Speed 6;
	  RenderStyle 'Add';
	  Alpha 0.9;
	  Scale 0.12;
	}
  States
  {
  Spawn:
    BFPA A 1 bright A_FadeOut(0.01);
    loop;
  }
}

class MO_BFGExtra : BFGExtra replaces BFGExtra
{
	Default
	{
	Alpha 1;
	Scale 0.5;
	}
  States
  {
  Spawn:
    NULL A 0;
	NULL A 0;//A_SpawnDebris("GreenPlasmaSpark");
	NULL A 0;// A_SpawnItem("GreenPlasmaSmoke");
	NULL A 0 A_SpawnItem("GreenExplosionFlareSmallFaded");
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG2", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG3", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	TNT1 AAAAAAAAAAAAAA 0 A_SpawnItemEx("LLGreenFireSmall", Random(-3, 3), Random(-4, 4), Random(-3, 3), (0.01)*Random(-90, 90), (0.01)*Random(-90, 90), (0.01)*Random(-90, 90), 0, SXF_NOCHECKPOSITION, 8);
	//NULL A 0 A_SpawnItem("BoomGreenSmall")
	BFXF A 6 bright Light("BFGXLight1");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 A 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	BFXF B 6 bright Light("BFGXLight2");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	BFXF C 6 bright Light("BFGXLight2");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	BFXF D 6 bright Light("BFGXLight1");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	BFXF E 6 bright Light("BFGXLight1");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
    //BFXF ABCDE 6 bright
    stop;
  }
}