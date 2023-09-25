class MO_KeyClass : Key
{
	Default
	{
	+DONTGIB;
	+NOTDMATCH;
	Radius 20;
	Height 16;
	Inventory.pickupsound "misc/keycard";
	Inventory.InterHubAmount 0;
	}
}

class MO_RedCard : MO_KeyClass replaces RedCard
{
	Default
	{
	Species "RedCard";
	Inventory.PickupMessage "$GOTREDCARD";
	Inventory.Icon "KEYRA0";
	}
	States
	{
		Spawn:
		KEYR A 10;
		KEYR B 10 bright;
		Loop;
	}
}

class MO_YellowCard : MO_KeyClass replaces YellowCard
{
	Default
	{
	Species "YellowCard";
	Inventory.Icon "KEYYA0";
	Inventory.PickupMessage "$GOTYELWCARD";
	}
	States
	{
		Spawn:
		KEYY A 10;
		KEYY B 10 bright;
		Loop;
	}
}

class MO_BlueCard : MO_KeyClass replaces BlueCard
{
	Default
	{
	Species "BlueCard";
	Inventory.PickupMessage "$GOTBLUECARD";
	Inventory.Icon "KEYBA0";
	}
	States
	{
		Spawn:
		KEYB A 10;
		KEYB B 10 bright;
		Loop;
	}
}

class MO_RedSkull : MO_KeyClass replaces RedSkull
{
	Default
	{
	Inventory.pickupsound "misc/skullkey";
	Inventory.PickupMessage "$GOTREDSKUL";
	Species "RedSkull";
	Inventory.Icon "SKLRA0";
	}
	States
	{
		Spawn:
		SKLR A 10;
		SKLR B 10 bright;
		Loop;
	}
}

class MO_BlueSkull : MO_KeyClass replaces BlueSkull
{
	Default
	{
	Inventory.pickupsound "misc/skullkey";
	Inventory.PickupMessage "$GOTBLUESKUL";
	Species "BlueSkull";
	Inventory.Icon "SKLBA0";
	}
	States
	{
		Spawn:
		SKLB A 10;
		SKLB B 10 bright;
		Loop;
	}
}

class MO_YellowSkull : MO_KeyClass replaces YellowSkull
{
	Default
	{
	Inventory.PickupMessage "$GOTYELWSKUL";
	Inventory.pickupsound "misc/skullkey";
	Species "YellowSkull";
	Inventory.Icon "SKLYA0";
	}
	States
	{
		Spawn:
		SKLY A 10;
		SKLY B 10 bright;
		Loop;
	}
}