final: prev: {
  vscodium = final.symlinkJoin rec {
    inherit (prev.vscodium) name;
    version = final.lib.getVersion prev.vscodium;

    paths = [ prev.vscodium ];
    buildInputs = [ final.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/codium \
        --add-flags "--enable-features=UseOzonePlatform" \
        --add-flags "--ozone-platform=wayland"
    '';
  };
}
