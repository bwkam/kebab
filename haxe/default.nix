{
  haxe,
  haxe-master-src,
  ocaml-ng,
}:
haxe.overrideAttrs (final: prev: {
  version = "master";
  src = "${haxe-master-src}";
  buildInputs = (prev.buildInputs or []) ++ (with ocaml-ng.ocamlPackages_4_14; [terminal_size ipaddr]);
})
