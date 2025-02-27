.PHONY: build generate clean plan apply lint-client lint-provider lint testacc testclient test

TIMEOUT ?= 40m
ifdef TEST
    override TEST := ./... -run $(TEST)
else
    override TEST := ./...
endif

ifdef TF_LOG
    override TF_LOG := TF_LOG=$(TF_LOG)
endif

build:
	go build -o terraform-provider-mikrotik

generate:
	go generate ./...

clean:
	rm dist/*

plan: build
	terraform init
	terraform plan

apply:
	terraform apply

lint-client:
	go vet ./client/...

lint-provider:
	go vet ./mikrotik/...

lint: lint-client lint-provider

test: lint testclient testacc

testclient:
	cd client; go test $(TEST) -race -v -count 1

testacc:
	TF_ACC=1 $(TF_LOG) go test $(TEST) -v -count 1 -timeout $(TIMEOUT)
