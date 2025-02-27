/*
 *      T5Cine
 *      Player-related functions
 */

#include scripts\utils;

// Ammo Regen
playerRegenAmmo()
{
    if( !level.PLAYER_AMMO ) return;

    self thread regenAmmo();
    self thread regenEquip();
}

regenAmmo()
{
    self endon( "disconnect" );
    for (;;)
    {
        self waittill( "reload" );
        wait 2;
        self giveMaxAmmo( self getCurrentWeapon() );
    }
}

regenEquip()
{
    self endon( "disconnect" );
    for (;;)
    {
        self waittill( "grenade_fire", grenade, name );
        waittillframeend;

        self setWeaponAmmoClip( name, 1 );
        self GiveMaxAmmo( name );
    }
}

// Movement Tweaks
movementTweaks()
{
    if( !level.PLAYER_MOVEMENT ) return;

    setDvar( "jump_slowdownEnable", "0" );
    self setPerk( "specialty_fallheight" );
    self setPerk( "specialty_movefaster" ); // Marathon
}