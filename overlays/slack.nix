final: prev: {
  slack = final.symlinkJoin rec {
    inherit (prev.slack) name;
    version = final.lib.getVersion prev.slack;

    paths = [ prev.slack ];
    buildInputs = [ final.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/slack \
        --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
        --add-flags "--ozone-platform=wayland"
    '';
  };
}
