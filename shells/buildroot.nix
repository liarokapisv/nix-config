{ pkgs }:

(pkgs.buildFHSUserEnv {
  name = "buildroot-buildenv";
  targetPkgs =
    pkgs:
    (with pkgs; [
      # required packages
      which
      gnused
      gnumake
      binutils
      diffutils
      openssl
      pkg-config
      gccStdenv.cc
      gccStdenv.cc.libc
      bash
      patch
      gzip
      bzip2
      perl
      gnutar
      cpio
      unzip
      rsync
      file
      bc
      findutils
      wget

      # optional packages
      ncurses5
      graphviz
      (python3.withPackages (
        pypkgs: with pypkgs; [
          matplotlib
          libfdt
        ]
      ))

      ## undocumented extras
      libxcrypt # needed crypt.h

      ## needed for host tools
      flock
    ]);
  extraOutputsToInstall = [ "dev" ];
  runScript = "bash";
}).env
