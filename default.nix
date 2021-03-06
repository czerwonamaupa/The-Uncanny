with import <nixpkgs> {};
let
  ebook-name = "The-Uncanny";
  pandoc = import (fetchTarball {
    url = "https://github.com/czerwonamaupa/pandoc/archive/413af81436a09f554a2ee575f063d8abed15ecd6.tar.gz";
    sha256 = "1q7bc087ipp8bb0gf9yr29wh0mgvrb7ipsx3gcpi94ann2knykak";
  }) {};
  pythonInputs = python3.withPackages (pkgs: with pkgs; [pandocfilters pyphen]);
  drv = stdenv.mkDerivation {
    pname = ebook-name;
    version = "v1.1";
    src = nix-gitignore.gitignoreSource [] ./.;
    buildInputs = [ pandoc kindlegen pythonInputs ];
    installPhase = ''
      mkdir -p $out/web
      cp -r {index.html,web.css,fonts} $out/web
      mkdir -p $out/ebooks
      cp ${ebook-name}.{epub,mobi} $out/ebooks
    '';
  };
  shell = mkShell {
    inputsFrom = [ drv ];
    buildInputs = [ entr ];
  };
in drv // { inherit shell; }
