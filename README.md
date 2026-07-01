# Qwen 3.5 Jetson snap

[![qwen3-5-jetson](https://snapcraft.io/qwen3-5-jetson/badge.svg)](https://snapcraft.io/qwen3-5-jetson)

Core24 inference snap for Qwen 3.5 4B on NVIDIA Jetson Orin Nano using a
CUDA-enabled llama.cpp backend.

## Resources

📚 **[Documentation](https://documentation.ubuntu.com/inference-snaps/)**, learn how to use inference snaps

💬 **[Discussions](https://github.com/canonical/inference-snaps/discussions)**, ask questions and share ideas

🐛 **[Issues](https://github.com/canonical/inference-snaps/issues)**, report bugs and request features

The model component downloads:

```text
https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-UD-Q4_K_XL.gguf
https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/mmproj-BF16.gguf
```

## Build

Build this snap on an arm64 Jetson Orin Nano, or on an equivalent arm64 build
host with CUDA toolkit packages available:

```shell
snapcraft pack
```

The llama.cpp component is built with `GGML_CUDA=ON` and
`CMAKE_CUDA_ARCHITECTURES=87`, matching Jetson Orin's NVIDIA Ampere GPU compute
capability.

## Local install

```shell
sudo snap install --dangerous qwen3-5-jetson_*.snap
sudo snap install --dangerous qwen3-5-jetson+llama-cpp-cuda.comp
sudo snap install --dangerous qwen3-5-jetson+model-qwen35-4b-ud-q4-k-xl.comp
sudo snap install --dangerous qwen3-5-jetson+model-qwen35-4b-mmproj-bf16.comp
sudo snap connect qwen3-5-jetson:hardware-observe
sudo snap connect qwen3-5-jetson:opengl
sudo qwen3-5-jetson use-engine --auto
sudo snap start qwen3-5-jetson
```

The engine is initially marked `devel`. If automatic selection skips it, select
it explicitly:

```shell
sudo qwen3-5-jetson use-engine jetson-orin-nano-cuda
```

Check logs for CUDA backend initialization:

```shell
snap logs qwen3-5-jetson
```

The service runs as root, which is required on the tested Jetson Orin Nano image
because `/dev/nvmap` and `/dev/nvhost-*` are owned by `root:root` with mode
`0600`.

## Jetson engine selection

The initial engine manifest uses `arm64` CPU detection as the baseline selector
because Jetson Orin Nano exposes an integrated NVIDIA GPU rather than a typical
PCI GPU. After installing on the Jetson, inspect the detected machine shape:

```shell
qwen3-5-jetson show-machine --format=json
```

If the integrated GPU is reported with a supported NVIDIA GPU manifest shape,
tighten `engines/jetson-orin-nano-cuda/engine.yaml` to require NVIDIA compute
capability `>=8.7`.
