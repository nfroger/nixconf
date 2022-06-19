{ config, pkgs, lib, ... }:

let
  sshfsServer = "sshfs.kektus.xyz";
  port = "2222";
  pam_kektus = pkgs.writeShellScript "pam_kektus" ''
    export PATH="${pkgs.coreutils}/bin:/run/wrappers/bin:/run/current-system/sw/bin:$PATH"

    if [ "$PAM_TYPE" = "open_session" ]; then
      if [ $(id -u) -eq 0 ]; then
        su - "$PAM_USER" -c "[ -x \$HOME/sshfs/.confs/install.sh ] && \$HOME/sshfs/.confs/install.sh || true"
      else
        [ -x $HOME/sshfs/.confs/install.sh ] && $HOME/sshfs/.confs/install.sh || true
      fi
    fi

    exit 0
  '';
in
{
  users.users.nicolas.uid = 5000;
  programs.ssh = {
    knownHosts.sshfs-rsa = {
      hostNames = [ sshfsServer ];
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNT5Ny5DbHYJqPvOoi9TyH040cdd7bHrTH7nbj+8U/iDzJQuEmAvRoHaANaxKNHD0WKneXAUt3RDTRXnm2mkcgmW50buzhxQ9uU6cr4URgjl33YqUXHZX+6vsRMjCvcsYkKUEAWGgguniZB3ETgcB+pF+ju3CT2Bd3OEcNExekHZMVsAQTZVwxl6/KT4TJ/ktIs8fnpCYpiUf64bpHA+J2qGWAWYsuMRB6UiHMGEAnInmwQG5rl6WmfWYCys0AxQIwo9YIsdCzGeAWUVKCkDudydo8D3G28w2uDnVBAtMBtL0K+opz5bpMEoFuxFy0QfK4cBf97GPqJo8vzf5ITbYvuvC+vt+CtKppzqxsMe6R1pP5HS5nLaxgsGy+uj2kXut5metpFk7/ebol5Pv5toikOgx9T4CkQAEXkOzHUv3OZZexhyBAsYFQM92qL29I6BRWE+Qvc5nIMcH/H1nKmusJl3Dq5EYd9pz4dZdPDFiZDOih0vUnFb6sYYypu6jEVo0=";
    };
    knownHosts.sshfs-ecdsa = {
      hostNames = [ sshfsServer ];
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBD8dzqjzNXACvaUZrPQU2gw7Bnr6zHIjA+XHDLsYDoykaNVXDs8tfGi7udhbG2w/sDbZ1R35FMOhLYnkDWAIxuQ=";
    };
    knownHosts.sshfs-ed25519 = {
      hostNames = [ sshfsServer ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINd0KfAJBPJ9rN79w1CMbi83NUn00+iEPelNfx23Xf/y";
    };

    extraConfig = ''
      Host ${sshfsServer}
        GSSAPIAuthentication yes
    '';
  };

  security.pam.services.login.pamMount = true;
  security.pam.mount = {
    enable = true;
    additionalSearchPaths = [ pkgs.sshfs ];
    extraVolumes = [
      ''
        <volume
          fstype="fuse"
          path="sshfs#%(USER)@${sshfsServer}:"
          mountpoint="~/sshfs"
          ssh="0"
          options="reconnect,port=${port}"
        />
      ''
    ];
  };

  security.pam.services.login.text = ''
    # Account management.
    account sufficient ${pkgs.pam_krb5}/lib/security/pam_krb5.so
    account required pam_unix.so

    # Authentication management.
    auth [success=1 default=ignore] ${pkgs.pam_krb5}/lib/security/pam_krb5.so use_first_pass
    auth sufficient pam_unix.so nullok  use_first_pass
    auth optional ${pkgs.pam_mount}/lib/security/pam_mount.so disable_interactive

    # Password management.
    password optional pam_unix.so nullok sha512
    password optional ${pkgs.pam_krb5}/lib/security/pam_krb5.so use_first_pass

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
    session required pam_loginuid.so
    session required ${pkgs.pam}/lib/security/pam_lastlog.so silent
    session optional ${pkgs.pam_krb5}/lib/security/pam_krb5.so
    session [success=3 default=ignore] pam_succeed_if.so quiet uid <= 1000
    session [success=2 default=ignore] pam_succeed_if.so quiet uid >= 30000
    session optional ${pkgs.pam_mount}/lib/security/pam_mount.so disable_interactive
    session required pam_exec.so ${pam_kektus}
    session optional ${pkgs.systemd}/lib/security/pam_systemd.so
  '';
  security.pam.services.swaylock.text = config.security.pam.services.login.text;
  security.pam.services.sudo.text = config.security.pam.services.login.text;
}
