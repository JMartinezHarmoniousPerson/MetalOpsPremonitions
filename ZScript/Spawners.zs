class ShotgunDropper : Inventory
{
	Default{+DROPPED}
	States
	{
	 Spawn:
        TNT1 A 0 NoDelay
        {
            If(invoker.bTOSSED) //If a monster drops this, only drop the Lever Shotgun
                { A_SpawnItemEx("LeverShotgun", flags:SXF_NOCHECKPOSITION); }
            Else
                { A_SpawnItemEx("ShotgunSpawner", flags:SXF_NOCHECKPOSITION); }
        }
        Stop;
   }
}

class ShotgunSpawner : RandomSpawner
{
	Default
    {
		DropItem "LeverShotgun", 255, 4;
		DropItem "MO_Pumpshotgun", 255, 2;
		DropItem "SSGRandomizer", 255,1;
	}
}

//This is not a spawner! This is a randomizer actor for the SSG spawn option.
//If the ssg random spawn on shotgun is off, it would spawn either the 
//lever action or pump shotgun. -JM
class SSGRandomizer : actor
{
	States
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 1
			{
				if(CVar.FindCVar("mo_ssgrandomizer").GetBool() == True)
				{return resolvestate("SpawnSSG");}
				return A_Jump(256, "SpawnPump", "SpawnLever");
			}
		SpawnSSG:
			TNT1 A 0;
			TNT1 A 1 A_Jump(80, "SpawnPump", "SpawnLever");
			TNT1 A 0 A_SpawnItemEx("MO_SSG");
			Stop;
		SpawnPump:
			TNT1 A 0 A_SpawnItemEx("MO_Pumpshotgun");
			Stop;
		SpawnLever:
			TNT1 A 0 A_SpawnItemEx("LeverShotgun");
			Stop;
	}
}

//Based on code from Jarwill and Ac1d
class ChaingunDropper : Inventory// replaces Chaingun
{
	Default{+DROPPED}
	States
	{
	 Spawn:
        TNT1 A 0 NoDelay
        {
            If(invoker.bTOSSED) //If a monster drops this, only drop the Minigun
                { A_SpawnItem("MO_MiniGun"); }
            Else
                { A_SpawnItem("ChaingunSpawner"); }
        }
        Stop;
   }
}

class ChaingunSpawner : RandomSpawner
{
	Default
    {
		DropItem "MO_MiniGun", 255, 4;
		DropItem "AssaultRifle", 255, 2;
		DropItem "MO_HeavyRifle", 255,1;
		DropItem "MO_SubMachinegun",255, 1;
	}
}

class ClipSpawner : RandomSpawner replaces Clip
{
	Default
	{
		DropItem "MO_HighCaliber";
		DropItem "MO_LowCaliber";
	}
}

class ClipboxSpawner : RandomSpawner replaces Clipbox
{
	Default
	{
		DropItem "MO_HighCalBox", 255;
		DropItem "MO_LowCalBox", 255;
	}
}

class ShellSpawner : RandomSpawner replaces Shell
{
	Default
	{
		DropItem "MO_ShotShell";
	}
}

class ShellboxSpawner : RandomSpawner replaces ShellBox
{
	Default
	{
		DropItem "MO_ShellBox";
	}
}

class BFGSpawner : RandomSpawner replaces BFG9000
{
	Default
	{
		DropItem "MO_BFG9000", 255, 3;
		DropItem "MO_Unmaker", 255, 1;
	}
}

/*
class FlamethrowerSpawner : CustomInventory replaces Chainsaw
{
	Default
	{
//		+COUNTITEM;
		+FLOORCLIP;
		+DONTGIB;
		Scale 0.42;
		Inventory.PickupSound "weapons/flamer/pickup";
        Inventory.PickupMessage "";
	}
	States
	{
		Spawn:
			TNT1 A 0;
			F1MC A -1;
			Stop;
		Pickup:
			TNT1 A 0 A_JumpIfInventory("MO_Flamethrower",1,"PickupGas");
			TNT1 A 1
			{
				A_GiveInventory("MO_Flamethrower",1);
				A_GiveInventory("MO_Gasoline",75);
				A_Log("You got the Flamethrower! (Slot 1)");
			}
			Stop;
		PickupGas:
			TNT1 A 1
			{
				A_GiveInventory("MO_Gasoline",75);
				A_Log("You got the gasoline from the Flamethrower! +90 Gas");
			}
			Stop;
	}
}
*/

//Items and Powerups
Class BerserkPackSpawner: RandomSpawner replaces Berserk
{
	Default
	{
		DropItem "MO_Berserk",255,3;
		DropItem "MO_HasteSphere",255,1;
	}
}

Class InvulSphereSpawner : RandomSpawner replaces InvulnerabilitySphere
{
	Default
	{
		DropItem "MO_Invulnerability",255,3;
		DropItem "MO_QuadDMGSphere",255,1;
	}
}

Class ArmorBonusSpawner : RandomSpawner replaces ArmorBonus
{
	Default
	{
		DropItem "MO_ArmorBonus",255,3;
		DropItem "MO_GeminusBonus",255, 1;
		DropItem "MO_TrebleBonus",255,1;
	}
}


Class HealthBonusSpawner : RandomSpawner replaces HealthBonus
{
	Default
	{
		DropItem "MO_HealthBonus",255,3;
		DropItem "MO_DoubleHealthBonus",255, 1;
		DropItem "MO_TripleHealthBonus",255,1;
	}
}