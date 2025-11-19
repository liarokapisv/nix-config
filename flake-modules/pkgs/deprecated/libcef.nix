{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      packages.libcef = inputs.nixpkgs-libcef.legacyPackages.${system}.libcef;
    };
}
