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
      DP-1 = {
        position = "0,0";
        transform = "270";
      };
      HDMI-A-1 = {
        position = "1080,500";
      };
    };
    workspaceOutputAssign = genWorkspaceAssign "HDMI-A-1" (builtins.genList (x: x + 1) 5)
      ++ genWorkspaceAssign "DP-1" (builtins.genList (x: x + 6) 5);
  };
}
