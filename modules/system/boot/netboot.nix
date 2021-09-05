{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    netboot = {
      enable = mkEnableOption "Set defaults for creating a netboot image";
      http = {
        mountPoint = mkOption {
          type = types.str;
          default = "/srv/netboothttp";
          description = "Mountpoint for the netboot files.";
        };
        url = mkOption {
          type = types.str;
          default = "https://static.k8s.kektus.xyz/kektus-pxe-images/";
          description = "netboot URL";
        };
      };
      imageName = mkOption {
        type = types.str;
        default = "nixnetboot";
        description = "Name of the netboot image";
      };
    };
  };

  config =
    let
      imageName = config.netboot.imageName;
    in
    mkIf config.netboot.enable {
      # Don't build the GRUB menu builder script, since we don't need it
      # here and it causes a cyclic dependency.
      boot.loader.grub.enable = false;

      # !!! Hack - attributes expected by other modules.
      environment.systemPackages = [ pkgs.grub2_efi pkgs.grub2 pkgs.syslinux ];

      fileSystems = {
        "/" = {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
        };

        # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
        # image) to make this a live CD.
        "/nix/.ro-store" = {
          fsType = "squashfs";
          device = "../${config.netboot.http.mountPoint}/${imageName}.squashfs";
          options = [ "loop" ];
          neededForBoot = true;
        };

        "/nix/.rw-store" = {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
          neededForBoot = true;
        };

        "/nix/store" = {
          fsType = "overlay";
          device = "overlay";
          options = [
            "lowerdir=/nix/.ro-store"
            "upperdir=/nix/.rw-store/store"
            "workdir=/nix/.rw-store/work"
          ];
        };
      };

      networking.useDHCP = mkForce true;
      boot.initrd = {
        availableKernelModules = [
          # To mount /nix/store
          "squashfs"
          "overlay"

          # SATA support
          "ahci"
          "ata_piix"
          "sata_inic162x"
          "sata_nv"
          "sata_promise"
          "sata_qstor"
          "sata_sil"
          "sata_sil24"
          "sata_sis"
          "sata_svw"
          "sata_sx4"
          "sata_uli"
          "sata_via"
          "sata_vsc"

          # NVMe
          "nvme"

          # Virtio (QEMU, KVM, etc.) support
          "virtio_pci"
          "virtio_blk"
          "virtio_scsi"
          "virtio_balloon"
          "virtio_console"
          "virtio_net"

          # Network support
          "ecb"
          "arc4"
          "bridge"
          "stp"
          "llc"
          "ipv6"
          "bonding"
          "8021q"
          "ipvlan"
          "macvlan"
          "af_packet"
          "xennet"
          "e1000e"
          "r8152"
        ];
        kernelModules = [
          "loop"
          "overlay"
        ];

        # For http downloading
        network.enable = true;
        network.udhcpc.extraArgs = [ "-t 10" "-A 10" ];
        extraUtilsCommands = ''
          copy_bin_and_libs ${pkgs.curl}/bin/curl
          copy_bin_and_libs ${pkgs.rng-tools}/bin/rngd

          cp -pv ${pkgs.glibc}/lib/libresolv.so.2 $out/lib
          cp -pv ${pkgs.glibc}/lib/libnss_dns.so.2 $out/lib
        '';
      };

      ###
      ### Commands to execute on boot to download the system and configure it
      ### properly.
      ###

      # Network is done in preLVMCommands, which means it is already set up when
      # we get to postDeviceCommands
      boot.initrd.postDeviceCommands = ''
        if ! [ -f /etc/resolv.conf ]; then
          # In case we didn't receive a nameserver from our DHCP
          echo "nameserver 1.1.1.1" >> /etc/resolv.conf
        fi

        imageName="${imageName}"
        squashfsName="$imageName.squashfs"

        httpDir=${config.netboot.http.mountPoint}
        targetHttpDir=$targetRoot/$httpDir
        mkdir -p $httpDir $targetRoot $targetHttpDir

        mount -o bind,ro $httpDir $targetHttpDir

        mount -t tmpfs tmpfs $httpDir

        curl "${config.netboot.http.url}$squashfsName" -o "$httpDir/$squashfsName"

        if ! [ -f "$httpDir/$squashfsName" ]; then
          ls -la $httpDir
          echo "HTTP download of '$squashfsName' failed!"
          fail
        fi
      '';

      # Usually, stage2Init is passed using the init kernel command line argument
      # but it would be inconvenient to manually change it to the right Nix store
      # path every time we rebuild an image. We just set it here and forget about
      # it.
      # Also, we cannot directly reference the current system.build.toplevel, as
      # it would cause an infinite recursion, so we have to put it in another
      # system.build artefact, in this case our squashfs, and use it from
      # there
      boot.initrd.postMountCommands = ''
        export stage2Init=$(cat $targetRoot/nix/store/stage2Init)
      '';

      boot.postBootCommands = ''
        # After booting, register the contents of the Nix store
        # in the Nix database in the tmpfs.
        ${config.nix.package}/bin/nix-store --load-db < /nix/store/nix-path-registration

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

      ###
      ### Outputs from the configuration needed to boot.
      ###

      # Create the squashfs image that contains the Nix store.
      system.build.squashfs = pkgs.callPackage ../../../lib/make-squashfs.nix {
        name = "${imageName}.squashfs";
        storeContents = singleton config.system.build.toplevel;
        stage2Init = "${config.system.build.toplevel}/init";
      };

      # Using the prepend argument here for system.build.initialRamdisk doesn't
      # work, so we just create an extra initrd and concatenate the two later.
      system.build.extraInitrd = pkgs.makeInitrd {
        name = "extraInitrd";
        inherit (config.boot.initrd) compressor;

        contents = [
          {
            object =
              config.environment.etc."ssl/certs/ca-certificates.crt".source;
            symlink = "/etc/ssl/certs/ca-certificates.crt";
          }
        ];
      };

      # Concatenate the required initrds.
      system.build.initrd = pkgs.runCommand "initrd" { } ''
        cat \
          ${config.system.build.initialRamdisk}/initrd \
          ${config.system.build.extraInitrd}/initrd \
          > $out
      '';

      system.build.toplevel-netboot = pkgs.runCommand "${imageName}.toplevel-netboot" { } ''
        mkdir -p $out
        cp ${config.system.build.kernel}/bzImage $out/${imageName}_bzImage
        cp ${config.system.build.initrd} $out/${imageName}_initrd
        cp ${config.system.build.squashfs}/${config.system.build.squashfs.name} $out/${imageName}.squashfs
      '';
    };
}
