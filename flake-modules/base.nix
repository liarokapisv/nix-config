{ self, ... }:
{
  flake.modules.nixos.base =
    { config, pkgs, ... }:
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
        users.${config.user} = {
          imports = [
            self.modules.homeManager.base
          ];
        };
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

      services = {
        automatic-timezoned.enable = true;
        openssh.enable = true;
      };

      fonts = {
        fontconfig.enable = true;
      };

      users.users.${config.user} = {
        extraGroups = [
          "plocate"
        ];
      };

      environment.systemPackages = with pkgs; [
        wget
        plocate
        ltrace
        usbutils
        powertop
      ];
    };
}
