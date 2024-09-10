let
  genWorkspaceAssign = disp:
    map (n: {
      output = disp;
      workspace = toString n;
    });
in
{
  wayland.windowManager.sway.config = {
    output = {
      DP-2 = {
        mode = "1920x1080@165Hz";
        position = "1080,410";
      };
      HDMI-A-1 = {
        position = "0,0";
        transform = "270";
      };
    };
    workspaceOutputAssign = [
      {
        output = "HDMI-A-1";
        workspace = "11";
      }
    ];
  };
}
