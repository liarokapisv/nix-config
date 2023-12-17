{ pkgs, ... }: {

  wayland.windowManager.hyprland.ext.keybinds.wireplumber.enable = true;

  programs.waybar.ext.wireplumber.on-click = "${pkgs.pavucontrol}/bin/pavucontrol";

  home.packages = with pkgs; [
    alsa-utils
    pavucontrol
    helvum
  ];

}
