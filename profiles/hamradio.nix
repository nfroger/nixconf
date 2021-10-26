{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chirp
    fldigi
    qsstv
    wsjtx
  ];
}
