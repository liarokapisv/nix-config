{
  flake.modules.nixos.embedded =
    { pkgs, ... }:
    {
      services = {
        udev.packages = with pkgs; [
          segger-jlink-headless
          openocd
          saleae-logic-2
          stlink
        ];
      };
    };

  flake.modules.homeManager.embedded =
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
              saleae-logic-2
            ]
          );
      };
    };
}
