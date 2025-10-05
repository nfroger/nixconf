{ pkgs, ... }:
let
  pieVNC = pkgs.writeScriptBin "pieVNC" ''
    ssh -S none -t -L 5900:localhost:5900 "root@$1" 'x11vnc -auth "$(find /var/run/sddm -type f)" -localhost -display :0'
  '';
  teams = pkgs.writeScriptBin "teams" ''
    ${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com
  '';
in
{
  home.packages = with pkgs; [
    (python3.withPackages (p: with p; [ ipython black ]))
    ansible
    apache-directory-studio
    awscli2
    claude-code
    discord
    dynamips
    ffmpeg
    gimp
    remmina
    gns3-gui
    gns3-server
    gnumeric
    imagemagick
    inetutils
    inkscape
    ipcalc
    jdk
    jellyfin-mpv-shim
    jetbrains.idea-ultimate
    jetbrains.rider
    jq
    libreoffice
    maven
    minio-client
    openldap
    openssl
    opentofu
    packer
    pieVNC
    poetry
    postgresql
    pv
    pwgen
    slack
    spotify
    tcpdump
    teams
    openbao
    virt-manager
    vscodium
    mtr
    minicom
    picocom
    dive
    lingot
    hoppscotch
    dos2unix
  ];
}
