{ self, pkgs, ... }: {

  imports = [
    self.inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than +10";
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
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    fuse.userAllowOther = true;
  };


  time.timeZone = "Europe/Athens";

  services = {
    openssh.enable = true;
    flatpak.enable = true;
    udev.packages = with pkgs; [
      segger-jlink
    ];
  };

  fonts = {
    fontconfig.enable = true;
  };

  users.users.${self.user} = {
    extraGroups = [ "plocate" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    plocate
  ];
}
