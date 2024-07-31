{
  description = "C Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pname = "binary";
        version = "0.1";
        src = ./.;
        buildInputs = with pkgs; [
          #zlib
          clang
        ];
        nativeBuildInputs = with pkgs; [
          clang-tools
          pkg-config
          gdb
          mold-wrapped
          just
          valgrind
          cppcheck
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          hardeningDisable = [ "all" ];
          inherit buildInputs nativeBuildInputs;

          # NIX_CFLAGS_COMPILE = [
          #   "-g"
          #   "-O2"
          #   "-Wall"
          #   "-Werror"
          #   "-fuse-ld=mold"
          # ];
          # You can use NIX_LDFLAGS to set the default linker flags for the shell
          #NIX_LDFLAGS = "-L${lib.getLib zstd}/lib -lzstd";
        };

        # Pinned gcc: remain on gcc10 even after `nix flake update`
        #default = pkgs.mkShell.override { stdenv = pkgs.gcc10Stdenv; } {
        #  inherit buildInputs nativeBuildInputs;
        #};
        #
        default = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          inherit buildInputs nativeBuildInputs;
        };

        packages.default = pkgs.stdenv.mkDerivation {
          hardeningDisable = [ "all" ];
          inherit
            buildInputs
            nativeBuildInputs
            pname
            version
            src
            ;

          buildPhase = ''
            just build
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ./build/bin/${pname} $out/bin/
          '';
        };
      }
    );
}
