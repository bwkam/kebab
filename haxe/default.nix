{
  haxe,
  haxe-master-src,
  haxe-nightly-src,
  ocaml-ng,
}: {
  master = haxe.overrideAttrs (final: prev: {
    version = "master";
    src = "${haxe-master-src}";
    buildInputs = (prev.buildInputs or []) ++ (with ocaml-ng.ocamlPackages_4_14; [terminal_size ipaddr]);
  });
  nightly = haxe.overrideAttrs (final: prev: {
    version = "nightly";
    src = "${haxe-nightly-src}";
    buildInputs = (prev.buildInputs or []) ++ (with ocaml-ng.ocamlPackages_4_14; [terminal_size ipaddr]);
  });
}
