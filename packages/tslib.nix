{
  lib,
  fetchzip,
  stdenv,
  pkg-config,
  ...
}:

stdenv.mkDerivation {

  pname = "tslib";
  version = "1.22";

  src = fetchzip {
    url = "https://github.com/libts/tslib/releases/download/1.22/tslib-1.22.tar.gz";
    sha256 = "zA3rpE6vH0d2VSL7iDY7JbzOa+SRzsLvk9z/iBzfj1g=";
  };

  nativeBuildInputs = [ pkg-config ];

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = "http://www.tslib.org";
    description = "C library for filtering touchscreen events";
    license = lib.licenses.lgpl21;
    platforms = [ "x86_64-linux" ];
  };
}
