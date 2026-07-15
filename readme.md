# Quickconf 🚀

A lightweight, reliable, and highly modular status bar configuration built with [Quickshell](https://github.com/outfoxxed/quickshell) and QML. Designed as a clean, performant, and reliable replacement for Waybar, styled around the elegant Catppuccin Mocha palette.

This configuration is entirely modularized, using a global singleton for centralized theming and isolated QML components for managing independent system data processes.

## ✨ Features

- **Hyprland Integration**:
  - **Animated Workspaces**: Interactive workspace switcher featuring smooth Bezier curve width animations and active/hover states.
  - **Window Title**: Displays the currently active toplevel window name, gracefully truncating long titles.
- **System Stats Module**:
  - **CPU Usage**: Efficiently parses aggregate CPU usage ticks from `/proc/stat`.
  - **RAM Usage**: Automatically monitors memory usage using `free`. Includes a **click-to-toggle feature** to seamlessly switch between absolute memory usage (`GB`) and percentage view (`%`).
  - **CPU Temperature**: Directly fetches the CPU `Tctl` die temp using `lm-sensors`. Features a dynamic color cascade that shifts text color seamlessly across thresholds from cold blue to warning dark red based on current heat levels.
- **Connectivity & System Tray**:
  - **Native SNI System Tray**: A fully functional D-Bus system tray that natively renders application context menus via `QsMenuAnchor`, complete with an app blacklist.
  - **Network & Bluetooth**: Dynamic signal icons that launch `iwgtk` and `blueman-manager` respectively on click.
- **Media & Power Management**:
  - **Audio Controls**: Input and Output sound components that adapt icons based on form factor (headphones, speakers) and launch `pavucontrol`.
  - **Battery & Power Profiles**: Interactive battery widget toggling between percentage and autonomy, plus a one-click `powerprofilesctl` switcher (Saver, Balanced, Performance).
  - **Brightness**: Tracks backlight levels via `brightnessctl`.
- **Utility & Time**:
  - **Caffeine / Idle Inhibitor**: Native Wayland idle inhibitor using the `idle-inhibit-unstable-v1` protocol to prevent the compositor from putting the system to sleep.
  - **Interactive Clock**: A dynamic real-time clock that toggles between standard 12-hour time and a full 24-hour date/time string on click.
- **Global Singleton Styling**: Uses a centralized `Global.qml` configuration to distribute unified font styles (`CaskaydiaCove NF`), colors, weights, and component sizing across all layouts.
- **Nix Flake Powered**: Built-in development shell context providing the exact QT declarative engines, shell environment paths (`QMLLS_BUILD_DIRS`), and runtime binaries required without global system pollution.

## 📁 Project Structure

```text
├── src/
│   ├── components/         # Extracted standalone widget logic
│   │   ├── Battery.qml     # Battery stats & autonomy toggles
│   │   ├── Bluetooth.qml   # Bluetooth status & manager launcher
│   │   ├── Brightness.qml  # Screen brightness monitor
│   │   ├── Caffeine.qml    # Wayland idle inhibitor toggle
│   │   ├── Calendar.qml    # Interactive clock and date display
│   │   ├── CpuTemp.qml     # Temperature tracking + threshold styling
│   │   ├── CpuUsage.qml    # Active CPU calculation
│   │   ├── InputSound.qml  # Microphone status & pavucontrol launcher
│   │   ├── Network.qml     # WiFi signal & iwgtk launcher
│   │   ├── OutputSound.qml # Sink volume & form-factor icons
│   │   ├── PowerProfiles.qml # powerprofilesctl interactive switcher
│   │   ├── RamUsage.qml    # Interactive Memory usage component
│   │   ├── Shutdown.qml    # Power menu trigger
│   │   ├── Tray.qml        # Native SNI System Tray with context menus
│   │   ├── WindowTitle.qml # Active Hyprland window title
│   │   └── Workspaces.qml  # Animated Hyprland workspace switcher
│   ├── Global.qml          # Project-wide visual definitions (Singleton)
│   └── shell.qml           # Primary panel architecture and zone positioning
├── flake.lock              # Pinning Nix dependencies
├── flake.nix               # Development shell and script app wrapper
├── readme.md               # Documentation
└── .envrc                  # Direnv integration for flakes
```

## 🛠️ Installation & Deployment

This configuration leverages Nix Flakes to simplify building, developing, and running your environment securely. All dependencies (like `pavucontrol`, `iwgtk`, `brightnessctl`, and `lm_sensors`) are bundled in the flake.

### Running Directly via Nix

You can test and launch the configuration immediately using the bundled `quickconf` application app script defined inside `flake.nix`:

```bash
nix run github:TheWhale01/quickconf
```

*Note: Running this command clears out `$HOME/.config/quickshell` safely, copies your active `src/*` hierarchy into it, and boots the bar instance instantly.*

### Local Development Environment

To hack on the configuration locally with full Language Server (LSP) and autocomplete capabilities matching the declared QT modules:

1. Clone the repository and navigate into the source tree:
   ```bash
   git clone https://github.com/TheWhale01/quickconf.git
   cd quickconf
   ```

2. Drop into the development shell context (or allow direnv):
   ```bash
   nix develop
   ```
   *(This automatically exports your `QML2_IMPORT_PATH` and setups environment paths pointing directly into the local repository layout and Nix packages store).*

3. Test your configurations locally using the interactive launcher hook:
   ```bash
   nix run .
   ```

## 🎨 Configuration & Customization

### Adjusting Global Colors & Fonts
To modify the overall aesthetic, update the properties inside `src/Global.qml`:

```qml
readonly property color fontColor: "#cdd6f4"
readonly property color backgroundColor: "#11111b"
readonly property color hoverColor: "#f5c2e7"
readonly property font font: Qt.font({
    family: "CaskaydiaCove NF",
    pixelSize: 13,
    weight: Font.Bold,
})
```

### Changing Temperature Sensor Target
If your machine uses an Intel CPU or exposes a different thermal target than `Tctl`, modify the parsing regex inside `src/components/CpuTemp.qml`:

```qml
command: ["sh", "-c", "sensors | grep 'Tctl' | awk '{print $2}' | tr -d '+°C'"]
```

## 🔗 Related Repositories

This configuration is actively integrated into the primary NixOS system deployment workflow located at [TheWhale01/nixos-config](https://github.com/TheWhale01/nixos-config).
