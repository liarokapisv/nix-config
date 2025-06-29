{
  self,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
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
  }
  (lib.mkIf (self ? user) {
    users.users.${self.user} = {
      extraGroups = [
        "docker"
      ];
    };
    users.groups.libvirtd.members = [
      self.user
    ];
  })
]
