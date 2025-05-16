{ librealsense, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "librealsense-udev-rules";
  version = librealsense.version;
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/etc/udev/rules.d/
    cp ${librealsense.src}/config/usb-R200-in $out/bin/
    chmod +x $out/bin/usb-R200-in
    cp ${librealsense.src}/config/usb-R200-in_udev $out/bin/
    chmod +x $out/bin/usb-R200-in_udev
    sed -i "s|/usr/local/bin|$out/bin|" $out/bin/usb-R200-in_udev
    cp "${librealsense.src}/config/99-realsense-libusb.rules" $out/etc/udev/rules.d/99-realsense-libusb.rules
    sed -i "s|/usr/local/bin|$out/bin|" $out/etc/udev/rules.d/99-realsense-libusb.rules
  '';
}
