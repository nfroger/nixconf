{ pkgs, config, lib, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    LESS_TERMCAP_mb = "$'\\e[1;32m'";
    LESS_TERMCAP_md = "$'\\e[1;32m'";
    LESS_TERMCAP_me = "$'\\e[0m'";
    LESS_TERMCAP_se = "$'\\e[0m'";
    LESS_TERMCAP_so = "$'\\e[01;33m'";
    LESS_TERMCAP_ue = "$'\\e[0m'";
    LESS_TERMCAP_us = "$'\\e[1;4;31m'";
  };

  wayland.windowManager.sway =
    let
      sysmenu = "system:  [l]ogout  [p]oweroff  [r]eboot [s]uspend";
    in
    {
      enable = true;
      config = {
        modifier = "Mod4";
        menu = "${pkgs.bemenu}/bin/bemenu-run -l 10 -i -p '>' -m -1 -n --fn 'Overpass Mono 11'";
        startup = [
          { command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'"; }
          { command = "${pkgs.xfce.thunar}/bin/thunar --daemon"; }
          { command = "${pkgs.mako}/bin/mako"; }
          { command = "systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP"; }
          { command = "dbus-update-activation-environment WAYLAND_DISPLAY"; }
          { command = "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY DBUS_SESSION_BUS_ADDRESS SWAYSOCK"; }
        ];
        terminal = "${pkgs.alacritty}/bin/alacritty";
        bars = [ ]; # empty because waybar is launched by systemd
        gaps = {
          inner = 10;
          outer = 5;
        };
        input = {
          "type:pointer" = {
            accel_profile = "flat";
          };
          "type:keyboard" = {
            xkb_layout = "us";
            xkb_options = "compose:rctrl";
            xkb_variant = "altgr-intl";
          };
        };
        output = {
          "*" = {
            bg = (builtins.fetchurl {
              url = https://static.k8s.kektus.xyz/uploads/iss063e034054.jpg;
              sha256 = "0fd43jgl4b2j8dyv800fvqzfijjsr48khapw11s75vc19glwrkab";
            }) + " fill";
          };
        };
        window = {
          hideEdgeBorders = "both";
          commands = [
            {
              criteria = {
                title = "win0";
                class = "jetbrains-idea-ce";
              };
              command = "floating enable";
            }
            {
              criteria = {
                title = "Welcome to IntelliJ IDEA";
              };
              command = "floating enable";
            }
          ];
        };
        modes = {
          "${sysmenu}" = {
            l = "exit";
            p = "exec poweroff";
            r = "exec reboot";
            s = "exec systemctl suspend;mode default";
            Return = "mode default";
            Escape = "mode default";
          };
        };
        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in
          lib.mkOptionDefault
            {
              "${modifier}+Delete" = "mode \"${sysmenu}\"";
              "${modifier}+L" = "exec swaylock -F -e -l -c 212121 --indicator-idle-visible";
              Print = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | wl-copy";
            };
      };
    };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window.padding = {
        x = 20;
        y = 20;
      };
      font = {
        normal = {
          family = "Source Code Pro";
          style = "Medium";
        };
        size = 12;
        offset.x = -1;
      };
      background_opacity = 0.95;
    };
  };

  programs.mako = {
    enable = true;
    backgroundColor = "#424242";
    borderRadius = 5;
    borderSize = 0;
    defaultTimeout = 10000;
    padding = "10";
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "bottom";
        height = 32;
        margin = "0 5 5";
        modules = {
          "sway/workspaces" = {
            disable-scroll = false;
            disable-markup = false;
            all-outputs = false;
            format = "{name}";
          };
          "sway/mode" = {
            format = "{}";
          };
          tray = {
            icon-size = 21;
            spacing = 10;
          };
          clock = {
            format = "{:%Y-%m-%d | %H:%M}";
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };
          cpu = {
            format = "{usage}% ";
          };
          memory = {
            format = "{}% ";
          };
          temperature = {
            hwmon-path = "";
            critical-threshold = 80;
            format-critical = "{temperatureC}°C ";
            format = "{temperatureC}°C ";
          };
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = [ "" "" "" "" "" ];
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
            format-disconnected = "Disconnected ⚠";
            interval = 7;
          };
          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              default = [ "" "" ];
            };
            on-click = "pavucontrol";
          };
        };
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "clock" "tray" ];
      }
    ];
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: Overpass,'Font Awesome 5', sans-serif;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background: #212121;
          border-radius: 4px;
          color: #ffffff;
      }

      window#waybar.hidden {
          opacity: 0.0;
      }

      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: #ffffff;
          padding-top: 3px;
          border-bottom: 3px solid transparent;
      }

      #workspaces button.focused {
          background: #484848;
          border-bottom: 3px solid #1e88e5;
      }

      #workspaces button.urgent {
          background-color: #ef5350;
      }

      #mode {
          background: #1e88e5;
          color: #000000;
          border-bottom: 3px solid #ffffff;
      }

      #clock, #battery, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #custom-media, #tray, #mode, #idle_inhibitor {
          padding: 0 5px;
          margin: 0 5px;
      }

      #clock {
          border-top: 3px solid transparent;
          border-bottom: 3px solid #1e88e5;
      }

      #battery.charging {
          color: #000000;
          background-color: #689f38;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      #battery.critical:not(.charging) {
          background: #ef5350;
          color: #000000;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }
    '';
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.overpass;
      name = "Overpass Semi-Bold";
      size = 11;
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc";
    };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "capitaine-cursors";
    };
  };

  home.packages = with pkgs; [ capitaine-cursors ];

  services.gammastep = {
    enable = true;
    latitude = 48.9;
    longitude = 2.15;
    temperature = {
      day = 7000;
      night = 2500;
    };
    settings = {
      general = {
        adjustment-method = "wayland";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Nicolas Froger";
    userEmail = "nicolas@kektus.xyz";
    signing = {
      signByDefault = true;
      key = "00BD4B2A4EBA035CC102E0B5B7D7C14018816976";
    };
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
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    #coc = {
    #  enable = true;
    #};
    plugins = with pkgs.vimPlugins; [
      emmet-vim
      {
        plugin = vimtex;
        config = ''
              let g:latex_view_general_viewer = "zathura"
          let g:vimtex_view_method = "zathura"
          let g:tex_flavor = "latex"
        '';
      }
      {
        plugin = onedark-vim;
        config = ''
          packadd! onedark-vim

          let g:onedark_color_overrides = {
                      \ "black": {"gui": "#1c1c1c", "cterm": "235", "cterm16": "0" }
          \}

          " onedark.vim override: Don't set a background color when running in a terminal;
          " just use the terminal's background color
          " `gui` is the hex color code used in GUI mode/nvim true-color mode
          " `cterm` is the color code used in 256-color mode
          " `cterm16` is the color code used in 16-color mode
          if (has("autocmd") && !has("gui_running"))
            augroup colorset
              autocmd!
              let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
              autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
            augroup END
          endif

          set background=dark
          colorscheme onedark
          let g:airline_theme = "onedark"

          if (has("termguicolors"))
            set termguicolors
          endif
        '';
      }
      vim-polyglot
    ];
    extraConfig = ''
      set nocompatible
      filetype off

      " Enable syntax highlight
      syntax on
      " Enable filetype detection for plugins and indentation options
      filetype plugin indent on
      " Force encoding to UTF-8
      set encoding=utf-8
      " Reload file when changed
      set autoread
      " Set amount of lines under and above cursor
      set scrolloff=5
      " Show command being executed
      set showcmd
      " Show current mode
      set showmode
      " Always show status line
      set laststatus=2
      " Display whitespace characters
      set list
      set listchars=tab:›\ ,eol:¬,trail:⋅
      " Indentation options
      """""""""""""""""""""""""""""
      " Length of a tab
      " Read somewhere it should always be 8
      set tabstop=8
      " Number of spaces inserted when using < or >
      set shiftwidth=4
      " Number of spaces inserted with Tab
      " -1 = same as shiftwidth
      set softtabstop=-1
      " Insert spaces instead of tabs
      set expandtab
      " When tabbing manually, use shiftwidth instead of tabstop and softtabstop
      set smarttab
      set autoindent
      nnoremap <silent> <space> za
      set foldlevel=99
      set t_Co=256
      set vb t_vb=".
      set smartcase
      set browsedir=buffer
      set tw=80
      set wrap
      set mouse=a
      set relativenumber

      set number
      set colorcolumn=80
      highlight colorcolumn ctermbg=4

      set clipboard=unnamed
    '';
  };

  programs.bat = {
    enable = true;
  };
}
