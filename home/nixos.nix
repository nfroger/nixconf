{ pkgs, ... }:

{
  imports = [
    ./gui
  ];

  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
}
