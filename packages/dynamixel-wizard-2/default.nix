{
  lib,
  stdenvNoCC,
  callPackage,
  autoPatchelfHook,
  libGL,
  libgcc,
  zlib,
  glib,
  libgpg-error,
  expat,
  libdrm,
  freetype,
  fontconfig,
}:
let
  dynamixel-wizard-2-setup = callPackage ./setup.nix { };
in
stdenvNoCC.mkDerivation {
  name = "DynamixelWizard2";
  nativeBuildInputs = [
    dynamixel-wizard-2-setup
    autoPatchelfHook
  ];
  buildInputs = [
    libGL
    libgcc.lib
    zlib
    glib
    libgpg-error
    expat
    libdrm
    freetype
    fontconfig
  ];
  dontWrapQtApps = true;
  dontUnpack = true;
  installPhase = "
    HOME=$(pwd)/home SetupDynamixelWizard2 -c --al --root $out in
    rm $out/libEGL.so.1

    mkdir -p $out/share/applications/
    cp home/.local/share/applications/DynamixelWizard2.desktop $out/share/applications
  ";

  passthru = {
    setup = dynamixel-wizard-2-setup;
  };

  meta = {
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
