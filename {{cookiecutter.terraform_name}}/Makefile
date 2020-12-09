.SHELL := /usr/bin/bash
.PHONY: init plan apply destroy plan-target
ENVIRONMENT ?= undefined
TF_CONFIG := env_vars/$(ENVIRONMENT).tfvars
TF_REMOTE := backend_config/$(ENVIRONMENT).tfvars
TF_OUT_PLAN := ./terraform.plan

BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
MAGENTA=$(shell tput setaf 5)
RESET=$(shell tput sgr0)


%_environment: $(TF_CONFIG)
	@echo "$(BOLD)$(GREEN)********************************************************$(RESET)"
	@echo "       Configuring for $* deployment"
	@echo "$(BOLD)$(GREEN)********************************************************$(RESET)"

undefined_environment:
	@echo "$(BOLD)$(RED)********************************************************$(RESET)"
	@echo "$(BOLD)$(RED)*$(RESET)     Please set the ENVIRONMENT variable         $(BOLD)$(RED)*$(RESET)"
	@echo "$(BOLD)$(RED)********************************************************$(RESET)"
	@exit -1

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ${ENVIRONMENT}_environment ## Configure the tfstate backend and update any modules
	@printf "\n${BOLD}${MAGENTA}***Configuring the Terraform remote backend***${RESET}\n\n"
	@if [ -d .terraform ] ; then \
		rm -fr .terraform ; \
	fi
	@if [ -f "$(TF_OUT_PLAN)" ] ; then \
		rm -f "$(TF_OUT_PLAN)"; \
	fi
	-tfenv install
	@terraform init \
		-backend=true \
		-backend-config=$(TF_REMOTE) \
		-input=false \
		-lock=true \
		-upgrade=true \
		-backend-config="acl=private"

plan: ## Show what Terraform thinks it will do
	@printf "\n${BOLD}${MAGENTA}***Execute dry-run***${RESET}\n\n"
	@terraform plan \
		-input=false \
		-lock=true \
		-refresh=true \
		-out=$(TF_OUT_PLAN) \
		-var-file $(TF_CONFIG)

init-plan: init ## Show what Terraform thinks it will do
	@printf "\n${BOLD}${MAGENTA}***Execute dry-run***${RESET}\n\n"
	@terraform plan \
		-input=false \
		-lock=true \
		-refresh=true \
		-out=$(TF_OUT_PLAN) \
		-var-file $(TF_CONFIG)


plan-target: init ## Run against a specific resource
	@printf "\n${BOLD}${MAGENTA}***Execute dry-run against a specific resource target***${RESET}\n\n"
	@read -p "Execute dry-run against target: " TARGET && \
	terraform plan \
		-input=false \
	    -lock=true \
		-refresh=true \
		-out=$(TF_OUT_PLAN) \
		-var-file $(TF_CONFIG) \
		-target=$$TARGET

apply: $(TF_OUT_PLAN) ## Apply the changes requested from code
	@printf "\n${BOLD}${MAGENTA}***Execute changes***${RESET}\n\n"
	@terraform apply $(TF_OUT_PLAN)
	@if [ -f "$(TF_OUT_PLAN)" ] ; then \
		rm -f "$(TF_OUT_PLAN)"; \
	fi

destroy: ## Apply the changes requested from code
	@printf "\n${BOLD}${MAGENTA}***Execute destroy***${RESET}\n"
	@terraform destroy \
		-input=false \
		-lock=true \
		-state=$(TF_OUT_PLAN) \
		-var-file $(TF_CONFIG)

kubeapply:
	@kubectl apply --recursive=true -f ./manifests

all: init plan apply
plan-apply: plan apply
init-destroy: init destroy
