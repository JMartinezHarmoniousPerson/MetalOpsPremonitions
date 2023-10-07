//Assault Rifle

Class ARSemiAuto : MO_ZSToken{}

Class AssaultRifle : JMWeapon
{
    Default
    {
        Weapon.AmmoGive 30;
        Weapon.AmmoType1 "HighCalClip";
        Weapon.AmmoType2 "ARAmmo";
        Inventory.PickupMessage "You got the Combat Rifle! (Slot 4)";
        Obituary "%o was shot down by %k's Combat Rifle.";
        Tag "Combat Rifle";
		Inventory.PickupSound "weapons/ar/pickup";
    }

    States
    {
		ContinueSelect:
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise();
		Goto Ready;
		
        Spawn:
            AR1W A -1;
            STOP;
        Ready:
		SelectAnimation:
			TNT1 A 0 A_StartSound("weapons/ar/select",0);
            AR1S ABCD 1;
        ReadyToFire:
            AR1G A 1 JM_WeaponReady(WRF_ALLOWRELOAD);
            Loop;
        Select:
			TNT1 A 0;
			Goto ClearAudioAndResetOverlays;
        Fire:
			TNT1 A 0 JM_CheckMag("ARAmmo");
            AR1F A 1 BRIGHT {
                A_FireBullets(5.6, 0, 1, 18, "UpdatedBulletPuff",FBF_NORANDOM,0,"MO_BulletTracer",0);
                A_TakeInventory("ARAmmo", 1,TIF_NOTAKEINFINITE);
                A_StartSound("weapons/ar/fire", 0);
				A_SpawnItemEx("GunSmoke",15,0,34,2,0,0);
				JM_CheckForQuadDamage();
            }
            AR1F B 1 BRIGHT 
			{
				JM_WeaponReady(WRF_NOFIRE);
				A_SpawnItemEx("EmptyRifleBrass",36, 9, 22, random(-2,2), random(3,6), random(3,5));
				if(!GetCvar("mo_nogunrecoil"))
				{
					A_SetPitch(pitch-0.8,SPF_Interpolate);
					A_SetAngle(angle+.04,SPF_INTERPOLATE);
				}
			}
            AR1F C 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				if(!GetCvar("mo_nogunrecoil"))
				{
					A_SetPitch(pitch-0.7,SPF_Interpolate);
					A_SetAngle(angle+.04,SPF_INTERPOLATE);
				}
			}
			AR1F D 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 {
				if(CountInv("ARAmmo") < 1)
					{A_SetInventory("GunIsEmpty",1);}
			}
			TNT1 A 0 JM_CheckMag("ARAmmo");		
            AR1F A 0 
			{
				if(PressingFire())
				{
					if(CheckInventory("ARSemiAuto",1))
					{return ResolveState("FireFinished");}
					else{return ResolveState("Fire");}
				}
				return ResolveState(null);
			}
            Goto ReadyToFire;
        Deselect:
            AR1S DCBA 1;
            TNT1 A 0 A_Lower(12);
            Wait;
		
		FireFinished:
			AR1G A 1 JM_WeaponReady(WRF_NoFire);
			AR1F A 0 A_JumpIf(JustReleased(BT_ATTACK), "ReadyToFire");
			Loop;
        
        Reload:
			TNT1 A 0 A_JumpIfInventory("ARAmmo",30,"ReadyToFire");
			TNT1 A 0 A_JumpIfInventory("HighCalClip",1,1);
			Goto ReadyToFire;
			AR10 ABC 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 DEF 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 GHI 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 I 7 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
				}
			AR12 A 0 A_JumpIf(CountInv("ARAmmo") < 1, 2);
			AR10 A 0;
			"####" J 1 A_StartSound("weapons/ar/magout", CHAN_AUTO);
			"####" KLM 1 JM_WeaponReady(WRF_NOFIRE);
			AR12 A 0 A_JumpIf(CountInv("ARAmmo") >= 1, 2);
			AR10 A 0 A_SpawnItemEx('ARMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			AR10 N 11 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(6);}
				}
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 OPQ 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_StartSound("weapons/ar/magin", CHAN_AUTO);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 RST 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 JM_ReloadGun("ARAmmo", "HighCalClip",30,1);
		DoneReload:		
			AR10 UV 1;
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,4);
			AR10 WWWWXYZ 1; //JM_WeaponReady(WRF_NOFIRE);
			AR11 ABC 1;// JM_WeaponReady(WRF_NOFIRE);
			AR11 A 0 A_JumpIf(CountInv("GunIsEmpty") >= 1, "Chamber");
			 AR1G A 1;
			 Goto ReadyToFire;
       
		ActionSpecial:
			"####" A 0 
			{
				if(CountInv("ARSemiAuto") == 1)
				{
					A_SetInventory("ARSemiAuto",0);
					A_Print("Full Auto");
				}
				else			
				{
					A_SetInventory("ARSemiAuto",1);
					A_Print("Semi Auto");
				}
			}
			AR1K ABCDEFGGG 1;// JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/modeswitch",0);
			AR1K GGG 1;
			AR1K FEDCBA 1 JM_WeaponReady();
			Goto ReadyToFire;

		Chamber:
			TNT1 A 0 A_SetInventory("GunIsEmpty",0);
			AR1G A 1 A_StartSound("weapons/ar/select",0);
			AR11 DEFGHIJ 1;
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			AR11 JK 1;// A_StartSound("weapons/ar/chamberbck",1);
			AR11 LMM 1;
			AR11 N 0 A_StartSound("weapons/ar/chamberfwd",2);
			AR11 NOPQQQQQ 1;
			AR11 GFED 1;
			GOTO ReadyToFire;
		
		FlashKick:
			AR1K ABCDEFG 1;// JM_WeaponReady();
			AR1K GGFFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKick:
			AR1K ABCDEFG 1;// JM_WeaponReady();
			AR1K G 5;
			AR1K GGFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
    }
} 

Class ARAmmo : Ammo
{
	Default
	{
    Inventory.Amount 0;
	Inventory.MaxAmount 30;
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 30;
	Inventory.Icon "AR1WA0";
	+INVENTORY.IGNORESKILL;
	}
}