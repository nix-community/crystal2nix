{
  description = "Crystal 2 Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    (with flake-utils.lib; eachSystem defaultSystems) (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

      in
      rec {
        packages = flake-utils.lib.flattenTree rec {
          crystal2nix = pkgs.crystal.buildCrystalPackage {
            pname = "crystal2nix";
            version = "0.3.0";

            src = ./.;

            format = "shards";
            lockFile = ./shard.lock;
            shardsFile = ./shards.nix;

            buildInputs = with pkgs; [ openssl ];

            nativeBuildInputs = with pkgs; [ pkg-config ];
          };

          default = crystal2nix;
        };

        checks = flake-utils.lib.flattenTree {
          specs = packages.crystal2nix;
        };

        devShells = flake-utils.lib.flattenTree {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              openssl
            ];

            nativeBuildInputs = with pkgs; [
              pkg-config
              crystal
              shards
            ];
          };
        };
      });
}
