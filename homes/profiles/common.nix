{ pkgs, ... }: {

  imports = [
    ../../modules/home-manager
    ../../configs/home-manager
    ../profiles/styling.nix
  ];

  nixpkgs.config.allowUnfree = true;

  systemd.user.startServices = true;

  programs = {
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
    thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };
  };

  home = {
    packages = with pkgs; [
      devenv
      ripgrep
      tree
      stremio
      reaper
      cachix
      pcmanfm
      xarchiver
      p7zip
      file
      bitwarden-cli
    ];
  };
}
