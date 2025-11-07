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
      "2:7:SynPS/2_Synaptics_TouchPad" = {
        natural_scroll = "enabled";
      };
    };
  };
}
