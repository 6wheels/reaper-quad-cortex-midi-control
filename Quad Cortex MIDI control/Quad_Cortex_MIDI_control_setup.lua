-- @description Setup Wizard for Quad Cortex MIDI control
-- @author Bertrand C
-- @noindex

local base_path = debug.getinfo(1).source:match("@?(.*[\\/])")
local lib = dofile(base_path .. "lib.lua")

function RunSetupWizard()
    lib.LoadSettings()

    local stage = 1 
    local temp_id = lib.Config.MIDI_HARDWARE_ID

    while stage <= 2 do
        if stage == 1 then
            local midi_list = lib.GetMidiOutputsList()
            reaper.MB(midi_list, "QC MIDI Control Setup - MIDI Device List", 0)

            local ok1, user_id = reaper.GetUserInputs("QC MIDI Control Setup - Hardware Config (1/2)", 1,
                "extrawidth=100,Enter MIDI Hardware ID:", temp_id)

            if not ok1 then return false end 

            local is_ok, _ = lib.CheckMidiDevice(user_id)

            if is_ok then
                temp_id = user_id
                stage = 2 
            else
                reaper.MB("Error: MIDI Hardware ID '" .. user_id .. "' is invalid.", "Hardware Error", 0)
            end

        elseif stage == 2 then
            local step2_captions = "extrawidth=200,MIDI Channel (1-16),Dedicated Track Name,Preset Prefix (#),Scene Prefix (!S),Tuner on Stop? (y/n),GigView on Play? (y/n),Log Level (0-2)"
            local step2_defaults = string.format("%s,%s,%s,%s,%s,%s,%s",
                lib.Config.MIDI_CHANNEL, lib.Config.TRACK_NAME, lib.Config.PRESET_PREFIX,
                lib.Config.SCENE_PREFIX, (lib.Config.AUTO_TUNER == "true" and "y" or "n"),
                (lib.Config.AUTO_GIGVIEW == "true" and "y" or "n"), lib.Config.LOG_LEVEL
            )

            local ok2, user_settings = reaper.GetUserInputs("QC MIDI Control Setup - Settings (2/2)", 7, step2_captions, step2_defaults)
            
            if not ok2 then return false end 

            local s = {}
            for val in (user_settings .. ","):gmatch("(.-),") do table.insert(s, val) end
            
            if #s >= 7 then
                local updated = {
                    MIDI_HARDWARE_ID = lib.getValueOrDefault(temp_id, lib.Defaults.MIDI_HARDWARE_ID),
                    MIDI_CHANNEL     = lib.getValueOrDefault(s[1], lib.Defaults.MIDI_CHANNEL),
                    TRACK_NAME       = lib.getValueOrDefault(s[2]:match("^%s*(.-)%s*$"), lib.Defaults.TRACK_NAME),
                    PRESET_PREFIX    = lib.getValueOrDefault(s[3], lib.Defaults.PRESET_PREFIX),
                    SCENE_PREFIX     = lib.getValueOrDefault(s[4], lib.Defaults.SCENE_PREFIX),

                    AUTO_TUNER       = lib.getBoolOrDefault(s[5], lib.Defaults.AUTO_TUNER),
                    AUTO_GIGVIEW     = lib.getBoolOrDefault(s[6], lib.Defaults.AUTO_GIGVIEW),

                    LOG_LEVEL        = lib.getValueOrDefault(s[7], lib.Defaults.LOG_LEVEL)
                }
                
                local old_config = lib.Config
                lib.Config = updated
                
                if lib.EnsureControlTrack() then
                    lib.SaveSettings(updated)
                    
                    if tonumber(updated.LOG_LEVEL) == 0 then
                        reaper.MB("Setup successful!\n\nThe configuration has been saved.\n\n" ..
                            "NOTE: Log Level is set to 0 (SILENT).\nIf opened, you can now SAFELY CLOSE the 'ReaScript console output' window.\n" ..
                            "The script will keep running in the background.", "QC MIDI Control Setup - Success", 0)
                    else
                        lib.Log("The script is now monitoring your project.", 1)
                        lib.Log("Activity logs will appear here.", 1)
                    end

                    stage = 3
                else
                    lib.Config = old_config
                    reaper.MB("Could not apply track configuration.\nPlease check your settings and try again.", "Setup Error", 0)
                end
            end
        end
    end
    return true
end

return RunSetupWizard()