{ inputs, ... }:
{
  flake-file.inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  perSystem =
    {
      system,
      ...
    }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs.nix"
      ];

      config = {
        nixpkgs = {
          hostPlatform = system;
          config.allowUnfree = true;
        };
      };
    };
}
