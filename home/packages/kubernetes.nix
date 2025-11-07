{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kubectl
    kubeswitch
    kubernetes-helm
    kustomize
    stern
  ];

  programs.zsh.initContent =
    let
      kubeswitchZshFiles =
        pkgs.runCommand "kubeswitch-shell-files-for-zsh"
          {
            nativeBuildInputs = [ pkgs.kubeswitch ];
          }
          ''
            mkdir -p $out/share
            switcher init zsh | sed "s/switch(/kubeswitch(/" > "$out/share/kubeswitch_init.zsh"
            switcher --cmd kubeswitch completion zsh > "$out/share/kubeswitch_completion.zsh"
          '';
    in
    ''
      source ${kubeswitchZshFiles}/share/kubeswitch_init.zsh
      source ${kubeswitchZshFiles}/share/kubeswitch_completion.zsh
    '';
}
