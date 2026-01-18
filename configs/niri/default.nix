{
  flake.modules.homeManager.config-niri =
    {
      config,
      lib,
      pkgs,
      osConfig,
      ...
    }:
    {
      config = lib.mkIf (osConfig.programs.niri.enable or false) {

        # Install required packages
        home.packages = with pkgs; [
          brightnessctl
        ];

        # Main niri configuration
        programs.niri.settings = {

          # Disable initial shortcut overview screen on startup
          hotkey-overlay.skip-at-startup = true;

          # Xwayland support via xwayland-satellite
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          # Prefer server-side decorations for consistent appearance
          prefer-no-csd = true;

          # Input configuration
          input = {
            keyboard.xkb = {
              layout = "us,gr";
              options = "grp:alt_shift_toggle";
            };
            touchpad = {
              tap = true;
              dwt = true; # disable-while-typing
              natural-scroll = false;
            };
          };

          # Output configuration
          outputs."eDP-1" = { };

          # Layout settings
          layout = {
            gaps = 5; # Inner gaps between windows

            border = {
              enable = false;
            };

            focus-ring = {
              enable = false;
            };
          };

          # Animations: Disable workspace-switch and horizontal-view-movement (cause eye strain/tearing)
          animations = {
            workspace-switch.enable = false;
            horizontal-view-movement.enable = false;
          };

          # Environment variables
          environment.NIXOS_OZONE_WL = "1";

          # Screenshot path
          screenshot-path = "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png";

          # Keybindings - Ergonomic layout following niri defaults with vim-style navigation
          binds = {
            # Show keyboard shortcuts overlay
            "Mod+Shift+Slash" = {
              action.show-hotkey-overlay = { };
            };

            # Applications
            "Mod+Return" = {
              action.spawn = "kitty";
            };
            "Mod+E" = {
              action.spawn = "firefox";
            };

            # DMS Launcher (replaces fuzzel)
            "Mod+D" = {
              action.spawn = [
                "dms"
                "ipc"
                "call"
                "spotlight"
                "toggle"
              ];
            };

            # DMS Control Center (network, bluetooth, audio)
            "Mod+Shift+C" = {
              action.spawn = [
                "dms"
                "ipc"
                "call"
                "control-center"
                "toggle"
              ];
            };

            # DMS Notifications
            "Mod+N" = {
              action.spawn = [
                "dms"
                "ipc"
                "call"
                "notifications"
                "toggle"
              ];
            };

            # DMS Lock Screen (changed from Mod+L to avoid conflicts)
            "Mod+Escape" = {
              action.spawn = [
                "dms"
                "ipc"
                "call"
                "lock"
                "lock"
              ];
            };

            # DMS System Monitor
            "Mod+Shift+Escape" = {
              action.spawn = [
                "dms"
                "ipc"
                "call"
                "processlist"
                "toggle"
              ];
            };

            # DMS Settings
            "Mod+I" = {
              action.spawn = [
                "dms"
                "ipc"
                "call"
                "settings"
                "toggle"
              ];
            };

            # DMS Dashboard
            "Mod+Shift+D" = {
              action.spawn = [
                "dms"
                "ipc"
                "call"
                "dash"
                "toggle"
              ];
            };

            # Window management
            "Mod+W" = {
              action.close-window = { };
            };
            "Mod+Shift+E" = {
              action.quit = { };
            };
            "Mod+F" = {
              action.maximize-column = { };
            };
            "Mod+Shift+F" = {
              action.fullscreen-window = { };
            };

            # Focus columns (left/right)
            "Mod+H" = {
              action.focus-column-left = { };
            };
            "Mod+L" = {
              action.focus-column-right = { };
            };

            # Focus windows within column (up/down)
            "Mod+Shift+J" = {
              action.focus-window-down = { };
            };
            "Mod+Shift+K" = {
              action.focus-window-up = { };
            };

            # Move columns (left/right) - uses Ctrl as in niri default
            "Mod+Ctrl+H" = {
              action.move-column-left = { };
            };
            "Mod+Ctrl+L" = {
              action.move-column-right = { };
            };

            # Move windows within column (up/down) - uses Ctrl as in niri default
            "Mod+Ctrl+Shift+J" = {
              action.move-window-down = { };
            };
            "Mod+Ctrl+Shift+K" = {
              action.move-window-up = { };
            };

            # Workspace switching (U/D for up/down)
            "Mod+K" = {
              action.focus-workspace-up = { };
            };
            "Mod+J" = {
              action.focus-workspace-down = { };
            };

            # Move column to workspace (Ctrl+U/D)
            "Mod+Ctrl+K" = {
              action.move-column-to-workspace-up = { };
            };
            "Mod+Ctrl+J" = {
              action.move-column-to-workspace-down = { };
            };

            # Workspace switching by number (1-10)
            "Mod+1" = {
              action.focus-workspace = 1;
            };
            "Mod+2" = {
              action.focus-workspace = 2;
            };
            "Mod+3" = {
              action.focus-workspace = 3;
            };
            "Mod+4" = {
              action.focus-workspace = 4;
            };
            "Mod+5" = {
              action.focus-workspace = 5;
            };
            "Mod+6" = {
              action.focus-workspace = 6;
            };
            "Mod+7" = {
              action.focus-workspace = 7;
            };
            "Mod+8" = {
              action.focus-workspace = 8;
            };
            "Mod+9" = {
              action.focus-workspace = 9;
            };
            "Mod+0" = {
              action.focus-workspace = 10;
            };

            # Move window to workspace by number (1-10)
            "Mod+Shift+1" = {
              action.move-window-to-workspace = 1;
            };
            "Mod+Shift+2" = {
              action.move-window-to-workspace = 2;
            };
            "Mod+Shift+3" = {
              action.move-window-to-workspace = 3;
            };
            "Mod+Shift+4" = {
              action.move-window-to-workspace = 4;
            };
            "Mod+Shift+5" = {
              action.move-window-to-workspace = 5;
            };
            "Mod+Shift+6" = {
              action.move-window-to-workspace = 6;
            };
            "Mod+Shift+7" = {
              action.move-window-to-workspace = 7;
            };
            "Mod+Shift+8" = {
              action.move-window-to-workspace = 8;
            };
            "Mod+Shift+9" = {
              action.move-window-to-workspace = 9;
            };
            "Mod+Shift+0" = {
              action.move-window-to-workspace = 10;
            };

            # Column width presets
            "Mod+R" = {
              action.switch-preset-column-width = { };
            };

            # Column height presets
            "Mod+Shift+R" = {
              action.switch-preset-window-height = { };
            };

            # Consume/expel windows - Directional (comma/period as in niri default)
            "Mod+Comma" = {
              action.consume-window-into-column = { };
            };
            "Mod+Period" = {
              action.expel-window-from-column = { };
            };

            # Consume-or-expel - Bidirectional (brackets as in niri default)
            "Mod+BracketLeft" = {
              action.consume-or-expel-window-left = { };
            };
            "Mod+BracketRight" = {
              action.consume-or-expel-window-right = { };
            };

            # Center column
            "Mod+C" = {
              action.center-column = { };
            };

            # Resize column width (horizontal)
            "Mod+Minus" = {
              action.set-column-width = "-10%";
            };
            "Mod+Equal" = {
              action.set-column-width = "+10%";
            };

            # Resize window height (vertical)
            "Mod+Shift+Minus" = {
              action.set-window-height = "-10%";
            };
            "Mod+Shift+Equal" = {
              action.set-window-height = "+10%";
            };

            # Reset window height to automatic
            "Mod+Ctrl+R" = {
              action.reset-window-height = { };
            };

            # Floating window toggle
            "Mod+V" = {
              action.toggle-window-floating = { };
            };

            # Workspace switching - Tab for previous workspace
            "Mod+Tab" = {
              action.focus-workspace-previous = { };
            };

            # Overview - Grave/backtick key
            "Mod+Grave" = {
              action.toggle-overview = { };
            };

            # Screenshots (keeping your P preference)
            "Mod+P" = {
              action.screenshot = { };
            };
            "Mod+Shift+P" = {
              action.screenshot-window = { };
            };

            # Note: Mouse bindings (Mod+LeftClick to move, Mod+RightClick to resize)
            # are built into niri and don't need to be configured in binds

            # Brightness controls
            "XF86MonBrightnessUp" = {
              action.spawn = [
                "brightnessctl"
                "set"
                "5%+"
              ];
            };
            "XF86MonBrightnessDown" = {
              action.spawn = [
                "brightnessctl"
                "set"
                "5%-"
              ];
            };

            # Volume controls
            "XF86AudioRaiseVolume" = {
              action.spawn = [
                "wpctl"
                "set-volume"
                "-l"
                "1"
                "@DEFAULT_AUDIO_SINK@"
                "5%+"
              ];
            };
            "XF86AudioLowerVolume" = {
              action.spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "5%-"
              ];
            };
            "XF86AudioMute" = {
              action.spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
            };
            "XF86AudioMicMute" = {
              action.spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SOURCE@"
                "toggle"
              ];
            };
          };

          # Window rules
          window-rules = [
            {
              # Make all windows open maximized
              open-maximized = true;
            }
          ];
        };
      };
    };
}
