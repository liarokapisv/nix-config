{ config, lib, pkgs, ... }: {

  options = {
    wayland.windowManager.hyprland.ext = {
      keybinds.wireplumber.enable = lib.mkEnableOption "wireplumber volume keybinds";
    };
  };

  config =
    let
      cfg = config.wayland.windowManager.hyprland;
    in

    lib.mkIf (cfg.enable) {

      home.packages = with pkgs; [ brightnessctl hyprshot ];

      wayland.windowManager.hyprland.settings = {
        binde = [
          ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ] ++
        lib.optionals (cfg.ext.keybinds.wireplumber.enable) [
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
        bind = [
          "SUPER, P, exec, HYPRSHOT_DIR=~/Downloads hyprshot -m region"
          "SUPER_SHIFT, P, exec, HYPRSHOT_DIR=~/Downloads hyprshot -m window"
        ];
      };

      wayland.windowManager.hyprland = {
        extraConfig = builtins.readFile ./hyprland.conf;
      };

      programs = {
        swww.systemd = {
          target = "hyprland-session.target";
        };
        waybar.systemd = {
          target = "hyprland-session.target";
        };
      };

      gtk = {
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };
    };
}




