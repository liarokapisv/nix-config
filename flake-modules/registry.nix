{ self, ... }:
let
  module =
    { ... }:
    {
      nix.registry.nixpkgs.flake = self.inputs.nixpkgs;
    };
in

{
  flake.modules.nixos.base = module;
  flake.modules.homeManager.base = module;
}
