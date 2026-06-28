# AGENTS.md — d:\docker

Cross-tool project context for AI coding agents (read natively by Cursor, Codex, Copilot, etc).

## Project

Voice / telephony platform: caller dials an extension in Asterisk, audio is routed
through an ARI/Stasis gateway to on-prem ASR and a local LLM, with TTS played back
into the call. Infrastructure is Docker-based and managed from a Windows Server host.

## Topology

- Windows host (Asterisk + ASR + LLM): `192.168.148.109`
- Linux host (gateway + TTS): `192.168.149.194`
- Flow: caller -> Asterisk (ext 3003) -> ARI Stasis gateway (`voice_bot`) ->
  ASR on Windows (Whisper / GigaAM) -> prompt -> LLM on Windows (Gemma4 / avibe) ->
  MOSS-TTS on Linux -> audio back into channel.

## Stack

- Python: `gigaam/` (ASR service), `gemma4-4b/` (LLM inference)
- Docker Compose per service directory
- Asterisk PBX + WebRTC + coturn (`asterisk/`)
- React / Next.js for web UI (when applicable)
- PowerShell for Windows host automation (repo root `*.ps1`)

## Key paths

- `gigaam/` — ASR service (`main.py`, `transcriber.py`, Dockerfile, compose)
- `gemma4-4b/` — LLM inference service
- `asterisk/` — PBX configs (`etc/`), WebRTC runbooks (`docs/asterisk-webrtc/`)
- `config/` — environment configs and integration notes
- `docs/` — analysis and agent-stack documentation
- `VOICE-BOT-HANDOFF.md` — full voice-bot architecture and handoff
- `CONTAINERS.md` — container reference map

## Conventions

- Docker-first deployment; one `docker-compose.yml` per service.
- Acceptance tests live in `*/scripts/run-acceptance-tests.ps1`.
- WebRTC / SIP changes must follow the checklists in `asterisk/docs/asterisk-webrtc/`.
- No secrets in the repo — only `*.env.example`. Real values stay on hosts.
- PowerShell scripts target Windows Server; prefer PowerShell 7+ where possible.

## Commands

- `docker compose up -d` (run inside the relevant service directory)
- Acceptance: `pwsh -File <service>/scripts/run-acceptance-tests.ps1`
- Host/SSH/firewall management: PowerShell scripts in the repo root.

## Agent workflow (full cycle)

See `docs/full-cycle-agent-stack.md` for the installed skill/agent stack and the
phase map (discovery -> spec -> plan -> build -> test -> QA -> security -> deploy ->
post-deploy). Prefer: clarify spec first, plan before coding, tests before/with
implementation, review and security gate before deploy.
