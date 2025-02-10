{ config, pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    port = 14242;
    interfaceName = "userspace-networking";
  };

  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  environment.systemPackages = [ pkgs.tailscale ];
}
