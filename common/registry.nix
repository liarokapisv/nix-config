{ self, ... }:
{
  nix.registry.nixpkgs.flake = self.inputs.nixpkgs;
}
