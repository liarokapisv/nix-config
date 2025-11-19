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
  options.home-configurations = mkOption {
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
    flake-file.inputs.home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake.modules.homeManager.base = { };

    flake.homeConfigurations = lib.concatMapAttrs (name: cfg: {
      "${name}" = withSystem (cfg.system) (
        { pkgs, ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            config.flake.modules.homeManager.base
          ]
          ++ cfg.modules;
        }
      );
    }) config.home-configurations;
  };
}
