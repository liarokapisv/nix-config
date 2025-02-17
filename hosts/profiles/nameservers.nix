{ config, lib, ... }:
let
  nameservers = [
    # Cloudflare
    "1.1.1.1"
    "1.0.0.1"
    # Google
    "8.8.8.8"
    "8.8.4.4"
  ];
in
{
  networking = {
    nameservers = lib.mkIf (!config.networking.networkmanager.enable) nameservers;

    networkmanager = {
      insertNameservers = lib.mkIf config.networking.networkmanager.enable nameservers;
    };
  };
}
