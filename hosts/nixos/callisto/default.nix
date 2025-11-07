{ pkgs
, lib
, nixos-hardware
, ...
}:

{
  # Desktop at CRI

  imports = [
    ../../profiles/core.nix
    ../../profiles/desktop.nix
    ../../profiles/docker.nix

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "callisto";

    domain = "lab.cri.epita.fr";
    nameservers = [
      "91.243.117.210"
      "8.8.8.8"
    ];

    vlans = {
      "eno1.240" = {
        id = 240;
        interface = "eno1";
      };
    };

    bridges = {
      br0 = {
        interfaces = [ "eno1" ];
      };
      "br0.240" = {
        interfaces = [ "eno1.240" ];
      };
    };

    interfaces = {
      eno1 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
      "br0".useDHCP = true;
      "br0.240" = {
        ipv4 = {
          addresses = [
            {
              address = "192.168.240.26";
              prefixLength = 24;
            }
          ];
        };
      };
    };

    timeServers = [
      "10.201.5.2"
    ];
  };

  # commented stuff is for pci passtrough vm, disabled because too many monitors
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ata_piix"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-mod"
    "dm-crypt"
    "e1000e"
    "bridge"
  ];
  boot.kernelModules = [
    "kvm-intel" # "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd"
  ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt" # "vfio-pci.ids=10de:1c81,10de:0fb9"
  ];
  #options vfio-pci ids=10de:1c81,10de:0fb9
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
  '';
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/e4a3273a-26df-47d8-bf31-72fa997fb4fe";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/83792639-dbde-4742-a03b-6cdf6de0f51e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E3D5-9873";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/1f3acca2-26d3-4349-ae67-1930f47afea8"; }];

  virtualisation.libvirtd.allowedBridges = [ "br0" ];
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    user = "nicolas"
    group = "kvm"
    cgroup_device_acl = [
        "/dev/input/by-id/usb-_USB_Keyboard-event-kbd",
        "/dev/input/by-id/usb-PixArt_USB_Optical_Mouse-event-mouse",
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/sev"
    ]
  '';

  services.openafsClient = {
    enable = true;
    cellName = "cri.epita.fr";
    cache = {
      diskless = true;
    };
    fakestat = true;
  };

  services.printing.drivers = with pkgs; [ hplip ];

  system.stateVersion = "22.11";
}
