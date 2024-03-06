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
        cd $src
        ${lib.getExe pkgs.hugo} --noBuildLock --destination $out
      '';
    }
