{ self, ... }:
{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    services.blueman.enable = true;
  };

  flake.modules.homeManager.bluetooth =
    { pkgs, ... }:
    {
      services.blueman-applet.enable = true;
      programs.waybar.ext.bluetooth.on-click = "${pkgs.blueman}/bin/blueman-manager";
    };
}
