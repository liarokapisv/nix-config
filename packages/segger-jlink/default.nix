{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  udev,
  config,
  acceptLicense ? config.segger-jlink.acceptLicense or false,
  fontconfig,
  xorg,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  supported = {
    x86_64-linux = {
      name = "x86_64";
      hash = "sha256-BuLwiszQfdQJdTdMUbOqflYG4zU3HHMDf+JejvIQkps=";
    };
    i686-linux = {
      name = "i386";
      hash = "sha256-Z78NLXXZPz/i/shP4gbQqldiE/eAkLgi4JzIf8Sy19k=";
    };
    aarch64-linux = {
      name = "arm64";
      hash = "sha256-hF3cBCRDRwvVudafOFFdD0pEIjoYWjiJtVz7vgtclx8=";
    };
    armv7l-linux = {
      name = "arm";
      hash = "sha256-KUpP6aNh7e3HA/X3Mov3nz3didcKMUaIAaFA5cYd2Kg=";
    };
  };

  platform = supported.${stdenv.system} or (throw "unsupported platform ${stdenv.system}");

  version = "792m";

  url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_${platform.name}.tgz";

  src =
    assert
      !acceptLicense
      -> throw ''
        Use of the "SEGGER JLink Software and Documentation pack" requires the
        acceptance of the following licenses:

          - SEGGER Downloads Terms of Use [1]
          - SEGGER Software Licensing [2]

        You can express acceptance by setting acceptLicense to true in your
        configuration. Note that this is not a free license so it requires allowing
        unfree licenses as well.

        configuration.nix:
          nixpkgs.config.allowUnfree = true;
          nixpkgs.config.segger-jlink.acceptLicense = true;

        config.nix:
          allowUnfree = true;
          segger-jlink.acceptLicense = true;

        [1]: ${url}
        [2]: https://www.segger.com/purchase/licensing/
      '';
    fetchurl {
      inherit url;
      inherit (platform) hash;
      curlOpts = "--data accept_license_agreement=accepted";
    };

  qt4-bundled = stdenv.mkDerivation {
    pname = "segger-jlink-qt4";
    inherit src version;

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      stdenv.cc.cc.lib
      fontconfig
      xorg.libXrandr
      xorg.libXfixes
      xorg.libXcursor
      xorg.libSM
      xorg.libICE
      xorg.libX11
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Install libraries
      mkdir -p $out/lib
      mv libQt* $out/lib

      runHook postInstall
    '';
  };

in
stdenv.mkDerivation {
  pname = "segger-jlink";
  inherit src version;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [ qt4-bundled ];

  # Udev is loaded late at runtime
  appendRunpaths = [ "${udev}/lib" ];

  dontConfigure = true;
  dontBuild = true;

  desktopItems =
    map
      (
        entry:
        (makeDesktopItem {
          name = entry;
          exec = entry;
          icon = "applications-utilities";
          desktopName = entry;
          genericName = "SEGGER ${entry}";
          categories = [ "Development" ];
          type = "Application";
          terminal = false;
          startupNotify = false;
        })
      )
      [
        "JFlash"
        "JFlashLite"
        "JFlashSPI"
        "JLinkConfig"
        "JLinkGDBServer"
        "JLinkLicenseManager"
        "JLinkRTTViewer"
        "JLinkRegistration"
        "JLinkRemoteServer"
        "JLinkSWOViewer"
        "JLinkUSBWebServer"
        "JMem"
        "JScope"
      ];

  installPhase = ''
    runHook preInstall

    # Install binaries and runtime files into /opt/
    mkdir -p $out/opt
    mv J* ETC GDBServer Firmwares $out/opt

    # Link executables into /bin/
    mkdir -p $out/bin
    for binr in $out/opt/*Exe; do
      binrlink=''${binr#"$out/opt/"}
      ln -s $binr $out/bin/$binrlink
      # Create additional symlinks without "Exe" suffix
      binrlink=''${binrlink/%Exe}
      ln -s $binr $out/bin/$binrlink
    done

    # Copy special alias symlinks
    for slink in $(find $out/opt/. -type l); do
      cp -P -n $slink $out/bin || true
      rm $slink
    done

    # Install libraries
    mkdir -p $out/lib
    mv libjlinkarm.so* $out/lib
    # This library is opened via dlopen at runtime
    for libr in $out/lib/*; do
      ln -s $libr $out/bin
      ln -s $libr $out/opt
    done

    # Install docs and examples
    mkdir -p $out/share/docs
    mv Doc/* $out/share/docs
    mkdir -p $out/share/examples
    mv Samples/* $out/share/examples

    # Install udev rule
    mkdir -p $out/lib/udev/rules.d
    mv 99-jlink.rules $out/lib/udev/rules.d/

    runHook postInstall
  '';

  meta = with lib; {
    description = "J-Link Software and Documentation pack";
    homepage = "https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [
      FlorianFranzen
      stargate01
    ];
  };
}
