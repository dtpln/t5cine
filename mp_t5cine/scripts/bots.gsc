/*
 *      T5Cine
 *      Bots functions
 */

#include common_scripts\utility;
#include scripts\utils;
#include maps\mp\_utility;
#include maps\mp\gametypes\_class;

// Add a bot
add( args )
{
    weapon = args[0];
    team = args[2];
    camo = args[1];

    ent = addtestclient();
    ent persistence();
    ent thread spawnme( self, weapon, team, camo );

    create_kill_params();
}

// Set bot persistence
persistence()
{
    self.pers["isBot"]      = true;     // is bot
    self.pers["isStaring"]  = false;    // is in "staring mode"
    self.pers["fakeModel"]  = false;    // has the bot's model been changed?
}

// Spawn a bot
spawnme( owner, weapon, team, camo )
{
    while ( !isdefined( self.pers["team"] ) ) skipframe();

    if ( ( team == "allies" || team == "axis" ) && isdefined( team ) )
        self notify( "menuresponse", game["menu_team"], team );
    else if ( !isdefined( team ) )
        self notify( "menuresponse", game["menu_team"], level.otherTeam[level.players[0].team] ); // level.players[0] might fuck up in round-based modes, I'll see
    else
        self notify( "menuresponse", game["menu_team"], level.otherTeam[level.players[0].team] );

    skipframe();

    // Had to use the method I used in T4 to set custom bot models upon conception. -4g
    if ( camo == "smg" )
		self notify( "menuresponse", "changeclass", "smg_mp" );
	else if ( camo == "cqb" )
		self notify( "menuresponse", "changeclass", "cqb_mp" );
	else if ( camo == "assault" )
		self notify( "menuresponse", "changeclass", "assault_mp" );
	else if ( camo == "lmg" )
		self notify( "menuresponse", "changeclass", "lmg_mp" );
	else if ( camo == "sniper" )
		self notify( "menuresponse", "changeclass", "sniper_mp" );
	else {
		self notify( "menuresponse", "changeclass", "assault_mp" );
		owner iPrintLn( "[^3WARNING^7] ^8'"+ camo +"' ^7isn't a valid class. Random class given." ); }
    loadout = create_loadout( weapon );
    self thread create_spawn_thread( scripts\bots::give_loadout_on_spawn, loadout );
    self thread create_spawn_thread( scripts\bots::attach_weapons, loadout );

    self waittill( "spawned_player" );
    while( isdefined( level.matchcountdowntime ) )
            wait 1;
    self setOrigin( at_crosshair( owner ) );
    self setPlayerAngles( owner.angles + ( 0, 180, 0 ) );

    self save_spawn();
    self thread create_spawn_thread( scripts\utils::load_spawn );
    self thread create_spawn_thread( scripts\misc::reset_models );
    self scripts\player::playerRegenAmmo();

    if( level.BOT_SPAWNCLEAR )
        self thread create_spawn_thread( scripts\misc::clear_bodies );
    
    self freezeControls( level.BOT_MOVE );

    self clearPerks();
    self unsetPerk( "specialty_pistoldeath" );
    self unsetPerk( "specialty_finalstand" );
}

// Move a bot
move( args )
{
    name = args[0];
    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];  //  this line fixes all if ( select_ents lines, but throws an error.
                                    //  probably a better way of doing this... -4g
        if ( select_ents( player, name, self ) ) {
            player setOrigin( at_crosshair( self ) );
            player save_spawn();
        }
    }
}

// Make a bot aim
aim( args )
{
    name = args[0];
    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];
        if ( select_ents( player, name, self ) ) 
        {
            player thread doaim();
            wait 0.5;
            player notify( "stopaim" );
        }
    }
}

// Make a bot stare
stare( args )
{
    name = args[0];
    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];
        if ( select_ents( player, name, self ) ) 
        {
            player.pers["isStaring"] ^= 1;
            if ( player.pers["isStaring"] ) player thread doaim();
            else                            player notify( "stopaim" );
        }
    }
}

