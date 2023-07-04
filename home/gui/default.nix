{ pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        opacity = 0.95;
        padding = {
          x = 20;
          y = 20;
        };
      };
      font = {
        normal = {
          family = "Source Code Pro";
          style = "Medium";
        };
        size = 12;
        offset.x = -1;
      };
    };
  };

  services.mako = {
    enable = true;
    backgroundColor = "#424242";
    borderRadius = 5;
    borderSize = 0;
    defaultTimeout = 10000;
    padding = "10";
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

  home = {
    packages = with pkgs; [ capitaine-cursors ];
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      x11.enable = true;
      gtk.enable = true;
    };
  };

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
}
