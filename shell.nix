{ pkgs ? import <nixpkgs> {} }:
let
  libPath = with pkgs; lib.makeLibraryPath [
    wayland-protocols
    wayland
    libxkbcommon
    libGL
  ];
in
pkgs.mkShell {
  shellHook = ''
    export LD_LIBRARY_PATH="${libPath}"
  '';
}