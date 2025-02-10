{ pkgs, ... }:
{

  programs.waybar.ext.network.on-click = "${pkgs.iwgtk}/bin/iwgtk";

  home.packages = with pkgs; [ iwgtk ];

}
