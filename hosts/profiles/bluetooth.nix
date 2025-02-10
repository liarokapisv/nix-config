{ self, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services.blueman.enable = true;

  home-manager.users.${self.user} = {
    imports = [ ../../homes/profiles/bluetooth.nix ];
  };

}
