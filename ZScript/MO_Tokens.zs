Class MO_ZSToken : Inventory 
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
		-INVENTORY.INVBAR;
	}
}


//-------------------------------------------------- |
//			 Weapon inspect tokens					 |
//---------------------------------------------------| 

//Slot 2
Class NeverUsedSMG : MO_ZSToken{}

//Slot 3
Class NeverUsedPSG : MO_ZSToken{}
Class NeverUsedLAS : MO_ZSToken{}

//Slot 4
//Class NeverUsedHAR : MO_ZSToken{} //Will come later

//For a future pickup system based on Castlevania: Rondo of Blood's subweapon pickup system, although the logic
//is mostly based on the Iron Snail mod.

Class MO_PumpShottyToken : MO_ZSToken{}
Class MO_LeverShottyToken : MO_ZSToken{}
Class MO_AssaultRifleToken : MO_ZSToken{}
Class MO_HARToken : MO_ZSToken{} 
