{
  self,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  {
    virtualisation.libvirtd.enable = true;
    virtualisation.docker.enable = true;
    programs.virt-manager.enable = true;
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
  })
]
