{ self, ... }:
{

  networking = {

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  home-manager.users.${self.user} = {
    imports = [ ../../homes/profiles/networking.nix ];
  };
}
