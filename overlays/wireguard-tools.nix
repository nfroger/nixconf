final: prev: {
  wireguard-tools = prev.wireguard-tools.overrideAttrs (old: rec {
    postFixup = ''
      substituteInPlace $out/lib/systemd/system/wg-quick@.service \
        --replace /usr/bin $out/bin
    '' + final.lib.optionalString final.stdenv.isLinux ''
      # we want to allow users to provide their own resolvconf implementation, i.e. the one provided by systemd-resolved
      for f in $out/bin/*; do
        wrapProgram $f \
         --prefix PATH : ${final.lib.makeBinPath (with final; [ procps iproute2 iptables ])} \
         --suffix PATH : ${final.lib.makeBinPath (with final; [ openresolv ])}
      done
    '' + final.lib.optionalString final.stdenv.isDarwin ''
      for f in $out/bin/*; do
        wrapProgram $f --prefix PATH : ${final.wireguard-go}/bin
      done
    '';
  });
}
