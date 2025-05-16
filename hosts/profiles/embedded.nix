{ self, pkgs, ... }:
{
  nixpkgs.config.segger-jlink.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-810"
  ];

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
