{ pkgs, ... }:
{
  home.packages = [
    (pkgs.librealsense-gui.overrideAttrs (old: {
      patches = old.patches ++ [
        # TODO: try to upstream this
        ./force-x11.patch
      ];
    }))
  ];
}
