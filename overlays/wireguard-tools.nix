final: prev: {
  wireguard-tools = prev.wireguard-tools.overrideAttrs (old: rec {
    postFixup = ''
      substituteInPlace $out/lib/systemd/system/wg-quick@.service \
        --replace /usr/bin $out/bin
    '' + final.lib.optionalString final.stdenv.isLinux ''
      for f in $out/bin/*; do
        wrapProgram $f --prefix PATH : ${final.lib.makeBinPath (with final; [ procps iproute2 iptables systemd ])}
      done
    '' + final.lib.optionalString final.stdenv.isDarwin ''
      for f in $out/bin/*; do
        wrapProgram $f --prefix PATH : ${final.wireguard-go}/bin
      done
    '';
  });
}
