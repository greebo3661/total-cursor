# Execution Log Template

Use this structure to preserve evidence during runbook execution.

## Incident

- Incident ID: `<INCIDENT_ID>`
- Runbook: `<RUNBOOK_NAME>`
- Service: `<SERVICE_NAME>`
- Environment: `<ENVIRONMENT>`
- Start time: `<START_TIME>`
- Executor: `<EXECUTOR>`

## Step Log

### Step <N>: \<STEP_NAME>

- Time started: `<TIME>`
- Action: `<ACTION>`
- Safety classification: read-only / low-risk / risky
- Approval required: yes/no
- Approval evidence: `<APPROVAL_RECORD>`
- Expected result: `<EXPECTED_RESULT>`
- Actual result: `<ACTUAL_RESULT>`
- Evidence:
  - Dashboard: `<DASHBOARD_URL>`
  - Logs: `<LOG_QUERY_OR_URL>`
  - Command output: `<OUTPUT_SNIPPET>`
  - Ticket or incident comment: `<LINK>`
- Decision: continue / stop / escalate / request approval / rollback
- Next step: `<NEXT_STEP>`
- Stop condition: `<STOP_CONDITION>`

## Final State

- Completion criteria met: yes/no
- Remaining risk: `<REMAINING_RISK>`
- Follow-up candidates observed during execution: `<FOLLOW_UP_CANDIDATES>`
- Automation or toil-reduction observations from this incident: `<AUTOMATION_OBSERVATIONS>`
- Incident update posted: yes/no
