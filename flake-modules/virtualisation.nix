{
  flake.modules.nixos.virtualisation =
    { lib, pkgs, ... }:
    {
      options.virtualisation.requiredGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Groups required for virtualisation access";
      };

      config = {
        virtualisation.requiredGroups = [
          "docker"
          "libvirtd"
        ];

        virtualisation.libvirtd.enable = true;
        networking.firewall.trustedInterfaces = [ "virbr0" ];
        programs.virt-manager.enable = true;

        virtualisation.docker = {
          enable = true;
          package = pkgs.docker_28;
        };
        environment.systemPackages = [
          pkgs.bottles
          pkgs.distrobox
        ];
      };
    };
}
