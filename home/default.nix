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
    userName = "Nicolas Froger";
    userEmail = "nicolas@kektus.xyz";
    signing = {
      signByDefault = true;
      key = "00BD4B2A4EBA035CC102E0B5B7D7C14018816976";
    };
    extraConfig = {
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
    forwardAgent = false;
    controlMaster = "yes";
    controlPersist = "10m";
    matchBlocks = {
      "*.kektus.xyz" = {
        user = "root";
      };

      # CRI
      "fw-cri" = {
        hostname = "91.243.117.1";
        user = "root";
      };
      "sw-core-cri" = {
        hostname = "192.168.200.240";
        user = "manager";
        extraOptions = {
          "HostKeyAlgorithms" = "+ssh-rsa";
          "KexAlgorithms" = "diffie-hellman-group14-sha1";
        };
      };
      "sw-rack-d-cri" = {
        hostname = "192.168.200.74";
        user = "admin";
        extraOptions = {
          "HostKeyAlgorithms" = "+ssh-rsa";
        };
      };
      "sw-mgmt-cri" = {
        hostname = "192.168.200.241";
        user = "manager";
        extraOptions = {
          "HostKeyAlgorithms" = "+ssh-rsa";
          "KexAlgorithms" = "diffie-hellman-group1-sha1";
        };
      };
      "os-bastion" = {
        hostname = "bastion.iaas.cri.epita.fr";
        user = "root";
        port = 2222;
      };
      "play-bastion" = {
        hostname = "bastion.cri-playground.iaas.epita.fr";
        user = "root";
      };
      "lre-bastion" = {
        hostname = "admin-svc.lre.iaas.epita.fr";
        user = "root";
      };
      "callisto" = {
        hostname = "10.201.4.10";
        user = "nicolas";
        proxyJump = "fw-cri";
      };

      "gitlab.cri.epita.fr" = lib.hm.dag.entryBefore [ "*.cri.epita.fr" ] {
        proxyJump = "none";
        extraOptions = {
          GSSAPIAuthentication = "yes";
        };
      };
      "git.forge.epita.fr" = lib.hm.dag.entryBefore [ "*.forge.epita.fr" ] {
        proxyJump = "none";
        extraOptions = {
          GSSAPIAuthentication = "yes";
        };
      };
      "git.exam.forge.epita.fr" = lib.hm.dag.entryBefore [ "*.forge.epita.fr" ] {
        proxyJump = "none";
        extraOptions = {
          GSSAPIAuthentication = "yes";
        };
      };
      "ssh.cri.epita.fr" = lib.hm.dag.entryBefore [ "*.cri.epita.fr" ] {
        proxyJump = "none";
        extraOptions = {
          GSSAPIAuthentication = "yes";
          GSSAPIDelegateCredentials = "yes";
        };
      };

      "*.cri.epita.fr" = {
        proxyJump = "fw-cri";
        user = "root";
      };
      "*.forge.epita.fr" = {
        proxyJump = "fw-cri";
        user = "root";
      };
      "*.cri.openstack.epita.fr" = {
        proxyJump = "os-bastion";
        user = "root";
      };
      "*.cri_playground.openstack.epita.fr" = {
        proxyJump = "play-bastion";
        user = "root";
      };
      "*.lre.openstack.epita.fr" = {
        proxyJump = "lre-bastion";
        user = "root";
      };
      "*.3ie.fr" = {
        proxyJump = "fw-cri";
        user = "root";
      };
      "3ie-bastion" = {
        hostname = "bastion.iaas.3ie.epita.fr";
        user = "root";
      };
      "*.3ie.openstack.epita.fr" = {
        proxyJump = "3ie-bastion";
        user = "root";
      };
    };
  };
}
