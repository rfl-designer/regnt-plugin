---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Dispatch `regnt:code-reviewer` subagent to catch issues before they cascade.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch code-reviewer subagent:**

Use Agent tool with `regnt:code-reviewer` type, fill template:

**Placeholders:**
- `{WHAT_WAS_IMPLEMENTED}` - What you just built
- `{PLAN_OR_REQUIREMENTS}` - What it should do
- `{BASE_SHA}` - Starting commit
- `{HEAD_SHA}` - Ending commit
- `{DESCRIPTION}` - Brief summary

**3. Act on feedback:**
- Fix Critical issues immediately
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if reviewer is wrong (with reasoning)

## Laravel-Specific Review Focus

When requesting review, highlight these areas:

| Area | What to Review |
|------|----------------|
| Models | Rich models, proper casts, relationships, scopes |
| N+1 Queries | Eager loading in all queries |
| Validation | Form Requests or Livewire rules |
| Authorization | Policies applied |
| Actions | Business logic isolation |
| Tests | Pest conventions, factories, coverage |
| Frontend | Livewire SFC, Flux UI, loading states |

## Example

```
[Just completed Task 2: Create Widget CRUD]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch regnt:code-reviewer subagent]
  WHAT_WAS_IMPLEMENTED: Widget model, migration, CRUD Livewire components, Pest tests
  PLAN_OR_REQUIREMENTS: Task 2 from docs/plans/widget-feature.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: Full Widget CRUD with Livewire SFC + Flux UI

[Subagent returns]:
  Strengths: Clean architecture, proper use of Actions, good test coverage
  Issues:
    Important: Missing eager loading on widget list (N+1)
    Minor: Could use WidgetData DTO instead of array
  Assessment: Ready to proceed after N+1 fix

You: [Fix eager loading]
[Continue to Task 3]
```

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task
- Catch issues before they compound

**Executing Plans:**
- Review after each batch (3 tasks)

**Dev Workflow:**
- Review before delivery phase

**Ralph Loop:**
- Auto-review at end of each story (optional)

## Simplification Pass

After code review fixes, optionally dispatch `laravel-simplifier` agent to:
- Simplify complex code
- Ensure consistency with existing patterns
- Remove unnecessary complexity

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
