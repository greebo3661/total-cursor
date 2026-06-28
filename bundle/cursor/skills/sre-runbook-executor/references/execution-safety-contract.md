# Execution Safety Contract

This contract governs safe runbook execution.

## Execution Rules

1. Confirm the incident input and selected runbook.
1. Confirm the runbook applies to the current service, environment, and symptom.
1. Execute one step at a time.
1. Prefer read-only diagnostics before state changes.
1. Capture evidence before and after each action.
1. Compare actual results with expected results.
1. Stop on ambiguity, missing access, missing tools, or mismatched state.
1. Stop before risky actions until approval is explicit.
1. Do not invent commands, thresholds, dashboards, owners, expected outputs, or credentials.
1. Escalate when the runbook no longer matches reality.
1. Use connectors only for read-only evidence unless the runbook explicitly requires a mutating action and approval has been granted.
1. Redact secrets, tokens, credentials, and sensitive customer data before sharing logs, manifests, screenshots, or command output.

## Safety Classifications

Read-only:

- Queries metrics, logs, dashboards, status endpoints, history, metadata, or configuration without changing state.

Low-risk:

- Creates notes, opens tickets, posts status updates, or runs local formatting/analysis that cannot affect production.

Risky:

- Changes production state, customer experience, data, traffic, capacity, deployment version, configuration, permissions, alerts, or resources. Examples include pod deletion, restarts, rollbacks, scaling, failovers, config changes, and alert suppression.

## Stop Conditions

Stop when:

- A command or action is missing.
- A placeholder has not been resolved.
- Required access is unavailable.
- Expected result is missing.
- Actual result differs materially from expected result.
- A risky action lacks approval.
- Blast radius is unknown.
- Rollback or abort criteria are missing.
- The incident appears outside the runbook scope.
