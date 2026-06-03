# Installing WSL2 and Docker (optional)

Hermes Hybrid works in **Git Bash on Windows** without WSL. Enable WSL2 only if you want Linux-native tooling or container sandboxes.

## WSL2 (optional)

1. Open PowerShell **as Administrator**:
   ```powershell
   wsl --install
   ```
2. Reboot when prompted, then set a default distro (Ubuntu recommended).
3. In Git Bash, verify:
   ```bash
   wsl.exe --status
   ```

Use WSL paths like `/mnt/d/hermes-agent-project/hermes-hybrid-setup` when running tools inside Linux.

## Docker Desktop (optional)

Needed only when `ENABLE_DOCKER_SANDBOX=true` in `.env`.

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) with WSL2 backend.
2. Start Docker Desktop and wait until it reports **Running**.
3. From Git Bash:
   ```bash
   docker info
   bash scripts/check-environment.sh
   ```

## Hermes + local models in WSL

If Ollama runs inside WSL, point `.env` at the WSL IP or use port forwarding:

```env
LOCAL_MODEL_BASE_URL=http://127.0.0.1:11434/v1
```

From Windows Git Bash, `127.0.0.1:11434` works when Ollama listens on all interfaces or WSL forwards the port.

## When to skip

- No Docker → set `ENABLE_DOCKER_SANDBOX=false`
- No WSL → stay on Git Bash scripts only; all `scripts/*.sh` remain the source of truth
