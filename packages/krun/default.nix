{
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  llvmPackages,
  perl,
  openssl,
  fetchurl,
  pkg-config,
  libdrm,
  libepoxy,
  pkgs,
  cpio,
  pipewire,
}:

let
  libkrunfw = pkgs.libkrunfw.overrideAttrs (
    f: p: {
      version = "git+bb1506b92ed78da880fc1a2f0e1180040f1a7a36";

      src = fetchFromGitHub {
        owner = "containers";
        repo = f.pname;
        rev = "bb1506b92ed78da880fc1a2f0e1180040f1a7a36";
        hash = "sha256-BN6v33iKgs+7n3ITaeERVg3S06xdQMH7PIAYtRpQ7UU=";
      };

      kernelSrc = fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.22.tar.xz";
        hash = "sha256-I+PntWQHJQ9UEb2rlXY9C8TjoZ36Qx2VHffqyr1hovQ=";
      };

      NIX_CFLAGS_COMPILE = "-march=${stdenv.hostPlatform.gcc.arch}+crypto";

      nativeBuildInputs = p.nativeBuildInputs ++ ([
        cpio
        perl
        openssl
      ]);

      meta.platforms = p.meta.platforms ++ [ "aarch64-linux" ];
    }
  );

  virglrenderer = pkgs.virglrenderer.overrideAttrs (
    f: p: {
      version = "git+84efb186c1dacc0838770027f73a09d065a5bbdf";

      src = fetchurl {
        url = "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/84efb186c1dacc0838770027f73a09d065a5bbdf/virglrenderer-84efb186c1dacc0838770027f73a09d065a5bbdf.tar.bz2";
        hash = "sha256-fskcDk5agQhc1GI0f8m920gBoQPfh3rXb/5ZxwKSLaA=";
      };

      mesonFlags = [
        "-Ddrm-msm-experimental=true"
        "-Ddrm-asahi-experimental=true"
      ];
    }
  );

  libkrun = (pkgs.libkrun.override { libkrunfw = libkrunfw; }).overrideAttrs (
    f: p: {
      version = "git+0bea04816f4dc414a947aa7675e169cbbfbd45dc";

      src = fetchFromGitHub {
        owner = "containers";
        repo = f.pname;
        rev = "0bea04816f4dc414a947aa7675e169cbbfbd45dc";
        hash = "sha256-eo48jhc6L92+ycSMwBtFO0qhbtanx+SXm1eJgYlsass=";
      };

      nativeBuildInputs = p.nativeBuildInputs ++ [
        pkg-config
        llvmPackages.clang
      ];

      buildInputs = p.buildInputs ++ [
        libepoxy
        libdrm
        pipewire
        virglrenderer
      ];

      env.LIBCLANG_PATH = "${llvmPackages.clang-unwrapped.lib}/lib/libclang.so";

      cargoDeps = rustPlatform.fetchCargoTarball {
        inherit (f) src;
        hash = "sha256-Mj0GceQBiGCt0KPXp3StjnuzWhvBNxdSUCoroM2awIY=";
      };

      makeFlags = p.makeFlags ++ [
        "GPU=1"
        "SND=1"
        "NET=1"
      ];
    }
  );

in
rustPlatform.buildRustPackage rec {
  pname = "krun";
  version = "git+${src.rev}";

  src = fetchFromGitHub {
    owner = "slp";
    repo = "krun";
    rev = "5a8542a5066bd1a4d8bad99236f05ea3ac687ef7";
    hash = "sha256-3w1JHqzpkF11+3yHN3yPu2dKdi4qXdO8HY+7ICugAZA=";
  };

  patches = [ ./mount-root-run-directory.patch ];

  postPatch = ''
    sed -i "s|/sbin/dhclient|${pkgs.dhclient}/bin/dhclient|" crates/krun-guest/src/net.rs
  '';

  cargoHash = "sha256-dtj3TiszBBsMtlJaaIyTmCNAGZy/zuSGSK8OOTb5Xmg=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = [ libkrun ];

  cargoLock.lockFile = "${src}/Cargo.lock";
}
