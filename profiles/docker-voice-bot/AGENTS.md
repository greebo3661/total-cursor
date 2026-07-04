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
- `youtube-transcribe/` — YouTube → GigaAM транскрибация, веб-UI (`:5004`), host-agent (`scripts/run-cookies-agent.ps1`, `:5005`)
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

## Skills & subagents routing

**Правило:** перед нетривиальной работой — прочитай релевантный skill (`Read` на `SKILL.md`).
Для изолированных или тяжёлых задач — делегируй субагенту через `Task`. Не импровизируй
паттерны, если skill или subagent уже покрывают задачу.

### Когда читать skill (обязательно)

| Задача | Skill | Путь |
|--------|-------|------|
| Сырой запрос / ТЗ / wishlist | `intake-to-spec` | `~/.cursor/skills/intake-to-spec/` |
| Новая фича, компонент, поведение | `brainstorming` | `~/.cursor/skills/brainstorming/` |
| Версионируемое ТЗ в git | `speckit-specify` → `speckit-plan` → `speckit-tasks` | `.cursor/skills/speckit-*/` |
| План перед кодом | `plan-change`, `writing-plans` | `~/.cursor/skills/` |
| Stress-test плана | `premortem` | `~/.cursor/skills/premortem/` |
| Любая реализация / bugfix | `test-driven-development` | `~/.cursor/skills/test-driven-development/` |
| Поиск готовых решений | `search-first` | `~/.cursor/skills/search-first/` |
| Python backend / FastAPI | `python-patterns`, `fastapi-patterns`, `api-design`, `backend-patterns` | `.cursor/skills/` |
| React / Next.js UI | `react-patterns`, `frontend-patterns` | `.cursor/skills/` |
| Webshop / product page / checkout | `frontend-ui-ux` | `~/.cursor/skills/frontend-ui-ux/` |
| UI polish / micro-interactions | `make-interfaces-feel-better` | `.cursor/skills/` |
| Asterisk / WebRTC / voice-bot | `voice-bot-stack` | `.cursor/skills/voice-bot-stack/` |
| Docker / compose / deploy | `docker-patterns`, `deployment-patterns` | `.cursor/skills/` |
| pytest / unit tests | `python-testing`, `pytest-patterns` | `.cursor/skills/` |
| React component tests | `react-testing`, `react-testing-library` | `.cursor/skills/` |
| E2E / Playwright | `e2e-testing`, `playwright-e2e` | `.cursor/skills/` |
| UAT для заказчика | `generate-uat` | `.cursor/skills/generate-uat/` |
| Auth / input / secrets / API | `security-review` | `.cursor/skills/security-review/` |
| Pre-deploy gate | `pre-deploy-checklist` | `.cursor/skills/pre-deploy-checklist/` |
| SRE runbook написать / выполнить / review | `sre-runbook-author`, `-executor`, `-reviewer` | `.cursor/skills/` |
| Завершение ветки / merge | `finishing-a-development-branch` | `~/.cursor/skills/` |
| Post-implementation acceptance | `review-and-verify`, `verification-loop` | `~/.cursor/skills/` |

**UI stack (порядок):** `brainstorming` → `frontend-ui-ux` (структура + conversion) →
`make-interfaces-feel-better` (polish) → `ui-ux-reviewer` subagent (приёмка).

**Spec-kit pipeline:** `speckit-constitution` → `speckit-specify` → `speckit-clarify` →
`speckit-plan` → `speckit-tasks` → `speckit-analyze` → `speckit-implement` → `speckit-converge`.

### Когда запускать subagent (`Task`)

| Задача | Subagent | Когда |
|--------|----------|-------|
| Обзор кодовой базы, поиск файлов | `explore` | Широкий search, не знаешь где код |
| Shell / git / docker ops | `shell` | Длинные или рискованные команды |
| План реализации | `planner` | Крупная фича, refactor, multi-file |
| Архитектура / trade-offs | `architect` | Новая подсистема, масштабирование |
| Code review после изменений | `code-reviewer` | **Обязательно** после любого кода |
| Security review | `security-reviewer` | Auth, input, DB, secrets, payments |
| E2E тесты | `e2e-runner` | Critical user flows, Playwright |
| UI/UX приёмка | `ui-ux-reviewer` | После UI impl, responsive, mockup compare |
| Верификация результата | `verifier` | Перед accept, когда output «слишком гладкий» |
| Документация / codemap | `doc-updater` | README, CODEMAPS, guides out of sync |
| Bugbot review | `bugbot` | Только по явному запросу пользователя |
| CI failure на PR | `ci-investigator` | Разбор упавшего check |
| Cursor product help | `cursor-guide` | «Как в Cursor…» |

Subagent definitions: `~/.cursor/agents/` (ECC) + встроенные Cursor (`verifier`, `ui-ux-reviewer`).

### Phase map (кратко)

```
intake-to-spec / speckit-specify
  → premortem (optional) / speckit-plan / planner+architect
  → search-first + domain skills + TDD
  → code-reviewer + security-reviewer (if sensitive)
  → pytest / e2e-runner / generate-uat
  → pre-deploy-checklist → deploy → sre-runbook-executor
  → review-and-verify / verifier
```

### Делегирование vs inline

- **Inline (skill only):** один файл, известный паттерн, правка по checklist.
- **Subagent:** >3 файлов, review gate, security-sensitive, E2E, UI acceptance, incident runbook.
- **Parallel subagents:** независимые review (например `code-reviewer` + `security-reviewer` только если явно нужны оба).

### Built-in Cursor skills (review gates)

| Skill | Subagent |
|-------|----------|
| `review-bugbot` | `bugbot` |
| `review-security` | `security-review` |

Использовать по запросу пользователя или перед merge критичных изменений.
