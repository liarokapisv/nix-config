{ self, ... }:
{
  flake.modules.nixos.bluetooth =
    { config, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };

      services.blueman.enable = true;

      home-manager.users.${config.user} = {
        imports = [ self.modules.homeManager.bluetooth ];
      };
    };

  flake.modules.homeManager.bluetooth =
    { pkgs, ... }:
    {
      services.blueman-applet.enable = true;
      programs.waybar.ext.bluetooth.on-click = "${pkgs.blueman}/bin/blueman-manager";
    };
}
