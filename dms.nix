{ self, ... }:
{
  # Add DMS flake inputs (following niri.nix pattern)
  flake-file.inputs.dms = {
    url = "github:AvengeMedia/DankMaterialShell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Add plugin registry for community plugins
  flake-file.inputs.dms-plugin-registry = {
    url = "github:AvengeMedia/dms-plugin-registry";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Track the flake input rather than nixpkgs's pinned v1.4.6 tag, whose
  # bundled greeter heredoc has `debug { keep-max-bpc-unchanged }` and is
  # rejected by recent niri. Mirrors the niri-flake overlay pattern.
  perSystem =
    { system, ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          dms-shell = self.inputs.dms.packages.${system}.dms-shell;
        })
      ];
    };

  # Define DMS home-manager module
  flake.modules.homeManager.dms = {
    imports = [
      self.inputs.dms.homeModules.dank-material-shell
      self.inputs.dms.homeModules.niri
      self.inputs.dms-plugin-registry.homeModules.default
    ];
  };
}
