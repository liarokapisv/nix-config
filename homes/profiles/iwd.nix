{ pkgs, ... }:
{

  #programs.waybar.ext.network.on-click = "${pkgs.iwgtk}/bin/iwgtk";

  services.network-manager-applet.enable = true;

  home.packages = [ pkgs.networkmanagerapplet ];

}
