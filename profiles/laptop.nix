{
  networking.networkmanager = {
    enable = true;
    dns = "default";
  };

  programs.nm-applet.enable = true;
  users.users.nicolas.extraGroups = [ "networkmanager" ];

  services.hardware.bolt.enable = true;
}
