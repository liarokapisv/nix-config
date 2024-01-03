{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      vmpk
      segger-jlink
      stm32cubemx
      kicard
    ];
  };
}
