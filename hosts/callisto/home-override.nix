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
        position = "0 440";
      };
      DP-2 = {
        position = "1920 440";
      };
      VGA-1 = {
        position = "3840 0";
        transform = "270";
      };
    };
    workspaceOutputAssign = genWorkspaceAssign "DP-1" (builtins.genList (x: x + 1) 5)
      ++ genWorkspaceAssign "DP-2" (builtins.genList (x: x + 6) 5) ++
      [{
        output = "VGA-1";
        workspace = "11";
      }];
  };
}
