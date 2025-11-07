{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = "nix-command flakes";

  users.users.nicolas = {
    name = "nicolas";
    home = "/Users/nicolas";
  };

  programs.zsh.enable = true;

  system.stateVersion = 6;
}
