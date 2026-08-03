#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Spec Kit – Clean Architecture + TDD"
echo "======================================"

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

log() {
  echo "→ $1"
}

success() {
  echo "✅ $1"
}

warning() {
  echo "⚠️  $1"
}

error() {
  echo "❌ $1" >&2
  exit 1
}

# ------------------------------------------------------------
# Checks
# ------------------------------------------------------------

if ! command -v specify >/dev/null 2>&1; then
  error "'specify' command not found.

Install Spec Kit with:

uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
"
fi

if [ ! -d ".specify" ]; then
  error "'.specify' directory not found.

This script must be run inside an already initialized Spec Kit project:

specify init . --here
"
fi

mkdir -p .specify/memory

# ------------------------------------------------------------
# Preset / extension helpers
# ------------------------------------------------------------

preset_installed() {
  specify preset list 2>/dev/null | grep -q "$1"
}

extension_installed() {
  specify extension list 2>/dev/null | grep -q "$1"
}

install_preset() {
  local name="$1"
  local url="$2"
  local priority="$3"

  if preset_installed "$name"; then
    warning "Preset '$name' is already installed — skipping."
    return 0
  fi

  log "Installing preset '$name'..."

  specify preset add "$name" \
    --from "$url" \
    --priority "$priority"

  success "Preset '$name' installed."
}

install_extension() {
  local name="$1"
  local url="$2"

  if extension_installed "$name"; then
    warning "Extension '$name' is already installed — skipping."
    return 0
  fi

  log "Installing extension '$name'..."

  specify extension add "$name" \
    --from "$url"

  success "Extension '$name' installed."
}

# ------------------------------------------------------------
# Presets
# ------------------------------------------------------------

echo ""
echo "📦 1. Installing presets"
echo "------------------------"

install_preset \
  "test-first-governance" \
  "https://github.com/ka-zo/spec-kit-preset-test-first-governance/archive/refs/heads/main.zip" \
  "10"

install_preset \
  "architecture-governance" \
  "https://github.com/hindermath/spec-kit-preset-architecture-governance/archive/refs/heads/main.zip" \
  "15"

# ------------------------------------------------------------
# Architecture Guard
# ------------------------------------------------------------

echo ""
echo "🛡️  2. Installing architecture-guard"
echo "------------------------------------"

install_extension \
  "architecture-guard" \
  "https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/heads/main.zip"

# ------------------------------------------------------------
# Constitution
# ------------------------------------------------------------
# NOTE: architecture-guard owns architecture boundary rules (Dependency Rule,
# layers, forbidden dependencies, verification). This file intentionally stays
# generic and does not duplicate what /speckit.architecture-guard.init writes.

echo ""
echo "📝 3. Writing constitution"
echo "--------------------------"

cat > .specify/memory/constitution.md << 'EOF'
# Project Constitution

This project follows professional engineering discipline inspired by Clean Code,
Test-Driven Development, Behavior-Driven Development, and Spec-Driven Development.

## Non-negotiable principles

1. **TDD is mandatory**
   Always write a failing test first (RED), then the minimal implementation
   (GREEN), then refactor.

2. **Behavior is specified in Gherkin**
   Every user-facing behavior must be expressed as Gherkin scenarios
   (Given / When / Then) before implementation.

3. **No business logic in outer layers**
   Controllers, UI components, handlers, and infrastructure adapters must
   contain no business rules.

4. **Small, focused modules**
   Prefer composition over inheritance. Keep modules small and focused on
   a single responsibility.

5. **Quality gates are mandatory**
   Features must pass the project quality gate before being considered complete.

Architecture boundaries and their enforcement are governed separately by
`architecture_constitution.md` and the `architecture-guard` extension.

## Product context

[Describe the overall product vision, main users, and high-level goals.
Keep this section stable. Detailed features go into individual specifications.]

## Tech defaults (fill in once per project)

[Fill this section once, at project start — by hand or with a short constitution
prompt. It sets the defaults every spec/plan will assume unless a feature says
otherwise.]

- **Language / runtime**: <e.g. TypeScript 5.x / Node 20>
- **Primary framework**: <e.g. NestJS / Next.js / none>
- **Package manager**: <e.g. pnpm>
- **Test framework**: <e.g. Vitest / Jest>
- **Linting / formatting**: <e.g. ESLint + Prettier>
- **Persistence**: <e.g. PostgreSQL via Prisma>
- **Other conventions**: <e.g. monorepo layout, API style (REST/GraphQL), CI provider>

