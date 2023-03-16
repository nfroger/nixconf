{ pkgs, nixos-hardware, ... }:

{
  # Dell XPS 15 9570

  imports = [
    ../../profiles/core.nix
    ../../profiles/hamradio.nix
    ../../profiles/laptop.nix
    ../../profiles/docker.nix
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    nixos-hardware.nixosModules.dell-xps-15-9560-intel
  ];

  networking.hostName = "mars";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "dm-crypt" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  hardware.enableRedistributableFirmware = true;

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/a599cb75-a689-4e78-9bce-73415ce867bd";
      preLVM = true;
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f8e34f92-fadb-4890-9549-843319df82d0";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/68B1-DABE";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/94319718-a960-4104-bb63-818845cefb9f"; }];

  system.stateVersion = "21.05";
}
