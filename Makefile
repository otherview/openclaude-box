SHELL := /bin/bash

PROJECT_DIR := /Users/bottybot/ai-agents/openclaude
CLI := $(PROJECT_DIR)/openclaude-box
INSTALL_DIR ?= $(HOME)/bin
INSTALL_PATH := $(INSTALL_DIR)/openclaude-box

.PHONY: help init clone build run version tools clean install uninstall

help: ## Show available commands
	@echo "OpenClaude box repo"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Create ~/.openclaude-box
	@$(CLI) init

clone: ## Clone OpenClaude source into ./src
	@$(CLI) clone

build: ## Build the Docker image
	@$(CLI) build

run: ## Run OpenClaude (pass args with ARGS="...")
	@$(CLI) run $(ARGS)

version: ## Print OpenClaude version from container
	@$(CLI) version

tools: ## Verify container toolchain
	@$(CLI) tools

clean: ## Remove local Docker image
	@$(CLI) clean

install: ## Install `openclaude-box` into INSTALL_DIR (default: ~/bin)
	@mkdir -p "$(INSTALL_DIR)"
	@ln -sf "$(CLI)" "$(INSTALL_PATH)"
	@echo "Installed at $(INSTALL_PATH)"
	@echo "Ensure $(INSTALL_DIR) is in PATH"

uninstall: ## Remove installed command from INSTALL_DIR
	@rm -f "$(INSTALL_PATH)"
	@echo "Removed $(INSTALL_PATH)"
