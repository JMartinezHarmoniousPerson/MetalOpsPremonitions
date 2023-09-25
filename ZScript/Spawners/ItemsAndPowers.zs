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