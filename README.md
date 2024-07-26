# Personal nix flake templates for dev environments

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
```shell
# Initialize in the current project
nix flake init --template github:ifelse023/dev-templates#rust

# Create a new project
nix flake new --template github:ifelse023/dev-templates#rust ${NEW_PROJECT_DIRECTORY}
```

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


[C]: https://www.open-std.org/jtc1/sc22/wg14
[latex]: https://www.latex-project.org/
[nix]: https://nixos.org
[python]: https://python.org
[release]: https://github.com/NixOS/nixpkgs/releases/tag/22.11
[rmarkdown]: https://rmarkdown.rstudio.com/
[rust]: https://rust-lang.org
[zig]: https://ziglang.org
[shellcheck]: https://www.shellcheck.net/
