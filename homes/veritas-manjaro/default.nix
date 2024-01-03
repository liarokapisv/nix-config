{ self, pkgs, ... }:
{
  imports = [
    ../profiles/common.nix
    ../profiles/styling.nix
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

    username = self.user;
    homeDirectory = "/home/${self.user}";

    stateVersion = "23.05";
  };
}
