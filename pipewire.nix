{ self, ... }:
{
  flake.modules.nixos.pipewire =
    { lib, ... }:
    {
      options.services.pipewire.requiredGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Groups required for pipewire access";
      };

      config = {
        services.pipewire.requiredGroups = [ "pipewire" ];

        security.rtkit.enable = true;

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          jack.enable = true;
          pulse.enable = true;
        };
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
