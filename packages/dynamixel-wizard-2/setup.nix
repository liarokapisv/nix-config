{
  lib,
  stdenvNoCC,
  fetchurl,
  libgcc,
  libxkbcommon,
  xorg,
  dbus,
  freetype,
  fontconfig,
  autoPatchelfHook,
}:
stdenvNoCC.mkDerivation {
  name = "DynamixelWizard2Setup";
  src = fetchurl {
    url = "https://www.dropbox.com/s/csawv9qzl8m8e0d/DynamixelWizard2Setup-x86_64?dl=1";
    hash = "sha256-AR9L3j0qIVNOV65rIBta30qOwiPuqKA88680UaBstPY=";
    name = "DynamixelWizard";
    downloadToTemp = true;
    executable = true;
    postFetch = ''
      install -D $downloadedFile $out/SetupDynamixelWizard2
    '';
  };

  dontStrip = true;

  nativeBuildInputs = [
    libgcc.lib
    libxkbcommon
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libxcb
    xorg.libX11
    dbus.lib
    freetype
    fontconfig.lib
    autoPatchelfHook
  ];

  installPhase = "
    mkdir -p $out/bin
    cp SetupDynamixelWizard2 $out/bin/SetupDynamixelWizard2
  ";

  meta.platforms = lib.platforms.linux;
}
