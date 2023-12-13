{ self, pkgs, ... }:
{
  imports = [
    ../../modules/hm/common.nix
  ];

  nixpkgs.overlays = [
    self.overlays.default
    (import ./nixGL.nix { inherit self; })
  ];

  targets.genericLinux.enable = true;

  stylix.image = ../../images/asian-neon-night.jpg;

  home = {
    packages = with pkgs; [
      spotify
      discord
      viber
      eagle
    ];

    username = "veritas";
    homeDirectory = "/home/veritas";

    stateVersion = "23.05";
  };
}
