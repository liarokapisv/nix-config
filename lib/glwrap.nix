{ self, pkgs }:
let
  wrapGeneric =
    wrap: orig-pkg: execName:
    pkgs.makeOverridable (
      attrs:
      let
        pkg = orig-pkg.override attrs;
        outs = pkg.meta.outputsToInstall;
        paths = pkgs.lib.attrsets.attrVals outs pkg;
        nonTrivialOuts = pkgs.lib.lists.remove "out" outs;
        metaAttributes = pkgs.lib.attrsets.getAttrs (
          [
            "name"
            "pname"
            "version"
            "meta"
          ]
          ++ nonTrivialOuts
        ) pkg;
      in
      pkgs.symlinkJoin (
        {
          inherit paths;
          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          postBuild = ''
            mv $out/bin/${execName} $out/bin/.${execName}-mkWrapped-original
            makeWrapper ${wrap}/bin/${wrap.name} $out/bin/${execName} --add-flags $out/bin/.${execName}-mkWrapped-original
          '';
        }
        // metaAttributes
      )
    ) { };

  glpkgs = self.inputs.nixgl.packages.${pkgs.system};
in
{
  wrapIntel = wrapGeneric glpkgs.nixGLIntel;
}
