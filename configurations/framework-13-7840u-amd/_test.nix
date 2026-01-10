{
  config,
  lib,
  ...
}:
{
  options = {
    test = {
      enable = lib.mkEnableOption "test";
    };
  };

  config =
    let
      cfg = config.test;
    in
    lib.mkIf (cfg.enable) ({
      systemd.services = { };
    });
}
