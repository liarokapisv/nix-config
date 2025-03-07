{ self, pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ self.overlays.default ];
  };
}
