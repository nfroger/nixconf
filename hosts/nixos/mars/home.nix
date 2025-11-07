{
  imports = [
    ../../../home
    ../../../home/nixos.nix

    ../../../home/packages/dev.nix
    ../../../home/packages/gui.nix
    ../../../home/packages/kubernetes.nix
    ../../../home/packages/tools.nix
  ];

  wayland.windowManager.sway.config = {
    input = {
      "1739:31251:SYNA2393:00_06CB:7A13_Touchpad" = {
        natural_scroll = "enabled";
        tap = "enabled";
      };
    };
  };

  services.kanshi.profiles = {
    normal = {
      outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
        }
      ];
    };
    dockedWork = {
      outputs = [
        {
          criteria = "eDP-1";
          position = "2560,360";
        }
        {
          criteria = "Dell Inc. DELL P3222QE 1DMSXG3";
          position = "0,0";
          scale = 1.5;
        }
      ];
    };
  };
}
