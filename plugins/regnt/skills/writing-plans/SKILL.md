---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans for Laravel projects. Document everything: which files to touch, code, testing, how to verify. Give the whole plan as bite-sized tasks following Laravel implementation order. DRY. YAGNI. TDD. Frequent commits.

Assume the implementer knows Laravel but not the specifics of this codebase.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Run Pint to format" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use regnt:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** Laravel 12, Livewire 4, Flux UI, Pest PHP, Pint

**Laravel Order:** Migration+Model → Policy → Action → Livewire → UI → Tests

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `app/Models/Widget.php`
- Create: `database/migrations/YYYY_MM_DD_create_widgets_table.php`
- Modify: `app/Livewire/WidgetList.php:45-60`
- Test: `tests/Feature/WidgetTest.php`

**Step 1: Write the failing test**

```php
it('creates a widget with valid data', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->post('/widgets', [
            'name' => 'Test Widget',
            'type' => 'basic',
        ]);

    $response->assertRedirect('/widgets');
    expect(Widget::count())->toBe(1);
});
```

**Step 2: Run test to verify it fails**

Run: `php artisan test --filter="creates a widget" --compact`
Expected: FAIL with "Class 'Widget' not found"

**Step 3: Write migration + model**

```php
// database/migrations/YYYY_MM_DD_create_widgets_table.php
return new class extends Migration {
    public function up(): void
    {
        Schema::create('widgets', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('type');
            $table->foreignId('user_id')->constrained();
            $table->timestamps();
        });
    }
};

// app/Models/Widget.php
class Widget extends Model
{
    protected $fillable = ['name', 'type', 'user_id'];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

**Step 4: Implement action to pass test**

```php
// app/Actions/CreateWidgetAction.php
class CreateWidgetAction
{
    public function execute(User $user, array $data): Widget
    {
        return $user->widgets()->create($data);
    }
}
```

**Step 5: Run test to verify it passes**

Run: `php artisan test --filter="creates a widget" --compact`
Expected: PASS

**Step 6: Format and commit**

```bash
vendor/bin/pint --dirty
git add -A && git commit -m "feat: add widget model, migration, and creation action"
```
````

## Laravel Implementation Order

**ALWAYS follow this order in plans:**

1. **Migration + Model** — Schema, casts, relationships, scopes → delegate to `regnt:laravel-core` agent
2. **Policy** — Authorization rules (if needed) → delegate to `regnt:laravel-core` agent
3. **Action** — Business logic in single-responsibility actions → use `regnt:php-development` skill
4. **Livewire** — Reactive components with SFC → delegate to `regnt:frontend-laravel` agent
5. **UI** — Views with Flux UI → delegate to `regnt:frontend-laravel` agent
6. **Tests** — Feature and unit tests with Pest → delegate to `regnt:pest-tester` agent

## Agent Delegation in Plans

When writing plan tasks, indicate which agent should handle each:

| Task Type | Agent | Skills |
|-----------|-------|--------|
| Models, Migrations, Enums, DTOs | `regnt:laravel-core` | `regnt:laravel-development` |
| Business Logic, Actions | general-purpose | `regnt:php-development` |
| Livewire, Flux UI, Blade | `regnt:frontend-laravel` | `regnt:laravel-development` |
| Tests | `regnt:pest-tester` | `regnt:test-driven-development` |
| AI SDK, MCP Integration | `regnt:ai-workflows` | `regnt:laravel-development` |

## Quality Checks in Plans

**Every plan MUST include quality steps:**

```bash
php artisan test --compact          # All tests passing
vendor/bin/pint --dirty             # Code formatted
```

## Remember
- Exact file paths always (Laravel convention paths)
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference agents for delegation
- DRY, YAGNI, TDD, frequent commits
- Follow Laravel implementation order

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use `regnt:subagent-driven-development`
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session
- **REQUIRED SUB-SKILL:** New session uses `regnt:executing-plans`

## SoloBoard Integration

If working on a SoloBoard feature, optionally create tasks from plan:

```
create-task title="{task name}" project_slug={slug} session_prompt="{task description}"
add-task-to-feature feature_id={ID} task_id={task_ID}
```
