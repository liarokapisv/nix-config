{ self, ... }:
(final: super:
with (self.lib final).glwrap;
{
  kitty = wrapIntel super.kitty "kitty";
  hyprland = wrapIntel super.hyprland "Hyprland";
  firefox = wrapIntel super.firefox "firefox";
  viber = wrapIntel super.viber "Viber";
})
