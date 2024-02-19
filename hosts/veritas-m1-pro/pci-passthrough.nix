{
  specialisation."SD_CARD_READER_VFIO".configuration = {
    system.nixos.tags = [ "with-sdcard-vfio" ];
    boot = {

      kernelParams = [
        "iommu.passthrough=0"
      ];

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      extraModprobeConfig = "options vfio-pci ids=17a0:9755";
    };
  };
}
