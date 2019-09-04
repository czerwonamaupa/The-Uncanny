{ pkgs ? import <nixpkgs> {} }:
with pkgs;
mkShell {
  buildInputs = [
    gnumake
    entr
    pandoc-footnotes
    kindlegen
    (python3.withPackages (pkgs: with pkgs; [
      pandocfilters
      pyphen
    ]))
  ];
}
