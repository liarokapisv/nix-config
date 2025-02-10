{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    gccStdenv.cc
    gccStdenv.cc.libc
    gnumake
    bash
    binutils
    flex
    bison
    pahole
    util-linux
    kmod
    e2fsprogs
    jfsutils
    reiserfsprogs
    xfsprogs
    squashfsTools
    btrfs-progs
    pcmciaUtils
    linuxquota
    ppp
    nfs-utils
    procps
    udev
    grub2
    mcelog
    iptables
    openssl
    bc
    sphinx
    cpio
    gnutar
    global
  ];
}
