{ config, lib, ... }: {

  options = {
    home.hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf (config.home.hyprland.enable) {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./config/hyprland.conf;
    };
  };

}

