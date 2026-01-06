# Project Context — EXAMPLE

<!--
This is an EXAMPLE of a filled-in PROJECT_CONTEXT.md.
Copy PROJECT_CONTEXT.md (the template) to your project and customize.
Delete this file—it's just for reference.
-->

## Technical Debt

| Date Added | Location | Description | Priority |
|------------|----------|-------------|----------|
| 2024-12-15 | `src/lib/auth/session.ts` | Hardcoded session timeout (should be configurable) | Low |
| 2024-12-14 | `src/app/api/auth/callback/route.ts` | No rate limiting on callback endpoint | Med |
| 2024-12-13 | `prisma/schema.prisma` | User table missing soft delete (deletedAt field) | Low |

## Failure Patterns

| Pattern | Trigger | Resolution |
|---------|---------|------------|
| Supabase connection timeout | Running `supabase start` after sleep | Run `supabase stop` then `supabase start` |
| Type errors after schema change | Modifying `prisma/schema.prisma` | Run `npx prisma generate` before `npm run dev` |
| Email preview blank | Hot reload on email templates | Restart `npm run email:dev` |
| Auth redirect loop | Missing NEXT_PUBLIC_SITE_URL | Check `.env.local` has correct URL |

## Stable Checkpoints

| Commit | Date | Description | Recovery Notes |
|--------|------|-------------|----------------|
| `a1b2c3d` | 2024-12-15 | Login/register working, pre-password-reset | `git checkout a1b2c3d` — auth works but no password reset |
| `e4f5g6h` | 2024-12-13 | Initial Supabase setup complete | `git checkout e4f5g6h` — base setup only, no auth UI |

## Lessons Learned

- [2024-12-16] Supabase `resetPasswordForEmail` requires exact redirect URL in dashboard settings
- [2024-12-15] React Email templates must be in separate package for Resend to compile
- [2024-12-14] Supabase RLS: Must enable policies BEFORE seeding test data
- [2024-12-13] Next.js 14: Server actions can't be imported into client components directly—use 'use server' file
- [2024-12-13] Shadcn/ui: Run `npx shadcn-ui@latest add [component]` not manual copy

## Decisions Log

| Date | Decision | Rationale | Alternatives Considered |
|------|----------|-----------|------------------------|
| 2024-12-16 | Use React Email over MJML | Better TypeScript support, component reuse | MJML (less maintainable), plain HTML (no components) |
| 2024-12-15 | Resend over SendGrid | Simpler API, better DX, generous free tier | SendGrid (complex), Postmark (expensive) |
| 2024-12-14 | Supabase Auth over NextAuth | Native Supabase integration, RLS policies | NextAuth (more flexible but complex), Clerk (expensive) |
| 2024-12-13 | Shadcn/ui over Radix directly | Pre-built components, easy customization | Radix (more control but verbose), MUI (heavy) |

## External Dependencies

- **Supabase:** Project ID `abcd1234`, using Auth + Database + Edge Functions. Dashboard: https://app.supabase.com/project/abcd1234
- **Resend:** API key in `.env.local`, domain `mail.example.com` verified, 100 emails/day free tier
- **Vercel:** Deployment target, preview URLs enabled for PR reviews. Project: https://vercel.com/team/project

## File Relationships

- **Auth Forms:** `src/app/(auth)/*/page.tsx` ↔ `src/lib/validations/auth.ts` ↔ `src/components/auth/*`
- **Email Templates:** `src/lib/email/templates/*.tsx` ↔ `supabase/functions/*/index.ts`
- **Supabase Types:** `supabase/migrations/*.sql` → run `supabase gen types` → `src/types/database.ts`
- **Auth Config:** `src/lib/auth/config.ts` ↔ `.env.local` ↔ Supabase dashboard settings

---

<!--
This example shows:
- Technical Debt with realistic entries and priorities
- Failure Patterns with specific triggers and resolutions
- Stable Checkpoints with recovery notes
- Lessons Learned accumulated over time
- Decisions Log with alternatives considered
- External Dependencies with useful links
- File Relationships showing what changes together
-->
