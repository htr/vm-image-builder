{ pkgs ? import <nixpkgs> {}, imageSize, ... }:

with pkgs;

let
  diskSize = imageSize * 1024;
  configuration = import ./configuration.nix;

in
  import <nixpkgs/nixos/lib/make-disk-image.nix> rec {
    config = (import <nixpkgs/nixos> { inherit configuration; }).config;
    inherit pkgs lib diskSize;
    format = "qcow2";

    configFile = ./configuration.nix;
    contents = [ ];

    postVM = ''
      echo done
    '';
  }

