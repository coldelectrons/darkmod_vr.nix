# The items in the curly brackets are function parameters as this is a Nix
# function that accepts dependency inputs and returns a new package
# description
{
  lib,
  pkgs,
  stdenv,
  #nativeBuildInputs
  clang-tools,
  clang,
  cmake,
  ninja,
  cppcheck,
  pkg-config,
  subversion,
  #buildInputs
  openxr-loader,
  wayland,
  libblake3,
  zlib-ng,
  minizip-ng,
  curl,
  vulkan-loader,
  vulkan-headers,
  glfw3,
  libjpeg,
  libpng,
  libogg,
  libvorbis,
  openal,
  ffmpeg-headless,
  pugixml,
  doctest,
  tracy,
  mbedtls,
  fltk,
  libxkbcommon,
  libuuid,
  # x11 stuff
  # xorgproto,
  # libx11,
  # libXext,
  # libxxf86vm,
  # libxaw,
  # libxfixes,
  # libxkbfile,
  # libxpm,
  # libxcb,
  # libxcb-wm,
  # libxcb-util,
  # libxcb-image,
  # libxcb-cursor,
  # libxcb-errors,
  # libxcb-keysyms,
  # libxcb-render-util,
  # libxinerama,
  # libxscrnsaver,
  # libSM,
  # libxv,
  # libxcursor,
  # libxrandr,
  # libxrender,
  # libice,
  # libfontenc,
  # libxt,
  # libxdamage,
  # libxdmcp,
  # libxmu,
}:

# stdenv.mkDerivation now accepts a list of named parameters that describe
# the package itself.
let
  stdenv = import ./ccdbenv.nix { inherit pkgs stdenv; };
in stdenv.mkDerivation {
  name = "thedarkmodvr";

  # good source filtering is important for caching of builds.
  # It's easier when subprojects have their own distinct subfolders.
  # src = lib.sourceByRegex ./. [
  #   "^src.*"
  #   "^assets.*"
  #   "^cm.*"
  #   "^framework.*"
  #   "^game.*"
  #   "^glprogs.*"
  #   "^hlprogs.*"
  #   # "^nix.*"
  #   "^nix.*"
  #   "^idlib.*"
  #   "^renderer.*"
  #   "^sound.*"
  #   "^sys.*"
  #   "^tools.*"
  #   "^ui.*"
  #   "CMakeLists.txt"
  #   "thedarkmodvr.png"
  # ];
    src = pkgs.fetchFromGitHub {
      owner = "coldelectrons";
      repo = "darkmod_src";
      branch = "openxr";
      rev = "c1ab71003d544dbedcbcfce7d2bfc4af7cf7a650";
      hash = "sha256-nG8nCwGmK/p8ucyc17SLtVlRF9rrII9uGjtT6dq08Bc=";
    };

  # We now list the dependencies similar to the devShell before.
  # Distinguishing between `nativeBuildInputs` (runnable on the host
  # at compile time) and normal `buildInputs` (runnable on target
  # platform at run time) is an important preparation for cross-compilation.
  nativeBuildInputs = [
    pkg-config
    cmake
    clang-tools
    clang
    ninja
    cppcheck
    subversion
  ];
  buildInputs = [
    pkg-config
    openxr-loader
    vulkan-loader
    vulkan-headers
    wayland
    wayland.dev
    libxkbcommon
    # libblake3
    # zlib-ng
    # minizip-ng
    # curl
    # curl.dev
    # glfw3
    # libjpeg
    # libpng
    # libogg
    # libvorbis
    # openal
    # ffmpeg-headless
    # ffmpeg-headless.dev
    # pugixml
    # doctest
    # tracy
    # mbedtls
    # fltk
    # libuuid # ???

    # libx11
    # libx11.dev
    # libXext
    # libxxf86vm
    # libxkbcommon
    # libxaw
    # libxfixes
    # libxkbfile
    # libxpm
    # libxcb
    # libxcb-wm
    # libxcb-util
    # libxcb-image
    # libxcb-cursor
    # libxcb-errors
    # libxcb-keysyms
    # libxcb-render-util
    # libxinerama
    # libxscrnsaver
    # libSM
    # libxv
    # libxcursor
    # libxrandr
    # libxrender
    # libice
    # libfontenc
    # libxt
    # libxdamage
    # libxdmcp
    # libxmu
  ];

  env = {
  };

  preConfigure = ''
    # find ${libxkbcommon}
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.27")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    # (lib.cmakeFeature "CMAKE_MODULES_PATH" "${src}/ThirdParty/artefacts/linux64")
    # (lib.cmakeBool "CMAKE_EXPORT_COMPILE_COMMANDS" true)
    # (lib.cmakeBool "NIXOS" true)
    # (lib.cmakeBool "TDM_THIRDPARTY_ARTEFACTS" true)
  ];
  # Instruct the build process to run tests.
  # The generic builder script of `mkDerivation` handles all the default
  # command lines of several build systems, so it knows how to run our tests.
  doCheck = true;
}
