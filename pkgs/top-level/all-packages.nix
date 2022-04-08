{
  discord = {
    path = ../applications/networking/instant-messengers/discord;
    args = final: prev: { inherit (prev) discord; };
  };
  vscodium = {
    path = ../applications/editors/vscode/vscodium.nix;
    args = final: prev: { inherit (prev) vscodium; };
  };
}
