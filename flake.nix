{
  description = "peakrdl compiler";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      packageOverrides = pkgs.callPackage ./python-packages.nix { };
      python = pkgs.python3.override { inherit packageOverrides; };
      #pythonWithPackages = python.withPackages (ps: [ ps.requests ]);
    in rec {
      packages = rec {
        peakrdl = python.pkgs.toPythonApplication python.pkgs.peakrdl;
        
        default = peakrdl;
      };

      devShells.default = pkgs.mkShell {
        packages = [ self.packages.peakrdl ];
        buildInputs = [ python ];
      };

      #pythonx = python;
      #pyover = packageOverrides;
      #pypkg = pythonWithPackages;
    });
}
