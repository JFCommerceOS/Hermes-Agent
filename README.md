# Hermes Agent (local project)

Local Hermes Agent install created on 2026-06-02.

## Layout

| Path | Purpose |
|------|---------|
| `hermes-agent/` | Upstream [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) clone + Python venv |
| `config.yaml`, `.env` | Hermes data home (`HERMES_HOME` = this directory) |
| `cron/`, `sessions/`, `logs/` | Runtime data (created by installer) |

## Commands

Open a **new** PowerShell window (PATH was updated), then:

```powershell
hermes doctor
hermes setup          # API keys and provider
hermes                # interactive CLI
```

Or invoke directly:

```powershell
D:\hermes-agent-project\hermes-agent\venv\Scripts\hermes.exe doctor
```

## Environment

- `HERMES_HOME` = `D:\hermes-agent-project`
- Install script used: Windows `install.ps1` (native Windows; the bash `install.sh` one-liner is for Linux/macOS/WSL/Git Bash).

## Update

```powershell
hermes update
```
