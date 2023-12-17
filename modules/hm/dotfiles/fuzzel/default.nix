{ config, lib, ... }: {
  config = lib.mkIf (config.programs.fuzzel.enable) {
    programs.fuzzel = {
      settings = {
        main = lib.mkIf (config.programs.kitty.enable) {
          terminal = "kitty";
        };
      };
    };
  };
}
