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
    thunderbird
    discord
    slack
    (wrapFirefox firefox-unwrapped {
      nixExtensions = [
        (fetchFirefoxAddon {
          name = "ublock-origin";
          url = "https://addons.mozilla.org/firefox/downloads/file/3816867/ublock_origin-1.37.2-an+fx.xpi";
          sha256 = "17jmd90d0ix9nm1n2jh4friq5bas6x88nm6x6c765d5cj4cci8xk";
        })
        (fetchFirefoxAddon {
          name = "bitwarden";
          url = "https://addons.mozilla.org/firefox/downloads/file/3831245/bitwarden_free_password_manager-1.52.1-an+fx.xpi";
          sha256 = "1fjbkqb19c733xg4mar31a923zkcpiyk62hs3llwiasd7dfyvmlm";
        })
        (fetchFirefoxAddon {
          name = "sponsorblock";
          url = "https://addons.mozilla.org/firefox/downloads/file/3834324/sponsorblock_skip_sponsorships_on_youtube-3.0.5-an+fx.xpi";
          sha256 = "19928ym85vswwkiz8hqrhc3fv977s0xjh6g7ppbhmdjj783lfy46";
        })
        (fetchFirefoxAddon {
          name = "video-speed-controller";
          url = "https://addons.mozilla.org/firefox/downloads/file/3756025/video_speed_controller-0.6.3.3-an+fx.xpi";
          sha256 = "0ahhaapdxlj74pxb6zhw36m2glgv6xgm2c7gndd2pn8dabrjb8ny";
        })
      ];

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
