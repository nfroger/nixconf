{ pkgs, ... }:
let
  pieVNC = pkgs.writeScriptBin "pieVNC" ''
    ssh -S none -t -L 5900:localhost:5900 "root@$1" 'x11vnc -auth /home/$(loginctl | grep -v tty | grep seat0 | awk '\'''{ print $3 }'\''')/.Xauthority -localhost -display :0'
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
    discord
    dotnet-sdk_7
    dynamips
    ffmpeg
    gimp
    gnome.vinagre
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
    vault
    virt-manager
    vscodium
  ];
}
