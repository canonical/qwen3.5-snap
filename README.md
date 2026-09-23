# Qwen 3.5 inference snap
[![qwen3-5](https://snapcraft.io/qwen3-5/badge.svg)](https://snapcraft.io/qwen3-5)

Qwen 3.5 is a multimodal instruction-tuned model from Qwen with vision capabilities, optimized directly for your hardware. It runs efficiently on pure CPU or leverages CUDA-enabled NVIDIA GPU acceleration.

Use this snap to quickly install an optimized environment for local inference with Qwen 3.5.

The snap includes the following hardware-optimized inference engines:

* cpu: Optimized for x64 and ARM (armv8, armv9) CPUs
* nvidia-gpu: CUDA-enabled GPU acceleration
* nvidia-jetson-orin: CUDA-enabled GPU acceleration for NVIDIA Jetson Orin devices

The most suitable engine is automatically selected based on the available hardware.

#### Install
```shell
sudo snap install qwen3-5
```

#### Run
```shell
qwen3-5
```

> [!TIP]
> Some accelerators require extra [drivers](https://documentation.ubuntu.com/inference-snaps/how-to/setup/drivers/) to be usable with this snap.

## Resources

📚 **[Documentation](https://documentation.ubuntu.com/inference-snaps/)**, learn how to use inference snaps

💬 **[Discussions](https://github.com/canonical/inference-snaps/discussions)**, ask questions and share ideas

🐛 **[Issues](https://github.com/canonical/inference-snaps/issues)**, report bugs and request features

## Build and install from source

Clone the repo:
```shell
git clone https://github.com/canonical/qwen3.5-snap
cd qwen3.5-snap
```

Initialize the development environment:
```shell
make init
```

Build and install snap:
```shell
make build
make install
```
