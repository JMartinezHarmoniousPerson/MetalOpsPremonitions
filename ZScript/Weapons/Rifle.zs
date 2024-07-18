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
			SMGG A 0 {if(invoker.isZoomed) {SetWeaponState("Ready2");}}
            AR1G A 1 
			{
				return JM_WeaponReady(WRF_ALLOWRELOAD);
			}
            Loop;
        Select:
			TNT1 A 0;
			TNT1 A 0 {invoker.isZoomed = False;}
			SMGR A 0 A_ZoomFactor(1.0);
			Goto ClearAudioAndResetOverlays;
        Fire:
			TNT1 A 0 JM_CheckMag("ARAmmo");
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "Fire2");
            AR1F A 1 BRIGHT {
                A_FireBullets(5.6, 0, 1, 18, "UpdatedBulletPuff",FBF_NORANDOM,0,"MO_BulletTracer",0);
                A_TakeInventory("ARAmmo", 1, TIF_NOTAKEINFINITE);
                A_StartSound("weapons/ar/fire", 0);
				A_SpawnItemEx("GunSmoke",15,0,34,2,0,0);
				JM_CheckForQuadDamage();
            }
			AR1F A 0 {
				if(CountInv("ARAmmo") < 1)
					{A_SetInventory("GunIsEmpty",1);}
			}
            AR1F B 1 BRIGHT 
			{
				JM_WeaponReady(WRF_NOFIRE);
				A_SpawnItemEx("EmptyRifleBrass",42, 9, 28, random(-2,2), random(3,6), random(3,5));
				JM_GunRecoil(-0.8, .04);
			}
            AR1F C 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-0.7, .04);
			}
			AR1F D 1 JM_WeaponReady(WRF_NOPRIMARY);
			TNT1 A 0 JM_CheckMag("ARAmmo");		
            AR1F A 0 
			{
				if(PressingFire())
				{
					if(CheckInventory("ARSemiAuto",1))
					{SetWeaponState("FireFinished");}
					else{SetWeaponState("Fire");}
				}
			}
            Goto ReadyToFire;

		AltFire:
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "UnZoom");
			TNT1 A 0 {invoker.isZoomed = true;}
			SMGR A 0 A_ZoomFactor(1.4);
			SMGR A 0 A_SetCrosshair(5);
			AR1Z ABCD 1 JM_WeaponReady(WRF_NOFIRE);
			AR1Z E 1 JM_WeaponReady(WRF_NOFIRE);
		Ready2:
			AR1Z E 1
			{
				if(invoker.ADSMode == 1) {SetWeaponState("ADSHold");}
				JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				if(JustPressed(BT_ALTATTACK)) {SetWeaponState("UnZoom");}
			}
			Loop;

		ADSHold:
			AR1Z E 1 
			{
				JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				if(!PressingAltFire()) {SetWeaponState("UnZoom");}
			}
			Loop;

		Unzoom:
			TNT1 A 0 {invoker.isZoomed = false;}
			SMGR A 0 A_ZoomFactor(1);
			SMGR A 0 A_SetCrosshair(0);
			AR1Z EDCBA 1 JM_WeaponReady(WRF_NOFIRE);
			Goto ReadyToFire;

		Fire2:
			  AR1Z F 1 BRIGHT {
                 A_FireBullets(5.6, 0, 1, 18, "UpdatedBulletPuff",FBF_NORANDOM,0,"MO_BulletTracer",0);
                A_TakeInventory("ARAmmo", 1, TIF_NOTAKEINFINITE);
                A_StartSound("weapons/ar/fire", 0);
				A_SpawnItemEx("GunSmoke",15,0,34,2,0,0);
				JM_CheckForQuadDamage();
            }
            AR1Z G 1 BRIGHT 
			{
				JM_GunRecoil(-0.7, .04);
				JM_WeaponReady(WRF_NOFIRE);
				A_SpawnItemEx("EmptyRifleBrass",35, 4, 32, random(-2,2), random(3,5), random(3,5));
			}
			AR1Z H 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-0.58, .04);
			}
            AR1Z I 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 {
				if(CountInv("ARAmmo") < 1)
					{A_SetInventory("GunIsEmpty",1);}
			}
			TNT1 A 0 JM_CheckMag("ARAmmo");
			 AR1F A 0
			{
				if(invoker.ADSMode == 1)
				{
					if(!PressingAltFire()) {
						SetWeaponState("UnZoom");
					}
				}
				if(CountInv("ARSemiAuto") >= 1)
				{
						SetWeaponState("FireFinished");
				}
				return JM_WeaponReady(WRF_NOFIRE|WRF_ALLOWRELOAD);
			}		
            Goto Ready2;

        Deselect:
			TNT1 A 0 A_ZoomFactor(1);
            AR1S DCBA 1;
            TNT1 A 0 A_Lower(12);
            Wait;
		
		FireFinished:
			AR1Z E 0 A_JumpIf(invoker.isZoomed, 2);
			AR1G A 0;
			"####" "#" 1 JM_WeaponReady(WRF_NoFire);
			AR1F A 0 A_JumpIf(!PressingFire(), "ReadyToFire");
			Loop;
        
        Reload:
			TNT1 A 0 A_JumpIfInventory("ARAmmo",30,"ReadyToFire");
			TNT1 A 0 A_JumpIfInventory("HighCalClip",1,1);
			Goto ReadyToFire;
			TNT1 AAA 0;
			AR10 A 0 {
				if(Invoker.isZoomed) {SetWeaponState("ReloadZoomed");}
			}
			AR10 A 0 
			{
				invoker.isZoomed = false;
				A_ZoomFactor(1.0);
				if(CountInv("ARAmmo") < 1) {return A_Jump(128, "MagFlipReload");}
				return ResolveState(Null);
			}
			AR10 ABC 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 DEF 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 GHI 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 I 7 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
				}
			A612 A 0 A_JumpIf(CountInv("ARAmmo") < 1, 2);
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
		DoneReload:		
			AR10 UV 1;
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,4);
			AR10 WWWWXYZ 1; //JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR11 AB 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/ReloadEnd",1);
			AR11 A 0 A_JumpIf(CountInv("GunIsEmpty") >= 1, "Chamber");
			AR10 A 0 JM_ReloadGun("ARAmmo", "HighCalClip",30,1);
			AR11 C 1 JM_WeaponReady(WRF_NOFIRE);
			 AR1G A 1;
			 Goto ReadyToFire;
       MagFlipReload:
			AR1G A 0 A_StartSound("weapons/ar/arflipstart", 0);
			AR12 ABC 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 DEF 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 GH 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/magflipsound",0);
			AR12 I 11 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(6);}
				}
			AR12 J 1 JM_WeaponReady(WRF_NOFIRE);	
			AR12 K 1 A_StartSound("weapons/ar/arflipend", 0);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			AR12 L 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_SpawnItemEx('ARMagazine', 28, 7, 29, random(-1,2), random(-8,-4), random(2,3));
			AR12 MNO 1 JM_WeaponReady(WRF_NOFIRE);
			AR12 P 5 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
				}
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 QRS 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_StartSound("weapons/ar/magin", CHAN_AUTO);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 TUV 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 JM_ReloadGun("ARAmmo", "HighCalClip",30,1);
			AR12 W 5 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
				}
			AR12 A 0 A_SetInventory("GunIsEmpty",0);
			AR12 XYZ 1;
			AR13 AB 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR13 CCDE 1  JM_WeaponReady(WRF_NOFIRE);
			AR13 F 1;
			AR11 J 0 A_StartSound("weapons/ar/chamberfwd",1);
			AR13 G 1;
			AR13 H 7
			{
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
			}
			AR11 J 0 A_StartSound("weapons/ar/ReloadEnd",1);
			AR13 IJKL 1;
			Goto ReadyToFire;

		ReloadZoomed:
			TNT1 A 0 A_ZoomFactor(1.275);
			AR1Z E 1 JM_WeaponReady(WRF_NOFIRE);
			ARZR AB 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR BCC 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR DEF 1 JM_WeaponReady(WRF_NOFIRE);
			ARZR G 7 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
				}
			ARZR H 1 A_StartSound("weapons/ar/magout", CHAN_AUTO);
			ARZR IJI 1 JM_WeaponReady(WRF_NOFIRE);
			AR12 A 0 A_JumpIf(CountInv("ARAmmo") >= 1, 2);
			AR10 A 0 A_SpawnItemEx('ARMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			ARZR K 11 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(6);}
				}
			ARZR A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR KKL 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_StartSound("weapons/ar/magin", CHAN_AUTO);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR MN 1 JM_WeaponReady(WRF_NOFIRE);
			ARZR O 1;
			ARZR O 5 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
				}
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR PQR 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 A 0 A_JumpIf(CountInv("GunIsEmpty") >= 1, "Chamber");
			AR10 A 0 JM_ReloadGun("ARAmmo", "HighCalClip",30,1);
			TNT1 A 0 A_ZoomFactor(1.4);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR STU 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/ReloadEnd",1);
			ARZR B 1 JM_WeaponReady(WRF_NOFIRE);
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
			AR10 A 0 JM_ReloadGun("ARAmmo", "HighCalClip",30,1);
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "Chamber2");
			AR1G A 0 A_StartSound("weapons/ar/ReloadEnd",0);
			AR11 D 1;
			AR11 EF 2;
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			AR11 GH 2;
			AR11 N 0 A_StartSound("weapons/ar/chamberfwd",2);
			AR11 IJKLMNO 1;
			GOTO ReadyToFire;

		Chamber2: //Zoomed
			AR1G A 0 A_StartSound("weapons/ar/ReloadEnd",0);
			ARZR S 2;
			ARZS ABCD 1;
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			ARZS EEFG 1;
			AR11 N 0 A_StartSound("weapons/ar/chamberfwd",2);
			ARZS HIJ 1;
			TNT1 A 0 A_ZoomFactor(1.4);
			ARZR STUBA 1;
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