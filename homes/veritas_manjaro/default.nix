{ self, ... }:
{
  nixpkgs.overlays = [
    self.overlays.default
    (import ./nixGL.nix { inherit self; })
  ];

  imports = [
    ../../modules/hm/common.nix
  ];

  home = {
    nvim.enable = true;
    zsh.enable = true;
    development = {
      nix.enable = true;
    };
    ssh.enable = true;
    hyprland.enable = true;
    waybar.enable = true;
    fuzzel.enable = true;
    firefox.enable = true;
  };

  targets.genericLinux.enable = true;

  home = {
    username = "veritas";
    homeDirectory = "/home/veritas";
  };

  home.stateVersion = "23.05";
}
