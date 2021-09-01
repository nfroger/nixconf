{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsMaster.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgsMaster, home-manager, flake-utils }:
    let
      inherit (nixpkgs) lib;
      inherit (flake-utils.lib) eachDefaultSystem defaultSystems;

      nixpkgsFor = lib.genAttrs defaultSystems (system: import nixpkgs {
        inherit system;
      });

      developEnv = eachDefaultSystem (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              nixpkgs-fmt
              pre-commit
            ];
          };
        });

      myConfig = {
        nixosConfigurations =
          let
            nixosSystem = hostName:
              lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                  (./. + "/hosts/${hostName}")
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nicolas = import ./home.nix;
                  }
                ];
              };
            hostNames = builtins.attrNames (lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./hosts));
          in
          lib.genAttrs hostNames nixosSystem;
      };

    in
    developEnv // myConfig;
}
