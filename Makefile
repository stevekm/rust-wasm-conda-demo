# https://rustwasm.github.io/book/game-of-life/hello-world.html
SHELL:=/bin/bash
# get system information; Mac (Darwin) or Linux
UNAME:=$(shell uname)
PATH:=$(CURDIR)/conda/bin:$(PATH)
unexport PYTHONPATH
unexport PYTHONHOME
export CARGO_HOME:=$(CURDIR)/.cargo
export RUSTUP_HOME:=$(CURDIR)/.multirust

ifeq ($(UNAME), Darwin)
CONDASH:=Miniconda3-4.5.4-MacOSX-x86_64.sh
endif

ifeq ($(UNAME), Linux)
CONDASH:=Miniconda3-4.5.4-Linux-x86_64.sh
endif

CONDAURL:=https://repo.continuum.io/miniconda/$(CONDASH)

conda:
	@echo ">>> Setting up conda..."
	@wget "$(CONDAURL)" && \
	bash "$(CONDASH)" -b -p conda && \
	rm -f "$(CONDASH)"

conda-install: conda
	conda install -y -c conda-forge \
	nodejs=11.14.0  \
	rust=1.36.0 && \
	cargo install wasm-pack cargo-generate

test:
	which cargo
	which npm
	which rustup
	which wasm-pack

generate:
	cargo generate --git https://github.com/rustwasm/wasm-pack-template --name wasm-game-of-life

python:
	python

CMD:=
cmd:
$(CMD)
