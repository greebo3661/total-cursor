# Context Verification

Use available MCP servers, apps, or tool connectors to verify runbook references during review. This is optional and read-only: the reviewer must still produce a clean-context review when no connector is installed.

## What to Verify

When authorized tools are available, check whether the runbook's operational references exist and are concrete:

- Alerts, monitors, alert rules, thresholds, durations, labels, routing, and notification targets.
- Dashboards, panels, notebooks, traces, log queries, metric queries, and data sources.
- Services, environments, namespaces, clusters, queues, topics, deployments, and dependencies.
- Incidents, incident severities, status updates, affected services, escalation channels, owners, and follow-up actions.
- Change records, deploy IDs, config changes, feature flags, and rollback targets.

## How to Report Findings

Use connector evidence to make review findings more precise:

- If a referenced object does not exist, flag it as a major issue or critical blocker depending on the step it supports.
- If the runbook name differs from the actual monitor, dashboard, or service name, flag the mismatch.
- If thresholds, queries, labels, environments, or owners differ from the runbook, report the discrepancy.
- If a connector reveals useful linked context missing from the runbook, recommend adding it.
- If access is missing, record which lookup could not be performed and list the resulting uncertainty.

## Example Connector Patterns

Datadog:

- Verify monitors, monitor IDs, queries, thresholds, tags, notification handles, dashboards, SLOs, logs, APM, and linked runbooks.

Grafana:

- Verify dashboards, panel UIDs, metric queries, data sources, variables, alert rules, thresholds, contact points, labels, and annotations.

incident.io:

- Verify incident IDs, severities, incident types, timelines, affected services, roles, communication channels, status updates, and follow-up actions.

Other connectors:

- Infer the same method from the connector's domain. Use read-only lookups to validate the objects the runbook depends on, then report confirmed facts, mismatches, and unknowns.

## Rules

- Do not mutate monitoring, incident, deployment, ticketing, or service configuration during review.
- Do not invent missing data when a connector is unavailable.
- Do not expose secrets, tokens, private customer details, or sensitive incident commentary in review output.
- Do not let connector data replace clean-context review. A runbook should still be executable from its own text or explicit links.
- Treat unverified critical references as risks, especially before risky or customer-impacting actions.
