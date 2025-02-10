{ self, pkgs, ... }:
{

  imports = [ self.inputs.home-manager.nixosModules.home-manager ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ self.overlays.default ];
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

  services = {
    openssh.enable = true;
    udev.packages = with pkgs; [
      segger-jlink
      openocd
    ];
  };

  fonts = {
    fontconfig.enable = true;
  };

  users.users.${self.user} = {
    extraGroups = [
      "plocate"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    plocate
    ltrace
    usbutils
    powertop
  ];
}
