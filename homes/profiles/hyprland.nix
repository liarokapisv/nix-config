{ pkgs, lib, ... }:
{

  wayland.windowManager.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.hyprland.default = [ "hyprland" "gtk" ];
  };

  programs = {
    fuzzel.enable = true;
    swww = {
      enable = true;
      systemd.enable = true;
    };
    waybar = {
      enable = true;
      systemd.enable = true;
    };
  };

  services = {
    hyprpaper.enable = lib.mkForce false;
    dunst.enable = true;
  };

  home.packages = with pkgs; [ wl-clipboard ];

}
