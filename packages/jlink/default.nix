{ system
, lib
, stdenvNoCC
, requireFile
, autoPatchelfHook
, patchelf
, dpkg
, xorg
, fontconfig
, libudev0-shim
}:

let
  meta = {
    homepage = "https://www.segger.com/";
    description = "Segger JLink software & documentation pack for Linux";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ liarokapisv ];
  };

  version = "V7.92k";
  versionNoDots = lib.strings.replaceStrings [ "." ] [ "" ] version;

  variants = {
    x86_64-linux = {
      name = "JLink_Linux_${versionNoDots}_x86_64.deb";
      sha256 = "sha256-MTPG0HeAcwOTHEHtqR/uOjuEu13UrTxQyX6zvwrDAoA=";
    };
  };

  src =
    let
      variant = variants.${system};
      name = variant.name;
      sha256 = variant.sha256;
      url = " https://www.segger.com/downloads/jlink/${name}";
    in
    (requireFile {
      inherit name;
      inherit sha256;
      inherit url;
    }).overrideAttrs (super: {
      passthru = (super.passthru or { }) // {
        inherit sha256;
        inherit url;
      };
    });
in
stdenvNoCC.mkDerivation
{
  pname = "jlink";

  inherit version;
  inherit src;
  inherit meta;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    patchelf
  ];

  buildInputs = [
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcursor
    xorg.libX11
    xorg.libSM
    xorg.libICE
    fontconfig.lib
  ];

  desktopApps = [
    "JFlash"
    "JFlashLite"
    "JFlashSPI"
    "JLinkConfig"
    "JLink"
    "JLinkGDBServer"
    "JLinkGUIServer"
    "JLinkLicenseManager"
    "JLinkRegistration"
    "JLinkRemoteServer"
    "JLinkRTTClient"
    "JLinkRTTLogger"
    "JLinkRTTViewer"
    "JLinkSTM32"
    "JLinkSWOViewer"
    "JMem"
    "JRun"
    "JTAGLoad"
  ];

  installPhase = ''
    dpkg-deb -x $src $out

    mkdir -p $out/bin

    # Soothe nix-build "suspicions"
    chmod -R g-w $out

    # Remove global symlinks
    rm -R $out/usr

    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps

    ln -s ${./JLink.svg} $out/share/pixmaps/JLink.svg

    for path in $out/opt/SEGGER/JLink_${versionNoDots}/J*
    do
      name=$(basename "$path")
      ln -s "$out/opt/SEGGER/JLink_${versionNoDots}/$name" "$out/bin/$name"
    done

    for name in $desktopApps
    do
        cat << EOF > "$out/share/applications/$name.desktop"
    [Desktop Entry]
    Type=Application
    Name=$name
    Exec=''${name}Exe
    Icon=JLink
    Terminal=false
    StartupNotify=false
    Categories=Development
    EOF
        chmod +x "$out/share/applications/$name.desktop"
    done
  '';

  postFixup = ''
    # needed due to dlopen
    patchelf --add-rpath "${libudev0-shim}/lib" $out/opt/SEGGER/JLink_${versionNoDots}/libjlinkarm.so
  '';
}
