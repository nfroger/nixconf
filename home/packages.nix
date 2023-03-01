{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (python310.withPackages (p: with p; [ ipython poetry black ]))
    ansible
    apache-directory-studio
    awscli2
    discord
    gnumeric
    imagemagick
    jetbrains.idea-community
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
