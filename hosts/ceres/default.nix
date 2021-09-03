{
  # Thinkpad X220

  imports = [
    ../../common.nix
  ];

  boot.initrd.kernelModules = [ "dm-crypt" ];

  networking.hostName = "ceres";

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/80e74efd-3642-4db1-9676-ca4e980aa34a";
      preLVM = false;
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/FIXME";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/FIXME";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/FIXME"; }];


  kektus.laptop.enable = true;

  system.stateVersion = "21.05";
}
