# Quad Cortex MIDI control for Reaper

Automate your **Neural DSP Quad Cortex** directly from the Reaper timeline.

---

## ✨ Key Features

* **Zero-Touch Setup**: Automatically creates and configures a dedicated MIDI track (Armed, Monitoring ON, Record Disabled).
* **Automatic Hardware Routing**: Assigns your MIDI interface ID directly to the track routing.
* **Intelligent Regions**: 
    * **Presets**: Switch banks and presets using `#BankLetter` (e.g., `#1A`).
    * **Scenes**: Switch scenes (A to H) using `!SA` to `!SH`.
    * **Inheritance**: Place Scene regions inside larger Preset regions for precise control.
* **Live/Studio Automation**:
    * **Play**: Forces **Gig View** ON and turns **Tuner** OFF.
    * **Stop/Pause**: Automatically activates the **Tuner** for silent breaks.
* **Smart Error Handling**: Detects if your MIDI hardware is unplugged and guides you through the fix.

---

## ⚠️ Choosing your version

### Stable Version

* **Status**: Recommended for Live/Studio
* **Source**: Search `Quad Cortex MIDI control` in ReaPack (Standard repos)

### Development Version

* **Status**: Experimental / New features
* **Source**: Add this GitHub URL to your ReaPack repositories

## Installation

### Stable Version (Easiest)
No extra steps required if you have ReaPack installed:
1. Open **Extensions > ReaPack > Browse packages**.
2. Search for `Quad Cortex MIDI control`.
3. Right-click and **Install**.

### Development Version

#### Through Reapack and GitHub
To test the latest features before they hit the stable release:
1. Copy this URL: `https://github.com/6wheels/reaper-quad-cortex-midi-control/raw/main/index.xml`
2. In Reaper: `Extensions > ReaPack > Import a repository`.
3. Paste the URL and click **OK**.
4. Install the package as usual.

#### Manually with Github
1. Download the `Quad Cortex MIDI control` folder from this repository.
2. Place it in your Reaper `Scripts` directory.
3. Load `Quad_Cortex_MIDI_Control.lua` in the Actions List.

## 🛠 Configuration (Setup Wizard)

On the first run, a **Setup Wizard** will appear. You can relaunch it at any time by running the `Quad_Cortex_MIDI_control_setup` script from your Action List.

* **MIDI Channel**: The MIDI channel your Quad Cortex is listening to (default: `1`).
* **Hardware MIDI Out ID**: The ID of your MIDI interface. A list of all available devices and their IDs is automatically displayed in the **Reaper Console** when the wizard opens.
* **Dedicated Track Name**: The name of the track the script will create and manage (default: `Quad Cortex MIDI Control`).
* **Preset Prefix**: The character used to identify Preset changes in Region names (default: `#`). 
    * *Example: `#1A`, `#12C`*
* **Scene Prefix**: The characters used to identify Scene changes in Region names (default: `!S`). 
    * *Example: `!SA` to `!SH` (matches footswitches A-H).*
* **Tuner on Stop? (y/n)**: If enabled, the QC Tuner activates when you stop playback.
* **GigView on Play? (y/n)**: If enabled, the QC forces Gig View ON when you hit play.
* **Log Level (0-2)**: 
    * `0`: Silent.
    * `1`: **[INFO]** Shows changes and transport status (Recommended).
    * `2`: **[DEBUG]** Shows full configuration and file operations.

---

## 🚀 Usage Instructions

### 1. Naming your Regions
Create regions in the timeline and name them using your prefixes:
* **To change a Preset**: Name a region `#1A` (Bank 1, Preset A).
* **To change a Scene**: Name a region `!SA` (Scene A).
* **Combined**:
  - Name the region with both preset and scene change, ex: `#1A !SA`
  - Place a small `!SB` region inside a larger `#4D` region to switch to Scene B while staying in Preset 4D.
  - Anything after preset and scene will be ignored, but it can be used to name the region as usual, ex: `#1A !SA Chorus`

### 2. Tempo Sync (BPM)
To sync your QC's delays and time-based effects to Reaper's tempo:
1. Go to `Preferences > MIDI Devices`.
2. Double-click your **MIDI Output**.
3. Check **"Send clock to this device"**.
4. The script's dedicated track will automatically relay this clock to your hardware.

*Note: If regions overlap, the shortest Region takes priority for Scene changes (ideal for nested scenes within a preset).*

### 💡 Pro Tip: Visual Organization (REAPER 7+)

REAPER 7 allows you to display multiple **Region Lanes**. This is highly recommended for this script to keep your timeline clean:

1. Right-click the **Region/Marker area** at the top of the timeline.
2. Select **Lanes > Display multiple lanes**.
3. You can now drag your **Scene regions (!S)** to a different lane than your **Preset regions (#)**.

This makes it much easier to see which Scene is active within a larger Preset region at a glance.

---

## 🔍 Troubleshooting

* **Hardware Error**: If your MIDI interface is unplugged, the script will stop and show an error message. Check the Console to see currently available IDs and update your setup.
* **MIDI Device missing from Console list**: If your device does not appear in the console during setup:
    1. Ensure the device is properly connected and recognized by your Operating System *before* launching REAPER.
    2. Check `Preferences > MIDI Devices` and ensure the output is not "Disabled".
* **Slow Scene/Preset Changes (USB MIDI)**: If you are using the Quad Cortex via USB MIDI and switching feels sluggish:
    1. Go to `Preferences > MIDI Devices`.
    2. Right-click your QC Output and select **Configure output...**.
    3. Check the box **"Open device in low latency/low precision mode"**. This often resolves timing issues with the QC's internal MIDI buffer.
* **Tempo / BPM Sync Issues**: 
    1. In REAPER: Ensure **"Send clock to this device"** is checked in your MIDI Output settings.
    2. On the Quad Cortex: Go to `Settings > MIDI` and ensure **MIDI Clock** is set to **ON** or **Receive**.
    3. Ensure the dedicated control track is not muted.
* **Erratic Behavior (Multiple Tracks)**: The script identifies the control track by its name. If your project contains multiple tracks with the same name, the script may target the wrong one. **Always ensure only one dedicated control track exists.**
* **No MIDI reaching the QC**: Ensure the dedicated track is Armed and Monitoring is set to ON.
* **Logging**: Set `Log Level` to `2` to see exactly what MIDI messages are being sent and which track is being used in real-time.

## License
This project is licensed under the **GNU General Public License v3.0**. 
You are free to share and modify this code, but you cannot monetize it, and any derivative work must remain Open Source under the same license.
