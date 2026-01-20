{
  flake.modules.homeManager.config-dms =
    {
      config,
      lib,
      pkgs,
      osConfig,
      ...
    }:
    {
      # Only enable DMS when niri is enabled
      config = lib.mkIf (osConfig.programs.niri.enable or false) {

        # Wallpaper disabled - using swww module instead
        # home.file.".config/dms/wallpaper.gif".source = "${self.outPath}/images/mountain-music.gif";

        home.packages = [
          (pkgs.writeShellScriptBin "dms-diff" ''
            set -euo pipefail
            cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/DankMaterialShell/settings.json"
            cp "$cfg" "$cfg".bak
            trap 'mv "$cfg".bak "$cfg" || true' EXIT
            rm -f "$cfg"
            cp -L "$cfg".bak "$cfg"
            chmod +w "$cfg"
            echo "Toggle one setting once in DMS, then press Enter…"
            read -r
            cp "$cfg" "$cfg".toggled
            trap 'rm -f "$cfg".toggled || true' EXIT
            echo "Toggle the same setting again in DMS, then press Enter…"
            read -r
            diff -u "$cfg".toggled "$cfg" || true
          '')
        ];

        programs.dank-material-shell = {
          enable = true;

          # Systemd auto-start
          systemd = {
            enable = true;
            restartIfChanged = true;
          };

          # Feature toggles
          enableSystemMonitoring = true; # dgop for CPU/RAM/GPU metrics
          enableVPN = false; # Enable if you use VPNs
          enableDynamicTheming = false; # Disabled - using swww for wallpaper management
          enableAudioWavelength = false; # Audio visualizer (cava)
          enableCalendarEvents = false; # Calendar integration (khal)
          enableClipboardPaste = true; # Clipboard pasting with wtype

          # Niri integration
          niri = {
            enableKeybinds = false; # We'll manually configure keybinds
            enableSpawn = false; # Using systemd instead
            includes = {
              enable = false; # Disable - niri doesn't support include statements
              override = false;
            };
          };

          # Default settings (can also be configured via GUI)
          settings = {
            theme = "dark";
            dynamicTheming = false; # Disabled - using swww instead
            showSeconds = true;
            blurWallpaperOnOverview = false;
            showLauncherButton = false;
            showWorkspaceIndex = true;
            showWorkspaceName = true;
            showWorkspaceApps = true;
            showOccupiedWorkspacesOnly = true;
            niriOverviewOverlayEnabled = true;
            useAutoLocation = true;

            # External wallpaper management (swww)
            screenPreferences = {
              wallpaper = [ ]; # Empty array enables external wallpaper management
            };

            # Additional workspace settings
            showWorkspacePadding = false;
            workspaceScrolling = false;
            groupWorkspaceApps = true;
            maxWorkspaceIcons = 3;
            workspaceFollowFocus = false;
            reverseScrolling = false;

            # Workspace colors
            workspaceColorMode = "default";
            workspaceOccupiedColorMode = "default";
            workspaceUnfocusedColorMode = "default";
            workspaceUrgentColorMode = "default";

            # Workspace borders
            workspaceFocusedBorderEnabled = false;
            workspaceFocusedBorderColor = "primary";
            workspaceFocusedBorderThickness = 2;

            # Widget settings
            waveProgressEnabled = true;
            scrollTitleEnabled = true;
            audioVisualizerEnabled = true;
            audioScrollMode = "volume";
            clockCompactMode = false;
            focusedWindowCompactMode = false;
            runningAppsCompactMode = true;
            keyboardLayoutNameCompactMode = false;
            runningAppsCurrentWorkspace = false;
            runningAppsGroupByApp = false;
            centeringMode = "index";
            clockDateFormat = "";
            lockDateFormat = "";
            mediaSize = 0; # 0=minimal/small, 1=medium, 2=large, 3=largest

            soundPluggedIn = false;
          };

          # Clipboard configuration
          clipboardSettings = {
            maxHistory = 50;
            maxEntrySize = 5242880; # 5MB
            autoClearDays = 7;
            clearAtStartup = false;
            disabled = false;
            disableHistory = false;
            disablePersist = false;
          };

          # Community plugins from registry
          plugins = {
            # Battery notifications
            dankBatteryAlerts.enable = true;

            # Media player enhancements
            mediaPlayer = {
              enable = true;
              settings = {
                preferredSource = "spotify";
              };
            };
          };
        };
      };
    };
}
