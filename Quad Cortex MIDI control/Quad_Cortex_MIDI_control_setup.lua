-- @description Setup Wizard for Quad Cortex MIDI Control
-- @author Bertrand C
-- @version 2.0-dev
-- @noindex

local base_path = debug.getinfo(1).source:match("@?(.*[\\/])")
local lib = dofile(base_path .. "lib.lua")

function RunSetupWizard()
    lib.LoadSettings()
    local s = lib.Config

    -- extrawidth=200 for better readability the dedicated track name that can be quite long
    local captions = "extrawidth=200,MIDI Channel (1-16),Hardware MIDI Out ID,Dedicated Track Name,Preset Prefix,Scene Prefix,Tuner on Stop? (y/n),GigView on Play? (y/n),Log Level (0-2)"
    
    local csv = string.format("%s,%s,%s,%s,%s,%s,%s,%s", 
        s.MIDI_CHANNEL, s.MIDI_OUTPUT_ID, s.TRACK_NAME, s.PRESET_PREFIX, s.SCENE_PREFIX,
        (s.AUTO_TUNER == "true" and "y" or "n"), (s.AUTO_GIGVIEW == "true" and "y" or "n"), s.LOG_LEVEL)

    local retval, user_input = reaper.GetUserInputs("Quad Cortex Setup", 8, captions, csv)
    
    if retval then
        local ch, id, name, p_pre, p_sce, tuner, gig, log = user_input:match("([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*)")
        
        local updated = {
            MIDI_CHANNEL   = ch,
            MIDI_OUTPUT_ID = id,
            TRACK_NAME     = name:match("^%s*(.-)%s*$"), 
            PRESET_PREFIX  = p_pre,
            SCENE_PREFIX   = p_sce,
            AUTO_TUNER     = (tuner:lower():find("y") or tuner:lower() == "true") and "true" or "false",
            AUTO_GIGVIEW   = (gig:lower():find("y") or gig:lower() == "true") and "true" or "false",
            LOG_LEVEL      = log
        }
        
        lib.SaveSettings(updated)
        return true
    end
    return false
end

return RunSetupWizard()