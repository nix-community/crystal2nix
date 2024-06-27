# default.nix

{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "crystal2nix";  # Replace with your project name
  version = "1.0.0";  # Replace with your project version

  src = ./.;  # Path to your project directory

  buildInputs = with pkgs; [
    crystal  # Example dependency, replace with actual dependencies
    zlib     # Example dependency, replace with actual dependencies
  ];

  installPhase = ''
    # Assuming Crystal build commands, adjust as per your project's build process
    crystal build src/main.cr -o $out/my_project
  '';
}
