---
name: using-regnt
description: Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions
---

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**Skill prefix:** All regnt skills use the `regnt:` prefix (e.g., `regnt:brainstorming`, `regnt:test-driven-development`).

# Using Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Available Skills

### Process Skills (invoke FIRST)
| Skill | When |
|-------|------|
| `regnt:brainstorming` | Before any creative work — features, components, functionality changes |
| `regnt:systematic-debugging` | Any bug, test failure, or unexpected behavior |
| `regnt:writing-plans` | After design approval, before implementation |
| `regnt:laravel-workflow` | End-to-end workflow from idea to delivery |

### Execution Skills (invoke SECOND)
| Skill | When |
|-------|------|
| `regnt:executing-plans` | Running plan in separate session with review checkpoints |
| `regnt:subagent-driven-development` | Executing plans with independent tasks in same session |
| `regnt:dev-workflow` | Implementing a single SoloBoard task |
| `regnt:ralph-loop` | Autonomous feature implementation loop |

### Discipline Skills (invoke ALWAYS)
| Skill | When |
|-------|------|
| `regnt:test-driven-development` | Implementing ANY feature or bugfix |
| `regnt:verification-before-completion` | Before ANY completion claim |
| `regnt:requesting-code-review` | After task completion, before merging |
| `regnt:receiving-code-review` | Reviewing feedback before implementing |

### Laravel Skills (invoke for implementation)
| Skill | When |
|-------|------|
| `regnt:laravel-development` | Laravel 12 conventions, controllers, models, migrations |
| `regnt:php-development` | PHP 8.x patterns, typing, enums, constructors |
| `regnt:pint-formatting` | Code formatting with Laravel Pint |
| `regnt:boost-tools` | Debug, DB, Artisan, docs |

### Planning Skills
| Skill | When |
|-------|------|
| `regnt:write-prd` | Creating PRDs (Product Requirements Documents) |
| `regnt:prd-to-tasks` | Breaking PRD into vertical slice tasks |

### Integration Skills
| Skill | When |
|-------|------|
| `regnt:using-git-worktrees` | Feature work needing isolation |
| `regnt:finishing-a-development-branch` | Implementation complete, all tests pass |

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (laravel-development, php-development) - these guide execution
3. **SoloBoard integration** (dev-workflow, ralph-loop) - these manage task lifecycle

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.
"Implement task #42" → dev-workflow first, then Laravel skills.

## Skill Types

**Rigid** (TDD, debugging, verification): Follow exactly. Don't adapt away discipline.

**Flexible** (brainstorming, patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
