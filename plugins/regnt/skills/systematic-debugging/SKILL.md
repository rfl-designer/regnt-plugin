---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures (`php artisan test` errors)
- Bugs in production
- Unexpected behavior
- N+1 query problems
- Migration failures
- Livewire component issues
- Queue/job failures

**Use this ESPECIALLY when:**
- Under time pressure
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Laravel stack traces contain the exact solution
   - Check `storage/logs/laravel.log`
   - Read Pest test output completely
   - Note file paths, line numbers, error types
   - Check `php artisan` output for migration/config errors

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - Write a failing test that reproduces it
   - If test failure: isolate with `--filter`
   ```bash
   php artisan test --filter="test name" --compact
   ```

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New migrations, config changes, package updates
   - `php artisan config:clear && php artisan cache:clear`

4. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple layers (Request → Middleware → Controller → Action → Model → DB):**

   ```bash
   # Check Laravel logs
   tail -50 storage/logs/laravel.log

   # Check database state
   php artisan tinker --execute="Model::where(...)->get()"

   # Check routes
   php artisan route:list --name=widget

   # Check config
   php artisan config:show app

   # Check queue
   php artisan queue:monitor
   ```

5. **Trace Data Flow**

   - Where does bad value originate?
   - Trace through: Request → Validation → Action → Model → DB
   - Use `dd()` or `ray()` at each layer
   - Fix at source, not at symptom

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - How do other models/components/actions handle this?

2. **Compare Against References**
   - Check Laravel docs for the feature
   - Check existing tests for the pattern
   - Use `regnt:boost-tools` to search docs

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What other components does this need?
   - Config, environment, services?
   - Missing migrations? `php artisan migrate:status`

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Use Pest PHP to reproduce the bug
   ```php
   it('does not allow duplicate widget names per user', function () {
       $user = User::factory()->create();
       Widget::factory()->for($user)->create(['name' => 'Duplicate']);

       $this->actingAs($user)
           ->post('/widgets', ['name' => 'Duplicate'])
           ->assertSessionHasErrors('name');
   });
   ```
   - MUST have before fixing
   - Use `regnt:test-driven-development` skill

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements

3. **Verify Fix**
   ```bash
   php artisan test --compact    # All tests pass
   vendor/bin/pint --dirty       # Code formatted
   ```

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze
   - **If >= 3: STOP and question the architecture**
   - Discuss with your human partner before attempting more fixes

5. **If 3+ Fixes Failed: Question Architecture**

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Should we refactor architecture vs. continue fixing symptoms?
   - **Discuss with your human partner before attempting more fixes**

## Laravel-Specific Debug Tools

| Tool | When |
|------|------|
| `storage/logs/laravel.log` | Any error — check here first |
| `php artisan tinker` | Inspect models, test queries |
| `php artisan test --filter="X"` | Isolate specific test |
| `php artisan route:list` | Route issues |
| `php artisan migrate:status` | Migration issues |
| `php artisan config:clear` | Config caching issues |
| `php artisan cache:clear` | Cache issues |
| `php artisan queue:failed` | Job failures |
| `dd()` / `ray()` | Data flow tracing |
| `DB::enableQueryLog()` | N+1 detection |
| `/regnt:boost-tools` | Search docs, inspect DB |

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (when already tried 2+)**

**ALL of these mean: STOP. Return to Phase 1.**

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read logs, reproduce, check changes | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

## Related Skills

- **regnt:test-driven-development** - For creating failing test case (Phase 4)
- **regnt:verification-before-completion** - Verify fix worked before claiming success
- **regnt:boost-tools** - Search Laravel docs, inspect database
