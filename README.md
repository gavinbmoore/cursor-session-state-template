# Cursor Session State Template

A lightweight context persistence system for [Cursor IDE](https://cursor.com) that maintains session continuity and minimizes token usage across conversations.

Designed to complement architectural frameworks like [Ray Fernando's llm-cursor-rules](https://github.com/RayFernando1337/llm-cursor-rules).

## The Problem

When starting a new Cursor chat, you often need to say something like:

> "Look over the codebase to understand where we're at..."

This fills 40-50% of your context window just to get oriented. Knowledge from previous sessions—decisions made, gotchas discovered, current progress—gets lost.

## The Solution

A lightweight system that gives the AI instant context with optional safety guardrails:

| File | Purpose | Updates |
|------|---------|---------|
| `.cursor/rules/session-state.mdc` | Instructions for AI behavior | Never (static rules) |
| `.cursor/rules/safety.mdc` | Safety prompting rules | Never (static rules) |
| `PROJECT_STATE.md` | Current project state | Every session (AI maintains) |
| `SAFETY.md` | Safety profile and boundaries | As needed (user configures) |

**Result:** Start new chats with ~5% context usage instead of 40-50%, with configurable safety guardrails.

## Quick Start

### Option 1: Use as GitHub Template

1. Click "Use this template" on GitHub
2. Clone your new repo
3. Fill in `PROJECT_STATE.md` with your project details
4. Start coding with Cursor

### Option 2: Manual Setup

```bash
# Copy the essential files to your project
curl -o PROJECT_STATE.md https://raw.githubusercontent.com/YOUR_USERNAME/cursor-session-state-template/main/PROJECT_STATE.md
mkdir -p .cursor/rules
curl -o .cursor/rules/session-state.mdc https://raw.githubusercontent.com/YOUR_USERNAME/cursor-session-state-template/main/.cursor/rules/session-state.mdc
```

## File Overview

```
your-project/
├── .cursor/
│   └── rules/
│       ├── session-state.mdc    # AI behavior instructions (auto-loads)
│       └── safety.mdc           # Safety prompting rules (auto-loads)
├── .cursorignore                # Keeps irrelevant files out of context
├── PROJECT_STATE.md             # Dynamic state (AI updates this)
├── SAFETY.md                    # Safety profile and boundaries (you configure)
└── AGENTS.md                    # Optional: Architectural guide (JIT indexing)
```

## How It Works

### Starting a New Session

Just say:
```
Hey, let's continue working on the project.
```

The AI automatically:
1. Reads `PROJECT_STATE.md`
2. Understands current state, recent changes, and next steps
3. Resumes work without lengthy context-setting

### During Development

The AI automatically updates `PROJECT_STATE.md` after completing tasks, tracking:
- What was just done
- Current progress on active features
- Lessons learned and gotchas discovered
- Decisions made and their rationale

### Manual Commands (if needed)

```
Check PROJECT_STATE.md and confirm where we are.
```

```
Update PROJECT_STATE.md with what we just did.
```

## PROJECT_STATE.md Sections

| Section | Purpose |
|---------|---------|
| **Meta** | Timestamps, current phase |
| **Active Context** | What matters RIGHT NOW |
| **Current Task Breakdown** | Checklist for complex features |
| **Recent Changes** | Last 5-10 completed items |
| **Next Steps** | Prioritized upcoming work |
| **Lessons Learned** | Gotchas and workarounds |
| **Decisions Log** | Key decisions with rationale |
| **File Relationships** | Files that change together |
| **External Dependencies** | APIs, services, constraints |
| **Quick Commands** | Project-specific commands |
| **Stable Checkpoints** | Known-good git commits |
| **Action Log** | Safety: significant AI actions |

## Safety Prompting (Optional)

This template includes optional safety guardrails that encourage deliberate, reversible AI actions.

> **Note:** These are *prompting guidelines*, not hard enforcement. The AI commits to follow them, but there's no technical mechanism preventing violations. For actual enforcement, see the git hooks section in `SAFETY.md`.

### Safety Profiles

Configure in `SAFETY.md` by setting **Active Profile:**

| Profile | Best For | Behavior |
|---------|----------|----------|
| **Minimal** | Rapid prototyping, trusted environments | Log destructive actions only, escalate on deletions |
| **Standard** | Most projects (default) | Log modifications, plan for 3+ files, checkpoint every 5 changes |
| **Strict** | Production code, team environments | Log everything with reasoning, escalate broadly, frequent checkpoints |

### Key Safety Features

- **Action Logging** - Track significant AI actions for auditability
- **Escalation Triggers** - AI pauses for confirmation before destructive/sensitive operations
- **Scope Boundaries** - Define allowed paths, read-only files, and deny lists
- **Rate Limits** - Auto-pause after N changes or errors
- **Rollback Protocol** - Checkpoint before risky operations, clear recovery steps
- **Planning Requirements** - Require explicit plans for multi-file changes

### Quick Setup

1. Open `SAFETY.md`
2. Set your desired profile: `**Active Profile:** standard`
3. Customize `## Scope Boundaries` for your project
4. Review `## Escalation Triggers` and adjust as needed

### External Enforcement

For actual technical controls beyond AI prompting, `SAFETY.md` includes ready-to-use:
- Git pre-commit hooks (block secrets, protect sensitive files)
- GitHub Actions workflow (CI secret scanning)

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

## Best Practices

### Keep PROJECT_STATE.md Concise
Target: Under 100 lines. Archive old entries periodically.

### Validate Periodically
Every few sessions, scan the state file to ensure it matches reality:
```
Validate PROJECT_STATE.md against the current codebase.
```

### Use Task Breakdowns for Complex Features
Instead of vague "working on auth," break it down:
```markdown
## Current Task Breakdown
Feature: User Authentication
- [x] Login form
- [ ] Password reset
  - [x] Request UI
  - [ ] Email template
  - [ ] Confirmation page
```

### Log Lessons Learned Immediately
When you discover a gotcha, add it right away—you'll thank yourself later.

## Customization

### Adjust Sections
Not every project needs every section. Remove what's not useful, add what is.

### Modify AI Instructions
Edit `.cursor/rules/session-state.mdc` to change how aggressively the AI updates state, what it tracks, etc.

### Project-Specific Rules
Add conditional rules based on your stack:
```markdown
## Stack-Specific Rules
- For React components: Always check for existing patterns in `src/components/ui/`
- For API routes: Follow the pattern in `src/app/api/example/route.ts`
```

## Troubleshooting

### AI Not Updating State File
1. Check that `.cursor/rules/session-state.mdc` exists
2. Explicitly ask: "Update PROJECT_STATE.md now"
3. Strengthen language in the .mdc file (add "MUST", "ALWAYS")

### State File Getting Too Long
1. Archive completed items: Move to a `PROJECT_ARCHIVE.md`
2. Keep only last 5-10 recent changes
3. Summarize old decisions into principles

### AI Scanning Codebase Anyway
Add to your prompt: "Use PROJECT_STATE.md for context—don't scan the full codebase unless necessary."

## Contributing

Contributions welcome! Please open an issue or PR if you have:
- Improvements to the state file structure
- Better AI instruction patterns
- Integration guides for other frameworks

## Credits

- Session state concept inspired by discussions on efficient Cursor usage
- Architectural patterns influenced by [Ray Fernando's llm-cursor-rules](https://github.com/RayFernando1337/llm-cursor-rules)

## License

MIT License - Use freely, attribution appreciated.
