{ self, ... }:
{
  flake.modules.nixos.networking =
    { pkgs, ... }:
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
    };

  flake.modules.homeManager.networking =
    { pkgs, ... }:
    {
      services.network-manager-applet.enable = true;

      home.packages = [
        pkgs.networkmanagerapplet
        pkgs.tcpdump
        pkgs.arp-scan
        pkgs.nmap
        pkgs.nftables
        pkgs.dig
        pkgs.conntrack-tools
        pkgs.whois
      ];

    };
}
