{ self, ... }:
{
  flake-file.inputs.niri-flake.url = "github:sodiboo/niri-flake";

  perSystem = {
    nixpkgs.overlays = [ self.inputs.niri-flake.overlays.niri ];
  };

  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [
        self.inputs.niri-flake.nixosModules.niri
        self.modules.nixos.wayland
      ];
      niri-flake.cache.enable = false;

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };

      # DMS Greeter base configuration
      services.displayManager.dms-greeter = {
        enable = true;
        compositor.name = "niri";
        # configHome should be set in machine-specific config
      };

      xdg.portal = {
        config.niri = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        };
      };
    };

  flake.modules.homeManager.niri = {
    imports = [
      self.modules.homeManager.wayland
    ];

    xdg.portal = {
      config.niri = {
        default = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      };
    };
  };
}
