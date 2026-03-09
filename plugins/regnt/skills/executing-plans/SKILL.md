---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches following Laravel implementation order, report for review between batches.

**Core principle:** Batch execution with checkpoints for review.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan

1. Read plan file
2. Review critically — identify any questions or concerns about the plan
3. Load Laravel skills: `/regnt:laravel-development`, `/regnt:php-development`, `/regnt:pint-formatting`
4. If concerns: Raise them before starting
5. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Batch

**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. If task has SoloBoard `task_id`: `start-timer task_id={ID}` and `update-task task_id={ID} status=doing`
3. Follow each step exactly (plan has bite-sized steps)
4. Follow Laravel implementation order: Migration+Model → Policy → Action → Livewire → UI → Tests
5. Run verifications as specified
6. Commit incrementally: `feat: [component description]`
7. Mark as completed
8. If task has SoloBoard `task_id`: `stop-timer task_id={ID}` and `update-task task_id={ID} status=done`

### Step 3: Quality Gate

After each batch, run:

```bash
php artisan test --compact    # All tests passing
vendor/bin/pint --dirty       # Code formatted
```

<HARD-GATE>
Do NOT proceed to next batch if tests fail. Fix first.
</HARD-GATE>

### Step 4: Report

When batch complete:
- Show what was implemented
- Show verification output (test results, pint output)
- Say: "Ready for feedback."

### Step 5: Continue

Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 6: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use `regnt:finishing-a-development-branch`
- Follow that skill to verify tests, present options, execute choice

## Agent Delegation

During execution, delegate to specialized agents when appropriate:

| Task Type | Agent |
|-----------|-------|
| Models, Migrations, Enums | `regnt:laravel-core` |
| Livewire, Flux UI, Blade | `regnt:frontend-laravel` |
| Tests with Pest | `regnt:pest-tester` |
| AI SDK, MCP | `regnt:ai-workflows` |
| Code simplification | `laravel-simplifier` |

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Follow Laravel implementation order
- Don't skip verifications (`php artisan test`, `vendor/bin/pint`)
- Between batches: just report and wait
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent
- Use SoloBoard timers when tasks are tracked

## Integration

**Required workflow skills:**
- **regnt:using-git-worktrees** - Set up isolated workspace before starting
- **regnt:writing-plans** - Creates the plan this skill executes
- **regnt:finishing-a-development-branch** - Complete development after all tasks
- **regnt:verification-before-completion** - Verify before any completion claim
