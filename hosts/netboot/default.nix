{ pkgs, lib, ... }:

{
  # Netboot image

  imports = [
    ../../profiles/core.nix
  ];

  netboot.enable = true;
  netboot.imageName = "nix-pikek";
}
