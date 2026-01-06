# Cursor Session State Template

A lightweight context persistence system for AI-assisted development that maintains project continuity across sessions and tools.

Works with [Cursor IDE](https://cursor.com), [Claude Code](https://claude.ai), [HumanLayer](https://humanlayer.dev), and other AI development tools.

## The Problem

When starting a new AI chat session, you often need to say something like:

> "Look over the codebase to understand where we're at..."

This fills 40-50% of your context window just to get oriented. Knowledge from previous sessions—decisions made, gotchas discovered, current progress—gets lost.

**Additional pain points:**
- Mid-flight work context evaporates between sessions
- Technical debt accumulates invisibly
- Multiple AI tools/windows can conflict
- Long-running projects hit state file bloat

## The Solution

A three-file system that gives AI tools instant context:

| File | Purpose | Updates |
|------|---------|---------|
| `PROJECT_STATE.md` | Current session state (hot) | Every session |
| `PROJECT_CONTEXT.md` | Project knowledge (cold) | When content changes |
| `PROJECT_ARCHIVE.md` | Historical entries | During archival |

**Result:** Start new chats with ~5% context usage instead of 40-50%. Maintain continuity across weeks and months, not just between sessions.

## Quick Start

### Option 1: Use as GitHub Template

1. Click "Use this template" on GitHub
2. Clone your new repo
3. Fill in `PROJECT_STATE.md` with your project details
4. Start coding with your AI tool

### Option 2: Add to Existing Project

```bash
# Clone this repo
git clone https://github.com/gavinbmoore/cursor-session-state-template.git

# Copy core files to your project
cp cursor-session-state-template/PROJECT_STATE.md /path/to/your/project/
cp cursor-session-state-template/PROJECT_CONTEXT.md /path/to/your/project/

# Copy AI rules
mkdir -p /path/to/your/project/.cursor/rules
cp cursor-session-state-template/.cursor/rules/session-state.mdc /path/to/your/project/.cursor/rules/
```

See [docs/MIGRATION.md](docs/MIGRATION.md) for detailed migration instructions.

## File Overview

```
your-project/
├── .cursor/
│   └── rules/
│       └── session-state.mdc    # AI behavior instructions (auto-loads)
├── .cursorignore                # Keeps irrelevant files out of context
├── PROJECT_STATE.md             # Hot state: current session (AI updates)
├── PROJECT_CONTEXT.md           # Cold state: project knowledge (AI updates)
├── PROJECT_ARCHIVE.md           # Overflow storage (created as needed)
└── AGENTS.md                    # Optional: Architectural guide
```

## How It Works

### Starting a New Session

Just say:
```
Hey, let's continue working on the project.
```

The AI automatically:
1. Reads `PROJECT_STATE.md` for current context
2. Checks for mid-flight work in Session Handoff
3. Reads `PROJECT_CONTEXT.md` if starting new feature
4. Resumes work without lengthy context-setting

### During Development

The AI automatically updates state files after completing tasks, tracking:
- What was just done
- Current progress on active features
- Lessons learned and gotchas discovered
- Decisions made and their rationale

### Session Handoff

When ending a session mid-task, the AI captures:
- What was in progress
- Files in modified state
- Context that would be lost
- Open questions

This context is restored at the start of the next session.

## File Sections

### PROJECT_STATE.md (Hot State)

| Section | Purpose |
|---------|---------|
| **Meta** | Timestamps, branch, active session, current phase |
| **Active Context** | What matters RIGHT NOW |
| **Current Task Breakdown** | Checklist for complex features |
| **Recent Changes** | Last 10 completed items |
| **Session Handoff** | Mid-flight context for next session |
| **Next Steps** | Prioritized upcoming work |
| **Quick Commands** | Project-specific commands |

### PROJECT_CONTEXT.md (Cold State)

| Section | Purpose |
|---------|---------|
| **Technical Debt** | Shortcuts taken that need addressing |
| **Failure Patterns** | Recurring issues with known workarounds |
| **Stable Checkpoints** | Known-good git commits for rollback |
| **Lessons Learned** | Gotchas and workarounds |
| **Decisions Log** | Key decisions with rationale |
| **External Dependencies** | APIs, services, constraints |
| **File Relationships** | Files that change together |

## Multi-Agent Usage

This system supports multiple AI tools working on the same project:

- **Active Session tracking** prevents conflicts when two sessions target the same branch
- **Tool-agnostic identifiers** (e.g., "Cursor on main", "Claude Code on feature/auth")
- **Branch awareness** allows parallel work on different branches

When starting a session, the AI checks if another session is active on the same branch and asks before proceeding.

## Best Practices

### Keep PROJECT_STATE.md Concise
Target: Under 80 lines. Archive old entries when it grows.

### Let PROJECT_CONTEXT.md Grow Organically
Don't fill it all at once. Add lessons and decisions as they happen.

### Validate Periodically
The AI validates state when:
- Starting a new feature
- Switching branches
- After major file changes
- When context feels stale

### Use Task Breakdowns for Complex Features
```markdown
## Current Task Breakdown
Feature: User Authentication
- [x] Login form
- [ ] Password reset
  - [x] Request UI
  - [ ] Email template ← CURRENT
  - [ ] Confirmation page
```

### Log Lessons Immediately
When you discover a gotcha, add it right away—you'll thank yourself later.

## Customization

### Adjust Sections
Not every project needs every section. Remove what's not useful, add what is.

### Modify AI Instructions
Edit `.cursor/rules/session-state.mdc` to change behavior.

### Git Considerations

**Option A: Commit everything** (solo projects)
- All state files tracked in git

**Option B: Ignore hot state** (teams)
```gitignore
PROJECT_STATE.md
PROJECT_ARCHIVE.md
```

**Option C: Ignore all state** (different AI tools per developer)
```gitignore
PROJECT_STATE.md
PROJECT_CONTEXT.md
PROJECT_ARCHIVE.md
```

## Troubleshooting

### AI Not Updating State File
1. Check that `.cursor/rules/session-state.mdc` exists
2. Explicitly ask: "Update PROJECT_STATE.md now"
3. Strengthen language in the .mdc file (add "MUST", "ALWAYS")

### State File Getting Too Long
1. Archive old entries to `PROJECT_ARCHIVE.md`
2. Keep only last 10 recent changes
3. Move completed task breakdowns to archive

### AI Scanning Codebase Anyway
Add to your prompt: "Use PROJECT_STATE.md for context—don't scan the full codebase unless necessary."

### Multi-Agent Conflicts
1. Check `Active Session` field in PROJECT_STATE.md
2. Clear stale sessions manually if needed
3. Use different branches for parallel work

### First-Time Setup Issues
1. The AI should detect placeholder values and prompt you
2. If not, manually fill in Meta and Active Context sections
3. See [docs/MIGRATION.md](docs/MIGRATION.md) for detailed setup

## Integration with Other Frameworks

This system complements (doesn't replace) architectural guidance:

| Framework | What It Provides | This System Adds |
|-----------|------------------|------------------|
| [llm-cursor-rules](https://github.com/RayFernando1337/llm-cursor-rules) | Tech stack rules, code patterns | Session continuity, state tracking |
| AGENTS.md | "Where is everything?" | "Where are we in development?" |
| .cursorrules | Static project rules | Dynamic progress tracking |

### Recommended Combo

```
.cursor/
└── rules/
    ├── session-state.mdc           # This template
    ├── nextjs-typescript.mdc       # From Ray's repo (or your tech stack)
    └── your-custom-rules.mdc       # Project-specific patterns
```

## Contributing

Contributions welcome! Please open an issue or PR if you have:
- Improvements to the state file structure
- Better AI instruction patterns
- Integration guides for other tools
- Bug fixes or documentation improvements

## Credits

- Session state concept inspired by discussions on efficient AI-assisted development
- Architectural patterns influenced by [Ray Fernando's llm-cursor-rules](https://github.com/RayFernando1337/llm-cursor-rules)

## License

MIT License - Use freely, attribution appreciated.
