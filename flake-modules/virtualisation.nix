{
  flake.modules.nixos.virtualisation =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
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
      users.users.${config.user} = {
        extraGroups = [
          "docker"
        ];
      };
      users.groups.libvirtd.members = [
        config.user
      ];
    };
}
