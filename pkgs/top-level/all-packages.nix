{
  termtrack = {
    path = ../applications/science/astronomy/termtrack;
    callPackage = final: prev: final.python3Packages.callPackage;
  };

  kubectl-view-allocations = ../applications/applications/networking/cluster/kubectl-view-allocations;
}
