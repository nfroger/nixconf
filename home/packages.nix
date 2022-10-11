{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (python310.withPackages (p: with p; [ poetry black ]))
    ansible
    apache-directory-studio
    awscli2
    discord
    gnumeric
    imagemagick
    jq
    krew
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    libreoffice
    minio-client
    openldap
    openssl
    packer
    slack
    spotify
    stern
    teams
    terraform
    vault
    virt-manager
    vscodium
  ];
}
