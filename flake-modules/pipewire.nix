{ self, ... }:
{
  flake.modules.nixos.pipewire =
    { config, ... }:
    {

      security.rtkit.enable = true;

      services = {
        pipewire = {
          enable = true;
          alsa.enable = true;
          jack.enable = true;
          pulse.enable = true;
        };

      };

      users.users.${config.user} = {
        extraGroups = [ "pipewire" ];
      };

      home-manager.users.${config.user} = {
        imports = [ self.modules.homeManager.pipewire ];
      };
    };

  flake.modules.homeManager.pipewire =
    { pkgs, ... }:
    {

      wayland.windowManager.hyprland.ext.keybinds.wireplumber.enable = true;

      programs.waybar.ext.wireplumber.on-click = "${pkgs.pavucontrol}/bin/pavucontrol";

      home.packages = with pkgs; [
        alsa-utils
        pavucontrol
        helvum
      ];

    };
}
