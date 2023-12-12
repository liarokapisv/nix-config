{ self, pkgs, ... }:
{

  imports = [
    ./hardware.nix
    self.inputs.apple-silicon.nixosModules.default
    ../../modules/nixos/common.nix
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

  sound.enable = true;

  services = {
    mpd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };

  networking.hostName = "veritas-m1-pro";

  users.users.veritas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$JwTimdf683A1QxN.$aorlpRJPWrcsl0pR1nlELJhdy8traiVPBXnwXU5IfEbWBD5PusIrkjRZDA76OJECmJdR9PLiUyxJeQUzjX6Nv0";

    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHQE3nquLEwnEU5NdU1YZ1LBLCIq4gaLgMF+TvnL9vV veritas@veritas"
    ];
  };

  home-manager.users.veritas = {
    imports = [
      ../../modules/hm/common.nix
    ];

    home = {
      hyprland.enable = true;
      waybar.enable = true;
      fuzzel.enable = true;

      stateVersion = "23.11";
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
