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
                  pico-sdk
                  gcc-arm-embedded-13
                  cmake
                  ninja
                  # cppcheck
                ];
                shellHook = ''
                  export PICO_SDK_PATH=${pkgs.pico-sdk}/lib/pico-sdk
                '';
              };
        }
      );
    };
}
