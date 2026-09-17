#!/usr/bin/env bash
# Build llama-prism for sm_61 (GTX 1050) inside the `llama-build` container.
# Usage: bash scripts/build-sm61.sh configure|build|all
set -euo pipefail
cd "$(dirname "$0")/.."

ARCH="${ARCH:-61}"
GEN="-G Ninja"
ARGS=(
  -DCMAKE_BUILD_TYPE=Release
  -DCMAKE_INSTALL_RPATH='$ORIGIN'
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
  -DGGML_NATIVE=ON
  -DGGML_CUDA=ON
  -DCMAKE_CUDA_ARCHITECTURES=${ARCH}
  -DLLAMA_CURL=OFF
  -DCMAKE_EXE_LINKER_FLAGS=-Wl,--allow-shlib-undefined
  -DLLAMA_BUILD_EXAMPLES=ON
  -DLLAMA_BUILD_TESTS=OFF
  -DLLAMA_BUILD_TOOLS=ON
  -DLLAMA_BUILD_SERVER=ON
  -DGGML_RPC=ON
)

case "${1:-all}" in
  configure) cmake -B build $GEN "${ARGS[@]}" ;;
  build)     cmake --build build -j"$(nproc)" ;;
  all)       cmake -B build $GEN "${ARGS[@]}" && cmake --build build -j"$(nproc)" ;;
  *) echo "usage: $0 configure|build|all"; exit 2 ;;
esac
