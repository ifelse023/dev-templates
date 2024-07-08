{
  description = "C Template";

  inputs = {
    nixpkgs.url = "nixpkgs";
    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pname = "memory-leak-creator";
        version = "0.1";
        src = ./.;
        buildInputs = with pkgs; [
          #zlib
        ];
        nativeBuildInputs = with pkgs; [
          pkg-config
          gnumake
          gdb

          clang-tools
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;

          # You can use NIX_CFLAGS_COMPILE to set the default CFLAGS for the shell
          #NIX_CFLAGS_COMPILE = "-g";
          # You can use NIX_LDFLAGS to set the default linker flags for the shell
          #NIX_LDFLAGS = "-L${lib.getLib zstd}/lib -lzstd";
        };

        # Pinned gcc: remain on gcc10 even after `nix flake update`
        #default = pkgs.mkShell.override { stdenv = pkgs.gcc10Stdenv; } {
        #  inherit buildInputs nativeBuildInputs;
        #};

        efault = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          inherit buildInputs nativeBuildInputs;
        };

        packages.default = pkgs.stdenv.mkDerivation {
          inherit
            buildInputs
            nativeBuildInputs
            pname
            version
            src
            ;
        };
      }
    );
}
