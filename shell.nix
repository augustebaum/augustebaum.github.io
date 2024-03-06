let
  sources = import ./nix/sources.nix;
in
  {pkgs ? import sources.nixpkgs {}, ...}:
    pkgs.mkShell {
      inputsFrom = [(import ./default.nix {})];
    }
