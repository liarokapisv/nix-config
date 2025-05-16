{ pkgs, ... }:
{
  nixpkgs.config.segger-jlink.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-810"
  ];

  home = {
    packages =
      with pkgs;
      (
        lib.optionals (stdenv.hostPlatform.system != "x86_64-linux") [ segger-jlink ]
        ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
          (pkgs.symlinkJoin {
            name = "segger-utils";
            paths = [
              segger-ozone
              segger-jlink
            ];
          })
          stm32cubemx
        ]
      );
  };
}
