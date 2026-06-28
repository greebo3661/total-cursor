---
name: generate-uat
description: Use when you need a client-ready User Acceptance Testing (UAT) plan from a spec, set of acceptance criteria, GitHub issues, or feature description. Produces a requirement-pure, deduplicated test document with steps, expected results, and sign-off.
---

# Generate UAT Plan

Turn requirements / acceptance criteria into a structured, client-ready UAT test plan.

## Inputs

- A spec, feature description, ticket(s), or list of acceptance criteria.
- Target environment (staging URL / host, test accounts) if available.
- Known constraints, out-of-scope items, and the audience (internal QA vs client sign-off).

If inputs are missing, proceed with explicit assumptions and list gaps in an `Open questions` section.

## Guardrails

- Stay requirement-pure: test what was specified, not implementation details.
- Deduplicate scenarios that repeat across platforms/flows; note shared preconditions once.
- Mark every assumption explicitly. Do not invent product behavior.
- Separate functional, edge-case, negative, and non-functional (perf/security/a11y) checks.

## Workflow

1. Restate the feature objective in one sentence.
2. Extract every acceptance criterion; assign a stable ID (UAT-001, UAT-002, ...).
3. For each criterion, write one or more test cases.
4. Group by user flow / module; list shared preconditions per group.
5. Add negative and edge cases for each critical path.
6. Add a non-functional section when relevant (performance, security, accessibility).
7. Produce a sign-off table.

## Output format

```
# UAT Plan: <feature>

## Scope
- In scope: ...
- Out of scope: ...
- Test environment: ...
- Preconditions: ...

## Test cases
| ID | Title | Preconditions | Steps | Expected result | Priority | Status |
|----|-------|---------------|-------|-----------------|----------|--------|
| UAT-001 | ... | ... | 1. ... 2. ... | ... | High | Not run |

## Negative / edge cases
| ID | Title | Steps | Expected result | Status |
|----|-------|-------|-----------------|--------|

## Non-functional checks
- Performance: ...
- Security: ...
- Accessibility: ...

## Open questions / assumptions
- ...

## Sign-off
| Role | Name | Verdict (Pass/Fail) | Date |
|------|------|---------------------|------|
| QA | | | |
| Product owner / Client | | | |
```

## Done criteria

- Every acceptance criterion maps to at least one test case ID.
- Critical paths have negative/edge coverage.
- Document is self-contained and readable by a non-technical stakeholder.
