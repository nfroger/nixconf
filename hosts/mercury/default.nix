{ nixos-hardware, ... }:

{
  # Main desktop

  imports = [
    ../../profiles/core.nix
    ../../profiles/desktop.nix
    ../../profiles/docker.nix

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
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
  boot.initrd.kernelModules = [ "dm-snapshot" "dm-mod" "dm-crypt" ];
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

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/9a83d0df-18bc-473d-928e-5a3d4f3149b4";
      preLVM = false;
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/4157cd65-3e83-46cf-9ab7-cb11b158a842";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4532-1F9D";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/6d9b9de5-dd5a-44d7-989d-562f36f20b8a"; }];

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

  system.stateVersion = "21.11";
}
