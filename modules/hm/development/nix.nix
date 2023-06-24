{ config, lib, pkgs, ... }: {
  options = {
    home.development.nix.enable = lib.mkEnableOption "nix development tools";
  };

  config = lib.mkIf (config.home.development.nix.enable) {
    programs.neovim.extraPackages = with pkgs; [

      # LSP
      nil

      # for formatting
      nixpkgs-fmt

    ];
  };
}
