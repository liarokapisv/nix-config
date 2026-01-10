{ self, ... }:
{
  flake.modules.nixos.base =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {

      imports = [
        self.inputs.home-manager.nixosModules.home-manager
      ];

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

      boot.tmp.cleanOnBoot = true;

      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit self; };
      };

      users = {
        mutableUsers = true;
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

      services = {
        automatic-timezoned.enable = true;
        openssh.enable = true;
      };

      fonts = {
        fontconfig.enable = true;
      };

      environment.systemPackages = with pkgs; [
        wget
        ltrace
        usbutils
        powertop
      ];
    };
}
