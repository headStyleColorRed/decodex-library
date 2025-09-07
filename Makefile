# Makefile for DecodexCore
# Swift Library for Decodex Protocol

# Variables
PROJECT_NAME = DecodexCore
BUILD_DIR = .build

# Colors for output
GREEN = \033[0;32m
BLUE = \033[0;34m
NC = \033[0m # No Color

# Default target
.PHONY: build
build: ## Build the project
	@echo "$(BLUE)Building $(PROJECT_NAME)...$(NC)"
	swift build
	@echo "$(GREEN)Build completed$(NC)"

.PHONY: run
run: build
	@echo "$(BLUE)Running $(PROJECT_NAME)...$(NC)"
	swift run
	@echo "$(GREEN)Project stopped$(NC)"
