# Hermes Agent

Local + hybrid Hermes Agent workstation for Windows.

**Repository:** [github.com/JFCommerceOS/Hermes-Agent](https://github.com/JFCommerceOS/Hermes-Agent)

## Layout

| Path | Purpose |
|------|---------|
| `hermes-agent/` | Upstream [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) clone + Python venv (gitignored) |
| `hermes-hybrid-setup/` | Local-first model system, skills, configs, workspaces (tracked) |
| `config.yaml`, `.env` | Hermes data home (`HERMES_HOME` = this directory; gitignored) |
| `cron/`, `sessions/`, `logs/` | Runtime data (gitignored) |

## Quick start

```powershell
cd D:\hermes-agent-project\hermes-hybrid-setup
bash scripts/bootstrap-offline.sh
bash scripts/show-model-notes.sh
```

Hermes CLI:

```powershell
$env:HERMES_HOME = "D:\hermes-agent-project"
hermes doctor
hermes setup          # API keys and provider (when ready)
hermes                # interactive CLI
```

Or invoke directly:

```powershell
D:\hermes-agent-project\hermes-agent\venv\Scripts\hermes.exe doctor
```

## Hybrid setup

See **`hermes-hybrid-setup/README.md`** for:

- Local-first model catalog (6 models)
- Budget policy ($20/mo cap)
- Isolated profiles (lifeos, commerceos-dev, homeos, research)
- Safety tiers T0–T8
- 11 bundled skills

## Environment

- `HERMES_HOME` = `D:\hermes-agent-project`
- Windows install: official `install.ps1` (not the bash `curl | bash` one-liner)

## Clone this repo

```powershell
git clone https://github.com/JFCommerceOS/Hermes-Agent.git D:\hermes-agent-project
```

Then install Hermes upstream into `hermes-agent/` per [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) docs.

## Update Hermes upstream

```powershell
hermes update
```
