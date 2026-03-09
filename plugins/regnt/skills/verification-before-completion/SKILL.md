---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Laravel Verification Commands

| Claim | Command | Expected |
|-------|---------|----------|
| Tests pass | `php artisan test --compact` | 0 failures |
| Code formatted | `vendor/bin/pint --dirty` | 0 files changed |
| Migrations work | `php artisan migrate:fresh --seed` | No errors |
| Routes correct | `php artisan route:list` | Expected routes present |
| No N+1 | Check query log in test | No duplicate queries |
| Build succeeds | `npm run build` (if frontend) | exit 0 |

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | `php artisan test` output: 0 failures | Previous run, "should pass" |
| Pint clean | `vendor/bin/pint --dirty` output: 0 changes | "I ran pint earlier" |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |
| SoloBoard updated | `get-task` confirms status | "I called update-task" |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!")
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Pint passed" | Pint ≠ tests |
| "Agent said success" | Verify independently |
| "Partial check is enough" | Partial proves nothing |

## Key Patterns

**Tests:**
```
✅ [php artisan test --compact] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Formatting:**
```
✅ [vendor/bin/pint --dirty] [See: 0 files] "Code formatted"
❌ "I formatted the files"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (fail) → Implement → Run (pass) → Verify red-green cycle
❌ "I've written a regression test" (without red-green verification)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, task complete"
```

**SoloBoard status:**
```
✅ update-task → get-task → confirm status changed
❌ "I updated the task"
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- Committing, PR creation, task completion
- Moving to next task
- Updating SoloBoard task status to `done`
- Stopping timer
- Delegating to agents

## The Bottom Line

**No shortcuts for verification.**

Run the command. Read the output. THEN claim the result.

This is non-negotiable.
