---
name: sre-runbook-reviewer
description: Review SRE runbooks from a clean-context perspective. Use when the user asks whether a runbook is clear, executable, safe, complete, on-call friendly, agent-executable, or missing assumptions, commands, dashboards, thresholds, rollback steps, escalation paths, or verification criteria.
---

# SRE Runbook Reviewer

Use this skill when the user asks to review, score, harden, or find gaps in an SRE runbook.

Do not use this skill to execute the runbook or to add invented service-specific facts. Review only what is present in the runbook and user-provided context.

## Review Posture

Review as if you have no prior context beyond the runbook and the provided alert or incident input.

- Do not rely on hidden tribal knowledge.
- When authorized MCP servers, apps, or connectors are available, use read-only lookups to verify referenced alerts, dashboards, incidents, services, owners, thresholds, and queries.
- Flag every missing command, dashboard, owner, threshold, service name, environment, credential, or expected output that is required for execution.
- Treat placeholders differently by artifact type: placeholders are acceptable in examples and reusable templates, but production runbooks should resolve them, mark them as intentionally variable, or omit nonapplicable optional items.
- Flag unsafe actions that lack approval gates.
- Flag steps without verification.
- Flag missing rollback or abort criteria.
- Flag vague phrases such as "check the logs", "restart the service", "scale up", or "notify stakeholders" unless they are concrete.
- Flag authoring metadata, validation gaps, post-incident process, communication templates, or automation ideas embedded in the executable runbook.
- Identify what would be confusing at 3 AM.
- Produce a scorecard and prioritized fixes.

## Safety Constraints

- Treat destructive, customer-impacting, data-changing, deploy, rollback, restart, scaling, failover, config, permission, alert-disabling, and resource-modifying steps as risky.
- Risky steps must have approval, blast-radius notes, verification, and rollback or abort criteria.
- Do not normalize unsafe runbooks by assuming missing safety context exists elsewhere.
- Connector data can confirm or refute runbook claims, but missing connector access is itself a review finding rather than a reason to guess.

## References

Open these only when useful:

- `references/clean-context-review-checklist.md` for the detailed review checklist.
- `references/review-scorecard.md` for scoring guidance.
- `references/context-verification.md` when referenced operational data can be checked through available connectors.

## Output Format

Use this format:

1. Summary
1. Overall verdict: Pass / Pass with changes / Fail
1. Critical blockers
1. Major issues
1. Minor issues
1. Hidden assumptions
1. Safety concerns
1. Missing verification
1. Missing rollback / abort criteria
1. Missing escalation or ownership
1. Clean-context executability score from 1 to 5
1. Recommended patch
