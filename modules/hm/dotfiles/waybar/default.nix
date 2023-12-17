{ config, lib, pkgs, ... }: {

  options = {
    programs.waybar.ext.wireplumber.on-click = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "The action to execute when clicking the wireplumber group";
    };
  };

  config =
    let cfg = config.programs.waybar;
    in lib.mkIf (cfg.enable) {
      programs.waybar = {
        systemd.enable = true;
        settings.options = {
          height = 30;
          spacing = 4;
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "wireplumber"
            "network"
            "cpu"
            "disk"
            "temperature"
            "backlight"
            "battery"
            "clock"
          ];
          wireplumber = {
            format = "{volume}% {icon}";
            format-muted = "";
            format-icons = [ "" "" " " ];
            on-click = cfg.ext.wireplumber.on-click;
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%)  ";
            format-ethernet = "{ipaddr}/{cidr}  ";
            tooltip-format = "{ifname} via {gwaddr}  ";
            format-linked = "{ifname} (No IP)  ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}= {ipaddr}/{cidr}";
          };
          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          disk = {
            format = "{used} / {total} ";
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
            format-charging = "{capacity}%  ";
            format-plugged = "{capacity}%  ";
            format-alt = "{time} {icon}";
            format-icons = [ " " " " " " " " " " ];
          };
          clock = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
        };
      };

      home.packages = with pkgs; [
        fira-code-nerdfont
        font-awesome
      ];
    };
}
