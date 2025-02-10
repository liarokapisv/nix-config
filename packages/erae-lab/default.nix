{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  fetchurl,
  curl,
  alsa-lib,
  freetype,
  libgcc,
  libGL,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "erae-lab";
  version = "1.4.1";
  src = fetchurl {
    url = "https://storage.googleapis.com/videohosting/DOWNLOAD_Ressources/ERAE_Software/EraeLab_${finalAttrs.version}";
    hash = "sha256-ODVXRxW2rhycIgoLonvsn8ik6rC/4NnN3NwAgWd0Iww=";
  };
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;
  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];
  buildInputs = [
    curl
    alsa-lib
    freetype
    libGL
    libgcc.lib
  ];
  postInstall = ''
    mkdir -p $out/bin
    cp $src $out/bin/EraeLab
    chmod +x $out/bin/EraeLab
  '';
  desktopItems = [
    (makeDesktopItem {
      name = "EraeLab";
      exec = "EraeLab";
      icon = fetchurl {
        url = "https://s3-eu-central-1.amazonaws.com/euc-cdn.freshdesk.com/data/helpdesk/attachments/production/80055164819/original/Ldm_LToocRwVP7BQLCGJ4bY6qgtve0i0lw.png";
        hash = "sha256-YYl7/uTnykNN9r8hbnG9/FJ6VhDGy4eUKFhwM4YvX/M=";
      };
      desktopName = "Erae Lab";
      genericName = "Erae Touch Configuration Software";
      categories = [
        "Settings"
        "Audio"
      ];
      type = "Application";
      terminal = false;
      startupNotify = false;
    })
  ];
  meta = {
    description = "Create and manage your own layouts and update your ERAE Touch";
    homepage = "https://www.embodme.com";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.liarokapisv ];
    platforms = lib.platforms.linux;
  };

})
