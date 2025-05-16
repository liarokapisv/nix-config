{ self, pkgs, ... }:
{
  services.udev.packages = [
    pkgs.librealsense-udev-rules
  ];

  home-manager.users.${self.user} = {
    imports = [ ../../homes/profiles/realsense ];
  };
}
