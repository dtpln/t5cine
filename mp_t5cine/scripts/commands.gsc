/*
 *      T5Cine
 *      Commands handler
 */

#include scripts\utils;


registerCommands()
{
    level endon( "disconnect" );

    // Misc
    self thread createCommand( "clone",         "Create a clone of yourself",           " ",                            scripts\misc::clone, 0 );
    self thread createCommand( "drop",          "Drop your current weapon",             " ",                            scripts\misc::drop, 0 );
    self thread createCommand( "about",         "About the mod",                        " ",                            scripts\misc::about, 0 );
    self thread createCommand( "clearbodies",   "Remove all player/bot corpses",        " ",                            scripts\misc::clear_bodies, 0 );
    self thread createCommand( "viewhands",     "Change your viewmodel",                " <model_name>",                scripts\misc::viewhands, 0 );
    self thread createCommand( "eb_explosive",  "Explosion radius on bullet impact",    " <radius>",                    scripts\misc::expl_bullets, 0 );
    self thread createCommand( "eb_magic",      "Kill bots within defined FOV value",   " <degrees>",                   scripts\misc::magc_bullets, 0 );

    self thread createCommand( "spawn_model",   "Spawn model at your position",         " <model_name>",                            scripts\misc::spawn_model );
    self thread createCommand( "spawn_fx",      "Spawn FX at your xhair",               " <fx_name>",                               scripts\misc::spawn_fx, 1 );
    self thread createCommand( "vision",        "Change vision, reset on death",        " <vision>",                                scripts\misc::change_vision, 1 );
    self thread createCommand( "fog",           "Change ambient fog",                   " <start> <half> <r> <g> <b> <a> <time>",   scripts\misc::change_fog, 1 );

    // Bots
    self thread createCommand( "bot_spawn",     "Add a bot",                            " <weapon_mp> <axis/allies>",               scripts\bots::add, 1);
    self thread createCommand( "bot_move",      "Move bot to xhair",                    " <bot_name>",                              scripts\bots::move, 1 );
    self thread createCommand( "bot_aim",       "Make bot look at closest enemy",       " <bot_name>",                              scripts\bots::aim, 1 );
    self thread createCommand( "bot_stare",     "Make bot stare at closest enemy",      " <bot_name>",                              scripts\bots::stare, 1 );
    self thread createCommand( "bot_model",     "Swap bot model",                       " <bot_name> <model> <axis/allies>",        scripts\bots::model, 1 );
    self thread createCommand( "bot_kill",      "Kill bot",                             " <bot_name> <body/head/cash>",             scripts\bots::kill, 1 );
    self thread createCommand( "bot_holdgun",   "Toggle bots holding guns when dying",  " ",                                        scripts\misc::toggle_holding, 1 );
    self thread createCommand( "bot_freeze",    "(Un)freeze bots",                      " ",                                        scripts\misc::toggle_freeze, 1 );

    self thread createCommand( "bot_weapon",    "Give a bot a weapon",                  " <bot_name> <weapon_name> <camo>",         scripts\bots::weapon, 1);
}

createCommand( command, desc, usage, callback, use_prefix )
{
    self endon( "disconnect" );

    prefix = "";
    if( ( use_prefix ) == 1 )
    {
        prefix = level.COMMAND_PREFIX + "_";
        setDvar( prefix + command, desc );
    }
    else    setDvar( command, desc );

    for (;;)
    {
        if( ( use_prefix ) == 1 )
        {
            while( getdvar( prefix + command ) == desc )
            wait .05;

                args = StrTok( getDvar( prefix + command ), " " );
                if ( args.size >= 1 )   self [[callback]]( args );
                else                    self [[callback]]();
        }
        else
        {
            while( getdvar( command ) == desc )
            wait .05;

                args = StrTok( getDvar( command ), " " );
                if ( args.size >= 1 )   self [[callback]]( args );
                else                    self [[callback]]();         
        }

        if( ( use_prefix ) == 1 )
        {
            prefix = level.COMMAND_PREFIX + "_";
            setDvar( prefix + command, desc );
        }
        else
            setDvar( command, desc );

        wait 0.05;
    }

}