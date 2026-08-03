#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Spec Kit – Clean Architecture + TDD (minimal stack)"
echo "======================================================"

# --- Vérifications ---
if ! command -v specify >/dev/null 2>&1; then
  echo "❌ 'specify' introuvable."
  echo "   Installe-le avec :"
  echo "   uv tool install specify-cli --from git+https://github.com/github/spec-kit.git"
  exit 1
fi

if [ ! -d ".specify" ]; then
  echo "❌ Dossier .specify introuvable."
  echo "   Ce script doit être lancé dans un projet déjà initialisé :"
  echo "   specify init . --here"
  exit 1
fi

echo ""
echo "📦 1. Installation des presets (via --from pour éviter les restrictions de catalogue)..."

# test-first-governance
specify preset add test-first-governance \
  --from "https://github.com/ka-zo/spec-kit-preset-test-first-governance/archive/refs/heads/main.zip" \
  --priority 10 || echo "⚠️  Preset test-first-governance déjà présent ou erreur non bloquante"

# architecture-governance
specify preset add architecture-governance \
  --from "https://github.com/hindermath/spec-kit-preset-architecture-governance/archive/refs/heads/main.zip" \
  --priority 15 || echo "⚠️  Preset architecture-governance déjà présent ou erreur non bloquante"

echo ""
echo "🛡️  2. Installation de architecture-guard..."
specify extension add architecture-guard \
  --from "https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/heads/main.zip" \
  --force || echo "⚠️  Extension architecture-guard déjà présente ou erreur non bloquante"

echo ""
echo "📝 3. Écriture de constitution.md (principes généraux)..."

mkdir -p .specify/memory

cat > .specify/memory/constitution.md << 'EOF'
# Project Constitution

This project follows professional engineering discipline inspired by Clean Code and Spec-Driven Development.

## Non-negotiable principles

1. **TDD is mandatory**  
   Always write a failing test first (RED), then the minimal implementation (GREEN), then refactor.

2. **Behavior is specified in Gherkin**  
   Every user-facing behavior must be expressed as Gherkin scenarios (Given / When / Then) before implementation.

3. **No business logic in outer layers**  
   Entry points (controllers, UI, handlers) and infrastructure adapters must contain no business rules.

4. **Small, focused modules**  
   Prefer composition over inheritance. Keep modules small and with a single responsibility.

5. **Quality gates**  
   Architecture boundaries, test coverage and maintainability must be respected. Architecture review tools enforce them.

## Product context (optional – fill or update later)

[Short description of the overall product vision, main users and high-level goals.
Keep this section stable. Detailed features go into individual specifications.]

## Tech defaults (fill in once per project)

[Fill this section once, at project start — by hand or with a short constitution prompt. It sets the defaults every spec/plan will assume unless a feature says otherwise.]

- **Language / runtime**: <e.g. TypeScript 5.x / Node 20>
- **Primary framework**: <e.g. NestJS / Next.js / none>
- **Package manager**: <e.g. pnpm>
- **Test framework**: <e.g. Vitest / Jest>
- **Linting / formatting**: <e.g. ESLint + Prettier>
- **Persistence**: <e.g. PostgreSQL via Prisma>
- **Other conventions**: <e.g. monorepo layout, API style (REST/GraphQL), CI provider>
EOF

echo "   → .specify/memory/constitution.md"

echo ""
echo "🏗️  4. Écriture de architecture_constitution.md (Clean Architecture)..."

cat > .specify/memory/architecture_constitution.md << 'EOF'
# Architecture Constitution – Clean Architecture

This project strictly follows Clean Architecture principles for all applications in the repository.

## Dependency Rule (non-negotiable)

Source code dependencies can only point **inward**.

Domain ← Application ← Infrastructure / Presentation

Never the opposite.

## Mandatory Layers

### 1. Domain
- Entities, Value Objects, Domain Services
- Repository / port interfaces
- Pure business logic – no framework or infrastructure dependencies

### 2. Application
- Use cases / Interactors
- Application services
- Input/output ports and DTOs
- Orchestrates the domain

### 3. Infrastructure
- Adapters: persistence, external APIs, messaging, file system, etc.
- Framework-specific implementations of the ports defined inward

### 4. Presentation (or Interfaces)
- Controllers, presenters, API handlers
- UI components / screens
- Application entry points

## Additional rules

- Prefer property-based / invariant tests for domain rules when relevant
- No leakage of infrastructure concerns into Domain or Application
- The composition root (main / bootstrap) is the only place that wires concrete implementations
- The same separation of concerns applies to backend, frontend and any other runtime
EOF

echo "   → .specify/memory/architecture_constitution.md"

echo ""
echo "✅ Fichiers de constitution écrits."
echo ""
echo "======================================================"
echo "⚠️  ACTION MANUELLE REQUISE (commande agent)"
echo "======================================================"
echo ""
echo "Dans ton agent IA, lance maintenant :"
echo ""
echo "   /speckit.architecture-guard.init"
echo ""
echo "Cette commande finalise / affine les constitutions côté architecture-guard."
echo "(Un script bash ne peut pas exécuter les commandes slash de l’agent.)"
echo ""
echo "--- État actuel ---"
specify preset list || true
echo ""
specify extension list || true
echo ""
echo "🎉 Setup terminé. Tu peux commencer avec /speckit.specify"