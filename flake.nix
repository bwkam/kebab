{
  description = "haxe bad, kebab good";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    haxe-master-src = {
      type = "git";
      url = "https://github.com/HaxeFoundation/haxe";
      submodules = true;
      flake = false;
    };
    kha-src = {
      type = "git";
      url = "https://github.com/Kode/Kha.git?ref=main";
      submodules = true;
      flake = false;
    };
    kode_haxe-src = {
      type = "git";
      url = "https://github.com/Kode/haxe.git";
      submodules = true;
      flake = false;
    };

    khamake-src = {
      type = "git";
      url = "https://github.com/Kode/khamake.git";
      submodules = true;
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    haxe-master-src,
    kha-src,
    kode_haxe-src,
    khamake-src,
  }: let
    inherit (nixpkgs) lib;
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    perSystem = f: lib.genAttrs systems f;
  in {
    packages = perSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      haxe_master = pkgs.callPackage ./haxe {
        inherit (pkgs) ocaml-ng;
        inherit haxe-master-src;
      };
      kha = pkgs.callPackage ./kha {
        inherit pkgs kha-src kode_haxe-src khamake-src;
      };
    });
  };
}
