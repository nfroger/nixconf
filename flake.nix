{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsMaster.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, nixpkgsMaster, home-manager, flake-utils, nixos-hardware }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) attrValues optional;
      inherit (flake-utils.lib) eachDefaultSystem defaultSystems;

      pkgImport = pkgs: system: withOverrides:
        import pkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = (attrValues self.overlays) ++ (optional withOverrides self.overrides.${system});
        };

      pkgset = system: {
        pkgs = pkgImport nixpkgs system true;
        pkgsUnstable = pkgImport nixpkgsUnstable system false;
        pkgsMaster = pkgImport nixpkgsMaster system false;
      };

      anySystemOutputs = {
        lib = import ./lib { inherit lib; };

        overlays = import ./pkgs/overlays.nix { inherit lib; };

        nixosConfigurations =
          let
            nixosSystem = hostName:
              let system = "x86_64-linux";
              in
              lib.nixosSystem {
                inherit system;
                specialArgs = {
                  inherit nixos-hardware;
                };
                modules = [
                  ./modules
                  (./. + "/hosts/${hostName}")
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nicolas = {
                      imports = [
                        ./home
                        "${toString ./.}/hosts/${hostName}/home-override.nix"
                      ];
                    };
                  }
                  ({
                    nixpkgs = {
                      inherit system;
                      inherit (pkgset system) pkgs;
                      overlays = [ self.overrides.${system} ];
                    };
                  })
                ];
              };
            hostNames = builtins.attrNames (lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./hosts));
          in
          lib.genAttrs hostNames nixosSystem;
      };

      multiSystemOutputs = eachDefaultSystem (system:
        let
          inherit (pkgset system) pkgs pkgsUnstable pkgsMaster;
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              nixpkgs-fmt
              pre-commit
            ];
          };

          overrides = import ./pkgs/overrides.nix { inherit pkgsUnstable pkgsMaster; };

          packages = (import ./pkgs { inherit lib pkgs; });
        });

    in
    multiSystemOutputs // anySystemOutputs;
}
