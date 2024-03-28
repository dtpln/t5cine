/*
 * 		T5Cine
 *		Entry point
 */
init()
{
    thread scripts\defaults::load_defaults();
    thread precache::common_precache();
    thread precache::custom_precache();
    thread precache::fx_precache();
    thread scripts\utils::match_tweaks();
    thread scripts\utils::lod_tweaks();
    thread scripts\utils::hud_tweaks();
    thread scripts\utils::score_tweaks();
    thread scripts\utils::bots_tweaks();

    level thread waitForHost();
}

waitForHost()
{
    level waittill( "connecting", player );
    scripts\utils::skip_prematch();
    scripts\utils::match_tweaks();
    scripts\utils::lod_tweaks();
    scripts\utils::hud_tweaks();
    scripts\utils::score_tweaks();
    scripts\utils::bots_tweaks();
    player thread scripts\commands::registerCommands();
    player thread onPlayerSpawned();
}


onPlayerSpawned()
{
    self endon( "disconnect" );

    self scripts\player::playerRegenAmmo();
    self thread scripts\utils::bots_tweaks();
    for(;;)
    {
        self waittill( "spawned_player" );
        self thread scripts\misc::class_swap();
        // Only stuff that gets reset/removed because of death goes here
        self scripts\player::movementTweaks();
        self scripts\misc::reset_models();

        if( !self.isdone ) self scripts\misc::welcome();

        if( !self.isHost ) self freezeControls( level.BOT_MOVE );
    }
}