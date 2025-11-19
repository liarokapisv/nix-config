{ self, ... }:
{
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {

      imports = [
        self.inputs.nix-index-database.homeModules.nix-index
        self.modules.homeManager.realsense
        self.modules.homeManager.networking
        self.modules.homeManager.bluetooth
        self.modules.homeManager.embedded
        self.modules.homeManager.pipewire
        self.modules.homeManager.hyprland
        self.modules.homeManager.configs
        self.modules.homeManager.styling
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
          nixfmt-rfc-style
          treefmt
          bitwarden-cli
          jq
          xxd
          tldr
          nix-tree
        ];
      };
    };
}
