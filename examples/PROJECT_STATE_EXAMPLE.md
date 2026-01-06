# Project State — EXAMPLE

<!--
This is an EXAMPLE of a filled-in PROJECT_STATE.md showing the new slimmed-down structure.
Copy PROJECT_STATE.md (the template) to your project and customize.
Delete this file—it's just for reference.
-->

## Meta

- **Last Updated:** 2024-12-16 14:30
- **Active Session:** Cursor on feature/password-reset
- **Last Task:** Completed password reset request UI
- **Current Phase:** MVP Development - Authentication Flow
- **Current Branch:** feature/password-reset (base: main)
- **Project:** SaaS Starter Kit
- **Stack:** Next.js 14, TypeScript, Supabase, Tailwind, Shadcn/ui

## Active Context

**Current Focus:** Password reset flow - building email template

**Key Files:**
- `src/app/(auth)/reset-password/page.tsx` - Reset request form (done)
- `src/lib/email/templates/` - Email templates (current)
- `supabase/functions/send-reset-email/` - Edge function for sending

**Blockers:** None

## Current Task Breakdown

Feature: User Authentication
- [x] Supabase auth client setup
- [x] Login page and form
- [x] Registration with email verification
- [ ] Password reset flow
  - [x] Reset request UI
  - [ ] Email template ← CURRENT
  - [ ] Reset confirmation page
  - [ ] Integration testing
- [ ] OAuth providers (Google, GitHub)
- [ ] Session management improvements

## Recent Changes

- [2024-12-16] Built password reset request form with validation
- [2024-12-16] Added Zod schema for auth forms
- [2024-12-15] Completed registration flow with email verification
- [2024-12-15] Set up Resend for transactional emails
- [2024-12-14] Implemented login page with remember me option
- [2024-12-14] Created auth layout with centered card design
- [2024-12-13] Initial Supabase setup and RLS policies
- [2024-12-13] Added shadcn/ui components (Button, Input, Card, Form)

## Session Handoff

<!-- This section was populated at end of last session -->

**Mid-Flight Work:**
- Email template partially complete in `src/lib/email/templates/password-reset.tsx`
- React Email preview server was running on port 3001

**Unresolved Questions:**
- Should reset link expire after 1 hour or 24 hours?

**Context for Next Session:**
- PR #42 open for password reset UI, waiting on email template before merge

## Next Steps

1. Create password reset email template (React Email)
2. Build reset confirmation page with new password form
3. Test full reset flow end-to-end
4. Add OAuth provider buttons to login/register
5. Implement "remember me" with extended session

## Quick Commands

```bash
# Development
npm run dev                    # Start Next.js dev server (port 3000)
supabase start                 # Start local Supabase (port 54321)

# Email Development
npm run email:dev              # Preview React Email templates (port 3001)

# Database
supabase db reset              # Reset local DB and run migrations
supabase gen types typescript --local > src/types/database.ts

# Testing
npm test                       # Run Vitest
npm run test:e2e               # Run Playwright

# Deployment
npm run build                  # Production build
supabase db push               # Push migrations to production
```

---

<!--
This example shows:
- Active Session field for multi-agent safety
- Current Branch with base branch
- Session Handoff with mid-flight context
- Slimmed-down structure (no Lessons Learned, Decisions—those are in PROJECT_CONTEXT.md)
-->
