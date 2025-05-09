{ self, pkgs, ... }:
{
  imports = [
    ../profiles/common.nix
    ../../common/nixpkgs.nix
    ../../common/registry.nix
  ];

  targets.genericLinux.enable = true;

  stylix = {
    image = ../../images/mountain-music.gif;
    targets.kde.enable = false;
  };

  home = {
    packages = with pkgs; [
      spotify
      discord
      viber
      eagle
      anydesk
      slack
      discord
      teams-for-linux
      zoom-us
      xclip
    ];

    username = self.user;
    homeDirectory = "/home/${self.user}";

    stateVersion = "24.11";
  };
}
