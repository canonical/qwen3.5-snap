# qwen35-orin-core24

Core24 inference snap for Qwen 3.5 4B on NVIDIA Jetson Orin Nano using a
CUDA-enabled llama.cpp backend.

The model component downloads:

```text
https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-UD-Q4_K_XL.gguf
https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/mmproj-BF16.gguf
```

## Build

Build this snap on an arm64 Jetson Orin Nano, or on an equivalent arm64 build
host with CUDA toolkit packages available:

```shell
snapcraft pack --destructive-mode
```

The llama.cpp component is built with `GGML_CUDA=ON` and
`CMAKE_CUDA_ARCHITECTURES=87`, matching Jetson Orin's NVIDIA Ampere GPU compute
capability.

## Local install

```shell
sudo snap install --dangerous qwen35-orin-core24_*.snap
sudo snap install --dangerous qwen35-orin-core24+llama-cpp-cuda.comp
sudo snap install --dangerous qwen35-orin-core24+model-qwen35-4b-ud-q4-k-xl.comp
sudo snap install --dangerous qwen35-orin-core24+model-qwen35-4b-mmproj-bf16.comp
sudo snap connect qwen35-orin-core24:hardware-observe
sudo snap connect qwen35-orin-core24:opengl
sudo qwen35-orin-core24 use-engine --auto
sudo snap start qwen35-orin-core24
```

The engine is initially marked `devel`. If automatic selection skips it, select
it explicitly:

```shell
sudo qwen35-orin-core24 use-engine jetson-orin-nano-cuda
```

Check logs for CUDA backend initialization:

```shell
snap logs qwen35-orin-core24
```

The service runs as root, which is required on the tested Jetson Orin Nano image
because `/dev/nvmap` and `/dev/nvhost-*` are owned by `root:root` with mode
`0600`.

## Jetson engine selection

The initial engine manifest uses `arm64` CPU detection as the baseline selector
because Jetson Orin Nano exposes an integrated NVIDIA GPU rather than a typical
PCI GPU. After installing on the Jetson, inspect the detected machine shape:

```shell
qwen35-orin-core24 show-machine --format=json
```

If the integrated GPU is reported with a supported NVIDIA GPU manifest shape,
tighten `engines/jetson-orin-nano-cuda/engine.yaml` to require NVIDIA compute
capability `>=8.7`.
