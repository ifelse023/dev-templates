{
  description = "A Nix-flake-based PlatformIO development environment";

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
          default = pkgs.mkShell {
            packages = with pkgs; [
              # clang-tools
              # cppcheck
              platformio-core.udev
              platformio
              ncurses5
            ];

            shellHook = ''
              export PLATFORMIO_CORE_DIR=$PWD/.platformio
              export LD_LIBRARY_PATH=${pkgs.ncurses5.out}/lib:$LD_LIBRARY_PATH
            '';
          };
        }
      );
    };
}
