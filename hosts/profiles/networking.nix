{
  self,
  pkgs,
  ...
}:
{
  services = {
    resolved = {
      enable = true;
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };
  };

  environment.systemPackages = [ pkgs.tailscale ];

  home-manager.users.${self.user} = {
    imports = [ ../../homes/profiles/networking.nix ];
  };
}