// Change bot model
model( args )
{
    name  = args[0];
    model = args[1];
    team  = args[2]; // <allies, axis >
    {
        for ( i = 0; i < level.players.size; i++ )
        {
            player = level.players[i];
            if ( select_ents( player, name, self ) ) 
            {
                oldWeap = player getCurrentWeapon();
                if ( model == "smg" )
	            	player notify( "menuresponse", "changeclass", "smg_mp" );
	            else if ( model == "cqb" )
	            	player notify( "menuresponse", "changeclass", "cqb_mp" );
	            else if ( model == "assault" )
	            	player notify( "menuresponse", "changeclass", "assault_mp" );
	            else if ( model == "lmg" )
	            	player notify( "menuresponse", "changeclass", "lmg_mp" );
	            else if ( model == "sniper" )
	            	player notify( "menuresponse", "changeclass", "sniper_mp" );
	            else {
	            	player notify( "menuresponse", "changeclass", "assault_mp" );
	            	self iPrintLn( "[^3WARNING^7] ^8'"+ model +"' ^7isn't a valid class. Random class given." ); }
                waitframe();
                player takeAllWeapons();
                wait .5;
                player giveWeapon( oldWeap ); player setSpawnWeapon( oldWeap ); player switchToWeapon( oldWeap );
                wait .5;
                newerWeap = player getCurrentWeapon(); 
                player takeWeapon( newerWeap ); player switchToWeapon( oldWeap );
                if( isdefined ( player.pers["viewmodel"] ) )
                    player setViewmodel( player.pers["viewmodel"] );
            }
        }
    } 
}

// Bot aiming logic
doaim()
{
    self endon( "disconnect" );
    self endon( "stopaim" );

    for (;;)
    {
        wait .05;
        target = undefined;

        for ( i = 0; i < level.players.size; i++ )
        {
            player = level.players[i];
            if ( ( player == self ) || ( level.teamBased && self.pers["team"] == player.pers["team"] ) || ( !isAlive( player) ) )
                continue;

            if ( isDefined( target ) ) {
                if ( closer ( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), target getTagOrigin( "j_head" ) ) )
                    target = player;
            }
            else target = player;
        }

        if ( isDefined( target ) )
            self setPlayerAngles( VectorToAngles( ( target getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
    }
}

// Kill a bot
kill( args )
{
    name = args[0];
    mode = args[1];
    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];
        if ( select_ents( player, name, self ) )
        {
            parameters  = strTok( level.killparams[mode], ":" );
            fx          = parameters[0];
            tag         = player getTagOrigin( parameters[1] );
            hitloc      = parameters[2];

            playFXOnTag( getFX( fx ), self, tag );
            player thread [[level.callbackPlayerDamage]]( player, player, player.health, 8, "MOD_SUICIDE", self getCurrentWeapon(), tag, tag, hitloc, 0 );
            player freezeControls( level.BOT_MOVE );
            player clearPerks();
        }
    }
}

// Delay bot spawn
delay( args )
{
    setDvar( "scr_killcam_time",      level.BOT_SPAWN_DELAY/2 );
    setDvar( "scr_killcam_posttime",  level.BOT_SPAWN_DELAY/2 );
}

// Create bot loadout
create_loadout( weapon )
{
    loadout = spawnstruct();
    loadout.primary = weapon;
    return loadout;
}

// Attach weapons to bot
attach_weapons( loadout )
{
    currentWeapon = self getCurrentWeapon();
    wait .1; // take the wait from misc\reset_models() into account
    if ( level.BOT_WEAPHOLD )
    {
        self.replica = getWeaponModel( currentWeapon );
        self attach( self.replica, "tag_weapon_right", true );
    }
}

// Change bot weapon
weapon( args )
{
    name = args[0];
    weapon = args[1];
    camo = args[2]; // Camo name, reference function camo_int.
    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];
        if ( select_ents( player, name, self ) )
        {
            currWeapon = player getCurrentWeapon();
            player takeWeapon( currWeapon );
            skipframe();
            player giveWeapon( weapon, is_akimbo( weapon ), camo_int( camo ) );
            player switchToWeapon( weapon );
            wait 1;
            player setSpawnWeapon( weapon );
            player thread attach_weapons();
        }
    }
}

// Create kill parameters
create_kill_params()
{
    level.killparams             = [];
    level.killparams["body"]     = "flesh_body:j_spine4:body";
    level.killparams["head"]     = "flesh_head:j_head:head";
    level.killparams["shotgun"]  = "flesh_body:j_knee_ri:body"; // REDO ME!!
}

// Give loadout on spawn
give_loadout_on_spawn( loadout )
{
    self takeAllWeapons();
    self giveWeapon( loadout.primary );
    self setSpawnWeapon( loadout.primary );
}