# AGENTS.md

<!-- 
This is a lightweight architectural guide following JIT (Just-In-Time) indexing.
Point to locations, don't paste content. Keep under 150 lines.
For dynamic session state, see PROJECT_STATE.md
-->

## Project Overview

- **Name:** [Project Name]
- **Type:** [Monorepo / Standard / Library]
- **Description:** [One-line description]

## Directory Structure

```
├── src/
│   ├── app/              # Next.js app router pages
│   ├── components/       # React components
│   │   ├── ui/          # Base UI components (buttons, inputs, etc.)
│   │   └── features/    # Feature-specific components
│   ├── lib/             # Utilities and shared logic
│   ├── hooks/           # Custom React hooks
│   ├── types/           # TypeScript types
│   └── styles/          # Global styles
├── public/              # Static assets
├── prisma/              # Database schema (if using Prisma)
└── tests/               # Test files
```

## Quick Find Commands

```bash
# Find a component
rg -n "export.*ComponentName" src/components/

# Find an API route
rg -n "export (async function|const) (GET|POST|PUT|DELETE)" src/app/api/

# Find a hook
rg -n "export function use" src/hooks/

# Find type definitions
rg -n "export (type|interface)" src/types/

# Find where something is used
rg -n "import.*ThingName" src/
```

## Key Patterns

### Components

- ✅ **DO:** Functional components with TypeScript
- ✅ **DO:** Co-locate component, types, and tests
- ❌ **DON'T:** Class components
- ❌ **DON'T:** Inline styles (use Tailwind)

**Reference:** `src/components/ui/Button.tsx`

### API Routes

- ✅ **DO:** Use route handlers in `src/app/api/`
- ✅ **DO:** Validate input with Zod
- ✅ **DO:** Return consistent error format
- ❌ **DON'T:** Business logic in route files (extract to `src/lib/`)

**Reference:** `src/app/api/example/route.ts`

### Data Fetching

- ✅ **DO:** Server Components for initial data
- ✅ **DO:** React Query for client-side mutations
- ❌ **DON'T:** `useEffect` for data fetching

**Reference:** `src/hooks/useExample.ts`

### State Management

- ✅ **DO:** Server state with React Query
- ✅ **DO:** URL state with `nuqs` or `useSearchParams`
- ✅ **DO:** Local UI state with `useState`
- ❌ **DON'T:** Global state for server data

## File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile.tsx` |
| Hooks | camelCase with "use" | `useAuth.ts` |
| Utilities | camelCase | `formatDate.ts` |
| Types | PascalCase | `User.ts` |
| API Routes | kebab-case folders | `api/user-profile/route.ts` |

## Sub-Directory Guides

<!-- Add AGENTS.md to subdirectories for domain-specific guidance -->

- `src/components/` → [see src/components/AGENTS.md](src/components/AGENTS.md)
- `src/lib/` → [see src/lib/AGENTS.md](src/lib/AGENTS.md)
- `src/app/api/` → [see src/app/api/AGENTS.md](src/app/api/AGENTS.md)

## Testing

```bash
# Run all tests
npm test

# Run specific test file
npm test -- path/to/test.ts

# Watch mode
npm run test:watch
```

**Pattern:** Tests live next to source files as `*.test.ts` or in `__tests__/` folder.

## Common Tasks

### Adding a New Component

1. Create in `src/components/[ui|features]/ComponentName.tsx`
2. Export from `src/components/index.ts`
3. Add story if complex: `ComponentName.stories.tsx`

### Adding a New API Route

1. Create folder: `src/app/api/route-name/`
2. Add `route.ts` with handlers
3. Add input validation with Zod schema
4. Add to API documentation if public

### Adding a New Database Table

1. Update `prisma/schema.prisma`
2. Run `npx prisma migrate dev --name description`
3. Update types in `src/types/`
4. Add seed data if needed

---

<!-- 
For current development state and session continuity, see PROJECT_STATE.md
This file is for architectural patterns; that file is for "where are we now"
-->
