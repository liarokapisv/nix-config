{ self, moduleWithSystem, ... }:
{
  flake.modules.nixos.realsense = moduleWithSystem (
    { self', ... }:
    { config, pkgs, ... }:
    {
      services.udev.packages = [
        self'.packages.librealsense-udev-rules
      ];

      home-manager.users.${config.user} = {
        imports = [ self.modules.homeManager.realsense ];
      };
    }
  );

  flake.modules.homeManager.realsense =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.librealsense-gui.overrideAttrs (old: {
          patches = old.patches ++ [
            # TODO: try to upstream this
            ./_force-x11.patch
          ];
        }))
      ];
    };
}