These project-specific choices must not override the principles defined above.
EOF

success ".specify/memory/constitution.md"

# ------------------------------------------------------------
# Architecture Constitution
# ------------------------------------------------------------

echo ""
echo "🏗️  4. Writing architecture constitution"
echo "-----------------------------------------"

cat > .specify/memory/architecture_constitution.md << 'EOF'
# Architecture Constitution – Clean Architecture

This project strictly follows Clean Architecture principles for all applications
in the repository.

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

Detailed enforcement (forbidden dependencies, drift detection, mechanical
verification) is handled by the `architecture-guard` extension — run
`/speckit.architecture-guard.init` to finalize this file.
EOF

success ".specify/memory/architecture_constitution.md"

# ------------------------------------------------------------
# Coding Standards
# ------------------------------------------------------------
# NOTE: this file covers general coding conventions (naming, error handling,
# logging, API conventions, testing, complexity). Architectural boundary
# rules are NOT repeated here — see architecture_constitution.md.

echo ""
echo "📐 5. Writing coding standards"
echo "------------------------------"

cat > .specify/memory/coding_standards.md << 'EOF'
# Coding Standards

These standards apply to all production code.

They are intentionally language- and framework-agnostic. Project-specific
conventions may extend these rules but must not contradict the principles
defined in the project constitution.

## 1. Naming Conventions

Names must communicate intent.

Avoid vague names such as:

- `data`
- `result`
- `thing`
- `temp`
- `value`
- `manager`
- `handler`

when a more precise name exists.

### General rules

- Use the naming conventions established by the project's language.
- Prefer descriptive names over abbreviations.
- Use consistent terminology throughout the codebase.
- Domain terminology must match the project's ubiquitous language.
- Avoid introducing technical terminology where a meaningful business concept
  already exists.

### Functions and methods

Names should clearly communicate the action or behavior they perform. Avoid
generic names such as `process`, `handle`, `execute`, `run` when a more
specific name is possible.

---

## 2. Error Handling

Errors must be explicit, meaningful, and handled at the appropriate boundary.

- Never silently swallow errors.
- Never use empty error-handling blocks.
- Do not use exceptions or equivalent mechanisms for normal business control
  flow unless explicitly justified by the project's conventions.
- Domain errors should represent meaningful domain failures.
- Infrastructure errors must not leak implementation details into the Domain.
- Errors crossing architectural boundaries must be translated into the
  appropriate abstraction.
- Preserve the original cause when useful for diagnostics.
- Do not expose internal implementation details through external interfaces.

---

## 3. Logging

Logging must be intentional and must remain outside core business rules.

- Use the project's standard logging mechanism.
- Avoid ad-hoc production logging.
- Never log secrets, credentials, authentication tokens, or sensitive data.
- Avoid excessive or redundant logging.
- Log meaningful technical or business events.
- The Domain must not depend on a concrete logging implementation.

---

## 4. API and External Interface Conventions

External interfaces must be explicit, stable, and independent from internal
implementation details.

- Validate external input at the system boundary.
- Never trust external input.
- Do not expose internal domain entities directly when a dedicated contract
  or DTO is more appropriate.
- Use explicit input and output contracts.
- Use consistent status and error semantics.
- Do not expose persistence or infrastructure implementation details.
- Authentication and authorization must be handled at the appropriate boundary.
- Keep external contracts stable even when internal implementation changes.

---

## 5. Testing Rules

Testing follows Test-Driven Development.

### Mandatory cycle

RED → GREEN → REFACTOR

### Rules

1. Write a failing test first whenever practical.
2. Implement the minimum behavior required to make the test pass.
3. Refactor while keeping the test suite green.
4. Never remove a test simply because it is inconvenient.
5. Tests must describe behavior rather than implementation details.
6. Domain rules should be tested independently from infrastructure.
7. Application use cases should be tested using appropriate test doubles
   for external dependencies.
8. Infrastructure adapters should have appropriate integration coverage.
9. Critical user journeys should have appropriate end-to-end coverage.
10. User-facing behavior should have corresponding Gherkin scenarios where
    applicable.

### Test quality

