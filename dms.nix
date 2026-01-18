{ self, ... }:
{
  # Add DMS flake inputs (following niri.nix pattern)
  flake-file.inputs.dms = {
    url = "github:AvengeMedia/DankMaterialShell/stable";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Add plugin registry for community plugins
  flake-file.inputs.dms-plugin-registry = {
    url = "github:AvengeMedia/dms-plugin-registry";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Define DMS home-manager module
  flake.modules.homeManager.dms = {
    imports = [
      self.inputs.dms.homeModules.dank-material-shell
      self.inputs.dms.homeModules.niri
      self.inputs.dms-plugin-registry.modules.default
    ];
  };
}
