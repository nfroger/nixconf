{ pkgs, ... }:
let
  teams = pkgs.writeScriptBin "teams" ''
    ${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com
  '';
in
{
  home.packages = with pkgs; [
    apache-directory-studio
    discord
    gimp
    remmina
    dynamips
    gns3-gui
    gns3-server
    gnumeric
    inkscape
    jellyfin-mpv-shim
    jetbrains.idea-ultimate
    jetbrains.rider
    libreoffice
    slack
    spotify
    teams
    virt-manager
    vscodium
    lingot
    hoppscotch
  ];
}
