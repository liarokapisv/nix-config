{ config, lib, ... }: {
  options.dotfiles.fuzzel = {
    enable = lib.mkEnableOption "fuzzel";
  };

  config = lib.mkIf (config.dotfiles.fuzzel.enable) {
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          terminal = "kitty";
        };
      };
    };
  };
}
