{ pkgs, lib, buildFHSEnv }:
let
  pname = "viber";
  version = "20.3.0.1";
  meta = {
    homepage = "https://www.viber.com";
    description = "An instant messaging and Voice over IP (VoIP) app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ jagajaga liarokapisv ];
  };
  unwrappedPackage =
    { lib
    , fetchurl
    , makeBinaryWrapper
    , autoPatchelfHook
    , libz
    , dpkg
    , alsa-lib
    , nss
    , gst_all_1
    , stdenvNoCC
    , xorg
    , lcms
    , libwebp
    , snappy
    , gdk-pixbuf
    , libmng
    , gtk3
    , pango
    , libtiff
    , tslib
    , libopus
    , libudev0-shim
    , mtdev
    , libxslt
    , pciutils
    , libpulseaudio
    }:

    stdenvNoCC.mkDerivation {

      inherit pname version meta;

      src = fetchurl {
        # Official link: https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
        url = "https://web.archive.org/web/20230906015353/https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
        sha256 = "03h8k73b5lngpddkww8z8wdg1lrnn4rncwr9v69acsw1j1hplf30";
      };

      # These are needed due to failing dlopen calls.
      # Not all of these may be strictly required.
      appendRunpaths = [
        "${libudev0-shim}/lib"
        "${libpulseaudio}/lib"
        "${pciutils}/lib"
      ];

      nativeBuildInputs = [
        autoPatchelfHook
        dpkg
        makeBinaryWrapper
      ];

      buildInputs = [
        libopus
        alsa-lib
        nss
        gst_all_1.gst-plugins-bad
        xorg.libXScrnSaver
        xorg.libX11
        xorg.xkeyboardconfig
        xorg.libXext
        xorg.libxshmfence
        xorg.libxkbfile
        xorg.libXrandr
        xorg.libxcb
        xorg.xcbutilwm
        xorg.xcbutilimage
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        xorg.libXtst
        libwebp
        snappy
        gdk-pixbuf
        libmng
        gtk3
        libtiff
        pango
        lcms
        libz
        tslib
        mtdev
        libxslt
      ];

      installPhase =
        let
          gstreamerPluginPath = lib.makeSearchPath "lib/gstreamer-1.0/" [
            gst_all_1.gstreamer.out
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-plugins-bad
          ];
        in
        ''
          dpkg-deb -x $src $out
          mkdir -p $out/bin

          # Soothe nix-build "suspicions"
          chmod -R g-w $out

          # GST_PLUGIN_SYSTEM_PATH is specified because Qt6's QGStreamerMediaPlayer calls
          # gst_element_factory_make which in turn uses the env variable to perform the lookup.
          # Qt6 uses the returned object without checking for NULL which will lead to a SEGFAULT.

          wrapProgram $out/opt/viber/Viber \
          --set QT_PLUGIN_PATH "$out/opt/viber/plugins" \
          --set QML2_IMPORT_PATH "$out/opt/viber/qml" \
          --set XDG_DATA_DIRS "out/share" \
          --set GST_PLUGIN_SYSTEM_PATH "${gstreamerPluginPath}" \

          ln -s $out/opt/viber/Viber $out/bin/Viber

          mv $out/usr/share $out/share
          rm -rf $out/usr

          # Fix the desktop link
          substituteInPlace $out/share/applications/viber.desktop \
            --replace /opt/viber/Viber Viber \
            --replace /usr/share/ $out/share/
        '';

      preFixup = ''
        # Ugly hack, libtiff.so.5 is not in nixpkgs. Does not seem to break anything.
        patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/viber/plugins/imageformats/libqtiff.so
      '';
    };
  package =
    buildFHSEnv
      {
        name = "${pname}-${version}";

        inherit meta;
        targetPkgs = pkgs: with pkgs;
          [
            (callPackage unwrappedPackage { })
            # needed because of hard-coded lookup to /usr/share/X11/xkb
            xorg.xkeyboardconfig
            # needed because of hard-coded lookup to /usr/share/fonts
            open-fonts
            # needed for xdg-mime - improves startup time
            xdg-utils
          ];
        runScript = "/bin/Viber";
        extraInstallCommands = ''
          mv $out/bin/${pname}-${version} $out/bin/Viber
          ln -s ${package.unwrapped}/share $out/share
        '';
        passthru = {
          unwrapped = pkgs.callPackage unwrappedPackage { };
        };
      };
in
package
