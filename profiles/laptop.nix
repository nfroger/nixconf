{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  programs.nm-applet.enable = true;
  users.users.nicolas.extraGroups = [ "networkmanager" ];
}
