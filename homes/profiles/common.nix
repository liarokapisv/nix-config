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
  };

  home = {
    packages = with pkgs; [
      ripgrep
      tree
      vmpk
      stremio
      reaper
      segger-jlink
      stm32cubemx
      conan
      #kicad
    ];
  };
}
