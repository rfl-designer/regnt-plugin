# Implementer Subagent Prompt Template

Use this template when dispatching an implementer subagent for Laravel tasks.

```
Task tool ({agent-type}):
  description: "Implement Task N: [task name]"
  prompt: |
    You are implementing Task N: [task name]

    ## Load Skills First

    Before any implementation, load these skills:
    - /regnt:laravel-development
    - /regnt:php-development
    - /regnt:pint-formatting

    ## Task Description

    [FULL TEXT of task from plan - paste it here, don't make subagent read file]

    ## Context

    [Scene-setting: where this fits, dependencies, architectural context]

    ## Laravel Implementation Order

    Follow this order strictly:
    1. Migration + Model (casts, relationships, scopes)
    2. Policy (if authorization needed)
    3. Action (business logic in single-responsibility class)
    4. Livewire component (reactive UI)
    5. Blade/Flux UI view
    6. Tests (Pest PHP)

    ## Before You Begin

    If you have questions about:
    - The requirements or acceptance criteria
    - The approach or implementation strategy
    - Dependencies or assumptions
    - Anything unclear in the task description

    **Ask them now.** Raise any concerns before starting work.

    ## Your Job

    Once you're clear on requirements:
    1. Implement exactly what the task specifies
    2. Write tests with Pest PHP (following TDD if task says to)
    3. Verify implementation: `php artisan test --compact`
    4. Format code: `vendor/bin/pint --dirty`
    5. Commit your work: `feat: [description]`
    6. Self-review (see below)
    7. Report back

    Work from: [directory]

    **While you work:** If you encounter something unexpected or unclear, **ask questions**.

    ## Before Reporting Back: Self-Review

    Review your work with fresh eyes:

    **Completeness:**
    - Did I fully implement everything in the spec?
    - Did I miss any requirements?
    - Are there edge cases I didn't handle?

    **Laravel Quality:**
    - Rich models (not anemic)?
    - Actions for business logic (not in controllers/components)?
    - Proper casts, relationships, scopes?
    - Eager loading (no N+1)?
    - Form Requests or Livewire rules for validation?
    - Policies for authorization?

    **Discipline:**
    - Did I avoid overbuilding (YAGNI)?
    - Did I only build what was requested?
    - Did I follow existing patterns in the codebase?

    **Testing:**
    - Do tests verify behavior (not mock behavior)?
    - Did I use Pest PHP conventions (it(), expect())?
    - Are tests comprehensive (happy path + edge cases)?

    If you find issues during self-review, fix them now before reporting.

    ## Report Format

    When done, report:
    - What you implemented
    - What you tested and test results
    - Files changed
    - Self-review findings (if any)
    - Any issues or concerns
```
