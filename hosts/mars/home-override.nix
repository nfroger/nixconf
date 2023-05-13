{
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
    dockedHome = {
      outputs = [
        {
          criteria = "eDP-1";
          status = "disable";
        }
        {
          criteria = "BenQ Corporation BenQ XL2411Z 6AF01007SL0";
          position = "1080,470";
        }
        {
          criteria = "BenQ Corporation BenQ GW2480 ETV5L03568SL0";
          position = "0,0";
          transform = "90";
        }
      ];
    };
  };
}