Tests must be deterministic, independent, have a clear purpose, use
meaningful assertions, fail for the correct reason, and remain independent
from implementation details.

---

## 6. Complexity

Prefer simple and understandable code over clever code. Avoid unnecessary
abstractions, premature generalization, deeply nested control flow,
excessively large functions or modules, excessive parameter lists,
duplicated business logic, and unnecessary indirection.

---

## 7. Maintainability

Prefer explicit dependencies, cohesive modules, clear boundaries, predictable
control flow, meaningful abstractions, minimal coupling, high cohesion, and
small changes with limited blast radius.

---

## 8. Definition of Done

Code is not considered complete until the applicable project quality gates
have passed.
EOF

success ".specify/memory/coding_standards.md"

# ------------------------------------------------------------
# Quality Gate
# ------------------------------------------------------------
# NOTE: architecture boundary checks (dependency direction, forbidden
# dependencies, drift) are enforced by the architecture-guard extension and
# are intentionally not repeated as a checklist here.

echo ""
echo "🚦 6. Writing quality gate"
echo "--------------------------"

cat > .specify/memory/quality_gate.md << 'EOF'
# Feature Quality Gate

A feature is complete only when every applicable gate passes.

## Specification

- [ ] User stories are clearly defined.
- [ ] Acceptance criteria are explicit.
- [ ] Gherkin scenarios are written for user-facing behavior.
- [ ] Relevant edge cases are identified.
- [ ] The specification is consistent with the project constitution.

## TDD

- [ ] Tests were written before implementation where applicable.
- [ ] RED → GREEN → REFACTOR cycle was followed.
- [ ] Domain rules have unit tests.
- [ ] Application use cases have isolated tests.
- [ ] Infrastructure adapters have appropriate integration tests.
- [ ] Critical user journeys have appropriate end-to-end coverage where applicable.

## Code Quality

- [ ] Naming conventions are respected.
- [ ] Error handling follows project standards.
- [ ] Logging follows project standards.
- [ ] External interface conventions are respected.
- [ ] No unnecessary duplication exists.
- [ ] Complexity is acceptable.
- [ ] Functions and modules remain focused.
- [ ] Dependencies remain explicit and justified.

## Validation

- [ ] Unit tests pass.
- [ ] Integration tests pass where applicable.
- [ ] End-to-end tests pass where applicable.
- [ ] Type checking or equivalent static validation passes where applicable.
- [ ] Linting or equivalent static analysis passes where applicable.
- [ ] Formatting checks pass where applicable.
- [ ] Architecture guard passes (see `architecture-guard` extension).
- [ ] `/speckit.analyze` reports no unresolved critical issues.
- [ ] `/speckit.checklist` quality checklist passes.

## Final Review

- [ ] Implementation matches the specification.
- [ ] Implementation follows the approved plan.
- [ ] No scope creep was introduced.
- [ ] Documentation is updated where necessary.
- [ ] The feature is ready to merge.
EOF

success ".specify/memory/quality_gate.md"

# ------------------------------------------------------------
# Final state
# ------------------------------------------------------------

echo ""
echo "======================================================"
echo "⚠️  MANUAL ACTION REQUIRED (agent command)"
echo "======================================================"
echo ""
echo "In your AI agent, run now:"
echo ""
echo "   /speckit.architecture-guard.init"
echo ""
echo "This finalizes/refines the architecture constitution on the"
echo "architecture-guard side. (A bash script cannot run the agent's"
echo "slash commands.)"
echo ""

echo "Presets:"
specify preset list || true

echo ""
echo "Extensions:"
specify extension list || true

echo ""
echo "📚 Governance files:"
echo "  .specify/memory/constitution.md"
echo "  .specify/memory/architecture_constitution.md"
echo "  .specify/memory/coding_standards.md"
echo "  .specify/memory/quality_gate.md"

echo ""
echo "👉 Recommended workflow:"
echo ""
echo "  /speckit.architecture-guard.init"
echo "  /speckit.constitution"
echo "  /speckit.specify"
echo "  /speckit.clarify"
echo "  /speckit.plan"
echo "  /speckit.checklist"
echo "  /speckit.tasks"
echo "  /speckit.analyze"
echo "  /speckit.implement"
echo "  /speckit.converge"
echo ""
echo "🎉 Setup completed."
