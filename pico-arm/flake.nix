{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default =
            pkgs.mkShell.override
              {
                stdenv = pkgs.clangStdenv;
              }
              {
                packages = with pkgs; [
                  gcc-arm-embedded-13
                  cmake
                  ninja
                  gdb
                  neocmakelsp
                  tio
                  # cppcheck
                ];
                shellHook = '''';
              };
        }
      );
    };
}
