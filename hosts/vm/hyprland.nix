{
  imports = [
    ./common.nix
  ];

  programs = {
    hyprland.enable = true;
  };

  home-manager.users.veritas.imports = [
    ../../homes/veritas_qemu_vm/hyprland.nix
  ];
}
