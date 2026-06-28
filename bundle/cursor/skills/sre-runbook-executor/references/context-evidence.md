# Context Evidence

Use available MCP servers, apps, or tool connectors only for read-only evidence collection while executing a runbook. This is optional and best-effort: execution must stop when required evidence, access, commands, or expected results are missing.

## Allowed Connector Use

Use authorized connectors to:

- Confirm that the selected runbook applies to the current alert, service, environment, incident, or operational task.
- Fetch alert, monitor, dashboard, incident, metric, log, trace, service catalog, or deployment evidence for the current step.
- Compare actual state with the runbook's expected result.
- Capture URLs, IDs, timestamps, query outputs, and summaries for the execution log.
- Identify mismatches that require stopping or escalation.

## Disallowed Connector Use

Do not use connectors to:

- Mutate monitoring, incident, deployment, ticketing, service, or production configuration unless the runbook step explicitly says to do so and approval has been granted.
- Create, update, silence, or delete alerts.
- Change incident severity, roles, status, or communications unless the runbook step explicitly requires it.
- Deploy, roll back, restart, scale, fail over, reconfigure, delete, or modify resources without an approval gate.
- Invent a replacement command, threshold, owner, dashboard, or expected output.

## Example Connector Patterns

Datadog:

- Read monitor state, monitor query, thresholds, tags, dashboard links, logs, APM traces, SLO state, and notebook links.
- Record monitor IDs and dashboard URLs as evidence.
- Stop if monitor scope or threshold differs from the runbook.

Grafana:

- Read dashboards, panels, Explore queries, alert rules, data sources, labels, thresholds, and evaluation state.
- Record panel URLs, query results, time ranges, and alert rule links as evidence.
- Stop if the panel or alert rule does not match the runbook's target service or environment.

incident.io:

- Read incident status, severity, timeline, affected services, roles, escalation paths, and follow-up actions.
- Record incident URLs, timestamps, status updates, and current commander or owner as evidence.
- Ask before posting updates or changing incident fields unless the runbook has a clear low-risk communication step.

Other connectors:

- Infer the same method from the connector's domain. Use read-only lookups to collect evidence for the current step, compare actual and expected state, and stop on mismatches.

## Evidence Logging

For each connector lookup, record:

- Connector name.
- Object type and identifier.
- Query, URL, or lookup parameters.
- Timestamp and time range.
- Actual result.
- Whether the result matches the runbook's expected state.
- Link or artifact to preserve.

## Stop Conditions

Stop when:

- A connector lookup fails and the runbook requires that evidence.
- The connector returns a different service, environment, threshold, or target than the runbook states.
- The lookup reveals broader impact than the runbook covers.
- A connector action would be mutating or customer-impacting.
- The next step is risky and approval has not been granted.
