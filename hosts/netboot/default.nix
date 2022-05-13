{ pkgs, lib, ... }:

{
  # Netboot image

  imports = [
    ../../profiles/core.nix
    ../../profiles/sshfs.nix
  ];

  netboot.enable = true;
  netboot.imageName = "nix-pikek";
}
