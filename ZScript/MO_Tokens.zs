Class MO_ZSToken : Inventory 
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
		-INVENTORY.INVBAR;
	}
}

Class MO_PumpShottyToken : MO_ZSToken{}

Class MO_LeverShottyToken : MO_ZSToken{}

Class MO_AssaultRifleToken : MO_ZSToken{}

Class MO_HARToken : MO_ZSToken{} 
