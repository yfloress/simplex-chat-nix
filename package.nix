{
  lib,
  stdenv,
  fetchurl,
  gmp,
  openssl,
  zlib,
}:

let
  source = lib.importJSON ./source.json;
in
stdenv.mkDerivation {
  pname = "simplex-chat";
  inherit (source) version;

  # Official prebuilt binary: building from source needs GHC and hours of compiling.
  src = fetchurl {
    url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${source.version}/simplex-chat-ubuntu-24_04-x86_64";
    inherit (source) hash;
  };

  dontUnpack = true;
  dontStrip = true;
  # Setting rpath and interpreter in one patchelf pass (as autoPatchelfHook does)
  # makes this binary segfault; two separate passes work.
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/simplex-chat
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        gmp
        openssl
        zlib
      ]
    } $out/bin/simplex-chat
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/simplex-chat
    runHook postInstall
  '';

  meta = {
    description = "SimpleX Chat terminal client";
    homepage = "https://github.com/simplex-chat/simplex-chat";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "simplex-chat";
  };
}
