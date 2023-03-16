{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (python310.withPackages (p: with p; [ ipython poetry black ]))
    ansible
    apache-directory-studio
    awscli2
    discord
    dynamips
    gnumeric
    gns3-gui
    gns3-server
    imagemagick
    inetutils
    jetbrains.idea-ultimate
    maven
    jdk
    jq
    libreoffice
    minio-client
    openldap
    openssl
    packer
    slack
    spotify
    teams
    terraform
    vault
    virt-manager
    vscodium
  ];
}
