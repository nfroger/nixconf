{ lib, ... }:

{
  imports = [
    ../../profiles/core.nix
  ];

  networking.hostName = "testvm";

  networking.useDHCP = lib.mkForce true;
}
