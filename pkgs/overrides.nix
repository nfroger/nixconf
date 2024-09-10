{ pkgsUnstable, pkgsMaster }:

final: prev: {
  inherit (pkgsUnstable)
    jetbrains
    ollama-rocm
    ;
}
