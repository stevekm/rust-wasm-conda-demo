# rust-wasm-conda-demo
Demo setup of a Rust web assembly app in a conda environment

A scripted setup of the Rust Web Assembly (WASM) tutorial (https://rustwasm.github.io/book/game-of-life/hello-world.html), using `conda` (Anaconda, Miniconda).

# Usage

Clone this repo:

```
git clone https://github.com/stevekm/rust-wasm-conda-demo.git
cd rust-wasm-conda-demo
```

Install dependencies; conda, Rust, Node.js, WASM:

```
make install
```

Make sure it worked:

```
make test
```

Download and build the WASM "Game of Life" demo:

```
make build
```

Run the app:

```
make run
```

Check it out in your web browser:

<img width="600" alt="Screen Shot 2019-07-16 at 7 41 49 PM" src="https://user-images.githubusercontent.com/10505524/61337070-d5fbe680-a801-11e9-8355-f611aff1beba.png">

# Software

Tested on macOS 10.12.6, should work on Linux as well

- GNU `make`

- `bash`

- Perl for some scripted text editing
