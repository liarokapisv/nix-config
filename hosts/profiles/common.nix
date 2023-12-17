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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
  };

  networking.useDHCP = false;

  users.mutableUsers = true;

  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    fuse.userAllowOther = true;
  };

  networking = {
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  time.timeZone = "Europe/Athens";

  security.rtkit.enable = true;

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
