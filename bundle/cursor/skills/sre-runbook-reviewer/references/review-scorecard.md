# Review Scorecard

Score clean-context executability from 1 to 5.

## 5: Executable

An on-call engineer or agent can follow the runbook without guessing. Commands, source links, dashboards, owners, expected outputs, verification, rollback, escalation, and stop conditions are concrete. Placeholders are acceptable only when the artifact is explicitly a template/example or the value is intentionally supplied at execution time. The executable body avoids authoring metadata, post-incident process, and automation ideas.

## 4: Mostly Executable

The runbook is safe and mostly clear, but has a small number of missing local details or minor ambiguities. It can be used with limited clarification.

## 3: Partially Executable

The runbook has useful structure but depends on tribal knowledge. Some key commands, dashboards, thresholds, expected results, verification steps, or escalation paths are missing.

## 2: Unsafe or Ambiguous

The runbook includes vague or risky actions without enough safety controls. Responders would need substantial service knowledge to avoid mistakes.

## 1: Not Executable

The runbook is too vague, unsafe, or incomplete to use during an incident. It lacks core operational details, safety gates, or verification.

## Verdict Guidance

Pass:

- Score is 5.
- No critical blockers.
- Risky actions have approval gates, verification, and rollback or abort criteria.

Pass with changes:

- Score is 4.
- No critical blockers.
- Issues are concrete and patchable.

Fail:

- Score is 1 to 3.
- Any critical blocker exists.
- A risky action lacks approval, verification, or rollback/abort criteria.

## Issue Severity

Critical blockers:

- Unsafe risky action without approval gate.
- Destructive or data-changing action without rollback or abort criteria.
- Missing service/environment target for a mutating action.
- No verification after mitigation.
- Escalation path missing for high-impact incidents.
- Runbook exposes or encourages sharing secrets, tokens, raw secret manifests, or sensitive customer data.

Major issues:

- Missing dashboards, log queries, thresholds, expected outputs, owners, or access requirements.
- Unresolved placeholders in a production runbook that are not intentionally variable and could have been provided before publication.
- Decision tree is unclear.
- Recent deploys, dependencies, or impact assessment are omitted.
- Communication path or evidence capture is incomplete.
- Platform-specific mutating actions such as resource deletion, direct rollback, restart, scaling, or config changes are presented without approval and tool-ownership guidance.
- Authoring notes, validation gaps, post-incident process, or automation ideas are mixed into incident-time execution flow or presented as runbook sections.

Minor issues:

- Formatting problems.
- Non-blocking wording ambiguity.
- Non-blocking wording or section-order issues.
- Inconsistent section names.
