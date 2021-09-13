{
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  users.users.nicolas.extraGroups = [ "networkmanager" ];
}
