{ pkgs, nixos-hardware, ... }:

{
  # Lenovo Thinkpad L14

  imports = [
    ../../profiles/core.nix
    ../../profiles/laptop.nix
    ../../profiles/docker.nix
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
  ];

  networking.hostName = "ganymede";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "dm-crypt" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  hardware.enableRedistributableFirmware = true;

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/4cfb4eec-3dd6-491c-840b-1e8bb0b36756";
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/e85c21ef-8da2-4af7-ac7f-83c30a8d7e10";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/698B-CB82";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/75a10f00-4e55-4389-8d54-51e83f23fae7"; }];

  system.stateVersion = "22.11";
}
