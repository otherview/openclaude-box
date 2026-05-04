# OpenClaude Box

A cheerful little launcher for running OpenClaude in a repeatable Docker sandbox.

## Why this repo exists

`openclaude-box` gives you a simple command flow to:

- clone the OpenClaude source into `./src`
- build a local container image with useful dev tooling
- run OpenClaude in that container against your current workspace

The top-level repo tracks the wrapper and container setup. The `src/` folder is intentionally git-ignored.

## Quick start

```bash
# from this repo
./openclaude-box init
./openclaude-box clone
./openclaude-box build
./openclaude-box run --version
```

Or via `make`:

```bash
make init
make clone
make build
make run ARGS="--version"
```

## Commands

```bash
openclaude-box help
openclaude-box init
openclaude-box clone
openclaude-box build
openclaude-box run [openclaude args...]
openclaude-box version
openclaude-box tools
openclaude-box clean
```

## What gets mounted on `run`

- current directory to `/workspace`
- `~/.openclaude-box` for runtime state
- `~/.codex` (read-only) for local Codex config
- selected provider env vars (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, etc.)

## Install helper command

```bash
make install
openclaude-box version
```

By default this installs to `~/bin/openclaude-box`.

## Notes

- This repository ignores `src/` on purpose.
- Build context comes from `src/` using the top-level `Dockerfile`.
