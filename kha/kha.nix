{
  stdenv,
  coreutils,
  nodejs,
  haxe,
  pcre2,
  makeWrapper,
  zlib,
  neko,
  lib,
  callPackage,
  mbedtls_2,
  ocaml-ng,
  kha-src,
  kode_haxe-src,
  khamake-src,
}: let
  khamake = callPackage ./khamake.nix {inherit khamake-src;};
  kode_haxe = haxe.overrideAttrs (_: {
    src = "${kode_haxe-src}";

    prePatch = "";

    buildFlags = ["haxe"];

    buildInputs =
      [zlib neko pcre2 mbedtls_2]
      # ++ lib.optional (lib.versionAtLeast version "4.1" && stdenv.isDarwin) Security
      ++ (with ocaml-ng.ocamlPackages_4_08; [
        ocaml
        findlib
        sedlex
        xml-light
        ptmap
        camlp5
        sha
        dune_3
        luv
        extlib
        camlp-streams
      ]);

    installPhase = ''
      install -vd "$out/bin" "$out/lib/haxe/std"
      cp -vr haxe std "$out/lib/haxe"

      # make wrappers which provide a temporary HAXELIB_PATH with symlinks to multiple repositories HAXELIB_PATH may point to
      for name in haxe; do
      cat > $out/bin/$name <<EOF
      #!{bash}/bin/bash

      if [[ "\$HAXELIB_PATH" =~ : ]]; then
        NEW_HAXELIB_PATH="\$(${coreutils}/bin/mktemp -d)"

        IFS=':' read -ra libs <<< "\$HAXELIB_PATH"
        for libdir in "\''${libs[@]}"; do
          for lib in "\$libdir"/*; do
            if [ ! -e "\$NEW_HAXELIB_PATH/\$(${coreutils}/bin/basename "\$lib")" ]; then
              ${coreutils}/bin/ln -s "--target-directory=\$NEW_HAXELIB_PATH" "\$lib"
            fi
          done
        done
        export HAXELIB_PATH="\$NEW_HAXELIB_PATH"
        $out/lib/haxe/$name "\$@"
        rm -rf "\$NEW_HAXELIB_PATH"
      else
        exec $out/lib/haxe/$name "\$@"
      fi
      EOF
      chmod +x $out/bin/$name
      done
    '';
  });
in
  stdenv.mkDerivation {
    pname = "kha";
    version = "latest";

    nativeBuildInputs = [makeWrapper];
    buildInputs = [khamake kode_haxe];

    src = "${kha-src}";

    patchPhase = ''
      rm -rf ./Tools/khamake

      mkdir -p ./Tools/khamake
      cp -r ${khamake}/* ./Tools/khamake

      rm ./Tools/linux_x64/haxe
      cp ${kode_haxe}/bin/haxe ./Tools/linux_x64/haxe
    '';

    installPhase = ''
      cp -r . $out
      makeWrapper ${lib.getExe nodejs} $out/bin/kmake \
        --add-flags "$out/Tools/khamake/out/khamake.js"
    '';
  }
