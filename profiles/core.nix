{ pkgs, lib, ... }:

{
  imports = [
    ./sound.nix
    ./gui.nix
  ];

  boot.tmpOnTmpfs = true;

  users.users.nicolas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "input" "kvm" "docker" "video" "dialout" ];
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
    autoOptimiseStore = true;
    gc = {
      options = "--delete-older-than 10d";
    };
    optimise.automatic = true;

    binaryCaches = [
      "https://cache.nix.cri.epita.fr/"
    ];
    binaryCachePublicKeys = [
      "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with pkgs; [
    linuxPackages.v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];

  # Services
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.pcscd.enable = true; # Smartcard support
  services.printing.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;

  programs.neovim.vimAlias = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.shellInit = ''
    if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    fi
  '';

  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.wireguard.enable = true;

  krb5 = {
    enable = true;
    libdefaults = {
      default_realm = "KEKTUS.XYZ";
      dns_fallback = true;
      dns_canonicalize_hostname = false;
      rnds = false;
      forwardable = true;
    };

    realms = {
      "CRI.EPITA.FR" = {
        admin_server = "kerberos.pie.cri.epita.fr";
      };
      "UNDERCLOUD.CRI.EPITA.FR" = {
        admin_server = "kerberos.undercloud.cri.epita.fr";
      };
      "KEKTUS.XYZ" = {
        admin_server = "kerberos.kektus.xyz";
        kdc = "kerberos.kektus.xyz";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    ansible
    awscli
    azure-cli
    chromium
    cifs-utils
    claws-mail
    coreutils-full
    curl
    discord
    file
    fzf
    git
    git-crypt
    glib
    gnupg
    htop
    irssi
    jq
    killall
    krew
    kubectl
    kubectx
    kubernetes-helm
    ldns
    lm_sensors
    manpages
    minio-client
    mpv
    neofetch
    neovim
    ntfs3g
    p7zip
    packer
    slack
    spotify
    terraform_0_15
    thunderbird
    tmux
    tree
    unzip
    vault
    virt-manager
    vscodium
    wget
    yubikey-manager
    zathura
    zip
    (wrapFirefox firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
        FirefoxHome = {
          Search = false;
          TopSites = false;
          Highlights = false;
          Pocket = false;
          Snippets = false;
        };
        Homepage = {
          StartPage = "none";
        };
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        PasswordManagerEnabled = false;
        Bookmarks = [
          {
            Title = "Google";
            URL = "https://google.com";
            Favicon = "https://google.com/favicon.ico";
            Placement = "toolbar";
          }
        ];
      };
    })
  ];
}
