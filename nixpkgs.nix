{ inputs, ... }:
{
  flake-file.inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  perSystem =
    {
      config,
      system,
      lib,
      ...
    }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs.nix"
      ];

      options.nixpkgs = {
        permittedInsecurePackages =
          with lib;
          mkOption {
            type = with types; listOf str;
            default = [ ];
          };
      };

      config.nixpkgs = {
        hostPlatform = system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = config.nixpkgs.permittedInsecurePackages;
        };
      };
    };
}
