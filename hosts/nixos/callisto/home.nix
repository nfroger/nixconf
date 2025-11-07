{ lib, ... }:

let
  genWorkspaceAssign =
    disp:
    map (n: {
      output = disp;
      workspace = toString n;
    });
in
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
    output = {
      DP-1 = {
        position = "0 0";
        transform = "270";
      };
      DP-2 = {
        position = "1200 0";
      };
    };
    workspaceOutputAssign =
      genWorkspaceAssign "DP-1" [ "11" ] ++ genWorkspaceAssign "DP-2" (builtins.genList (x: x + 1) 5);
  };

  programs.ssh.matchBlocks."fw-cri".hostname = lib.mkForce "10.201.5.2";
}
