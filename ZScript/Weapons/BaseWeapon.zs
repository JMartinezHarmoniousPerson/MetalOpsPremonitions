class JMWeapon : Weapon
{
	bool isFirstTime;
	property firstTime: isFirstTime;
	bool pressedKick;
	property pressedKick: pressedKick;
	bool isHoldingAim;
//	sound dryFireSound;
//	property DryFireSound : dryFireSound;
	int adsMode;
	string inspectToken;
	property InspectToken: inspectToken;


	bool isZoomed;

	//weapons should ALWAYS bob, fucking fight me -popguy
	override void DoEffect()
	{
		super.DoEffect();
		let player = owner.player;
		adsMode =  Cvar.GetCvar("mo_aimmode",player).GetInt();
		Cvar Bobbing = Cvar.GetCvar("MTOps_AlwaysBob",player);
		if (player && player.readyweapon)
		{
			player.WeaponState |= WF_WEAPONBOBBING;
		}
	}

	bool OwnerHasSpeed()
	{
		return (owner.CountInv("MO_PowerSpeed") >= 1);
	}

	 //Credits: Matt
    action bool JustPressed(int which) // "which" being any BT_* value, mentioned above or not
    {
        return player.cmd.buttons & which && !(player.oldbuttons & which);
    }
    action bool JustReleased(int which)
    {
        return !(player.cmd.buttons & which) && player.oldbuttons & which;
    }

    //Based on IsPressingInput from Project Brutality
    action bool PressingWhichInput(int which)
    {
        return player.cmd.buttons & which;
    }
	
	action void JM_CheckForQuadDamage()
	{
		If(CheckInventory("MO_PowerQuadDmg",1))
		{
			A_StartSound("powerup/quadfiring",70, CHANF_DEFAULT,3.0,ATTN_NONE);
		}
	}

//Holy shit I can't believe I got this working
	int SetCustomXHair(int w)
	{
		static const string weaponPrefix[] =
		{
			"Pistol", "Deagle", "SMG", "LAS", "PSG", "SSG", "Rifle", "Chain", 
			"RL", "RLGuided", "Plasma", "Rail", "BFG", "MP40", "Unmaker",
			"Flamer"
		};
		string weaponCVar = "mo_xhair".. String.Format("%s", weaponPrefix[w]);
		if(owner.GetCvar("mo_customxhairs"))
		return owner.GetCvar(weaponCvar);
		else
		return 0;
	}
	
	action void JM_SetWeaponSprite(string s)
	{
		if(!player) return;
		 let psp = player.GetPSprite(PSP_WEAPON);
		 psp.sprite = GetSpriteIndex(s);
	}
	
	action bool PressingFire(){return player.cmd.buttons & BT_ATTACK;}
    action bool PressingAltfire(){return player.cmd.buttons & BT_ALTATTACK;}

	action state JM_CheckMag(name type, statelabel st = "Reload")
	{
		if(CountInv(type) <= 0)
		{
			return ResolveState(st);
		}
		return ResolveState(Null);
	}

	//Based on the Set and Check functions from Project Brutality
	action void JM_SetInspect(bool type)
	{
		invoker.isFirstTime = type;
	}
	
	action bool JM_CheckInspect()
	{
		return invoker.isFirstTime;
	}

	action void JM_CheckInspectIfDone()
	{
			Actor theOwner = invoker.owner;
			let wep = player.readyweapon;
			bool notInspected = invoker.inspectToken != "" && theOwner.CountInv(invoker.inspectToken);
			if(notInspected)
			{
				theOwner.TakeInventory(invoker.inspectToken,1);
				theOwner.player.SetPSprite(PSP_WEAPON,wep.FindState("Inspect"));
			}
	}
				
	//By Matt. Perfect to go around the Return state/ResolveState headache
	action void SetWeaponState(statelabel st,int layer=PSP_WEAPON)
    {
        if(player) player.setpsprite(layer,invoker.findstate(st));
    }
// Don't complain if this is an action state rather than an action void
// I found it easier an action state in terms of returning to state labels.
	action state JM_WeaponReady(int wpflags = 0)
	{	
		A_WeaponReady(wpflags);
		if(player.cmd.buttons & BT_USER1)
		{
			if(CheckIfInReady())
			return ResolveState("TossThrowable");
		}
		if(JustPressed(BT_USER4))
		{
			State ActionSpecial = invoker.owner.player.ReadyWeapon.FindState("ActionSpecial");
			if(ActionSpecial != NULL && CheckIfInReady())
				return ResolveState('ActionSpecial');
			else	
			return null;		
		}	
		return null;
	}
	
	action void JM_PressedKick (bool type)
	{
		invoker.pressedKick = type;
	}
	
	action bool JM_CheckIfKicked()
	{
		return invoker.pressedKick;
	}
	
	action bool CheckIfInReady()
	{
		if ( (InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("Ready")) || 
			  InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ReadyToFire"))||
			  InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ReadyToFire2"))||
			  InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ReadyLoop"))
			 ) )
		{		
			return true;
		}
		return false;
	}
	
	action void JM_ReloadGun(name magammo, name reserve, int magMax, int reserveTake)
	{
		for(int i = 0; i < magMax; i++)
		{
			if(CountInv(reserve) < 1 || CountInv(magammo) == magMax) 
			return;
			
			A_GiveInventory(magammo, 1);
			A_TakeInventory(reserve, reserveTake, TIF_NOTAKEINFINITE);
		}
	}
	
