{ self, pkgs, ... }:
{
  services = {
    udev.packages = with pkgs; [
      segger-jlink-headless
      openocd
      saleae-logic-2
    ];
  };

  home-manager.users.${self.user} = {
    imports = [ ../../homes/profiles/embedded.nix ];
  };
}
