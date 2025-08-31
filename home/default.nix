{ pkgs, config, lib, ... }:

{
  imports = [
    ./gui
    ./nvim.nix
    ./packages.nix
    ./shell.nix
    ./kubecli-packages.nix
  ];

  home.stateVersion = "18.09";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    CLIFF_FIT_WIDTH = "1"; # for OpenStack CLI table width
    AWS_EC2_METADATA_DISABLED = "true";
  };

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
