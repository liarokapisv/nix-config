{ self, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../profiles/common.nix
    ../profiles/pipewire.nix
    ../profiles/bluetooth.nix
    ../profiles/hyprland.nix
    ../profiles/iwd.nix
    ../profiles/usb-automount.nix
  ];

  nix = {
    settings = {
      substituters = [
        "https://devenv.cachix.org/"
        "https://ros.cachix.org/"
      ];
      trusted-public-keys = [
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };

  services = {
    upower.enable = true;
    fwupd.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    udev.packages = [
      pkgs.segger-jlink
    ];
    zerotierone = {
      enable = true;
      joinNetworks = [
        "db64858fed5b04bb"
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.tmp.useTmpfs = true;

  networking = {
    hostName = "veritas-framework-13-amd-7840u";
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

  programs.steam.enable = true;

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
        bitwarden
        digikam
        anydesk
        slack
      ];

      stateVersion = "24.05";
    };
  };

  fonts = {
    enableDefaultPackages = true;
  };

  system.stateVersion = "24.05";
}

