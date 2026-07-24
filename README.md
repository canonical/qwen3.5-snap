# Qwen 3.5 inference snap
[![qwen3-5](https://snapcraft.io/qwen3-5/badge.svg)](https://snapcraft.io/qwen3-5)

Install [Qwen 3.5](https://qwen.ai/blog?id=qwen3.5), optimized directly for your hardware.
This package deploys a high-performance runtime for local inference across arm and x86 platforms. It runs efficiently on pure CPU or leverages CUDA-enabled NVIDIA GPU acceleration.

Before starting, install the necessary [drivers](https://documentation.ubuntu.com/inference-snaps/how-to/setup/drivers/) for your accelerator.

| Engine | Arch | Description |
|--------------|--------------|-------------|
| cpu | amd64, arm64 | Optimized for several CPU variants (x86, armv8, armv9) |
| nvidia-gpu | amd64, arm64 | CUDA-enabled GPU acceleration |
| nvidia-jetson-orin | arm64 | CUDA-enabled GPU acceleration for NVIDIA Jetson Orin devices |

#### Install
```
sudo snap install qwen3-5
```
#### Use
```
qwen3-5 --help
```

#### Default configurations
| Key | Value |
|-----|-------|
| http.port | 8352 |
| http.host | 127.0.0.1 |
| webui.http.port | 8353 |
| webui.http.host | 127.0.0.1 |

## Resources

📚 **[Documentation](https://documentation.ubuntu.com/inference-snaps/)**, learn how to use inference snaps

💬 **[Discussions](https://github.com/canonical/inference-snaps/discussions)**, ask questions and share ideas

🐛 **[Issues](https://github.com/canonical/inference-snaps/issues)**, report bugs and request features

## Build and install from source

Clone this repo with its submodules:
```shell
git clone --recurse-submodules https://github.com/canonical/qwen3.5-snap
```

Prepare the required models by running `make download-models`.

Build the snap and its component:
```shell
snapcraft pack -v
```

Refer to the `./dev` directory for additional development tools.
