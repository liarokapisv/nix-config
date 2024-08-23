{ self, pkgs, ... }: {

  imports = [
    self.inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      auto-optimise-store = true;

      # enables devenv cache
      extra-substituters = [ "https://devenv.cachix.org" ];
      extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
    ];
  };

  boot.tmp.cleanOnBoot = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
  };

  users = {
    mutableUsers = true;
    groups = {
      plocate = { };
    };
  };

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    fuse.userAllowOther = true;
    htop.enable = true;
  };


  time.timeZone = "Europe/Athens";

  virtualisation.docker.enable = true;

  services = {
    openssh.enable = true;
    udev.packages = with pkgs; [
      segger-jlink
      openocd
    ];
    zerotierone = {
      enable = true;
      joinNetworks = [
        "db64858fed5b04bb"
      ];
    };
  };

  fonts = {
    fontconfig.enable = true;
  };

  users.users.${self.user} = {
    extraGroups = [ "plocate" "docker" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    plocate
    ltrace
  ];
}
