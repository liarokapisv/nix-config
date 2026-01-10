inputs:
inputs.flake-parts.lib.mkFlake { inherit inputs; } (
  { lib, ... }:
  lib.pipe inputs.import-tree [
    (i: i.filterNot (lib.hasSuffix "flake.nix"))
    (i: i.filterNot (lib.hasSuffix "outputs.nix"))
    (i: i ./.)
  ]
)
