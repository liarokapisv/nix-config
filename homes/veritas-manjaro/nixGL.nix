{ self, ... }:
(final: super:
with (self.lib final).glwrap;
{
  kitty = wrapIntel super.kitty "kitty";
  hyprland = wrapIntel super.hyprland "Hyprland";
  firefox = wrapIntel super.firefox "firefox";
  stremio = wrapIntel super.stremio "stremio";
  viber = wrapIntel super.viber "Viber";
  eagle = wrapIntel super.eagle "eagle";
})
