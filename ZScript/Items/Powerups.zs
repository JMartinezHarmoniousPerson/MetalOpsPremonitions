mixin class PowerUpExpiringBase
{
	const playTimer = 105;
	int ExpireSoundTics;
}

mixin class MO_PowerUpWarning
{
	void PowerWarning(name pwrname, string b4pwrname, string expiresnd, string blend, string txtcolor, string wearmsg = "is wearing off")
	{
		string str = b4pwrname.." \c"..txtcolor..pwrname.."\c- "..wearmsg;
		if (Owner && EffectTics > 0 && EffectTics == ExpireSoundTics || EffectTics == 70 || EffectTics == 35)
		{
			Owner.A_StartSound(expiresnd, 40, CHANF_OVERLAP, 1.0, ATTN_NONE);
			Owner.A_Print(str, 1);
			Owner.A_SetBlend(blend, .3, 8);
		}
	}
}

class MO_BackPack : BackPack replaces Backpack
{
	Default
	{
	Inventory.PickupSound "misc/backpack";
	Inventory.PickupMessage "You got a backpack to store more ammo!";
	Height 26;
	}
	States
	{
		Spawn:
		BPAK A -1;
		Stop;
	}
}

class MO_AllMap : AllMap replaces AllMap
{
	Default
	{
		+COUNTITEM
		+INVENTORY.FANCYPICKUPSOUND
		+INVENTORY.ALWAYSPICKUP
		Inventory.MaxAmount 0;
		Inventory.PickupSound "misc/map";
		Inventory.PickupMessage "$GOTMAP"; // "Computer Area Map"
	}
	States
	{
	Spawn:
		PMAP ABCDCB 6 Bright;
		Loop;
	}
}

Class MO_Goggles : Infrared replaces Infrared
{
	Default
   {
	  +COUNTITEM;
	  +INVENTORY.AUTOACTIVATE;
	  +INVENTORY.ALWAYSPICKUP;
	  Inventory.MaxAmount 0;
	  Powerup.Type "MO_NightVision";
	  Inventory.PickupMessage "Tactical Night Vision Goggles";
	  inventory.pickupsound "misc/goggles";
	  Inventory.AltHudIcon "PVISA0";
  }
  States
  {
  Spawn:
    PVIS A 6 Bright;
    PVIS B 6;
    Loop;
  }
}

Class MO_NightVision : PowerLightAmp
{
	mixin PowerUpExpiringBase;
	mixin MO_PowerUpWarning;
	
	override void DoEffect ()
    {
		if(!owner) return;
        Super.DoEffect();
		
		ExpireSoundTics = playTimer;
		PowerWarning("Night Vision Goggles'", "The", "misc/goggleswarn", "00 aa 00", "d", "battery is running low");
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		Owner.A_StartSound("misc/gogglesend", 41);
		Owner.A_StopSound(40);
	}
		
	Default
	{
		Inventory.AltHudIcon "PVISA0";
		+INVENTORY.NOSCREENBLINK;
	}
}

//In the future I'm going try to remove the leaky suit feature
Class MO_RadSuit : RadSuit replaces Radsuit
{
  Default
  {
	  Height 46;
	  +INVENTORY.AUTOACTIVATE;
	  +INVENTORY.ALWAYSPICKUP;
	  Inventory.MaxAmount 0;
	  Inventory.PickupMessage "Radiation/Hazardous Environment Suit"; // "Radiation Shielding Suit"
	  Powerup.Type "MO_SuitPower";
	  Inventory.PickupSound "misc/suit";
	  Inventory.AltHudIcon "SUITA0";
  }
  States
  {
  Spawn:
    SUIT A -1;// Bright
    Stop;
  }
}

Class MO_SuitPower : PowerIronFeet
{
	mixin PowerUpExpiringBase;
	mixin MO_PowerUpWarning;
	
	override void DoEffect ()
    {
		if(!owner) return;
        Super.DoEffect();
		
		ExpireSoundTics = playTimer;
		PowerWarning("Hazardous Environment Suit", "The", "hazsuitwarn", "Green", "d", "is expiring");
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		Owner.A_StartSound("hazsuitended", 41);
		Owner.A_StopSound(40);
	}
	
	Default
	{
		Inventory.AltHudIcon "SUITA0";
		+INVENTORY.NOSCREENBLINK;
	}
}