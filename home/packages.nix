{ pkgs, ... }:
let
  pieVNC = pkgs.writeScriptBin "pieVNC" ''
    ssh -S none -t -L 5900:localhost:5900 "root@$1" 'x11vnc -auth /home/$(loginctl | grep -v tty | grep seat0 | awk '\'''{ print $3 }'\''')/.Xauthority -localhost -display :0'
  '';
in
{
  home.packages = with pkgs; [
    (python310.withPackages (p: with p; [ ipython black ]))
    ansible
    apache-directory-studio
    awscli2
    discord
    dynamips
    gnome.vinagre
    gns3-gui
    gns3-server
    gnumeric
    imagemagick
    inetutils
    jdk
    jellyfin-mpv-shim
    jetbrains.idea-ultimate
    jetbrains.rider
    dotnet-sdk_7
    jq
    libreoffice
    maven
    minio-client
    openldap
    openssl
    packer
    pieVNC
    poetry
    slack
    spotify
    teams
    terraform
    vault
    virt-manager
    vscodium
  ];
}
