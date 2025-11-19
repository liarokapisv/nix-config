{ inputs, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    inputs.flake-file.flakeModules.default
    inputs.flake-parts.flakeModules.modules
  ];

  options = {
    flake.lib = mkOption {
      type = types.attrsOf types.raw;
      default = { };
    };
  };
  config = {
    flake.modules = { };
    flake-file.inputs = {
      flake-file.url = "github:vic/flake-file";
      import-tree.url = "github:vic/import-tree";
      flake-parts.url = "github:liarokapisv/flake-parts/add-key-to-modules-extra";
    };
  };
}
