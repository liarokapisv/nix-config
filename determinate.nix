{ inputs, lib, ... }:
{
  flake-file.inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  flake-file.inputs.nixpkgs = lib.mkForce {
    follows = "determinate/nixpkgs";
  };

  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.determinate.nixosModules.default
      ];
    };
}
