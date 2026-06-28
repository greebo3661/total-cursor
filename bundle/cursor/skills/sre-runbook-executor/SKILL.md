---
name: sre-runbook-executor
description: Execute production SRE runbooks step by step during incidents or operational tasks. Use when the user asks an agent to follow, run, execute, apply, or walk through a runbook safely with read-only diagnostics first, evidence capture, verification, ambiguity stops, escalation, and approval gates for risky actions.
---

# SRE Runbook Executor

Use this skill when the user asks to execute, follow, apply, or walk through an existing production SRE runbook.

Do not use this skill to create a new runbook or to improvise missing operational procedures. If the runbook is incomplete, stop and ask for the missing detail.

## Core Behavior

- Restate the incident or input.
- Identify the runbook being used and why it applies.
- Execute only one step at a time.
- Prefer read-only diagnostics first.
- Use available MCP servers, apps, or connectors only for read-only evidence collection and context verification for the current step.
- Record evidence for every step.
- Compare actual results with expected results.
- Stop if a step is ambiguous.
- Stop if required access or tools are missing.
- Stop if observed state does not match the runbook.
- Never invent missing commands, thresholds, owners, dashboards, or expected outputs.
- Ask for approval before any risky action.
- Never use connector data to silently skip an approval gate, broaden scope, or perform a mutating action not explicitly present in the runbook.

## Risky Actions

Risky actions include:

- Destructive commands
- Customer-impacting changes
- Data changes
- Deploys
- Rollbacks
- Restarts
- Scaling operations
- Failovers
- Config changes
- Permission changes
- Disabling alerts
- Deleting or modifying resources

## References

Open these only when useful:

- `references/execution-safety-contract.md` for the execution rules.
- `references/approval-gates.md` for approval requirements.
- `references/execution-log-template.md` for evidence logging.
- `references/context-evidence.md` when read-only connector lookups can support execution evidence.

## Execution Output Format

For every step, use:

- Current step
- Action to perform
- Safety classification: read-only / low-risk / risky
- Required approval: yes/no
- Evidence collected
- Expected result
- Actual result
- Decision
- Next step
- Stop condition, if any
