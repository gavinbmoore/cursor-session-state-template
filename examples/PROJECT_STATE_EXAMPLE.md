# Project State — EXAMPLE

<!-- 
This is an EXAMPLE of a filled-in PROJECT_STATE.md.
Copy PROJECT_STATE.md (the template) to your project and customize.
Delete this file—it's just for reference.
-->

## Meta

- **Last Updated:** 2024-12-16 14:30
- **Last Task:** Completed password reset request UI
- **Current Phase:** MVP Development - Authentication Flow
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

## Next Steps

1. Create password reset email template (React Email)
2. Build reset confirmation page with new password form
3. Test full reset flow end-to-end
4. Add OAuth provider buttons to login/register
5. Implement "remember me" with extended session

## Lessons Learned

- [2024-12-16] Supabase `resetPasswordForEmail` requires exact redirect URL in dashboard settings
- [2024-12-15] React Email templates must be in separate package for Resend to compile
- [2024-12-14] Supabase RLS: Must enable policies BEFORE seeding test data
- [2024-12-13] Next.js 14: Server actions can't be imported into client components directly—use 'use server' file

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2024-12-16 | Use React Email over MJML | Better TypeScript support, component reuse |
| 2024-12-15 | Resend over SendGrid | Simpler API, better DX, generous free tier |
| 2024-12-14 | Supabase Auth over NextAuth | Native Supabase integration, RLS policies |
| 2024-12-13 | Shadcn/ui over Radix directly | Pre-built components, easy customization |

## File Relationships

- **Auth Forms:** `src/app/(auth)/*/page.tsx` ↔ `src/lib/validations/auth.ts` ↔ `src/components/auth/*`
- **Email Templates:** `src/lib/email/templates/*.tsx` ↔ `supabase/functions/*/index.ts`
- **Supabase Types:** `supabase/migrations/*.sql` → run `supabase gen types` → `src/types/database.ts`

## External Dependencies

- **Supabase:** Project `abcd1234`, using Auth + Database + Edge Functions
- **Resend:** API key in `.env.local`, domain verified, 100 emails/day free tier
- **Vercel:** Deployment target, preview URLs enabled for PR reviews

## Quick Commands

```bash
# Development
npm run dev                    # Start Next.js dev server (port 3000)
supabase start                 # Start local Supabase (port 54321)

# Database
supabase db reset              # Reset local DB and run migrations
supabase gen types typescript --local > src/types/database.ts

# Email Development
npm run email:dev              # Preview React Email templates

# Testing
npm test                       # Run Vitest
npm run test:e2e               # Run Playwright

# Deployment
npm run build                  # Production build
supabase db push               # Push migrations to production
```

## Stable Checkpoints

- `a1b2c3d` - Login/register working, pre-password-reset (2024-12-15)
- `e4f5g6h` - Initial Supabase setup complete (2024-12-13)

---

<!--
This example shows a mid-development state.
Your actual file will look different based on your project.
-->
