# Session State System Improvements — Implementation Plan

## Overview

Evolve cursor-session-state-template from "session continuity" to "project continuity" — maintaining useful context across weeks and months, not just between chat sessions.

### Goals
- Faster session starts with pre-loaded context (branch state, mid-flight work)
- Fewer repeated mistakes (failure patterns and tech debt visible)
- Cleaner handoffs (to future-you, collaborators, or different AI tools)
- Sustainable for long projects (archival prevents bloat)
- Multi-agent safe (concurrent sessions don't corrupt state)
- Tool-agnostic (works with Cursor, Claude Code, HumanLayer, etc.)

### Non-Goals
- Auto-discovery of project structure (keep manual curation)
- Real-time test result syncing (use CI for that)
- Tool-specific integrations in core template

---

## Architecture Decision: Split-File Structure

**Current:** Single `PROJECT_STATE.md` for everything

**Proposed:** Two-file system separating hot and cold state

```
your-project/
├── .cursor/rules/session-state.mdc    # AI behavior rules (updated)
├── PROJECT_STATE.md                   # HOT: Changes every session
├── PROJECT_CONTEXT.md                 # COLD: Changes weekly/monthly
├── PROJECT_ARCHIVE.md                 # Overflow storage (created as needed)
└── AGENTS.md                          # Architectural guide (unchanged)
```

### Why Split?

| Aspect | PROJECT_STATE.md (Hot) | PROJECT_CONTEXT.md (Cold) |
|--------|------------------------|---------------------------|
| Update frequency | Every session | Weekly or when things change |
| Git noise | Acceptable | Minimal |
| Conflict risk | Higher (mitigated by protocol) | Lower |
| Line count target | <80 lines | <120 lines |
| Purpose | "What's happening now?" | "What do I need to know?" |

---

## Phase 1: Core Structure Improvements

### 1.1 Add Session Handoff Section

**File:** `PROJECT_STATE.md`

**Location:** Between "Recent Changes" and "Next Steps"

**Purpose:** Capture mid-flight context that would otherwise be lost when closing a session.

```markdown
## Session Handoff

<!-- Populated at END of session. Cleared at START of next session after reading. -->

**Mid-Flight Work:**
- [What was in progress when session ended]
- [Files open/modified but not committed]

**Unresolved Questions:**
- [Questions that came up but weren't answered]

**Context for Next Session:**
- [Anything the next session needs to know immediately]
```

**Rules to add to session-state.mdc:**
```markdown
## Session Handoff Protocol

**Before ending ANY session:**
1. Check if work is incomplete or in-progress
2. If yes, populate `## Session Handoff` with:
   - What you were doing
   - What files are in a modified state
   - Any context that would be lost
3. This section is READ then CLEARED at the start of the next session

**At start of session:**
1. Read Session Handoff section
2. Acknowledge any mid-flight work: "Resuming: [description]"
3. Clear the section after incorporating context
```

---

### 1.2 Add Branch Context to Meta

**File:** `PROJECT_STATE.md`

**Location:** In the `## Meta` section

**Keep it simple** — just enough to know where you are:

```markdown
## Meta

- **Last Updated:** [YYYY-MM-DD HH:MM]
- **Last Task:** [Brief description]
- **Current Phase:** [e.g., "MVP Development"]
- **Current Branch:** [branch-name] (base: [main/master])
- **Project:** [Project name]
- **Stack:** [e.g., "Next.js 14, TypeScript, Supabase"]
```

**Rules to add:**
```markdown
## Branch Context

- Update `Current Branch` in Meta when switching branches
- Include base branch for feature branches
- If branch has open PR, note PR number in Session Handoff (not Meta)
```

---

### 1.3 Create PROJECT_CONTEXT.md (Cold State)

**New file** for slower-changing project context.

```markdown
# Project Context

<!--
AI INSTRUCTIONS: This file contains project-level context that changes infrequently.
- Read this when starting work on a new feature or after extended break
- Update when you discover patterns, accumulate debt, or learn lessons
- Not updated every session—only when content changes
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
```

---

### 1.4 Slim Down PROJECT_STATE.md

**Remove from PROJECT_STATE.md** (moved to PROJECT_CONTEXT.md):
- Lessons Learned
- Decisions Log
- External Dependencies
- File Relationships
- Stable Checkpoints

**Keep in PROJECT_STATE.md:**
- Meta (with branch context)
- Active Context
- Current Task Breakdown
- Recent Changes
- **Session Handoff** (new)
- Next Steps
- Quick Commands

**Target:** Under 80 lines for active projects.

---

## Phase 2: Multi-Agent Safety

### 2.1 Conflict Prevention Protocol

**Problem:** Two AI sessions (different windows, different tools) could simultaneously edit state files, causing conflicts or data loss.

**Solution:** Ownership model with lock indicators.

**Add to PROJECT_STATE.md Meta section:**
```markdown
## Meta

- **Last Updated:** 2024-12-16 14:30
- **Active Session:** [tool-name] on [branch] | None
- **Last Task:** [description]
...
```

**Rules to add to session-state.mdc:**
```markdown
## Multi-Agent Safety Protocol

**At session START:**
1. Check `Active Session` field in Meta
2. If another session is active:
   - If same branch: ASK user "Another session may be active. Continue anyway?"
   - If different branch: Proceed (separate workstreams)
3. Set `Active Session` to your tool/context identifier

**At session END:**
1. Clear `Active Session` (set to "None")
2. This happens BEFORE populating Session Handoff

**If you detect conflicts:**
1. Do NOT overwrite—ask user which version to keep
2. State files use last-write-wins; be conservative

**Identifier format:** `[Tool] on [branch]`
- Examples: "Cursor on feature/auth", "Claude Code on main", "HumanLayer on fix/bug-123"
```

---

### 2.2 Atomic Updates

**Problem:** Partial writes during crashes could corrupt state.

**Solution:** Update protocol that minimizes corruption risk.

**Rules to add:**
```markdown
## Atomic Update Protocol

When updating state files:
1. Read current content
2. Make ALL changes in memory
3. Write complete file in single operation
4. Verify write succeeded before proceeding

Never:
- Make multiple sequential small edits
- Leave file in intermediate state
- Write partial sections
```

---

## Phase 3: Initial Population Protocol

### 3.1 First-Time Setup Detection

**Add to session-state.mdc:**
```markdown
## First-Time Setup Protocol

**Detect empty/template state:**
If PROJECT_STATE.md contains only template placeholders (e.g., `[YYYY-MM-DD]`, `[Project name]`):

1. Inform user: "I see this is a fresh project state. Let me help you populate it."
2. Ask for essentials:
   - Project name and brief description
   - Current development phase
   - Tech stack
   - What you're currently working on
3. Populate Meta and Active Context from responses
4. Leave other sections with template structure

**Do NOT:**
- Scan entire codebase to auto-populate
- Guess at project structure
- Fill in placeholder data
```

---

### 3.2 Migration Guide for Existing Projects

**Add to README.md** and create `docs/MIGRATION.md`:

```markdown
# Migrating Existing Projects

If you're adding session-state to an existing project:

## Quick Start (5 minutes)

1. Copy template files to your project
2. Fill in `## Meta` section with current project info
3. In `## Active Context`, describe what you're currently working on
4. Add your most-used commands to `## Quick Commands`
5. Start using—the AI will build up the rest organically

## Thorough Setup (15 minutes)

After Quick Start, also populate:

### PROJECT_STATE.md
- `## Current Task Breakdown`: If mid-feature, list remaining subtasks
- `## Recent Changes`: Last 5-10 things you remember doing
- `## Next Steps`: Your mental TODO list

### PROJECT_CONTEXT.md
- `## Technical Debt`: Known shortcuts you've taken
- `## Lessons Learned`: Gotchas you've discovered
- `## Decisions Log`: Key architectural choices and why
- `## Stable Checkpoints`: Last known-good commit

## Adoption Tips

- Don't try to fill everything perfectly upfront
- The AI will prompt you to add context as gaps become apparent
- After 3-5 sessions, review and clean up any accumulated cruft
```

---

### 3.3 Incremental Population Prompts

**Add to session-state.mdc:**
```markdown
## Incremental Population

When you notice a section is empty or sparse during normal work:

**Do:**
- Populate it naturally as relevant information emerges
- Example: After making a decision, add to Decisions Log
- Example: After discovering a gotcha, add to Lessons Learned

**Don't:**
- Stop work to exhaustively fill empty sections
- Ask user to populate sections unrelated to current task
- Auto-generate content by scanning codebase

**Gentle prompts (use sparingly, max 1 per session):**
- "I noticed [section] is empty. Want me to add [specific item] based on what we just did?"
- Only prompt if the addition is directly relevant to completed work
```

---

## Phase 4: Validation & Archival

### 4.1 Strengthen Validation Protocol

**Replace** the vague "every 3-5 tasks" with explicit triggers.

**Add to session-state.mdc:**
```markdown
## State Validation Triggers

**Validate state file accuracy when:**
1. Starting work on a NEW feature (not continuation)
2. Switching branches
3. After any file deletion or major rename
4. After 15+ tool calls without a state update
5. When something feels "off" or context seems stale
6. After returning from extended break (>24 hours)

**Validation checklist:**
- [ ] Does `Current Branch` match actual branch?
- [ ] Does `Current Task Breakdown` reflect actual progress?
- [ ] Are `Next Steps` still the right priorities?
- [ ] Is `Active Session` correctly set?

**If discrepancies found:**
1. Update state BEFORE continuing work
2. Note significant corrections in Session Handoff
```

---

### 4.2 Archival Protocol

**Trigger:** When PROJECT_STATE.md exceeds ~100 lines OR during monthly maintenance.

**Create PROJECT_ARCHIVE.md template:**
```markdown
# Project Archive

<!--
Historical state entries moved from PROJECT_STATE.md
Organized by month. Searchable reference, not active state.
-->

## Archive: [YYYY-MM]

### Completed Features
- [Feature]: [Brief summary of what was built]

### Archived Recent Changes
- [YYYY-MM-DD] [Description]
...

### Archived Task Breakdowns
- [Feature]: Completed [YYYY-MM-DD]
  - Summary of what was involved

---

## Archive: [Previous Month]
...
```

**Rules to add:**
```markdown
## Archival Protocol

**When to archive:**
- PROJECT_STATE.md exceeds 100 lines
- Monthly (first session of new month)
- When completing a major feature/milestone

**What to archive:**
- Recent Changes older than 2 weeks (keep last 10)
- Completed Task Breakdowns (move summary to archive)
- Resolved blockers

**How to archive:**
1. Create/update PROJECT_ARCHIVE.md
2. Move old entries under month header
3. Keep PROJECT_STATE.md focused on current work

**What stays in PROJECT_CONTEXT.md (never archived):**
- Technical Debt (until resolved)
- Failure Patterns (until obsolete)
- Lessons Learned (cumulative knowledge)
- Decisions Log (permanent record)
```

---

## Phase 5: Documentation & Examples

### 5.1 Update Example Files

**Update examples/PROJECT_STATE_EXAMPLE.md:**
- Show the slimmed-down structure
- Include Session Handoff populated
- Include Branch Context in Meta
- Show Active Session field

**Create examples/PROJECT_CONTEXT_EXAMPLE.md:**
- Show Technical Debt with realistic entries
- Show Failure Patterns
- Show enhanced Stable Checkpoints with recovery notes

**Create examples/PROJECT_ARCHIVE_EXAMPLE.md:**
- Show monthly archive structure
- Show how completed features are summarized

---

### 5.2 Update README.md

- Add PROJECT_CONTEXT.md to file overview table
- Update sections table (what's in each file)
- Add "Multi-Agent Usage" section
- Add "Migrating Existing Projects" section
- Update troubleshooting for new features

---

### 5.3 Update session-state.mdc

Consolidate all new rules:
- Session Handoff Protocol
- Branch Context updates
- Multi-Agent Safety Protocol
- First-Time Setup Protocol
- Incremental Population
- Validation Triggers
- Archival Protocol

---

## Implementation Checklist

### Phase 1: Core Structure
- [x] Add Session Handoff section to PROJECT_STATE.md
- [x] Add Branch Context to Meta section
- [x] Create PROJECT_CONTEXT.md template
- [x] Slim down PROJECT_STATE.md (move sections to CONTEXT)
- [x] Update session-state.mdc with new section rules

### Phase 2: Multi-Agent Safety
- [x] Add Active Session field to Meta
- [x] Add Multi-Agent Safety Protocol to rules
- [x] Add Atomic Update Protocol to rules

### Phase 3: Initial Population
- [x] Add First-Time Setup Protocol to rules
- [x] Create docs/MIGRATION.md
- [x] Add Incremental Population guidance to rules

### Phase 4: Validation & Archival
- [x] Replace "every 3-5 tasks" with explicit triggers
- [x] Create PROJECT_ARCHIVE.md template
- [x] Add Archival Protocol to rules

### Phase 5: Documentation
- [x] Update examples/PROJECT_STATE_EXAMPLE.md
- [x] Create examples/PROJECT_CONTEXT_EXAMPLE.md
- [x] Create examples/PROJECT_ARCHIVE_EXAMPLE.md
- [x] Update README.md with all changes
- [x] Consolidate session-state.mdc updates

### Validation
- [ ] Test with fresh Cursor session
- [ ] Test with Claude Code session
- [ ] Verify multi-agent detection works
- [ ] Verify archival flow works
- [ ] All files under line count targets

---

## File Change Summary

| File | Changes |
|------|---------|
| `PROJECT_STATE.md` | Add Session Handoff, Branch Context in Meta, Active Session field; remove sections moved to CONTEXT |
| `PROJECT_CONTEXT.md` | **NEW** — Technical Debt, Failure Patterns, Stable Checkpoints, Lessons Learned, Decisions Log, External Dependencies, File Relationships |
| `PROJECT_ARCHIVE.md` | **NEW** — Template for archived state |
| `.cursor/rules/session-state.mdc` | Add all new protocols (handoff, multi-agent, validation triggers, archival, initial population) |
| `README.md` | Update file overview, sections table, add new sections |
| `docs/MIGRATION.md` | **NEW** — Guide for existing projects |
| `examples/PROJECT_STATE_EXAMPLE.md` | Update with new structure |
| `examples/PROJECT_CONTEXT_EXAMPLE.md` | **NEW** — Example populated context |
| `examples/PROJECT_ARCHIVE_EXAMPLE.md` | **NEW** — Example archive |

---

## Execution Recommendation

**Session 1:** Phase 1 (Core Structure)
- Highest immediate value
- Creates foundation for other phases

**Session 2:** Phase 2 (Multi-Agent Safety)
- Important if using multiple tools
- Can defer if single-tool workflow

**Session 3:** Phase 3 (Initial Population)
- Important for template users
- Makes adoption smoother

**Session 4:** Phase 4 (Validation & Archival)
- Can wait until state files actually get long
- Implement proactively or reactively

**Session 5:** Phase 5 (Documentation)
- Polish before sharing/publishing
- Can be done incrementally alongside other phases
