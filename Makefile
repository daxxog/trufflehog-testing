SHELL := /bin/bash


.PHONY: help
help:
	@printf "available targets -->\n\n"
	@cat Makefile | grep ".PHONY" | grep -v ".PHONY: _" | sed 's/.PHONY: //g'


container-built.txt: Dockerfile entrypoint.sh
	podman build . -t localhost/trufflehog-scan-test
	date | tee container-built.txt


.PHONY: debug
debug: container-built.txt mnt/castle.cms.git
	podman run \
		-i \
		-t \
		-e REPO_NAME=castle.cms \
		-v $$(pwd)/mnt/castle.cms.git:/mnt/git \
		-v $$(pwd):/mnt/output \
		--entrypoint /bin/sh \
		localhost/trufflehog-scan-test \
	;


.PHONY: scan
scan: container-built.txt mnt/castle.cms.git
	podman run \
		-i \
		-t \
		-e REPO_NAME=castle.cms \
		-v $$(pwd)/mnt/castle.cms.git:/mnt/git \
		-v $$(pwd):/mnt/output \
		localhost/trufflehog-scan-test \
	;


mnt:
	mkdir -p mnt


mnt/castle.cms.git: mnt
	cd mnt && git clone --bare git@github.com:castlecms/castle.cms.git
