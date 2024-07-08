{
  description = "Zig development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nativeBuildInputs = with pkgs; [
          zig
          zls
        ];

        buildInputs = with pkgs; [ ];
      in
      {
        devShells.default = pkgs.mkShell { inherit nativeBuildInputs buildInputs; };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "name";
          version = "0.0.0";
          src = ./.;

          nativeBuildInputs = nativeBuildInputs ++ [ pkgs.zig.hook ];
          inherit buildInputs;
        };
      }
    );
}
