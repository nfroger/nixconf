{
  # Main desktop

  imports = [
    ../../common.nix
  ];

  networking.hostName = "mercury";

  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges = {
    br0 = {
      interfaces = [ "enp3s0" ];
    };
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "dm-mod" "dm-cache" "dm-cache-smq" "dm-thin-pool" "raid1" ];
  boot.kernelModules = [ "kvm-intel" "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "vfio-pci.ids=10de:13c2,10de:0fbb" ];
  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:13c2,10de:0fbb
    options kvm_intel nested=1
  '';
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  boot.initrd.extraUtilsCommands = ''
    for BIN in ${pkgs.thin-provisioning-tools}/{s,}bin/*; do
        copy_bin_and_libs $BIN
    done
  '';
  # Before LVM commands are executed, ensure that LVM knows exactly where our cache and thin provisioning tools are
  boot.initrd.preLVMCommands = ''
    mkdir -p /etc/lvm
    echo "global/thin_check_executable = "$(which thin_check)"" >> /etc/lvm/lvm.conf
    echo "global/cache_check_executable = "$(which cache_check)"" >> /etc/lvm/lvm.conf
    echo "global/cache_dump_executable = "$(which cache_dump)"" >> /etc/lvm/lvm.conf
    echo "global/cache_repair_executable = "$(which cache_repair)"" >> /etc/lvm/lvm.conf
    echo "global/thin_dump_executable = "$(which thin_dump)"" >> /etc/lvm/lvm.conf
    echo "global/thin_repair_executable = "$(which thin_repair)"" >> /etc/lvm/lvm.conf
  '';

  boot.initrd.mdadmConf = ''
    ARRAY /dev/md/Raid1Lvm  metadata=1.2 UUID=7e4af654:59346547:b73345ac:ea3002d3 name=any:Raid1Lvm
    ARRAY /dev/md/Raid1Swap  metadata=1.2 UUID=6b2e5afc:43e07a13:eba3cbb5:8441e5d7 name=any:Raid1Swap
  '';
  services.lvm.boot.thin.enable = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d1b43f5d-1d46-4517-8a86-ee45abd266bd";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/03DA-0074";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/52780eb3-01ea-4ed4-928d-b79da50225f2"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuOvmf = true;
  virtualisation.libvirtd.allowedBridges = [ "br0" ];
  virtualisation.libvirtd.qemuVerbatimConfig = ''
    user = "nicolas"
    group = "kvm"
    cgroup_device_acl = [
        "/dev/input/by-id/usb-04d9_USB-HID_Keyboard-event-kbd",
        "/dev/input/by-id/usb-093a_USB_OPTICAL_MOUSE-event-mouse",
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/sev"
    ]
  '';

  virtualisation.docker.enable = true;

  system.stateVersion = "20.09";
}
