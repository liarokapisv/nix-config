{ pkgs, ... }:
{
  services.blueman-applet.enable = true;

  programs.waybar.ext.bluetooth.on-click = "${pkgs.blueman}/bin/blueman-manager";
}
