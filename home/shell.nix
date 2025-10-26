{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "gallifrey";
      plugins = [ "git" ];
    };
    shellAliases = {
      cat = "bat";
      ls = "ls -hN --color=auto --group-directories-first";
      k = "kubectl";
      kcx = "kubeswitch";
      kns = "kubeswitch ns";
      os = "openstack";
    };
    initContent = ''
      source <(kubectl completion zsh)
      complete -F __start_kubectl k
    '';
    envExtra = ''
      export MANPAGER='sh -c "col -bx | bat -l man -p"'
      export MANROFFOPT="-c";
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

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    daemon.enable = true;
    settings = {
      sync_address = "https://atuin.kektus.xyz";
    };
  };
}
