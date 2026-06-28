# Production SRE Runbook Template

# \<RUNBOOK_TITLE>

## Purpose

State the incident, alert, or operational task this runbook handles.

## When to Use This Runbook

- Use when `<ALERT_NAME>` fires for `<SERVICE_NAME>` in `<ENVIRONMENT>`.
- Use when symptoms match `<SYMPTOM_PATTERN>`.

## When Not to Use This Runbook

- Do not use when `<EXCLUSION_CONDITION>`.
- Escalate instead when `<ESCALATION_CONDITION>`.

## Preconditions

- Incident or ticket: `<INCIDENT_ID>`
- Service: `<SERVICE_NAME>`
- Environment: `<ENVIRONMENT>`
- Affected component: `<COMPONENT_NAME>`
- Runbook owner: `<RUNBOOK_OWNER>`

## Required Access and Tools

- Monitoring: `<DASHBOARD_URL>`
- Logs: `<LOG_SYSTEM>` with query `<LOG_QUERY>`
- Metrics: `<METRIC_SYSTEM>`
- Deployment tool: `<DEPLOYMENT_TOOL>`
- Production role, account, cluster, or environment access: `<ACCESS_REQUIREMENT>`

## Safety Constraints

- Start with read-only diagnostics.
- Preserve evidence before mutating state.
- Redact secrets and sensitive values from logs, manifests, command outputs, screenshots, and copied evidence before sharing.
- Stop before risky actions until approval is granted.
- Do not continue if observed state does not match this runbook.
- Use the approved deployment or GitOps tool for rollbacks and config changes unless direct platform commands are explicitly approved.
- Treat resource deletion, restarts, rollbacks, scaling, failovers, and config changes as risky actions.

## Source Links

- Alert or monitor: `<ALERT_OR_MONITOR_URL>`
- Primary dashboard: `<DASHBOARD_URL>`
- Logs or traces: `<LOG_OR_TRACE_URL>`
- Service catalog or owner record, if used: `<SERVICE_CATALOG_URL>`
- Deploy or change history, if used: `<CHANGE_HISTORY_URL>`

## Symptoms

- `<USER_VISIBLE_SYMPTOM>`
- `<SYSTEM_SYMPTOM>`
- `<DEPENDENCY_SYMPTOM>`

## Initial Triage

1. Confirm alert status in `<ALERTING_SYSTEM>`.
1. Identify affected service, environment, region, and version.
1. Start an incident record if impact is user-visible or escalating.
1. Record current time, alert labels, and links to dashboards/logs.

## Impact Assessment

- Affected users or tenants: `<AFFECTED_USERS>`
- Affected endpoints or jobs: `<AFFECTED_ENDPOINTS>`
- Error rate, latency, saturation, or backlog: `<IMPACT_METRICS>`
- Business impact: `<BUSINESS_IMPACT>`

## Read-Only Diagnostics

1. Check service health dashboard: `<DASHBOARD_URL>`.
   - Expected: `<EXPECTED_HEALTH_STATE>`
   - Evidence to capture: screenshot or metric link.
1. Query logs: `<LOG_QUERY>`.
   - Expected: `<EXPECTED_LOG_PATTERN>`
   - Evidence to capture: query URL and representative entries.
1. Check recent deploys or config changes: `<CHANGE_QUERY_OR_URL>`.
   - Expected: `<EXPECTED_CHANGE_STATE>`
   - Evidence to capture: change IDs and timestamps.
1. Check dependencies: `<DEPENDENCY_DASHBOARD_OR_QUERY>`.
   - Expected: `<EXPECTED_DEPENDENCY_STATE>`
   - Evidence to capture: dependency health indicators.

## Decision Tree

- If `<CONDITION_A>`, proceed to mitigation A.
- If `<CONDITION_B>`, proceed to mitigation B.
- If impact is severe or unclear after `<TIMEBOX>`, escalate to `<ON_CALL_ALIAS>` in `<ESCALATION_CHANNEL>`.
- If diagnostics contradict this runbook, stop and escalate.

## Mitigation Steps

### Mitigation 1: \<MITIGATION_NAME>

Safety classification: read-only / low-risk / risky

Approval required: yes/no

Action:

```sh
<COMMAND_OR_MANUAL_ACTION_PLACEHOLDER>
```

Expected result: `<EXPECTED_RESULT>`

Verification:

1. Check `<METRIC_OR_DASHBOARD>`.
1. Confirm `<SUCCESS_CRITERION>`.
1. Record `<EVIDENCE>`.

Rollback / abort criteria:

- Abort if `<ABORT_CONDITION>`.
- Roll back with `<ROLLBACK_ACTION_PLACEHOLDER>` if `<ROLLBACK_CONDITION>`.

## Escalation

Escalate when:

- User impact is severe or expanding.
- Required access or tooling is unavailable.
- A risky action is required and no approver is available.
- Observed state does not match this runbook.
- Mitigation fails after `<TIMEBOX>`.

Contact:

- Primary: `<ON_CALL_ALIAS>`
- Channel: `<ESCALATION_CHANNEL>`
- Backup: `<BACKUP_ALIAS>`

## Evidence to Preserve

- Alert payload and timestamps.
- Dashboard links or screenshots.
- Log query URLs and representative entries.
- Change IDs, deploy versions, and config diffs.
- Commands run and outputs.
- Approval records for risky actions.
- Secret values, tokens, credentials, and sensitive customer data must be redacted before evidence is shared.

## Completion Criteria

- Alert has cleared or stayed below threshold for `<STABILITY_WINDOW>`.
- User-visible symptoms are resolved.
- Mitigation has been verified.
