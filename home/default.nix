{ pkgs, config, lib, ... }:

{
  imports = [
    ./gui
    ./nvim.nix
    ./packages.nix
    ./shell.nix
    ./slrn.nix
    ./kubecli-packages.nix
  ];

  home.stateVersion = "18.09";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    LESS_TERMCAP_mb = "[1;32m";
    LESS_TERMCAP_md = "[1;32m";
    LESS_TERMCAP_me = "[0m";
    LESS_TERMCAP_se = "[0m";
    LESS_TERMCAP_so = "[01;33m";
    LESS_TERMCAP_ue = "[0m";
    LESS_TERMCAP_us = "[1;4;31m";
    CLIFF_FIT_WIDTH = "1"; # for OpenStack CLI table width
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
        hostname = "91.243.117.211";
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
      "callisto" = {
        hostname = "gate.cri.epita.fr";
        port = 22426;
        user = "nicolas";
      };
      "*.cri.epita.fr" = {
        proxyJump = "fw-cri";
        user = "root";
      };
      "*.forge.epita.fr" = {
        proxyJump = "fw-cri";
        user = "root";
      };
      "os-bastion" = {
        hostname = "bastion.iaas.cri.epita.fr";
        user = "root";
        port = 2222;
      };
      "*.cri.openstack.epita.fr" = {
        proxyJump = "os-bastion";
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
      "git.cri.epita.fr" = {
        extraOptions = {
          GSSAPIAuthentication = "yes";
        };
      };
      "ssh.cri.epita.fr" = {
        extraOptions = {
          GSSAPIAuthentication = "yes";
          GSSAPIDelegateCredentials = "yes";
        };
      };
    };
  };
}
