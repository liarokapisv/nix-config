{ inputs, lib, ... }:
{
  flake-file.inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  flake-file.inputs.nixpkgs.url = lib.mkForce "https://flakehub.com/f/NixOS/nixpkgs/0";

  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.determinate.nixosModules.default
      ];
    };
}
