# Project Context

<!--
AI INSTRUCTIONS: This file contains project-level context that changes infrequently.
- Read this when starting work on a new feature or after extended break
- Update when you discover patterns, accumulate debt, or learn lessons
- Not updated every session—only when content changes
- For current session state, see PROJECT_STATE.md
-->

## Technical Debt

<!-- Shortcuts taken that need addressing. Review before major refactors. -->

| Date Added | Location | Description | Priority |
|------------|----------|-------------|----------|
| YYYY-MM-DD | `path/to/file.ts` | [What shortcut was taken and why] | Low/Med/High |

## Failure Patterns

<!-- Recurring issues with known workarounds. Check before debugging. -->

| Pattern | Trigger | Resolution |
|---------|---------|------------|
| [Name] | [What causes it] | [How to fix/avoid] |

## Stable Checkpoints

<!-- Git commits representing known-good states for rollback -->

| Commit | Date | Description | Recovery Notes |
|--------|------|-------------|----------------|
| `abc123` | YYYY-MM-DD | [What's working] | [How to recover, what breaks if you go further] |

## Lessons Learned

<!-- Gotchas, workarounds, and discoveries worth remembering -->

- [YYYY-MM-DD] [Discovery and how to handle it]

## Decisions Log

<!-- Key architectural/design decisions with rationale -->

| Date | Decision | Rationale | Alternatives Considered |
|------|----------|-----------|------------------------|
| YYYY-MM-DD | [What was decided] | [Why] | [What else was considered] |

## External Dependencies

<!-- APIs, services, and their constraints -->

- **[Service Name]:** [Key details—endpoints, rate limits, quirks]

## File Relationships

<!-- Files that typically change together -->

- **[Feature/Component]:** `file1.ts` ↔ `file2.ts` ↔ `file3.ts`

---

<!--
MAINTENANCE NOTES:
- Keep this file under 120 lines
- Technical Debt items stay until resolved (then remove)
- Failure Patterns stay until obsolete
- Lessons Learned and Decisions Log are cumulative (never archived)
-->
