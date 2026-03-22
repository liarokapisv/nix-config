{
  perSystem =
    { pkgs, ... }:
    {
      packages.creality-print = pkgs.callPackage (
        {
          appimageTools,

          fetchurl,
        }:
        let
          pname = "creality-print";
          version = "7.0.0";
          src = fetchurl {
            url = "https://github.com/CrealityOfficial/CrealityPrint/releases/download/v7.0.0/CrealityPrint-V7.0.0.4127-x86_64-Release.AppImage";
            hash = "sha256-J3oVSp6mR5qmm9zNcFQTqK+A0XAJSmVYzC3hKWQOjr4=";
          };
        in
        appimageTools.wrapAppImage {
          inherit pname version;
          src = appimageTools.extract {
            inherit pname version src;
            postExtract = ''
              # The AppRun script sets LD_LIBRARY_PATH to only $DIR/bin:$DIR/usr/lib,
              # which prevents the FHS environment's system libraries from being found.
              # Patch it to also include the standard system library paths.
              substituteInPlace $out/AppRun \
                --replace-fail 'export LD_LIBRARY_PATH="$DIR/bin:$DIR/usr/lib"' \
                                'export LD_LIBRARY_PATH="$DIR/bin:$DIR/usr/lib:/usr/lib:/usr/lib64"'
            '';
          };
          extraPkgs = pkgs: [
            pkgs.libdeflate
            pkgs.zstd
            pkgs.libsoup_3
            pkgs.webkitgtk_4_1
          ];
        }
      ) { };
    };
}
