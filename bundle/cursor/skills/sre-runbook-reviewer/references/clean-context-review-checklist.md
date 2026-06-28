# Clean-Context Review Checklist

Use this checklist to review a runbook as if you are the on-call engineer seeing it for the first time during an incident.

## Scope

- Does the title identify the service, alert, or operation?
- Does the runbook say when to use it?
- Does it say when not to use it?
- Does it name the environment, region, namespace, service, queue, deployment, or dependency?

## Preconditions and Access

- Are required tools listed?
- Are required permissions listed?
- Are production access assumptions explicit?
- Are credentials or secret names avoided?
- Is there a stop condition if access is missing?
- If this is a production runbook, are placeholders resolved, intentionally variable, or explicitly nonapplicable?
- If this is an example or template, are placeholders generic and clearly not invented production facts?

## Alert and Symptoms

- Is the authoritative alert, monitor, or dashboard linked?
- Does the runbook avoid duplicating alert thresholds and queries that should live in the alerting system?
- Are optional source links omitted when the team does not use that system, rather than left as meaningless placeholders?
- Are user-visible symptoms described?
- Are likely false positives or exclusions documented?

## Diagnostics

- Do read-only diagnostics come first?
- Are dashboards linked or represented by placeholders?
- Are log queries concrete or represented by placeholders?
- Are metric names, expected values, and time windows present?
- Are dependency checks included?
- Are recent deploys or config changes checked?

## Decisions

- Does the runbook explain how to choose between mitigations?
- Are severity or impact criteria concrete?
- Are timeboxes present for diagnosis and escalation?
- Does it stop when observations do not match the runbook?

## Risk and Safety

- Are risky actions clearly marked before execution?
- Do risky actions require approval?
- Is blast radius described?
- Are customer-impacting effects stated?
- Are data-changing actions called out?
- Are pod deletion and restarts treated as mutating actions rather than harmless cleanup?
- Do rollback or config-change steps use the approved deployment, release, or GitOps tool unless direct platform commands are explicitly approved?
- Are alert suppression steps treated as risky?

## Verification

- Does each action have an expected result?
- Does each mitigation have a verification step?
- Are success criteria measurable?
- Does the runbook say how long to monitor after mitigation?

## Rollback and Abort

- Does every risky action have rollback or abort criteria?
- Are rollback commands or manual procedures included as placeholders?
- Are conditions for abandoning the runbook clear?

## Escalation

- Are owners and escalation channels named or represented by placeholders?
- Does the runbook say when to escalate?
- Does the runbook link to the incident communication process when communication is required?

## Evidence and Execution Focus

- Does the runbook say what evidence to preserve?
- Does it require secret and sensitive-data redaction before sharing evidence?
- Are command outputs, dashboard links, log snippets, approvals, and timestamps captured?
- Does the runbook avoid authoring notes, validation gaps, post-incident process, and automation ideas in the executable body?
- If agent authoring notes are present, are they plain agent output outside the runbook artifact rather than Markdown runbook headings?
