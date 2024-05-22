{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      cmake
      clang-tools
      cargo
      rust-analyzer
      vmpk
      segger-jlink
      kicad
    ];
  };
}
