{ config, lib, ... }: {
  options.home.fuzzel = {
    enable = lib.mkEnableOption "fuzzel";
  };

  config = lib.mkIf (config.home.fuzzel.enable) {
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
