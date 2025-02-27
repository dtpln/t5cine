/*
 *      T5Cine
 *      Default settings - "The poor man's GSH"
 */

load_defaults()
{
    // Command Settings
    level.COMMAND_PREFIX            = "mvm";    // Prefix of the commands. Can be blank ("") to disable globally.
    level.COMMAND_COLOR             = "^3";     // Q3 color code for the commands' descriptions and killfeed messages. Can be blank ("") to disable globally.
    level.HIGHLIGHT_COLOR           = "^1";     // Q3 color code for the highlighted text in the output messages.

    // Match Settings
    level.MATCH_UNLIMITED_TIME      = true;     // Unlimited time.
    level.MATCH_UNLIMITED_SCORE     = true;     // Unlimited score.
    level.MATCH_KILL_SCORE          = 5;        // Default score per kill.
    level.MATCH_KILL_BONUS          = false;    // Whether or not to give bonuses (headshot, longshot, etc.) for kills.

    // Bot Settings
    level.BOT_KILLCAMTIME           = 3;        // Total time of the killcam in seconds. (0 = instant respawn, -1 = reset killcam behavior)
    level.BOT_MOVE                  = true;     // Makes bots static.
    level.BOT_WEAPHOLD              = false;    // Makes bots hold their weapons on death by default.
    level.BOT_LATERAGDOLL           = true;     // Bot corpses will ragdoll only when the death animation has almost fully ended.
    level.BOT_SPAWNCLEAR            = false;    // Clears ALL corpses whenever a bot spawns.
    level.BOT_AUTOCLEAR             = 5;        // Time in seconds before a corpse deletes itself. 0 to disable.

    // Player Settings
    level.PLAYER_MOVEMENT           = true;     // Turn fall damage, stamina, and jump slowdown on or off.
    level.PLAYER_AMMO               = true;     // Gives you ammo and equipment upon reloading/using.
    level.PLAYER_CLASS_CHANGE       = true;     // Allows the player to always change classes on or off.

    // Visual Settings
    level.VISUAL_LOD                = true;     // Increase LOD distances. (Might cause weapon flicker on some maps)
    level.VISUAL_HUD                = true;     // When false, hides the weaponbar/scorebar/minimap.

    // Miscellaneous Settings
    level.INGAME_MUSIC              = false;    // When false, disables music in game.
    level.BOT_WARFARE               = false;    // When true, enables bot warfare. (Adding in the future)
}