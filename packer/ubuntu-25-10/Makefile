# Makefile for Ubuntu 25.10 Packer build

# Variables
PKR_FILE := ubuntu-25.10.pkr.hcl
VARS_FILE := ../credentials.auto.pkrvars.hcl

# Generic tasks
init:
	packer init .

validate:
	packer validate -var-file=$(VARS_FILE) .

fmt:
	packer fmt .

build:
	packer build -var-file=$(VARS_FILE) .

# Combined tasks
all: init validate build

# Clean task
clean:
	rm -rf packer_cache
	rm -f *.log

.PHONY: init validate fmt build all clean
