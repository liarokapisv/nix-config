{ self, ... }: {

  networking = {

    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  home-manager.users.${self.user} = {
    imports = [
      ../../homes/profiles/iwd.nix
    ];
  };
}
