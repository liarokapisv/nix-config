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
let
  version = "2.2.3.2";
in
stdenvNoCC.mkDerivation {
  pname = "DynamixelWizard2Setup";
  inherit version;
  src = fetchurl {
    url = "https://archive.org/download/dynamixel-wizard-2-setup-x-64/DynamixelWizard2Setup_x64%286%29";
    hash = "sha256-MMDL18i4Gg1/H6hEZ3REH6Gj/Bz41WNgQ6qWrvdPv3M=";
    pname = "DynamixelWizard";
    inherit version;
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
