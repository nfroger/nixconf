{ config, pkgs, lib, nixpkgs, nixpkgsUnstable, nixpkgsMaster, ... }:

{
  imports = [
    ./sound.nix
    ./gui.nix
  ];

  boot.tmp.useTmpfs = true;

  users.users.nicolas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "input" "kvm" "docker" "video" "dialout" "ubridge" "wireshark" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$2xUbJKyOp0o0Hn2k$mFqM7kCQwqAjwdtuRZRQDrGPZrxV6coKoEHiW0m7AwET6LI9WOn6yT6oVumVbF0dkzfzRQk2/m4vxt45DTlHY/";
  };
  users.groups.ubridge = { };

  documentation.dev.enable = true;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_GB.UTF-8";

  networking.useDHCP = false;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
    gc = {
      options = "--delete-older-than 10d";
    };
    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
        "https://s3next.kektus.xyz/kektus-nix-cache"
      ];
      trusted-public-keys = [
        "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
        "kektus-nix-cache:djm3CvTdE+0Z5F6h1Qjyew3dFi8X5ElpgIyXSvfakr0="
      ];
    };

    registry = {
      nixpkgs.flake = nixpkgs;
      nixpkgsUnstable.flake = nixpkgsUnstable;
      nixpkgsMaster.flake = nixpkgsMaster;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with pkgs; [
    config.boot.kernelPackages.v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];

  # Services
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.pcscd.enable = true; # Smartcard support
  services.printing.enable = true;
  services.smartd.enable = true;

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
  programs.zsh.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  networking.wireguard.enable = true;

  security.pam.krb5.enable = false;
  krb5 = {
    enable = true;
    libdefaults = {
      default_realm = "KEKTUS.XYZ";
      dns_fallback = true;
      dns_canonicalize_hostname = false;
      rnds = false;
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

  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "ubridge";
    permissions = "u+rx,g+x";
  };

  environment.systemPackages = with pkgs; [
    chromium
    cifs-utils
    coreutils-full
    curl
    file
    fzf
    git
    glib
    gnupg
    htop
    irssi
    killall
    ldns
    lm_sensors
    man-pages
    mpv
    ncdu
    neofetch
    neovim
    ntfs3g
    p7zip
    thunderbird
    tmux
    tree
    unzip
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
