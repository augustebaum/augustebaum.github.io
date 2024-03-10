let
  sources = import ./nix/sources.nix;
in
  {pkgs ? import sources.nixpkgs {}}: let
    inherit (pkgs) lib;
  in
    pkgs.stdenv.mkDerivation {
      name = "auguste-blog";

      src = ./src;

      buildInputs = [pkgs.hugo];

      buildPhase = ''
        ${lib.getExe pkgs.hugo} \
          --noBuildLock \
          --minify \
          --source $src \
          --destination $out
      '';
    }
