{ pkgs, ... }:
{
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
