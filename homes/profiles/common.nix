{ self, pkgs, ... }:
{

  imports = [
    ../../modules/home-manager
    ../../configs/home-manager
    ../profiles/styling.nix
    self.inputs.nix-index-database.hmModules.nix-index
  ];

  systemd.user.startServices = true;
  nixpkgs.config.allowUnfree = true;

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
      stremio
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
      (bitwarden-cli.overrideAttrs (old: {
        # TODO: Remove when fixed upstream.
        dontCheckForBrokenSymlinks = true;
      }))
      ventoy
      jq
      xxd
      tldr
      nix-tree
    ];
  };
}
