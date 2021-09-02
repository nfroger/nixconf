{ config, lib, ... }:

with lib;
{
  options = {
    kektus.laptop = {
      enable = mkEnableOption "Whether the host is a laptop";
    };
  };

  config = mkIf config.kektus.laptop.enable {
    networking.networkmanager.enable = true;
    programs.nm-applet.enable = true;
  };
}
