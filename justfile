# https://just.systems

default:
    echo 'Hello, world!'

pull:
    if [[ -d darkmod_src ]]; then
        cd darkmod_src
        git pull
    else
        git clone https://github.com/coldelectrons/darkmod_src -b openxr --depth 1
    fi

shell:
    nix develop

configure:
    cmake -S ./darkmod_src -B build \
        -DCMAKE_RELEASE_TYPE="Release" \
        -DCMAKE_POLICY_MINUMUM_VERSION="3.27" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE \
        -DCMAKE_FIND_DEBUG_MODE=TRUE \
        -DCMAKE_MODULES_PATH="./cmake/" \
        -DTDM_THIRDPARTY_ARTEFACTS=FALSE

build:
    cmake -B build build
