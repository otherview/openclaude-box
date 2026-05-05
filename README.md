# openclaude-box

Run [OpenClaude](https://github.com/Gitlawb/openclaude) as an AI coding agent inside an isolated, reproducible Docker container.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Container-Docker-blue)](Dockerfile)

## Why

OpenClaude is a powerful terminal-based AI coding agent. `openclaude-box` wraps it in a clean, self-contained Docker environment so you can:

- **Isolate** the agent's dependencies — no risk of polluting your host system
- **Reproduce** builds across machines — the same image, same toolchain
- **Ship easily** — one command gets you a ready-to-go agent on any machine

## Features

- One-command install: `curl ... | bash`
- Pre-installed dev tools: git, ripgrep, golang, python3, jq, make, docker
- Automatic OpenClaude source cloning on first build
- Configurable API keys: Anthropic, Gemini, OpenAI, Grok

## Quick Start

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/otherview/openclaude-box/main/install.sh | bash
# or
wget -qO - https://raw.githubusercontent.com/otherview/openclaude-box/main/install.sh | bash
```

After installation, if `~/.local/bin` is not on your PATH, add it:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Or run directly:

```bash
~/.local/bin/openclaude-box init
```

### Run

```bash
openclaude-box init          # Set up runtime directory
openclaude-box run            # Start the agent (builds if needed)
```

That's it — the first run will clone OpenClaude, build the image, and launch the agent.

## Usage

| Command | Description |
|---------|-------------|
| `openclaude-box init` | Create the runtime directory at `~/.openclaude-box/` |
| `openclaude-box run` | Build (if needed) and start the agent |
| `openclaude-box build` | Build the Docker image |
| `openclaude-box version` | Show the agent version |
| `openclaode-box tools` | List pre-installed dev tools |

## Configuration

### API Keys

The agent connects to AI providers via env vars. You have three options:

1. **Pass env vars directly** when running the container (the script accepts them as arguments):
   ```bash
   openclaude-box run \
     --anthropic-key "$ANTHROPIC_API_KEY" \
     --gemini-key "$GEMINI_API_KEY" \
     --openai-key "$OPENAI_API_KEY" \
     --grok-key "$GROK_API_KEY"
   ```

2. **Edit the config file** at `~/.openclaude-box/.openclaude.json`:
   ```json
   {
     "providers": {
       "anthropic": { "apiKey": "sk-ant-..." }
     }
   }
   ```

3. **Set host env vars** — the script automatically passes through `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`, `OPENAI_API_KEY`, and `GROK_API_KEY` from your shell.

### Docker Compose Alternative

If you prefer Docker Compose, add this to your `docker-compose.yml`:

```yaml
services:
  agent:
    build:
      context: .
      dockerfile: Dockerfile
    image: openclaude-custom:local
    container_name: openclaude-box
    volumes:
      - .:/workspace
      - ${HOME}/.openclaude-box:/home/node/.openclaude
      - ${HOME}/.gitconfig:/home/node/.gitconfig
      - ${HOME}/.bashrc:/home/node/.bashrc
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - GEMINI_API_KEY=${GEMINI_API_KEY}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - GROK_API_KEY=${GROK_API_KEY}
    tty: true
```

## Dev Setup

### Local development

```bash
git clone <repo-url>
cd openclaude-box
make init        # Create runtime dir
make clone       # Clone OpenClaude into src/
make build       # Build Docker image
make run         # Launch agent
```

### CI / Docker Hub

This repo includes a GitHub Action (`/.github/workflows/build.yml`) that automatically builds and pushes the image to Docker Hub on every push to `main`.

Required secret: `DOCKERHUB_TOKEN` — a Docker Hub Personal Access Token (classic, read/write scope).

### Makefile targets

| Target | Description |
|--------|-------------|
| `make init` | Create `~/.openclaude-box/` |
| `make build` | Build Docker image (auto-clones `src/` if missing) |
| `make run` | Build and launch the agent |
| `make version` | Show agent version |
| `make tools` | List pre-installed dev tools |
| `make clean` | Stop and remove the container |

## Architecture

```
┌──────────────────────────────────────────────────────┐
│  Host machine                                        │
│                                                      │
│  ~/.openclaude-box/   → persistent config & state    │
│  ./src/               → cloned OpenClaude source     │
│  .openclaude.json     → provider keys & settings     │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │  openclaude-box Docker image                 │   │
│  │  ├─ Node 22 (slim)                           │   │
│  │  ├─ OpenClaude CLI                           │   │
│  │  ├─ git, ripgrep, golang, python3, jq, make  │   │
│  │  └─ /app (agent workspace)                   │   │
│  └──────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────┘
```

The container is **ephemeral** — all writes inside it are wiped when the container stops. Only the bind-mounted directories persist.

## License

MIT — see [LICENSE](LICENSE) for details.
