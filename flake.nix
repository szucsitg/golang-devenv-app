{
  description = "Devenv Go App";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, gitignore, flake-compat, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = rec {
          devenv-app = pkgs.buildGoModule {
            name = "devenv-app";
            src = gitignore.lib.gitignoreSource ./.;
            vendorSha256 = null;
            GOFLAGS="-mod=vendor";
          };
          default = devenv-app;
        };
        apps = rec {
          devenv-app = flake-utils.lib.mkApp { drv = self.packages.${system}.devenv-app; };
          default = devenv-app;
        };
      });
}
