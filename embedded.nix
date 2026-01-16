{ self, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      nixpkgs = {
        config.segger-jlink.acceptLicense = true;

        permittedInsecurePackages = [
          "segger-jlink-qt4-874"
        ];
      };
    };

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

  flake-file.inputs.nixpkgs-eagle.url = "github:nixos/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb";

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

              ((import self.inputs.nixpkgs-eagle {
                inherit (pkgs.stdenv.hostPlatform) system;
                config.allowUnfree = true;
              }).eagle

              )
            ]
          );
      };
    };
}
