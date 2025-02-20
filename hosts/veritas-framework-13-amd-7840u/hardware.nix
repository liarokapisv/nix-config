{
  self,
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  hardware = {
    framework.amd-7040.preventWakeOnAC = true;
    enableAllFirmware = true;

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/494e17d4-29fa-4139-a7d5-bf835e52f495";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1C58-6A09";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3ef9f9d4-1975-4ac5-b59e-f1f9716a5216";
    fsType = "ext4";
  };

  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-uuid/63f5dc7a-6cdc-460d-bc1a-909acb42c606";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/725e17f2-57f4-40d0-817d-95a728532932";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/b44b4bef-d20b-4bb5-8fb6-45fb0cdf186f"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Sets regulatory domain to Europe.
  # https://wiki.archlinux.org/title/Framework_Laptop_13#Wi-Fi_performance_on_AMD_edition
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="GR"
  '';
}
