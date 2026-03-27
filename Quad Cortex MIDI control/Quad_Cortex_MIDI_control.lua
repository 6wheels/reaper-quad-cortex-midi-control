-- @description Quad Cortex MIDI control
-- @author Bertrand C
-- @version 2.4.1-dev
-- @changelog
--   - Setup Wizard globally improved with steps
--   - Use of message box instead of console for setup instructions
--   - Improved error handling for missing MIDI device
--   - Better handling of default values in setup
-- @provides
--   [main] . > ../Quad_Cortex_MIDI_control.lua
--   [main] . > ../Quad_Cortex_MIDI_control_setup.lua
--   [nomain] . > ../lib.lua
-- @link GitHub Repository https://github.com/6wheels/reaper-quad-cortex-midi-control

-- Main synchronization engine

local base_path = debug.getinfo(1).source:match("@?(.*[\\/])")
local lib = dofile(base_path .. "lib.lua")

-- --- INITIALIZATION ---
reaper.ClearConsole()

lib.Log("--- Quad Cortex MIDI Control ---", 1)
lib.Log("Initializing...", 1)

if not lib.LoadSettings() then
    lib.Log("First run or missing config. Launching Setup Wizard...", 1)
    local setup_success = dofile(base_path .. "Quad_Cortex_MIDI_Control_Setup.lua")
    if not setup_success then
        lib.SetToolbarButtonState(0)
        return
    end
    lib.LoadSettings()
end

if not lib.EnsureControlTrack() then
    lib.SetToolbarButtonState(0)
    return
end

lib.Log("Hardware check: OK", 1)

local lastPlayState, lastPc, lastCc = -1, -1, -1

function MainLoop()
    local playState = reaper.GetPlayState()
    local playPos = (playState == 0) and reaper.GetCursorPosition() or reaper.GetPlayPosition()

    -- --- TRANSPORT HANDLING (Log Level 1) ---
    if playState == 1 and lastPlayState ~= 1 then
        local statusMsg = "Play"
        if lib.Config.AUTO_TUNER == "true" then
            lib.SendMidi(0xB0, 45, 0) -- Tuner OFF
            statusMsg = statusMsg .. " | Tuner: OFF"
        end
        if lib.Config.AUTO_GIGVIEW == "true" then 
            lib.SendMidi(0xB0, 46, 127) -- GigView ON
            statusMsg = statusMsg .. " | GigView: ON"
        end
        lib.Log(statusMsg, 1)
        lastPc, lastCc = -1, -1

    elseif (playState == 0 or playState == 2) and lastPlayState == 1 then
        local statusMsg = (playState == 0) and "Stop" or "Pause"
        if lib.Config.AUTO_TUNER == "true" then
            lib.SendMidi(0xB0, 45, 127) -- Tuner ON
            statusMsg = statusMsg .. " | Tuner: ON"
        end
        lib.Log(statusMsg, 1)
    end

    -- --- REGION PROCESSING ---
    local current = lib.GetProjectState(playPos)

    if current.pc and current.pc ~= lastPc then
        lib.SendMidi(0xB0, 32, 1) 
        lib.SendMidi(0xC0, current.pc, 0)
        lastPc, lastCc = current.pc, -1
        lib.Log("Preset Change -> " .. current.pc_name, 1)
    end

    if current.cc and current.cc ~= lastCc then
        lib.SendMidi(0xB0, 43, current.cc) 
        lastCc = current.cc
        lib.Log("Scene Change -> Scene " .. current.cc_name, 1)
    end
    
    lastPlayState = playState
    reaper.defer(MainLoop)
end

-- --- EXECUTION ---
lib.SetToolbarButtonState(1)
reaper.atexit(lib.HandleExit)

lib.Log("Engine has started (sending messages to track: " .. lib.Config.TRACK_NAME .. ")", 1)
lib.Log("Note: Enable 'Send clock' in MIDI Prefs for Tempo Sync.", 1)

MainLoop()