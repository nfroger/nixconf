{
  # Thinkpad X220

  imports = [
    ../../common.nix
  ];

  networking.hostName = "ceres";

  kektus.laptop.enable = true;
}
