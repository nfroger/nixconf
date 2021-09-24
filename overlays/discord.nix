final: prev: {
  discord = final.symlinkJoin rec {
    inherit (prev.discord) name;
    version = final.lib.getVersion prev.discord;

    paths = [ prev.discord ];
    buildInputs = [ final.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/discord \
        --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
        --add-flags "--ozone-platform=wayland"
    '';
  };
}
