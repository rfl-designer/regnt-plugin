# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable, follows Laravel conventions)

**Only dispatch after spec compliance review passes.**

```
Task tool (regnt:code-reviewer):
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing the code quality of a Laravel implementation.

    WHAT_WAS_IMPLEMENTED: [from implementer's report]
    PLAN_OR_REQUIREMENTS: Task N from [plan-file]
    BASE_SHA: [commit before task]
    HEAD_SHA: [current commit]
    DESCRIPTION: [task summary]

    ## Laravel Quality Checklist

    Check these specifically:

    **Models:**
    - Rich models with casts, scopes, relationships (not anemic)
    - No repositories pattern (use Eloquent directly)
    - Proper use of fillable/guarded

    **Architecture:**
    - Business logic in Actions (not controllers or Livewire components)
    - Single Responsibility Principle
    - Proper use of DTOs at boundaries
    - Form Requests or Livewire rules for validation
    - Policies for authorization

    **Performance:**
    - Eager loading (no N+1 queries)
    - Proper database indexes
    - Efficient queries

    **Frontend:**
    - Livewire SFC pattern
    - Flux UI components where available
    - wire:loading states
    - Flash messages for feedback

    **Testing:**
    - Pest PHP conventions (it(), expect())
    - Tests verify behavior, not implementation
    - Factories for test data
    - Feature tests for HTTP + Livewire
    - Unit tests for Actions

    **Code Style:**
    - Pint formatted
    - PHP 8.x features (enums, readonly, named args)
    - Conventional commits

    Report: Strengths, Issues (Critical/Important/Minor), Assessment
```

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
