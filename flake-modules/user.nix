{
  flake.modules.nixos.base =
    { lib, ... }:
    {
      options = {
        user = lib.mkOption { type = lib.types.str; };
      };
    };
}
