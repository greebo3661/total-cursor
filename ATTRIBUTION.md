# Attribution

This distribution pack bundles skills, rules, agents, and hooks from multiple open-source
projects. See each upstream repository for license terms.

| Component | Upstream | URL | Notes |
|-----------|----------|-----|-------|
| ECC skills (15) | affaan-m/ECC | https://github.com/affaan-m/ECC | search-first, backend-patterns, api-design, python-*, fastapi-patterns, frontend-patterns, react-*, e2e-testing, docker-patterns, deployment-patterns, security-review, verification-loop, eval-harness |
| ECC rules (24) | affaan-m/ECC | same | common, python, typescript, react — converted to `.mdc` |
| ECC agents (6) | affaan-m/ECC | same | planner, architect, code-reviewer, security-reviewer, e2e-runner, doc-updater |
| ECC guard hooks (3) | affaan-m/ECC | same | before-submit-prompt, before-read-file, before-tab-file-read |
| Superpowers (6) | obra/superpowers | https://github.com/obra/superpowers | brainstorming, writing-plans, test-driven-development, requesting-code-review, finishing-a-development-branch, using-git-worktrees |
| spec-kit (11 skills + templates) | github/spec-kit | https://github.com/github/spec-kit | speckit-* skills and `.specify/` templates |
| QA skills (3) | QASkills.sh | https://qaskills.sh | playwright-e2e, pytest-patterns, react-testing-library |
| pre-deploy-checklist | DIBmaster/cursor-skills | https://github.com/DIBmaster/cursor-skills | pre-deploy-checklist skill |
| SRE runbooks (3) | medzin/sre-runbook-agent-skills | https://github.com/medzin/sre-runbook-agent-skills | sre-runbook-author, -reviewer, -executor |
| runbook-generator | borghei/Claude-Skills | https://github.com/borghei/Claude-Skills | engineering/runbook-generator |
| generate-uat | custom | this repo | replacement for non-existent rushikeshpol02/ai-skills |
| voice-bot profile | custom | d:\\docker project | AGENTS.md, voice-bot-stack skill, voice-bot.mdc rule |

## MCP servers (configured via example, not bundled)

| Server | Package | URL |
|--------|---------|-----|
| GitHub | @modelcontextprotocol/server-github | https://www.npmjs.com/package/@modelcontextprotocol/server-github |
| Playwright | @playwright/mcp | https://www.npmjs.com/package/@playwright/mcp |

## Security audit tool

| Tool | Package | URL |
|------|---------|-----|
| AgentShield | ecc-agentshield | https://www.npmjs.com/package/ecc-agentshield |

When updating this pack, re-run upstream verification and `verify.ps1` after changes.
