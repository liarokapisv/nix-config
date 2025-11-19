{ inputs, ... }:
{
  flake-file.inputs.make-shell.url = "github:nicknovitski/make-shell";
  imports = [ inputs.make-shell.flakeModules.default ];
  perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = [ pkgs.opencode ];
    };
}
