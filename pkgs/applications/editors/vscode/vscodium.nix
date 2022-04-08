{ lib, symlinkJoin, makeWrapper, vscodium }:

symlinkJoin {
  inherit (vscodium) name meta;
  version = lib.getVersion vscodium;

  paths = [ vscodium ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/codium \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform=wayland"
  '';
}
