{ ... }:
{
  flake.modules.nixos.plocate =
    { pkgs, lib, ... }:
    {
      options.services.plocate.requiredGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Groups required for plocate access";
      };

      config = {
        services.plocate.requiredGroups = [ "plocate" ];

        users.groups.plocate = { };

        environment.systemPackages = [ pkgs.plocate ];
      };
    };
}
