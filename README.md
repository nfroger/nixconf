# Personal NixOS Configuration

This repository contains all of the configuration for my computers running
NixOS.

## Test VM

A test virtual machine can be built to test the configuration. Simply run
``nix build .#nixosConfigurations.testvm.config.system.build.vm``.

## Installation guide

* Boot the NixOS live image
* Load the necessary kernel modules using modprobe (dm-cache, dm-raid...)
* Partition the disk
* Mount root at ``/mnt`` and esp at ``/mnt/boot``
* Clone this repo
* Run ``nixos-generate-config`` and adjust host config according to the
    generated files
* Run ``nix-shell -p nixUnstable --run "nix --experimental-features 'nix-command flakes' build .#nixosConfigurations.${hostname}.config.system.build.toplevel"``
* Run ``nixos-install --system ./result``
