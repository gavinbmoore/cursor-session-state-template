# Migrating Existing Projects

If you're adding session-state to an existing project, follow this guide.

## Quick Start (5 minutes)

1. Copy template files to your project:
   ```bash
   # Copy core files
   cp PROJECT_STATE.md /path/to/your/project/
   cp PROJECT_CONTEXT.md /path/to/your/project/

   # Copy rules
   mkdir -p /path/to/your/project/.cursor/rules
   cp .cursor/rules/session-state.mdc /path/to/your/project/.cursor/rules/
   ```

2. Fill in `PROJECT_STATE.md` → `## Meta` section:
   - Project name
   - Current branch
   - Tech stack
   - Current phase

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
- `## External Dependencies`: APIs and services you're using

## Adoption Tips

### Don't over-engineer the setup
- You don't need to fill everything perfectly upfront
- The AI will prompt you to add context as gaps become apparent
- After 3-5 sessions, review and clean up any accumulated cruft

### Let sections grow organically
- Lessons Learned will accumulate as you discover gotchas
- Decisions Log will grow as you make architectural choices
- Technical Debt will populate as you take shortcuts

### Review periodically
- After 3-5 sessions, scan files for accuracy
- Archive old Recent Changes if the list gets long
- Remove resolved Technical Debt items

## Common Scenarios

### Adding to a personal project
1. Quick Start is usually enough
2. Focus on `## Active Context` and `## Next Steps`
3. Let other sections grow as needed

### Adding to a team project
1. Do Thorough Setup
2. Populate `## Decisions Log` with existing architectural decisions
3. Document known gotchas in `## Lessons Learned`
4. Consider adding `PROJECT_STATE.md` to `.gitignore` if team members use different AI tools

### Adding mid-feature
1. Describe current feature in `## Active Context`
2. Create `## Current Task Breakdown` with remaining work
3. Note any blockers or open questions in `## Session Handoff`

## File Placement

```
your-project/
├── .cursor/
│   └── rules/
│       └── session-state.mdc    # AI behavior rules
├── PROJECT_STATE.md             # Hot state (gitignore optional)
├── PROJECT_CONTEXT.md           # Cold state (usually committed)
├── PROJECT_ARCHIVE.md           # Created when needed
└── ... your project files
```

### Git considerations

**Option A: Commit everything**
- Good for: Solo projects, wanting history of decisions
- All state files tracked in git

**Option B: Ignore hot state**
- Good for: Teams, frequently changing state
- Add to `.gitignore`:
  ```
  PROJECT_STATE.md
  PROJECT_ARCHIVE.md
  ```
- Keep `PROJECT_CONTEXT.md` committed (decisions, lessons are team knowledge)

**Option C: Ignore all state**
- Good for: Using different AI tools per developer
- Add to `.gitignore`:
  ```
  PROJECT_STATE.md
  PROJECT_CONTEXT.md
  PROJECT_ARCHIVE.md
  ```
