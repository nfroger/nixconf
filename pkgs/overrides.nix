{ pkgsUnstable, pkgsMaster }:

final: prev: {
  inherit (pkgsUnstable)
    jetbrains
    llama-cpp
    ;
}
