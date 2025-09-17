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
    url = "https://uc651ffd76317798f385521dcd7d.dl.dropboxusercontent.com/cd/0/get/CxggYoql7TIkD64w_S95oFx5QcGPK4KcHKuGi5Gv1c2dHjkerPehdVsQ2C6bK4yS6AMnXSjDNG8CQZF0Q0zEpi1np0bkfjKzB8Xak8HJREkTbjY0S2MvRV2nXXkGcSp_M3kJniX8yMFMKz1PEYYwIbjX/file?dl=1";
    hash = "sha256-MMDL18i4Gg1/H6hEZ3REH6Gj/Bz41WNgQ6qWrvdPv3M=";
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
