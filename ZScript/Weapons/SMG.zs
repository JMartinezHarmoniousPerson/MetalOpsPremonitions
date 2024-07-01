//Assault Rifle

Class SMGBurstMode : MO_ZSToken{}

Class SMGBurstCounter : Inventory {Default{Inventory.MaxAmount 5;}}

Class MO_SubMachineGun : JMWeapon
{
    Default
    {
        Weapon.AmmoGive 40;
        Weapon.AmmoType1 "LowCalclip";
        Weapon.AmmoType2 "SMGAmmo";
        Inventory.PickupMessage "You got the Sub Machine Gun (Slot 2)!";
        Obituary "%o was killed by %k's Sub Machine Gun.";
        Tag "Sub Machinegun";
		Inventory.PickupSound "weapons/smg/pickup";
		JMWeapon.InspectToken "NeverUsedSMG";
    }

    States
    {
		ContinueSelect:
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise();
		Goto Ready;
		
		Inspect:
			TNT1 A 0 A_StartSound("weapons/smg/inspect1",0);
			SM5I ABCDEFGHI 1 JM_WeaponReady();
			SM5I KMNPRSTVW 1 JM_WeaponReady();
			SM5I WWWXYZZZ 1 JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/inspect4",0);
			SM51 ABCDEFG 1;
			TNT1 A 0 A_StartSound("weapons/smg/inspect2",6);
			SM51 HHHHHHHH 1 JM_WeaponReady();
			SM5G A 0 A_StartSound("Weapons/smg/inspect3",7);
			SM51 HHIJKLMMMMLKJI 1 JM_WeaponReady();
			SM51 IIIII 1 JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/select",0);
			SM51 NOP 1 JM_WeaponReady();
			Goto ReadyToFire;
        Spawn:
            SUBM A -1;
            STOP;
        Ready:
			TNT1 A 0 JM_CheckInspectIfDone;
		SelectAnimation:
			TNT1 A 0 A_StartSound("weapons/smg/select",0);
            SM5S ABCD 1;
        ReadyToFire:
			SMGG A 0 {if(invoker.isZoomed) {SetWeaponState("Ready2");}}
            SM5G A 1 
			{
				if(JustPressed(BT_ALTATTACK)) {SetWeaponState("AltFire");}
				A_TakeInventory("SMGBurstCounter",999);
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
            Loop;
        Select:
			TNT1 A 0;
			TNT1 A 0 {invoker.isZoomed = False;}
			SMGR A 0 A_ZoomFactor(1.0);
			Goto ClearAudioAndResetOverlays;
        Fire:
			TNT1 A 0 JM_CheckMag("SMGAmmo");
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "Fire2");
			TNT1 A 0 A_JumpIfInventory("SMGBurstMode",1,"BurstFire");
            SM5F A 1 BRIGHT {
                A_FireBullets(5.6, 0, 1, 10, "UpdatedBulletPuff",FBF_NORANDOM, 0,"MO_BulletTracer",0);
                JM_UseAmmo("SMGAmmo", 1);
                A_StartSound("weapons/smg/fire", 0);
				A_SpawnItemEx("GunSmoke",15,0,34,2,0,0);
				JM_CheckForQuadDamage();
            }
            SM5F B 1 BRIGHT 
			{
				JM_GunRecoil(-0.895, .09);
				JM_WeaponReady(WRF_NOFIRE);
				A_SpawnItemEx("PistolCasing",29, 4, 38, random(-2,2), random(3,5), random(3,5));
			}
            SM5F C 1 JM_WeaponReady(WRF_NOFIRE);
            AR1F A 0 A_JumpIf(PressingWhichInput(BT_ATTACK), "Fire");
			TNT1 A 0 JM_CheckMag("SMGAmmo");
            Goto ReadyToFire;

		Fire2:
			  SM5Z E 1 BRIGHT {
                A_FireBullets(5.6, 0, 1, 10, "UpdatedBulletPuff",FBF_NORANDOM, 0,"MO_BulletTracer",0);
                JM_UseAmmo("SMGAmmo", 1);
                A_StartSound("weapons/smg/fire", 0);
				A_SpawnItemEx("GunSmoke",15,0,34,2,0,0);
				JM_CheckForQuadDamage();
            }
            SM5Z F 1 BRIGHT 
			{
				JM_GunRecoil(-0.85, .06);
				JM_WeaponReady(WRF_NOFIRE);
				A_SpawnItemEx("PistolCasing",29, 4, 38, random(-2,2), random(3,5), random(3,5));
			}
            SM5Z G 1 JM_WeaponReady(WRF_NOFIRE);
            AR1F A 0 A_JumpIf(PressingWhichInput(BT_ATTACK), "Fire");
			TNT1 A 0 JM_CheckMag("SMGAmmo");
            Goto Ready2;
	
		AltFire:
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "UnZoom");
			TNT1 A 0 {invoker.isZoomed = true;}
			SMGR A 0 A_ZoomFactor(1.3);
			SM5Z ABC 1 JM_WeaponReady(WRF_NOFIRE);
			SM5Z D 2 JM_WeaponReady(WRF_NOFIRE);
		Ready2:
			SM5Z D 1 
			{
				JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				if(JustPressed(BT_ALTATTACK)) {SetWeaponState("UnZoom");}
			}
			Loop;

		UnZoom:
			TNT1 A 0 {invoker.isZoomed = False;}
			SMGR A 0 A_ZoomFactor(1.0);
			SM5Z CBA 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 1 JM_WeaponReady(WRF_NOFIRE);
			Goto ReadyToFire;
			
        Deselect:
			TNT1 A 0 {invoker.isZoomed = False;}
			SMGR A 0 A_ZoomFactor(1.0);
            SM5S DCBA 1;
            TNT1 A 0 A_Lower(12);
            Wait;
        
        Reload:
			TNT1 A 0 A_JumpIfInventory("SMGAmmo",40,"ReadyToFire");
			TNT1 A 0 A_JumpIfInventory("LowCalClip",1,1);
			Goto ReadyToFire;
			TNT1 AAA 0;
			TNT1 A 0 A_JumpIf(Invoker.isZoomed, "ReloadZoomed");
			TNT1 A 0 
			{
				invoker.isZoomed = false;
				A_ZoomFactor(1.0);
			}
			SMR1 AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMR1 CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 FGH 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 I 7 
			{
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
			}
			SMR2 A 0 A_JumpIf(CountInv("SMGAmmo") < 1, 2);
			SMR1 A 0;
			"####" J 1 A_StartSound("weapons/smg/magout", CHAN_AUTO);
			"####" JKLM 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 N 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_JumpIf(CountInv("SMGAmmo") >= 1, 2);
			SMR1 A 0; //A_SpawnItemEx('SMGMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			SMR1 N 5 
			 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(2);}
			}
			SMR1 OP 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMR1 QR 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 S 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 TU 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 JM_ReloadGun("SMGAmmo","LowCalClip",40,1);
	DoneReload:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 VWXYZ 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,5);
			SMR2 ABBBBBC 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SMR2 DE 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
            SMR1 DCBA 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 1;
            Goto ReadyToFire;

	ReloadZoomed:
			TNT1 AAA 0;
			TNT1 A 0 
			{
				A_ZoomFactor(1.2);
			}
			SMRZ AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMRZ CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMRZ FGG 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ G 7 
			{
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
			}
			SMRZ H 1 A_StartSound("weapons/smg/magout", CHAN_AUTO);
			SMRZ IIJJ 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ J 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_JumpIf(CountInv("SMGAmmo") >= 1, 2);
			SMR1 A 0; //A_SpawnItemEx('SMGMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			SMRZ J 4 
			 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(2);}
			}
			SMRZ IHG 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMRZ K 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMRZ LL 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ MN 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 JM_ReloadGun("SMGAmmo","LowCalClip",40,1);
	DoneReloadZoomed:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMRZ OONML 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,5);
			SMRZ KKKKKKP 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SMRZ QR 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ A 0 A_ZoomFactor(1.3);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            SMRZ S 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ A 1 A_OverlayOffset(PSP_WEAPON , 0,39); 
			SMRZ A 1 A_OverlayOffset(PSP_WEAPON ,0,35);
			SMRZ A 1 A_OverlayOffset(PSP_WEAPON ,0,32);
            Goto ReadyToFire;

	/*	ActionSpecial:
			"####" A 0 
			{
				if(CountInv("SMGBurstMode") == 1)
					{
						A_SetInventory("SMGBurstMode",0);
						A_Print("Full Auto");
					}
				else			
					{
					A_SetInventory("SMGBurstMode",1);
					A_Print("Burst Fire");
					}
			}
			SK34 ABCDEFGGG 1;// JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/modeswitch",0);
			SK34 GGG 1;
			SK34 FEDCBA 1 JM_WeaponReady();
			Goto ReadyToFire;*/

	//This will be added in a future update.
/*		Chamber:
			AR1G A 1 A_StartSound("weapons/ar/select",0);
			AR11 DEFGHIJ 1;
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			AR11 JK 1;// A_StartSound("weapons/ar/chamberbck",1);
			AR11 LMM 1;
			AR11 N 0 A_StartSound("weapons/ar/chamberfwd",2);
			AR11 NOPQQQQQ 1;
			AR11 GFED 1;
			GOTO ReloadLoop;*/
		
		FlashKick:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashKickFast");
			SK34 ABCDEFG 1;// JM_WeaponReady();
			SK34 GGFFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashKickFast:
			SK34 ABCDEF 1;// JM_WeaponReady();
			SK34 GFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKick:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashAirKickFast");
			SK34 ABCDEFG 1;// JM_WeaponReady();
			SK34 G 5;
			SK34 GGFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKickFast:
			SK34 ABCDEFG 1;// JM_WeaponReady();
			SK34 G 2;
			SK34 FEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
    }
} 

Class SMGAmmo : Ammo
{
	Default
	{
    Inventory.Amount 0;
	Inventory.MaxAmount 40;
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 40;
	Inventory.Icon "SUBMA0";
	+INVENTORY.IGNORESKILL;
	}
}