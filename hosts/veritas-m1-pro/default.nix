{ self, pkgs, ... }:
{
  imports = [
    ./asahi.nix
    ./hardware.nix
    ../profiles/common.nix
    ../profiles/pipewire.nix
    ../profiles/hyprland.nix
    ../profiles/iwd.nix
    ../profiles/usb-automount.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32 * 1024;
  }];

  networking = {
    hostName = "veritas-m1-pro";
  };

  users.users.${self.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$JwTimdf683A1QxN.$aorlpRJPWrcsl0pR1nlELJhdy8traiVPBXnwXU5IfEbWBD5PusIrkjRZDA76OJECmJdR9PLiUyxJeQUzjX6Nv0";

    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHQE3nquLEwnEU5NdU1YZ1LBLCIq4gaLgMF+TvnL9vV veritas@veritas"
    ];
  };

  environment.systemPackages = with pkgs; [
    sommelier
    passt
  ];

  home-manager.users.${self.user} = {
    imports = [
      ../../homes/profiles/common.nix
      ../../homes/profiles/embedded.nix
    ];

    stylix.image = ../../images/mountain-music.gif;

    home = {
      packages = with pkgs; [
        qbittorrent
        vlc
        distrobox
        (box64.overrideAttrs (old: {
          version = "0.2.8";
          src = old.src.override {
            hash = "sha256-P+m+JS3THh3LWMZYW6BQ7QyNWlBuL+hMcUtUbpMHzis=";
          };
          cmakeFlags = old.cmakeFlags ++ [ "-DM1=ON" ];
        }))
      ];

      stateVersion = "23.11";
    };
  };

  fonts = {
    enableDefaultPackages = true;
  };

  system.stateVersion = "23.11";
}
