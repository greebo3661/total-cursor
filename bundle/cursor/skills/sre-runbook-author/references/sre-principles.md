# SRE Principles for Runbooks

These principles are inspired by Google SRE practices and aligned with common SRE best practices. They do not imply affiliation with Google.

## Actionable Alerting

Runbooks should be attached to alerts that require human judgment or action. If an alert has no action, fix the alert or automate the response.

## Emergency Response

During incidents, responders need concise instructions, clear ownership, and known-safe options. A runbook should reduce cognitive load under pressure.

## Safe Mitigation

Mitigation should prioritize user impact reduction while minimizing the chance of making the incident worse. Start with evidence and reversible actions.

## Verification

Every meaningful action needs a verification step. Verification should compare actual results with expected results using metrics, logs, health checks, or user-impact signals.

## Rollback and Abort Criteria

Risky actions require a stop rule. Define when to abort, when to roll back, who approves, and what evidence justifies the decision.

## Escalation

Escalation is a safety mechanism, not a failure. Escalate when impact is high, uncertainty is high, access is missing, or the runbook no longer matches reality.

## Ownership

Runbooks need owners. The owner keeps the runbook accurate, removes toil, and ensures alerts, dashboards, and operational procedures remain aligned.

## Incident Review Outside Runbooks

Incidents should improve the system. Capture follow-up work for monitoring, automation, permanent fixes, documentation, and training in the incident response process or executor output, not inside the static executable runbook.

## Toil Reduction

A runbook should not preserve avoidable manual work forever. Use execution logs and incident review to identify repeated manual steps that are automation candidates, especially read-only diagnostics and low-risk checks.
