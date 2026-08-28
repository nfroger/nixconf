{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    extraPackages = with pkgs; [ docker-buildx ];
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
