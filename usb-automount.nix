{
  flake.modules.nixos.usb-automount = {
    services = {
      devmon = {
        enable = true;
      };
    };
  };
}
