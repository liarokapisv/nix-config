{ inputs, ... }:
{
  flake-file.inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.determinate.nixosModules.default
      ];
    };
}
