// Flashlight++ - https://forum.zdoom.org/viewtopic.php?t=75585

// Gives the player the flashlight holder item on game startup and handles the button presses
class FPP_Handler : StaticEventHandler 
{
	FPP_Holder setupFlashlightHolder( PlayerPawn p )
	{
		FPP_Holder holder = FPP_Holder( p.GiveInventoryType( "FPP_Holder" ) );
		holder.Init();
		return holder;
	}
	
	override void WorldLoaded( WorldEvent e )
    {
		if( e.IsReopen )
		{
			FPP_Light hl = null;
			for( let it = ThinkerIterator.Create( "FPP_Light" ); hl = FPP_Light( it.next() ); )
			{
				hl.destroy();
				//prevents duplicate flashlights for hub-world maps
			}
		}
		for( int i = 0; i < MAXPLAYERS; i++ )
		{
			if( playeringame[ i ] )
			{
				PlayerPawn p = players[ i ].mo;
				
				FPP_Holder holder = FPP_Holder( p.FindInventory( "FPP_Holder" ) );
				if( holder )
				{
					holder.FixState();
				}
			}
		}
		
		FPP_Holder holder = null;
		for( let it = ThinkerIterator.Create( "FPP_Holder" ); holder = FPP_Holder( it.next() ); )
		{
			holder.FixState();
		}
	}
	
	override void PlayerDisconnected( PlayerEvent e )
	{ 
	//reset state on player disconnect
		FPP_Light hl = null;
		for( let it = ThinkerIterator.Create( "FPP_Light" ); hl = FPP_Light( it.next() ); )
		{
			hl.destroy();
		}
		
		FPP_Holder holder = null;
		for( let it = ThinkerIterator.Create( "FPP_Holder" ); holder = FPP_Holder( it.next() ); )
		{
			if( holder.owner && !playeringame[ holder.owner.PlayerNumber() ] )
				continue;
				
			holder.FixState();
		}
	}
	
	override void NetworkProcess( ConsoleEvent e )
	{
		if( e.name == "flashlight_plus_toggle" )
		{
			PlayerPawn p = players[ e.player ].mo;
			if( p )
            {
				FPP_Holder holder = FPP_Holder( p.FindInventory( "FPP_Holder" ) );
				if( !holder )
				{
					holder = setupFlashlightHolder( p );
				}
				holder.ToggleFlashlight();
			}
		}
		else if( e.name == "flashlight_plus_uninstall" )
		{
			PlayerPawn p = null;
			for( let it = ThinkerIterator.Create( "PlayerPawn" ); p = PlayerPawn( it.next() ); )
			{
				FPP_Holder holder = FPP_Holder( p.FindInventory( "FPP_Holder" ) );
				if( holder )
				{
					p.RemoveInventory( holder );
					holder.destroy();
				}
			}
			
			FPP_Light hl = null;
			for( let it = ThinkerIterator.Create( "FPP_Light" ); hl = FPP_Light( it.next() ); )
			{
				hl.destroy();
			}
		}
	}
}
