# Context Enrichment

Use available MCP servers, apps, or tool connectors to validate operational context before writing a runbook. This is optional and best-effort: the skill must remain useful when no connector is installed. Keep connector validation results out of the executable runbook unless they are stable source links or concrete steps.

## When to Enrich Context

Try enrichment when the user provides:

- Alert or monitor names, IDs, URLs, or payloads.
- Dashboard names, IDs, or URLs.
- Metric names or queries.
- Service, environment, namespace, cluster, queue, topic, or deployment names.
- Incident IDs, tickets, deploy IDs, or change records.

## What to Validate

Validate only through available authorized tools:

- Does the alert or monitor exist?
- What is the exact alert query, threshold, duration, grouping, tags, and notification routing?
- Which dashboards, notebooks, traces, logs, or service catalog entries are linked?
- Which service, environment, region, namespace, cluster, queue, topic, or deployment does the alert target?
- What labels or dimensions identify affected resources?
- Are there existing runbook links, owners, escalation channels, or SLOs?
- Are recent incidents, deploys, config changes, or maintenance windows relevant?

Prefer linking to the authoritative alert, dashboard, incident, or service record over copying values that will drift.

## Datadog Example

If a Datadog MCP server or connector is available, use Datadog terminology:

- Look up the alert as a monitor.
- Capture monitor name, ID, query, thresholds, evaluation window, tags, notification handles, and message text.
- Validate dashboard URLs and dashboard titles when referenced.
- Capture linked service catalog, SLO, logs, APM, notebook, or runbook references when available.
- Preserve monitor and dashboard URLs as evidence.

If Datadog is not available, keep only placeholders needed for execution, such as `<ALERT_NAME>`, `<MONITOR_ID>`, `<DASHBOARD_URL>`, `<METRIC_NAME>`, or `<THRESHOLD>`. Omit Datadog-specific links when the team does not use Datadog.

## Grafana Example

If a Grafana MCP server or connector is available:

- Look up referenced dashboards by URL, UID, folder, or title.
- Capture dashboard title, UID, panel titles, metric queries, variables, data sources, and time ranges.
- Validate alert rules, contact points, labels, annotations, thresholds, and evaluation intervals when available.
- Preserve dashboard, panel, alert rule, and Explore links as evidence.
- Use validated panel or Explore queries as placeholders for read-only diagnostics.

If Grafana is not available, keep only placeholders needed for execution, such as `<DASHBOARD_URL>`, `<PANEL_URL>`, `<METRIC_QUERY>`, `<ALERT_RULE_NAME>`, or `<THRESHOLD>`. Omit Grafana-specific links when the team does not use Grafana.

## incident.io Example

If an incident.io MCP server or connector is available:

- Look up referenced incidents, incident types, severities, timestamps, summaries, and status updates.
- Capture affected services, escalation paths, roles, and communication channels when available.
- Use prior related incidents to identify recurring symptoms, mitigations, and known pitfalls.
- Preserve incident URLs and status update links as evidence.
- Do not copy sensitive customer details or private incident commentary into the generated runbook unless the user explicitly asks and it is appropriate to the audience.

If incident.io is not available, keep only incident placeholders that are needed for execution, such as `<INCIDENT_ID>`, `<INCIDENT_URL>`, `<SEVERITY>`, or `<ESCALATION_CHANNEL>`. Omit incident-management links when the team does not use that system.

## Rules

- Do not invent missing dashboards, monitors, metric names, thresholds, owners, credentials, or expected outputs.
- Do not expose secrets, tokens, private URLs, or sensitive customer data in the generated runbook.
- If a connector returns conflicting data, cite the conflict in authoring notes after the runbook and ask which source is authoritative.
- If access fails, record the attempted validation in authoring notes and continue with placeholders only for required or intentionally variable facts.
- Prefer read-only queries. Do not mutate monitoring, alerting, incident, or service configuration while authoring a runbook.

## Runbook Sections to Update From Enrichment

- `Required access and tools`: connector/tool names and required permissions.
- `Source links`: authoritative alert, monitor, dashboard, logs, traces, service catalog, deploy history, and incident links that apply.
- `Symptoms`: observed or linked symptoms from monitor text or incident context.
- `Read-only diagnostics`: validated dashboards, log queries, traces, and service views.
- `Escalation`: validated owners, notification handles, or escalation channels.
- `Evidence to preserve`: monitor URLs, dashboard URLs, query outputs, and incident links.

## Agent Output Notes

If validation gaps remain, report them after the runbook as plain text, not as a Markdown heading:

```text
---
Agent output, not part of the runbook:
- <MISSING_INPUT_OR_VALIDATION_GAP>
```

Do not include these notes under the runbook title, in the runbook table of contents, or inside the incident-time execution flow.
