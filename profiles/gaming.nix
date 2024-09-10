{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      gamescope
      mangohud
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
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
