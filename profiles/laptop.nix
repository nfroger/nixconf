{
  networking.networkmanager = {
    enable = true;
    dns = "default";
    wifi.backend = "iwd";
  };

  programs.nm-applet.enable = true;
  users.users.nicolas.extraGroups = [ "networkmanager" ];

  services.hardware.bolt.enable = true;
}
