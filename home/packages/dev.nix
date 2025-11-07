{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python3.withPackages (
      p: with p; [
        ipython
        black
      ]
    ))
    maven
    poetry
    uv
  ];
}
