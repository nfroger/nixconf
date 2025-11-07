{ pkgs, ... }:
let
  pieVNC = pkgs.writeScriptBin "pieVNC" ''
    ssh -S none -t -L 5900:localhost:5900 "root@$1" 'x11vnc -auth "$(find /var/run/sddm -type f)" -localhost -display :0'
  '';
in
{
  home.packages = with pkgs; [
    ansible
    awscli2
    claude-code
    coreutils
    dive
    dos2unix
    ffmpeg
    imagemagick
    inetutils
    ipcalc
    jq
    minicom
    minio-client
    mtr
    openbao
    openldap
    openssl
    opentofu
    packer
    picocom
    pieVNC
    postgresql
    pv
    pwgen
    rclone
    tcpdump
  ];
}
