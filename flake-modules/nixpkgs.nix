{ inputs, ... }:
{
  flake-file.inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.self.overlays.default
        ];
        config = {
          allowUnfree = true;
          segger-jlink.acceptLicense = true;
          permittedInsecurePackages = [
            "segger-jlink-qt4-874"
          ];
        };
      };
    };
}
