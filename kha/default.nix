{
  pkgs,
  kha-src,
  kode_haxe-src,
  khamake-src,
}:
import ./kha.nix {
  inherit
    (pkgs)
    stdenv
    coreutils
    nodejs
    haxe
    pcre2
    makeWrapper
    zlib
    neko
    lib
    callPackage
    mbedtls_2
    ocaml-ng
    ;
  inherit
    kha-src
    kode_haxe-src
    khamake-src
    ;
}
