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
    self.inputs.agenix.nixosModules.default
  ];

  # Turn off to enable docker swarm.
  virtualisation.docker.daemon.settings.live-restore = false;

  # Required for docker swarm
  # networking.firewall = {
  #     allowedTCPPorts = [
  #       7946
  #       2377
  #     ];
  #     allowedUDPPorts = [
  #       7946
  #       4789
  #     ];
  # };

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

  # vpn connectivity
  age.secrets = {
    "AlexL.ovpn".file = ../../secrets/AlexL.ovpn;
    "AlexL-password.txt".file = ../../secrets/AlexL-password.txt;
  };

  environment.systemPackages = [
    self.inputs.agenix.packages."${pkgs.system}".default
  ];

  services.openvpn.servers = {
    acuminoNzOfficeVPN = {
      config = ''
        config ${config.age.secrets."AlexL.ovpn".path}
        askpass ${config.age.secrets."AlexL-password.txt".path}
      '';
      autoStart = true;
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
    extraGroups = [ "wheel" ];
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
