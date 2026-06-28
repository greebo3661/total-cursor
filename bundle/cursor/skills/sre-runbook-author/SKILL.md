---
name: sre-runbook-author
description: Create execution-focused production SRE runbooks for incidents, alerts, operational procedures, service failures, rollbacks, mitigations, diagnostics, and escalation. Use when the user asks to write, improve, structure, or convert operational knowledge into a clear SRE runbook.
---

# SRE Runbook Author

Use this skill when the user asks to create, improve, restructure, or convert operational knowledge into a production SRE runbook.

Do not use this skill to execute a runbook, approve risky actions, or invent service-specific operational facts. For execution, use an execution-focused skill.

## Core Behavior

Create runbooks that can be followed by a human or AI agent during an incident. Include only information needed to decide, act, verify, stop, roll back, or escalate during the incident. Use concise, concrete steps and make missing details explicit.

When the user provides alert, dashboard, service, or incident identifiers, try to enrich and verify context through available MCP servers, apps, or connectors before drafting. Prefer links to authoritative sources over copying alert queries or thresholds into the runbook. If no connector is available or access is missing, do not guess.

If the user asks for a production runbook and required local details are missing, ask a short clarification before drafting unless the user explicitly asks for a generic example, template, or best-effort draft. Ask for the smallest useful set of values, such as service, environment, owner or escalation path, and required tooling. Also ask whether missing optional systems should be omitted.

Before finalizing a production runbook, resolve missing local details with the user when possible. For each missing item, choose one explicit outcome:

- The user provides the value.
- The runbook intentionally keeps a placeholder because it is a reusable template or example.
- The item or optional source link is omitted because it does not apply to the user's environment.

Do not force placeholders for optional systems a team does not use, such as an incident process URL, service catalog URL, change history URL, feature flag tool, or dashboard. Keep required sections, but include only applicable entries inside them.

Every runbook must include:

- Title
- Purpose
- When to use this runbook
- When not to use this runbook
- Preconditions
- Required access and tools
- Safety constraints
- Source links
- Symptoms
- Initial triage
- Impact assessment
- Read-only diagnostics
- Decision tree
- Mitigation steps
- Verification after each step
- Rollback / abort criteria
- Escalation
- Evidence to preserve
- Completion criteria

## Safety Constraints

- Prefer read-only diagnostics before mutating actions.
- Mark risky, destructive, or customer-impacting actions clearly.
- Do not invent commands, dashboards, owners, thresholds, credentials, service names, or expected outputs.
- Prefer verified operational data from available connectors over user-supplied names or memory, but never require a connector for the skill to work.
- Use placeholders only for reusable templates/examples, truly unresolved required facts, or intentionally variable incident inputs. Do not leave avoidable placeholders in a production runbook when the user can provide the value.
- Do not put authoring metadata, validation gaps, post-incident process, or automation ideas inside the executable runbook.
- Do not expose secrets; tell responders to redact sensitive values from logs, manifests, command output, and evidence before sharing.
- Prefer the approved deployment or GitOps tool for rollback or config changes; direct platform commands are examples only unless explicitly approved.
- Include verification after each mitigation step.
- Include rollback or abort criteria for every risky action.
- Include escalation criteria.

## References

Open these only when useful:

- `references/runbook-template.md` for the full runbook structure.
- `references/runbook-quality-bar.md` when checking completeness.
- `references/context-enrichment.md` when alert, dashboard, incident, or service identifiers may be validated through available connectors.
- `references/sre-principles.md` for SRE practice alignment.

## Output Format

Return the executable runbook first in Markdown. If important details are missing, add a horizontal rule after the runbook, then a plain-text agent-output block titled `Agent output, not part of the runbook:`. Do not use a Markdown heading for this block. Do not include these notes under the runbook title, in a runbook table of contents, or inside the incident-time execution flow.
