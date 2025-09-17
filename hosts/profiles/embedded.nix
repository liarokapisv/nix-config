{ self, pkgs, ... }:
{
  services = {
    udev.packages = with pkgs; [
      segger-jlink-headless
      openocd
    ];
  };

  home-manager.users.${self.user} = {
    imports = [ ../../homes/profiles/embedded.nix ];
  };
}
