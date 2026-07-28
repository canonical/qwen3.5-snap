SHELL := /bin/bash

# Always run `hf` via pipx to avoid relying on local `hf` installations.
hf := pipx run --spec "huggingface_hub[cli]" hf

SNAP_NAME ?= qwen3-5
ENGINE ?= cpu

.PHONY: all help init build install upload smoke-test install-deps init-submodules download-models \
	download-model-4b download-mmproj-4b download-model-9b download-mmproj-9b

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

download-models: download-model-4b download-mmproj-4b download-model-9b download-mmproj-9b

download-model-4b:
	@echo "Downloading Qwen3.5-4B model weights..."
	$(hf) download unsloth/Qwen3.5-4B-GGUF Qwen3.5-4B-UD-Q4_K_XL.gguf \
		--local-dir components/model-q4-k-xl-gguf

download-mmproj-4b:
	@echo "Downloading Qwen3.5-4B mmproj weights..."
	$(hf) download unsloth/Qwen3.5-4B-GGUF mmproj-BF16.gguf \
		--local-dir components/mmproj-4b-q4-k-xl

download-model-9b:
	@echo "Downloading Qwen3.5-9B model weights..."
	$(hf) download inference-snaps/Qwen3.5-9B-Q4_K_M-5GB Qwen3.5-9B-Q4_K_M-00001-of-00002.gguf \
		--local-dir components/model-q4-k-m-gguf-1-of-2
	$(hf) download inference-snaps/Qwen3.5-9B-Q4_K_M-5GB Qwen3.5-9B-Q4_K_M-00002-of-00002.gguf \
		--local-dir components/model-q4-k-m-gguf-2-of-2

download-mmproj-9b:
	@echo "Downloading Qwen3.5-9B mmproj weights..."
	$(hf) download unsloth/Qwen3.5-9B-GGUF mmproj-BF16.gguf \
		--local-dir components/mmproj-9b-q4-k-m
