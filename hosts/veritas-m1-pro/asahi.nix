{ self, ... }:
{
  imports = [
    self.inputs.apple-silicon.nixosModules.default
  ];

  nixpkgs.overlays = [
    # overriding some apple-silicon packages since the modules do
    # not provide package options

    (final: super: {
      asahi-audio = super.asahi-audio.overrideAttrs (old: {
        src = old.src.override {
          rev = "839c671e256256ecc194198c134ec4f026595ecd";
          hash = "sha256-PKfyG0WKZN0KrhKNzye1gEcKMvfkNjOBMhvvHjs8BLI=";
        };
      });
    })
  ];

  # These do not work on asahi yet:

  # This needs to be explicitly set when not using partitions
  # boot.resumeDevice = "/var/lib/swapfile";

  # This needs to change when modifying the swapfile
  # boot.kernelParams = [
  #   # Determined using `findmnt -no UUID -T /var/lib/swapfile`
  #   "resume=UUID=e626023e-4d1b-4b71-b5c0-b5defa70f916"
  #   # Determined using `filefrag -v /var/lib/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'
  #   "resume_offset=64186368"
  # ];

  # Protecting the kernel image actually disables hibernation
  # security.protectKernelImage = false;

  # services.logind = {
  #   lidSwitch = "hibernate";
  #   lidSwitchExternalPower = "lock";
  #   powerKey = "hibernate";
  #   extraConfig = ''
  #     HibernateDelaySec=3600
  #   '';
  # };

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "overlay";
    };
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  services.udev.extraRules =
    ''
      SUBSYSTEM=="power_supply", KERNEL=="macsmc-battery", ATTR{charge_control_end_threshold}="80"
    '';
}
