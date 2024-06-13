{ lib, fetchFromGitHub, rustPlatform, llvmPackages, libkrun, libkrunfw, perl, openssl, fetchurl, glibc, cargo, pkg-config, epoxy, libdrm, virglrenderer }:

rustPlatform.buildRustPackage {
  pname = "krun";
  version = "d0179f3";

  src = fetchFromGitHub {
    owner = "slp";
    repo = "krun";
    rev = "d0179f3c4ab0eaa07a8813a772db805bf5be9965";
    hash = "sha256-oA/RRzZHji3d+Od1tCNkzj4jNJ1/qwj+pFRnmzT2d4Y=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    llvmPackages.llvm
  ];

  buildInputs =
    [
      ((libkrun.override {
        libkrunfw = libkrunfw.overrideAttrs
          (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ perl openssl ];
            buildInputs = old.buildInputs ++ [ cargo glibc glibc.static ];
            src = old.src.override {
              rev = "bb1506b92ed78da880fc1a2f0e1180040f1a7a3";
              hash = "sha256-BN6v33iKgs+7n3ITaeERVg3S06xdQMH7PIAYtRpQ7UU=";
            };
            version = "4.1.0";
            kernelSrc = fetchurl {
              url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.22.tar.xz";
              hash = "sha256-I+PntWQHJQ9UEb2rlXY9C8TjoZ36Qx2VHffqyr1hovQ=";
            };
            postPatch = old.postPatch + ''
              zcat /proc/config.gz > config-libkrunfw_aarch64
            '';
            meta.platforms = old.meta.platforms ++ [ "aarch64-linux" ];
          });
      }).overrideAttrs (old: rec {
        src = old.src.override {
          rev = "95b8a18950bd5452dd7e3a36f8dc99fd4d45b714";
          hash = "sha256-9ww22H5cDuomqzeSY0eARDumwLX6WMrzSZOikOl+70M=";
        };
        cargoDeps = rustPlatform.fetchCargoTarball {
          inherit (old) pname version;
          inherit src;
          hash = "sha256-KKcu97ZPBc1V2Yxl6X3eBjz94QC9ZI/F8mh6jc25eIg=";
        };
        NET = 1;
        BLK = 1;
        GPU = 1;
        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkg-config
        ];
        buildInputs = old.buildInputs ++ [
          epoxy
          libdrm
          virglrenderer
        ];
      }))
    ];

  cargoHash = "sha256-Qh6YmDQaXxbXpLcxFsz0zVtT3JcSZYQ9oOBacbTqLwo=";

  meta = {
    homepage = "https://github.com/slp/krun";
    license = lib.licenses.unlicense;
  };
}
