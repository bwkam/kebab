{
  stdenv,
  typescript,
  khamake-src,
}:
stdenv.mkDerivation {
  pname = "khamake";
  version = "latest";

  src = "${khamake-src}";

  nativeBuildInputs = [typescript];

  patchPhase = ''
    sed -i 's/copyAndReplace(p.*//' ./src/HaxeProject.ts
  '';

  buildPhase = ''
    tsc -p ./
  '';

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = {
    description = "Kha's build tool";
    homepage = "https://github.com/Kode/khamake/";
  };
}
