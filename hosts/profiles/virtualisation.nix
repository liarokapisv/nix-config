{ self, lib, ... }:

lib.mkMerge [
  {
    virtualisation.libvirtd.enable = true;
    virtualisation.docker.enable = true;
    programs.virt-manager.enable = true;
  }
  (lib.mkIf (self ? user) {
    users.users.${self.user} = {
      extraGroups = [
        "docker"
      ];
    };
  })
]
