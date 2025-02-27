/*
 *      T5Cine
 *      Utilities
 */

#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\defaults;


/// Macros
waitsec() { wait 1; }
waitframe() { wait 0.05; }
skipframe() { waittillframeend; }


// Utility Functions
true_or_undef( cond )
{
    if ( cond || !isdefined( cond ) ) return true;
}

defaultcase( cond, a, b) 
{
    if ( cond ) return a;
    return b;
}

bool( value )
{
    if ( value ) return "ON";
    return "OFF";
}


// Player Spawn Thread
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
camo_int( tracker )
{
    wait .5;
    switch ( tracker )
	{
		case "dusty":
			return 1;
		case "nevada":
			return 2;
        case "woodland":
            return 3;
        case "tiger":
            return 4;
        case "sahara":
            return 5;
        case "erdl":
            return 6;
        case "berlin":
            return 7;
        case "warsaw":
            return 8;
        case "red":
            return 9;
        case "flora":
            return 10;
        case "siberia":
            return 11;
        case "olive":
            return 12;
        case "ice":
            return 13;
        case "yukon":
            return 14;
        case "gold":
            return 15;
        default:
			return 0;
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


// Match Tweaks
skip_prematch()
{
    level.prematchPeriod = -1; // Fixed
}

lod_tweaks()
{
    if( !level.VISUAL_LOD ) return;

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
    if( !level.INGAME_MUSIC ) {
        game["music"]["spawn_allies"] = undefined; 
        game["music"]["spawn_axis"] = undefined; }
}

bots_tweaks() //    Useless in games that lack these dvars by default. -4g
{
    setDvar( "testclients_doMove",      level.BOT_MOVE );
    setDvar( "testclients_doAttack",    level.BOT_MOVE );
    setDvar( "testclients_doReload",    level.BOT_MOVE );
    setDvar( "testclients_watchKillcam", 1 );
    if( ( !self.isHost ) && level.BOT_MOVE ) {
        self freezecontrols( level.BOT_MOVE );
    }
    else self freezecontrols( false );
}

score_tweaks()
{
    level thread maps\mp\gametypes\_rank::registerScoreInfo( "kill",  level.MATCH_KILL_SCORE );

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
is_bot2()
{
    if (isdefined(self.pers["isBot"]) && self.pers["isBot"])
    {
        return true;
    }
    return false;
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
    self freezeControls ( level.BOT_MOVE );
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