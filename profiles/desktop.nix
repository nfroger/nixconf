let
  sshkeys = import ../vars/ssh_keys.nix;
in
{
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh = {
    enable = true;
    port = 22;
    authorizedKeys = [ sshkeys.nicolas ];
    hostKeys = [ "/etc/ssh/ssh_host_rsa_key" "/etc/ssh/ssh_host_ed25519_key" ];
  };

  services.lldpd.enable = true;
}
