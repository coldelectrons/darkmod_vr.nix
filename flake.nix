{
  description = "The Dark Mod VR";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # This is the list of architectures that work with this project
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.clang-format.enable = true;
            programs.cmake-format.enable = true;
            programs.mdformat.enable = true;
          };
          packages = rec {
            # The `callPackage` automatically fills the parameters of the function
            # in package.nix with what's inside the `pkgs` attribute.
            thedarkmodvr = pkgs.callPackage ./thedarkmodvr.nix { stdenv = pkgs.clangStdenv; };
            default = thedarkmodvr;
            tdm_installer = pkgs.callPackage ./installer.nix { stdenv = pkgs.clangStdenv; };
            tdm_packager = pkgs.callPackage ./packager.nix { stdenv = pkgs.clangStdenv; };
          };
          devShells.default = pkgs.mkShell rec {
            packages = with pkgs; [
              pkg-config
              cmake
              clang
              clang-tools
              conan
              python3
              ninja
              gnumake
              subversion
              git
              # fltk_1_4
              libtool

              openxr-loader
              vulkan-loader
              vulkan-headers
              libGL
              libGLU
              wayland
              wayland-scanner
              libxkbcommon
              libffi

              # libblake3
              # zlib
              # minizip
              # curl
              # glfw3
              # libjpeg
              # libpng
              # libogg
              # libvorbis
              # openal
              # ffmpeg-headless
              # pugixml
              # doctest
              # tracy
              # mbedtls

              # why so much x11 deps
              libx11
              libXext
              libxxf86vm
              libxkbcommon
              libxaw
              libxfixes
              libxkbfile
              libxpm
              libxcb
              libxcb-wm
              libxcb-util
              libxcb-image
              libxcb-cursor
              libxcb-errors
              libxcb-keysyms
              libxcb-render-util
              libxi
              libxinerama
              libxscrnsaver
              libSM
              libxv
              libxcursor
              libxrandr
              libxrender
              libice
              libfontenc
              libxt
              libxdamage
              libxdmcp
              libxmu
            ];
            shellHook = with pkgs; ''
              cp cmake/nix_deps.cmake.in cmake/nix_deps.cmake
              substituteInPlace cmake/nix_deps.cmake \
                --replace-fail '@ZLIB_ROOT_DIR@'      '${zlib}' \
                --replace-fail '@MINIZIP_ROOT_DIR@'   '${minizip}' \
                --replace-fail '@FLTK_ROOT_DIR@'      '${fltk}' \
                --replace-fail '@BLAKE3_ROOT_DIR@'    '${libblake3}' \
                --replace-fail '@GLFW3_ROOT_DIR@'     '${glfw3}' \
                --replace-fail '@CURL_ROOT_DIR@'      '${curl}' \
                --replace-fail '@LIBJPEG_ROOT_DIR@'   '${libjpeg}' \
                --replace-fail '@LIBPNG_ROOT_DIR@'    '${libpng}' \
                --replace-fail '@FFMPEG_ROOT_DIR@'    '${ffmpeg}' \
                --replace-fail '@OGG_ROOT_DIR@'       '${libogg}' \
                --replace-fail '@VORBIS_ROOT_DIR@'    '${libvorbis}' \
                --replace-fail '@OPENAL_ROOT_DIR@'    '${openal}' \
                --replace-fail '@PUGIXML_ROOT_DIR@'   '${pugixml}' \
                --replace-fail '@WAYLAND_ROOT_DIR@'   '${wayland}' \
                --replace-fail '@MBEDTLS_ROOT_DIR@'   '${mbedtls}' \
                --replace-fail '@XKBCOMMON_ROOT_DIR@' '${libxkbcommon}' \
                --replace-fail '@OPENXR_ROOT_DIR@'    '${openxr-loader}' \
                --replace-fail '@TRACY_ROOT_DIR@'     '${tracy}' \
                --replace-fail '@DOCTEST_ROOT_DIR@'   '${doctest}'
            '';
            env = {
              # CMAKE_COMPILE_COMMANDS_EXPORT="ON";
              # CMAKE_MODULE_PATH="./cmake/";
            };
          };
        };
    };
}
