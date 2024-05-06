{
  lib,
  stdenv,
  mkDerivation,
  patchesRoot,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  mandoc,
  groff,
  boot-install,
  install,
  compatIfNeeded,
}:

mkDerivation {
  path = "lib/libnetbsd";
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    mandoc
    groff
    (if stdenv.hostPlatform == stdenv.buildPlatform then boot-install else install)
  ];
  patches = lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
    /${patchesRoot}/libnetbsd-do-install.patch
    #/${patchesRoot}/libnetbsd-define-__va_list.patch
  ];
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
  ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";
  buildInputs = compatIfNeeded;
}
