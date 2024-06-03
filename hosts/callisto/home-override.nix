{ lib, ... }:

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
        position = "0 0";
      };
      DP-2 = {
        position = "1920 0";
      };
    };
    workspaceOutputAssign = genWorkspaceAssign "DP-1" (builtins.genList (x: x + 1) 5)
      ++ genWorkspaceAssign "DP-2" (builtins.genList (x: x + 6) 5);
  };

  programs.ssh.matchBlocks."fw-cri".hostname = lib.mkForce "10.201.5.2";
}
