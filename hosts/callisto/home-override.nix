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
      VGA-1 = {
        position = "0 0";
        transform = "270";
      };
      DP-2 = {
        position = "1080 420";
      };
      DP-1 = {
        position = "3000 420";
      };
    };
    workspaceOutputAssign = genWorkspaceAssign "DP-2" (builtins.genList (x: x + 1) 5)
      ++ genWorkspaceAssign "DP-1" (builtins.genList (x: x + 6) 5) ++
      [{
        output = "VGA-1";
        workspace = "11";
      }];
  };

  programs.ssh.matchBlocks."fw-cri".hostname = lib.mkForce "10.201.5.2";
}
