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
.PHONY: help
help: ## Show this help message
	@echo "$(BLUE)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

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

.PHONY: tag
tag: ## Create and push a git tag (usage: make tag VERSION=1.0.0)
	@if [ -z "$(VERSION)" ]; then \
		echo "$(BLUE)Usage: make tag VERSION=x.y.z$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Creating tag $(VERSION)...$(NC)"
	git tag -a $(VERSION) -m "Release version $(VERSION)"
	@echo "$(BLUE)Pushing tag $(VERSION) to remote...$(NC)"
	git push origin $(VERSION)
	@echo "$(GREEN)Tag $(VERSION) created and pushed successfully$(NC)"
