{ pkgs, lib, ... }:

{
  imports = [
    ./sound.nix
    ./gui.nix
  ];

  users.users.nicolas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "input" "kvm" "docker" "video" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$2xUbJKyOp0o0Hn2k$mFqM7kCQwqAjwdtuRZRQDrGPZrxV6coKoEHiW0m7AwET6LI9WOn6yT6oVumVbF0dkzfzRQk2/m4vxt45DTlHY/";
  };

  documentation.dev.enable = true;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_GB.UTF-8";

  networking.useDHCP = false;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  services.pcscd.enable = true;

  services.gvfs.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  environment.systemPackages = with pkgs; [
    coreutils-full
    file
    tree
    htop
    unzip
    zip
    p7zip
    killall
    manpages
    cifs-utils
    ntfs3g
    ldns
    wget
    neovim
    curl
    git
    fzf
    gnupg
    yubikey-manager
    neofetch
    jq
    glib
    zathura
    irssi
    vault
    packer
    awscli
    terraform_0_15
    ansible
    kubectl
    tmux
    firefox
    discord
    slack
  ];

  programs.neovim.vimAlias = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
