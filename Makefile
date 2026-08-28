SHELL := /bin/bash

# Always run `hf` via pipx to avoid relying on local `hf` installations.
hf := pipx run --spec "huggingface_hub[cli]" hf

SNAP_NAME ?= qwen3-5
ENGINE ?= cpu

.PHONY: all help init build install upload smoke-test install-deps init-submodules download-models \
	download-model-0.8b download-mmproj-0.8b download-model-2b download-mmproj-2b \
	download-model-4b download-mmproj-4b download-model-9b download-mmproj-9b \
	download-model-35b download-mmproj-35b

all: help

#
# Main targets
#

help: ## Show this help message
	@echo "Usage: make <target>"
	@echo
	@echo "Targets:"
	@# List all targets with descriptions (lines starting with '##'):
	@grep -E '^[a-zA-Z0-9_-]+:.*## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  %-11s %s\n", $$1, $$2}'

init: init-submodules install-deps download-models ## Initialize the build environment (dependencies, model weights, submodules, etc.)

build: ## Build the snap
	./dev/build.sh

install: ## Install the snap
	./dev/install.sh

upload: ## Upload the snap
	./dev/upload.sh

smoke-test: ## Run smoke tests (override with SNAP_NAME=... ENGINE=...)
	sudo ./dev/smoke-test.sh $(SNAP_NAME) $(ENGINE)

#
# Supporting targets
#

install-deps:
	@echo "Installing dependencies..."
	@# Ensure pipx is available for running the hf CLI.
	@command -v pipx >/dev/null 2>&1 || { \
		sudo apt-get update; \
		sudo apt-get install -y pipx; \
	}

init-submodules:
	@echo "Initializing submodules..."
	@if git submodule status | grep -q '^-'; then \
		git submodule update --init; \
	fi

download-models: download-model-0.8b download-mmproj-0.8b download-model-2b download-mmproj-2b download-model-4b download-mmproj-4b download-model-9b download-mmproj-9b download-model-35b download-mmproj-35b

download-model-0.8b:
	@echo "Downloading Qwen3.5-0.8B model weights..."
	$(hf) download unsloth/Qwen3.5-0.8B-GGUF Qwen3.5-0.8B-Q4_K_M.gguf \
		--local-dir components/model-0-8b-q4-k-m-gguf

download-mmproj-0.8b:
	@echo "Downloading Qwen3.5-0.8B mmproj weights..."
	$(hf) download unsloth/Qwen3.5-0.8B-GGUF mmproj-BF16.gguf \
		--local-dir components/mmproj-0-8b-q4-k-m

download-model-2b:
	@echo "Downloading Qwen3.5-2B model weights..."
	$(hf) download unsloth/Qwen3.5-2B-GGUF Qwen3.5-2B-Q4_K_M.gguf \
		--local-dir components/model-2b-q4-k-m-gguf

download-mmproj-2b:
	@echo "Downloading Qwen3.5-2B mmproj weights..."
	$(hf) download unsloth/Qwen3.5-2B-GGUF mmproj-BF16.gguf \
		--local-dir components/mmproj-2b-q4-k-m

download-model-4b:
	@echo "Downloading Qwen3.5-4B model weights..."
	$(hf) download unsloth/Qwen3.5-4B-GGUF Qwen3.5-4B-UD-Q4_K_XL.gguf \
		--local-dir components/model-4b-q4-k-xl-gguf

download-mmproj-4b:
	@echo "Downloading Qwen3.5-4B mmproj weights..."
	$(hf) download unsloth/Qwen3.5-4B-GGUF mmproj-BF16.gguf \
		--local-dir components/mmproj-4b-q4-k-xl

download-model-9b:
	@echo "Downloading Qwen3.5-9B model weights..."
	$(hf) download inference-snaps/Qwen3.5-9B-Q4_K_M-5GB Qwen3.5-9B-Q4_K_M-00001-of-00002.gguf \
		--local-dir components/model-9b-q4-k-m-gguf-1-of-2
	$(hf) download inference-snaps/Qwen3.5-9B-Q4_K_M-5GB Qwen3.5-9B-Q4_K_M-00002-of-00002.gguf \
		--local-dir components/model-9b-q4-k-m-gguf-2-of-2

download-mmproj-9b:
	@echo "Downloading Qwen3.5-9B mmproj weights..."
	$(hf) download unsloth/Qwen3.5-9B-GGUF mmproj-BF16.gguf \
		--local-dir components/mmproj-9b-q4-k-m

download-model-35b:
	@echo "Downloading Qwen3.5-35B model weights..."
	$(hf) download inference-snaps/Qwen3.5-35B-A3B-Q4_K_M-5GB Qwen3.5-35B-A3B-Q4_K_M-00001-of-00005.gguf \
		--local-dir components/model-35b-a3b-q4-k-m-gguf-1-of-5
	$(hf) download inference-snaps/Qwen3.5-35B-A3B-Q4_K_M-5GB Qwen3.5-35B-A3B-Q4_K_M-00002-of-00005.gguf \
		--local-dir components/model-35b-a3b-q4-k-m-gguf-2-of-5
	$(hf) download inference-snaps/Qwen3.5-35B-A3B-Q4_K_M-5GB Qwen3.5-35B-A3B-Q4_K_M-00003-of-00005.gguf \
		--local-dir components/model-35b-a3b-q4-k-m-gguf-3-of-5
	$(hf) download inference-snaps/Qwen3.5-35B-A3B-Q4_K_M-5GB Qwen3.5-35B-A3B-Q4_K_M-00004-of-00005.gguf \
		--local-dir components/model-35b-a3b-q4-k-m-gguf-4-of-5
	$(hf) download inference-snaps/Qwen3.5-35B-A3B-Q4_K_M-5GB Qwen3.5-35B-A3B-Q4_K_M-00005-of-00005.gguf \
		--local-dir components/model-35b-a3b-q4-k-m-gguf-5-of-5

download-mmproj-35b:
	@echo "Downloading Qwen3.5-35B mmproj weights..."
	$(hf) download unsloth/Qwen3.5-35B-A3B-GGUF mmproj-BF16.gguf \
		--local-dir components/mmproj-35b-q4-k-m
