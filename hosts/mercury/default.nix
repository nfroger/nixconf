{ nixos-hardware, pkgs, ... }:

{
  # Main desktop

  imports = [
    ../../profiles/core.nix
    ../../profiles/desktop.nix
    ../../profiles/docker.nix
    ../../profiles/gaming.nix

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-gpu-amd
  ];

  networking = {
    hostName = "mercury";

    bridges = {
      br0 = {
        interfaces = [ "eno1" ];
      };
    };

    interfaces = {
      eno1.useDHCP = true;
      br0.useDHCP = true;
    };
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" "r8169" ];
  boot.initrd.kernelModules = [ "dm-mod" "dm-crypt" "bridge" ];
  boot.kernelModules = [ "kvm-amd" "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ ];
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
  '';
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/d2a4a6f4-2c6c-4fb7-af8a-88d0a56bb262";
      preLVM = false;
    };
  };
  hardware.enableRedistributableFirmware = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/dec301b6-195d-4281-b6df-616c1d483fd2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/0BEE-B0C9";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/0b76c53e-0964-44e4-8d4e-071abe9d7127"; }];

  virtualisation.libvirtd.allowedBridges = [ "br0" ];
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    user = "nicolas"
    group = "kvm"
    cgroup_device_acl = [
        "/dev/input/by-id/usb-Keychron_Keychron_Q1-if02-event-kbd",
        "/dev/input/by-id/usb-093a_USB_OPTICAL_MOUSE-event-mouse",
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/sev"
    ]
  '';

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      OLLAMA_ORIGINS = "moz-extension://*";
    };
  };
  environment.systemPackages = with pkgs; [
    (btop.override { rocmSupport = true; })
  ];

  system.stateVersion = "21.11";
}
