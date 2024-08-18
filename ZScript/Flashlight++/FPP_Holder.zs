// Flashlight++ - https://forum.zdoom.org/viewtopic.php?t=75585

// Handles turning the flashlight on and off and any other effects that might run while the player has a flashlight item in their inventory
class FPP_Holder : Inventory 
{
	FPP_Light light1;
	FPP_Light light2;
	bool on;
	bool ifInertia;
	
    enum EOnOffSound
	{
	    NOCLICK = -1,
	    DEFAULTCLICK = 0,
		OLDBOOP = 1,
		ALTCLICK = 2,
		SELACLICK = 3,
		HL1TOGGLE = 4,
		DDZTOGGLE = 5,
		OP4THING = 6, //What the fuck do i call this?
		PREYLIGHTER = 7,
        SEL2CLICK = 8,
        LITCLICK = 9,
        BDCLICK = 10
	};
	
	void Enable()
	{
		PlayerPawn pp = PlayerPawn( owner );
		if( pp )
		{
			if( light1 )
			{
				light1.destroy();
			}
			light1 = FPP_Light( owner.Spawn( "FPP_Light" ) ).Init( pp, false );
			
			if( CVar.GetCVar( "cl_flashlight_plus_second_beam", owner.player ).GetBool() )
			{
				if( light2 )
				{
					light2.destroy();
				}
				light2=FPP_Light( owner.Spawn( "FPP_Light" ) ).Init( pp, true );
    		}
		}
		on = true;
	}
	
	void Disable()
	{
		if( light1 )
		{
			light1.destroy();
			light1 = null;
		}
		if( light2 )
		{
			light2.destroy();
			light2 = null;
		}
		on = false;
	}
	
	FPP_Holder Init()
	{
		light1 = null;
		light2 = null;
		on = false;
		return self;
	}
	
    void PlayFlashlightToggleSound( bool toggleOn )
	{
		sound flon, floff;
		int scvar = CVar.GetCVar( "cl_fpp_sound", owner.player ).GetInt();
		
		if( scvar == NOCLICK )
			return;
		
		switch( scvar )
		{
			case DEFAULTCLICK:
				flon = "flashlightOn"; 
				floff = "flashlightOff"; 
				break;
				
			case ALTCLICK:
				flon = "altflashlightOn"; 
				floff = "altflashlightOff"; 
				break;
				
			case OLDBOOP:
				flon = "oldflashlightOn"; 
				floff = "oldflashlightOff"; 
				break; 
				
			case SELACLICK:
				flon = "selacoflashlightOn"; 
				floff = "selacoflashlightOff"; 
				break;
				
			case HL1TOGGLE:
				flon = "hl1flashlightToggle"; 
				floff = flon; 
				break;
				
			case DDZTOGGLE:
				flon = "darkdoomzflashlightToggle"; 
				floff = flon; 
				break;
				
			case OP4THING:
				flon = "op4flashlightOn"; 
				floff = "op4flashlightOff"; 
				break;
				
			case PREYLIGHTER:
				flon = "preyflashlightOn"; 
				floff = "preyflashlightOff"; 
				break;
				
			case SEL2CLICK:
				flon = "selaco2flashlightOn"; 
				floff = "selaco2flashlightOff"; 
				break;
				
			case LITCLICK:
				flon = "litdoomflashlightOn"; 
				floff = "litdoomflashlightOff"; 
				break;
				
			case BDCLICK:
				flon = "brutaldoomflashlightOn"; 
				floff = "brutaldoomflashlightOff"; 
				break;
		}
    		
		if( toggleOn ) 
			owner.A_StartSound( flon, CHAN_AUTO );
		else 
			owner.A_StartSound( floff, CHAN_AUTO );
	}
	
	void ToggleFlashlight()
	{
		if( on )
		{
			Disable();
			PlayFlashlightToggleSound( false );
			return;
		}
		Enable();
		PlayFlashlightToggleSound( true );
	}
	
	void FixState()
	{
		if( !owner )
		{
			destroy();
		}
		else
		{
			if( on )
				Enable();
			else
				Disable();
		}
	}
}