# Approval Gates

Risky actions require explicit approval before execution.

## Approval Request Format

Before a risky action, state:

- Proposed action
- Reason
- Target service, environment, namespace, region, or resource
- Owning deployment, release, or GitOps tool when relevant
- Expected impact
- Blast radius
- Evidence supporting the action
- Verification plan
- Rollback or abort criteria
- Approver required

Then ask for approval and stop.

## Actions Requiring Approval

- Destructive commands
- Customer-impacting changes
- Data changes
- Deploys
- Rollbacks
- Restarts
- Pod deletion
- Scaling operations
- Failovers
- Config changes
- Permission changes
- Disabling alerts
- Deleting or modifying resources

## Approval Evidence

Record:

- Who approved
- Where approval was given
- Timestamp
- Exact action approved
- Any constraints or timebox

## Approval Is Not Transferable

Approval for one action does not approve later risky actions. Ask again when the target, scope, command, risk, or rollback plan changes.
