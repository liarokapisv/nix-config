{ self, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    self.inputs.apple-silicon.nixosModules.default
    ../profiles/common.nix
    ../profiles/pipewire.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "overlay";

    };
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  networking.hostName = "m1-pro";

  users.users.${self.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ];
    initialHashedPassword = "$6$JwTimdf683A1QxN.$aorlpRJPWrcsl0pR1nlELJhdy8traiVPBXnwXU5IfEbWBD5PusIrkjRZDA76OJECmJdR9PLiUyxJeQUzjX6Nv0";

    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHQE3nquLEwnEU5NdU1YZ1LBLCIq4gaLgMF+TvnL9vV veritas@veritas"
    ];
  };

  home-manager.users.${self.user} = {
    imports = [
      ../../modules/hm/common.nix
    ];
    stylix.image = ../../images/mountain-music.gif;

    programs = {
      waybar.enable = true;
      fuzzel.enable = true;
      swww.enable = true;
      swww.systemd = {
        enable = true;
      };
      waybar.systemd = {
        target = "hyprland-session.target";
      };
    };

    home = {
      packages = with pkgs; [
        qbittorrent
        vlc
      ];

      stateVersion = "23.11";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        exec-once="amixer -c 0 set 'Jack DAC' 100%"
      '';
    };
  };

  programs = {
    hyprland.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
  };

  system.stateVersion = "23.11";
}
