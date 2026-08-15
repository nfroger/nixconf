{ pkgs
, config
, lib
, ...
}:

{
  imports = [
    ./nvim.nix
    ./shell.nix
  ];

  home.stateVersion = "18.09";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    CLIFF_FIT_WIDTH = "1"; # for OpenStack CLI table width
    AWS_EC2_METADATA_DISABLED = "true";

    IDEA_JDK = "${pkgs.jdk}/lib/openjdk";
  };

  programs.gpg = {
    enable = true;
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      require-secmem = true;
      no-symkey-cache = true;
      armor = true;
      use-agent = true;
      throw-keyids = true;
    };
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
  };
  home.sessionVariablesExtra = ''
    export SSH_AUTH_SOCK="$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)"
  '';

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "00BD4B2A4EBA035CC102E0B5B7D7C14018816976";
    };
    settings = {
      user = {
        name = "Nicolas Froger";
        email = "nicolas@kektus.fr";
      };
      format.signOff = true;
      pager.branch = false;
      pull.rebase = true;
    };
    ignores = [ ".direnv" ];
    lfs.enable = true;
    includes = [
      {
        condition = "gitdir:~/Documents/cri/";
        contents = {
          user = {
            email = "nico@cri.epita.fr";
          };
        };
      }
      {
        condition = "gitdir:~/Documents/forge/";
        contents = {
          user = {
            email = "nico@cri.epita.fr";
          };
        };
      }
      {
        condition = "gitdir:~/Documents/teachings/";
        contents = {
          user = {
            email = "nico@cri.epita.fr";
          };
        };
      }
      {
        condition = "gitdir:~/Documents/epita/";
        contents = {
          user = {
            email = "nicolas.froger@epita.fr";
          };
        };
      }
    ];
  };

  programs.ssh = {
    enable = true;
    settings = {
      "*" = {
        ForwardAgent = "no";
        ControlMaster = "yes";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "10m";
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        Compression = "no";
        AddKeysToAgent = "no";
        HashKnownHosts = "no";
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };

      "*.kektus.xyz" = {
        User = "root";
      };

      # CRI
      "fw-cri" = {
        HostName = "91.243.117.1";
        User = "root";
      };
      "sw-core-cri" = {
        HostName = "192.168.200.240";
        User = "manager";
        HostKeyAlgorithms = "+ssh-rsa";
        KexAlgorithms = "diffie-hellman-group14-sha1";
      };
      "os-bastion" = {
        Hostname = "bastion.iaas.cri.epita.fr";
        User = "root";
        Port = 2222;
      };
      "play-bastion" = {
        HostName = "bastion.cri-playground.iaas.epita.fr";
        User = "root";
      };
      "lre-bastion" = {
        HostName = "admin-svc.lre.iaas.epita.fr";
        User = "root";
      };
      "callisto" = {
        HostName = "10.201.4.10";
        User = "nicolas";
        ProxyJump = "fw-cri";
      };

      "gitlab.cri.epita.fr" = lib.hm.dag.entryBefore [ "*.cri.epita.fr" ] {
        ProxyJump = "none";
        GSSAPIAuthentication = "yes";
      };
      "git.forge.epita.fr" = lib.hm.dag.entryBefore [ "*.forge.epita.fr" ] {
        ProxyJump = "none";
        GSSAPIAuthentication = "yes";
      };
      "git.exam.forge.epita.fr" = lib.hm.dag.entryBefore [ "*.forge.epita.fr" ] {
        ProxyJump = "none";
        GSSAPIAuthentication = "yes";
      };
      "ssh.cri.epita.fr" = lib.hm.dag.entryBefore [ "*.cri.epita.fr" ] {
        ProxyJump = "none";
        GSSAPIAuthentication = "yes";
        GSSAPIDelegateCredentials = "yes";
      };

      "*.cri.epita.fr" = {
        User = "root";
      };
      "*.forge.epita.fr" = {
        User = "root";
      };
      "*.cri.openstack.epita.fr" = {
        ProxyJump = "os-bastion";
        User = "root";
      };
      "*.cri_playground.openstack.epita.fr" = {
        ProxyJump = "play-bastion";
        User = "root";
      };
      "forge-dev" = {
        HostName = "nico-dev.cri_playground.openstack.epita.fr";
        ProxyJump = "play-bastion";
        User = "nicolas";
        ForwardAgent = "yes";
        RemoteForward = "/run/user/1001/gnupg/S.gpg-agent /Users/nicolas/.gnupg/S.gpg-agent.extra";
        ExitOnForwardFailure = "yes";
      };
      "mercury" = {
        HostName = "10.10.220.10";
        User = "nicolas";
        ForwardAgent = "yes";
        RemoteForward = "/run/user/1001/gnupg/S.gpg-agent /Users/nicolas/.gnupg/S.gpg-agent.extra";
        ExitOnForwardFailure = "yes";
      };
      "*.lre.openstack.epita.fr" = {
        ProxyJump = "lre-bastion";
        User = "root";
      };
    };
  };
}
