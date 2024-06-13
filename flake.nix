{
  description = "ghciwatch-compat";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ nixpkgs, self, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      overlays.default = final: prev: {
        ghciwatch-compat = final.writeShellApplication {
          name = "ghciwatch-compat";
          text = builtins.readFile ./ghciwatch-compat;
          runtimeInputs = [
            final.argc
            final.ghciwatch
          ];
        };
      };

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          default = pkgs.ghciwatch-compat;
          ghciwatch-compat = pkgs.ghciwatch-compat;
        }
      );
    };
}
