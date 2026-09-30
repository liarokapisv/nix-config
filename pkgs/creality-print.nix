{
  perSystem =
    { pkgs, ... }:
    {
      packages.creality-print = pkgs.callPackage (
        {
          lib,
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

          appimageContents = appimageTools.extract {
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
        in
        appimageTools.wrapAppImage {
          inherit pname version;
          src = appimageContents;

          extraPkgs = pkgs: [
            pkgs.libdeflate
            pkgs.zstd
            pkgs.libsoup_3
            pkgs.webkitgtk_4_1
          ];

          # The AppImage ships a .desktop file and icon but wrapAppImage does not
          # install them. Copy them into the FHS-env output and point Exec at the
          # wrapped binary (default is the AppImage's `AppRun`).
          extraInstallCommands = ''
            install -Dm444 ${appimageContents}/CrealityPrint.desktop \
              $out/share/applications/CrealityPrint.desktop
            install -Dm444 ${appimageContents}/usr/share/icons/hicolor/192x192/apps/CrealityPrint.png \
              $out/share/icons/hicolor/192x192/apps/CrealityPrint.png
            substituteInPlace $out/share/applications/CrealityPrint.desktop \
              --replace-fail 'Exec=AppRun' 'Exec=${pname}'
          '';

          meta = {
            description = "3D printing slicer software from Creality";
            homepage = "https://www.creality.com/pages/download-creality-print";
            license = lib.licenses.unfree;
            maintainers = [ lib.maintainers.liarokapisv ];
            platforms = [ "x86_64-linux" ];
            mainProgram = pname;
          };
        }
      ) { };
    };
}
