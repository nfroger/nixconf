{ pkgs, config, ... }:

{
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
    noto-fonts-color-emoji
    overpass
    roboto
    fira
    ibm-plex
  ];

  environment.systemPackages = with pkgs; [
    lxappearance
    arc-theme
    arc-icon-theme
    capitaine-cursors
    pavucontrol
    libva
    libva-utils
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    xdg-utils
    xfce.thunar
    xfce.thunar-volman
  ];

  xdg.mime.enable = true;

  environment.shellAliases = {
    xdg-open = "handlr";
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      alacritty
      bemenu
      brightnessctl
      gammastep
      grim
      handlr
      imv
      mako
      playerctl
      slurp
      swayidle
      swaylock
      waybar
      wayvnc
      wdisplays
      wf-recorder
      wl-clipboard
      wl-mirror
      xdg-desktop-portal-wlr
      xwayland
    ];
    extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
        export BEMENU_BACKEND=wayland
    '';
    wrapperFeatures.gtk = true;
  };

  programs.waybar.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
  };

  hardware.graphics = {
    enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DBUS_REMOTE = "1";
    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];
    XCURSOR_PATH = [
      "${config.system.path}/share/icons"
      "$HOME/.icons"
      "$HOME/.nix-profile/share/icons/"
    ];
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  services.tumbler.enable = true;
  programs.thunar.plugins = with pkgs; [ xfce.tumbler ];
}
