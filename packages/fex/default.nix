{ fetchFromGitHub
, cmake
, pkg-config
, ninja
, python3
, libepoxy
, SDL2
, nasm
, git
, llvmPackages
}:
llvmPackages.stdenv.mkDerivation
  (finalAttrs: {
    version = "2405";
    pname = "FEX";
    src = fetchFromGitHub {
      owner = "FEX-Emu";
      repo = "FEX";
      rev = "FEX-${finalAttrs.version}";
      hash = "sha256-YAOZwFGCdgNjlSaeE6TwqL8+ahY+SPIEl8uMOEgtuqE=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      llvmPackages.bintools
      (python3.withPackages (p: with p; [
        setuptools
      ]))
      libepoxy
      SDL2
      nasm
      git
    ];

    cmakeFlags = [
      "-DBUILD_TESTS=OFF"
    ];
  })
