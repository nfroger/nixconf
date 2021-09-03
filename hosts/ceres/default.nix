{
  # Thinkpad X220

  imports = [
    ../../common.nix
  ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "dm-crypt" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  networking.hostName = "ceres";

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/80e74efd-3642-4db1-9676-ca4e980aa34a";
      preLVM = false;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/528715cd-f12c-4322-b112-ecdd85bcb9b0";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D724-0A5B";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a7bda4f2-1adf-4146-9129-63dc2b3ebb62"; }
    ];

  kektus.laptop.enable = true;

  system.stateVersion = "21.05";
}
