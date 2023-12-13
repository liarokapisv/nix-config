{ config, lib, pkgs, ... }: {

  options = {
    dotfiles.waybar.enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf (config.dotfiles.waybar.enable) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.options = {
        height = 30;
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          "battery"
          "clock"
          "tray"
        ];
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };
        battery = {
          states = {
            "warning" = 30;
            "critical" = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}= {ipaddr}/{cidr}";
        };
      };
      style = ''
        
      '';
    };

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

}
