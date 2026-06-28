# Runbook Quality Bar

A production SRE runbook is ready when an on-call engineer with no prior service context can use it during an incident without guessing.

## Required Qualities

- Clear scope: the runbook states when to use it and when not to use it.
- Concrete inputs: alerts, symptoms, dashboards, logs, services, environments, and affected user journeys are named, intentionally parameterized, or explicitly omitted when they do not apply.
- Safe order of operations: read-only diagnostics come before mutating actions.
- Explicit risk labels: risky actions are marked before the step, not after.
- Verification: every diagnostic and mitigation step has expected evidence or a success condition.
- Abort criteria: every risky action has a rollback or stop condition.
- Escalation: the runbook names who to contact, when, and through which channel.
- Evidence preservation: the runbook tells responders what to record before changing state.
- Secret handling: the runbook tells responders to redact sensitive values before sharing evidence.
- Completion criteria: the runbook explains when the incident can be considered mitigated.
- Execution focus: the runbook avoids authoring metadata, review notes, post-incident process, and automation ideas.

## Common Defects

- "Check logs" without a query, system, time window, or expected pattern.
- "Restart the service" without scope, approval, blast radius, command placeholder, verification, and rollback.
- "Delete the resource" as a harmless quick fix; resource deletion is a mutating action and needs scope, approval, verification, and abort criteria.
- "Scale up" without target component, limits, approval, cost/capacity impact, and success criteria.
- "Notify stakeholders" without linking to the incident communication process or naming the escalation channel.
- Dashboards named without URLs, metric names, or an explicit note that the team does not use that dashboard.
- Duplicated alert query or threshold details that should be linked to the authoritative alert or monitor.
- Mitigations without evidence capture.
- Rollbacks without a decision rule.
- Rollbacks that bypass the approved deployment, release, or GitOps tool without explicit approval.
- Escalation paths that assume tribal knowledge.
- Open questions, validation gaps, post-incident follow-up, or automation ideas embedded in the incident-time runbook body.

## Placeholder Standard

Placeholders are normal in reusable templates and examples. In a production runbook, resolve placeholders before publication whenever the user, connector, service catalog, deployment tool, or alerting system can provide the value.

When a value is missing during authoring, ask the user whether to:

1. Provide the value.
1. Keep a placeholder because the runbook is intentionally reusable.
1. Omit the item because the system or process does not exist in their environment.

Use angle-bracket placeholders for unresolved or intentionally variable local facts:

- `<SERVICE_NAME>`
- `<ENVIRONMENT>`
- `<COMPONENT_NAME>`
- `<NAMESPACE>`
- `<DASHBOARD_URL>`
- `<LOG_QUERY>`
- `<METRIC_NAME>`
- `<THRESHOLD>`
- `<ON_CALL_ALIAS>`
- `<ESCALATION_CHANNEL>`
- `<RUNBOOK_OWNER>`

Do not replace placeholders with invented values.

Do not create placeholders for optional links or tools that do not apply. For example, omit an incident process link when the team has no incident process URL, or omit a feature flag tool when the service does not use feature flags.
