{
  config,
  withSystem,
  inputs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.configurations = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          system = mkOption { type = types.str; };
          modules = mkOption { type = types.listOf types.deferredModule; };
        };
      }
    );
  };

  config = {
    flake.modules.nixos.base = { };
    flake.nixosConfigurations = lib.concatMapAttrs (name: cfg: {
      "${name}" = withSystem (cfg.system) (
        { pkgs, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            config.flake.modules.nixos.base
          ]
          ++ cfg.modules;
        }
      );
    }) config.configurations;
  };
}
