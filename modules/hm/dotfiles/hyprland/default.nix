{ config, lib, ... }: {

  options = {
    dotfiles.hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf (config.dotfiles.hyprland.enable) {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./config/hyprland.conf;
    };
  };

}

