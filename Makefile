# https://rustwasm.github.io/book/game-of-life/hello-world.html
SHELL:=/bin/bash
# get system information; Mac (Darwin) or Linux
UNAME:=$(shell uname)

# Conda environment
export PATH:=$(CURDIR)/conda/bin:$(PATH)
unexport PYTHONPATH
unexport PYTHONHOME

# Rust environment
export CARGO_HOME:=$(CURDIR)/.cargo
export PATH:=$(CARGO_HOME)/bin:$(PATH)
# export RUSTUP_HOME:=$(CURDIR)/.rust

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
	conda=4.5.4 \
	nodejs=11.14.0 \
	rust=1.36.0

cargo-install: conda
	cargo install wasm-pack cargo-generate

# https://rustwasm.github.io/wasm-pack/book/prerequisites/non-rustup-setups.html
RUST_SYSROOT:=$(CURDIR)/conda/lib/rustlib/
WASM32_LIB:=$(RUST_SYSROOT)/wasm32-unknown-unknown
$(WASM32_LIB):
	wget https://static.rust-lang.org/dist/rust-std-1.36.0-wasm32-unknown-unknown.tar.gz && \
	tar -xvzf rust-std-1.36.0-wasm32-unknown-unknown.tar.gz && \
	rm -f rust-std-1.36.0-wasm32-unknown-unknown.tar.gz && \
	mv rust-std-1.36.0-wasm32-unknown-unknown/rust-std-wasm32-unknown-unknown/lib/rustlib/wasm32-unknown-unknown "$(RUST_SYSROOT)" && \
	rm -rf rust-std-1.36.0-wasm32-unknown-unknown
wasm32: $(WASM32_LIB)

install: conda-install cargo-install wasm32

test:
	which rustc
	rustc --version
	rustc --print sysroot
	which cargo
	which wasm-pack
	which npm
# which rustup

wasm-game-of-life:
	cargo generate --git https://github.com/rustwasm/wasm-pack-template --name wasm-game-of-life
	cd wasm-game-of-life && \
	wasm-pack build && \
	npm init wasm-app www && \
	cat www/package.json | perl -pe  's|(^.*"devDependencies".*)|\1\n"wasm-game-of-life": "file:../pkg",\n|g' > tmp && mv tmp www/package.json && \
	cat www/index.js | sed 's|hello-wasm-pack|wasm-game-of-life|g' > tmp && mv tmp www/index.js && \
	cd www && npm install
build: wasm-game-of-life

run:
	cd wasm-game-of-life/www && \
	npm run start


# for testing
bash:
	bash
