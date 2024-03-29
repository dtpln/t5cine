/*
 *      T5Cine
 *      Utilities
 */

#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\defaults;
// Macros
waitsec()
{ wait 1; }

waitframe()
{ wait .05; }

skipframe()
{ waittillframeend; }

//print( string ) // Removed "pront", sorry sass
//{ for ( i = 0; i < level.players.size; i++ ) player iPrintLn( string );  }

true_or_undef( cond )
{ if ( cond || !isdefined( cond ) ) return true; }

defaultcase( cond, a, b )
{ if ( cond ) return a; return b; }

//inarray( value, array, err )
//{ for ( i = 0; i < ( element in array; i++ )) { if ( element == value ) return true; } pront( err ); return false; }

bool( value )
{ if ( value ) return "ON"; return "OFF"; }


// Create thread for player spawns
create_spawn_thread( callback, args )
{
    self endon( "disconnect" );
    for(;;)
    {
        self waittill( "spawned_player" );
        if ( !isdefined( args ) ) 	
             self [[callback]]();
        else self [[callback]]( args );
    }
}


// Weapons-related functions
camo_int( int )
{
    return int( tableLookup( "mp/camoTable.csv", 1, int, 0 ) );
}

get_offhand_name( item )
{
    switch ( item )
    {
        case "flash_grenade_mp":
            return "flash";
        case "smoke_grenade_mp":
            return "smoke";
        case "flare_mp":
            return "flare";
        default:
            return item;
    }
}

// Gotta test all weapons and add them if needed
fake_killfeed_icon( weapon )
{
    switch ( weapon )
    {
        case "cheytac":
            return "intervention";
        case "m4":
            return "m4a1";
        case "masada":
            return "acr";
        default:
            return weapon;
    }
}

take_offhands_tac()
{
    tac = self getOffhandSecondaryClass();
    self takeweapon( tac );
}

take_offhands_leth()
{
    leth = self getCurrentOffhand();
    self takeWeapon( leth );
}

is_akimbo( weapon )
{
    if ( isSubStr( weapon.name, "akimbo" ) )
        return true;
    return false;
}

skip_prematch() // Works, i guess... -4g
{
    level.prematchPeriod = -1; // Fixed
}

lod_tweaks()
{
    if(!level.VISUAL_LOD) return;

    setDvar( "r_lodBiasRigid",   "-1000" );
    setDvar( "r_lodBiasSkinned", "-1000" );
}

hud_tweaks()
{
    setDvar( "sv_hostname", "^3Sass' Cinematic Mod ^7- Ported to BO1 by ^3Forgive" );
    setDvar( "g_TeamName_Allies",    "allies" );
    setDvar( "g_TeamName_Axis",      "axis" );
    setDvar( "ui_hud_hardcore", !level.VISUAL_HUD );
    setdvar( "didyouknow", "^3Sass' Cinematic Mod ^7- Ported to BO1 by ^3Forgive" );

    game["strings"]["change_class"] = undefined;
}

match_tweaks()
{
    if( level.MATCH_UNLIMITED_TIME )
        setDvar( "scr_" + level.gameType + "_timelimit", 0 );

    if( level.MATCH_UNLIMITED_SCORE ) {
        setDvar( "scr_" + level.gameType + "_scorelimit", 0 );
        setDvar( "scr_" + level.gameType + "_winlimit", 0 ); }
}

bots_tweaks() //    Useless in games that lack these dvars by default. -4g
{
        if( self is_bot_2() && level.BOT_MOVE ) {
            self freezecontrols( level.BOT_MOVE );
        }
        else self freezecontrols( false );
}

score_tweaks()
{
    maps\mp\gametypes\_rank::registerScoreInfo( "kill",  level.MATCH_KILL_SCORE );

    if ( level.MATCH_KILL_BONUS )
    {
        maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 100 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 80 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 60 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 40 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist", 20 );
		maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "dogkill", 30 );
		maps\mp\gametypes\_rank::registerScoreInfo( "dogassist", 10 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterkill", 200 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist", 50 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_75", 150 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_50", 100 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_25", 50 );
		maps\mp\gametypes\_rank::registerScoreInfo( "spyplanekill", 100 );
		maps\mp\gametypes\_rank::registerScoreInfo( "spyplaneassist", 50 );
		maps\mp\gametypes\_rank::registerScoreInfo( "rcbombdestroy", 50 );
        maps\mp\gametypes\_rank::registerScoreInfo( "challenge", 2500 );
    }
    else 
    {
		maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "dogkill", 20 );
		maps\mp\gametypes\_rank::registerScoreInfo( "dogassist", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterkill", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_75", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_50", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_25", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "spyplanekill", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "spyplaneassist", 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "rcbombdestroy", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "challenge", 0 );
    }
}

// Player & Bots manipulation
is_bot_2()
{
    if( isDefined( self ) );
    if( isPlayer( self ) );

    return ( sDefined ( self.pers["isBot"] ) && self.pers["isBot"] != 0 );
}

foreach_bot( arg, arg_two, arg_val )
{
    player = level.players;
    for( i = 0; i < player.size; i++ )
    {
        if( player[i] is_bot_2() && arg_two == 1 )
            player[i] [[arg]]( arg_val );
        else if( player[i] is_bot_2() && arg_two == 0 )
            player[i] [[arg]]();
    }
}

at_crosshair( ent )
{
    return BulletTrace( ent getTagOrigin( "tag_eye" ), anglestoforward( ent getPlayerAngles() ) * 100000, true, ent )["position"];
}

save_spawn()
{
    self.saved_origin = self.origin;
    self.saved_angles = self getPlayerAngles();
}

load_spawn()
{
    self setOrigin( self.saved_origin );
    self setPlayerAngles( self.saved_angles );
}

select_ents( ent, name, player )
{
    if ( isSubStr( ent.name, name ) || isSubStr( ent["name"], name )  || 
       ( name == "look" && inside_fov( player, ent["hitbox"], 10 ) )  || 
       ( name == "look" && inside_fov( player, ent, 10 ) )            || 
         name == "all" ) 
        return true;
    return false;
}

inside_fov( player, target, fov )
{
    normal = vectorNormalize( target.origin - player getEye() );
    forward = anglesToForward( player getPlayerAngles() );
    dot = vectorDot( forward, normal );
    return dot >= cos( fov );
}