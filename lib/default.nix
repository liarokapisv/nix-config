{ self, pkgs }: { glwrap = import ./glwrap.nix { inherit self pkgs; }; }
