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

  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {

      imports = [
        self.inputs.nix-index-database.homeModules.nix-index
      ];

      systemd.user.startServices = true;

      programs = {
        tmux.enable = true;
        home-manager.enable = true;
        neovim.enable = true;
        zsh.enable = true;
        ssh.enable = true;
        firefox.enable = true;
        direnv.enable = true;
        fzf.enable = true;
        kitty.enable = true;
        git.enable = true;
        zathura.enable = true;
        feh.enable = true;
      };

      home = {
        packages = with pkgs; [
          devenv
          ripgrep
          tree
          reaper
          vlc
          cachix
          pcmanfm
          xarchiver
          p7zip
          file
          nil
          nixfmt
          treefmt
          bitwarden-cli
          jq
          xxd
          tldr
          nix-tree
          lsof
          duf
          pinta
          opencode
          mdcat
        ];
      };
    };

}
