{ self, lib, ... }:
{
  imports = [
    self.inputs.apple-silicon.nixosModules.default
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

  # TODO! Remove when added in nixos-apple-silicon 
  boot.kernelPatches = [
    {
      name = "Add UCLAMP_TASK options discussed in Asahi Fedora Remix blog post.";
      patch = null;
      extraStructuredConfig = {
        UCLAMP_TASK = lib.kernel.yes;
        UCLAMP_BUCKETS_COUNT = lib.kernel.freeform "5";
        UCLAMP_TASK_GROUP = lib.kernel.yes;
      };
    }
  ];

  services.udev.extraRules =
    ''
      SUBSYSTEM=="power_supply", KERNEL=="macsmc-battery", ATTR{charge_control_end_threshold}="80"
    '';
}
