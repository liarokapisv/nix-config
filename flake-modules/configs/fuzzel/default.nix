{
  flake.modules.homeManager.config-fuzzel =
    { config, lib, ... }:
    {
      programs.fuzzel = {
        settings = {
          main = lib.mkIf (config.programs.kitty.enable) { terminal = "kitty"; };
        };
      };
    };
}
