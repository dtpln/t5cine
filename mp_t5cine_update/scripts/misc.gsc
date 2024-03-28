/*
 *      T5Cine
 *      Miscellaneous functions
 */
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\utils;
#include maps\mp\gametypes\_class;

clone()
{
    self ClonePlayer(1);
}

drop()
{
    self dropItem( self getCurrentWeapon() );
}

class_swap()
{
    self endon( "disconnect" );

    old_class = self.pers["class"];
    for(;;)
    {
        if( self.pers["class"] != old_class )
        {
            self maps\mp\gametypes\_class::giveloadout( self.pers["team"], self.pers["class"] );
            self scripts\player::movementTweaks();
            self scripts\misc::reset_models();
            old_class = self.pers["class"];
        }
        waitframe();
    }
}

// As for as equipment goes, going from a lethal that doesn't depend --
// -- on scripts to one that does will not work. (e.g TK to Claymore)
// Not gonna bother because I highly doubt anybody does that anyway.
give( args )
{
    weapon  = args[0];
    camo    = defaultcase( isDefined( args[1] ), args[1], 0 );

    {
        self dropItem( self getCurrentWeapon() );
        skipframe();

        self giveWeapon( weapon, camo_int( camo ), is_akimbo( weapon ) );

        self switchToWeapon( weapon );
    }
}

clear_bodies()
{
    for ( i = 0; i < 15; i++ )
    {
        clone = self ClonePlayer(1);
        clone delete();
        skipframe();
    }
}

expl_bullets()
{
    for(;;)
    {
        self waittill( "weapon_fired" );
        if( GetDvarInt("eb_explosive") > 0 ) RadiusDamage( at_crosshair( self ), GetDvarInt("eb_explosive"), 800, 800, self );
    }
}

magc_bullets()
{
    for(;;)
    {
        self waittill( "weapon_fired" );
        for ( i = 0; i < level.players.size; i++ )
        {
            player = level.players[i];
            if ( inside_fov( self, player, GetDvarInt("eb_magic") ) && player != self )
                player thread [[level.callbackPlayerDamage]]( self, self, self.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0, 0, 0), (0, 0, 0), "torso_upper", 0 );
        }
    }
}

viewhands( args )
{
    self iPrintLn( "[" + level.HIGHLIGHT_COLOR + "T5Cine^7]Setting viewmodel to " + args[0] );
    self setViewmodel( args[0] );
    self.pers["viewmodel"] = args[0];
}

reset_models()
{
    if( isdefined ( self.pers["fakeModel"] ) && self.pers["fakeModel"] != false ) {
        skipframe();
        self detachAll();
        self [[game[self.pers["fakeTeam"] + "_model"][self.pers["fakeModel"]]]]();
    }

    if( isdefined ( self.pers["viewmodel"] ) )
        self setViewmodel( self.pers["viewmodel"] );
}

// Toggles
toggle_holding() //     Gotta do sum with this at some point. -4g
{
    level.BOT_WEAPHOLD ^= 1;
    self iPrintLn( "[" + level.HIGHLIGHT_COLOR + "T5Cine^7]Holding weapons on death: " + bool(level.BOT_WEAPHOLD) );

    if( !level.BOT_WEAPHOLD ) 
    {
        for ( i = 0; i < level.players.size; i++ )
        {
            player = level.players[i];
            player.replica delete();
        }
    }
}

toggle_freeze( args )
{
    level.BOT_MOVE ^= 1;
    level thread scripts\utils::bots_tweaks();
    self iPrintLn( "[" + level.HIGHLIGHT_COLOR + "T5Cine^7] Frozen bots: " + level.COMMAND_COLOR + bool(level.BOT_MOVE) );

}


// Spawners
spawn_model( args ) // Kinda useless, but decided to keep in. Spawn some trees or something. -4g
{
    model = args[0];
    prop = spawn( "script_model", self.origin );
    prop.angles = ( 0, self.angles[1], 0);
    prop setModel( model );

    self iPrintLn( "[" + level.HIGHLIGHT_COLOR + "T5Cine^7]Spawned model " + model );
}

spawn_fx( args )
{
    fx = args[0];
    level._effect[fx] = loadfx( fx );
    playFX( level._effect[fx], at_crosshair( self ) );
}

// Fog and Vision
change_vision( args )
{
    vision = args[0];
    VisionSetNaked( vision );
    self iPrintLn( "[" + level.HIGHLIGHT_COLOR + "T5Cine^7]Vision changed to : " + vision);
}

change_fog( args ) // Currently broken. Works, but cant change to another once one is set. -4g
{
    start       = int(args[0]);
    end         = int(args[1]);
    red         = int(args[2]);
    green       = int(args[3]);
    blue        = int(args[4]);
    transition  = int(args[5]);
    //SetExpFog( <startDist>, <halfwayDist>, <red>, <green>, <blue>, <transition time> );
    setExpFog(start, end, red, green, blue, transition);
    wait 0.5;
}

// Text and Messages
welcome()
{
    //self freezeControls( false );
	self iPrintLn(" Welcome to ^3Sass' Cinematic Mod" );
    self iPrintLn(" Ported to BO1 by ^3Forgive" );
	self iPrintLn(" Type ^3/about 1 ^7for more info" );
    self.isdone = true;
}

about()
{
    lastWeapon = self getCurrentWeapon();
    self giveWeapon( "briefcase_bomb_defuse_mp" );
	self SwitchToWeapon( "briefcase_bomb_defuse_mp" );
    while( self getCurrentWeapon() != "briefcase_bomb_defuse_mp" )
        waitframe();

    wait 0.55;

    VisionSetNaked( "mpintro", 0.4 );

    text = [];
    text[0] = elem( -50, 2, "qerFont",     "^3Sass' Cinematic Mod", 15 );
    text[1] = elem( -33, 1,   "qerFont",    "Ported to BO1 by ^3Forgive", 15 );
    text[2] = elem( -9,  1, "qerFont",      "^3Immensely and forever thankful for :", 15 );
    text[3] = elem( 7.5, 1, "qerFont",    "Sass, Expert, Yoyo1love, Antiga", 15 );
    text[4] = elem( 170, 1, "smallDevFont", "Press ^3[{weapnext}]^7 to close", 15 );

    self waittill( "weapon_change" );
    for( i=0; i<text.size; i++ )
        text[i] destroy();
    self switchToWeapon( lastWeapon );
    VisionSetNaked( getDvar( "mapname" ), 0.5 );

    waitsec();
    self takeWeapon( "briefcase_bomb_defuse_mp" );
    
}

elem( offset, size, font, text, pulse )
{
    elem = newClientHudElem( self );
    elem.horzAlign = "center";
    elem.vertAlign = "middle";
    elem.alignX = "center";
    elem.alignY = "middle";
    elem.y = offset;
    elem.font = font;
    elem.fontscale = size;
    elem.alpha = 1;
    elem.color = (1,1,1);
    elem setText( text );
    elem SetPulseFX( pulse, 900000000, 9000 );
    return elem;
}