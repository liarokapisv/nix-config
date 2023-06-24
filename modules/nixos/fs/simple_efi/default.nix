{ self, config, lib, ... }:
{
  imports = [
    self.inputs.disko.nixosModules.disko
  ];

  options = {
    disk-format.device = lib.mkOption {
      type = lib.types.path;
      default = "/dev/vda";
      description = lib.mdDoc "
        Specifies the disk device for the disko config
      ";
    };
  };

  config = {
    disko.devices = import ./schema.nix { device = config.disk-format.device; };
  };
}