//Basically A_TakeInventory but with the TIF_NOTAKEINIFNITE Flag built in, for the ammo
	action void JM_UseAmmo(name ammotype, int count)
	{
		A_TakeInventory(ammotype, count, TIF_NOTAKEINFINITE);
	}

	action void JM_GunRecoil(float gunPitch, float gunAngle)
	{
		CVar checkRecoil = CVar.FindCVar("mo_nogunrecoil");
		bool noRecoil = checkRecoil.GetBool();
		if(!noRecoil)
		{
			A_SetPitch(pitch+gunPitch, SPF_INTERPOLATE);
			A_SetAngle(angle+gunAngle, SPF_INTERPOLATE);
		}
	}

    Default
    {
        Weapon.BobStyle "InverseSmooth";
        Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.6;
		Weapon.BobSpeed 1.5;
        +DONTGIB;
        Inventory.PickupMessage "How did you pick this up? You're not supposed to see or use this.";
    }
	
	States
	{
		
		Select:
			TNT1 A 1 A_RAISE();
			wait;
		ClearAudioAndResetOverlays:
			TNT1 A 0;
			TNT1 A 1 {
				A_StopSound(CHAN_5);
				A_StopSound(CHAN_WEAPON);
				A_StopSound(CHAN_6);
				A_STOPSOUND(CHAN_7);
				SetPlayerProperty(0,0,0);
				A_SetCrosshair(0);
				A_ClearOverlays(-8,8);
				A_OverlayFlags(-999, PSPF_PLAYERTRANSLATED, FALSE);
				JM_PressedKick(false);
				}
			TNT1 A 0 A_Jump(255, "ContinueSelect");
			Loop;
		Deselect:
			TNT1 A 1 A_Lower();
			Loop;
			
		Ready:
		FIRE:
		ReallyReady:
			"####" A 0;
			"####" A 0;
			"####" AAAA 1 A_Jump(256, "readytofire");
			Loop;
		BackToWeapon:
			TNT1 A 1 
			{
				State SelectAnim = player.readyweapon.FindState("SelectAnimation");
				if(SelectAnim != NULL)
					{return ResolveState("SelectAnimation");}
				return ResolveState(Null);
			}
			Goto ReallyReady;
			
		Kick: //16 frames
			"####" A 0 A_ZoomFactor(1.0);
			"####" A 0 A_StopSound(CHAN_VOICE);
			"####" A 0 {invoker.isZoomed = False;}
			"####" A 0 A_JumpIf (vel.Z != 0, "AirKick");
			"####" A 0;
			"####" A 0 
			{
				SetPlayerProperty(0,1,0);
				A_OverlayFlags(-999, PSPF_PLAYERTRANSLATED, TRUE);
				If(invoker.OwnerHasSpeed()) {return ResolveState("KickFaster");}
				{return ResolveState(Null);}
			}
			KCK1 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK1 DEF 1;
			KCK1 G 1
			{
				if(CountInv("PowerStrength") == 1)
				{
					if(health < 25)
					{A_CustomPunch(65 * 3, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
					else
					{A_CustomPunch(65, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
				}
				else
				{
					A_CustomPunch(30, TRUE, CPF_NOTURN, "KickingPuff", 80, 0, 0, "none", "playerkick/hit");
				}
			}
			KCK1 GHG 1;
			KCK1 FEDCBA 1;
			TNT1 A 0 A_OverlayFlags(-999,PSPF_PLAYERTRANSLATED,FALSE);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			Stop;
		
		KickFaster:
			KCK1 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK1 DF 1;
			KCK1 G 1
			{
				if(CountInv("PowerStrength") == 1)
				{
					if(health < 25)
					{A_CustomPunch(65 * 3, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
					else
					{A_CustomPunch(65, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
				}
				else
				{
					A_CustomPunch(30, TRUE, CPF_NOTURN, "KickingPuff", 80, 0, 0, "none", "playerkick/hit");
				}
			}
			KCK1 HG 1;
			KCK1 FEDCA 1;
			TNT1 A 0 A_OverlayFlags(-999,PSPF_PLAYERTRANSLATED,FALSE);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			Stop;
		AirKick: //16 frames
			"####" A 0 ThrustThing(angle * 256 / 360, 3, 0, 0);
			"####" A 0 A_OverlayFlags(-999, PSPF_PLAYERTRANSLATED, TRUE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"AirKickFaster");
			KCK2 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK2 DE 1;
			KCK2 F 1 
			{
				if(CountInv("PowerStrength") == 1)
				{
					if(health < 25)
					{A_CustomPunch(65 * 3, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
					else
					{A_CustomPunch(65, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
				}
				else
				{
					A_CustomPunch(30, TRUE, CPF_NOTURN, "KickingPuff", 80, 0, 0, "none", "playerkick/hit");
				}
			}
			KCK2 GGHHI 1;
			KCK2 JKLMN 1;
			"####" A 0 A_OverlayFlags(-999, PSPF_PLAYERTRANSLATED, false);
			Stop;
		
		AirKickFaster:
			KCK2 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK2 DE 1;
			KCK2 F 1 
			{
				if(CountInv("PowerStrength") == 1)
				{
					if(health < 25)
					{A_CustomPunch(65 * 3, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
					else
					{A_CustomPunch(65, TRUE, CPF_NOTURN, "BerserkKickPuff", 80, 0, 0, "none", "playerkick/hit");}
				}
				else
				{
					A_CustomPunch(30, TRUE, CPF_NOTURN, "KickingPuff", 80, 0, 0, "none", "playerkick/hit");
				}
			}
			KCK2 GGHI 1;
			KCK2 JKLN 1;
			"####" A 0 A_OverlayFlags(-999, PSPF_PLAYERTRANSLATED, false);
			Stop;
				
		FlashKick:
				TNT1 A 0 A_JumpIf(invoker.OwnerHasSpeed(), "FlashKickFast");
				TNT1 A 16;
				Goto ReallyReady;

		FlashKickFast:
				TNT1 A 14;
				Goto ReallyReady;
		
		//From the PB Add-on	
		TossThrowable:
			"####" "#" 0;
			"####" "#" 0 {
				if(CountInv("ThrowableType") == 1)
				{return ResolveState("ThrowMolotov");}
				else
				{return ResolveState("ThrowGrenade");}
				return resolvestate(null);
			}
			Goto Ready;
			
		ThrowMolotov:
		"####" "#" 0 A_ZoomFactor(1.0);
			"####" "#" 0 A_StopSound(6);
			"####" "#" 0 A_StopSound(CHAN_VOICE);
			"####" "#" 1 A_JumpIfInventory("MolotovAmmo", 1, 2);
			"####" "#" 0 A_Print("No Molotov Cocktails left");
			Goto ReallyReady;
			MTOV AB 1;
			TNT1 A 0 A_StartSound("Molotov/Open",0);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV CDE 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			MTOV FG 1;
			MTOV H 2 {
				A_StartSound("Molotov/Lit",1);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(1);}
			}
			MTOV I 1 A_StartSound("Molotov/Flame",0,CHANF_DEFAULT,2.0);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV JKK 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV LLM 1;
//			MOLO FG 2 A_SpawnItemEx ("FlameTrails",cos(pitch)*1,0,0-(sin(pitch))*-10,cos(pitch)*20,0,-sin(pitch)*20,0,SXF_NOCHECKPOSITION);
			MOLO A 0 A_StartSound("Molotov/Close", 5);
//			MOLO H 2 A_SpawnItemEx ("FlameTrails",cos(pitch)*1,0,0-(sin(pitch))*-10,cos(pitch)*20,0,-sin(pitch)*20,0,SXF_NOCHECKPOSITION);
			MTOV N 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			MTOV OP 1;
			TNT1 A 0;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
			TNT1 AAAA 1;
			//HND1 I 2
			TNT1 A 0 A_StartSound("MOLTHRW",0,CHANF_DEFAULT,2.0);
			MTOV QRS 1;
			MTOV A 0 
			{
				A_FireProjectile("MolotovThrown",0,0,0,0,FPF_NOAUTOAIM,0);
				A_TakeInventory("MolotovAmmo", 1, TIF_NOTAKEINFINITE);
			}
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV TUVW 1;
			TNT1 A 5
			{
//				A_StartSound("Molotov/Lit",1);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(2);}
			}
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "ThrowMolotov");
			Goto BackToWeapon;
		
		CookingGrenade:
			TNT1 A 0;
			TNT1 A 0 ACS_Execute(2098,0,0,0,0);
		CookingGrenadeHold:
			TNT1 A 1 A_GiveInventory("GrenadeCookTimer", 1);			
			TNT1 A 0 A_JumpIf(CountInv("GrenadeCookTimer") == 105, "ExplodeOnYerFace");
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "CookingGrenadeHold");
			Goto TossTheGrenade;
		
		ExplodeOnYerFace:
			TNT1 A 1
			{
					ACS_Terminate(2098,0);
					A_Explode(125, 220,XF_HURTSOURCE);
					A_AlertMonsters(200);
					A_StartSound("rocket/explosion", 6);
					A_SpawnItemEx("RocketExplosionFX",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
					A_SetInventory("GrenadeCookTimer",0);
			}
			TNT1 AAA 1;
			Goto BackToWeapon;
			
		ThrowGrenade:
			"####" "#" 0 A_ZoomFactor(1.0);
			"####" "#" 0 A_StopSound(6);
			"####" "#" 0 A_StopSound(CHAN_VOICE);
			"####" "#" 1 A_JumpIfInventory("GrenadeAmmo", 1, 2);
			"####" "#" 0 A_Print("No Frag Grenades left");
			Goto ReallyReady;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			GREP AABCD 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			GREP EFGII 1;
			TNT1 A 0 A_StartSound("FragGrenade/Pin",0);
			GREP K 1;
			TNT1 A 0 A_TakeInventory("GrenadeAmmo", 1, TIF_NOTAKEINFINITE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
			GREP LMNOPQ 1;
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "CookingGrenade");
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
//			MOLO FG 2 A_SpawnItemEx ("FlameTrails",cos(pitch)*1,0,0-(sin(pitch))*-10,cos(pitch)*20,0,-sin(pitch)*20,0,SXF_NOCHECKPOSITION);
			TNT1 AAAAA 1;
			//HND1 I 2
		TossTheGrenade:
			TNT1 A 0 ACS_Terminate(2098,0);
			GRE1 AB 1;
			TNT1 A 0 A_StartSound("FragGrenade/Throw",0,CHANF_DEFAULT,2.0);
			GRE1 C 1;
			MTOV A 0 A_FireProjectile("MO_ThrownGrenade",0,0,0,8,FPF_NOAUTOAIM,0);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			GRE1 DEFG 1;
			TNT1 A 0 A_SetInventory("GrenadeCookTimer",0);
			TNT1 A 4
			{
				A_StartSound("Molotov/Lit",1);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(2);}
			}
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "ThrowGrenade");
			Goto BackToWeapon;
		
		//Failsafe just in case there are no flash kick states
		FlashKick:
		FlashAirKick:
		FlashSlideKick:
			"####" "#" 16;
			Goto ReallyReady;
		}
}