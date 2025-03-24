{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              {
                packages = with pkgs; [
                  mariadb
                ];

                enterShell = ''
                  echo "MySQL/MariaDB development environment ready"
                  echo "Run 'devenv up' to start the service"
                '';

                services.mysql = {
                  enable = true;
                  package = pkgs.mariadb;
                  initialDatabases = [{ name = "dev"; }];
                  ensureUsers = [
                    {
                      name = "root";
                      password = "";
                      ensurePermissions = {
                        "*.*" = "ALL PRIVILEGES";
                      };
                    }
                  ];
                };
              }
            ];
          };
        }
      );
    };
}
