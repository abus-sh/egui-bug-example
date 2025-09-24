{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libGL,
  libxkbcommon,
  u-config,
  wayland,
  wayland-protocols,
  pkgs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "egui-bug-example";
  version = "0.1.0";

  src = pkgs.lib.cleanSource ./.;

  cargoHash = "sha256-APTEND0cC0Myp/saJTXL6l6gt0F1M09ULoUPYHdRXPA=";

  addDlopenRunpaths = map (p: "${lib.getLib p}/lib") (
    lib.optionals stdenv.hostPlatform.isLinux [
      libxkbcommon
      wayland
      libGL
    ]
  );

  addDlopenRunpathsPhase = ''
    elfHasDynamicSection() {
        patchelf --print-rpath "$1" >& /dev/null
    }

    while IFS= read -r -d $'\0' path ; do
      elfHasDynamicSection "$path" || continue
      for dep in $addDlopenRunpaths ; do
        patchelf "$path" --add-rpath "$dep"
      done
    done < <(
      for o in $(getAllOutputNames) ; do
        find "''${!o}" -type f -and "(" -executable -or -iname '*.so' ")" -print0
      done
    )
  '';

  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];
})
