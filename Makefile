SHELL := /bin/bash

.PHONY: download-models setup-hf-cli

all: download-models

download-models: download-model-4b download-mmproj-4b download-model-9b download-mmproj-9b

setup-hf-cli:
	sudo apt-get install -y python3-venv
	python3 -m venv .venv
	. .venv/bin/activate && pip install --upgrade pip && pip install -U huggingface_hub

download-model-4b: setup-hf-cli
	. .venv/bin/activate && hf download hf://unsloth/Qwen3.5-4B-GGUF/Qwen3.5-4B-UD-Q4_K_XL.gguf --local-dir components/model-q4-k-xl-gguf

download-mmproj-4b: setup-hf-cli
	. .venv/bin/activate && hf download hf://unsloth/Qwen3.5-4B-GGUF/mmproj-BF16.gguf --local-dir components/mmproj-4b-q4-k-xl

download-model-9b: setup-hf-cli
	. .venv/bin/activate && hf download hf://inference-snaps/Qwen3.5-9B-Q4_K_M-5GB/Qwen3.5-9B-Q4_K_M-00001-of-00002.gguf --local-dir components/model-q4-k-m-gguf-1-of-2
	. .venv/bin/activate && hf download hf://inference-snaps/Qwen3.5-9B-Q4_K_M-5GB/Qwen3.5-9B-Q4_K_M-00002-of-00002.gguf --local-dir components/model-q4-k-m-gguf-2-of-2

download-mmproj-9b: setup-hf-cli
	. .venv/bin/activate && hf download hf://unsloth/Qwen3.5-9B-GGUF/mmproj-BF16.gguf --local-dir components/mmproj-9b-q4-k-m
