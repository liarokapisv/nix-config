{ callPackage, buildFHSEnv }:
let
  unwrapped = callPackage ./unwrapped.nix { };
in
buildFHSEnv
{
  name = unwrapped.name;
  meta = unwrapped.meta;

  targetPkgs = p: with p;
    [
      (p.callPackage ./unwrapped.nix { })
      # needed because of hard-coded lookup to /usr/share/X11/xkb
      xorg.xkeyboardconfig
      # needed because of hard-coded lookup to /usr/share/fonts
      open-fonts
      # needed for xdg-mime - improves startup time
      xdg-utils
    ];

  runScript = "/bin/Viber";
  extraInstallCommands = ''
    mv $out/bin/${unwrapped.name} $out/bin/Viber
    ln -s ${unwrapped}/share $out/share
  '';
  passthru = {
    inherit unwrapped;
  };
}
