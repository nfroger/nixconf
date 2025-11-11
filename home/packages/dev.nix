{ pkgs, ... }:
let
  pythonPkg = pkgs.python3.withPackages (
    p: with p; [
      ipython
      black
    ]);
in
{
  home.packages = with pkgs; [
    pythonPkg
    maven
    poetry
    uv
  ];

  home.sessionVariables = {
    UV_NO_SYNC = "1";
    UV_PYTHON = "${pythonPkg}/bin/python";
    UV_PYTHON_DOWNLOADS = "never";
  };
}
