{ inputs, ... }:
{
  flake-file.inputs.nixpkgs-libcef.url = "github:NixOS/nixpkgs/de69d2ba6c70e747320df9c096523b623d3a4c35";

  perSystem =
    { system, ... }:
    {
      packages.libcef = inputs.nixpkgs-libcef.legacyPackages.${system}.libcef;
    };
}
