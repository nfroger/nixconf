{ pkgs, config, lib, ... }:

let
  backgroundPicture = builtins.fetchurl {
    url = https://s3.kektus.fr/kektus-uploads/DSC00554.jpg;
    sha256 = "0ggicqmfbh9cfwhjgyviaisbr93fqyvhz8wb0kc3kdff3hww4fp9";
  };

  swaylockCommand = "${pkgs.swaylock}/bin/swaylock -F -e -l -i ${backgroundPicture} --indicator-idle-visible";
in
{
  programs.zsh.loginExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';

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
          { command = "${pkgs.xfce.thunar}/bin/thunar --daemon"; }
          { command = "${pkgs.mako}/bin/mako"; }
          { command = "systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP"; }
          { command = "dbus-update-activation-environment WAYLAND_DISPLAY"; }
          { command = "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY DBUS_SESSION_BUS_ADDRESS SWAYSOCK"; }
        ];
        terminal = "${pkgs.alacritty}/bin/alacritty";
        bars = [ ]; # empty because waybar is launched by systemd
        fonts = {
          names = [ "Overpass" ];
          size = 11.0;
        };
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
            bg = backgroundPicture + " fill";
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
            {
              criteria = {
                app_id = "thunderbird";
                title = "^$";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "thunderbird";
                title = "^$";
              };
              command = "sticky enable";
            }
          ];
        };
        modes = lib.mkOptionDefault {
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
              "${modifier}+0" = "workspace 10";
              "${modifier}+Shift+0" = "move container to workspace number 10";
              "${modifier}+Delete" = "mode \"${sysmenu}\"";
              "${modifier}+t" = "exec ${swaylockCommand}";
              "${modifier}+c" = "exec firefox";
              Print = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | wl-copy";
              "Shift+Print" = "exec ${pkgs.grim}/bin/grim - | wl-copy";
              "${modifier}+p" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | wl-copy";
              "${modifier}+Shift+p" = "exec ${pkgs.grim}/bin/grim - | wl-copy";
              XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
              XF86MonBrightnessUp = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
              XF86AudioMute = "exec ${pkgs.alsa-utils}/bin/amixer -q set Master toggle";
              XF86AudioLowerVolume = "exec ${pkgs.alsa-utils}/bin/amixer -q set Master 5%-";
              XF86AudioRaiseVolume = "exec ${pkgs.alsa-utils}/bin/amixer -q set Master 5%+";
              XF86AudioMicMute = "exec ${pkgs.alsa-utils}/bin/amixer -q set Capture toggle";
              XF86AudioPlay = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
              XF86AudioNext = "exec ${pkgs.playerctl}/bin/playerctl next";
              XF86AudioPrev = "exec ${pkgs.playerctl}/bin/playerctl previous";
            };
      };
    };

  systemd.user.services.swayidle = {
    Unit = {
      Description = "Swayidle as systemd service";
      Documentation = "man:swayidle(1)";
      Requires = [ "sway-session.target" ];
      PartOf = "sway-session.target";
    };

    Service = {
      ExecStart = ''${pkgs.swayidle}/bin/swayidle \
        timeout 120 '${swaylockCommand}' \
        timeout 200 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
          resume '${pkgs.sway}/bin/swaymsg "output * dpms on"' \
        before-sleep '${swaylockCommand}'
      '';
    };

    Install = { WantedBy = [ "sway-session.target" ]; };
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

  services.kanshi.enable = true;
}
