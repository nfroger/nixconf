{ pkgs, ... }:

{
  home.packages = with pkgs; [
    krew
    kubectl
    kubectl-doctor
    kubectl-tree
    kubeswitch
    kubent
    kubernetes-helm
    kubespy
    kustomize
    stern

    kubescape
    kube-bench
    popeye
    kube-score
    kube-capacity
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
