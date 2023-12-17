{ self, pkgs, ... }: {

  imports = [
    self.inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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

  users.mutableUsers = true;

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
  };

  fonts = {
    fontconfig.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
  ];
}
