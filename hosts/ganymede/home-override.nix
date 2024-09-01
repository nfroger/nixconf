{
  wayland.windowManager.sway.config = {
    input = {
      "1267:12809:ELAN067F:00_04F3:3209_Touchpad" = {
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
    dockedHome = {
      outputs = [
        {
          criteria = "eDP-1";
          status = "disable";
        }
        {
          criteria = "BNQ BenQ XL2411Z 6AF01007SL0";
          position = "1080,470";
        }
        {
          criteria = "BNQ BenQ GW2480 ETV5L03568SL0";
          position = "0,0";
          transform = "90";
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
