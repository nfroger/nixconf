{ lib, symlinkJoin, makeWrapper, discord }:

symlinkJoin rec {
  inherit (discord) name meta;
  version = lib.getVersion discord;

  paths = [ discord ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/discord \
      --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
      --add-flags "--ozone-platform=wayland"
  '';
}
