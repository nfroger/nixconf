{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      gamescope
      mangohud
      libxcursor
      libxi
      libxinerama
      libxscrnsaver
      libpng
      libpulseaudio
      pipewire
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];
    gamescopeSession.enable = true;
  };
  programs.gamescope = {
    enable = true;
  };
}
