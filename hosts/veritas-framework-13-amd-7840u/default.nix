{
  self,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../profiles/common.nix
    ../profiles/power.nix
    ../profiles/pipewire.nix
    ../profiles/bluetooth.nix
    ../profiles/hyprland.nix
    ../profiles/usb-automount.nix
    ../profiles/networking.nix
    ../profiles/virtualisation.nix
    ../profiles/realsense.nix
    ../profiles/embedded.nix
  ];

  networking.firewall.trustedInterfaces = [
    "enp195s0f3u1c2"
  ];
  virtualisation.docker.daemon.settings = {
    "data-root" = "/home/docker-root";
  };
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
    udev.packages = [ pkgs.segger-jlink ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.tmp.useTmpfs = true;

  networking.hostName = "veritas-framework-13-amd-7840u";

  users.users.${self.user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
    ];
    initialHashedPassword = "$6$JwTimdf683A1QxN.$aorlpRJPWrcsl0pR1nlELJhdy8traiVPBXnwXU5IfEbWBD5PusIrkjRZDA76OJECmJdR9PLiUyxJeQUzjX6Nv0";

    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHQE3nquLEwnEU5NdU1YZ1LBLCIq4gaLgMF+TvnL9vV veritas@veritas"
    ];
  };

  programs = {
    steam.enable = true;
  };

  home-manager.users.${self.user} = {
    stylix.image = ../../images/mountain-music.gif;

    home = {
      packages = with pkgs; [
        dynamixel-wizard-2
        qbittorrent
        vlc
        bitwarden
        digikam
        anydesk
        slack
        discord
        teams-for-linux
        zoom-us
        erae-lab
      ];

      stateVersion = "24.05";
    };

  };

  fonts = {
    enableDefaultPackages = true;
  };

  system.stateVersion = "24.05";
}
