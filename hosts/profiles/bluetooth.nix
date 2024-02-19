{ self, ... }:
{
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  home-manager.users.${self.user} = {
    imports = [
      ../../homes/profiles/bluetooth.nix
    ];
  };

}
