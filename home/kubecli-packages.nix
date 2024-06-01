{ pkgs, ... }:

{
  home.packages = with pkgs; [
    krew
    kubectl
    kubectl-doctor
    kubectl-tree
    kubectx
    kubent
    kubernetes-helm
    kubespy
    kustomize
    stern

    kubescape
    kube-bench
    popeye
    kube-score
    kubent
    kube-capacity
  ];
}
