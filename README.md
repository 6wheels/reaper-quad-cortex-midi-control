# Quad Cortex MIDI Control for Reaper

Automate your **Neural DSP Quad Cortex** directly from the Reaper timeline.

## Features
- **Region-Based Control**: Trigger Presets and Scenes by simply naming your Regions.
- **Automatic Track Setup**: Automatically creates and configures a dedicated MIDI routing track.
- **Smart Transport Automation**: 
    - Automatically activates the **Tuner** on Stop (optional).
    - Automatically switches to **Gig View** on Play (optional).
- **Setup Wizard**: Easy configuration of MIDI channels, hardware IDs, and naming prefixes.
- **MIDI Clock Support**: Reaper will send tempo/clock to the Quad Cortex 
    if "Send clock" is enabled for your MIDI output in Reaper's Preferences.
- **Modular Design**: Lightweight engine with a separate configuration interface.

## ⚠️ Choosing your version

| Version | Status | Source |
| :--- | :--- | :--- |
| **Stable** | Recommended for Live/Studio | Search `Quad Cortex MIDI Control` in ReaPack (Standard repos) |
| **Development** | Experimental / New features | Add this GitHub URL to your ReaPack repositories |

## Installation

### Stable Version (Easiest)
No extra steps required if you have ReaPack installed:
1. Open **Extensions > ReaPack > Browse packages**.
2. Search for `Quad Cortex MIDI Control`.
3. Right-click and **Install**.

### Development Version

#### Through Reapack and GitHub
To test the latest features before they hit the stable release:
1. Copy this URL: `https://github.com/6wheels/reaper-quad-cortex-midi-control/raw/main/index.xml`
2. In Reaper: `Extensions > ReaPack > Import a repository`.
3. Paste the URL and click **OK**.
4. Install the package as usual.

#### Manually with Github
1. Download the `Quad Cortex MIDI Control` folder from this repository.
2. Place it in your Reaper `Scripts` directory.
3. Load `Quad_Cortex_MIDI_Control.lua` in the Actions List.

## Usage

### 1. Configuration
On the first run, a **Setup Wizard** will appear. 
- **MIDI Channel**: The MIDI channel your Quad Cortex is listening to (default: 1).
- **Hardware MIDI Out ID**: The ID of your MIDI interface connected to the QC.
- **Prefixes**: Characters used to identify commands in Region names.

### 2. Controlling the Quad Cortex
Create Regions in your project and name them using the following syntax (default prefixes):

| Target | Syntax Example | Notes |
| :--- | :--- | :--- |
| **Preset** | `#1A` | Bank number + Slot letter (A to H) |
| **Scene** | `!S1` or `!SA` | Scene number (1-8) or letter (A-H) |

*Note: If regions overlap, the shortest Region takes priority for Scene changes (ideal for nested scenes within a preset).*

## License
This project is licensed under the **GNU General Public License v3.0**. 
You are free to share and modify this code, but you cannot monetize it, and any derivative work must remain Open Source under the same license.