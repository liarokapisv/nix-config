{
  imports = [
    ./common.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  programs.dconf.enable = true;

  home-manager.users.veritas.imports = [
    ../../homes/veritas_qemu_vm/plasma.nix
  ];
}
