{ pkgs, ... }:

{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraConfig = "unload-module module-role-cork";
  };
  services.pipewire.enable = true;
  environment.systemPackages = with pkgs; [
    apulse
  ];
}
