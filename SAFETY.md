# Safety Prompting Guidelines

<!--
AI INSTRUCTIONS: This file defines safety boundaries for AI actions.
- Read this alongside PROJECT_STATE.md at session start
- These are guidelines you commit to follow, not hard enforcement
- When uncertain, escalate to user
-->

## Safety Profile

<!-- Choose one: minimal | standard | strict -->
**Active Profile:** standard

---

## Profiles Reference

### Minimal
For trusted environments, solo projects, rapid prototyping.
- Log destructive actions only
- Escalate on file deletions
- No rate limits

### Standard (Recommended)
Balanced safety for most projects.
- Log all file modifications
- Escalate on: deletions, config changes, security-related code
- Plan required for 3+ file changes
- Checkpoint every 5 modifications

### Strict
For production codebases, team environments, sensitive projects.
- Log all actions with reasoning
- Escalate on any non-trivial change
- Plan required for all multi-file changes
- User approval for: new dependencies, API changes, auth code
- Checkpoint every 3 modifications

---

## Escalation Triggers

<!-- Actions requiring explicit user confirmation before proceeding -->

**Always Escalate:**
- [ ] Deleting files
- [ ] Modifying `.env`, credentials, secrets
- [ ] Changes to auth/permission logic
- [ ] CI/CD and deployment configs
- [ ] Database migrations or schema changes

**Standard+ Profile:**
- [ ] Installing new dependencies
- [ ] Modifying API contracts
- [ ] Changes to security-sensitive code

**Strict Profile:**
- [ ] Any change to files outside defined scope
- [ ] Multi-file refactors

---

## Scope Boundaries

<!-- Define what's in-scope for AI modifications -->

**Allowed Paths:**
```
src/
tests/
docs/
```

**Read-Only Paths:**
```
*.config.js
*.config.ts
package.json (can add deps, not remove)
```

**Deny List (never modify without escalation):**
```
.env*
**/credentials*
**/secrets*
**/*key*
.github/workflows/
```

---

## Rate Limits

| Metric | Minimal | Standard | Strict |
|--------|---------|----------|--------|
| Max files per task | unlimited | 10 | 5 |
| Errors before pause | 5 | 3 | 2 |
| Checkpoint interval | none | 5 changes | 3 changes |

---

## Rollback Protocol

**Before risky operations:**
1. Note current git state in PROJECT_STATE.md `## Stable Checkpoints`
2. Verify clean working tree (`git status`)
3. Proceed with changes

**If something goes wrong:**
1. Stop immediately—don't attempt fixes that might compound the issue
2. Report to user: what happened, what was attempted, current state
3. Offer rollback: `git checkout <checkpoint>` or `git stash`
4. Log incident in PROJECT_STATE.md `## Lessons Learned`

**Recovery commands:**
```bash
# Undo uncommitted changes
git checkout -- .

# Rollback to checkpoint
git reset --hard <commit-hash>

# Recover stashed work
git stash list
git stash pop
```

---

## Incident Response

When a safety boundary is violated:

1. **Stop** - Halt current operation
2. **Log** - Record what happened in Action Log
3. **Notify** - Inform user immediately with:
   - What was attempted
   - What went wrong
   - Current system state
   - Recommended remediation
4. **Wait** - Do not proceed until user acknowledges

---

## External Enforcement (Optional)

For actual technical controls beyond AI prompting:

### Git Pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Block commits with secrets
if git diff --cached | grep -iE "(password|secret|api_key)\s*=" ; then
    echo "ERROR: Potential secret in commit"
    exit 1
fi

# Block commits to protected files without confirmation
PROTECTED=".env docker-compose.yml"
for file in $PROTECTED; do
    if git diff --cached --name-only | grep -q "$file"; then
        echo "WARNING: Modifying protected file: $file"
        read -p "Continue? (y/N) " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] || exit 1
    fi
done
```

### GitHub Actions Check
```yaml
# .github/workflows/safety-check.yml
name: Safety Check
on: [pull_request]
jobs:
  check-secrets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check for secrets
        run: |
          if grep -rE "(password|secret|api_key)\s*=" --include="*.ts" --include="*.js" .; then
            echo "::error::Potential hardcoded secrets detected"
            exit 1
          fi
```

---

<!--
MAINTENANCE:
- Review escalation triggers quarterly
- Update scope boundaries as project evolves
- Adjust profile based on project phase (stricter near production)
-->
