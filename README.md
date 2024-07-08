# Personal nix flake templates for dev environments

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
```shell
# Initialize in the current project
nix flake init --template github:the-nix-way/dev-templates#rust

# Create a new project
nix flake new --template github:ifelse023/dev-templates#rust ${NEW_PROJECT_DIRECTORY}
```

## How to use the templates

Once your preferred template has been initialized, you can use the provided shell in two ways:

1. If you have [`nix-direnv`][nix-direnv] installed, you can initialize the environment by running `direnv allow`.
2. If you don't have `nix-direnv` installed, you can run `nix develop` to open up the Nix-defined shell.

## Available templates

| Language/framework/tool | Template              |
| :---------------------- | :-------------------- |
| [C]                     | [`c`](./c/)           |
| Empty                   | [`empty`](./empty)    |
| [LaTeX]                 | [`latex`](./latex/)   |
| [Nix]                   | [`nix`](./nix/)       |
| [Python]                | [`python`](./python/) |
| [Rust]                  | [`rust`](./rust/)     |
| [Shell]                 | [`shell`](./shell/)   |
| [Zig]                   | [`zig`](./zig/)       |


## Code organization

All of the templates have only the root [flake](./flake.nix) as a flake input. That root flake provides a common revision of [Nixpkgs] and [`flake-utils`][flake-utils] to all the templates.

[C]: https://www.open-std.org/jtc1/sc22/wg14
[latex]: https://www.latex-project.org/
[nix]: https://nixos.org
[python]: https://python.org
[release]: https://github.com/NixOS/nixpkgs/releases/tag/22.11
[rmarkdown]: https://rmarkdown.rstudio.com/
[rust]: https://rust-lang.org
[zig]: https://ziglang.org
[shellcheck]: https://www.shellcheck.net/
