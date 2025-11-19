{
  flake.modules.nixos.apple =
    { pkgs, ... }:
    {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };
      environment.systemPackages = [
        pkgs.libimobiledevice
        pkgs.ifuse
      ];
    };
}
