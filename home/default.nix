{ pkgs, config, lib, ... }:

{
  imports = [
    ./gui
    ./nvim.nix
    ./slrn.nix
  ];

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
        condition = "gitdir:~/Documents/epita/";
        contents = {
          user = {
            email = "nicolas.froger@epita.fr";
          };
        };
      }
      {
        condition = "gitdir:~/Documents/zelros/";
        contents = {
          user = {
            email = "nicolas.froger@zelros.com";
            signingKey = "E5C5184FEC5F8C6AB7BD56AC8552733297F5B117";
          };
        };
      }
    ];
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      theme = "gallifrey";
      plugins = [ "git" ];
    };
    shellAliases = {
      cat = "bat";
      ls = "ls -hN --color=auto --group-directories-first";
      k = "kubectl";
      kns = "kubens";
      kcx = "kubectx";
      os = "openstack";
    };
    initExtra = ''
      source <(kubectl completion zsh)
      complete -F __start_kubectl k
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[»](bold white)";
        error_symbol = "[»](bold red)";
      };
      directory = {
        truncate_to_repo = false;
      };
      kubernetes = {
        disabled = false;
      };
    };
  };

  programs.ssh = {
    enable = true;
    forwardAgent = false;
    controlMaster = "yes";
    controlPersist = "yes";
    matchBlocks = {
      "*.kektus.xyz" = {
        user = "root";
      };

      # CRI
      "fw-cri" = {
        hostname = "gate.cri.epita.fr";
        user = "root";
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
      "acu-bastion" = {
        hostname = "bastion.iaas.assistants.epita.fr";
        user = "root";
      };
      "*.assistants.openstack.epita.fr" = {
        proxyJump = "acu-bastion";
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
