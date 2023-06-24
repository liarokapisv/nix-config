{ pkgs, ... }:
{
  imports = [
    ../../modules/hm/common.nix
  ];

  home.packages = with pkgs; [ libsForQt5.dolphin ];

  programs = {
    wofi.enable = true;
  };

  home = {
    hyprland.enable = true;
    waybar.enable = true;
    fuzzel.enable = true;
  };

  home.stateVersion = "23.05";
}
