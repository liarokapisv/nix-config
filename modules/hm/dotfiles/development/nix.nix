{ config, lib, pkgs, ... }: {
  options = {
    dotfiles.development.nix.enable = lib.mkEnableOption "nix development tools";
  };

  config = lib.mkIf (config.dotfiles.development.nix.enable) {
    programs.neovim.extraPackages = with pkgs; [

      # LSP
      nil

      # for formatting
      nixpkgs-fmt

    ];
  };
}
